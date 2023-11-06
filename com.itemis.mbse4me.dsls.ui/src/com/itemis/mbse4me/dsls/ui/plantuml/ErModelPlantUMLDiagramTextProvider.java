package com.itemis.mbse4me.dsls.ui.plantuml;

import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.ui.IEditorPart;
import org.eclipse.xtext.LanguageInfo;
import org.eclipse.xtext.resource.XtextResource;
import org.eclipse.xtext.ui.editor.XtextEditor;
import org.eclipse.xtext.ui.editor.model.IXtextDocument;
import org.eclipse.xtext.util.concurrent.IUnitOfWork;

import com.google.inject.Inject;
import com.itemis.mbse4me.dsls.erModel.ModelContainer;
import com.itemis.mbse4me.dsls.plantuml.ErModelPlantUMLConverter;

import net.sourceforge.plantuml.eclipse.utils.DiagramTextProvider;

public class ErModelPlantUMLDiagramTextProvider implements DiagramTextProvider {

	@Inject
	private LanguageInfo languageInfo;

	@Inject
	private ErModelPlantUMLConverter erModelPlantUMLConverter;

	@Override
	public boolean supportsSelection(ISelection selection) {
		return true;
	}

	@Override
	public String getDiagramText(IEditorPart editorPart, ISelection selection) {

		if (editorPart instanceof XtextEditor) {
			XtextEditor xtextEditor = (XtextEditor) editorPart;
			if (languageInfo.getLanguageName().equals(xtextEditor.getLanguageName())) {
				IXtextDocument xtextDocument = xtextEditor.getDocument();

				ModelContainer modelContainer = xtextDocument.readOnly(
						new IUnitOfWork<ModelContainer, XtextResource>(){
						       public ModelContainer exec(XtextResource resource) {
						    	   EList<EObject> contents = resource.getContents();
						    	   if (contents.isEmpty()) {
						    		   return null;
						    	   }
						    	   else {
						    		   return (ModelContainer) contents.get(0);
						    	   }
						       }
						 }
				);

				if (modelContainer == null) {
					return null;
				} else {
					ResourceSet resourceSet = modelContainer.eResource().getResourceSet();
					String result = erModelPlantUMLConverter.convertToPlantUML(resourceSet).toString();
					return result;
				}
			}
		}

		return DiagramTextProvider.super.getDiagramText(editorPart, selection);
	}
}