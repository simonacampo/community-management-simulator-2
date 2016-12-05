log using "/Users/albertocottica/github/local/community-management-simulator/Data/Prepare_data.smcl"

insheet using "/Users/albertocottica/github/local/community-management-simulator/Data/dataByTurtle.csv", comma

* Goal: compute in-run Gini coefficients and their SE for ms and nc

svyset _n

quietly separate ms , by (run)
quietly separate nc, by (run)


* create new variables to store the values
generate ms_gini = 0
generate ms_se_gini = 0
generate nc_gini = 0
generate nc_se_gini = 0

* what follows needs to be done in batches  

forval i=501/864 {
	quietly svylorenz ms`i' 
	quietly replace ms_gini = e(gini) if runnumber == `i'
	quietly replace ms_se_gini = e(se_gini) if runnumber == `i'
	quietly svylorenz nc`i' 
	quietly replace nc_gini = e(gini) if runnumber == `i'
	quietly replace nc_se_gini = e(se_gini) if runnumber == `i'
	* drop observations, reducing dimensionality
	quietly drop if runnumber == `i' & id != 1 
	* drop already used ms_n and nc_n variables, further reducing dimensionality
	quietly drop ms`i'
	quietly drop nc`i'
	}
save "/Users/albertocottica/github/local/community-management-simulator/Data/data-w-gini-2.dta", replace

* now create variables with in-run average ginis and their SE. Start with ms_gini.
* each average is computed on 24 runs with all other variables fixed.

gen ms_avg_gini = 0
egen total_ms_gini = total(ms_gini) if intimacystrength == float(11) & chattiness == float(.1), by (policy)
egen total_ms_gini_2 = total(ms_gini) if intimacystrength == float(1) & chattiness == float(.1), by (policy)
replace total_ms_gini = total_ms_gini_2 if intimacystrength == float(1) & chattiness == float(.1)
drop total_ms_gini_2
egen total_ms_gini_2 = total(ms_gini) if intimacystrength == float(5) & chattiness == float(.1), by (policy)
replace total_ms_gini = total_ms_gini_2 if intimacystrength == float(5) & chattiness == float(.1)
drop total_ms_gini_2
egen total_ms_gini_2 = total(ms_gini) if intimacystrength == float(5) & chattiness == float(.15), by (policy)
replace total_ms_gini = total_ms_gini_2 if intimacystrength == float(5) & chattiness == float(.15)
drop total_ms_gini_2
egen total_ms_gini_2 = total(ms_gini) if intimacystrength == float(11) & chattiness == float(.15), by (policy)
replace total_ms_gini = total_ms_gini_2 if intimacystrength == float(11) & chattiness == float(.15)
drop total_ms_gini_2
egen total_ms_gini_2 = total(ms_gini) if intimacystrength == float(1) & chattiness == float(.15), by (policy)
replace total_ms_gini = total_ms_gini_2 if intimacystrength == float(1) & chattiness == float(.15)
drop total_ms_gini_2
egen total_ms_gini_2 = total(ms_gini) if intimacystrength == float(5) & chattiness == float(.4), by (policy)
replace total_ms_gini = total_ms_gini_2 if intimacystrength == float(5) & chattiness == float(.4)
drop total_ms_gini_2
egen total_ms_gini_2 = total(ms_gini) if intimacystrength == float(11) & chattiness == float(.4), by (policy)
replace total_ms_gini = total_ms_gini_2 if intimacystrength == float(11) & chattiness == float(.4)
drop total_ms_gini_2
egen total_ms_gini_2 = total(ms_gini) if intimacystrength == float(1) & chattiness == float(.4), by (policy)
replace total_ms_gini = total_ms_gini_2 if intimacystrength == float(1) & chattiness == float(.4)
drop total_ms_gini_2
replace ms_avg_gini = (1/24) * total_ms_gini
drop total_ms_gini

*same thing for nc_gini

gen nc_avg_gini = 0
egen total_nc_gini = total(nc_gini) if intimacystrength == float(11) & chattiness == float(.1), by (policy)
egen total_nc_gini_2 = total(nc_gini) if intimacystrength == float(1) & chattiness == float(.1), by (policy)
replace total_nc_gini = total_nc_gini_2 if intimacystrength == float(1) & chattiness == float(.1)
drop total_nc_gini_2
egen total_nc_gini_2 = total(nc_gini) if intimacystrength == float(5) & chattiness == float(.1), by (policy)
replace total_nc_gini = total_nc_gini_2 if intimacystrength == float(5) & chattiness == float(.1)
drop total_nc_gini_2
egen total_nc_gini_2 = total(nc_gini) if intimacystrength == float(5) & chattiness == float(.15), by (policy)
replace total_nc_gini = total_nc_gini_2 if intimacystrength == float(5) & chattiness == float(.15)
drop total_nc_gini_2
egen total_nc_gini_2 = total(nc_gini) if intimacystrength == float(11) & chattiness == float(.15), by (policy)
replace total_nc_gini = total_nc_gini_2 if intimacystrength == float(11) & chattiness == float(.15)
drop total_nc_gini_2
egen total_nc_gini_2 = total(nc_gini) if intimacystrength == float(1) & chattiness == float(.15), by (policy)
replace total_nc_gini = total_nc_gini_2 if intimacystrength == float(1) & chattiness == float(.15)
drop total_nc_gini_2
egen total_nc_gini_2 = total(nc_gini) if intimacystrength == float(5) & chattiness == float(.4), by (policy)
replace total_nc_gini = total_nc_gini_2 if intimacystrength == float(5) & chattiness == float(.4)
drop total_nc_gini_2
egen total_nc_gini_2 = total(nc_gini) if intimacystrength == float(11) & chattiness == float(.4), by (policy)
replace total_nc_gini = total_nc_gini_2 if intimacystrength == float(11) & chattiness == float(.4)
drop total_nc_gini_2
egen total_nc_gini_2 = total(nc_gini) if intimacystrength == float(1) & chattiness == float(.4), by (policy)
replace total_nc_gini = total_nc_gini_2 if intimacystrength == float(1) & chattiness == float(.4)
drop total_nc_gini_2
replace nc_avg_gini = (1/24) * total_nc_gini
drop total_nc_gini

* standard error

* create the variable relative to ms (membership strength)
gen ms_xrun_se_gini = 0
* square all within-runs ses
gen ms_se_gini_2 = ms_se_gini^2
* sum them. Here I need to distinguish the different parameter vectors
egen total_ms_se_gini_2 = total(ms_se_gini_2) if intimacystrength == float(11) & chattiness == float(.1), by (policy)
replace ms_xrun_se_gini = sqrt(total_ms_se_gini_2)/24 if intimacystrength == float(11) & chattiness == float(.1)
drop total_ms_se_gini_2
**
egen total_ms_se_gini_2 = total(ms_se_gini_2) if intimacystrength == float(1) & chattiness == float(.1), by (policy)
replace ms_xrun_se_gini = sqrt(total_ms_se_gini_2)/24 if intimacystrength == float(1) & chattiness == float(.1)
drop total_ms_se_gini_2
**
egen total_ms_se_gini_2 = total(ms_se_gini_2) if intimacystrength == float(5) & chattiness == float(.1), by (policy)
replace ms_xrun_se_gini = sqrt(total_ms_se_gini_2)/24 if intimacystrength == float(5) & chattiness == float(.1)
drop total_ms_se_gini_2
**
egen total_ms_se_gini_2 = total(ms_se_gini_2) if intimacystrength == float(11) & chattiness == float(.15), by (policy)
replace ms_xrun_se_gini = sqrt(total_ms_se_gini_2)/24 if intimacystrength == float(11) & chattiness == float(.15)
drop total_ms_se_gini_2
**
egen total_ms_se_gini_2 = total(ms_se_gini_2) if intimacystrength == float(1) & chattiness == float(.15), by (policy)
replace ms_xrun_se_gini = sqrt(total_ms_se_gini_2)/24 if intimacystrength == float(1) & chattiness == float(.15)
drop total_ms_se_gini_2
**
egen total_ms_se_gini_2 = total(ms_se_gini_2) if intimacystrength == float(5) & chattiness == float(.15), by (policy)
replace ms_xrun_se_gini = sqrt(total_ms_se_gini_2)/24 if intimacystrength == float(5) & chattiness == float(.15)
drop total_ms_se_gini_2
**
egen total_ms_se_gini_2 = total(ms_se_gini_2) if intimacystrength == float(11) & chattiness == float(.4), by (policy)
replace ms_xrun_se_gini = sqrt(total_ms_se_gini_2)/24 if intimacystrength == float(11) & chattiness == float(.4)
drop total_ms_se_gini_2
**
egen total_ms_se_gini_2 = total(ms_se_gini_2) if intimacystrength == float(1) & chattiness == float(.4), by (policy)
replace ms_xrun_se_gini = sqrt(total_ms_se_gini_2)/24 if intimacystrength == float(1) & chattiness == float(.4)
drop total_ms_se_gini_2
**
egen total_ms_se_gini_2 = total(ms_se_gini_2) if intimacystrength == float(5) & chattiness == float(.4), by (policy)
replace ms_xrun_se_gini = sqrt(total_ms_se_gini_2)/24 if intimacystrength == float(5) & chattiness == float(.4)
drop total_ms_se_gini_2
**
drop ms_se_gini_2

* now create the variable relative to nc (number of comments)
gen nc_xrun_se_gini = 0
* square all within-runs ses
gen nc_se_gini_2 = nc_se_gini^2
* sum them. Here I need to distinguish the different parameter vectors
egen total_nc_se_gini_2 = total(nc_se_gini_2) if intimacystrength == float(11) & chattiness == float(.1), by (policy)
replace nc_xrun_se_gini = sqrt(total_nc_se_gini_2)/24 if intimacystrength == float(11) & chattiness == float(.1)
drop total_nc_se_gini_2
**
egen total_nc_se_gini_2 = total(nc_se_gini_2) if intimacystrength == float(1) & chattiness == float(.1), by (policy)
replace nc_xrun_se_gini = sqrt(total_nc_se_gini_2)/24 if intimacystrength == float(1) & chattiness == float(.1)
drop total_nc_se_gini_2
**
egen total_nc_se_gini_2 = total(nc_se_gini_2) if intimacystrength == float(5) & chattiness == float(.1), by (policy)
replace nc_xrun_se_gini = sqrt(total_nc_se_gini_2)/24 if intimacystrength == float(5) & chattiness == float(.1)
drop total_nc_se_gini_2
**
egen total_nc_se_gini_2 = total(nc_se_gini_2) if intimacystrength == float(11) & chattiness == float(.15), by (policy)
replace nc_xrun_se_gini = sqrt(total_nc_se_gini_2)/24 if intimacystrength == float(11) & chattiness == float(.15)
drop total_nc_se_gini_2
**
egen total_nc_se_gini_2 = total(nc_se_gini_2) if intimacystrength == float(1) & chattiness == float(.15), by (policy)
replace nc_xrun_se_gini = sqrt(total_nc_se_gini_2)/24 if intimacystrength == float(1) & chattiness == float(.15)
drop total_nc_se_gini_2
**
egen total_nc_se_gini_2 = total(nc_se_gini_2) if intimacystrength == float(5) & chattiness == float(.15), by (policy)
replace nc_xrun_se_gini = sqrt(total_nc_se_gini_2)/24 if intimacystrength == float(5) & chattiness == float(.15)
drop total_nc_se_gini_2
**
egen total_nc_se_gini_2 = total(nc_se_gini_2) if intimacystrength == float(11) & chattiness == float(.4), by (policy)
replace nc_xrun_se_gini = sqrt(total_nc_se_gini_2)/24 if intimacystrength == float(11) & chattiness == float(.4)
drop total_nc_se_gini_2
**
egen total_nc_se_gini_2 = total(nc_se_gini_2) if intimacystrength == float(1) & chattiness == float(.4), by (policy)
replace nc_xrun_se_gini = sqrt(total_nc_se_gini_2)/24 if intimacystrength == float(1) & chattiness == float(.4)
drop total_nc_se_gini_2
**
egen total_nc_se_gini_2 = total(nc_se_gini_2) if intimacystrength == float(5) & chattiness == float(.4), by (policy)
replace nc_xrun_se_gini = sqrt(total_nc_se_gini_2)/24 if intimacystrength == float(5) & chattiness == float(.4)
drop total_nc_se_gini_2
**
drop nc_se_gini_2



* now the t-tests. the t-statistics for the two Gini coefficients are computed in Python. :-(
* remember to do this for all cases: chattiness high-low, intimacy strength hi-low

* totalmembership strength:
ttest totalmembershipstrength if intimacystrength == float(11) & chattiness == float(.1) & (policy == "none" | policy == "onboard"), by (policy)
ttest totalmembershipstrength if intimacystrength == float(11) & chattiness == float(.1) & (policy == "none" | policy == "engage"), by (policy)
ttest totalmembershipstrength if intimacystrength == float(11) & chattiness == float(.1) & (policy == "none" | policy == "both"), by (policy)

* dropouts
ttest dropouts if intimacystrength == float(11) & chattiness == float(.1) & (policy == "none" | policy == "onboard"), by (policy)
ttest dropouts if intimacystrength == float(11) & chattiness == float(.1) & (policy == "none" | policy == "engage"), by (policy)
ttest dropouts if intimacystrength == float(11) & chattiness == float(.1) & (policy == "none" | policy == "both"), by (policy)

* mycommentsofturtle0
ttest totalcomments if intimacystrength == float(11) & chattiness == float(.1) & (policy == "none" | policy == "onboard"), by (policy)
ttest totalcomments if intimacystrength == float(11) & chattiness == float(.1) & (policy == "none" | policy == "engage"), by (policy)
ttest totalcomments if intimacystrength == float(11) & chattiness == float(.1) & (policy == "none" | policy == "both"), by (policy)

log close

* plot some stuff
scatter totalcomments mycommentsofturtle0, msize tiny 
