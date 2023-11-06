package com.itemis.mbse4me.dsls.ui.doubleclicking;

import org.eclipse.jface.text.ITextDoubleClickStrategy;
import org.eclipse.jface.text.source.ISourceViewer;
import org.eclipse.xtext.ui.editor.doubleClicking.DoubleClickStrategyProvider;
import org.eclipse.xtext.ui.editor.model.TerminalsTokenTypeToPartitionMapper;

public class ErModelDoubleClickStrategyProvider extends DoubleClickStrategyProvider {

	@Override
	public ITextDoubleClickStrategy getStrategy(ISourceViewer sourceViewer,
			String contentType, String documentPartitioning) {

		if (TerminalsTokenTypeToPartitionMapper.STRING_LITERAL_PARTITION.equals(contentType)) {
			return new ErModelFixedCharCountPartitionDoubleClickSelector(documentPartitioning, 1, 1);
		}

		return super.getStrategy(sourceViewer, contentType,
				documentPartitioning);
	}

}