package com.itemis.mbse4me.dsls.sysml.ui;

import java.util.List;

import org.eclipse.core.resources.IProject;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.Status;
import org.eclipse.core.runtime.jobs.Job;
import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Shell;

import com.itemis.mbse4me.dsls.erModel.ModelContainer;
import com.itemis.mbse4me.dsls.requirement.Requirement;
import com.itemis.mbse4me.dsls.sysml.ErModelSysmlTransformer;
import com.itemis.mbse4me.dsls.sysml.IErModelToSysMLTransformer;

public class SysmlTransformerBackgroundJob extends Job {

	private final List<ModelContainer> modelContainers;
	private final List<Requirement> requirements;
	private final String outputModelName;
	private final IProject modellingProject;
	private final Shell s;

	private IStatus operationStatus;

	public IStatus getOperationStatus() {
		return operationStatus;
	}

	public SysmlTransformerBackgroundJob(Shell s, String name, List<ModelContainer> modelContainers,
			List<Requirement> requirements,
			String outputModelName, IProject modellingProject) {
		super(name);
		this.modelContainers = modelContainers;
		this.outputModelName = outputModelName;
		this.modellingProject = modellingProject;
		this.requirements = requirements;
		this.s = s;
	}

	@Override
	protected IStatus run(IProgressMonitor monitor) {
		IErModelToSysMLTransformer sysmlTransformer = new ErModelSysmlTransformer();
		try {
			sysmlTransformer.transform(modelContainers, requirements, modellingProject, outputModelName, monitor);
			operationStatus = Status.OK_STATUS;
			Display.getDefault().syncExec(new Runnable() {

				@Override
				public void run() {
					MessageDialog.openInformation(s, "SysML Export successful", "SysML Export is successful!");
				}
			});

		} catch (Exception e) {
			Display.getDefault().syncExec(new Runnable() {

				@Override
				public void run() {
					MessageDialog.openError(s, "SysML model could not be saved", "SysML Export failed:\n" + e.toString());
				}
			});
			e.printStackTrace();
			operationStatus = Status.error(e.getMessage());
		}
		return operationStatus;
	}
}
