// *************************************************************************/
// UserLookupsExtension Class
//      VB: This class is a User standard controller extension that 
//			pulls the list of User Lookup records associated with a   
//          specific user.  This is so the User detail page can display  
//          this list of records, which isn't allowed due to the
//			limitations around Users and lookup fields and related lists.
//           
//  2016/06/22      Vernon Baas         Original
// *************************************************************************/
public with sharing class UserLookupsExtension {

	// This is the list that is displayed on the VF page
	public List<User_Lookups__c> UserLookups {get; set;}
    
	public UserLookupsExtension(ApexPages.StandardController controller) {
		
        UserLookups = new List<User_Lookups__c>();	// Initialize the list
		User thisUser  = (User) controller.getRecord();    //Get User from controller.
        
		//Query and loop through the (hopefully one) lookups.
        for (User_Lookups__c theLookup : [Select Chapter__c, Contact__c from User_Lookups__c where User__c = :thisUser.Id]) {
        	
            UserLookups.add(theLookup);
        }
    }
    
}