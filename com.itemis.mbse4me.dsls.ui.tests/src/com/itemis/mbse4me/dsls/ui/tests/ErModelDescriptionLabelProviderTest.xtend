package com.itemis.mbse4me.dsls.ui.tests

import com.google.inject.Inject
import com.itemis.mbse4me.dsls.erModel.ErModelFactory
import org.eclipse.jface.viewers.ILabelProvider
import org.eclipse.xtext.resource.IEObjectDescription
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.ui.IImageHelper
import org.eclipse.xtext.ui.resource.ResourceServiceDescriptionLabelProvider
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith

import static extension org.eclipse.xtext.resource.EObjectDescription.create

/**
 * Test cases for the {@link com.itemis.mbse4me.dsls.ui.labeling.ErModelDescriptionLabelProvider} class.
 */
@ExtendWith(InjectionExtension)
@InjectWith(ErModelUiInjectorProvider)
class ErModelDescriptionLabelProviderTest {

	@ResourceServiceDescriptionLabelProvider
	@Inject ILabelProvider labelProvider

	@Inject IImageHelper imageHelper

	extension ErModelFactory = ErModelFactory.eINSTANCE


	@Test def assembly_image() {
		"Test Assembly".create(createAssembly).hasImage("Assembly.png")
	}

	@Test def component_image() {
		"Test Component".create(createComponent).hasImage("Component.png")
	}

	@Test def product_image() {
		"Test Product".create(createProduct).hasImage("Product.png")
	}

	private def hasImage(IEObjectDescription eObjectDescription, String image) {
		val actual = labelProvider.getImage(eObjectDescription)
		val expected = imageHelper.getImage(image)
		Assertions.assertEquals(expected, actual)
	}

}
