package com.itemis.mbse4me.dsls.ui.tests

import com.google.inject.Inject
import com.google.inject.Provider
import com.itemis.mbse4me.dsls.ui.wizard.ErModelTemplateNewProjectWizard
import com.itemis.mbse4me.dsls.ui.wizard.ProjectImportedFromExcel
import org.eclipse.jface.viewers.StructuredSelection
import org.eclipse.jface.wizard.Wizard
import org.eclipse.jface.wizard.WizardDialog
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.ui.testing.AbstractWorkbenchTest
import org.eclipse.xtext.ui.wizard.template.NewProjectWizardTemplateSelectionPage
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith

import static org.eclipse.xtext.ui.testing.util.IResourcesSetupUtil.*

/**
 * Test cases for the {@link com.itemis.mbse4me.dsls.ui.wizard.ErModelTemplateNewProjectWizard} class.
 */
@ExtendWith(InjectionExtension)
@InjectWith(ErModelUiInjectorProvider)
class ErModelNewProjectWizardTest extends AbstractWorkbenchTest {

	val static excelFilePathStrings = #[
		"..\\com.itemis.mbse4me.dsls.tests\\resources\\Requirements_001.xlsx",
		"..\\com.itemis.mbse4me.dsls.tests\\resources\\CAD_Data_001.xlsx",
		"..\\com.itemis.mbse4me.dsls.tests\\resources\\Price_Data_001.xlsx"
	]

	@Inject Provider<ErModelTestableNewProjectWizard> wizardProvider

	val static PROJECT_NAME = "TestProjekt"

	val TIMEOUT = 500

	@Test def test001() {
		// Given
		assertWorkspaceIsEmpty

		// When
		val wizard = wizardProvider.get
		wizard.init(workbench, new StructuredSelection)
		wizard.createAndFinishWizardDialog

		// Then
		val project = root.getProject(PROJECT_NAME)
		Assertions.assertTrue(project.exists)
		waitForBuild
		assertNoErrorsInWorkspace
	}

	@Test def test002() {
		val wizard = wizardProvider.get
		wizard.init(workbench, new StructuredSelection)
		wizard.assertTemplate("Excel", "<p><b>Imported from Excel</b></p> <p>Wähle eine Excel Datei (*.xlsx aus) ...</p>")
	}

	/**
	 * Create the wizard dialog, open it and press Finish.
	 */
	private def createAndFinishWizardDialog(Wizard wizard) {
		val dialog = new WizardDialog(wizard.shell, wizard) {
			override open() {
				val thread = new Thread("Press Finish") {
					override run() {
						// wait for the shell to become active
						var attempt = 0
						while (shell === null && (attempt++) < 5) {
							println("Waiting for shell to become active")
							Thread.sleep(TIMEOUT)
						}
						shell.display.syncExec[
							val page = wizard.getPage("templateNewProjectPage")
							val templateSelectionPage = page as NewProjectWizardTemplateSelectionPage
							val projectImportedFromExcelTemplate = templateSelectionPage.selectedTemplate as ProjectImportedFromExcel
							projectImportedFromExcelTemplate.excelFilePathStrings = excelFilePathStrings

							wizard.performFinish
							shell.close
						]
						attempt = 0
						while (shell !== null && (attempt++) < 5) {
							println("Waiting for shell to be disposed")
							Thread.sleep(TIMEOUT)
						}
					}
				}
				thread.start
				super.open
			}
		}

		dialog.open
	}

	/**
	 * Create the wizard dialog, open it, press Next to navigate to the template selection page, verifies its label and description and press Finish.
	 */
	var actualTemplateLabel = null
	var actualTemplateDescription = null
	private def assertTemplate(Wizard wizard, String expectedTemplateLabel, String expectedTemplateDescription) {
		val dialog = new WizardDialog(wizard.shell, wizard) {
			override open() {
				val thread = new Thread("Press Finish") {
					override run() {
						// wait for the shell to become active
						var attempt = 0
						while (shell === null && (attempt++) < 5) {
							println("Waiting for shell to become active")
							Thread.sleep(TIMEOUT)
						}
						shell.display.syncExec[
							val templateSelectionPage = wizard.getNextPage(wizard.startingPage) as NewProjectWizardTemplateSelectionPage
							templateSelectionPage.showPage
							val selectedTemplate = templateSelectionPage.selectedTemplate
							actualTemplateLabel = selectedTemplate.label
							actualTemplateDescription = selectedTemplate.description

							val ProjectImportedFromExcel projectImportedFromExcelTemplate = selectedTemplate as ProjectImportedFromExcel
							projectImportedFromExcelTemplate.excelFilePathStrings = excelFilePathStrings

							wizard.performFinish
							shell.close
						]
						attempt = 0
						while (shell !== null && (attempt++) < 5) {
							println("Waiting for shell to be disposed")
							Thread.sleep(TIMEOUT)
						}
					}
				}
				thread.start
				super.open
			}
		}

		dialog.open

		Assertions.assertEquals(expectedTemplateLabel, actualTemplateLabel)
		Assertions.assertEquals(expectedTemplateDescription, actualTemplateDescription)
	}

	private def assertWorkspaceIsEmpty() {
		Assertions.assertTrue(root.projects.isEmpty)
	}

	/**
	 * Manually set the project name (usually set in the wizard dialog).
	 */
	static class ErModelTestableNewProjectWizard extends ErModelTemplateNewProjectWizard {

		override getProjectInfo() {
			val projectInfo = super.projectInfo
			projectInfo.setProjectName(PROJECT_NAME)
			projectInfo
		}
	}

}