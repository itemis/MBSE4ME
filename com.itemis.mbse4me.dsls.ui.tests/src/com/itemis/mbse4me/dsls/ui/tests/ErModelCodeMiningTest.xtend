package com.itemis.mbse4me.dsls.ui.tests

import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.ui.testing.AbstractCodeMiningTest
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith

/**
 * Test cases for the {@link com.itemis.mbse4me.dsls.ui.codemining.ErModelCodeMiningProvider} class.
 */
@ExtendWith(InjectionExtension)
@InjectWith(ErModelUiInjectorProvider)
class ErModelCodeMiningTest extends AbstractCodeMiningTest {

	@Test def test001() {
		'''
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs "1.11€"
			}
		'''.testCodeMining('''
			1 component
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs "1.11€"
			}
		''')
	}

	@Test def test002() {
		'''
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs "1.11€",
				Component "COMPONENT - 2" ID "00000000 2" costs "2.22€"
			}
		'''.testCodeMining('''
			2 components
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs "1.11€",
				Component "COMPONENT - 2" ID "00000000 2" costs "2.22€"
			}
		''')
	}

	@Test def test003() {
		'''
			Assemblies {

			}
		'''.testCodeMining('''
			Assemblies {

			}
		''')
	}

	@Test def test004() {
		'''
			Assemblies {
				Assembly "ASSEMBLY 1" ID "11111111 1" uses {
				}
			}
		'''.testCodeMining('''
			1 assembly
			Assemblies {
				Assembly "ASSEMBLY 1" ID "11111111 1" uses {
				}
			}
		''')
	}

	@Test def test005() {
		'''
			Assemblies {
				Assembly "ASSEMBLY 1" ID "11111111 1" uses {
				},
				Assembly "ASSEMBLY 2" ID "11111111 2" uses {
				}
			}
		'''.testCodeMining('''
			2 assemblies
			Assemblies {
				Assembly "ASSEMBLY 1" ID "11111111 1" uses {
				},
				Assembly "ASSEMBLY 2" ID "11111111 2" uses {
				}
			}
		''')
	}

	@Test def test006() {
		'''
			Assemblies {
				Assembly "ASSEMBLY 1" ID "11111111 1" uses {
					1 pieces of "00000000 1", 2 pieces of "00000000 2"
				}
			}
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs "1.11€",
				Component "COMPONENT - 2" ID "00000000 2" costs "2.22€"
			}
		'''.testCodeMining('''
			1 assembly | 2 components
			Assemblies {
				Assembly "ASSEMBLY 1" ID "11111111 1" uses {
					1 pieces of "00000000 1", 2 pieces of "00000000 2"
				}
			}
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs "1.11€",
				Component "COMPONENT - 2" ID "00000000 2" costs "2.22€"
			}
		''')
	}

	@Test def test007() {
		'''
			Products {
				Product "Product 1" ID "22222222 1" uses {
				}
			}
		'''.testCodeMining('''
			1 product
			Products {
				Product "Product 1" ID "22222222 1" uses {
				}
			}
		''')
	}

	@Test def test008() {
		'''
			Products {
				Product "Product 1" ID "22222222 1" uses {
					1 pieces of "11111111 1", 1 pieces of "11111111 2"
				},
				Product "Product 2" ID "22222222 2" uses {
					1 pieces of "11111111 2", 1 pieces of "11111111 3"
				}
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
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs "1.11€",
				Component "COMPONENT - 2" ID "00000000 2" costs "2.22€",
				Component "COMPONENT - 3" ID "00000000 3" costs "3.33€",
				Component "COMPONENT - 4" ID "00000000 4" costs "4.44€"
			}
		'''.testCodeMining('''
			2 products | 3 assemblies | 4 components
			Products {
				Product "Product 1" ID "22222222 1" uses {
					1 pieces of "11111111 1", 1 pieces of "11111111 2"
				},
				Product "Product 2" ID "22222222 2" uses {
					1 pieces of "11111111 2", 1 pieces of "11111111 3"
				}
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
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs "1.11€",
				Component "COMPONENT - 2" ID "00000000 2" costs "2.22€",
				Component "COMPONENT - 3" ID "00000000 3" costs "3.33€",
				Component "COMPONENT - 4" ID "00000000 4" costs "4.44€"
			}
		''')
	}
}
