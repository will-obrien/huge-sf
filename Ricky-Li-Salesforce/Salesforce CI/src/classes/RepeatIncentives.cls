public class RepeatIncentives {
	/*
		This apex class is the controller for the Repeat_Incentive.page
	*/
	
    public List<Repeat_Incentive__c> listRepeatIncentives{get;set;}
    list <User> listUsers;
    String UserId;
    private String baseQuery; 
    public Double yourMoney {get;set;}
       
    public RepeatIncentives(ApexPages.StandardController controller) {
    
        listUsers = [select id from User where Id =: Userinfo.getUserId()];
        userId = listUsers[0].Id;
    	baseQuery = 'select Account__c, Traveller_Name__c, CEO_User__c, Original_Trip_Code__c, CEO_Average_Score__c, Repeat_Trip_Code__c, Payment_Amount__c from Repeat_Incentive__c WHERE CEO_User__c = :userId ORDER BY Original_Service__r.Service_Start_Date__c DESC ';
    	
    	listRepeatIncentives = Database.query(baseQuery);
       
   		// Calculate CEO Total Money:
   		yourMoney = 0;
   		for (Repeat_Incentive__c item: listRepeatIncentives) {
   			yourMoney = yourMoney + item.Payment_Amount__c;
   		}
    }
}