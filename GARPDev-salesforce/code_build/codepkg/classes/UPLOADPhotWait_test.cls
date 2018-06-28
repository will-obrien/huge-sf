@isTest
public class UPLOADPhotWait_test {
    
    static testMethod void unitTest_1(){
        test.startTest();
        uploadPhotoWait photowait = new uploadPhotoWait();
        photowait.incrementCounter();
        photowait.getCount();
        test.stopTest();
    }

}