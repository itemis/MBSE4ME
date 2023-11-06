package com.itemis.mbse4me.dsls.ui.tests

import java.util.List
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.ui.testing.AbstractContentAssistTest
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith

import static org.junit.jupiter.api.Assertions.fail

/**
 * Test cases for the {@link com.itemis.mbse4me.dsls.ui.contentassist.ErModelProposalProvider} class.
 */
@ExtendWith(InjectionExtension)
@InjectWith(ErModelUiInjectorProvider)
class ErModelContentAssistTest extends AbstractContentAssistTest {

	// cursor position marker
	val c = '''<|>'''

	@Test def test001() {
		'''
			«c»
		'''.testContentAssistant(#["Assemblies", "Components", "Products"], "Assemblies", '''
			Assemblies
		''')
	}

	private def void testContentAssistant(CharSequence text, List<String> expectedProposals,
		String proposalToApply, String expectedContent) {

		val cursorPosition = text.toString.indexOf(c)
		if(cursorPosition == -1) {
			fail("Can't locate cursor position symbols '" + c + "' in the input text.")
		}

		val content = text.toString.replace(c, "")

		val builder = newBuilder.append(content).assertTextAtCursorPosition(cursorPosition, expectedProposals)

		if(proposalToApply !== null) {
			builder.applyProposal(cursorPosition, proposalToApply).expectContent(expectedContent)
		}
	}

}