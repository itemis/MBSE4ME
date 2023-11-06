package com.itemis.mbse4me.dsls.sysml.profiles;

import java.net.URL;

import org.eclipse.core.runtime.Platform;
import org.osgi.framework.Bundle;

public class CameoSysMLProfileConstants {
	public static final String PLUGIN_ID = "com.itemis.mbse4me.dsls.sysml";
	public static final String SYSML_PROFILE_NAME = "SysML";
	public static final String IMPAKT_PROFILE_NAME = "SysML4ImPaKT_Extension";

	public static final String SYSML_PROFILE_FILE = "SysML.profile.uml";
	public static final String SYSML_STANDARD_PROFILE_EXTENSION1_FILE = "UML_Standard_Profile.MagicDraw_Profile.DSL_Customization.profile.uml";
	public static final String SYSML_STANDARD_PROFILE_EXTENSION2_FILE = "UML_Standard_Profile.MagicDraw_Profile.profile.uml";
	public static final String SYSML_STANDARD_PROFILE_EXTENSION3_FILE = "UML_Standard_Profile.Validation_Profile.profile.uml";

	public static final String CAMEO_AUXILIARY_PROFILE1_FILE = "MD_Customization_for_Requirements.additional_stereotypes.profile.uml";
	public static final String CAMEO_AUXILIARY_PROFILE2_FILE = "MD_Customization_for_SysML.additional_stereotypes.profile.uml";
	public static final String CAMEO_AUXILIARY_PROFILE3_FILE = "MD_Customization_for_SysML.analysis_patterns.profile.uml";
	public static final String CAMEO_AUXILIARY_PROFILE4_FILE = "MD_Customization_for_SysML.customizations_for_traceability.profile.uml";
	public static final String CAMEO_AUXILIARY_PROFILE5_FILE = "MD_Customization_for_SysML.SysML_constraints.profile.uml";
	public static final String CAMEO_AUXILIARY_PROFILE6_FILE = "MD_Customization_for_SysML.sysphs_profile.profile.uml";
	public static final String CAMEO_AUXILIARY_PROFILE7_FILE = "UML_Standard_Profile.Dependency_Matrix_Profile.profile.uml";
	public static final String CAMEO_AUXILIARY_PROFILE8_FILE = "UML_Standard_Profile.MagicDraw_Profile.Find_By_Text.profile.uml";
	public static final String CAMEO_AUXILIARY_PROFILE9_FILE = "UML_Standard_Profile.MagicDraw_Profile.Traceability_customization.profile.uml";

	public static final String IMPAKT_PROFILE_FILE = "SysML4ImPaKT_Extension.profile.uml";


	public static final Bundle TEST_MODEL_BUNDLE = Platform.getBundle(PLUGIN_ID);
	public static final URL SYSML_STANDARD_PROFILE_URL = TEST_MODEL_BUNDLE.getEntry("/resources/cameo/" + SYSML_PROFILE_FILE);
	public static final URL IMPAKT_PROFILE_URL = TEST_MODEL_BUNDLE.getEntry("/resources/cameo/" + IMPAKT_PROFILE_FILE);
	public static final URL SYSML_STANDARD_PROFILE_EXTENSION1_URL = TEST_MODEL_BUNDLE.getEntry("/resources/cameo/" + SYSML_STANDARD_PROFILE_EXTENSION1_FILE);
	public static final URL SYSML_STANDARD_PROFILE_EXTENSION2_URL = TEST_MODEL_BUNDLE.getEntry("/resources/cameo/" + SYSML_STANDARD_PROFILE_EXTENSION2_FILE);
	public static final URL SYSML_STANDARD_PROFILE_EXTENSION3_URL = TEST_MODEL_BUNDLE.getEntry("/resources/cameo/" + SYSML_STANDARD_PROFILE_EXTENSION3_FILE);


	public static final URL  CAMEO_AUXILIARY_PROFILE1_URL = TEST_MODEL_BUNDLE.getEntry("/resources/cameo/" + CAMEO_AUXILIARY_PROFILE1_FILE);
	public static final URL  CAMEO_AUXILIARY_PROFILE2_URL = TEST_MODEL_BUNDLE.getEntry("/resources/cameo/" + CAMEO_AUXILIARY_PROFILE2_FILE);
	public static final URL  CAMEO_AUXILIARY_PROFILE3_URL = TEST_MODEL_BUNDLE.getEntry("/resources/cameo/" + CAMEO_AUXILIARY_PROFILE3_FILE);
	public static final URL  CAMEO_AUXILIARY_PROFILE4_URL = TEST_MODEL_BUNDLE.getEntry("/resources/cameo/" + CAMEO_AUXILIARY_PROFILE4_FILE);
	public static final URL  CAMEO_AUXILIARY_PROFILE5_URL = TEST_MODEL_BUNDLE.getEntry("/resources/cameo/" + CAMEO_AUXILIARY_PROFILE5_FILE);
	public static final URL  CAMEO_AUXILIARY_PROFILE6_URL = TEST_MODEL_BUNDLE.getEntry("/resources/cameo/" + CAMEO_AUXILIARY_PROFILE6_FILE);
	public static final URL  CAMEO_AUXILIARY_PROFILE7_URL = TEST_MODEL_BUNDLE.getEntry("/resources/cameo/" + CAMEO_AUXILIARY_PROFILE7_FILE);
	public static final URL  CAMEO_AUXILIARY_PROFILE8_URL = TEST_MODEL_BUNDLE.getEntry("/resources/cameo/" + CAMEO_AUXILIARY_PROFILE8_FILE);
	public static final URL  CAMEO_AUXILIARY_PROFILE9_URL = TEST_MODEL_BUNDLE.getEntry("/resources/cameo/" + CAMEO_AUXILIARY_PROFILE9_FILE);
}

