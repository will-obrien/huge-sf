@isTest
public class BulkOrderTrackingNumbers_test {

    static testMethod void unitTest_1(){
        
        test.startTest();
        BulkOrderTrackingNumbers file = new BulkOrderTrackingNumbers();
        file.contentFile = blob.valueOf('<xml><OpenShipment><ProcessMessage><test>test test</test></ProcessMessage></OpenShipment></xml>');
        file.fileName = 'test';
        file.ReadFile();
        test.stopTest();
    }
}