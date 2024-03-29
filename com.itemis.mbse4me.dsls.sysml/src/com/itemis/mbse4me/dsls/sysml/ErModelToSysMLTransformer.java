package com.itemis.mbse4me.dsls.sysml;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.eclipse.core.resources.IProject;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.uml2.uml.Class;
import org.eclipse.uml2.uml.Model;
import org.eclipse.uml2.uml.Package;

import com.itemis.mbse4me.dsls.erModel.Assembly;
import com.itemis.mbse4me.dsls.erModel.Component;
import com.itemis.mbse4me.dsls.erModel.ModelContainer;
import com.itemis.mbse4me.dsls.erModel.Product;
import com.itemis.mbse4me.dsls.requirement.Requirement;
import com.itemis.mbse4me.dsls.sysml.profiles.CameoProfileUtils;
import com.itemis.mbse4me.dsls.utils.UnicodeConstants;

public class ErModelToSysMLTransformer implements IErModelToSysMLTransformer {

	private List<ModelContainer> modelContainersToTransform;
	private List<Requirement> requirementsToTransform;

	public Model transform(List<ModelContainer> modelsToTransform, List<Requirement> requirements, IProject modelingProject, String outputModelName, IProgressMonitor progressMonitor) throws IOException {
		this.modelContainersToTransform = modelsToTransform;
		this.requirementsToTransform = requirements;

		progressMonitor.beginTask("Copying Cameo Profiles and creating models", 100);
		Model transformedModel = CameoProfileUtils.createModelAndCopyProfiles(modelingProject, outputModelName);
		progressMonitor.worked(20);
		progressMonitor.setTaskName("Transforming model elements");
		doTransform(modelContainersToTransform, transformedModel, progressMonitor);
		progressMonitor.worked(80);
		progressMonitor. setTaskName("Saving SysML model");
		final HashMap<Object, Object> saveOptions = new HashMap<Object, Object>();
		saveOptions.put(Resource.OPTION_LINE_DELIMITER, Resource.OPTION_LINE_DELIMITER_UNSPECIFIED);
		transformedModel.eResource().save(saveOptions);
		progressMonitor.worked(100);

		return transformedModel;
	}

