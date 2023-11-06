package com.itemis.mbse4me.dsls.ui.tests

import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.ui.testing.AbstractMultiQuickfixTest
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith

/**
 * Test cases for the {@link com.itemis.mbse4me.dsls.ui.quickfix.ErModelQuickfixProvider} class.
 */
@ExtendWith(InjectionExtension)
@InjectWith(ErModelUiInjectorProvider)
class ErModelMultiQuickfixTest extends AbstractMultiQuickfixTest {

	@Test def test001() {
		'''
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs "1.11"
			}
		'''.testMultiQuickfix('''
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs <0<"1.11">0>
			}
			-----
			0: message=Price has no currency!
		''', '''
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs "1.11€"
			}
			-----
			(no markers found)
		''')
	}

	@Test def test002() {
		'''
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs "1.11",
				Component "COMPONENT - 2" ID "00000000 2" costs "2.22",
				Component "COMPONENT - 3" ID "00000000 3" costs "3.33",
				Component "COMPONENT - 4" ID "00000000 4" costs "4.44"
			}
		'''.testMultiQuickfix('''
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs <0<"1.11">0>,
				Component "COMPONENT - 2" ID "00000000 2" costs <1<"2.22">1>,
				Component "COMPONENT - 3" ID "00000000 3" costs <2<"3.33">2>,
				Component "COMPONENT - 4" ID "00000000 4" costs <3<"4.44">3>
			}
			-----
			0: message=Price has no currency!
			1: message=Price has no currency!
			2: message=Price has no currency!
			3: message=Price has no currency!
		''', '''
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs "1.11€",
				Component "COMPONENT - 2" ID "00000000 2" costs "2.22€",
				Component "COMPONENT - 3" ID "00000000 3" costs "3.33€",
				Component "COMPONENT - 4" ID "00000000 4" costs "4.44€"
			}
			-----
			(no markers found)
		''')
	}

}