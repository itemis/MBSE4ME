package com.itemis.mbse4me.dsls.tests

import com.google.inject.Inject
import com.google.inject.Provider
import com.itemis.mbse4me.dsls.erModel.ModelContainer
import com.itemis.mbse4me.dsls.plantuml.ErModelPlantUMLConverter
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.xtext.resource.XtextResourceSet
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith

import static org.junit.jupiter.api.Assertions.assertEquals

/**
 * Test cases for the {@link com.itemis.mbse4me.dsls.plantuml.ErModelPlantUMLConverter} class.
 */
@ExtendWith(InjectionExtension)
@InjectWith(ErModelInjectorProvider)
class ErModelPlantUMLConverterTest2 {

	@Inject extension ParseHelper<ModelContainer>
	@Inject extension ErModelPlantUMLConverter

	@Inject extension Provider<XtextResourceSet>

	@Test def test001() {
		val resourceSet = get

		'''
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs "1.11€"
			}
		'''.parse(resourceSet)

		'''
			Assemblies {
				Assembly "ASSEMBLY 1" ID "11111111 1" uses {
					1 pieces of "00000000 1"
				}
			}
		'''.parse(resourceSet)

		resourceSet.assertConvertedTo('''
			class "Component 00000000 1" {
				COMPONENT - 1
				1.11€
			}
			abstract "Assembly 11111111 1" {}
			"Component 00000000 1" --> "1 piece" "Assembly 11111111 1"
		''')
	}

	@Test def test002() {
		val resourceSet = get

		'''
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs "1.11€"
			}
		'''.parse(resourceSet)

		'''
			Assemblies {
				Assembly "ASSEMBLY 1" ID "11111111 1" uses {
					1 pieces of "00000000 1"
				}
			}
		'''.parse(resourceSet)

		'''
			Products {
				Product "Product 1" ID "22222222 1" uses {
					2 pieces of "11111111 1"
				}
			}
		'''.parse(resourceSet)

		resourceSet.assertConvertedTo('''
			class "Component 00000000 1" {
				COMPONENT - 1
				1.11€
			}
			abstract "Assembly 11111111 1" {}
			protocol "Product 22222222 1" {
				Product 1
			}
			"Component 00000000 1" --> "1 piece" "Assembly 11111111 1"
			"Assembly 11111111 1" --> "2 pieces" "Product 22222222 1"
		''')
	}

	private def assertConvertedTo(ResourceSet resourceSet, String expected) {
		val actual = resourceSet.convertToPlantUML.toString
		assertEquals(expected, actual)
	}
}