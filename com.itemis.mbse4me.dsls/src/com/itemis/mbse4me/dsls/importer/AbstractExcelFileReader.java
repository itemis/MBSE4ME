package com.itemis.mbse4me.dsls.importer;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.Iterator;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public abstract class AbstractExcelFileReader {

	public abstract Object readDataFrom(String excelFilePath);

	protected Workbook openExcelFile(String fileName) {
		Workbook workbook = null;
		try (FileInputStream fileInputStream = new FileInputStream(fileName)) {
			workbook = new XSSFWorkbook(fileInputStream);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return workbook;
	}

    protected int getExcelColumnNumber(String column) {
        int result = 0;
        for (int i = 0; i < column.length(); i++) {
            result *= 26;
            result += column.charAt(i) - 'A' + 1;
        }
        return result - 1;
    }

	protected void skipRows(Iterator<Row> iterator, int count) {
		for (int i=0; i<count; i++) {
			iterator.next();
		}
	}

}
