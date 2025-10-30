* This file runs a regrssion based on our dataset and saves it

* Load cleaned dataset
use "$data_path/survey_with_changes.dta", clear

* Install estout to store table is not already installed
ssc install estout

* Geen log wages
gen ln_wage = ln(wage)
label var ln_wage "Log Wage"

* Gen age squared
gen age_sq = age*age
label var age_sq "Age Squared"

* Run and store estimation (quietly)
eststo r1: quietly reg ln_wage hours ttl_exp tenure i.collgrad i.race age age_sq
	
* Export table to be readable in word using esttab from estout package
esttab r1 using "$table_path/table1.doc", replace rtf nobase label ///
	title("Table 1: Wage as a function of individual characteristics")
