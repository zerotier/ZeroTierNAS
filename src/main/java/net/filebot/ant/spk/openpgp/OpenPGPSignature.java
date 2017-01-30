package net.filebot.ant.spk.openpgp;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.security.Security;
import java.security.SignatureException;

import org.bouncycastle.bcpg.ArmoredOutputStream;
import org.bouncycastle.bcpg.BCPGOutputStream;
import org.bouncycastle.bcpg.HashAlgorithmTags;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.openpgp.PGPException;
import org.bouncycastle.openpgp.PGPPrivateKey;
import org.bouncycastle.openpgp.PGPSignature;
import org.bouncycastle.openpgp.PGPSignatureGenerator;
import org.bouncycastle.openpgp.operator.PBESecretKeyDecryptor;
import org.bouncycastle.openpgp.operator.PGPDigestCalculatorProvider;
import org.bouncycastle.openpgp.operator.jcajce.JcaPGPContentSignerBuilder;
import org.bouncycastle.openpgp.operator.jcajce.JcaPGPDigestCalculatorProviderBuilder;
import org.bouncycastle.openpgp.operator.jcajce.JcePBESecretKeyDecryptorBuilder;

public class OpenPGPSignature {

	static {
		Security.addProvider(new BouncyCastleProvider());
	}

	private PGPSignatureGenerator signature;

	public OpenPGPSignature(OpenPGPSecretKey key) throws PGPException {
		PGPDigestCalculatorProvider pgpDigestCalculator = new JcaPGPDigestCalculatorProviderBuilder().setProvider(BouncyCastleProvider.PROVIDER_NAME).build();
		PBESecretKeyDecryptor pbeSecretKeyDecryptor = new JcePBESecretKeyDecryptorBuilder(pgpDigestCalculator).setProvider(BouncyCastleProvider.PROVIDER_NAME).build(key.getPassword());
		JcaPGPContentSignerBuilder pgpContentSigner = new JcaPGPContentSignerBuilder(key.getSecretKey().getPublicKey().getAlgorithm(), HashAlgorithmTags.SHA1).setProvider(BouncyCastleProvider.PROVIDER_NAME).setDigestProvider(BouncyCastleProvider.PROVIDER_NAME);

		signature = new PGPSignatureGenerator(pgpContentSigner);

		PGPPrivateKey privateKey = key.getSecretKey().extractPrivateKey(pbeSecretKeyDecryptor);
		signature.init(PGPSignature.BINARY_DOCUMENT, privateKey);
	}

	public void update(byte[] buffer, int offset, int length) throws SignatureException {
		signature.update(buffer, offset, length);
	}

	public byte[] generate() throws IOException, SignatureException, PGPException {
		ByteArrayOutputStream buffer = new ByteArrayOutputStream(1024);

		// make sure to call close() on these streams, because they will want to write some extra data at the end of the file
		try (BCPGOutputStream out = new BCPGOutputStream(new ArmoredOutputStream(buffer))) {
			signature.generate().encode(out);
		}

		return buffer.toByteArray();
	}

	public static OpenPGPSignature createSignatureGenerator(String keyId, File secring, char[] password) throws FileNotFoundException, IOException, PGPException {
		try (InputStream secretKeyRing = new FileInputStream(secring)) {
			OpenPGPSecretKey key = new OpenPGPSecretKey(keyId, secretKeyRing, password);
			OpenPGPSignature signature = new OpenPGPSignature(key);
			return signature;
		}
	}

}
