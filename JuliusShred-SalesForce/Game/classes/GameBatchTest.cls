@isTest
public class GameBatchTest 
{
    static testMethod void gameBatchTest()
    {
        //creating data
        Unit__c unit1 = new Unit__c(Name = 'Unit1', HP__c = 100, minDMG__c = 10, maxDMG__c = 20, Active__c = false, Deactivation_Time__c = DateTime.now().addDays(-1), Stamina__c = 0);
        Unit__c unit2 = new Unit__c(Name = 'Unit2', HP__c = 100, minDMG__c = 10, maxDMG__c = 20, Active__c = false, Deactivation_Time__c = DateTime.now().addDays(-1), Stamina__c = 0);
        Unit__c unit3 = new Unit__c(Name = 'Unit3', HP__c = 100, minDMG__c = 10, maxDMG__c = 20, Active__c = false, Deactivation_Time__c = DateTime.now().addDays(-1), Stamina__c = 70);
        Unit__c unit4 = new Unit__c(Name = 'Unit4', HP__c = 100, minDMG__c = 10, maxDMG__c = 20, Active__c = false, Deactivation_Time__c = DateTime.now().addDays(-1), Stamina__c = 80);
        Unit__c unit5 = new Unit__c(Name = 'Unit5', HP__c = 100, minDMG__c = 10, maxDMG__c = 20, Active__c = false, Deactivation_Time__c = DateTime.now().addDays(-1), Stamina__c = 95);
        List<Unit__c> unitDataList = new List<Unit__c>();
        unitDataList.add(unit1);
        unitDataList.add(unit2);
        unitDataList.add(unit3);
        unitDataList.add(unit4);
        unitDataList.add(unit5);
        insert unitDataList;
        
        //starting our test
        Test.startTest();
        Database.executeBatch(new gameBatch());
        Test.stopTest();
        
        List<Unit__c> unitsList = [SELECT Id, Stamina__c, Active__c 
                                   FROM Unit__c 
                                   WHERE Active__c = true];
        System.assertEquals(5, unitsList.size());
        
        for(Unit__c i: unitsList)
        {
            System.assert(i.Stamina__c >= 10);
            System.assertEquals(true, i.Active__c, 'Error: Unit must be active.');
        }
    }    
}