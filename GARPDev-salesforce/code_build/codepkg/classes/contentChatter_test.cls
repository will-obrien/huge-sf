@isTest
public class contentChatter_test {
   static content__c content;
    static void testData(){
        content = new Content__c();
        content.Content_Type__c = 'News Feed' ;
        content.Status__c = 'Draft' ;
        //content.Published_Date__c = system.today() ;
        content.Is_On_Demand__c = true;
        content.Raw_HTML__c = 'test';
        insert content;
    }
    static testMethod void unitTest_1(){
        testdata();
        test.startTest();
        ApexPages.currentPage().getParameters().put('contentId',content.id);
        contentChatter chatter = new contentChatter();
        test.stopTest();
    }
}