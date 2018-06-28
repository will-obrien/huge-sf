@isTest
public class UploadFile_test {

    static testMethod void unitTest_1(){
        
        test.startTest();
        uploadFile file = new uploadFile();
        file.contentFile = blob.valueOf('<xml><OpenShipment><ProcessMessage><test>test test</test></ProcessMessage></OpenShipment></xml>');
        file.fileName = 'test';
        file.ReadFile();
        test.stopTest();
    }
}