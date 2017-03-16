import csv
dirPath = '/Users/albertocottica/github/local/community-management-simulator-2/Data/'

def readFile(filename):
    '''
    (str) => list of dicts
    loads file filename into a list. Each item is a dict encoding one run in the model.
    '''
    with open (filename, 'r') as csvFile:
        csvReader = csv.DictReader (csvFile, delimiter = ',', quotechar = '"')
        runs = []
        for row in csvReader:
            runs.append(row)
        return runs

def compute_t_ginis():
    '''
    (none) => list of dicts
    computes the t statistic relative to the null hypothesis that gini2 == gini1
    gini1 and gini2 are average cross-run ginis.
    we have 9 cases: 3 valus for chattiness, 3 for intimacystrength
    we also have 3 policy tests for each case: "onboard", "engage" and "both"  vs. "none"
    '''
    
    results = []
    
    chattiness_values = [".1", ".15", ".4"]
    intimacy_values = ["1", "5", "11"]
    
    # lots of overwriting here
    for c in chattiness_values:
        for i in intimacy_values:
            thisCase = {}
            for ob in obs:
                if ob["chattiness"] == c and  ob["intimacystrength"] == i:
                    thisCase["chattiness"] = c
                    thisCase["intimacystrength"] = i
                    thisCase[ob["policy"] + "_ms_avg_gini"] = ob["ms_avg_gini"]
                    thisCase[ob["policy"] + "_nc_avg_gini"] = ob["nc_avg_gini"]
                    thisCase[ob["policy"] + "_ms_se_gini"] = ob["ms_xrun_se_gini"] 
                    thisCase[ob["policy"] + "_nc_se_gini"] = ob["nc_xrun_se_gini"]         
                    
            # now compute the 6 t statistics. Start by onboard vs. none
            ms_x2 = float(thisCase["none_ms_avg_gini"])
            ms_s2 = float(thisCase["none_ms_se_gini"])
            ms_x1 = float(thisCase["onboard_ms_avg_gini"])
            ms_s1 = float(thisCase["onboard_ms_se_gini"])
            ms_t = (ms_x1 - ms_x2) / (((ms_s1 ** 2 + ms_s2 ** 2) /24) ** (0.5))
            thisCase["ms_t_onboard_none"] = ms_t
            
            nc_x2 = float(thisCase["none_nc_avg_gini"])
            nc_s2 = float(thisCase["none_nc_se_gini"])
            nc_x1 = float(thisCase["onboard_nc_avg_gini"])
            nc_s1 = float(thisCase["onboard_nc_se_gini"])
            nc_t = (nc_x1 - nc_x2) / (((nc_s1 ** 2  + nc_s2 ** 2) /24) ** (0.5))
            thisCase["nc_t_onboard_none"] = nc_t
                    
            # engage vs. none 
            ms_x1 = float(thisCase["engage_ms_avg_gini"])
            ms_s1 = float(thisCase["engage_ms_se_gini"])
            ms_t = (ms_x1 - ms_x2) / (((ms_s1 ** 2 + ms_s2 ** 2) /24) ** (0.5))
            thisCase["ms_t_engage_none"] = ms_t
            
            nc_x1 = float(thisCase["engage_nc_avg_gini"])
            nc_s1 = float(thisCase["engage_nc_se_gini"])
            nc_t = (nc_x1 - nc_x2) / (((nc_s1 ** 2 + nc_s2 ** 2) /24) ** (0.5))
            thisCase["nc_t_engage_none"] = nc_t

            # both vs. none
            ms_x1 = float(thisCase["both_ms_avg_gini"])
            ms_s1 = float(thisCase["both_ms_se_gini"])
            ms_t = float((ms_x1 - ms_x2) / (((ms_s1 ** 2 + ms_s2 ** 2) /24)) ** (0.5))
            thisCase["ms_t_both_none"] = ms_t
            
            nc_x1 = float(thisCase["both_nc_avg_gini"])
            nc_s1 = float(thisCase["both_nc_se_gini"])
            nc_t = (nc_x1 - nc_x2) / (((nc_s1 ** 2 + nc_s2 ** 2) /24) ** (0.5))
            thisCase["nc_t_both_none"] = nc_t
            
            results.append(thisCase)
    return results


    

if __name__ == "__main__":
    obs = readFile(dirPath + 'data-w-gini-2.csv')
    results = compute_t_ginis()
    for item in results:
        print ("chattiness: " + str(item["chattiness"]) + "; intimacy strength: " + str(item["intimacystrength"]))
        print ("***** inequality in membership strength ********")
        print ("H0: ms_avg_gini(onboard) = ms_avg_gini_none => " + str(item["ms_t_onboard_none"]))
        print ("H0: ms_avg_gini(engage) = ms_avg_gini_none => " + str(item["ms_t_engage_none"]))
        print ("H0: ms_avg_gini(both) = ms_avg_gini_none => " + str(item["ms_t_both_none"]))
        print ("***** inequality in number of comments ********")
        print ("H0: ms_avg_gini(onboard) = ms_avg_gini_none => " + str(item["ms_t_onboard_none"]))
        print ("H0: ms_avg_gini(engage) = ms_avg_gini_none => " + str(item["ms_t_engage_none"]))
        print ("H0: ms_avg_gini(both) = ms_avg_gini_none => " + str(item["ms_t_both_none"]))
        print ("******************************************************************")

        

        
    
