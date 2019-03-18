@isTest
public class MAPS_Delete_Old_Records_Test {
    static testMethod void unitTest(){
         Test.startTest();
        List<sObject> mREP = Test.loadData(MAPS_Reporting__c.sObjectType,'MAPSStaticRecords');
        
       /* MAPS_Delete_Old_Records delMAPS = new MAPS_Delete_Old_Records();
        delMAPS.deleteMAPSRecords();*/
        
        MAPS_Delete_Old_Records_Scheduler delMAPS = new MAPS_Delete_Old_Records_Scheduler();
        String sch = '0 0 18 * * ?';
        system.schedule('MAPS_Delete_Old_Records', sch, delMAPS); 
        Test.stopTest(); 
    }
}