package com.itemis.mbse4me.dsls.plantuml

import com.itemis.mbse4me.dsls.erModel.Assembly
import com.itemis.mbse4me.dsls.erModel.Component
import com.itemis.mbse4me.dsls.erModel.ModelContainer
import com.itemis.mbse4me.dsls.erModel.Product
import java.util.List
import org.eclipse.emf.ecore.resource.ResourceSet

/**
 * Converts a DSL model to a PlantUML representation.
 */
class ErModelPlantUMLConverter {

	List<Component> allComponents
	List<Assembly> allAssemblies
	List<Product> allProducts

	def convertToPlantUML(ResourceSet resourceSet) {
		resourceSet.collectAllData

		'''
			«FOR it : allComponents»
				class "Component «id»" {
					«name»
					«price»
				}
			«ENDFOR»
			«FOR it : allAssemblies»
				abstract "Assembly «id»" {}
			«ENDFOR»
			«FOR it : allProducts»
				protocol "Product «id»" {
					«name»
				}
			«ENDFOR»
			«FOR assembly : allAssemblies»
				«FOR componentUsage: assembly.componentUsages»
					"Component «componentUsage.component.id»" --> "«componentUsage.count» pieces" "Assembly «assembly.id»"
				«ENDFOR»
			«ENDFOR»
			«FOR product : allProducts»
				«FOR assemblyUsage: product.assemblyUsages»
					"Assembly «assemblyUsage.assembly.id»" --> "«assemblyUsage.count» pieces" "Product «product.id»"
				«ENDFOR»
			«ENDFOR»
		'''
	}

	private def collectAllData(ResourceSet resourceSet) {
		allComponents = newLinkedList
		allAssemblies = newLinkedList
		allProducts = newLinkedList

		for (resource : resourceSet.resources) {
			val modelContainer = resource.allContents.head as ModelContainer

			allComponents += modelContainer.components
			allAssemblies += modelContainer.assemblies
			allProducts += modelContainer.products
		}
	}

}