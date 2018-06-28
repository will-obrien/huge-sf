public without sharing class BloombergOptIn{

    public PageReference BloombergOptIn() {
       
        
        String userId = ApexPages.currentPage().getParameters().get('id');
        
        System.debug('ID: ' + userId);  
 
        
        if(userId != null) {
            List<Contact> lstContact = [SELECT Id, Name, Bloomberg_Profile_Opt_In__c FROM Contact WHERE Id = :userId];
            
            System.debug('lstContact: ' + lstContact);  
            
            if( lstContact != null && lstContact.size() > 0 ) {   
                Contact con = lstContact[0];
                con.Bloomberg_Profile_Opt_In__c = true;
                update con;
                 
            }        
        }
        return null;
    }


   
}