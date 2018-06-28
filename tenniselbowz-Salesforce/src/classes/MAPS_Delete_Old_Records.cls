public class MAPS_Delete_Old_Records {
    public void deleteMAPSRecords(){
        LIST<MAPS_Reporting__c> delRecords = [SELECT Id FROM MAPS_Reporting__c WHERE Month_Ending__c = FALSE AND Week_Ending__c = FALSE AND CreatedDate < LAST_N_DAYS:60 ];
        if(delRecords.size()>0)
        delete delRecords;
        
    }
}