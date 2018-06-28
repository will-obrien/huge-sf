@isTest
public class getcontentURL_test {
    static testMethod void unitTest_1(){
        test.startTest();
        try{
        getcontentURL contentUrl = new getcontentURL();
        contentUrl.getContentURL();
        }catch(Exception ex){}
        test.stopTest();
        
    }

}