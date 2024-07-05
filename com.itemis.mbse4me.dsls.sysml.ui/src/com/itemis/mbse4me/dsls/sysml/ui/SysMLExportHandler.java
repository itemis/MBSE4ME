package com.itemis.mbse4me.dsls.sysml.ui;

import java.util.ArrayList;
import java.util.List;

import com.google.inject.name.Named;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.IProject;
import org.eclipse.core.resources.IResource;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.e4.core.di.annotations.Execute;
import org.eclipse.e4.ui.services.IServiceConstants;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.jface.viewers.ITreeSelection;
import org.eclipse.jface.viewers.TreeSelection;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.ui.PlatformUI;
import org.eclipse.xtext.ui.resource.IResourceSetProvider;

import com.itemis.mbse4me.dsls.RequirementStandaloneSetup;
import com.itemis.mbse4me.dsls.erModel.ModelContainer;
import com.itemis.mbse4me.dsls.requirement.Requirement;
import com.itemis.mbse4me.dsls.ui.internal.DslsActivator;

/**
 * <b>Warning</b> : As explained in <a href=
 * "http://wiki.eclipse.org/Eclipse4/RCP/FAQ#Why_aren.27t_my_handler_fields_being_re-injected.3F">this
 * wiki page</a>, it is not recommended to define @Inject fields in a handler.
 * <br/>
 * <br/>
 * <b>Inject the values in the @Execute methods</b>
 */
public class SysMLExportHandler {

	@Execute
	public void execute(@Named(IServiceConstants.ACTIVE_SHELL) Shell s) throws CoreException {

		var activeWorkbenchWindow = PlatformUI.getWorkbench().getActiveWorkbenchWindow();
		if (activeWorkbenchWindow != null) {
			ITreeSelection selection = (TreeSelection) activeWorkbenchWindow.getSelectionService().getSelection();
			IProject selectedProject = (IProject) selection.getFirstElement();
			var modelContainers = getModelContainersFromSelectedProject(selectedProject);
			if (modelContainers.isEmpty()) {
				MessageDialog.openWarning(s, "SysML Export", "No models found!");
				return;
			}
			var requirements = getRequirementsFromSelectedProject(selectedProject);
			var transformationJob = new SysmlTransformerBackgroundJob(s,
					selectedProject.getName() + " SysML Transformation", modelContainers, requirements,
					selectedProject.getName() + "_SysML_Cameo", selectedProject);
			transformationJob.schedule();
		}
	}

	private List<Requirement> getRequirementsFromSelectedProject(IProject project) throws CoreException {
		var retval = new ArrayList<Requirement>();
		RequirementStandaloneSetup setup = new RequirementStandaloneSetup();
		var injector = setup.createInjectorAndDoEMFRegistration();
		var rset = injector.getInstance(ResourceSet.class);
		var requirementsFolder = project.getFolder("requirements");
		if (!requirementsFolder.exists()) {
			return retval;
		}
		for (var file : requirementsFolder.members()) {
			if (file.getFileExtension().equals("requirement")) {
				// get the resources out of the file
				Resource resource = rset.getResource(URI.createURI(file.getFullPath().toString()), true);
				if (!resource.getContents().isEmpty()) {
					var rootNode = resource.getContents().get(0);
					if (rootNode instanceof Requirement reqSpec) {
						retval.add(reqSpec);
					}
				}
			}
		}
		return retval;
	}

	private List<ModelContainer> getModelContainersFromSelectedProject(IProject project) throws CoreException {
		List<ModelContainer> result = new ArrayList<>();
		var injector = DslsActivator.getInstance().getInjector(DslsActivator.COM_ITEMIS_MBSE4ME_DSLS_ERMODEL);
		var resourceSetProvider = injector.getInstance(IResourceSetProvider.class);
		var rset = resourceSetProvider.get(project);
		IResource[] allProjectMembers = project.members();
		for (var member : allProjectMembers) {
			if (member instanceof IFile && member.getFileExtension().equals("ermodel")) {
				// get the resources out of the file
				Resource resource = rset.getResource(URI.createURI(member.getFullPath().toString()), true);
				if (!resource.getContents().isEmpty()) {
					var rootNode = resource.getContents().get(0);
					if (rootNode instanceof ModelContainer modelContainer) {
						result.add(modelContainer);
					}
				}
			}
		}
		return result;
	}
}
