package com.itemis.mbse4me.dsls.ui.tests

import com.google.inject.Inject
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.ui.testing.AbstractHighlightingTest
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith

import com.itemis.mbse4me.dsls.ui.highlighting.MultilineStringAwareHighlightingConfiguration

import static com.itemis.mbse4me.dsls.tests.utils.TestUtils.c

@ExtendWith(InjectionExtension)
@InjectWith(RequirementUiInjectorProvider)
class RequirementHighlightingTest extends AbstractHighlightingTest {

	@Inject extension MultilineStringAwareHighlightingConfiguration

	@Test def void test001() {
		'''
			Number: "1.1.1"
			Text: «c»
				Line 1.
				Line 2.
			«c»
		''' => [
			testHighlighting('''Line 1.''', multilineStringStyle)
			testHighlighting('''Line 2.''', multilineStringStyle)
		]
	}

	@Test def void test002() {
		'''
			Number: "1.1.1"
			Text: «c»
				A
			BCD
			«c»
		''' => [
			testHighlighting('''A''', multilineStringStyle)
			testHighlighting('''BCD''', multilineStringStyle)
		]
	}

}