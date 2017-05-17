package net.filebot.ant.spk;

import static net.filebot.ant.spk.Info.*;
import static net.filebot.ant.spk.util.Digest.*;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;
import org.apache.tools.ant.taskdefs.Delete;
import org.apache.tools.ant.taskdefs.Tar;
import org.apache.tools.ant.taskdefs.Tar.TarCompressionMethod;
import org.apache.tools.ant.taskdefs.Tar.TarFileSet;
import org.apache.tools.ant.taskdefs.Tar.TarLongFileMode;
import org.apache.tools.ant.types.FileSet;
import org.tukaani.xz.LZMA2Options;
import org.tukaani.xz.XZOutputStream;

public class PackageTask extends Task {

	public static final String INFO = "INFO";
	public static final String SYNO_SIGNATURE = "syno_signature.asc";

	File destDir;

	Map<String, String> infoList = new LinkedHashMap<String, String>();

	List<TarFileSet> packageFiles = new ArrayList<TarFileSet>();
	List<TarFileSet> spkFiles = new ArrayList<TarFileSet>();

	Compression compression = Compression.gzip; // use GZIP by default, XZ requires DSM 6 or higher

	CodeSignTask codesign;

	public void setDestdir(File value) {
		destDir = value;
	}

	public void setCompression(Compression value) {
		compression = value;
	}

	public void setName(String value) {
		infoList.put(NAME, value);
	}

	public void setVersion(String value) {
		infoList.put(VERSION, value);
	}

	public void setArch(String value) {
		infoList.put(ARCH, value);
	}

	public void addConfiguredInfo(Info info) {
		infoList.put(info.name, info.value);
	}

	public void addConfiguredPackage(TarFileSet files) {
		packageFiles.add(files);
	}

	public void addConfiguredScripts(TarFileSet files) {
		files.setPrefix("scripts");
		spkFiles.add(files);
	}

	public void addConfiguredWizard(TarFileSet files) {
		files.setPrefix("WIZARD_UIFILES");
		spkFiles.add(files);
	}

	public void addConfiguredConf(TarFileSet files) {
		files.setPrefix("conf");
		spkFiles.add(files);
	}

	public void addConfiguredIcon(Icon icon) {
		TarFileSet files = new TarFileSet();
		files.setFullpath(icon.size.getFileName());
		files.setFile(icon.file);
		spkFiles.add(files);
	}

	public void setLicense(File file) {
		TarFileSet files = new TarFileSet();
		files.setFullpath("LICENSE");
		files.setFile(file);
		spkFiles.add(files);
	}

	public void addConfiguredCodeSign(CodeSignTask codesign) {
		this.codesign = codesign;
	}

	@Override
	public void execute() throws BuildException {
		if (destDir == null || !infoList.containsKey(NAME) || !infoList.containsKey(VERSION) || !infoList.containsKey(ARCH))
			throw new BuildException("Required attributes: destdir, name, version, arch");

		if (packageFiles.isEmpty() || spkFiles.isEmpty())
			throw new BuildException("Required elements: package, scripts");

		String spkName = String.format("%s-%s-%s", infoList.get(NAME), infoList.get(VERSION), infoList.get(ARCH));

		File spkStaging = new File(destDir, spkName);
		File spkFile = new File(destDir, spkName + ".spk");

		// make sure staging folder exists
		spkStaging.mkdirs();

		// generate info and package files and add to spk fileset
		preparePackage(spkStaging);
		prepareInfo(spkStaging);
		prepareSignature(spkStaging);

		// spk must be an uncompressed tar
		tar(spkFile, null, spkFiles);

		// make sure staging folder is clean for next time
		clean(spkStaging);
	}

	private void prepareSignature(File tempDirectory) {
		if (codesign != null) {
			// select files that need to be signed
			spkFiles.forEach((fs) -> {
				fs.setProject(getProject());
				codesign.addConfiguredCat(fs);
			});

			// create signature file
			File signatureFile = new File(tempDirectory, SYNO_SIGNATURE);
			codesign.setToken(signatureFile);

			codesign.bindToOwner(this);
			codesign.execute();

			// add signature file to output package
			TarFileSet syno_signature = new TarFileSet();
			syno_signature.setFullpath(signatureFile.getName());
			syno_signature.setFile(signatureFile);
			spkFiles.add(syno_signature);
		}
	}

	private void preparePackage(File tempDirectory) {
		File packageFile = new File(tempDirectory, "package.tgz");
		tar(packageFile, compression, packageFiles);

		infoList.put("checksum", md5(packageFile));

		TarFileSet package_tgz = new TarFileSet();
		package_tgz.setFullpath(packageFile.getName());
		package_tgz.setFile(packageFile);
		spkFiles.add(package_tgz);
	}

	private void prepareInfo(File tempDirectory) {
		StringBuilder infoText = new StringBuilder();
		for (Entry<String, String> it : infoList.entrySet()) {
			infoText.append(it.getKey()).append('=').append('"').append(it.getValue()).append('"').append('\n');
		}

		File infoFile = new File(tempDirectory, INFO);
		log("Generating INFO: " + infoFile);
		try {
			Files.write(infoFile.toPath(), infoText.toString().getBytes("UTF-8"));
		} catch (IOException e) {
			throw new BuildException("Failed to write INFO", e);
		}

		TarFileSet info = new TarFileSet();
		info.setFullpath(infoFile.getName());
		info.setFile(infoFile);
		spkFiles.add(info);
	}

	private void tar(File destFile, Compression compression, List<TarFileSet> files) {
		Tar tar = new Tar();
		tar.setProject(getProject());
		tar.setLocation(getLocation());
		tar.setTaskName(getTaskName());
		tar.setEncoding("utf-8");

		TarLongFileMode gnuLongFileMode = new TarLongFileMode();
		gnuLongFileMode.setValue("gnu");
		tar.setLongfile(gnuLongFileMode);

		if (compression == Compression.gzip) {
			TarCompressionMethod gzipCompression = new TarCompressionMethod();
			gzipCompression.setValue("gzip");
			tar.setCompression(gzipCompression);
		}

		tar.setDestFile(destFile);
		for (FileSet fileset : files) {
			if (fileset != null) {
				// make sure the tarfileset element is initialized with all the project information it may need
				fileset.setProject(tar.getProject());
				fileset.setLocation(tar.getLocation());
				tar.add(fileset);
			}
		}

		tar.perform();

		// ant tar does not support xz compression so we need to do it yourself
		if (compression == Compression.xz) {
			try {
				log("xz: " + destFile);
				byte[] uncompressedTar = Files.readAllBytes(destFile.toPath());

				try (XZOutputStream xz = new XZOutputStream(new FileOutputStream(destFile), new LZMA2Options(LZMA2Options.PRESET_DEFAULT))) {
					xz.write(uncompressedTar);
				}
			} catch (Exception e) {
				throw new BuildException("xz: " + e);
			}
		}
	}

	private void clean(File tempDirectory) {
		Delete cleanupTask = new Delete();
		cleanupTask.setProject(getProject());
		cleanupTask.setTaskName(getTaskName());
		cleanupTask.setLocation(getLocation());
		cleanupTask.setDir(tempDirectory);
		cleanupTask.perform();
	}

}
