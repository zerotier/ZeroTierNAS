package net.filebot.ant.spk.util;

import java.io.File;
import java.math.BigInteger;
import java.nio.file.Files;
import java.security.MessageDigest;

import org.apache.tools.ant.BuildException;

public class Digest {

	public static String md5(File file) {
		return digest(file, "MD5");
	}

	public static String sha256(File file) {
		return digest(file, "SHA-256");
	}

	public static String digest(File file, String algorithm) {
		try {
			MessageDigest digest = MessageDigest.getInstance(algorithm);
			digest.update(Files.readAllBytes(file.toPath()));

			// as hex string (e.g. 16 bytes = 32 hex digits)
			int digits = 2 * digest.getDigestLength();
			return String.format("%0" + digits + "x", new BigInteger(1, digest.digest()));
		} catch (Exception e) {
			throw new BuildException(e);
		}
	}

}
