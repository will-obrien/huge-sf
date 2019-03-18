@isTest (SeeAllData = true)
//@isTest
private class LeadEventHandler_Test {
    
    
    static testMethod void leadCoversionTest() {
        
        Group que = new Group(Name='Lead Queue', type='Queue');
        insert que;
        
        QueuesObject queSobj = new QueueSObject(QueueID = que.id, SobjectType = 'Lead');
        insert queSobj; 
        
        Test.startTest();
           //User u2 = [SELECT Id FROM User WHERE Alias='vvall'];
           User u2 = [select id from user where name = 'eCommerce Customer' and isactive=true limit 1];   
           System.RunAs(u2){
            //system.runas(new user(id=userinfo.getuserid())){ 
            Lead lead = PGITestUtilities.getLeadDetails();
            lead.ECommerce_Account_Number__c = 'Ecom-000000001';
            lead.ECommerce_Convert__c = false;
            lead.LeadSource = 'ECommerce Customer';
            lead.ECommerce_Convert__c= false;
            lead.DoNotSolicit__c = true;
            lead.ownerid = que.id;
            lead.Product_Interest__c = 'Web:iMeet';
            lead.company= 'eCommerce';
            lead.email = 'test@pgi.com';
            lead.phone = '201-201-2011';
            lead.Z_Source__c = 'eCommerce';
            lead.status = 'Qualifying';
               
            insert lead;
            
            LeadEventHandler.skipAfterEvent= false;
            
            lead.ownerid = que.id;
            lead.ECommerce_Convert__c= true;
            update lead;
                    
            Lead ld = [Select id, isConverted, ConvertedOpportunityId, convertedAccountId, ConvertedContactId from lead where id =: lead.id limit 1];
            system.assertEquals(ld.isConverted, true);
        }
        Test.stopTest();
    }
    

    static testMethod void NoleadCoversionTest() {
        Test.startTest();
        Group que = new Group(Name='Lead Queue', type='Queue');
        insert que;
        
        QueuesObject queSobj = new QueueSObject(QueueID = que.id, SobjectType = 'Lead');
        insert queSobj; 
        
        User u2 = [select id from user where name = 'eCommerce Customer' and isactive=true limit 1];   
        System.RunAs(u2){  
            Lead lead = PGITestUtilities.getLeadDetails();
            lead.firstName +='1';
            lead.Email='noLeadConversion@LeadEvents.com';
            lead.ECommerce_Account_Number__c = 'Ecom-000000001';
            lead.ECommerce_Convert__c = false;
            lead.LeadSource = 'ECommerce Customer';
            lead.ECommerce_Convert__c= false;
            lead.Product_Interest__c = 'Web:iMeet';
            lead.DoNotSolicit__c = true;
            lead.ownerid = que.id;
            lead.company= 'eCommerce';
            lead.Z_Source__c = 'eCommerce';
            lead.email = 'test@pgi.com';
            lead.phone = '201-201-2011';
            lead.status = 'Qualifying';
            insert lead;

            
            LeadEventHandler.skipAfterEvent= false;
            
            lead.LeadSource = 'Qualifying';
            update lead;
            
            Lead ld = [Select id, ECommerce_Convert__c, LeadSource, isConverted, ConvertedOpportunityId, convertedAccountId, ConvertedContactId from lead where id =: lead.id limit 1];
            //system.assert(ld.isConverted == false);
            //system.assert(lead.LeadSource <> 'ECommerce Customer' || lead.ECommerce_Convert__c == true);
        }
        
        Test.stopTest();
    }
    //}
}