package com.itemis.mbse4me.dsls.ui.utils;

import org.eclipse.jface.viewers.StyledString;

public class ErModelUiUtils {

	public static StyledString style(String text) {
		StyledString styledString = new StyledString(text);
		int offset = text.indexOf('-');
		styledString.setStyle(offset, text.length() - offset, StyledString.DECORATIONS_STYLER);
		return styledString;
	}

}
