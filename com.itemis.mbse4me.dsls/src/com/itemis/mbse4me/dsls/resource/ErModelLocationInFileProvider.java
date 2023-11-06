package com.itemis.mbse4me.dsls.resource;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EStructuralFeature;
import org.eclipse.xtext.resource.DefaultLocationInFileProvider;

import com.itemis.mbse4me.dsls.erModel.Assembly;
import com.itemis.mbse4me.dsls.erModel.Component;

public class ErModelLocationInFileProvider extends DefaultLocationInFileProvider {

	@Override
	protected EStructuralFeature getIdentifierFeature(EObject obj) {
		if (obj instanceof Component || obj instanceof Assembly) {
			final EClass eClass = obj.eClass();
			return eClass.getEStructuralFeature("id");
		}

		return super.getIdentifierFeature(obj);
	}
}
