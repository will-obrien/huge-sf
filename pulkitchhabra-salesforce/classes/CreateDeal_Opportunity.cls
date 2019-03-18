global class CreateDeal_Opportunity implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select Id, Name, StageName from Opportunity]);
    }
    global void execute(Database.BatchableContext BC, List<Opportunity> scope){
        List<Deal__c> nDeal=new List<Deal__c>();
        for(Opportunity o:scope){
            Deal__c d = new Deal__c();
            d.RecordTypeId='012280000000xXP';
            d.Deal_Id__c= o.Id;
            d.Name= o.Name;
            d.Opportunity__c=o.Id;
            d.Status__c=o.StageName;
            d.Type__c='Opportunity';
            nDeal.add(d);
        }
        insert nDeal;
    }
    global void finish(Database.BatchableContext BC){
        
    }

}