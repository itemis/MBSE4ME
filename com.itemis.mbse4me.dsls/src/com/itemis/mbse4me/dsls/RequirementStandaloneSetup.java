/*
 * generated by Xtext 2.32.0
 */
package com.itemis.mbse4me.dsls;


/**
 * Initialization support for running Xtext languages without Equinox extension registry.
 */
public class RequirementStandaloneSetup extends RequirementStandaloneSetupGenerated {

	public static void doSetup() {
		new RequirementStandaloneSetup().createInjectorAndDoEMFRegistration();
	}
}
