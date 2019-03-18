/*
 * Share case Created from Open311
 */

global class CaseSharing {

    public static boolean manualShareRead(Id recordId, Id userOrGroupId){
        CaseShare caseShr  = new CaseShare();
        caseShr.CaseId = recordId;

        System.debug('Record Type ID: ' +  recordId);
        System.debug('Group ID: ' +  userOrGroupId);
        // Set the ID of user or group being granted access.
        caseShr.UserOrGroupId = userOrGroupId;

        // Set the access level.
        caseShr.CaseAccessLevel= 'Read';

        // Set rowCause to 'manual' for manual sharing.
        // This line can be omitted as 'manual' is the default value for sharing objects.
        //  caseShr.RowCause = Schema.CaseShare.RowCause.Manual;

        // Insert the sharing record and capture the save result. 
        // The false parameter allows for partial processing if multiple records passed 
        // into the operation.
        Database.SaveResult sr = Database.insert(caseShr,false);

        // Process the save results.
        if(sr.isSuccess()){
            // Indicates success
            System.debug('CaseSharing class returns : TRUE');
            return true;
        }
        else {
            // Get first save result error.
            Database.Error err = sr.getErrors()[0];
            System.debug('CaseSharing class thrown error: ' + String.valueOf(err));
            // Check if the error is related to trival access level.
            // Access levels equal or more permissive than the object's default 
            // access level are not allowed. 
            // These sharing records are not required and thus an insert exception is acceptable. 
            if(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  &&  
                    err.getMessage().contains('AccessLevel')){
                // Indicates success.
                System.debug('CaseSharing class returns : TRUE');
                return true;
            }
            else{
                // Indicates failure.
                System.debug('CaseSharing class returns : FALSE');
                return false;
            }
        }
    }
}