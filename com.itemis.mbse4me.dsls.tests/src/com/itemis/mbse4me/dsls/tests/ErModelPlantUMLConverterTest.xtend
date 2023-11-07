package com.itemis.mbse4me.dsls.tests

import com.google.inject.Inject
import com.itemis.mbse4me.dsls.erModel.ModelContainer
import com.itemis.mbse4me.dsls.plantuml.ErModelPlantUMLConverter
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
class ErModelPlantUMLConverterTest {

	@Inject extension ParseHelper<ModelContainer>
	@Inject extension ErModelPlantUMLConverter

	@Test def test001() {
		'''
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs "1.11€"
			}
		'''.assertConvertedTo('''
			class "Component 00000000 1" {
				COMPONENT - 1
				1.11€
			}
		''')
	}

	@Test def test002() {
		'''
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs "1.11€",
				Component "COMPONENT - 2" ID "00000000 2" costs "2.22€",
				Component "COMPONENT - 3" ID "00000000 3" costs "3.33€",
				Component "COMPONENT - 4" ID "00000000 4" costs "4.44€"
			}
		'''.assertConvertedTo('''
			class "Component 00000000 1" {
				COMPONENT - 1
				1.11€
			}
			class "Component 00000000 2" {
				COMPONENT - 2
				2.22€
			}
			class "Component 00000000 3" {
				COMPONENT - 3
				3.33€
			}
			class "Component 00000000 4" {
				COMPONENT - 4
				4.44€
			}
		''')
	}


	@Test def test003() {
		'''
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs "1.11€",
				Component "COMPONENT - 2" ID "00000000 2" costs "2.22€",
				Component "COMPONENT - 3" ID "00000000 3" costs "3.33€",
				Component "COMPONENT - 4" ID "00000000 4" costs "4.44€"
			}

			Assemblies {
				Assembly "ASSEMBLY 1" ID "11111111 1" uses {
					1 pieces of "00000000 1", 2 pieces of "00000000 2"
				},
				Assembly "ASSEMBLY 2" ID "11111111 2" uses {
					3 pieces of "00000000 2", 4 pieces of "00000000 3"
				},
				Assembly "ASSEMBLY 3" ID "11111111 3" uses {
					5 pieces of "00000000 3", 6 pieces of "00000000 4"
				}
			}
		'''.assertConvertedTo('''
			class "Component 00000000 1" {
				COMPONENT - 1
				1.11€
			}
			class "Component 00000000 2" {
				COMPONENT - 2
				2.22€
			}
			class "Component 00000000 3" {
				COMPONENT - 3
				3.33€
			}
			class "Component 00000000 4" {
				COMPONENT - 4
				4.44€
			}
		''')
	}

	@Test def test004() {
		'''
			Products {
				Product "Product 1" ID "22222222 1" uses {
					2 pieces of "11111111 1"
				}
			}

			Assemblies {
				Assembly "ASSEMBLY 1" ID "11111111 1" uses {
					1 pieces of "00000000 1"
				}
			}

			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs "1.11€"
			}
		'''.assertConvertedTo('''
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

	private def assertConvertedTo(CharSequence input, String expected) {
		val actual = input.parse.eResource.resourceSet.convertToPlantUML.toString
		assertEquals(expected, actual)
	}
}