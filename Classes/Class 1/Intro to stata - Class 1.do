********************************************************************************
********************************************************************************

*	Universitat de Barcelona
*	UB School of Economics
*	MSc in Economics
*	Introduction to Stata
*	Salvatore Viola (sviola@ub.edu)
*	October 17, 2025

********************************************************************************
********************************************************************************



*** Good practice: always clear the curent memory at the beginning of a .do file
clear all	// the -clear- command alone as well works




*** Tell stata where to access files on you computer - set the working directory
cd "C:\Users\room\OneDrive - Universitat de Barcelona\Intro to stata"


*** Importing and loading data
sysuse auto.dta, clear				// Preloaded dataset in Stata

use "OG.dta"	// Load dataset from your computer that is .dta

import excel "results.xlsx", clear	// Load an excel file from your computer

import delimited "stata_class.csv", clear	// Load a comma separated file



*** Looking for help
help import				// -help command_name- see documentation for commands


sysuse auto.dta, clear				// Preloaded dataset in Stata


*** First look at your dataset
describe		// overview of dataset and variables

browse			// open the viewer (like excel) for the dataset

browse price	// open the viewer for specific variables

summarize				// Descriptive statistics

sum price, detail	// More detailed descriptive statistics

tab make		// view oservations of a variables and their frequencies

correlate *			// correlation matrix for all variables (* = all variables)



*** Cleaning and Manipulating your dataset
rename make cars		// change the name of a variable

label variable rep78 "# of repairs in 1978"		// change the label

sort price			// order the observations lowest to highest by price


** logical and mathematical operators
/*

	+, -, =, /, *, >, <, <=, >=		// basic mathematical operators
	
	if, |, &, !, ==						// basic logical operators

*/

generate random_ratio = mpg/weight		// standard way to create variables

label var random_ratio "mpg/weight"	

summarize price weight length if foreign==0

summarize price if weight<3000 & foreign==1

summarize price if weight<3000 | weight >= 4000


gen eco = "not eco"			// create a variable for the cars

replace eco = "eco" if mpg >= 20 	// cool cars get more than 20 mpg

encode eco, generate(eco_dummy)	// "encode" to use in analysis

decode foreign, gen(foreign_str)


** Removing observations
drop eco					// drop all observations for a given var

drop one eco_dummy foreign_str

drop if price > 5000			// drop specific obs. based on a condition

drop if foreign == 1			// remove foreign cars from the dataset

keep cars price mpg				// keep certain variables

keep if cars == "AMC Concord"






*** Saving and exporting tables
* -asdoc- command
* install -asdoc-
ssc install asdoc

asdoc sum, replace

asdoc corr price mpg rep78 headroom trunk weight length turn displacement gear_ratio foreign, append 

asdoc corr price mpg rep78 headroom trunk weight length turn displacement gear_ratio foreign, replace label dec(2) save(corr.doc)

quietly asdoc corr price mpg rep78 headroom trunk weight length turn displacement gear_ratio foreign, replace label dec(2) save(corr.doc)


asdoc table rep78, c(n mpg mean mpg sd mpg median mpg) save(table1.doc) replace


* -putexcel- command
putexcel set results, replace
putexcel A1 = "Variable"
putexcel B1 = "Mean"
putexcel C1 = "Std. Dev."

sysuse auto, clear
summarize mpg		// see -help summarize- to see what it stores
return list

putexcel A2 = "mpg"
putexcel B2 = `r(mean)', nformat(number_d2)
putexcel C2 = `r(sd)', nformat(number_d2)


* -table- command (maybe not the best one, but allows the most customization)
* see -help table- for more info



*** Regressions
regress price mpg 		// depentent variable then indepentdent variables

regress price mpg weight headroom

regress price mpg weight headroom if foreign==0		// only domestic

regress price mpg weight headroom if foreign==1		// only foreign


** Regressions with dummy or categorical variables
regress price mpg weight headroom i.foreign		// "i." identifies a dummy var

