package com.itemis.mbse4me.dsls.importer;

import java.util.Iterator;
import java.util.Map;
import java.util.TreeMap;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;

import com.itemis.mbse4me.dsls.erModel.Assembly;
import com.itemis.mbse4me.dsls.erModel.AssemblyUsage;
import com.itemis.mbse4me.dsls.erModel.Component;
import com.itemis.mbse4me.dsls.erModel.ComponentUsage;
import com.itemis.mbse4me.dsls.erModel.ErModelFactory;
import com.itemis.mbse4me.dsls.erModel.Product;

public class CADDataExcelFileReader extends AbstractExcelFileReader {

	private ErModelFactory modellFactory;

	private Map<String, Product> products;
	private Map<String, Assembly> assemblies;
	private Map<String, Component> components;

	public CADDataExcelFileReader() {
		modellFactory = ErModelFactory.eINSTANCE;

		products = new TreeMap<>();
		assemblies = new TreeMap<>();
		components = new TreeMap<>();
	}

	@Override
	public Object readDataFrom(String excelFilePath) {
		Workbook workbook = openExcelFile(excelFilePath);

		if (workbook != null) {
			readComponentsSheet(workbook);
			readAssembliesSheet(workbook);
			readUsedComponentsSheet(workbook);
			readProductsSheet(workbook);
			readUsedAssembliesSheet(workbook);
		}

		return null;
	}

	private void readComponentsSheet(Workbook workbook) {
		Sheet sheet = workbook.getSheet("Components");

		Iterator<Row> rowIterator = sheet.iterator();

		// die Titelzeile überspringen
		skipRows(rowIterator, 1);

		while (rowIterator.hasNext()) {

			Row row = rowIterator.next();

			Cell IDCell = row.getCell(getExcelColumnNumber("A"));
			String ID = IDCell.getStringCellValue();

			Cell nameCell = row.getCell(getExcelColumnNumber("B"));
			String name = nameCell.getStringCellValue();

			if (components.containsKey(ID)) {
				System.err.println("There is an already existing component with the ID: " + ID + " !");
			} else {
				Component component = createComponent(ID, name);
				components.put(ID, component);
			}
		}
	}

	private void readAssembliesSheet(Workbook workbook) {
		Sheet sheet = workbook.getSheet("Assemblies");

		Iterator<Row> rowIterator = sheet.iterator();

		// die Titelzeile überspringen
		skipRows(rowIterator, 1);

		while (rowIterator.hasNext()) {

			Row row = rowIterator.next();

			Cell IDCell = row.getCell(getExcelColumnNumber("A"));
			String ID = IDCell.getStringCellValue();

			Cell nameCell = row.getCell(getExcelColumnNumber("B"));
			String name = nameCell.getStringCellValue();

			if (assemblies.containsKey(ID)) {
				System.err.println("There is an already existing assembly with the ID: " + ID +" !");
			} else {
				Assembly assembly = createAssembly(ID, name);
				assemblies.put(ID, assembly);
			}
		}
	}

	private void readProductsSheet(Workbook workbook) {
		Sheet sheet = workbook.getSheet("Products");

		Iterator<Row> rowIterator = sheet.iterator();

		// die Titelzeile überspringen
		skipRows(rowIterator, 1);

		while (rowIterator.hasNext()) {

			Row row = rowIterator.next();

			Cell IDCell = row.getCell(getExcelColumnNumber("A"));
			String ID = IDCell.getStringCellValue();

			Cell nameCell = row.getCell(getExcelColumnNumber("B"));
			String name = nameCell.getStringCellValue();

			if (products.containsKey(ID)) {
				System.err.println("There is an already existing product with the ID: " + ID +" !");
			} else {
				Product product = createProduct(ID, name);
				products.put(ID, product);
			}
		}
	}

	private void readUsedComponentsSheet(Workbook workbook) {
		Sheet sheet = workbook.getSheet("Used Components");

		Iterator<Row> rowIterator = sheet.iterator();

		// die Titelzeile überspringen
		skipRows(rowIterator, 1);

		while (rowIterator.hasNext()) {

			Row row = rowIterator.next();

			Cell componentIDCell = row.getCell(getExcelColumnNumber("A"));
			String componentID = componentIDCell.getStringCellValue();

			Cell assemblyIDCell = row.getCell(getExcelColumnNumber("B"));
			String assemblyID = assemblyIDCell.getStringCellValue();

			Cell componentCountCell = row.getCell(getExcelColumnNumber("C"));
			int componentCount = (int) componentCountCell.getNumericCellValue();

			Component component = components.get(componentID);
		    Assembly assembly = assemblies.get(assemblyID);

		    if (assembly == null) {
		    	System.err.println("There is no assemlby with the ID " + assemblyID + " !");
		    }
		    if (component == null) {
		    	System.err.println("There is no component with the ID " + componentID + " !");
		    }

		    if (assembly != null && component != null) {
		    	ComponentUsage componentUsage = createComponentUsage(component, componentCount);
		    	assembly.getComponentUsages().add(componentUsage);
		    }
		}
	}

	private void readUsedAssembliesSheet(Workbook workbook) {
		Sheet sheet = workbook.getSheet("Used Assemblies");

		Iterator<Row> rowIterator = sheet.iterator();

		// die Titelzeile überspringen
		skipRows(rowIterator, 1);

		while (rowIterator.hasNext()) {

			Row row = rowIterator.next();

			Cell assemblyIDCell = row.getCell(getExcelColumnNumber("A"));
			String assemblyID = assemblyIDCell.getStringCellValue();

			Cell productIDCell = row.getCell(getExcelColumnNumber("B"));
			String productID = productIDCell.getStringCellValue();

			Cell assemblyCountCell = row.getCell(getExcelColumnNumber("C"));
			int assemblyCount = (int) assemblyCountCell.getNumericCellValue();

		    Product product = products.get(productID);
		    Assembly assembly = assemblies.get(assemblyID);

		    if (product == null) {
		    	System.err.println("There is no product with the ID " + productID + " !");
		    }
		    if (assembly == null) {
		    	System.err.println("There is no assembly with the ID " + assemblyID + " !");
		    }

		    if (product != null && assembly != null) {
		    	AssemblyUsage assemblyUsage = createAssemblyUsage(assembly, assemblyCount);
		    	product.getAssemblyUsages().add(assemblyUsage);
		    }
		}
	}

	private Component createComponent(String ID, String name) {
		Component component = modellFactory.createComponent();
		component.setId(ID);
		component.setName(name);
		return component;
	}

	private Assembly createAssembly(String ID, String name) {
		Assembly assembly = modellFactory.createAssembly();
		assembly.setId(ID);
		assembly.setName(name);
		return assembly;
	}

	private Product createProduct(String ID, String name) {
		Product product = modellFactory.createProduct();
		product.setId(ID);
		product.setName(name);
		return product;
	}

	private ComponentUsage createComponentUsage(Component component, int count) {
		ComponentUsage componentUsage = modellFactory.createComponentUsage();
		componentUsage.setComponent(component);
		componentUsage.setCount(count);
		return componentUsage;
	}

	private AssemblyUsage createAssemblyUsage(Assembly assembly, int count) {
		AssemblyUsage assemblyUsage = modellFactory.createAssemblyUsage();
		assemblyUsage.setAssembly(assembly);
		assemblyUsage.setCount(count);
		return assemblyUsage;
	}

	public Map<String, Component> getComponents() {
		return components;
	}

	public Map<String, Assembly> getAssemblies() {
		return assemblies;
	}

	public Map<String, Product> getProducts() {
		return products;
	}

}
