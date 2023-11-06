package com.itemis.mbse4me.dsls.importer;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;

public class RequirementExcelFileReader extends AbstractExcelFileReader {

	private final static String SHEET_NAME = "Requirements";
	private List<String> requirements;

	public RequirementExcelFileReader() {
		requirements = new ArrayList<String>();
	}

	public List<String> readDataFrom(String excelFilePath) {
		Workbook workbook = openExcelFile(excelFilePath);

		if (workbook != null) {
			readRequirementsSheet(workbook);
		}

		return requirements;
	}

	private void readRequirementsSheet(Workbook workbook) {
		Sheet sheet = workbook.getSheet(SHEET_NAME);

		Iterator<Row> rowIterator = sheet.iterator();

		// die Titelzeile überspringen
		skipRows(rowIterator, 1);

		while (rowIterator.hasNext()) {

			Row row = rowIterator.next();

			Cell numberCell = row.getCell(getExcelColumnNumber("A"));
			if (numberCell == null) {
				continue;
			}

			String number = numberCell.getStringCellValue();

			if (number == null || number.isBlank()) {
				continue;
			}

			Cell textCell = row.getCell(getExcelColumnNumber("B"));
			String text = textCell.getStringCellValue();

			String requirement = createRequirementText(number, text);
			requirements.add(requirement);
		}
	}

	private String createRequirementText(String number, String text) {
		StringBuilder sb = new StringBuilder();
		sb.append("Number: \"" + number + "\"" + System.lineSeparator());
		sb.append("Text:'''" + System.lineSeparator());

		text = text.replaceAll("\r?\n", System.lineSeparator());

		sb.append("\t" + text);
		if (!text.endsWith(System.lineSeparator())) {
			sb.append(System.lineSeparator());
		}
		sb.append("'''" + System.lineSeparator());
		return sb.toString();
	}

}
