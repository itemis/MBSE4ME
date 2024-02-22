# MBSE4ME
The open source **MBSE4ME** (Model-based Systems Engineering for Mechanical Engineering) project aims to demonstrate the use case where unstructured customer data stored in excel files are transformed into structured SysML models.

The project has been demonstrated on the [TDSE (Tag des Systems Engineerings)](https://www.tdse.org/) in 2023.

# Starting the application:
To start the application, open the [mbse4me.product](com.itemis.mbse4me.dsls.product/mbse4me.product) file and click on the `Launch an Eclipse application` button. In the runtime Eclipse application, create a new ErModel project, enter a project name and select the locations of the excel files. Such excel files containing test data are located in the [com.itemis.mbse4me.dsls.tests/resources](com.itemis.mbse4me.dsls.tests/resources) folder. 
	
![001](https://github.com/itemis/MBSE4ME/assets/20393472/fe52e20b-310c-4455-9215-0ed9ca603818)
	
After clicking on the `Finish` button, the new project shows up in the `Project Explorer`. The project contains different files, that can be opened one-by-one in the editor area, are shown on the `Outline` view in a tree structure and can be visualized graphically on the `PlantUML` view.
	
![002](https://github.com/itemis/MBSE4ME/assets/20393472/cd137afe-de63-4f49-9662-8a19774da4d2)
	
These data can be converted into SysML models by invoking the `SysML Export` function on the context menu of the project in the `Project Explorer`.
	
# Exporting the application:	
To be able to use it as a standalone application (without the development environment), use the `Eclipse Product export wizard` button on the [mbse4me.product](com.itemis.mbse4me.dsls.product/mbse4me.product) page.

