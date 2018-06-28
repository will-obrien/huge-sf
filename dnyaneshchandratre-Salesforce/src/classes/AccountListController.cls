/** Title    : Custom controller for AccountList.page and RelatedContacts.page
 *  Author   : Dnyanesh Chandratre
 */
global with sharing class AccountListController {

    global static List<Account> listAccount;
    List<Contact> relatedContacts;
    public static Boolean searchFlag = false;
    public Integer countOfRecords {get;set;}
    public static String searchKey {get;set;}
    public Id idOfAccount {get;set;}
    public String nameOfAccount {get;set;}

    global static List<Account> getListAccount() {
        if(!searchFlag) {
            listAccount = [SELECT Id,
                                  Name,
                                  Email_Address__c,
                                  Phone,
                                  Website
                           FROM Account
                           ORDER BY Name
                           LIMIT 1000];

        } else {
            listAccount = [SELECT Id,
                                  Name,
                                  Email_Address__c,
                                  Phone,
                                  Website
                           FROM Account
                           WHERE Name like : '%' + searchKey.trim() + '%'
                           ORDER BY Name
                           LIMIT 1000];

        }
        
        return(listAccount);
    }

    @RemoteAction
    global static void searchAccounts() {
        if(String.isEmpty(searchKey) || String.isBlank(searchKey)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,
                                                       'Please enter at least 3 characters to perform search'));
            searchFlag = false;
        } else {
            searchFlag = true;
            //getListAccount();
        }
    }

    public PageReference RedirectToContacts() {
        idOfAccount = ApexPages.currentPage().getParameters().get('aid');
        nameOfAccount = ApexPages.currentPage().getParameters().get('an');
        PageReference pageRef = Page.RelatedContacts;
        pageRef.getParameters().put('aid', idOfAccount);
        pageRef.getParameters().put('an', nameOfAccount);
        pageRef.setRedirect(true);
        return pageRef;
    }

    public List<Contact> getRelatedContacts() {
        idOfAccount = ApexPages.currentPage().getParameters().get('aid');
        nameOfAccount = ApexPages.currentPage().getParameters().get('an');
        List<Contact> relatedContacts = [SELECT Id,
                                                Name,
                                                Phone,
                                                MobilePhone
                                         FROM Contact 
                                         WHERE AccountId =: idOfAccount];
        countOfRecords = relatedContacts.size();
        if(!relatedContacts.isEmpty()) {
            return relatedContacts;
        }
        else {
            return NULL;
        }
    }

    public PageReference returnToAccount() {
        return Page.AccountList;
    }
    
    public void clearList() {
        searchKey = '';
        searchFlag = false;
    }

}