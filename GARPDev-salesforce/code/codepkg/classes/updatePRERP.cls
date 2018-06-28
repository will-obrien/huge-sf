global class updatePRERP implements Database.Batchable<sObject>,Database.StateFul{
    
   global Database.QueryLocator start(Database.BatchableContext BC){
      
        String strSection = 'ERP';
        String datExam = '2015-11-21';
        String StrDefered = 'Pending';
        String oppstatus = 'closed';
        String id ='a1a40000004Cegx';
        
       
     
      // return Database.getQueryLocator('select id,Defered__c,Room__c,Cancelled__c,Candidate_Requirement__c,Opportunity_StageName__c, Exam_Date__c ,Candidate_Commitment__c from Exam_Attempt__c where Section__c =:strSection and Defered__c =:StrDefered and Cancelled__c != true  and Opportunity_StageName__c =:oppstatus and Exam_Date__c = 2015-11-21 and id=:id');
      return Database.getQueryLocator('select id,Defered__c,Room__c,Cancelled__c,Candidate_Requirement__c,Opportunity_StageName__c, Exam_Date__c ,Candidate_Commitment__c from Exam_Attempt__c where Section__c =:strSection and Defered__c =:StrDefered and Cancelled__c != true  and Opportunity_StageName__c =:oppstatus and Exam_Date__c = 2015-11-21'); 
   }

   global void execute(Database.BatchableContext BC, List<Exam_Attempt__c> scope){
        
        List<String> lstCR = new List<String>();

        for(Exam_Attempt__c objList : scope)
        {
           
            lstCR.add(objList.Candidate_Requirement__c);        
        }
        

        List<Candidate_Requirement__c> lstUpsert = new List<Candidate_Requirement__c>();
        for(Candidate_Requirement__c cr : [select id,Name,status__C,Exam__c,recordTypeId,Candidate_Commitment__c from Candidate_Requirement__c where id in: lstCR])
        {
            Candidate_Requirement__c crERP1 = cr.clone(false,true,false,false);
            Candidate_Requirement__c crERP2 = cr.clone(false,true,false,false);
             crERP1.Name = 'Pass ERP1';
             crERP1.Exam__c = 'ERP Part I';
            
             crERP2.Name = 'Pass ERP2';
             crERP2.Exam__c = 'ERP Part II';
            
            lstUpsert.add(crERP1);
            lstUpsert.add(crERP2);
            
        }
        
        upsert lstUpsert;
        
    }
    
  

   global void finish(Database.BatchableContext BC){
   
   }
}