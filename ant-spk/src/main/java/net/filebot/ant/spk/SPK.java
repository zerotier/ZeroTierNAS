package net.filebot.ant.spk;

import java.io.File;
import java.net.URL;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.tools.ant.types.resources.URLResource;

public class SPK {

	File file;
	URL url;

	public void setFile(File file) {
		this.file = file;
	}

	public void setUrl(URL url) {
		this.url = url;
	}

	Map<String, Object> infoList = new LinkedHashMap<String, Object>();

	public void addConfiguredInfo(Info info) {
		infoList.put(info.name, info.value);
	}

	List<String> thumbnail = new ArrayList<String>();
	List<String> snapshot = new ArrayList<String>();

	public void addConfiguredThumbnail(URLResource link) {
		thumbnail.add(link.getURL().toString());
	}

	public void addConfiguredSnapshot(URLResource link) {
		snapshot.add(link.getURL().toString());
	}

}