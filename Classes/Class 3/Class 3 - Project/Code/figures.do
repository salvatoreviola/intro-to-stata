* File to load cleaned data, create figures and save them

* Load cleaned dataset
use "$data_path/survey_with_changes.dta", clear

* Sum age
sum age

* Store mean for graph
local m_age = `r(mean)'

* Create bar chart which was the solution to problem set 1
graph bar wage hours, missing note("") ///
	over(union, reverse relabel(3 "Unknown")) ///
	by(smsa collgrad, note("{stSerif:This note is in th SMCL Serif font which is similar to Times New Roman}") ///
		title("Intro to Stata -- Problem Set 1")) ///
	bargap(10) xalternate yalternate ///
	yline(`m_age', lcolor(gold) lpattern(dash_dot) style(extended) lwidth(thick)) ///
	legend(order(2 1) label(1 "Avg. Wage") label(2 "Avg. Hours")) ///
	text(42 90 "Avg. age of entire sample", size(tiny)) blabel(bar, position(inside) size(tiny) color(white)) ///
	scheme(sj) ylabel(,nogrid) 
	

* Save chart using the $figure_path from the main file
graph export "$figure_path/figure1.png", replace as(png)