package com.itemis.mbse4me.dsls.tests

import com.google.inject.Inject
import com.itemis.mbse4me.dsls.erModel.ModelContainer
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith

@ExtendWith(InjectionExtension)
@InjectWith(ErModelInjectorProvider)
class ErModelParsingTest {

	@Inject extension ParseHelper<ModelContainer>
	@Inject extension ValidationTestHelper

	@Test def test001() {
		'''
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs "1.11€"
			}
		'''.hasNoErrors
	}

	@Test def test002() {
		'''
			Assemblies {
				Assembly "ASSEMBLY 1" ID "11111111 1" uses {
				}
			}
		'''.hasNoErrors
	}

	@Test def test004() {
		'''
			Products {
				Product "Product 1" ID "22222222 1" uses {
				}
			}
		'''.hasNoErrors
	}

	private def hasNoErrors(CharSequence text) {
		text.parse.assertNoErrors
	}
}
