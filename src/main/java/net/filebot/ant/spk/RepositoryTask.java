package net.filebot.ant.spk;

import static java.util.Collections.*;
import static net.filebot.ant.spk.PackageTask.*;
import static net.filebot.ant.spk.util.Digest.*;

import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.StringWriter;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Pattern;

import javax.json.Json;
import javax.json.JsonArrayBuilder;
import javax.json.JsonObject;
import javax.json.JsonObjectBuilder;
import javax.json.JsonReader;
import javax.json.JsonString;
import javax.json.JsonValue;
import javax.json.JsonWriter;
import javax.json.stream.JsonGenerator;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.Task;
import org.apache.tools.ant.taskdefs.Get;
import org.apache.tools.ant.types.FileSet;
import org.apache.tools.ant.types.Resource;
import org.apache.tools.ant.types.ResourceCollection;
import org.apache.tools.ant.types.TarFileSet;
import org.apache.tools.ant.types.resources.URLResource;
import org.apache.tools.ant.types.resources.Union;
import org.apache.tools.ant.util.FileUtils;

public class RepositoryTask extends Task {

	File index;

	Union keyrings = new Union();
	List<SPK> spks = new ArrayList<SPK>();
	List<URLResource> sources = new ArrayList<URLResource>();

	public void setFile(File file) {
		this.index = file;
	}

	public void addConfiguredKeyRing(FileSet key) {
		keyrings.add(key);
	}

	public void addConfiguredKeyRing(ResourceCollection key) {
		keyrings.add(key);
	}

	public void addConfiguredSource(URLResource source) {
		sources.add(source);
	}

	public void addConfiguredSPK(SPK spk) {
		if (spk.file == null) {
			throw new BuildException("Required attributes: [file] or [url, file]");
		}

		spks.add(spk);
	}

	public static final String KEYRINGS = "keyrings";
	public static final String PACKAGES = "packages";

	@Override
	public void execute() throws BuildException {
		if (index == null) {
			throw new BuildException("Required attributes: file");
		}

		try {
			// generate package source for spk files
			JsonArrayBuilder jsonPackages = Json.createArrayBuilder();
			getPackages().forEach((p) -> {
				JsonObjectBuilder jsonPackage = Json.createObjectBuilder();
				p.forEach((k, v) -> {
					if (v instanceof Boolean) {
						jsonPackage.add(k, (Boolean) v); // Boolean
					} else if (v instanceof Number) {
						jsonPackage.add(k, ((Number) v).longValue()); // Integer
					} else if (v instanceof String[]) {
						JsonArrayBuilder array = Json.createArrayBuilder(); // String Array
						for (String s : (String[]) v) {
							array.add(s);
						}
						jsonPackage.add(k, array);
					} else if (v == null) {
						jsonPackage.addNull(k); // null
					} else {
						jsonPackage.add(k, v.toString()); // String
					}
				});
				jsonPackages.add(jsonPackage);
			});

			// collect public keys and omit duplicates
			Set<String> keyrings = new LinkedHashSet<String>();
			keyrings.addAll(getKeyRings());

			// include keyrings and packages from external package sources
			for (URLResource source : sources) {
				try (JsonReader reader = Json.createReader(source.getInputStream())) {
					JsonObject json = reader.readObject();
					for (JsonValue k : json.getJsonArray(KEYRINGS)) {
						log("Import keyring: " + source);
						keyrings.add(normalizeKey(((JsonString) k).getString()));
					}
					for (JsonValue p : json.getJsonArray(PACKAGES)) {
						log("Import package: " + (((JsonString) ((JsonObject) p).get(PACKAGE))).getString());
						jsonPackages.add(p);
					}
				} catch (Exception e) {
					throw new BuildException(e);
				}
			}

			JsonArrayBuilder jsonKeyrings = Json.createArrayBuilder();
			keyrings.forEach(jsonKeyrings::add);

			JsonObjectBuilder jsonRoot = Json.createObjectBuilder();
			jsonRoot.add(KEYRINGS, jsonKeyrings);
			jsonRoot.add(PACKAGES, jsonPackages);

			log("Write Package Source: " + index);
			StringWriter json = new StringWriter();
			try (JsonWriter writer = Json.createWriterFactory(singletonMap(JsonGenerator.PRETTY_PRINTING, true)).createWriter(json)) {
				writer.writeObject(jsonRoot.build());
			}
			Files.write(index.toPath(), json.toString().trim().getBytes(StandardCharsets.UTF_8));
		} catch (IOException e) {
			throw new BuildException(e);
		}
	}

