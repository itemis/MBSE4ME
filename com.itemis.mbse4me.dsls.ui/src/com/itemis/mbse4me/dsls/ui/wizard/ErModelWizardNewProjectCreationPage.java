package com.itemis.mbse4me.dsls.ui.wizard;

import org.eclipse.jface.wizard.IWizardPage;
import org.eclipse.swt.SWT;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.FileDialog;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Text;
import org.eclipse.ui.dialogs.WizardNewProjectCreationPage;

public class ErModelWizardNewProjectCreationPage extends WizardNewProjectCreationPage {

	private Text[] excelFilePathGuiTextfields;
	private String[] excelFilePathStrings;

	public ErModelWizardNewProjectCreationPage(String pageName) {
		super(pageName);
		excelFilePathGuiTextfields = new Text[3];
		excelFilePathStrings = new String[3];
	}

	@Override
	public void createControl(Composite parent) {
		super.createControl(parent);

		Control control = getControl();
		if (control instanceof Composite) {
			Composite composite = (Composite) control;
			createExcelFileGUI(composite, 0, "Requirements (*.xlsx):");
			createExcelFileGUI(composite, 1, "CAD Data (*.xlsx):");
			createExcelFileGUI(composite, 2, "Price Data (*.xlsx):");
		}
	}

	private void createExcelFileGUI(Composite parent, int index, String labelText) {
		Composite group = new Composite(parent, SWT.NONE);
		Label label = new Label(group, SWT.NONE);
		label.setText(labelText);

		group.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, false));
		group.setLayout(new GridLayout(3, false));

		Text text = new Text(group, SWT.BORDER);
		GridData data = new GridData(GridData.FILL_HORIZONTAL);
		data.grabExcessHorizontalSpace = true;
		text.setLayoutData(data);
		excelFilePathGuiTextfields[index] = text;

		// browse button
		Button browseButton = new Button(group, SWT.PUSH);
		browseButton.setText("Durchsuchen...");
		GridData buttonGridData = new GridData();
		buttonGridData.widthHint = 150;
		browseButton.setLayoutData(buttonGridData);
		browseButton.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent event) {
				handleLocationBrowseButtonPressed(index);
			}
		});
	}

	/**
	 * Open an appropriate directory browser
	 */
	private void handleLocationBrowseButtonPressed(int index) {
		FileDialog fd = new FileDialog(Display.getCurrent().getActiveShell(), SWT.OPEN);
        fd.setText("Open");
        String filterPath = "C:/";
        if (index != 0) {
        	String previousSelectedFile = excelFilePathStrings[index-1];
        	if (previousSelectedFile != null) {
        		filterPath = previousSelectedFile.substring(0, previousSelectedFile.lastIndexOf("\\"));
        	}
        }
        fd.setFilterPath(filterPath);
        String[] filterExt = { "*.xlsx", "*.xls" };
        fd.setFilterExtensions(filterExt);
        String selected = fd.open();
        if (selected != null) {
        	excelFilePathGuiTextfields[index].setText(selected);
        	excelFilePathStrings[index] = selected;
        }
	}

	public String[] getExcelFilePathStrings() {
		return excelFilePathStrings;
	}

	@Override
	public IWizardPage getNextPage() {
		return null;
	}
}
