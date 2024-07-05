package com.itemis.mbse4me.dsls.ui.tests

import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.ui.testing.AbstractOutlineTest
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith

/**
 * Test cases for the {@link com.itemis.mbse4me.dsls.ui.outline.ErModelOutlineTreeProvider} class.
 */
@ExtendWith(InjectionExtension)
@InjectWith(ErModelUiInjectorProvider)
class ErModelOutlineViewTest extends AbstractOutlineTest {

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

	@Test def test004() {
		'''
			Products {
				Product "Product 1" ID "22222222 1" uses {
					1 piece of "11111111 1", 1 piece of "11111111 2"
				},
				Product "Product 2" ID "22222222 2" uses {
					1 piece of "11111111 2", 1 piece of "11111111 3"
				}
			}
			Assemblies {
				Assembly "ASSEMBLY 1" ID "11111111 1" uses {
					1 piece of "00000000 1", 2 pieces of "00000000 2"
				},
				Assembly "ASSEMBLY 2" ID "11111111 2" uses {
					3 pieces of "00000000 2", 4 pieces of "00000000 3"
				},
				Assembly "ASSEMBLY 3" ID "11111111 3" uses {
					5 pieces of "00000000 3", 6 pieces of "00000000 4"
				}
			}
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs "1.11€",
				Component "COMPONENT - 2" ID "00000000 2" costs "2.22€",
				Component "COMPONENT - 3" ID "00000000 3" costs "3.33€",
				Component "COMPONENT - 4" ID "00000000 4" costs "4.44€"
			}
		'''.assertAllLabels('''
			test
				Product 1 - 2 Assemblies
					1 of 11111111 1 - ASSEMBLY 1
						1 of 00000000 1 - COMPONENT - 1
						2 of 00000000 2 - COMPONENT - 2
					1 of 11111111 2 - ASSEMBLY 2
						3 of 00000000 2 - COMPONENT - 2
						4 of 00000000 3 - COMPONENT - 3
				Product 2 - 2 Assemblies
					1 of 11111111 2 - ASSEMBLY 2
						3 of 00000000 2 - COMPONENT - 2
						4 of 00000000 3 - COMPONENT - 3
					1 of 11111111 3 - ASSEMBLY 3
						5 of 00000000 3 - COMPONENT - 3
						6 of 00000000 4 - COMPONENT - 4
				ASSEMBLY 1 - 2 Components
					1 of 00000000 1 - COMPONENT - 1
					2 of 00000000 2 - COMPONENT - 2
				ASSEMBLY 2 - 2 Components
					3 of 00000000 2 - COMPONENT - 2
					4 of 00000000 3 - COMPONENT - 3
				ASSEMBLY 3 - 2 Components
					5 of 00000000 3 - COMPONENT - 3
					6 of 00000000 4 - COMPONENT - 4
				COMPONENT - 1
				COMPONENT - 2
				COMPONENT - 3
				COMPONENT - 4
		''')
	}

	// use tabs instead of spaces for indentation
	override protected indent(StringBuffer buffer, int tabs) {
		for (var i = 0; i < tabs/2; i++) {
			buffer.append("\t")
		}
	}

}