	public List<String> getKeyRings() throws IOException {
		List<String> keys = new ArrayList<String>();
		for (Resource resource : keyrings) {
			log("Include keyring: " + resource.getName());
			String key = FileUtils.readFully(new InputStreamReader(resource.getInputStream(), StandardCharsets.US_ASCII));
			if (key != null) {
				keys.add(normalizeKey(key)); // make sure to normalize line endings
			}
		}
		return keys;
	}

	private static final Pattern NEWLINE = Pattern.compile("\\R");
	private static final String UNIX_NEWLINE = "\n";

	private String normalizeKey(String key) {
		return NEWLINE.matcher(key).replaceAll(UNIX_NEWLINE).trim();
	}

	public static final String PACKAGE = "package";
	public static final String VERSION = "version";

	public static final String LINK = "link";
	public static final String MD5 = "md5";
	public static final String SHA256 = "sha256"; // NOT SUPPORTED BY SYNOLOGY DSM
	public static final String SIZE = "size";
	public static final String THUMBNAIL = "thumbnail";
	public static final String SNAPSHOT = "snapshot";

	public List<Map<String, Object>> getPackages() throws IOException {
		List<Map<String, Object>> packages = new ArrayList<Map<String, Object>>();

		for (SPK spk : spks) {
			log("Include SPK: " + spk.file.getName());

			// make sure file is cached locally
			if (spk.url != null) {
				log("Using " + spk.url);
				if (!spk.file.exists()) {
					spk.file.getParentFile().mkdirs();
				}
				if (spk.url == null) {
					spk.url = spk.url;
				}
				Get get = new Get();
				get.bindToOwner(this);
				get.setQuiet(true);
				get.setUseTimestamp(true);
				get.setSrc(spk.url);
				get.setDest(spk.file);
				get.execute();
			} else {
				log("Using " + spk.file);
			}

			// import SPK INFO
			Map<String, Object> info = new LinkedHashMap<String, Object>();

			TarFileSet tar = new TarFileSet();
			tar.setProject(getProject());
			tar.setSrc(spk.file);
			tar.setIncludes(INFO);
			for (Resource resource : tar) {
				if (INFO.equals(resource.getName())) {
					String text = FileUtils.readFully(new InputStreamReader(resource.getInputStream(), StandardCharsets.UTF_8));
					for (String line : NEWLINE.split(text)) {
						String[] s = line.split("=", 2);
						if (s.length == 2) {
							if (s[1].startsWith("\"") && s[1].endsWith("\"")) {
								s[1] = s[1].substring(1, s[1].length() - 1);
							}
							importSpkInfo(info, s[0], s[1]);
						}
					}
				}
			}
			log(String.format("Imported %d fields from SPK: %s", info.size(), info.keySet()));

			// add thumbnails and snapshots
			if (spk.thumbnail.size() > 0) {
				info.put(THUMBNAIL, spk.thumbnail.toArray(new String[0]));
			}
			if (spk.snapshot.size() > 0) {
				info.put(SNAPSHOT, spk.snapshot.toArray(new String[0]));
			}

			// add user-defined fields
			info.putAll(spk.infoList);

			// automatically generate file size and checksum fields
			if (!info.containsKey(LINK)) {
				info.put(LINK, spk.url);
			}

			info.put(MD5, md5(spk.file));
			info.put(SHA256, sha256(spk.file));
			info.put(SIZE, spk.file.length());

			packages.add(info);
		}

		return packages;
	}

	public void importSpkInfo(Map<String, Object> info, String key, String value) {
		switch (key) {
		case "package":
		case "version":
		case "maintainer":
		case "maintainer_url":
		case "distributor":
		case "distributor_url":
			info.put(key, value);
			break;
		case "displayname":
			info.put("dname", value);
			break;
		case "description":
			info.put("desc", value);
			break;
		case "install_dep_packages":
			info.put("deppkgs", value);
			break;
		case "install_dep_services":
			info.put("depsers", value);
			break;
		case "startable":
			info.put("start", Project.toBoolean(value));
			info.put("qstart", Project.toBoolean(value));
			break;
		case "silent_install":
			info.put("qinst", Project.toBoolean(value));
			break;
		case "silent_upgrade":
			info.put("qupgrade", Project.toBoolean(value));
			break;
		case "package_link_url":
			info.put(LINK, value);
			break;
		case "package_thumbnail_url":
			info.put(THUMBNAIL, URL_SEPARATOR.split(value));
			break;
		case "package_snapshot_url":
			info.put(SNAPSHOT, URL_SEPARATOR.split(value));
			break;
		}
	}

	private static final Pattern URL_SEPARATOR = Pattern.compile("[, ]+");

}
