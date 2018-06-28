/**

Test Case for the following Controller Extension:
PublicIntermediateCertsController

**/

@isTest 
public class PublicIntermediateCertsCtlrTest{

  static testMethod void validateTest() {
  
    Account parentAccount = getParentAccount();
     insert parentAccount;
     
     // create the child account - record type = Root
     Account childAccount = getChildAccount(parentAccount.id);
     insert childAccount;
  
     PageReference pageRef = Page.PublicIntermediateCerts;
  PublicIntermediateCertsController pacrc = new PublicIntermediateCertsController();
  pacrc.getCurrentDate();

  
  }
  
   public static Account getParentAccount()
    {
        Account parentAccount = new Account();
        parentAccount.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CA Owner').getRecordTypeID();
        parentAccount.name = 'ParentAccount';
        parentAccount.type = 'Owner';
        parentAccount.status__c= 'Included';
        parentAccount.Revocation_Status__c = 'Included';
        parentAccount.phone='2128425500';
        parentAccount.website  = 'https//www.test.com';
        parentAccount.valid_From_GMT__c= date.today()+1;
        parentAccount.valid_to_GMT__c= date.today()+10;
        parentAccount.company_website__c=  'https//www.test.com';
        parentAccount.organizational_type__c=  'Organizational Type';
        parentAccount.geographic_focus__c=  'Geographic focus';
        parentAccount.primary_market_customer_base__c = 'Primary Market';
        return parentAccount;
    }
    
     public static Account getChildAccount(ID parentAccountId)
    {
        Account childAccount = new Account();
        childAccount.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Intermediate Certificate').getRecordTypeID();
        childAccount.name = 'ChildAccount';
        childAccount.type = 'Root';
        childAccount.phone='2128425500';
        childAccount.Revocation_Status__c = 'Not Revoked';
        childAccount.website  = 'https//www.test.com';
        childAccount.valid_From_GMT__c= date.today()+1;
        childAccount.valid_to_GMT__c= date.today()+10;
        childAccount.company_website__c=  'https//www.test.com';
        childAccount.SHA_1_Fingerprint__c= '1:2:3:4:5:6:7:8:9:10';
        childAccount.parentid = parentAccountId;
        
        return childAccount;
    }

}