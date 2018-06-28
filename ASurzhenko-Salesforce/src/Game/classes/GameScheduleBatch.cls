/**
 * This is global GameScheduleBatch class
 * When we execute the class, it changes Stamina__c field from List of units (List<Unit__c> unitsToUpdateList)
 * if Stamina__c < 100
 * We will execute this batch from ScheduleGameUpdate class by using System.schedule() method
 * System.schedule() method will create a job to execute this class every day in midnight:
 * System.schedule('Update unit stamina', '0 0 0 * * ?', new ScheduleGameUpdate());   
*/
global class GameScheduleBatch implements Database.Batchable<sObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator([SELECT Id, Stamina__c FROM Unit__c 
                                         WHERE Stamina__c < 100]);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        List<Unit__c> unitsToUpdateList = new List<Unit__c>();
        
        for(Unit__c item : (List<Unit__c>) scope)
        {
            item.Stamina__c = 100;   
            unitsToUpdateList.add(item);
        }
        
        update unitsToUpdateList;
    }
    
    global void finish(Database.BatchableContext BC)
    {	
    	
    }
}