regress price mpg weight headroom i.foreign i.rep78

** interactions

generate interact=mpg*foreign //first option, generating ineraction

regress price mpg interact

regress price mpg i.foreign c.mpg#i.foreign //second option, ineracting in the regression

regress price c.mpg##i.foreign // alternative syntax ##



*** Saving and exporting regressions
** -asdoc-
asdoc regress price mpg weight headroom i.foreign, replace

asdoc regress price mpg weight headroom i.foreign, ///
	save(regression1.doc) replace ///
	title(Table 1: Price)
	

* Append regressions to the same document
asdoc regress price mpg weight headroom i.foreign, /// 
	save(appended.doc) replace ///
	title(Table 1: Price)
	
asdoc regress gear_ratio mpg weight headroom i.foreign, /// 
	save(appended.doc) append ///
	title(Table 2: Gear Ratio)


* Nest regressions in asdoc
asdoc regress price mpg, save(nested.doc) nest replace

asdoc regress price mpg weight headroom, save(nested.doc) nest

asdoc regress price mpg weight headroom if foreign==0, save(nested.doc) nest ///
	add(Origin, Domestic)

asdoc regress price mpg weight headroom if foreign==1, save(nested.doc) nest ///
	add(Origin, Foreign)
	
	

*** Exporting regressions with outreg2
** Installing outreg2
ssc install outreg2			// -ssc install command_name- same for every command

regress price mpg weight headroom i.foreign
estimates store r1

outreg2 r1 using "reg1.doc", replace

ssc install estout
** Adding headers and such
regress price mpg weight headroom i.foreign
eststo r2

outreg2 r2 using "reg1.doc", replace title(Table 1: Price)


** Appending tables in outreg2
ssc install estout

eststo clear

eststo simple: regress price mpg

eststo morevars: regress price mpg weight headroom

eststo dom: regress price mpg weight headroom if foreign==0

eststo for: regress price mpg weight headroom if foreign==1

outreg2 [simple morevars dom for] using "reg2.doc", replace title(Table 2: Price)

* Another syntax
eststo simple: regress price mpg
outreg2 simple using "reg3.doc", replace title(Table 3: Price - Fnacy) ctitle("Just MPG")

eststo morevars: regress price mpg weight headroom
outreg2 morevars using "reg3.doc", append ctitle("More Vars")

eststo dom: regress price mpg weight headroom if foreign==0
outreg2 dom using "reg3.doc", append ctitle("Domestic")

eststo for: regress price mpg weight headroom if foreign==1
outreg2 for using "reg3.doc", append ctitle("Foreign")


*** Exporting regressions with -esttab-
eststo clear

eststo simple: regress price mpg

eststo morevars: regress price mpg weight headroom

eststo dom: regress price mpg weight headroom if foreign==0

eststo for: regress price mpg weight headroom if foreign==1

esttab simple morevars dom for using "esttabex.doc", replace 

esttab simple morevars dom for using "esttabex.doc", replace rtf

* now with latex and overleaf

esttab simple morevars dom for using "esttabex.tex", replace 






*** Saving and exporting datasets
save "stata_class1.dta", replace		// saves as stata .dta file

export excel "stata_class1.xlsx", replace firstrow(var)		// saves as excel

export delimited "stata_class1.csv", replace		// saves as .csv

export delimited "stata_class1.tsv", replace		// saves as .tsv



*** Exercise ***
/*

Downloading data and uploading it to stata

1. Go to this website: https://data.oecd.org/
 - click on indicators 
 - look through datasets
 - select one 
 - scroll down and click access now
 - wait (forever) for the page to load
 - change some of the filters (if you want)
 (select only one country over multiple years or multiple countries in one year)

2. Download the data as ***FILTERED DATA IN TABULAR TEXT (CSV)***

3. Open a new .do file and load the dataset
(Hint: locate the data and set that folder as your working directory -cd-)

4. Browse the data and try to understnd the structure and different variables

5. Play around with the data, i.e. browse, sum, drop, keep... just to try commands

6. Try trimming the data to keep a specific set of the data 
(i.e. One type of the variable for one year/country for a single group.
This will of course depend on the data.)

6. Save some descriptive statistics using -asdoc- for only one year or country
(Hint: try using -if- or -drop- to select years)

7. save the data both as a .dta (stata file) AND as an excel
(Hint: see -help save- and -help export- if you're stuck)

Let me know if you need help or finish early!

*/


	


