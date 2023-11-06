package com.itemis.mbse4me.dsls.ui.editor

import org.eclipse.xtext.ui.editor.model.TerminalsTokenTypeToPartitionMapper

class MultilineStringAwareTerminalsTokenTypeToPartitionMapper extends TerminalsTokenTypeToPartitionMapper {

	override protected calculateId(String tokenName, int tokenType) {
		/*
		 * enable spell checking in multiline string by assigning the string literal partition to it.
		 */
		if ("RULE_MULTILINE_STRING".equals(tokenName)) {
			STRING_LITERAL_PARTITION
		} else {
			super.calculateId(tokenName, tokenType)
		}
	}
}