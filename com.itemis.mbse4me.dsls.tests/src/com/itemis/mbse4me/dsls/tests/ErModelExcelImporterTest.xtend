package com.itemis.mbse4me.dsls.tests

import com.itemis.mbse4me.dsls.importer.ExcelImporter
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith

import static com.itemis.mbse4me.dsls.tests.utils.TestUtils.c
import static org.junit.jupiter.api.Assertions.assertEquals

/**
 * Test cases for the {@link com.itemis.mbse4me.dsls.importer.ExcelImporter} class.
 */
@ExtendWith(InjectionExtension)
@InjectWith(ErModelInjectorProvider)
class ErModelExcelImporterTest {

	@Test def test001() {
		#["resources\\Requirements_001.xlsx", "resources\\CAD_Data_001.xlsx", "resources\\Price_Data_001.xlsx"].assertImportedTo(#[
			'''
			Number: "1.1"
			Text:«c»
				Requirement 1
			«c»
			''',
			'''
			Number: "1.2"
			Text:«c»
				Requirement 2
			«c»
			''',
			'''
			Number: "1.2a"
			Text:«c»
				Requirement 2a
			«c»
			'''],'''
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs "1.11€",
				Component "COMPONENT - 2" ID "00000000 2" costs "2.22€",
				Component "COMPONENT - 3" ID "00000000 3" costs "3.33€",
				Component "COMPONENT - 4" ID "00000000 4" costs "4.44€"
			}
			''',
			'''
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
			''',
			'''
			Products {
				Product "Product 1" ID "22222222 1" uses {
					1 pieces of "11111111 1", 1 pieces of "11111111 2"
				},
				Product "Product 2" ID "22222222 2" uses {
					1 pieces of "11111111 2", 1 pieces of "11111111 3"
				}
			}
		''')
	}

	private def void assertImportedTo(String[] excelFileNames, String[] expectedRequestSpecifications, String expectedKomponenten, String expectedBaugruppen, String expectedRaupen) {
		val excelImporter = new ExcelImporter

		excelImporter.importDataFrom(excelFileNames)

		val actualRequestSpecifications = excelImporter.requirement

		for(var i=0; i < expectedRequestSpecifications.size; i++) {
			val actualRequestSpecification = actualRequestSpecifications.get(i)
			val expectedRequestSpecification = expectedRequestSpecifications.get(i)
			assertEquals(expectedRequestSpecification, actualRequestSpecification)
		}

		val actualKomponenten = excelImporter.getComponentsModelContainer
		val actualBaugruppen = excelImporter.getAssembliesModelContainer
		val actualRaupen = excelImporter.getProductsModelContainer

		assertEquals(expectedKomponenten, actualKomponenten)
		assertEquals(expectedBaugruppen, actualBaugruppen)
		assertEquals(expectedRaupen, actualRaupen)
	}
}