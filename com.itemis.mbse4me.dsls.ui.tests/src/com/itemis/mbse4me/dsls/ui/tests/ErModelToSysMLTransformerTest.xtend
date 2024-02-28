package com.itemis.mbse4me.dsls.ui.tests

import com.google.inject.Inject
import com.itemis.mbse4me.dsls.erModel.ModelContainer
import com.itemis.mbse4me.dsls.sysml.ErModelToSysMLTransformer
import com.itemis.mbse4me.dsls.sysml.IErModelToSysMLTransformer
import java.util.List
import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.IProject
import org.eclipse.core.runtime.NullProgressMonitor
import org.eclipse.emf.common.util.URI
import org.eclipse.uml2.uml.Class
import org.eclipse.uml2.uml.Model
import org.eclipse.uml2.uml.Package
import org.eclipse.uml2.uml.Usage
import org.eclipse.xtext.resource.FileExtensionProvider
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.ui.XtextProjectHelper
import org.eclipse.xtext.ui.resource.IResourceSetProvider
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith

import static org.junit.jupiter.api.Assertions.assertEquals

import static extension org.eclipse.xtext.ui.testing.util.IResourcesSetupUtil.addNature
import static extension org.eclipse.xtext.ui.testing.util.IResourcesSetupUtil.createFile
import static extension org.eclipse.xtext.ui.testing.util.IResourcesSetupUtil.createProject

import static org.eclipse.xtext.ui.testing.util.IResourcesSetupUtil.waitForBuild

/**
 * Test cases for the {@link com.itemis.mbse4me.dsls.sysml.ErModelToSysMLTransformer} class.
 */
@ExtendWith(InjectionExtension)
@InjectWith(ErModelUiInjectorProvider)
class ErModelToSysMLTransformerTest {

	@Inject IResourceSetProvider resourceSetProvider

	@Inject extension FileExtensionProvider

	val IErModelToSysMLTransformer transfomer = new ErModelToSysMLTransformer

