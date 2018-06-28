/**
 * This is global GameBatch class
 * When we execute the class, it changes Stamina__c field from List of units (List<Unit__c> unitsToUpdateList)
 * if Stamina__c < 100
 * In finish method System.scheduleBatch will run and the job will be created that will execute GameBatch class 
 * again in 180 minutes, so the GameBatch class will execute every 180 minutes   
*/
global class GameBatch implements Database.Batchable<sObject>
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
            item.Stamina__c += 10;   
            unitsToUpdateList.add(item);
        }
        
        update unitsToUpdateList;
    }
    
    global void finish(Database.BatchableContext BC)
    {	
    	System.scheduleBatch(new GameBatch(), 'Stamina changes', 180);
    }
}
