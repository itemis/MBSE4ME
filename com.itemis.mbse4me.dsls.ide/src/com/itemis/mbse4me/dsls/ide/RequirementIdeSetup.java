/*
 * generated by Xtext 2.32.0
 */
package com.itemis.mbse4me.dsls.ide;

import com.google.inject.Guice;
import com.google.inject.Injector;
import com.itemis.mbse4me.dsls.RequirementRuntimeModule;
import com.itemis.mbse4me.dsls.RequirementStandaloneSetup;
import org.eclipse.xtext.util.Modules2;

/**
 * Initialization support for running Xtext languages as language servers.
 */
public class RequirementIdeSetup extends RequirementStandaloneSetup {

	@Override
	public Injector createInjector() {
		return Guice.createInjector(Modules2.mixin(new RequirementRuntimeModule(), new RequirementIdeModule()));
	}
	
}
