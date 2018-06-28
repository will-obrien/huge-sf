public without sharing class DirectoryOptOut{

    public PageReference DirectoryOptOut() {
       
        
        String userId = ApexPages.currentPage().getParameters().get('id');
        
        System.debug('ID: ' + userId);  
 
        
        if(userId != null) {
            List<Contact> lstContact = [SELECT Id, Name, GARP_Directory_Invite_Opt_Out__c FROM Contact WHERE Id = :userId];
            
            System.debug('lstContact: ' + lstContact);  
            
            if( lstContact != null && lstContact.size() > 0 ) {   
                Contact con = lstContact[0];
                con.GARP_Directory_Invite_Opt_Out__c = true;
                update con;
                 
            }        
        }
        return null;
    }


   
}