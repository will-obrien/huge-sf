@RestResource(urlMapping='/verifyAuth/*')
   
global with sharing class verifyAuth {

    @HttpPost
    global static authResponse echoMyType(String userId) {
        
        authResponse ar = new authResponse();
        
        List<Contact> lstContact = [SELECT Id, FirstName, LastName, Email, GARP_Member_ID__c, GARP_ID__c, Membership_Type__c FROM Contact WHERE GARP_Member_ID__c = :userId];
        if( lstContact != null && lstContact.size() > 0 ) {       
        	ar.firstName = lstContact[0].FirstName;
            ar.lastName = lstContact[0].LastName;
            ar.email = lstContact[0].Email;
        }
        return ar;
    }

    global class authResponse {

        global String firstName { get; set; }      
        global String lastName { get; set; }
        global String email { get; set; }

    }
    
}