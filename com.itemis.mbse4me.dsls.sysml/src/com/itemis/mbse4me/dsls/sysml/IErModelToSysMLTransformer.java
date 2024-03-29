package com.itemis.mbse4me.dsls.sysml;

import java.io.IOException;
import java.util.List;

import org.eclipse.core.resources.IProject;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.uml2.uml.Model;

import com.itemis.mbse4me.dsls.erModel.ModelContainer;
import com.itemis.mbse4me.dsls.requirement.Requirement;

public interface IErModelToSysMLTransformer {

	Model transform(List<ModelContainer> modelsToTransform, List<Requirement> requirements, IProject modelingProject, String outputModelName, IProgressMonitor progressMonitor) throws IOException;

}
