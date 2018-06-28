@isTest
public class NewsFeed_test {

    
    static testMethod void unitTest_1(){
        
        test.startTest();
        NewsFeed.GetFeedWrapper('test');
        Test.setMock(HttpCalloutMock.class, new MocKHttpResponseGenerator1());
       
        NewsFeed.getFeedMethod();
        
        test.stopTest();
    }
}