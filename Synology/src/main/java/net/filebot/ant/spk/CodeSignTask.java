package net.filebot.ant.spk;

import static net.filebot.ant.spk.PackageTask.*;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.ByteBuffer;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.security.SignatureException;
import java.util.ArrayList;
import java.util.List;
import java.util.TreeMap;
import java.util.UUID;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.mime.MultipartEntityBuilder;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;
import org.apache.tools.ant.taskdefs.Tar.TarFileSet;
import org.apache.tools.ant.types.Resource;
import org.bouncycastle.openpgp.PGPException;

import net.filebot.ant.spk.openpgp.OpenPGPSignature;

public class CodeSignTask extends Task {

	String keyId;
	File secring;

	char[] password = new char[0]; // empty password by default
	String timestamp = "http://timestamp.synology.com/timestamp.php"; // default Synology signature server

	public void setKeyId(String keyId) {
		this.keyId = keyId;
	}

	public void setSecring(File secring) {
		this.secring = secring;
	}

	public void setPassword(String password) {
		this.password = password.toCharArray();
	}

	public void setTimestamp(String timestamp) {
		this.timestamp = timestamp;
	}

	File token = new File(SYNO_SIGNATURE);
	List<TarFileSet> cats = new ArrayList<TarFileSet>();

	public void setToken(File token) {
		this.token = token;
	}

	public void addConfiguredCat(TarFileSet files) {
		cats.add(files);
	}

	@Override
	public void execute() {
		byte[] asciiArmoredSignatureFile;

		// compute PGP signature
		log("GPG: sign with key " + keyId);

		try {
			OpenPGPSignature signature = OpenPGPSignature.createSignatureGenerator(keyId, secring, password);

			// cat files in case-sensitive alphabetical tar entry path order
			byte[] buffer = new byte[64 * 1024];
			int length = 0;
			for (Resource r : getTarOrderCatResources()) {
				try (InputStream in = r.getInputStream()) {
					while ((length = in.read(buffer, 0, buffer.length)) != -1) {
						signature.update(buffer, 0, length);
					}
				}
			}

			asciiArmoredSignatureFile = signature.generate();
		} catch (IOException | SignatureException | PGPException e) {
			throw new BuildException("Failed to compute PGP signature: " + e);
		}

		// sign the signature
		log("SYNO: Submit signature to " + timestamp);

		try (CloseableHttpClient httpClient = HttpClientBuilder.create().build()) {
			HttpPost httpPost = new HttpPost(timestamp);

			// timestamp.synology.com requires the full Content-Disposition head to be sent, including the filename section, e.g. Content-Disposition: form-data; name="file"; filename="ALLCAT.dat.asc"
			HttpEntity pastData = MultipartEntityBuilder.create().addBinaryBody("file", asciiArmoredSignatureFile, ContentType.DEFAULT_BINARY, UUID.randomUUID().toString()).build();
			httpPost.setEntity(pastData);

			HttpResponse response = httpClient.execute(httpPost);
			Files.copy(response.getEntity().getContent(), token.toPath(), StandardCopyOption.REPLACE_EXISTING);
			dumpSignature(Files.readAllBytes(token.toPath()));
		} catch (IOException e) {
			throw new BuildException("Failed to retrieve signature: " + e.getMessage());
		}
	}

	protected void dumpSignature(byte[] bytes) {
		log(StandardCharsets.UTF_8.decode(ByteBuffer.wrap(bytes)).toString());
	}

	protected Resource[] getTarOrderCatResources() {
		TreeMap<String, Resource> sortedCats = new TreeMap<String, Resource>();
		cats.forEach(fs -> {
			fs.forEach(r -> {
				sortedCats.put(getTarEntryName(r.getName(), fs), r);
			});
		});
		return sortedCats.values().toArray(new Resource[0]);
	}

	protected String getTarEntryName(String vPath, TarFileSet tarFileSet) {
		if (vPath.isEmpty() || vPath.startsWith("/")) {
			throw new IllegalArgumentException("Illegal tar entry: " + vPath);
		}

		String fullpath = tarFileSet.getFullpath(getProject());
		if (fullpath.length() > 0) {
			return fullpath;
		}

		String prefix = tarFileSet.getPrefix(getProject());
		if (prefix.length() > 0) {
			if (prefix.endsWith("/")) {
				return prefix + vPath;
			} else {
				return prefix + '/' + vPath;
			}
		}

		return vPath;
	}
}
