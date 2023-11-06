package com.itemis.mbse4me.dsls.tests.utils

import org.eclipse.emf.ecore.EPackage

class TestUtils {

	public static val c = "'''"

	def static registerEPackage(String packageNamespaceURI, EPackage packageInstance) {
		if (!EPackage.Registry.INSTANCE.containsKey(packageNamespaceURI)) {
			EPackage.Registry.INSTANCE.put(packageNamespaceURI, packageInstance)
		}
	}

}