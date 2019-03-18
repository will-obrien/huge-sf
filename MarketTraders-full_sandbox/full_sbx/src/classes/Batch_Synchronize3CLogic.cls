global class Batch_Synchronize3CLogic implements Database.Batchable<sObject>, Database.AllowsCallouts,Database.Stateful{

    public String query;

    global Batch_Synchronize3CLogic(){
        this.query = 'SELECT Id, OwnerId, Owner_Name__c, x3Clogic_Stage_Score__c, Account_Phone__c, Account_Email__c, StageName, Product__c, Account_First_Name__c, Account_Last_Name__c, X3CLogic_Previous_Owner__c, X3CLogic_Status__c, X3CLogic_Previous_Owner__r.FirstName, X3CLogic_Previous_Owner__r.LastName FROM Opportunity WHERE X3CLogic_Status__c != null';
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Opportunity> scope){
        for(Opportunity opp : scope){
            Synchronize_3CLogic syncManager = new Synchronize_3CLogic(opp);
            syncManager.synchronize();
            opp.X3CLogic_Status__c = null;
            opp.X3CLogic_Previous_Owner__c = null;
        }
        Database.update(scope);
    }
   
   global void finish(Database.BatchableContext BC){
            
   }
    
}