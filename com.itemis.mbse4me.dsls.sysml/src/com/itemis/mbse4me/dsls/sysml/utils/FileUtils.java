package com.itemis.mbse4me.dsls.sysml.utils;

import java.io.InputStream;
import java.net.URL;

import org.eclipse.core.resources.IContainer;
import org.eclipse.core.resources.IFile;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.Path;
import org.eclipse.emf.common.util.URI;

public class FileUtils {
	public static IFile copyFileToContainer(IContainer container, URL url, boolean deleteIfExists) {
		final String urlStr = url.toString();
		final String fileName = urlStr.substring(urlStr.lastIndexOf('/'));
		return copyFileToContainer(container, url, fileName, deleteIfExists);
	}

	public static IFile copyFileToContainer(IContainer container, URL url, String targetFileName,
			boolean deleteIfExists) {
		final IFile file = container.getFile(new Path(URI.decode(targetFileName)));
		if (file.exists()) {
			if (deleteIfExists) {
				try {
					file.delete(true, null);
				} catch (final CoreException e) {
					e.printStackTrace();
				}
				copyUrlFileToIFile(url, file);
			} else {
				// File already exists, nothing to do..
			}
		} else {
			copyUrlFileToIFile(url, file);
		}
		return file;
	}

	private static void copyUrlFileToIFile(URL url, IFile file) {
		try (final InputStream stream = url.openStream()) {
			file.create(stream, true, null);
		} catch (final Exception e) {
			e.printStackTrace();
		}
	}
}
