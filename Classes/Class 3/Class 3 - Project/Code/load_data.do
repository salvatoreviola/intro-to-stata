* File to load auto data, clean and save data

* Load survey dataset
sysuse nlsw88.dta, clear

* Describe variables
describe

* Drop some of the ones that we dont need
drop c_city industry

* Display some descriptive statisitics
sum age married grade collgrad wage hours

* Save our slightly modified data to our project's data folder
save "$data_path/survey_with_changes.dta", replace