*** Visualizations in Stata
* Tip: There are endless ways to format graphs in stata. Look at the -help- files!!
sysuse census.dta, clear


** Histrograms
histogram pop  

histogram pop, bin(20)		// change the number of bins

hist pop, bin(10) normal		// add a normal distribution tot eh graph


** Pie Charts
graph pie pop, over(region)

graph pie pop, over(region) pie(_all, explode) plabel(_all percent) title("Pie Chart")


** Bar Graphs 
gr bar pop5_17 pop18p pop65p

gr bar pop5_17 pop18p pop65p

gr bar pop5_17 pop18p pop65p, stack		// stack the variables

gr bar pop5_17 pop18p pop65p, over(region)		// do it by region

gr bar pop65p pop5_17 pop18p, over(region)		// do it by region



** Box Plots
gr box marriage divorce


** Dot Plots
gr dot pop poplt5 pop5_17 pop18p pop65p popurban


** Scatter Plots
scatter divorce marriage

scatter divorce marriage || lfit divorce marriage	// include line of best fit

scatter divorce marriage || scatter death pop65p	// plot two separate graphs

graph twoway (scatter death marriage) (lfit death marriage) //alternative

scatter death marriage || lfit death marriage || lfit death marriage if state!="Nevada"


* Combine everything
scatter divorce marriage || scatter death pop65p || lfit divorce marriage || lfit  death pop65p 

* combining graphs
scatter divorce marriage || lfit divorce marriage, name(ex1, replace)

scatter death pop65p || lfit death pop65p, name(ex2, replace)

graph combine ex1 ex2, name(combo, replace)


** Naming, Saving and exporting graphs (Copy paste???)
* Naming 
sysuse census.dta, clear

scatter divorce marriage || lfit divorce marriage, name(g1) // cant run it twice

scatter divorce marriage || lfit divorce marriage, name(g1, replace)

graph display g1


* Saving - only useful for saving graphs in the stata .gph fortmat
graph save div_mar, replace

graph save g1 div_mar, replace


* Exporting
scatter divorce marriage || lfit divorce marriage, name(g1, replace)

graph export "div_mar.png", replace as(png) 

scatter divorce marriage || lfit divorce marriage, name(g1, replace)

graph export "div_mar.jpg", replace as(jpg)






*** Macros and Loops
sysuse census.dta, clear

** Local - store values/variables to be used immediately
local lname poplt5 pop5_17 pop18p pop65p popurban death marriage divorce

summarize `lname' 
summarize poplt5

** Global - store values/variables to be used throughout the dataset
global gname poplt5 pop5_17 pop18p pop65p popurban death marriage divorce
summarize $gname

** Macros and regressions
global indep death pop i.region

global controls pop18p medage

reg marriage $indep $controls

** Loops
* "forvalues" loops - iterate over a certain range
display state[1]
forvalues i=1/10 {
	display `i'
}

* "foreach" loops - iterate over a set of variables/names
foreach i of varlist pop poplt5 pop5_17 {
	summarize `i'
}

* Loops and globals
foreach i of varlist $gname {
	summarize `i'
}

* More complicated loops
foreach i of varlist $gname {
	generate `i'_rel=`i'/pop
	display "Variable `i' adjusted for pop: `i'_rel"
}


** ACTIVITY
* Use forvalues to display the name of the first 10 states
* (Hint: see what happens if you run -display pop[1]- or -display state[1]-)
* If you finish early, try doing it for all 50 states
sysuse census.dta, clear

sort state

display state[1]

display pop[1]



 
