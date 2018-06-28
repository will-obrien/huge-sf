@isTest
public class concontentupdateinsert_test{

    static testMethod void unitTest_1(){
        
        test.startTest();
        Content__c content = new Content__c();
        content.Content_Type__c = 'News Feed' ;
        content.Status__c = 'Draft' ;
        //content.Published_Date__c = system.today() ;
        content.Is_On_Demand__c = true;
        content.Raw_HTML__c = 'test';
        insert content;
        update content;
        test.stopTest();
    }
}