@isTest
public class NewsFeedEditor_test {

    static void testData() {
        
        Id recordTypeID = RecordTypeHelper.GetRecordTypeId('Content__c','News Feed');
        
        Content__c content = new Content__c();
        content.Content_Type__c = 'News Feed' ;
        content.Status__c = 'Draft' ;
        content.Published_Date__c = system.today() ;
        content.Is_On_Demand__c = true;
        content.RecordTypeId = recordTypeId;
        insert content;
        
        content = new Content__c();
        content.Content_Type__c = 'Webcast' ;
        content.Status__c = 'Draft' ;
        content.Published_Date__c = system.today() ;
        content.Is_On_Demand__c = true;
        content.RecordTypeId = recordTypeId;
        insert content;
    }
    
    static testMethod void unitTest_1() {
        test.startTest();
        testData();
        NewsFeedEditor feed = new NewsFeedEditor();
        feed.startDate.Published_Date__c = Date.today().addDays(-1);
        feed.endDate.Published_Date__c = Date.today().addDays(1);
        feed.fetchRecords();
        Decimal foundNumber = feed.FoundNumber;
        System.assert(foundNumber == 2);
        Content__c [] cust = feed.cust;
        for (Content__c content : cust) {
            content.Is_On_Demand__c = true;
        }
        feed.filterRecords();
        feed.publish();
        feed.sendEmail();
        test.stopTest();
    }
}