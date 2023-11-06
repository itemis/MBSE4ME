package com.itemis.mbse4me.dsls.ui.renaming;

import org.eclipse.emf.ecore.EAttribute;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.ui.refactoring.impl.DefaultRenameStrategy;

import com.itemis.mbse4me.dsls.erModel.Component;
import com.itemis.mbse4me.dsls.erModel.ErModelPackage;

@SuppressWarnings("restriction")
public class ErModelRenameStrategy extends DefaultRenameStrategy {

	@Override
	protected EAttribute getNameAttribute(EObject targetElement) {
		if (targetElement instanceof Component) {
			return ErModelPackage.Literals.COMPONENT__ID;
		} else {
			return super.getNameAttribute(targetElement);
		}
	}
}
