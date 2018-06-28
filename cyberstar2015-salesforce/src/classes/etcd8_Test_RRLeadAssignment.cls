/*
 * eightCloud (2014)
 * Test class for etcd8_LeadRecipientController class
 */
@isTest
private class etcd8_Test_RRLeadAssignment {
 
    static testMethod void testRRLeadAssignment() {
       
      Profile pfl = [select id from profile where name='Standard User'];  
         
      List<User> lstUser  = new List<User>();      
      for(Integer i = 0 ;i<2;i++) {
        User testUser = getUserObject(pfl,'test'+i); 
        lstUser.add(testUser);  
      } 
      insert lstUser;
      Boolean setNextFlag = false;   
      list<etcd8_LeadRecipient__c> lstRecipient = new list<etcd8_LeadRecipient__c>();                      
      for(User usr : lstUser) {
        etcd8_LeadRecipient__c recipient;
        if(!setNextFlag) {
          recipient = getLeadRecipient(usr,true,true);
          setNextFlag = true;
        }
        else {
          recipient = getLeadRecipient(usr,false,true);
        }
        
        lstRecipient.add(recipient);        
      }                        
      insert lstRecipient;
      
      List<Lead> lstLead = new List<Lead>();
      List<QueueSobject> lstUnassignedQueue = [SELECT QueueId From QueueSobject WHERE Queue.Name = 'Unassigned'];
      for(integer i = 0; i < 201 ; i++) { 
        lstLead.add(new Lead(LastName = 'lead'+i,Company='lead'+i));
      }
      insert lstLead;
      for(Lead lead : lstLead) { 
        lead.OwnerId = lstUnassignedQueue[0].QueueId;
      }
      update lstLead;
      List<Lead> lstLeads = [Select OwnerId,Lead_Recipient__c FROM Lead Where Id IN :lstLead order by lastname];
      //To add some asserts
      system.assert(lstLeads[0].OwnerId == lstUser[0].Id);
      system.assert(lstLeads[0].Lead_Recipient__c == lstRecipient[0].Id);   
      
      
      //To check that leads remains in Unasssigned queue if none of the recipient is not available
      for(etcd8_LeadRecipient__c leadRecip : lstRecipient) {
        leadRecip.available__c = false;
      }
      update lstRecipient;
      
      lstLead = new List<Lead>();
      for(integer i = 0; i < 201 ; i++) { 
        lstLead.add(new Lead(LastName = 'lead'+i,Company='lead'+i));
      }
      insert lstLead;
      for(Lead lead : lstLead) { 
        lead.OwnerId = lstUnassignedQueue[0].QueueId;
      }
      update lstLead;
      lstLeads = [Select OwnerId,Lead_Recipient__c FROM Lead Where Id IN :lstLead order by lastname];
      system.assert(lstLeads[0].OwnerId == lstUnassignedQueue[0].QueueId);
    }
    
    /******************************************************************************************
     * Method to test that lead is assigned to default lead owner in case none of the recipients are available
     ******************************************************************************************/   
     static testMethod void testRRLeadAssignmentDefaultOwner() {
       
      Profile pfl = [select id from profile where name='Standard User'];  
      
      List<User> lstUser  = new List<User>();      
      for(Integer i = 0 ;i<2;i++) {
        User testUser = getUserObject(pfl,'test'+i); 
        lstUser.add(testUser);  
      } 
      insert lstUser;
      Boolean setNextFlag = false;   
      list<etcd8_LeadRecipient__c> lstRecipient = new list<etcd8_LeadRecipient__c>();                      
      for(User usr : lstUser) {
        etcd8_LeadRecipient__c recipient;
        if(!setNextFlag) {
          recipient = getLeadRecipient(usr,true,false);
          setNextFlag = true;
        }
        else {
          recipient = getLeadRecipient(usr,false,false);
        }
        
        lstRecipient.add(recipient);        
      }                        
      insert lstRecipient;
       
      List<Lead> lstLead = new List<Lead>();
      List<QueueSobject> lstUnassignedQueue = [SELECT QueueId From QueueSobject WHERE Queue.Name = 'Unassigned'];
      for(integer i = 0; i < 201 ; i++) { 
        lstLead.add(new Lead(LastName = 'lead'+i,Company='lead'+i));
      }
      insert lstLead;
      for(Lead lead : lstLead) { 
        lead.OwnerId = lstUnassignedQueue[0].QueueId;
      }
      update lstLead;
      List<Lead> lstLeads = [Select OwnerId,Lead_Recipient__c FROM Lead Where Id IN :lstLead order by lastname];
      //To add some asserts
      system.assert(lstLeads[0].OwnerId == lstUnassignedQueue[0].QueueId);
      system.assert(lstLeads[0].Lead_Recipient__c == NULL);   
    
    }

    /******************************************************************************************
     * Create user record
     ******************************************************************************************/    
    public static User getUserObject(Profile pfl,String username) {
        return new User(alias = username, email='u1@testorg.com',emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                               localesidkey='en_US', profileid = pfl.Id,  country='United States', CommunityNickname = username,
                               timezonesidkey='America/Los_Angeles', username=username + Datetime.now().hour() + Datetime.now().minute() + Datetime.now().second() +'@testorg.com');
    }
    
    /******************************************************************************************
     * Create lead recipient record
     ******************************************************************************************/
    public static etcd8_LeadRecipient__c getLeadRecipient(User usr,Boolean next,Boolean available) {
        return new etcd8_LeadRecipient__c(user__c = usr.Id, available__c = available,nextUp__c = next);
    }

}