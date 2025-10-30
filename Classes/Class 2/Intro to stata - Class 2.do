********************************************************************************
********************************************************************************

*	Universitat de Barcelona
*	UB School of Economics
*	MSc in Economics
*	Introduction to Stata & MATLAB (Stata)
*	Salvatore Viola (sviola@ub.edu)
*	October 24, 2025

********************************************************************************
********************************************************************************

* Clear current memory
clear all

* Set current working directory
cd "C:\Users\salva\OneDrive - Universitat de Barcelona\Intro to stata"

cd "C:\Users\aules\OneDrive - Universitat de Barcelona\Intro to stata\intro-to-stata"


********************************************************************************
*** 						Reminders for Stata
* the "*" in Stata starts a "comment" which are lines in that appear green and do not contribute to the output. They are just words or comments for those looking at the .do-file

/*

A multi-line comment can be defined using /* to begin and */ to end as you see here

*/


// comments can also be input anywhere using a double slash "//"

* the triple slash "///" is used to break a line of code and continue it on another line

/*

 When dealing with macros, you need to identify them by using a prefix and or suffix
 
 locals are identified using these symbols `' with the name inbetween them
 ex. `local_name'
 
 globals are indentified using a dollar sign $
 ex. $global_name

*/
********************************************************************************




*** ACTIVITY *** 
/*

1. Open the cancer.dta dataset available in Stata
(Hint: -sysuse-)

2. Describe data and summarize the first four variables

3. Show the percentiles of months to death for those who died
(Hint: check the -help summarize- file to get percentiles)

4.Which drug is associated to a lower probability of death?
(Hint: perform a regression with the different types of drugs)

5. Does the effectiveness of the drugs vary if older than 50 years?
(Hint: -if-)

6. Export the regressions in 4 and 5 with outreg2 or estout, show variable labels
(Hint: Are they installed? ssc install outreg2. Take a look at the -help- files)

*/










*** Review of Macros and Loops
sysuse census.dta, clear

** Local - store values/variables to be used immediately
local variables poplt5 pop5_17 pop18p pop65p popurban death marriage divorce

summarize `variables' 	// summarizes all of the variables stored in the local lname

return list			// displays a list of everything store by the command sum...



** Storing particular values in macros
summarize poplt5

return list		// shows what is store in stata memory after the summarize command

* Creates a local call poplt15_mean which is assigned the mean of the variable poplt15 stored from the summarize command
local poplt15_mean = `r(mean)' 	


* Displays the value of the local poplt15_mean
display `poplt15_mean'		// in order for this to run, you need to run the local command at the same time * that is, select both codes and run them

summarize poplt5

global poplt15_mean = `r(mean)'	// with globals, you do not need to run them at the same time

display $poplt15_mean




*** The egen command -help egen-  Used for the creation of more complex vars
sysuse census, clear		// load sample dataset

describe			// set what variables it contains

sum pop		// sum the cholesterol variable

egen avg_pop = mean(pop)

egen avg_pop_south = mean(pop) if region == 3	// create a new variable equal to the mean of cholesterol

egen max = max(pop)	// create a new variable equal to the max of cholesterol

sum pop

