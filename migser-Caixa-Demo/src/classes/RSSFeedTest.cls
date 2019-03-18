@isTest(SeeAllData=true)
public class RSSFeedTest {
    @isTest static void testRss() {
        System.Test.startTest();
        System.Test.setMock(HttpCalloutMock.class,new RSSMockCallout());
        DE_RSSUtil.getRSSFeedObjects('test');
        DE_RSSObject o = new DE_RSSObject('test','test','test','Wed, 02 Dec 2015 09:54:10 -0500');
        System.Test.stopTest();
        
    }
}