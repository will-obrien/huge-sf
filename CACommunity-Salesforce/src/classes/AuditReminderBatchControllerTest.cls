/**************************************************************************************

Test Case for the following Controller Extensions:

** AuditReminderBatchHelper - Executes the logic for sending the reminder emails to 
   the CA Owners based on Standard/BR/EV audit dates.
** AuditReminderBatchController - controller class for the RunAuditReminderBatch VF page
   which displays status of batch jobs.
** AuditReminderBatch - implements Database.Batchable for each record selected for 
   processing.

**/

@isTest 

public class AuditReminderBatchControllerTest {
    
    static testMethod void myTestForAuditReminder() {
      
   
     
        
     // create the parent account  - record type = Owner
     Account parentAccount = getParentAccount();
     insert parentAccount;
     parentAccount.status__c = 'Included';
     update parentAccount;
        
     // create the contact associated with the parent account
     Contact parentContact = getParentContact(parentAccount.id);
     insert parentContact;
             
     // create the child accounts - record type = Root
     Account childAccount1 = getChildAccount1(parentAccount.id);
     insert childAccount1;
     childAccount1.status__c = 'Included';
     update childAccount1;
     Account childAccount2 = getChildAccount2(parentAccount.id);
     insert childAccount2;
     childAccount2.status__c = 'Included';
     update childAccount2;
     Account childAccount3 = getChildAccount3(parentAccount.id);
     insert childAccount3;
     childAccount3.status__c = 'Included';
     update childAccount3;
     
     // create a CA Program user
     User CAUser = getUser();
        
     // system.debug('accountLst='+accountLst);
                
     // *************************** START PROCESS ***********************************      
        
        // Start the test
        Test.startTest();
           
        AuditReminderBatchController batchController = new AuditReminderBatchController();
        batchController.startBatch();        
        batchJobs batchJobsController = new BatchJObs();
        batchJobsController.getBatchJobs();
        AuditReminderBatchSchedulerClass.scheduleMe();
        
     // ***************************** END PROCESS ***********************************
        
     // End the test
     Test.stopTest();
        
        
    }
    
    public static Account getParentAccount()
    {
        Account parentAccount = new Account();
        parentAccount.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CA Owner').getRecordTypeID();
        parentAccount.name = 'ParentAccount';
        parentAccount.type = 'Owner';
        parentAccount.CA_Email_Alias_1__c='EmailAlias1@Company.junk';
        parentAccount.CA_Email_Alias_2__c='EmailAlias2@Company.junk';
        parentAccount.website  = 'https//www.test.com';
        parentAccount.valid_From_GMT__c= date.today()+1;
        parentAccount.valid_to_GMT__c= date.today()+10;
        parentAccount.company_website__c=  'https//www.test.com';
        parentAccount.organizational_type__c=  'Organizational Type';
        parentAccount.geographic_focus__c=  'Geographic focus';
        parentAccount.status__c = 'Included';
        return parentAccount;
    }

    public static Contact getParentContact(ID accountid)
    {
        Contact parentContact = new Contact();
        parentcontact.firstname = 'FirstName';
        parentcontact.accountid = accountId;
        parentcontact.lastname = 'LastName';
        parentcontact.email= 'LastName@firstname.com';
        parentcontact.phone= '456786588';
        parentcontact.type__c= 'Primary POC';
        
        return parentContact;
    }

