@isTest
public class uploadAttchment_test {

    static testMethod void unitTest_1(){
        
        test.startTest();
        uploadAttchment att = new uploadAttchment();
        att.upload();
        test.stopTest();
    }
    
}