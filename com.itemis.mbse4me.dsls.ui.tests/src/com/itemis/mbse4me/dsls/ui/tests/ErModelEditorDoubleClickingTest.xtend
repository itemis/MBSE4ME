package com.itemis.mbse4me.dsls.ui.tests

import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.ui.XtextProjectHelper
import org.eclipse.xtext.ui.testing.AbstractEditorDoubleClickTextSelectionTest
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith

import static extension org.eclipse.xtext.ui.testing.util.IResourcesSetupUtil.addNature

/**
 * Test cases for the {@link com.itemis.mbse4me.dsls.ui.doubleclicking.ErModelDoubleClickStrategyProvider} class.
 */
@ExtendWith(InjectionExtension)
@InjectWith(ErModelUiInjectorProvider)
class ErModelEditorDoubleClickingTest extends AbstractEditorDoubleClickTextSelectionTest {

	override protected createFile(String content) {
		val file = super.createFile(content)

		val project = file.project
		if(!project.hasNature(XtextProjectHelper.NATURE_ID)) {
			project.addNature(XtextProjectHelper.NATURE_ID)
		}

		file
	}

	@Test def test001() {
		'''
			Components {
				Component "«c»COMPONENT - 1" ID "00000000 1" costs "1.11€"
			}
		'''.assertSelectedTextAfterDoubleClicking('''COMPONENT - 1''')
	}

	@Test def test002() {
		'''
			Components {
				Component "COMP«c»ONENT - 1" ID "00000000 1" costs "1.11€"
			}
		'''.assertSelectedTextAfterDoubleClicking('''COMPONENT - 1''')
	}

	@Test def test003() {
		'''
			Components {
				Component "COMPONENT - 1«c»" ID "00000000 1" costs "1.11€"
			}
		'''.assertSelectedTextAfterDoubleClicking('''COMPONENT - 1''')
	}
}