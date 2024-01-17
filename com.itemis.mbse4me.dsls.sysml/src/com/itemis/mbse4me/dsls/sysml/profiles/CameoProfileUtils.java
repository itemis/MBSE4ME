package com.itemis.mbse4me.dsls.sysml.profiles;

import java.util.function.Predicate;

import org.eclipse.core.resources.IProject;
import org.eclipse.emf.common.util.TreeIterator;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.uml2.uml.Element;
import org.eclipse.uml2.uml.Model;
import org.eclipse.uml2.uml.Profile;
import org.eclipse.uml2.uml.Stereotype;
import org.eclipse.uml2.uml.UMLFactory;

import com.itemis.mbse4me.dsls.sysml.utils.FileUtils;

public class CameoProfileUtils {

	public static Model createModelAndCopyProfiles(IProject project, String modelName) {
		final URI uri = URI.createURI(project.getFile(modelName).getFullPath().toString() + ".uml");
		try {
			copySysMLProfilesToContainer(project);
			final ResourceSetImpl set = new ResourceSetImpl();
			final Resource resource = set.createResource(uri);

			final Model model = UMLFactory.eINSTANCE.createModel();
			model.setName(modelName);
			resource.getContents().add(model);
			final Profile sysmlProfile = getSysMLProfileFromResource(project, set);

			model.applyProfile(sysmlProfile);
			resource.getContents().add(sysmlProfile);

			var newSet = new ResourceSetImpl();
			var reloadedSysmlProfile = getSysMLProfileFromResource(project, newSet);
			model.createPackageImport(reloadedSysmlProfile);
			resource.getContents().add(reloadedSysmlProfile);

			return model;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	private static void copySysMLProfilesToContainer(IProject project) {
		FileUtils.copyFileToContainer(project, CameoSysMLProfileConstants.SYSML_STANDARD_PROFILE_URL, true);
		FileUtils.copyFileToContainer(project, CameoSysMLProfileConstants.SYSML_STANDARD_PROFILE_EXTENSION1_URL, true);
		FileUtils.copyFileToContainer(project, CameoSysMLProfileConstants.SYSML_STANDARD_PROFILE_EXTENSION2_URL, true);
		FileUtils.copyFileToContainer(project, CameoSysMLProfileConstants.SYSML_STANDARD_PROFILE_EXTENSION3_URL, true);

		FileUtils.copyFileToContainer(project, CameoSysMLProfileConstants.CAMEO_AUXILIARY_PROFILE1_URL, true);
		FileUtils.copyFileToContainer(project, CameoSysMLProfileConstants.CAMEO_AUXILIARY_PROFILE2_URL, true);
		FileUtils.copyFileToContainer(project, CameoSysMLProfileConstants.CAMEO_AUXILIARY_PROFILE3_URL, true);
		FileUtils.copyFileToContainer(project, CameoSysMLProfileConstants.CAMEO_AUXILIARY_PROFILE4_URL, true);
		FileUtils.copyFileToContainer(project, CameoSysMLProfileConstants.CAMEO_AUXILIARY_PROFILE5_URL, true);
		FileUtils.copyFileToContainer(project, CameoSysMLProfileConstants.CAMEO_AUXILIARY_PROFILE6_URL, true);
		FileUtils.copyFileToContainer(project, CameoSysMLProfileConstants.CAMEO_AUXILIARY_PROFILE7_URL, true);
		FileUtils.copyFileToContainer(project, CameoSysMLProfileConstants.CAMEO_AUXILIARY_PROFILE8_URL, true);
		FileUtils.copyFileToContainer(project, CameoSysMLProfileConstants.CAMEO_AUXILIARY_PROFILE9_URL, true);
	}

	private static Profile getSysMLProfileFromResource(IProject project, final ResourceSetImpl set) {
		// apply the SyML profile to the entire model
		final URI sysmlProfileUri = URI.createPlatformResourceURI(
				project.getFile(CameoSysMLProfileConstants.SYSML_PROFILE_FILE).getFullPath().toString(), false);
		final Resource profileResource = set.getResource(sysmlProfileUri, true);
		final Profile profile = find(profileResource, Profile.class,
				p -> CameoSysMLProfileConstants.SYSML_PROFILE_NAME.equals(p.getName()));
		return profile;
	}

	public static Stereotype applySysMLStereotype(Element element, String stereotypeToApply) {
		// get the SysML profile
		Model model = (Model) element.eResource().getContents().get(0);
		var appliedSysMLProfile = model.getAllAppliedProfiles().stream()
				.filter(p -> p.getName().equals(CameoSysMLProfileConstants.SYSML_PROFILE_NAME)).findFirst()
				.orElse(null);
		element.getNearestPackage().applyProfile(appliedSysMLProfile);
		var stereotype = find(appliedSysMLProfile, Stereotype.class, s -> stereotypeToApply.equals(s.getName()));
		element.applyStereotype(stereotype);
		return stereotype;
	}

	private static <T extends EObject> T find(Object o, java.lang.Class<T> clazz, Predicate<T> predicate) {
		final TreeIterator<EObject> iter = o instanceof Resource resource ? resource.getAllContents()
				: o instanceof EObject eObject ? eObject.eAllContents() : null;
		while (iter != null && iter.hasNext()) {
			final EObject obj = iter.next();
			if (clazz.isInstance(obj) && predicate.test(clazz.cast(obj)))
				return clazz.cast(obj);
		}
		return null;
	}

}
