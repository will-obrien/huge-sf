public without sharing class JRA_ErrorHandler {
//Runs without sharing to ensure permission errors don't prevent saves

public Static List< jrsbd__JRA_Error_Log__c > errorMessages; 

   
public static void addErrorMessage (String sError, Id sid) {

if (errorMessages == NULL) {
    errorMessages = new List<jrsbd__JRA_Error_Log__c >(); 
}

errorMessages.add(new jrsbd__JRA_Error_Log__c(jrsbd__Error_Message__c = sError, jrsbd__Record_Id__c = sid));

}    

public static void SaveErrors() {
if (errorMessages != NULL && errorMessages.isEmpty() == FALSE) {
    try {
        insert errorMessages;
    }
    catch (Exception Ex) {
        system.debug(Ex);
    }
    
}

}    

}