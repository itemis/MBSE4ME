package com.itemis.mbse4me.dsls.importer;

import java.util.Iterator;
import java.util.Map;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;

import com.itemis.mbse4me.dsls.erModel.Component;
import com.itemis.mbse4me.dsls.utils.UnicodeConstants;

public class PriceDataExcelFileReader extends AbstractExcelFileReader {

	private Map<String, Component> components;

	@Override
	public Object readDataFrom(String excelFilePath) {
		Workbook workbook = openExcelFile(excelFilePath);

		if (workbook != null) {
			readComponentCostsSheet(workbook);
		}

		return null;
	}

	private void readComponentCostsSheet(Workbook workbook) {
		Sheet sheet = workbook.getSheet("Component price");

		Iterator<Row> rowIterator = sheet.iterator();

		// die Titelzeile überspringen
		skipRows(rowIterator, 1);

		while (rowIterator.hasNext()) {

			Row row = rowIterator.next();

			Cell idCell = row.getCell(getExcelColumnNumber("A"));
			String id = idCell.getStringCellValue();

			Cell costCell = row.getCell(getExcelColumnNumber("B"));
			double cost = costCell.getNumericCellValue();

			Component component = components.get(id);
		    if (component == null) {
		    	System.err.println("There is no component with the ID " + id + " !");
		    } else {
	    		component.setPrice(Double.toString(cost) + UnicodeConstants.EURO_SYMBOL);
		    }
		}
	}

	public void setComponents(Map<String, Component> components) {
		this.components = components;
	}
}
