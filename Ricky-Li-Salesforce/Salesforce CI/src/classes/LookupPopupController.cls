//
// Custom controller for lookup example popup page
//
public with sharing class LookupPopupController 
{
    
    public String query {get; set;}
    public List<User> accounts {get; set;}
    public String RoomieName;
    
    public PageReference runQuery()
    {
        List<List<User>> searchResults;
        String Id = Userinfo.getUserId();
        User user = [Select gender__c, Reporting_Office__c from User where Id =:Id];
       
        if(query.length()!=0){
            if(query.length() < 3){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter the First Name!'));
            }
            else{
                searchResults=[FIND :query IN NAME FIELDS RETURNING User (id, name, Gender__c where Gender__c=:user.gender__c and Reporting_Office__c !=: user.Reporting_Office__c)];
                accounts=searchResults[0];
            }
        
            if(accounts.size() < 1)
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Unfortunately '+query+' is not available to be your roommate. Please select a roommate from a different region'));
       
       }
       else
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Enter something in!'));
       
       return null;
    }


    public PageReference SaveRoomieName() {
        String RoomieName = Apexpages.currentPage().getParameters().get('RoomieName');
        System.Debug('RoomieName'+RoomieName);            
        String userID = Userinfo.getUserId();
        Golden_Ticket__c gtc = [Select Roomie__c from Golden_Ticket__c where User__c=:userID];
        gtc.Roomie__c = RoomieName;
        update gtc;
        
        return null;
    }
}