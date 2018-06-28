/**

Test Case for the following Controller Extension:
FetchAccountDetailsController

**/

@isTest 
public class FetchAccountDetailsControllerTest{
    static testMethod void validateFetchAccountDetails() {
    
      // create the parent account  - record type = Owner
     Account parentAccount = getParentAccount();
     insert parentAccount;
      
     // create a case
     Case accountCase = getCase(parentAccount.id);
     insert accountCase;
     
     Case caseWithoutAccount = getCase(null);
     insert caseWithoutAccount;
     
     // create a standard controller instance 
     ApexPages.StandardController standardcontroller = new ApexPages.StandardController(accountCase);
     
     FetchAccountDetailsController fetchAccController= new FetchAccountDetailsController(standardController);
     
     fetchAccController.showErrorMessage();
     
     fetchAccController.fetchAccountDetailsOnCase();
    
    // execute scenario where the case does not have any account
     standardcontroller = new ApexPages.StandardController(caseWithoutAccount);
     fetchAccController= new FetchAccountDetailsController(standardController);
     fetchAccController.fetchAccountDetailsOnCase();     
    
    }
    
      public static Account getParentAccount()
    {
        Account parentAccount = new Account();
        parentAccount.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CA Owner').getRecordTypeID();
        parentAccount.name = 'ParentAccount';
        parentAccount.phone='2128425500';
        parentAccount.website  = 'https//www.test.com';
        parentAccount.company_website__c=  'https//www.test.com';
        return parentAccount;
    }
    
    
     public static Case getCase(ID accountId)
    {
        Case caseDetailsSO = new CAse();
        caseDetailsSO.accountid=accountId;
        caseDetailsSO.company_website__c = 'https://www.test1233.com';
        return caseDetailsSO ;
    }
    
    
}