	private void doTransform(List<ModelContainer> containers, Model transformedModel, IProgressMonitor monitor) {
		// first, collect all the elements from all model containers
		List<Component> components = containers.stream().flatMap(container -> container.getComponents().stream()).toList();
		List<Assembly> assemblies = containers.stream().flatMap(container -> container.getAssemblies().stream()).toList();
		List<Product> products = containers.stream().flatMap(container -> container.getProducts().stream()).toList();
		// create package structure
		var componentsPack = getOrCreateComponentsPackage(transformedModel);
		var assembliesPack = getOrCreateAssembliesPackage(transformedModel);
		var productsPack = getOrCreateProductsPackage(transformedModel);
		var requirementsPack = transformedModel.createNestedPackage("Requirements");
		monitor.setTaskName("Creating Requirements");
		requirementsToTransform.stream().forEach(requirement -> {
			var reqId = requirement.getNumber();
			var reqText = requirement.getText().replace("'''", "").trim();
			var reqClass = requirementsPack.createOwnedClass(String.format("Requirement_%s", reqId), false);
			reqClass.createOwnedAttribute("Requirement Text", null).setStringDefaultValue(reqText);
			CameoProfileUtils.applySysMLStereotype(reqClass, "Block");
		});
		monitor.setTaskName("Creating components");
		Map<Component, Class> componentsToSysmlBlocks = new HashMap<>();
		Map<Assembly, Class> assembliesToSysmlBlocks = new HashMap<>();
		Map<Assembly, Double> assembliesToComputedPrice = new HashMap<>();
		components.forEach(component -> {
			var createdComponent = componentsPack.createOwnedClass(component.getName(), false);
			createdComponent.createOwnedAttribute("PLM_ID", null).setStringDefaultValue(component.getId());
			createdComponent.createOwnedAttribute("Price", null).setStringDefaultValue(component.getPrice());
			CameoProfileUtils.applySysMLStereotype(createdComponent, "Block");
			componentsToSysmlBlocks.put(component, createdComponent);
		});
		monitor.worked(40);
		monitor.setTaskName("Creating assemblies");
		assemblies.forEach(assembly -> {
			var createdAssembly = assembliesPack.createOwnedClass(assembly.getName(), false);
			createdAssembly.createOwnedAttribute("PLM_ID", null).setStringDefaultValue(assembly.getId());
			CameoProfileUtils.applySysMLStereotype(createdAssembly, "Block");
			// get the components included in this assembly
			assembly.getComponentUsages().stream().forEach(usedComponent -> {
				var sysmlComponent = componentsToSysmlBlocks.get(usedComponent.getComponent());
				if (sysmlComponent != null) {
					createdAssembly.createUsage(sysmlComponent).createOwnedComment().setBody(usedComponent.getCount() + " Pcs");
				}
			});
			var assemblyPrice = assembly.getComponentUsages().stream().map(componentUsage -> {
				var priceString = componentUsage.getComponent().getPrice();
				priceString = priceString.replace(UnicodeConstants.EURO_SYMBOL, "");
				return Double.parseDouble(priceString) * componentUsage.getCount();
			}).reduce((double) 0, (subtotal, price) -> subtotal + price);
			assemblyPrice = round(assemblyPrice);
			assembliesToComputedPrice.put(assembly, assemblyPrice);
			createdAssembly.createOwnedAttribute("Price", null).setStringDefaultValue(assemblyPrice.toString() + UnicodeConstants.EURO_SYMBOL);
			assembliesToSysmlBlocks.put(assembly, createdAssembly);
		});
		monitor.worked(60);
		monitor.setTaskName("Creating products");
		products.forEach(product -> {
			var createdProduct = productsPack.createOwnedClass(product.getName(), false);
			CameoProfileUtils.applySysMLStereotype(createdProduct, "Block");
			createdProduct.createOwnedAttribute("PLM_ID", null).setStringDefaultValue(product.getId());
			var productPrice = product.getAssemblyUsages().stream().map(assemblyUsage -> assembliesToComputedPrice.get(assemblyUsage.getAssembly())).reduce((double) 0, (subtotal, price) -> subtotal + price);
			productPrice = round(productPrice);
			createdProduct.createOwnedAttribute("Price", null).setStringDefaultValue(productPrice.toString() + UnicodeConstants.EURO_SYMBOL);
			// get the assemblies included in this product
			product.getAssemblyUsages().stream().forEach(usedAssembly -> {
				var sysmlAssembly = assembliesToSysmlBlocks.get(usedAssembly.getAssembly());
				if (sysmlAssembly != null) {
					createdProduct.createUsage(sysmlAssembly).createOwnedComment().setBody(usedAssembly.getCount() + " Pcs");
				}
			});
		});
	}

	private Package getOrCreateComponentsPackage(Model transformedModel) {
		var pack = transformedModel.getNestedPackage(TransformedModelConstants.COMPONENTS_PACKAGE);
		return pack != null ? pack : transformedModel.createNestedPackage(TransformedModelConstants.COMPONENTS_PACKAGE);
	}

	private Package getOrCreateAssembliesPackage(Model transformedModel) {
		var pack = transformedModel.getNestedPackage(TransformedModelConstants.ASSEMBLIES_PACKAGE);
		return pack != null ? pack : transformedModel.createNestedPackage(TransformedModelConstants.ASSEMBLIES_PACKAGE);
	}

	private Package getOrCreateProductsPackage(Model transformedModel) {
		var pack = transformedModel.getNestedPackage(TransformedModelConstants.PRODUCTS_PACKAGE);
		return pack != null ? pack : transformedModel.createNestedPackage(TransformedModelConstants.PRODUCTS_PACKAGE);
	}

	private double round(double value) {
	    BigDecimal bigDeciaml = new BigDecimal(Double.toString(value));
	    bigDeciaml = bigDeciaml.setScale(2, RoundingMode.HALF_UP);
	    return bigDeciaml.doubleValue();
	}
}
