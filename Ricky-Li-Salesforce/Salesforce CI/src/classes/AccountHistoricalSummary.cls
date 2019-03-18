public class AccountHistoricalSummary {
Account acc;
Public list <AccountHistoricalSummary__c> AHS {Get;set;}
    public AccountHistoricalSummary(ApexPages.StandardController controller) {
    //Write a SOQL query on the Account Historical Object emitting the field data
         
      acc = [SELECT id FROM Account
                WHERE Id = :ApexPages.currentPage().getParameters().get('Id')];       
                System.debug(acc);
               
        String acc1 = String.valueOf(acc); 
        System.debug(acc1);
        
        AHS = new List <AccountHistoricalSummary__c> ();
        AHS = [Select Add_ons__c, Average_Tour_Length__c, Booked_Air_in_the_Past__c, Client_Type__c, Lifetime_Value__c, Number_of_Tours__c, Preferred_Comfort_Level__c, Preferred_Trip_Style__c, Average_Tour_Price__c, Last_Agency_Used__c from AccountHistoricalSummary__c where Account_id__c = :acc.id];
                 System.debug(AHS);
                 
}
      
    }