@isTest
private class GameTriggerTest 
{
    @testSetup
    private static void setup() 
    {
        
        Unit__c fighter1 = new Unit__c(Name = 'test unit1', HP__c = 600, Min_Damage__c = 10, Max_Damage__c = 30, 
                                       Victory_Quantity__c = 0, Top_Position__c = 0);
        Unit__c fighter2 = new Unit__c(Name = 'test unit2', HP__c = 600, Min_Damage__c = 10, Max_Damage__c = 30,
                                       Victory_Quantity__c = 0, Top_Position__c = 0);
        Unit__c fighter3 = new Unit__c(Name = 'test unit3', HP__c = 600, Min_Damage__c = 10, Max_Damage__c = 30,
                                       Victory_Quantity__c = 0, Top_Position__c = 0);
        List<Unit__c> updateList = new List<Unit__c>();
        updateList.add(fighter1);
        updateList.add(fighter2);
        updateList.add(fighter3);
        insert updateList;
    }
    
    @isTest 
    private static void triggerTest()
    {
        List<Unit__c> beforeUpdateList = [SELECT Id, Name, Victory_Quantity__c, Top_Position__c FROM Unit__c 
                                          WHERE Name IN ('test unit1', 'test unit2', 'test unit3')];
        
        Unit__c unit1Before = beforeUpdateList.get(0);
        Unit__c unit2Before = beforeUpdateList.get(1);
        Unit__c unit3Before = beforeUpdateList.get(2);
        
    	unit1Before.Victory_Quantity__c = 3;    
        unit2Before.Victory_Quantity__c = 5;
        unit3Before.Victory_Quantity__c = 1;
        
        update unit1Before;
        update unit2Before;
        update unit3Before;
        
        List<Unit__c> afterUpdateList = [SELECT Id, Name, Victory_Quantity__c, Top_Position__c FROM Unit__c 
                                WHERE Name IN ('test unit1', 'test unit2', 'test unit3')];
        
        Unit__c unit1After = afterUpdateList.get(0);
        Unit__c unit2After = afterUpdateList.get(1);
        Unit__c unit3After = afterUpdateList.get(2);
        
        system.assertEquals(1, unit2After.Top_Position__c);
        system.assertEquals(2, unit1After.Top_Position__c);
        system.assertEquals(3, unit3After.Top_Position__c);
    }
}
