global class closelostoppafterexam implements Database.Batchable<SObject>
{
   List<Exam_Date__c > lstDate = Exam_Date__c.getAll().values();
    global Date datExam = lstDate[0].Date__c;
    global string stagename = 'New Lead';
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id, Opportunity__c,Opportunity_StageName__c,Cancelled__c from Exam_Attempt__c where Opportunity_StageName__c =:stagename and Cancelled__c=false and Exam_Date__c =:datExam');
     }
    
    
    global void execute(Database.BatchableContext BC, List<Exam_Attempt__c> scope){
        
         Map<Id,Id> oppids = new Map<Id,Id>();
        List<Exam_Attempt__c> lstea = new List<Exam_Attempt__c>();
        system.debug('scope *****:'+scope);
        for(Exam_Attempt__c obj : Scope)
        {
            obj.Cancelled__c = true;
              lstea.add(obj);
               oppids.put(obj.id,obj.Opportunity__c);
              system.debug('*****:'+oppids);
        }


       update lstea;
      // update op;
      List<Opportunity> lstOpp = new List<Opportunity>();
      for(Opportunity opp : [select id,StageName from Opportunity where id in :oppids.values()])
      {
           opp.StageName = 'Closed Lost';
           lstOpp.add(opp);
                 
      }
      
      if(!lstOpp.isEmpty())
          update lstOpp;
    
    }
        

    global void finish(Database.BatchableContext BC){
         
       
    }

}