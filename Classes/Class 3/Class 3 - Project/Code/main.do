********************************************************************************
********************************************************************************

*	Universitat de Barcelona
*	UB School of Economics
*	MSc in Economics
*	Introduction to Stata & MATLAB (Stata)
*	Salvatore Viola (sviola@ub.edu)
*	October 31, 2025

********************************************************************************
********************************************************************************
/*
			Advanced topics and project management

So far in calss we have used the Stata -cd- command in order to set the working
directory of our session to tell Stata where to look for and save files on our 
devices. This is a core element of using Stata and any other 
programming/scripting language/software. While having one simple lcoation is 
useful, projects often become quite large and combine any number of different 
dataset and scripting files as well as generate a numerous graphs and figures. 
This file will give you an overview of some of the best practices for larger 
project management that will not only make them more understandable by others, 
but also help to organize projects as they become more complex.

Specifically, this file will cover the following concepts:

	1. Using global values to create multiple "paths" (or locations) to 
	different folders within a project
	
	2. Using paths to store and access data and figures in different places
	
	3. Creating a "main" .do file to run external scripts (.do files)
	
	
Here is an overview of the structure of this classes folder:
(the forward slashes "/" indicate that the object is a folder)

	__Intro to Stata - Class 3/
		|
		|__Data/
		|	|__placeholder.dta
		|
		|__Code/
		|	|__main.do
		|	|__load_data.do
		|	|__figures.do
		|	|__tables.do
		|
		|__Output/
			|
			|__Tables/
			|	|__placeholder.doc
			|
			|__Figures/
				|__placeholder.png
				

Notice here we have our master folder which is the "Intro to Stata - Class 3"
Within this folder we have 3 subfolders "Data", "Code", and "Output" which 
contains another two folders "Tables" and "Figures". This structure reflects the
structure of any other project you might find within an economics study or other
coding project. The idea here is to keep everything organized and separate in 
order to avoid long .do files and folders which contain a mixture of data, 
graphs and figures. At the same time, this allows us to distribute our different 
tasks (i.e., loading the data, running regressions, etc.) and then run them in a
single .do file called "main.do". If from the description alone this does not
seem clear to you, hopefully having a mock (example) project for you to go over
will help to demonstrate how a projet like this in Stata can look and function.


To orient ourselves before covering the actual code, NOTICE THAT YOU ARE IN THE
"MAIN" .do file. That is, it is the hub or main document that will control 
everything in this example project. There are many extended comments, but also 
some important lines of code. As you follow this document, be sure to run the 
corresponding code in each section.

*/






********************************************************************************
********************************************************************************

*				Setting up gloabl paths

********************************************************************************
********************************************************************************

* Just like any other .do file, clear Stata memory
clear all



////////////////////////////		IMPORTANT		////////////////////////////
* CHANGE THIS PATH (within quotes) TO THE LOCATION OF THE "Class 3 - Project" ON YOUR OWN DEVICE. 

global project_path "C:/Users/salva/OneDrive - Universitat de Barcelona/Intro to stata/intro-to-stata/Classes/Class 3/Class 3 - Project"

* This is the main path which directs Stata to the folder for this class. Note that it is not actually setting the path like -cd-, just creating a global variable which stores the path to the folder you downloaded which will be used to tell Stata where to look for and store things in a slightly different way. The path shown is from my device which is just there as a placeholder to serve as an example. On windows, right-click on the "Class 3 - Project" folder and select "copy as path". Alternatively, go into the folder, right-click, "show more options", "properties" and there should be a "location" that that you can copy. On mac, right-click on the folder, select something like "more information" or "obtain information", then copy the text that appears in the "location" field. We have covered this extensively each day in class, so if you are having trouble, it would be a good idea to reach out for help.
////////////////////////////////////////////////////////////////////////////////



* Next we can define separate global paths to each of the different folders within the project. Notice that we are using the global project path in order to do this by writing -$prject_path- before writing the rest of the path to the folders
global data_path "$project_path/Data/"
global code_path "$project_path/Code/"
global table_path "$project_path/Output/Tables/"
global figure_path "$project_path/Output/Figures/"



* Using the -dir- command, we instruct Stata to display the contents of each of the folders.
dir "$code_path"

* For now, these folders are empty except for the placeholder files. We will check again at the end to see how everything looks
dir "$data_path"
dir "$table_path"
dir "$figure_path"






********************************************************************************
********************************************************************************

*				Running code from external .do files

********************************************************************************
********************************************************************************
* As indicated in the project structure, we have files within the "Code" folder which we will use to perform various tasks in Stata. These files are also .do just like this one, but we do not have to go into the file in order to run them. Recall from class that you can run code by selecting or highlighting the lines of code you want to run and clicking the play button in the menu bar. You can also run entire files at once by clicking the same button without selecting anything. In order to run a .do file that you are not currently editing, you can use the -do- command in Stata
help do



* The first file in the "Code" folder is "load_data.do". We can run it from this file by adding the $code_path in front of the name. Notice that once you run it, some actions are performed. Specifically, the nlsw88.dta dataset is loaded, some descriptive commands are run and the dataset is then saved to the "Data" folder. This is the intended function of this file hance the name "load_data.do". If you go into the "load_data.do" file, you will see that when we save the data, we included the global path "$data_path" before the name of our changed dataset "survey_with_changes.dta". 
do "$code_path/load_data.do"



* Next, there is another .do file in the "Code" folder called "figures.do". Since this file is also in the "Code" fodler, we can run it here just like with the previous .do file and its contents will be run. As suggested by the name, this file generate a figure for us. This figure might seem familiar to you and it will also pop up on your screen somewhere. Additionally, the file has also been stored in the "Figures" folder within the "Output" fodler. If you look in the "figures.do" file, you will notice that we instructed Stata to store the figure in a specific location with the -graph export- command using our gloabl path, $figure_path, to the "Figures" folder.
do "$code_path/figures.do"



* Lastly, there is a .do file in the "Code" folder called "tables.do". By now, you should have noticed a pattern. This file will loads the dataset runs some regression and stores their results in tables in the "Tables" folder within "Output". Notice that we don't actually see anything happening when we run this file. If you look in the "tables.do" file, you will see that the regress command we ran had the -quietly- prefix. We briefly discussed this in class, but what it does is suppress the output of a command that we run in Stata. In this case, we actually run an entire block using this command.
do "$code_path/tables.do"






********************************************************************************
********************************************************************************

*				Checking the final content of our folders

********************************************************************************
********************************************************************************
* CODE FOLDER
dir "$code_path"

* DATA FOLDER
dir "$data_path"

* FIGURE FOLDER
dir "$figure_path"

* TABLE FOLDER
dir "$table_path"






********************************************************************************
********************************************************************************

*				Exercise

********************************************************************************
********************************************************************************


* 1. Edit the "tables.do" file, adding code the creates a correlation matrix and saves it to the "Table" folder

* 2. Edit the "figures.do" file, adding code that creates a scatter plot and saves it to the "Figures" folder

* 3. Create a new .do file called "save_data.do" in the "Code" folder. This new file should load the data, only keep the "idcode" variable, and export the data as a .csv to the "Data" folder.

* 4. Include a section in the this file which runs "save_data.do" and rerun the entire script in this file so that previous changes are reflected in the output. 

* 5. Once you have finished, covert your own "Class 3 - Project" folder into a ZIP file, rename it "Class 3 - Project - LASTNAME" and send to me by email by the end of the day (23:59h). LASTNAME should be your own last name.








