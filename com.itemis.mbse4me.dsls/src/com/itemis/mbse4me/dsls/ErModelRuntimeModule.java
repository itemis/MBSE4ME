/*
 * generated by Xtext 2.32.0
 */
package com.itemis.mbse4me.dsls;

import org.eclipse.xtext.naming.DefaultDeclarativeQualifiedNameProvider;
import org.eclipse.xtext.resource.ILocationInFileProvider;

import com.itemis.mbse4me.dsls.naming.ErModelDeclarativeQualifiedNameProvider;
import com.itemis.mbse4me.dsls.resource.ErModelLocationInFileProvider;

/**
 * Use this class to register components to be used at runtime / without the Equinox extension registry.
 */
public class ErModelRuntimeModule extends AbstractErModelRuntimeModule {

	public Class<? extends DefaultDeclarativeQualifiedNameProvider> bindDeclarativeQualifiedNameProvider() {
		return ErModelDeclarativeQualifiedNameProvider.class;
	}

	@Override
	public Class<? extends ILocationInFileProvider> bindILocationInFileProvider() {
		return ErModelLocationInFileProvider.class;
	}

}