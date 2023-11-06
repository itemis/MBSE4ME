package com.itemis.mbse4me.dsls.formatting2

import com.google.inject.Inject
import com.itemis.mbse4me.dsls.erModel.Component
import com.itemis.mbse4me.dsls.erModel.ErModelPackage
import com.itemis.mbse4me.dsls.erModel.ModelContainer
import com.itemis.mbse4me.dsls.services.ErModelGrammarAccess
import org.eclipse.xtext.formatting2.AbstractFormatter2
import org.eclipse.xtext.formatting2.IFormattableDocument
import org.eclipse.xtext.formatting2.regionaccess.ISemanticRegion

class ErModelFormatter extends AbstractFormatter2 {

	@Inject extension ErModelGrammarAccess

	int componentNameMaxLength

	def dispatch void format(ModelContainer it, extension IFormattableDocument document) {
		val longestComponentName = getLongestComponentName
		componentNameMaxLength = if (longestComponentName === null) 0 else longestComponentName.length

		formatProducts(document)
		formatAssemblies(document)
		formatComponents(document)
	}

	private def void formatProducts(ModelContainer it, extension IFormattableDocument document) {
		document.formatElement(
			regionFor.keyword(modelContainerAccess.leftCurlyBracketKeyword_0_1),
			regionFor.keyword(modelContainerAccess.rightCurlyBracketKeyword_0_4)
		)

		for (assembly : assemblies) {
			document.formatElement(assembly.regionFor.keyword("{"), assembly.regionFor.keyword("}"))
			assembly.prepend[newLine]
		}
	}

	private def void formatAssemblies(ModelContainer it, extension IFormattableDocument document) {
		document.formatElement(
			regionFor.keyword(modelContainerAccess.leftCurlyBracketKeyword_1_1),
			regionFor.keyword(modelContainerAccess.rightCurlyBracketKeyword_1_4)
		)

		for (component : components) {
			document.formatElement(component.regionFor.keyword("{"), component.regionFor.keyword("}"))
			component.prepend[newLine]
		}
	}

	private def void formatComponents(ModelContainer it, extension IFormattableDocument document) {
		document.formatElement(regionFor.keyword("{"), regionFor.keyword("}"))
		components.forEach [ component |
			component.format
		]
	}

	def dispatch format(Component component, extension IFormattableDocument document) {
		// align the component name and the component ID in columns based on the longest component name
		component.regionFor.feature(ErModelPackage.Literals.COMPONENT__NAME).append[space = component.additionalSpaces]

		component.prepend[newLine]
	}

	private def void formatElement(extension IFormattableDocument document, ISemanticRegion leftCurlyBracket, ISemanticRegion rightCurlyBracket) {
		leftCurlyBracket.append[newLine]
		interior(leftCurlyBracket, rightCurlyBracket)[indent]
		rightCurlyBracket.prepend[newLine]
	}

	private def additionalSpaces(Component it) {
		val count = componentNameMaxLength - name.length + 1
		" ".repeat(count)
	}

	private def getLongestComponentName(ModelContainer modelContainer) {
		modelContainer.components.sortBy[-name.length]?.head?.name
	}
}
