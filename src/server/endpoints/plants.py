# Managing All Plant Data

# ===== Personal Plant Management Endpoints ====

'''
Adds a PERSONAL plant. (POST)
    - Params: 
        - personalName:  string  
        - desc:          string
        - userId:        int
        - photoUrl:      string 
        - plantTypeId:   int
        - plantTags:     [string]
        // if friends are happening
        - private:       boolean
'''
def add_personal_plant():
    pass

'''
Gets a PERSONAL Plant (GET)
    - Params:
        - plantId: int and/or username: string
    - Returns:
        - all plant information
'''
def get_personal_plant():
    pass

'''
Deletes a PERSONAL Plant (DELETE)
    - Params:
        - plantId: int
        - userId:  int
    - Notes:
        - plant must belong to user
'''
def delete_personal_plant():
    pass

# ==== Miscellaneous Plant Endpoints ====

'''
Adds an Activity to a Plant (POST)
    - Params:
        - plantId:      int
        - activityType: int
        - time:         date
'''
def add_activity():
    pass

'''
Gets Activity of a Plant (GET)
    - Params:
        - plantId: int
    - Return:
        - time series of activity
'''
def get_activity():
    pass

# ==== Plant Type Management Endpoints ====
# Consider if these endpoints are really necessary.
# We can manually manage the data. But that also saying,
# If a new plant type comes in we might want to verify it. Eh. dunno.

'''
Adds a Plant Type (ADMIN)
    - Params:
        - commonName:     string
        - fullName:       string
        - type:           string
    - Process:
        - Create new requirement/s for plant type
        - Create new plant type w/ requirement

Note: do we need one of these? We could add them manually (thinking admin and auth bleh)
'''

'''
Deletes a Plant Type (ADMIN)
    - Params:
        - plantId: int
'''

