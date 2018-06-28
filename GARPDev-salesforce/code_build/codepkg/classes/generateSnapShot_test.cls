@isTest
public class generateSnapShot_test {

    static testMethod void unitTest_1(){
        
        test.startTest();
        Snapshot__c  snapshot = new Snapshot__c ();
        //snapshot.Snapshot_Date__c = system.today();
        //insert snapshot;
        ApexPages.StandardController controller = new ApexPages.StandardController(snapshot);
        generateSnapShot genSnapShot = new generateSnapShot(controller);
        gensnapshot.createSnapShot();
        
        test.stopTest();
    }
    
}