package com.itemis.mbse4me.dsls.ui.wizard

import org.eclipse.xtext.ui.XtextProjectHelper
import org.eclipse.xtext.ui.util.ProjectFactory
import org.eclipse.xtext.ui.wizard.template.IProjectGenerator
import org.eclipse.xtext.ui.wizard.template.IProjectTemplateProvider
import org.eclipse.xtext.ui.wizard.template.ProjectTemplate
import com.itemis.mbse4me.dsls.importer.ExcelImporter

/**
 * Create a list with all project templates to be shown in the template new project wizard.
 *
 * Each template is able to generate one or more projects. Each project can be configured such that any number of files are included.
 */
class ErModelProjectTemplateProvider implements IProjectTemplateProvider {

	override getProjectTemplates() {
		#[new ProjectImportedFromExcel]
	}
}

@ProjectTemplate(label="Excel", icon="project_template.png", description="<p><b>Imported from Excel</b></p>
<p>Wähle eine Excel Datei (*.xlsx aus) ...</p>")
final class ProjectImportedFromExcel {

	String[] excelFilePathStrings = null

	override generateProjects(IProjectGenerator generator) {
		val excelImporter = new ExcelImporter

		excelImporter.importDataFrom(excelFilePathStrings)

		generator.generate(new ProjectFactory => [
			projectName = projectInfo.projectName
			projectDefaultCharset = "UTF-8"
			location = projectInfo.locationPath
			projectNatures += #[XtextProjectHelper.NATURE_ID]
			builderIds += #[XtextProjectHelper.BUILDER_ID]
			addFile('''components.ermodel''', excelImporter.getComponentsModelContainer)
			addFile('''assemblies.ermodel''', excelImporter.getAssembliesModelContainer)
			addFile('''products.ermodel''', excelImporter.getProductsModelContainer)
			var i = 1
			for (requirement : excelImporter.requirements) {
				addFile('''requirements/«i.withLeadingZeros».requirement''', requirement)
				i++
			}
		])
	}

	private def withLeadingZeros(int i) {
		if (i<10) return "00" + i
		if (i<100) return "0" + i
		return i
	}

	def void setExcelFilePathStrings(String[] excelFilePathStrings) {
		this.excelFilePathStrings = excelFilePathStrings
	}

}
