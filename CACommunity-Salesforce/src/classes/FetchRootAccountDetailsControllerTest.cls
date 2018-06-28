/**

Test Case for the following Controller Extension:
FetchRootAccountDetailsController

**/

@isTest 
public class FetchRootAccountDetailsControllerTest{
    static testMethod void validateFetchRootAccountDetails() {
    
      // create the root account  - record type = Root
     Account rootAccount = getrootAccount();
     insert rootAccount;
      
     // create a case
     Root_Case__c accountCase = getRootCase(rootAccount.id);
     insert accountCase;
     
     Root_Case__c rootCaseWithoutAccount = getRootCase(null);
     insert rootCaseWithoutAccount;
     
     // create a standard controller instance 
     ApexPages.StandardController standardcontroller = new ApexPages.StandardController(accountCase);
     
     FetchRootAccountDetailsController fetchRootAccController= new FetchRootAccountDetailsController(standardController);
     
     fetchRootAccController.showErrorMessage();
     
     fetchRootAccController.fetchRootAccountDetailsOnRootCase();
    
    // execute scenario where the case does not have any account
     standardcontroller = new ApexPages.StandardController(rootCaseWithoutAccount);
     fetchRootAccController= new FetchRootAccountDetailsController(standardController);
     fetchRootAccController.fetchRootAccountDetailsOnRootCase();     
    
    }
    
      public static Account getrootAccount()
    {
        Account rootAccount = new Account();
        rootAccount.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Root Certificate').getRecordTypeID();
        rootAccount.name = 'RootAccount';
        rootAccount.phone='2128425500';
        rootAccount.website  = 'https//www.test.com';
        rootAccount.company_website__c=  'https//www.test.com';
        return rootAccount;
    }
    
    
     public static Root_Case__c getRootCase(ID accountId)
    {
        Root_Case__c rootCaseDetailsSO = new Root_Case__c();
        rootCaseDetailsSO.Root_Certificate_Name_Existing__c=accountId;
        rootCaseDetailsSO.Root_Certificate_Name__c = 'Test Root';
        rootCaseDetailsSO.Request_Status__c = 'Initial Request Received';
        rootCaseDetailsSo.SHA_1_Fingerprint__c = '1:2:3:4:5';
        rootCaseDetailsSO.Certificate_Signature_Algorithm__c= 'Certificate name';
        rootCaseDetailsSO.Signing_Key_Parameters__c = 'Signing Key Parameters';
        rootCaseDetailsSO.Trust_Bits__c = 'Trust Bits';
        return rootCaseDetailsSO ;
    }
    
    
}