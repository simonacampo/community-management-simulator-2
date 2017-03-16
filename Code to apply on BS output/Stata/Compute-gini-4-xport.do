insheet using "/Users/albertocottica/github/local/community-management-simulator-2/Data/dataByTurtle.csv", comma

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

forval i=1/500 {
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
save "/Users/albertocottica/github/local/community-management-simulator-2/Data/data-w-gini-retry.dta", replace
