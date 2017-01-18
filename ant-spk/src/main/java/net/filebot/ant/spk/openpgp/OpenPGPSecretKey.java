package net.filebot.ant.spk.openpgp;

import java.io.IOException;
import java.io.InputStream;

import org.bouncycastle.openpgp.PGPObjectFactory;
import org.bouncycastle.openpgp.PGPSecretKey;
import org.bouncycastle.openpgp.PGPSecretKeyRing;
import org.bouncycastle.openpgp.PGPUtil;
import org.bouncycastle.openpgp.bc.BcPGPObjectFactory;

public class OpenPGPSecretKey {

	private static final long MASK = 0xFFFFFFFFL;

	private PGPSecretKey secretKey;
	private char[] password;

	public OpenPGPSecretKey(String keyId, InputStream secretKeyRing, char[] password) throws IOException {
		PGPObjectFactory pgpObjectFactory = new BcPGPObjectFactory(PGPUtil.getDecoderStream(secretKeyRing));

		for (Object it = pgpObjectFactory.nextObject(); it != null; it = pgpObjectFactory.nextObject()) {
			PGPSecretKeyRing pgpSecretKeyRing = (PGPSecretKeyRing) it;
			PGPSecretKey pgpSecretKey = pgpSecretKeyRing.getSecretKey();

			if (keyId == null || keyId.isEmpty() || Long.valueOf(keyId, 16) == (pgpSecretKey.getKeyID() & MASK)) {
				this.secretKey = pgpSecretKey;
				break;
			}
		}

		// sanity check
		if (secretKey == null) {
			throw new IllegalArgumentException("Secret key " + keyId + " not found");
		}

		this.password = password;
	}

	public PGPSecretKey getSecretKey() {
		return secretKey;
	}

	public char[] getPassword() {
		return password;
	}

}
