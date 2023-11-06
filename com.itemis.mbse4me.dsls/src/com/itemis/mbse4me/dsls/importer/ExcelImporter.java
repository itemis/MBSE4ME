package com.itemis.mbse4me.dsls.importer;

import java.util.List;
import java.util.Map;

import com.itemis.mbse4me.dsls.erModel.Assembly;
import com.itemis.mbse4me.dsls.erModel.AssemblyUsage;
import com.itemis.mbse4me.dsls.erModel.Component;
import com.itemis.mbse4me.dsls.erModel.ComponentUsage;
import com.itemis.mbse4me.dsls.erModel.Product;

public class ExcelImporter {

	private RequirementExcelFileReader requirementExcelFileReader;
	private CADDataExcelFileReader cadDataExcelFileReader;
	private PriceDataExcelFileReader priceDataExcelFileReader;

	private Map<String, Component> components;
	private Map<String, Assembly> assemblies;
	private Map<String, Product> products;

	private String componentsModelContainer;
	private String assembliesModelContainer;
	private String productsModelContainer;
	private List<String> requirements;

	public ExcelImporter() {
		requirementExcelFileReader = new RequirementExcelFileReader();
		cadDataExcelFileReader = new CADDataExcelFileReader();
		priceDataExcelFileReader = new PriceDataExcelFileReader();
	}

	public void importDataFrom(String[] excelFilePathStrings) {
		String reqSpecExcelFile = excelFilePathStrings[0];
		requirements = requirementExcelFileReader.readDataFrom(reqSpecExcelFile);

		String cadDatenExcelFile = excelFilePathStrings[1];
		cadDataExcelFileReader.readDataFrom(cadDatenExcelFile);
		components = cadDataExcelFileReader.getComponents();
		assemblies = cadDataExcelFileReader.getAssemblies();
		products = cadDataExcelFileReader.getProducts();

		String priceDatenExcelFile = excelFilePathStrings[2];
		priceDataExcelFileReader.setComponents(components);
		priceDataExcelFileReader.readDataFrom(priceDatenExcelFile);

		createComponentsModelContainerText();
		createAssembliesModelContainerText();
		createProductsModelContainerText();
	}

	private void createComponentsModelContainerText() {
		StringBuilder sb = new StringBuilder();
		sb.append("Components {" + System.lineSeparator());

		for (Component component: components.values()) {
			sb.append("\tComponent \"" + component.getName() + "\" ID \"" + component.getId() + "\" costs \"" + component.getPrice() + "\"," + System.lineSeparator());
		}

		sb.deleteCharAt(sb.length() - 3); // delete the last unnecessary comma

		sb.append("}" + System.lineSeparator());

		componentsModelContainer = sb.toString();
	}

	private void createAssembliesModelContainerText() {
		StringBuilder sb = new StringBuilder();
		sb.append("Assemblies {" + System.lineSeparator());

		for (Assembly assembly: assemblies.values()) {
			sb.append("\tAssembly \"" + assembly.getName() + "\" ID \"" + assembly.getId() + "\" uses {" + System.lineSeparator());
			sb.append("\t\t");
			for (ComponentUsage componentUsage : assembly.getComponentUsages()) {
				sb.append(componentUsage.getCount() + " pieces of \"" + componentUsage.getComponent().getId() + "\", ");
			}
			sb.deleteCharAt(sb.length() - 1); // delete the last unnecessary whitespace
			sb.deleteCharAt(sb.length() - 1); // delete the last unnecessary comma
			sb.append(System.lineSeparator());

			sb.append("\t}," + System.lineSeparator());
		}

		sb.deleteCharAt(sb.length() - 3); // delete the last unnecessary comma

		sb.append("}" + System.lineSeparator());

		assembliesModelContainer = sb.toString();
	}

	private void createProductsModelContainerText() {
		StringBuilder sb = new StringBuilder();
		sb.append("Products {" + System.lineSeparator());

		for (Product product: products.values()) {
			sb.append("\tProduct \"" + product.getName() + "\" ID \"" + product.getId() + "\" uses {" + System.lineSeparator());
			sb.append("\t\t");
			for (AssemblyUsage assemblyUsage : product.getAssemblyUsages()) {
				sb.append(assemblyUsage.getCount() + " pieces of \"" + assemblyUsage.getAssembly().getId() + "\", ");
			}
			sb.deleteCharAt(sb.length() - 1); // delete the last unnecessary whitespace
			sb.deleteCharAt(sb.length() - 1); // delete the last unnecessary comma
			sb.append(System.lineSeparator());

			sb.append("\t}," + System.lineSeparator());
		}

		sb.deleteCharAt(sb.length() - 3); // delete the last unnecessary comma

		sb.append("}" + System.lineSeparator());

		productsModelContainer = sb.toString();
	}

	public String getComponentsModelContainer() {
		return componentsModelContainer;
	}

	public String getAssembliesModelContainer() {
		return assembliesModelContainer;
	}

	public String getProductsModelContainer() {
		return productsModelContainer;
	}

	public List<String> getRequirement() {
		return requirements;
	}
}
