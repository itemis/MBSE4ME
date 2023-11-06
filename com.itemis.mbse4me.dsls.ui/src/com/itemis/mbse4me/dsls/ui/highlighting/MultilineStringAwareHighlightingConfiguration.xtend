package com.itemis.mbse4me.dsls.ui.highlighting

import org.eclipse.swt.graphics.RGB
import org.eclipse.xtext.ui.editor.syntaxcoloring.DefaultHighlightingConfiguration
import org.eclipse.xtext.ui.editor.syntaxcoloring.IHighlightingConfigurationAcceptor

class MultilineStringAwareHighlightingConfiguration extends DefaultHighlightingConfiguration {

	public static val String MULTILINE_STRING = "multiline_string"

	override configure(IHighlightingConfigurationAcceptor acceptor) {
		super.configure(acceptor)
		acceptor.acceptDefaultHighlighting(MULTILINE_STRING, "Multiline String", multilineStringStyle)
	}

	def multilineStringStyle() {
		val textStyle = stringTextStyle.copy
		textStyle.backgroundColor = new RGB(220, 220, 220) // grey
		textStyle
	}

}