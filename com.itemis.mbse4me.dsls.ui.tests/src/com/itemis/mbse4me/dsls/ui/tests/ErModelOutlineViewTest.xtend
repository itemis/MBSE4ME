package com.itemis.mbse4me.dsls.ui.tests

import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.ui.testing.AbstractOutlineTest
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith

/**
 * Test cases for the {@link com.itemis.mbse4me.dsls.ui.outline.ErModelOutlineTreeProvider} class.
 */
@ExtendWith(InjectionExtension)
@InjectWith(ErModelUiInjectorProvider)
class ErModelOutlineViewTest extends AbstractOutlineTest {

	@BeforeEach
	override void setUp() {
		super.setUp
	}

	@Test def test001() {
		'''
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs "1.11€"
			}
		'''.assertAllLabels('''
			test
				COMPONENT - 1
		''')
	}

	@Test def test002() {
		'''
			Assemblies {
				Assembly "ASSEMBLY 1" ID "11111111 1" uses {
					1 pieces of "00000000 1"
				}
			}
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs "1.11€"
			}
		'''.assertAllLabels('''
			test
				ASSEMBLY 1 - 1 Component
					1 of 00000000 1 - COMPONENT - 1
				COMPONENT - 1
		''')
	}

	@Test def test003() {
		'''
			Assemblies {
				Assembly "ASSEMBLY 1" ID "11111111 1" uses {
					1 pieces of "00000000 1"
				},
				Assembly "ASSEMBLY 2" ID "11111111 2" uses {
					2 pieces of "00000000 1"
				},
			}
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs "1.11€"
			}
		'''.assertAllLabels('''
			test
				ASSEMBLY 1 - 1 Component
					1 of 00000000 1 - COMPONENT - 1
				ASSEMBLY 2 - 1 Component
					2 of 00000000 1 - COMPONENT - 1
				COMPONENT - 1
		''')
	}

	// use tabs instead of spaces for indentation
	override protected indent(StringBuffer buffer, int tabs) {
		for (var i = 0; i < tabs/2; i++) {
			buffer.append("\t")
		}
	}

}