gen max1 = `r(max)'

*** Is there another way that you can do this using what we learned above?
* Hint: what does the summarize command store?

** More egen examples
sysuse auto.dta, clear		// load new dataset

* separately for foreign and domestic cars, sums all of the prices into one new var
sort region

bysort region: egen tot_pop = sum(pop)


* separately for foreign and domestic cars, counts the number of cars (obs)
bys region: egen num_states = count(state)

gen avp = tot_pop/num_states

by foreign: egen mean_price = mean(price)




*** Collapsing datasets - changing their format to consider different units 
webuse college, clear
describe
list		// we can see that its contins different students from different years

sysuse census, clear		// load sample dataset


** change dataset to only have the average gpa of each year
collapse (mean) pop, by(region)

collapse (mean) pop death (max) medage (first) state, by(region)


* example with states
sysuse census.dta, clear

* creates a dataset with only population for the region
collapse (sum) pop, by(region)

sysuse census.dta, clear

* creates a dataset with all measure of population by region
collapse (sum) pop*, by(region)

sysuse census.dta, clear

* creates a dataset with the max population by regions
collapse (max) pop*, by(region)





*** Another example with collapsing and egen with some string manipulation

* Eurostat unemployment NUTS2: https://ec.europa.eu/eurostat/databrowser/view/tgs00010/default/table?lang=en
import delimited "tgs00010_page_linear.csv", varnames(1) clear

* Keep only the useful variables
keep geo time_period obs_value

* Give the variables more standard and useful names
rename geo NUTS2
rename time_period year
rename obs_value unemp_rate

* save it
save "unemp.dta", replace




* We want to change the dataset so that it only has the average unemployment rates by country
use unemp, clear

* The first problem we run into is that there aren't country names alone, only country names with the NUTS2 region code. How do we make a variable for country?
gen country = substr(NUTS2, 1, 2)

* Lets see how many countries we have in our dataset
* ssc install unique
unique(country)


*** ACTIVITY
* Using -collapse-, change the dataset to include a new variable which has the average unemployment rate by region (ex. Wien avg. unemployment between 2013 and 2024)
* Don't forget to check the -help- file for -collapse-

collapse (mean) m_unemp = unemp_rate, by(NUTS2)



*** Merging datasets - combining data from different sources with different similar unit i.e. countries and years
webuse autosize, clear

save "autosize.dta", replace

list

webuse autoexpense, clear // slightly different dataset with some similar units
use autoexpense, clear
save "autoexpense.dta", replace

list

* command to merge the datasets. 1:1 means that we are matching a equal observations from one dataset to another. -using- tells us with which dataset we want to merge it. This command creates a new variale "_merge" which indicates the success of the match by observation
merge 1:1 make using "autosize.dta"

list		// we can see that one observation wasn't matched because it was only present in one of the data sets

drop if _merge != 3

keep if _merge == 3
drop if _merge != 3

drop _merge


* Example of a 1:m or m:1 merge
webuse dollars, clear

list

webuse sforce

list

merge m:1 region using https://www.stata-press.com/data/r18/dollars

list







* GDP PC PPS https://ec.europa.eu/eurostat/databrowser/view/tec00114/default/table?lang=en
* deselect compress files option at the bottom
* download "from this page only"

* Wage gap indicator https://ec.europa.eu/eurostat/databrowser/view/earn_gr_gpgr2$dv_593/default/table?lang=en
* https://ec.europa.eu/eurostat/databrowser/view/earn_gr_gpgr2/default/table?lang=en&category=eq.eq_labour_earn.eq_gpgr
* deselect compress files option at the bottom
* download "from this page only"


* Import the .csv file 
import delimited  "earn_gr_gpgr2_page_linear.csv", clear

* Keep only the useful variables
keep geo time_period obs_value

* Give the variables more standard and useful names
rename geo country
rename time_period year
rename obs_value wage_gap

* Save the data as a .dta Stata data file to be used later
save "wage_gap.dta", replace


* Import another .csv file
import delimited "tec00114_page_linear.csv", clear

* Keep only the useful variables
keep geo time_period obs_value

* Give the variables more standard and useful names to match the other dataset
rename geo country
rename time_period year
rename obs_value gdp_pc

* Save the data as a .dta Stata data file to be used later
save "gdp_pc.dta", replace






** Merge the two datasets
* Load the base dataset
use "gdp_pc.dta", clear

use gdp_pc, clear

* Run the merge command with the type of merge AND the variables which we want to match
* Also, specifiy the dataset we want to merge with after the "using" prompt
merge 1:1 country year using "wage_gap.dta"

* Look at the data and see where matches have been made and missed
browse

* Keep only the observations which were matched between the two datasets
keep if _merge == 3

save "merged_data.dta", replace





* Let's say that we wanted to treat this data as a panel
use "merged_data.dta", clear

* tell stata that the data are a panel using -xtset-
xtset country year		// wont let us because country is string. How can we change that?

* We can encode it!
encode country, gen(cntry)		// how many different countries do we have?

* Try the -xtset- again
xtset cntry year

* Look at the pattern of the data. Do we have observations for every country across all years?
xtdescribe		// shows that there are some gaps - every country should have 10 years

* How do we only keep countries for which we have observations across all years?
sum cntry
sum year if cntry == 1		// has 10 observations
return list
sum year if cntry == 31		// has only 7 observations

display `r(N)'
if `r(N)' != 10 display "Less than 10" 

* One way to do this
forvalue i = 1/31{
	sum year if cntry == `i'
	drop if cntry == `i' & `r(N)' != 10
}


* Check again to see if it worked
xtdescribe






*** Simple introduction to reshaping data
webuse reshape1, clear

list

reshape long inc ue, i(id) j(year)


reshape wide inc ue, i(id) j(year)



*** Extra time for examples with my code and questions 



*** ACTIVITY ***
/*

1. Load the census dataset
(Hint: -sysuse-)

2. Check out the effect of marriage on death. Is it what you expect?
(Hint: try a regression. What other variables should you include?)

3. Make a scatter plot of the relationship between death and marriage

4. Layer the scatter plot using two separate age groups (above and below the median = 29.54)

ex. scatter divorce marriage if medage .. || scatter divorce marriage if medage ...

5. Add labels to the LEGEND to identify which points belong to each age group
(Hint: use the -help scatter- file, look for legend options)

6. Now, plot the two graphs side-by-side-by-side and add state labels
(Hint: see -help graph combine- and reference graph names from the example (e.g g1))

*/



