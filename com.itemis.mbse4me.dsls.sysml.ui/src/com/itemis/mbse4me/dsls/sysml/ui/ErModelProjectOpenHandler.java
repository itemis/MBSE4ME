
package com.itemis.mbse4me.dsls.sysml.ui;

import org.eclipse.e4.core.di.annotations.Evaluate;
import org.eclipse.ui.PlatformUI;
import org.eclipse.core.resources.IProject;
import org.eclipse.jface.viewers.TreeSelection;

public class ErModelProjectOpenHandler {
	@Evaluate
	public boolean evaluate() {
		var activeWorkshopWindow = PlatformUI.getWorkbench().getActiveWorkbenchWindow();
		if (activeWorkshopWindow != null) {
			var selection = activeWorkshopWindow.getSelectionService().getSelection();
			if (selection instanceof TreeSelection treeSelection) {
				var firstElement = treeSelection.getFirstElement();
				return treeSelection.size() == 1 && firstElement instanceof IProject;
			} else {
				return false;
			}
		} else {
			return false;
		}
	}
}
