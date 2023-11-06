package com.itemis.mbse4me.dsls.tests

import com.google.inject.Inject
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.testing.formatter.FormatterTestHelper
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith

/**
 * Test cases for the {@link com.itemis.mbse4me.dsls.formatting2.ErModelFormatter} class.
 */
@ExtendWith(InjectionExtension)
@InjectWith(ErModelInjectorProvider)
class ErModelFormatterTest {

	@Inject extension FormatterTestHelper

	@Test def test001() {
		'''
			Components { Component "COMPONENT - 1" ID "00000000 1" costs "1.11€"}
		'''.isFormattedTo('''
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs "1.11€"
			}
		''')
	}

	@Test def test002() {
		'''
			Components { Component "COMPONENT - 1" ID "00000000 1" costs "1.11€",Component "COMPONENT - 2" ID "00000000 2" costs "2.22€"}
		'''.isFormattedTo('''
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs "1.11€",
				Component "COMPONENT - 2" ID "00000000 2" costs "2.22€"
			}
		''')
	}

	private def isFormattedTo(CharSequence formatterInput, CharSequence formatterExpectation) {
		assertFormatted[
			toBeFormatted = formatterInput
			expectation = formatterExpectation
		]
	}
}