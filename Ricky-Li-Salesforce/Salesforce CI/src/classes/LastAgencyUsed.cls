public class LastAgencyUsed {
Account acc;
Public list <AccountHistoricalSummary__c> AHS {Get;set;}
    public LastAgencyUsed(ApexPages.StandardController controller) {
        //Write a SOQL query on the Account Historical Object emitting the field data
         
      acc = [SELECT id FROM Account
                WHERE Id = :ApexPages.currentPage().getParameters().get('Id')];       
                System.debug(acc);
               
        String acc1 = String.valueOf(acc); 
        System.debug(acc1);
        
        AHS = new List <AccountHistoricalSummary__c> ();
        AHS = [Select Last_Agency_Used__c from AccountHistoricalSummary__c where Account_id__c = :acc.id];
                 System.debug(AHS);
    }

}