package com.itemis.mbse4me.dsls.dot;

import java.io.File;
import java.io.IOException;
import java.util.Collections;

import org.eclipse.core.runtime.FileLocator;
import org.eclipse.core.runtime.Path;
import org.eclipse.core.runtime.Platform;
import org.eclipse.jface.preference.IPreferenceStore;
import org.eclipse.ui.IStartup;
import org.osgi.framework.FrameworkUtil;

import net.sourceforge.plantuml.eclipse.Activator;
import net.sourceforge.plantuml.eclipse.utils.PlantumlConstants;

public class PreferenceInitializer implements IStartup {

	@Override
	public void earlyStartup() {
		// initialize PlantUML Graphviz preference to point to local dot executable
		IPreferenceStore preferenceStore = Activator.getDefault().getPreferenceStore();

		try {
			// XXX: handle different platforms
			String dotPath = null;
			if (Platform.OS_MACOSX.equals(Platform.getOS())) {
				if (Platform.ARCH_X86_64.equals(Platform.getOSArch())) {
					dotPath = FileLocator
							.toFileURL(FileLocator.find(FrameworkUtil.getBundle(PreferenceInitializer.class),
									new Path("/dot/macosx/x86_64/dot"), Collections.<String, String> emptyMap()))
							.getFile();
				}
			} else if (Platform.OS_LINUX.equals(Platform.getOS())) {
				if (Platform.ARCH_X86_64.equals(Platform.getOSArch())) {
					dotPath = FileLocator
							.toFileURL(FileLocator.find(FrameworkUtil.getBundle(PreferenceInitializer.class),
									new Path("/dot/linux/x86_64/dot"), Collections.<String, String> emptyMap()))
							.getFile();
				}
			} else if (Platform.OS_WIN32.equals(Platform.getOS())) {
				dotPath = FileLocator
						.toFileURL(FileLocator.find(FrameworkUtil.getBundle(PreferenceInitializer.class),
								new Path("/dot/windows/x86_64/dot.exe"), Collections.<String, String> emptyMap()))
						.getFile();
			}

			if (dotPath == null) {
				throw new IllegalStateException("No dot executable path retrieved for platform.");
			}
			if (!new File(dotPath).exists()) {
				throw new IllegalStateException("Path " + dotPath + " does not exist.");
			}

			preferenceStore.setValue(PlantumlConstants.GRAPHVIZ_PATH, dotPath);
		} catch (IOException e) {
			System.err.print(e);
		}
	}
}
