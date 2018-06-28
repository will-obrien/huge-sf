@isTest
public class selfServiceControllerTest {
    static testMethod void myTest() {
        Callback__c testCall = new Callback__c();
        
        selfServiceController.createCase('test','test','test');
    }
}