package com.itemis.mbse4me.dsls.ui.highlighting

import org.eclipse.xtext.RuleCall
import org.eclipse.xtext.ide.editor.syntaxcoloring.DefaultSemanticHighlightingCalculator
import org.eclipse.xtext.ide.editor.syntaxcoloring.IHighlightedPositionAcceptor
import org.eclipse.xtext.nodemodel.INode
import org.eclipse.xtext.resource.XtextResource
import org.eclipse.xtext.util.CancelIndicator

import static extension com.itemis.mbse4me.dsls.ui.highlighting.TextLines.splitString

class MultilineStringAwareSemanticHighlightingCalculator extends DefaultSemanticHighlightingCalculator {

	override protected doProvideHighlightingFor(XtextResource resource, IHighlightedPositionAcceptor acceptor, CancelIndicator cancelIndicator) {

		// It gets a node model.
		val root = resource.parseResult.rootNode
		for (INode node : root.asTreeIterable) {
			val grammarElement = node.grammarElement
			if (grammarElement instanceof RuleCall) {
				val r = grammarElement.rule

				// handle MULTILINE_STRING elements specifically
				if (r.name.equals("MULTILINE_STRING")) {
					val startOffset = node.offset

					val textLines = node.text.splitString

					// do not highlight the starting and the ending triple quotes -> skip the first and the last line
					for(var i = 1; i < textLines.length - 1; i++) {
						var textLine = textLines.get(i)
						val leadingWhiteSpaceLength = textLine.leadingWhiteSpace.length
						val offset = startOffset + textLine.relativeOffset + leadingWhiteSpaceLength
						val length = textLine.length - leadingWhiteSpaceLength
						acceptor.addPosition(offset, length, MultilineStringAwareHighlightingConfiguration.MULTILINE_STRING)
					}
				}
			}
		}
	}
}