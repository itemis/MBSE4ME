package com.itemis.mbse4me.dsls.ui.doubleclicking;

import org.eclipse.jface.text.BadLocationException;
import org.eclipse.jface.text.IDocument;
import org.eclipse.jface.text.IRegion;
import org.eclipse.jface.text.ITypedRegion;
import org.eclipse.jface.text.TextUtilities;
import org.eclipse.xtext.ui.editor.doubleClicking.FixedCharCountPartitionDoubleClickSelector;

public class ErModelFixedCharCountPartitionDoubleClickSelector extends FixedCharCountPartitionDoubleClickSelector {

	private String fPartitioning;

	public ErModelFixedCharCountPartitionDoubleClickSelector(String partitioning, int leftBorder, int rightBorder) {
		super(partitioning, leftBorder, rightBorder);
		this.fPartitioning = partitioning;
	}

	@Override
	protected IRegion findExtendedDoubleClickSelection(IDocument document, int offset) {
		IRegion match= super.findExtendedDoubleClickSelection(document, offset);
		if (match != null)
			return match;

		try {
			ITypedRegion region= TextUtilities.getPartition(document, fPartitioning, offset, true);
			return getSelectedRegion(document, region);
		} catch (BadLocationException e) {
			return null;
		}
	}

}
