package com.itemis.mbse4me.dsls.tests

import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.testing.formatter.AbstractFormatterTest
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith

/**
 * Test cases for the {@link com.itemis.mbse4me.dsls.formatting2.ErModelFormatter} class.
 */
@ExtendWith(InjectionExtension)
@InjectWith(ErModelInjectorProvider)
class ErModelFormatterTest extends AbstractFormatterTest {

	@Test def test001() {
		'''
			Components { Component "COMPONENT - 1" ID "00000000 1" costs "1.11€"}
		'''.assertFormattedTo('''
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs "1.11€"
			}
		''')
	}

	@Test def test002() {
		'''
			Components { Component "COMPONENT - 1" ID "00000000 1" costs "1.11€",Component "COMPONENT - 2" ID "00000000 2" costs "2.22€"}
		'''.assertFormattedTo('''
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs "1.11€",
				Component "COMPONENT - 2" ID "00000000 2" costs "2.22€"
			}
		''')
	}
}