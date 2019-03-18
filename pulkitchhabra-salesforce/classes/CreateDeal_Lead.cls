global class CreateDeal_Lead implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select Id, FirstName, LastName, Status from Lead Where IsConverted=False]);
    }
    global void execute(Database.BatchableContext BC, List<Lead> scope){
        List<Deal__c> nDeal=new List<Deal__c>();
        for(Lead l:scope){
            Deal__c d = new Deal__c();
			d.RecordTypeId='012280000000xiT';
            d.Deal_Id__c= l.Id;
            d.Name= l.FirstName+' '+l.LastName;
            d.Lead__c=l.Id;
            d.Status__c=l.Status;
            d.Type__c='Lead';
            nDeal.add(d);
        }
        insert nDeal;
    }
    global void finish(Database.BatchableContext BC){
        
    }

}