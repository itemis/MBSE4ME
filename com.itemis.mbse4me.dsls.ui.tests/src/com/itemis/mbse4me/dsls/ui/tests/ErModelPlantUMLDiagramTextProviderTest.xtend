package com.itemis.mbse4me.dsls.ui.tests

import com.google.inject.Inject
import org.eclipse.xtext.resource.FileExtensionProvider
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.ui.testing.AbstractEditorTest
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith
import com.itemis.mbse4me.dsls.ui.plantuml.ErModelPlantUMLDiagramTextProvider

/**
 * Test cases for the {@link com.itemis.mbse4me.dsls.ui.plantuml.ErModelPlantUMLDiagramTextProvider} class.
 */
@ExtendWith(InjectionExtension)
@InjectWith(ErModelUiInjectorProvider)
class ErModelPlantUMLDiagramTextProviderTest extends AbstractEditorTest {

	@Inject extension ErModelPlantUMLDiagramTextProvider
	@Inject extension FileExtensionProvider

	@Test def test001() {
		''''''.assertConvertedTo(null)
	}

	@Test def test002() {
		'''
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs "1.11€"
			}
		'''.assertConvertedTo('''
			class "Component 00000000 1" {
				COMPONENT - 1
				1.11€
			}
		''')
	}

	private def assertConvertedTo(CharSequence input, String expectedDiagramText) {
		val actualDiagramText = dslFile("TestProject", "test", primaryFileExtension, input).
					openEditor.
					getDiagramText(null)

		if (expectedDiagramText === null) {
			Assertions.assertNull(actualDiagramText)
		} else {
			Assertions.assertEquals(expectedDiagramText.toString, actualDiagramText.toString)
		}
	}
}