   public static Account getChildAccount1(ID parentAccountId)
    {
        Account childAccount = new Account();
        childAccount.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Root Certificate').getRecordTypeID();
        childAccount.name = 'ChildAccount1';
        childAccount.parentid = parentAccountId;
        childAccount.type = 'Root';
        childAccount.valid_From_GMT__c= date.today()+1;
        childAccount.valid_to_GMT__c= date.today()+10;
        childAccount.SHA_1_fingerprint__c= '1:2:3:4:5:6:7:8:9:10';
        childAccount.Trust_Bits__c = 'Email';
        childAccount.Standard_Audit__c = 'StandardAudit.pdf';
        childAccount.Standard_Audit_Statement_Date__c = date.today()-396; // courtesy reminder for 1yr + 30 to 120 days old
        childAccount.Standard_Audit_Type__c = 'WebTrust';
        childAccount.BR_Audit__c = 'BRAudit.pdf';
        childAccount.BR_Audit_Statement_Date__c = date.today();
        childAccount.BR_Audit_Type__c = '';
        childAccount.EV_Audit__c = 'EVAudit.pdf';
        childAccount.EV_Audit_Statement_Date__c = date.today();
        childAccount.EV_Audit_Type__c = '';
        childAccount.ev_policy_oid_s__c = '';
        childAccount.status__c = 'Included';
        return childAccount;
    }
    
    public static Account getChildAccount2(ID parentAccountId)
    {
        Account childAccount = new Account();
        childAccount.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Root Certificate').getRecordTypeID();
        childAccount.name = 'ChildAccount2';
        childAccount.parentid = parentAccountId;
        childAccount.type = 'Root';
        childAccount.valid_From_GMT__c= date.today()+1;
        childAccount.valid_to_GMT__c= date.today()+10;
        childAccount.SHA_1_fingerprint__c= '1:2:3:4:5:6:7:8:9:10';
        childAccount.Trust_Bits__c = 'Email;Websites';
        childAccount.Standard_Audit__c = 'StandardAudit.pdf';
        childAccount.Standard_Audit_Statement_Date__c = date.today();
        childAccount.Standard_Audit_Type__c = 'WebTrust';
        childAccount.BR_Audit__c = 'BRAudit.pdf';
        childAccount.BR_Audit_Statement_Date__c = date.today()-490; // overdue reminder for 1yr + 120 to 240 days old
        childAccount.BR_Audit_Type__c = 'WebTrust';
        childAccount.EV_Audit__c = 'EVAudit.pdf';
        childAccount.EV_Audit_Statement_Date__c = date.today();
        childAccount.EV_Audit_Type__c = '';
        childAccount.ev_policy_oid_s__c = '';
        childAccount.status__c = 'Included';
        return childAccount;
    }
    
    public static Account getChildAccount3(ID parentAccountId)
    {
        Account childAccount = new Account();
        childAccount.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Root Certificate').getRecordTypeID();
        childAccount.name = 'ChildAccount3';
        childAccount.parentid = parentAccountId;
        childAccount.type = 'Root';
        childAccount.valid_From_GMT__c= date.today()+1;
        childAccount.valid_to_GMT__c= date.today()+10;
        childAccount.SHA_1_fingerprint__c= '1:2:3:4:5:6:7:8:9:10';
        childAccount.Trust_Bits__c = 'Email;Websites';
        childAccount.Standard_Audit__c = 'StandardAudit.pdf';
        childAccount.Standard_Audit_Statement_Date__c = date.today();
        childAccount.Standard_Audit_Type__c = 'WebTrust';
        childAccount.BR_Audit__c = 'BRAudit.pdf';
        childAccount.BR_Audit_Statement_Date__c = date.today();
        childAccount.BR_Audit_Type__c = 'WebTrust';
        childAccount.EV_Audit__c = 'EVAudit.pdf';
        childAccount.EV_Audit_Statement_Date__c = date.today()-610; // Danger of Removal reminder for 1yr + 240+ days old
        childAccount.EV_Audit_Type__c = 'Webtrust';
        childAccount.ev_policy_oid_s__c = 'Some data';
        childAccount.status__c = 'Included';
        return childAccount;
    }
    
    public static User getUser()
    {
        Profile CAProfile = [SELECT Id FROM Profile WHERE Name='Standard User - Mozilla']; 
        
        User CAUser = new User(Alias = 'CAUser', 
                               Email='CAUser@mozilla.com', 
                               UserName='CAUser@mozilla.com',
                               CA_Program_Manager__c = True,
                               ProfileId = CAProfile.Id
                              );       
        return CAUser;
    }
 
}