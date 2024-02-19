package com.itemis.mbse4me.dsls.ui.tests

import com.google.inject.Inject
import com.itemis.mbse4me.dsls.erModel.ErModelFactory
import org.eclipse.emf.ecore.EObject
import org.eclipse.jface.viewers.ILabelProvider
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.ui.IImageHelper
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith

/**
 * Test cases for the {@link com.itemis.mbse4me.dsls.ui.labeling.ErModelLabelProvider} class.
 */
@ExtendWith(InjectionExtension)
@InjectWith(ErModelUiInjectorProvider)
class ErModelLabelProviderTest {

	@Inject ILabelProvider labelProvider
	@Inject IImageHelper imageHelper

	extension ErModelFactory = ErModelFactory.eINSTANCE


	@Test def assembly_image() {
		createAssembly.hasImage("Assembly.png")
	}

	@Test def component_image() {
		createComponent.hasImage("Component.png")
	}

	@Test def product_image() {
		createProduct.hasImage("Product.png")
	}

	private def hasImage(EObject eObject, String image) {
		val actual = labelProvider.getImage(eObject)
		val expected = imageHelper.getImage(image)
		Assertions.assertEquals(expected, actual)
	}

}
