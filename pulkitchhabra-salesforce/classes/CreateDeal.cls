global class CreateDeal implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select Id, FirstName, LastName, Salutation, Status from Lead Where IsConverted=False]);
    }
    global void execute(Database.BatchableContext BC, List<Lead> scope){
        List<Deal__c> nDeal=new List<Deal__c>();
        for(Lead l:scope){
            for(Deal__c d:[Select Id, Name, Deal_ID__C from Deal__c]){
                if(d.Deal_Id__c==l.Id){  
                d.RecordTypeId='012280000000xiT';
                d.Deal_Id__c= l.Id;
                if(l.Salutation!=Null){
                    d.Name=l.Salutation+' '+l.FirstName+' '+l.LastName; 
                }
                else{
                    d.Name= l.FirstName+' '+l.LastName;
                }
                d.Lead__c=l.Id;
                d.Status__c=l.Status;
                d.Type__c='Lead';
                nDeal.add(d);
                }    
           }     
        }
        update nDeal;
    }
    global void finish(Database.BatchableContext BC){
        
    }

}