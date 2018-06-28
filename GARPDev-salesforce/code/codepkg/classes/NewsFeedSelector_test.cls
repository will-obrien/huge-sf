@isTest
public class NewsFeedSelector_test {

    static void testData(){
        
        Content__c content = new Content__c();
        content.Content_Type__c = 'News Feed' ;
        content.Status__c = 'Draft' ;
        content.Published_Date__c = system.today() ;
        content.Is_On_Demand__c = true;
        insert content;
    }
    static testMethod void unitTest_1(){
        test.startTest();
        testData();
        NewsFeedSelector feed = new NewsFeedSelector();
        feed.fetchRecords();
        feed.publish();
        test.stopTest();
    }
}