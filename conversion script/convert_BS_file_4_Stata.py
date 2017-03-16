import csv

def stringToList(longString):
    '''
    (string) => list
    transforms longString into a Python list
    '''
    lS1 = longString.strip('[]').split()
    return lS1

def convert (runRow):
    '''
    (dict) => dict
    re-arranges the observations contained in one runRow (which represent one run with many turtles)
    as cross-sectional data (each row is one turtle).
    All non-turtle-specific data are repeated in each row. New-type rows are returned as dictionaries.
    '''
    conv = {} # initialize the dictionary to be returned
    ## start by copying the turtle-invariant (run-specific) values
    conv ["[run number]"] = runRow ["[run number]"]
    conv ["founders"] = runRow ["founders"]
    conv ["chattiness"] = runRow ["chattiness"]
    conv ["num-members"] = runRow ["num-members"]
    conv ["intimacy-strength"] = runRow ["intimacy-strength"]
    conv ["total-membership-strength"] = runRow ["total-membership-strength"]
    conv ["total-comments"] = runRow ["total-comments"]
    conv ["dropouts"] = runRow ["dropouts"]
    conv ["[my-comments] of turtle 0"] = runRow ["[my-comments] of turtle 0"]
    if runRow["onboard"] == "false" and runRow["engage"] == "false":
        conv ["policy"] = "none"
    elif runRow["onboard"] == "true" and runRow["engage"] == "false":
        conv ["policy"] = "onboard"
    elif runRow["onboard"] == "false" and runRow["engage"] == "true":
        conv ["policy"] = "engage"
    elif runRow["onboard"] == "true" and runRow["engage"] == "true":
        conv ["policy"] = "both"

    
    ## now add turtle-specific information
    ## start by creating lists from all the NetLogo reporters of the type "[my-variable] of turtles"
    idList = stringToList(runRow["map idlist sort members"])
    msList = stringToList(runRow["map mslist sort members"])
    ncList = stringToList(runRow["map nclist sort members"])  
    listOfTurtleDicts = [] ## create the list to be returned
    for i in range (len(idList)):
        turtleRow = conv.copy() # make a copy of conv
        turtleRow['id'] = idList[i]
        turtleRow['ms'] = msList[i]
        turtleRow['nc'] = ncList[i]
        listOfTurtleDicts.append(turtleRow)
    return listOfTurtleDicts

dirPath = '/Users/albertocottica/github/local/community-management-simulator-2/Data/'
converted = []
with open (dirPath + 'Online_communities_v3 intimacy-strength vs. policies-table.csv', 'r') as csvFile:
    for i in range (6):
        csvFile.readline()
    csvReader = csv.DictReader (csvFile, delimiter = ',', quotechar = '"')
    for row in csvReader:
        listOfDicts = convert(row)
        for item in listOfDicts:
            converted.append(item)
        
with open (dirPath + 'dataByTurtle.csv', 'w') as outFile:
    fieldnames = ["[run number]","founders","chattiness","num-members","intimacy-strength","policy","total-membership-strength","dropouts","total-comments","[my-comments] of turtle 0","id", "ms","nc"]
    ## paste the column title row of the table.csv file coming out of NetLogo
    writer = csv.DictWriter (outFile, fieldnames = fieldnames)
    
    writer.writeheader()
    for row in converted:
        writer.writerow(row)
    
        
