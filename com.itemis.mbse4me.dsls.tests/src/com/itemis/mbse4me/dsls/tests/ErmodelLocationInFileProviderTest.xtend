package com.itemis.mbse4me.dsls.tests

import com.google.inject.Inject
import com.itemis.mbse4me.dsls.erModel.ModelContainer
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.resource.ILocationInFileProvider
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith

import static org.junit.jupiter.api.Assertions.assertEquals

/**
 * Test cases for the {@link com.itemis.mbse4me.dsls.resource.ErModelLocationInFileProvider} class.
 */
@ExtendWith(InjectionExtension)
@InjectWith(ErModelInjectorProvider)
class ErmodelLocationInFileProviderTest {

	// cursor position marker
	val c = '''<|>'''

	@Inject ILocationInFileProvider locationInFileProvider
	@Inject extension ParseHelper<ModelContainer>

	@Test def test001() {
		'''
			Components {
				Component "COMPONENT - 1" ID «c»"00000000 1"«c» costs "1.11€"
			}
		'''.assertSignificantTextRegion
	}

	@Test def test002() {
		'''
			Assemblies {
				Assembly "ASSEMBLY 1" ID «c»"11111111 1"«c» uses {
				}
			}
		'''.assertSignificantTextRegion
	}

	private def assertSignificantTextRegion(CharSequence input) {
		val text = input.toString();
		val first = text.indexOf(c);
		if (first == -1) {
			Assertions.fail("Can't locate the first position symbol '" + c + "' in the input text");
		}

		val second = text.lastIndexOf(c);
		if (first == second) {
			Assertions.fail("Can't locate the second position symbol '" + c + "' in the input text");
		}

		val expectedOffset = first
		val expectedLength = second - first - c.length

		val content = text.toString().replace(c, "");

		val modelContainer = content.parse
		var EObject eObject = modelContainer.components.head
		if (eObject === null) {
			eObject = modelContainer.assemblies.head
		}

		val actual = locationInFileProvider.getSignificantTextRegion(eObject)
		val actualOffset = actual.offset
		val actualLength = actual.length

		assertEquals('''
			offset: «expectedOffset»
			length: «expectedLength»
		'''.toString, '''
			offset: «actualOffset»
			length: «actualLength»
		'''.toString)
	}

}