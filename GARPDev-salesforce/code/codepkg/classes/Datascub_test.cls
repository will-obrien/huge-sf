@isTest
public class Datascub_test {


    static void testData(){
        
    }
    static testMethod void unitTest_1(){
        testdata();
        test.starttest();
        Datascub scub = new Datascub();
        scub.contentFile = blob.valueOf('test');
        Datascub.missingWrapper wrp = new Datascub.missingWrapper('test','test','test','test');
        scub.compareData();
        scub.checkForUnmatchingRecords(new string[] {''});
        
        test.stopTest();
    }

}