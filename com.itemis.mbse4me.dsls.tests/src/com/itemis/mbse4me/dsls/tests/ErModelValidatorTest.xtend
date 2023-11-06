package com.itemis.mbse4me.dsls.tests

import com.google.inject.Inject
import com.itemis.mbse4me.dsls.erModel.ModelContainer
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith

import static extension org.junit.jupiter.api.Assertions.assertEquals
import com.itemis.mbse4me.dsls.erModel.ErModelPackage
import com.itemis.mbse4me.dsls.validation.ErModelIssueCodes

/**
 * Test cases for the {@link com.itemis.mbse4me.dsls.validation.ErModelValidator} class.
 */
@ExtendWith(InjectionExtension)
@InjectWith(ErModelInjectorProvider)
class ErModelValidatorTest {

	@Inject extension ParseHelper<ModelContainer>

	extension ValidationTestHelper validationTestHelper = new ValidationTestHelper(ValidationTestHelper.Mode.EXACT)

	@Test def void test001() {
		'''
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs "1.11"
			}
		'''.parse.
		assertNumberOfIssues(1).
		assertError(ErModelPackage.Literals.COMPONENT, ErModelIssueCodes.COMPONENT_MISSING_CURRENCY, 63, 6, "Price has no currency!")
	}

	@Test def void test002() {
		'''
			Assemblies {
				Assembly "ASSEMBLY 1" ID "11111111 1" uses {
				}
			}
		'''.parse.
		assertNumberOfIssues(1).
		assertWarning(ErModelPackage.Literals.ASSEMBLY, ErModelIssueCodes.ASSEMBLY_HAS_NO_COMPONENT, 15, 48, "Assembly uses no components")
	}

	@Test def void test003() {
		'''
			Products {
				Product "Product 1" ID "22222222 1" uses {
				}
			}
		'''.parse.
		assertNumberOfIssues(1).
		assertWarning(ErModelPackage.Literals.PRODUCT, ErModelIssueCodes.PRODUCT_HAS_NO_ASSEMBLY, 13, 46, "Product uses no assemblies")
	}

	private def assertNumberOfIssues(ModelContainer modelContainer, int expectedNumberOfIssues) {
		expectedNumberOfIssues.assertEquals(modelContainer.validate.size)
		modelContainer
	}

}