	@Test def test001() {
		#['''
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs "1.11€"
			}
		'''].assertConvertedTo('''
			<Package> Components
				<<Block>> <Class> COMPONENT - 1
					<Property> PLM_ID
						<Literal String> 00000000 1
					<Property> Price
						<Literal String> 1.11€
			<Package> Assemblies
			<Package> Products
		''')
	}

	@Test def test002() {
		#['''
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs "1.11€",
				Component "COMPONENT - 2" ID "00000000 2" costs "2.22€"
			}
		'''].assertConvertedTo('''
			<Package> Components
				<<Block>> <Class> COMPONENT - 1
					<Property> PLM_ID
						<Literal String> 00000000 1
					<Property> Price
						<Literal String> 1.11€
				<<Block>> <Class> COMPONENT - 2
					<Property> PLM_ID
						<Literal String> 00000000 2
					<Property> Price
						<Literal String> 2.22€
			<Package> Assemblies
			<Package> Products
		''')
	}

	@Test def test003() {
		#['''
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs "1.11€"
			}
		''',
		'''
			Assemblies {
				Assembly "ASSEMBLY 1" ID "11111111 1" uses {
					1 piece of "00000000 1"
				}
			}
		'''].assertConvertedTo('''
			<Package> Components
				<<Block>> <Class> COMPONENT - 1
					<Property> PLM_ID
						<Literal String> 00000000 1
					<Property> Price
						<Literal String> 1.11€
			<Package> Assemblies
				<<Block>> <Class> ASSEMBLY 1
					<Property> PLM_ID
						<Literal String> 11111111 1
					<Property> Price
						<Literal String> 1.11€
				<Usage> 'ASSEMBLY 1' uses 1 Pcs of 'COMPONENT - 1'
			<Package> Products
		''')
	}

	@Test def test004() {
		#['''
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs "1.11€",
				Component "COMPONENT - 2" ID "00000000 2" costs "2.22€"
			}
		''',
		'''
			Assemblies {
				Assembly "ASSEMBLY 1" ID "11111111 1" uses {
					1 piece of "00000000 1", 2 pieces of "00000000 2"
				}
			}
		'''].assertConvertedTo('''
			<Package> Components
				<<Block>> <Class> COMPONENT - 1
					<Property> PLM_ID
						<Literal String> 00000000 1
					<Property> Price
						<Literal String> 1.11€
				<<Block>> <Class> COMPONENT - 2
					<Property> PLM_ID
						<Literal String> 00000000 2
					<Property> Price
						<Literal String> 2.22€
			<Package> Assemblies
				<<Block>> <Class> ASSEMBLY 1
					<Property> PLM_ID
						<Literal String> 11111111 1
					<Property> Price
						<Literal String> 5.55€
				<Usage> 'ASSEMBLY 1' uses 1 Pcs of 'COMPONENT - 1'
				<Usage> 'ASSEMBLY 1' uses 2 Pcs of 'COMPONENT - 2'
			<Package> Products
		''')
	}

	@Test def test005() {
		#['''
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs "1.11€"
			}
		''',
		'''
			Assemblies {
				Assembly "ASSEMBLY 1" ID "11111111 1" uses {
					1 piece of "00000000 1"
				}
			}
		''',
		'''
			Products {
				Product "Product 1" ID "22222222 1" uses {
					1 piece of "11111111 1"
				}
			}
		'''
		].assertConvertedTo('''
			<Package> Components
				<<Block>> <Class> COMPONENT - 1
					<Property> PLM_ID
						<Literal String> 00000000 1
					<Property> Price
						<Literal String> 1.11€
			<Package> Assemblies
				<<Block>> <Class> ASSEMBLY 1
					<Property> PLM_ID
						<Literal String> 11111111 1
					<Property> Price
						<Literal String> 1.11€
				<Usage> 'ASSEMBLY 1' uses 1 Pcs of 'COMPONENT - 1'
			<Package> Products
				<<Block>> <Class> Product 1
					<Property> PLM_ID
						<Literal String> 22222222 1
					<Property> Price
						<Literal String> 1.11€
				<Usage> 'Product 1' uses 1 Pcs of 'ASSEMBLY 1'
		''')
	}

	@Test def test006() {
		#['''
			Components {
				Component "COMPONENT - 1" ID "00000000 1" costs "1.11€",
				Component "COMPONENT - 2" ID "00000000 2" costs "2.22€",
				Component "COMPONENT - 3" ID "00000000 3" costs "3.33€",
				Component "COMPONENT - 4" ID "00000000 4" costs "4.44€"
			}
		''',
		'''
			Assemblies {
				Assembly "ASSEMBLY 1" ID "11111111 1" uses {
					1 piece of "00000000 1", 2 pieces of "00000000 2"
				},
				Assembly "ASSEMBLY 2" ID "11111111 2" uses {
					3 pieces of "00000000 2", 4 pieces of "00000000 3"
				},
				Assembly "ASSEMBLY 3" ID "11111111 3" uses {
					5 pieces of "00000000 3", 6 pieces of "00000000 4"
		''',
		'''
			Products {
				Product "Product 1" ID "22222222 1" uses {
					1 piece of "11111111 1", 1 piece of "11111111 2"
				},
				Product "Product 2" ID "22222222 2" uses {
					1 piece of "11111111 2", 1 piece of "11111111 3"
				}
			}
		'''
		].assertConvertedTo('''
			<Package> Components
				<<Block>> <Class> COMPONENT - 1
					<Property> PLM_ID
						<Literal String> 00000000 1
					<Property> Price
						<Literal String> 1.11€
				<<Block>> <Class> COMPONENT - 2
					<Property> PLM_ID
						<Literal String> 00000000 2
					<Property> Price
						<Literal String> 2.22€
				<<Block>> <Class> COMPONENT - 3
					<Property> PLM_ID
						<Literal String> 00000000 3
					<Property> Price
						<Literal String> 3.33€
				<<Block>> <Class> COMPONENT - 4
					<Property> PLM_ID
						<Literal String> 00000000 4
					<Property> Price
						<Literal String> 4.44€
			<Package> Assemblies
				<<Block>> <Class> ASSEMBLY 1
					<Property> PLM_ID
						<Literal String> 11111111 1
					<Property> Price
						<Literal String> 5.55€
				<Usage> 'ASSEMBLY 1' uses 1 Pcs of 'COMPONENT - 1'
				<Usage> 'ASSEMBLY 1' uses 2 Pcs of 'COMPONENT - 2'
				<Usage> 'ASSEMBLY 2' uses 3 Pcs of 'COMPONENT - 2'
				<Usage> 'ASSEMBLY 2' uses 4 Pcs of 'COMPONENT - 3'
				<Usage> 'ASSEMBLY 3' uses 5 Pcs of 'COMPONENT - 3'
				<Usage> 'ASSEMBLY 3' uses 6 Pcs of 'COMPONENT - 4'
				<<Block>> <Class> ASSEMBLY 2
					<Property> PLM_ID
						<Literal String> 11111111 2
					<Property> Price
						<Literal String> 19.98€
				<Usage> 'ASSEMBLY 1' uses 1 Pcs of 'COMPONENT - 1'
				<Usage> 'ASSEMBLY 1' uses 2 Pcs of 'COMPONENT - 2'
				<Usage> 'ASSEMBLY 2' uses 3 Pcs of 'COMPONENT - 2'
				<Usage> 'ASSEMBLY 2' uses 4 Pcs of 'COMPONENT - 3'
				<Usage> 'ASSEMBLY 3' uses 5 Pcs of 'COMPONENT - 3'
				<Usage> 'ASSEMBLY 3' uses 6 Pcs of 'COMPONENT - 4'
				<<Block>> <Class> ASSEMBLY 3
					<Property> PLM_ID
						<Literal String> 11111111 3
					<Property> Price
						<Literal String> 43.29€
				<Usage> 'ASSEMBLY 1' uses 1 Pcs of 'COMPONENT - 1'
				<Usage> 'ASSEMBLY 1' uses 2 Pcs of 'COMPONENT - 2'
				<Usage> 'ASSEMBLY 2' uses 3 Pcs of 'COMPONENT - 2'
				<Usage> 'ASSEMBLY 2' uses 4 Pcs of 'COMPONENT - 3'
				<Usage> 'ASSEMBLY 3' uses 5 Pcs of 'COMPONENT - 3'
				<Usage> 'ASSEMBLY 3' uses 6 Pcs of 'COMPONENT - 4'
			<Package> Products
				<<Block>> <Class> Product 1
					<Property> PLM_ID
						<Literal String> 22222222 1
					<Property> Price
						<Literal String> 25.53€
				<Usage> 'Product 1' uses 1 Pcs of 'ASSEMBLY 1'
				<Usage> 'Product 1' uses 1 Pcs of 'ASSEMBLY 2'
				<Usage> 'Product 2' uses 1 Pcs of 'ASSEMBLY 2'
				<Usage> 'Product 2' uses 1 Pcs of 'ASSEMBLY 3'
				<<Block>> <Class> Product 2
					<Property> PLM_ID
						<Literal String> 22222222 2
					<Property> Price
						<Literal String> 63.27€
				<Usage> 'Product 1' uses 1 Pcs of 'ASSEMBLY 1'
				<Usage> 'Product 1' uses 1 Pcs of 'ASSEMBLY 2'
				<Usage> 'Product 2' uses 1 Pcs of 'ASSEMBLY 2'
				<Usage> 'Product 2' uses 1 Pcs of 'ASSEMBLY 3'
		''')
	}

	private def assertConvertedTo(List<String> input, CharSequence expected) {
		val project = "TestProject".createProject

		project.addNature(XtextProjectHelper.NATURE_ID)

		"TestProject".createFile("components", primaryFileExtension, input.head)

		if (input.size > 1) {
			"TestProject".createFile("assemblies", primaryFileExtension, input.get(1))
		}

		if (input.size > 2) {
			"TestProject".createFile("products", primaryFileExtension, input.get(2))
		}

		waitForBuild

		val actual = transfomer.transform(
			project.convertToModelContainers,
			#[], // requirments
			project,
			"output",
			new NullProgressMonitor
		).text

		assertEquals(expected.toString, actual.toString)
	}

	private def text(Model it) '''
		«createComponentsText»
		«createAssembliesText»
		«createProductsText»
	'''

	private def createComponentsText(Model it) '''
		<Package> Components
			«FOR component : componentsPackage.allOwnedElements.filter(Class)»
				<<Block>> <Class> «component.name»
					«FOR property : component.getAllAttributes»
						<Property> «property.name»
							<Literal String> «property.defaultValue.stringValue»
					«ENDFOR»
			«ENDFOR»
	'''

	private def createAssembliesText(Model it) '''
		«val assembliesPackage = assembliesPackage»
		<Package> Assemblies
			«FOR assembly : assembliesPackage.allOwnedElements.filter(Class)»
				<<Block>> <Class> «assembly.name»
					«FOR property : assembly.getAllAttributes»
						<Property> «property.name»
							<Literal String> «property.defaultValue.stringValue»
					«ENDFOR»
				«FOR usage : assembliesPackage.packagedElements.filter(Usage)»
					<Usage> '«usage.clients.head.name»' uses «usage.count» of '«usage.suppliers.head.name»'
				«ENDFOR»
			«ENDFOR»
	'''

	private def createProductsText(Model it) '''
		«val productsPackage = productsPackage»
		<Package> Products
			«FOR product : productsPackage.allOwnedElements.filter(Class)»
				<<Block>> <Class> «product.name»
					«FOR property : product.getAllAttributes»
						<Property> «property.name»
							<Literal String> «property.defaultValue.stringValue»
					«ENDFOR»
				«FOR usage : productsPackage.packagedElements.filter(Usage)»
					<Usage> '«usage.clients.head.name»' uses «usage.count» of '«usage.suppliers.head.name»'
				«ENDFOR»
			«ENDFOR»
	'''

	private def componentsPackage(Model model) {
		model.getPackagedElement("Components") as Package
	}

	private def assembliesPackage(Model model) {
		model.getPackagedElement("Assemblies") as Package
	}

	private def productsPackage(Model model) {
		model.getPackagedElement("Products") as Package
	}

	private def count(Usage usage) {
		usage.ownedComments.head.body
	}

	private def List<ModelContainer> convertToModelContainers(IProject project) {
		val modelContainers = newArrayList
		val resourceSet = resourceSetProvider.get(project)
		for (member : project.members) {
			if (member instanceof IFile && member.getFileExtension().equals(primaryFileExtension)) {
				// get the resources out of the file
				val resource = resourceSet.getResource(URI.createURI(member.fullPath.toString), true)
				if (!resource.contents.isEmpty) {
					val rootNode = resource.contents.head
					if (rootNode instanceof ModelContainer) {
						modelContainers += rootNode
					}
				}
			}
		}
		return modelContainers
	}
}