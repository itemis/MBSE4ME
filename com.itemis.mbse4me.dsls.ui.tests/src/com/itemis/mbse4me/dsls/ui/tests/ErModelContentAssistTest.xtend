package com.itemis.mbse4me.dsls.ui.tests

import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.ui.testing.AbstractContentAssistTest
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith

/**
 * Test cases for the {@link com.itemis.mbse4me.dsls.ui.contentassist.ErModelProposalProvider} class.
 */
@ExtendWith(InjectionExtension)
@InjectWith(ErModelUiInjectorProvider)
class ErModelContentAssistTest extends AbstractContentAssistTest {

	@Test def test001() {
		'''
			«c»
		'''.assertContentAssistant(#["Assemblies", "Components", "Products"], "Assemblies", '''
			Assemblies
		''')
	}
}