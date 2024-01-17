package com.itemis.mbse4me.dsls.ui.wizard;

import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.ui.dialogs.WizardNewProjectCreationPage;
import org.eclipse.xtext.ui.wizard.IProjectInfo;
import org.eclipse.xtext.ui.wizard.template.AbstractProjectTemplate;
import org.eclipse.xtext.ui.wizard.template.TemplateNewProjectWizard;
import org.eclipse.xtext.ui.wizard.template.TemplateProjectInfo;

public class ErModelTemplateNewProjectWizard extends TemplateNewProjectWizard {

	private ErModelWizardNewProjectCreationPage mainPage;

	protected WizardNewProjectCreationPage createMainPage(String pageName) {
		mainPage = new ErModelWizardNewProjectCreationPage(pageName);
		return mainPage;
	}

	protected void doFinish(final IProjectInfo projectInfo, final IProgressMonitor monitor) {
		TemplateProjectInfo templateProjectInfo = (TemplateProjectInfo) projectInfo;
		AbstractProjectTemplate projectTemplate = templateProjectInfo.getProjectTemplate();
		if (projectTemplate instanceof ProjectImportedFromExcel) {
			ProjectImportedFromExcel projectImportedFromExcel = (ProjectImportedFromExcel) projectTemplate;

			String[] excelFilePathStrings = mainPage.getExcelFilePathStrings();

			if (!containsNull(excelFilePathStrings) && excelFilePathStrings.length !=0) {
				projectImportedFromExcel.setExcelFilePathStrings(excelFilePathStrings);
			}
				super.doFinish(projectInfo, monitor);				
			

		}
	}

	private boolean containsNull(String[] array) {
		for(String s : array) {
			if (s == null) {
				return true;
			}
		}
		return false;
	}

}
