package com.itemis.mbse4me.dsls.naming;

import org.eclipse.xtext.naming.DefaultDeclarativeQualifiedNameProvider;
import org.eclipse.xtext.naming.QualifiedName;

import com.itemis.mbse4me.dsls.erModel.Assembly;
import com.itemis.mbse4me.dsls.erModel.Component;

/**
 * Identify the components and the assemblies by its ID instead of its name.
 */
public class ErModelDeclarativeQualifiedNameProvider extends DefaultDeclarativeQualifiedNameProvider {

	public QualifiedName qualifiedName(Component component) {
		String plmId = component.getId();
		QualifiedName qualifiedNameFromConverter = getConverter().toQualifiedName(plmId);
		return qualifiedNameFromConverter;
	}

	public QualifiedName qualifiedName(Assembly assembly) {
		String id = assembly.getId();
		QualifiedName qualifiedNameFromConverter = getConverter().toQualifiedName(id);
		return qualifiedNameFromConverter;
	}

}