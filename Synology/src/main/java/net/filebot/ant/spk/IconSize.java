package net.filebot.ant.spk;

import org.apache.tools.ant.types.EnumeratedAttribute;

public class IconSize extends EnumeratedAttribute {

	public String[] getValues() {
		return new String[] { "72", "256" };
	}

	public String getFileName() {
		switch (value) {
		case "72":
			return "PACKAGE_ICON.PNG";
		default:
			return "PACKAGE_ICON_" + value + ".PNG";
		}
	}

}
