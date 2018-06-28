@isTest
public class JWileyJournal_test {

    static testMethod void myUnitTest_1() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MocKHttpResponseGenerator1());
        JWileyJournal journal = new JWileyJournal();
        
 		test.stopTest();
    }
    
    
    
   
}