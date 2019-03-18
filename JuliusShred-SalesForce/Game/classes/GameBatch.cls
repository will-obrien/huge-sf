/**
* This is Batch that checks if it's time for activating the units and make the recovery of units' stamina
*/
global class GameBatch implements Database.Batchable<sObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator([SELECT ID, HP__c, Active__c, Deactivation_Time__c, Stamina__c
                                      FROM Unit__c]);
    }
    global void execute(Database.BatchableContext BC, List<Unit__c> scope)
    {
        List<Unit__c> updateUnitList = new List<Unit__c>();
        DateTime nowMinus24Hours = DateTime.now().addDays(-1);
        Decimal staminaIncrementValue;
        for(Unit__c unit :(List<Unit__c>) scope)
        {
            if (unit.Deactivation_Time__c < nowMinus24Hours) 
            {
                unit.Active__c = true;
            }
            //the speed of stamina recovery depends on the units max Health Points
            staminaIncrementValue = unit.HP__c / 10;
            if (unit.Stamina__c + staminaIncrementValue <= 100)
            {
                unit.Stamina__c += staminaIncrementValue;
            } else
            {
                unit.Stamina__c = 100;
            }
            updateUnitList.add(unit);
        }
        update updateUnitList;
    }
    
    global void finish(Database.BatchableContext BC)
    {

    }   
}