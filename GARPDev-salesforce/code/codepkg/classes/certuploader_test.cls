@isTest
public class certuploader_test {

    static testMethod void unitTest_1(){
        
        test.startTest();
        certuploader file = new certuploader();
        file.contentFile = blob.valueOf('<xml><OpenShipment><ProcessMessage><test>test test</test></ProcessMessage></OpenShipment></xml>');
        file.fileName = 'test';
        file.ReadFile();
        test.stopTest();
    }
}