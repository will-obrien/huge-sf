global class updatePRERP2 implements Database.Batchable<sObject>,Database.StateFul{
    
   global Database.QueryLocator start(Database.BatchableContext BC){
      
        string constatus ='Activated ( Auto-Renew )';
        string programtype ='ERP';
        string programreqstatus ='cancelled';
        string name ='Pass ERP';
        Id erpRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program');

        
     return Database.getQueryLocator('select id,Candidate_Commitment__r.RecordTypeId,Candidate_Commitment__c,Candidate_Commitment__r.Do_not_touch__c,Program_Type__c from Candidate_Requirement__c where Program_Type__c =:programtype and  Candidate_Commitment__r.status =:constatus and Candidate_Commitment__r.Do_not_touch__c!=true and Status__c=:programreqstatus and name =:name and Candidate_Commitment__r.RecordTypeId=:erpRecordTypeID'); 

   }

   global void execute(Database.BatchableContext BC, List<Candidate_Requirement__c> scope){
        
        set<String> lstCR = new set<String>();

        for(Candidate_Requirement__c objList : scope)
        {
           
            lstCR.add(objList.Candidate_Commitment__c);        
        }
        

        List<Candidate_Requirement__c> lstUpsert = new List<Candidate_Requirement__c>();
        List<Candidate_Requirement__c> lstUpsert1 = new List<Candidate_Requirement__c>();
        for(Candidate_Requirement__c cr : [select id,Name,status__C,Exam__c,recordTypeId,Candidate_Commitment__c from Candidate_Requirement__c where Candidate_Commitment__c in: lstCR and name ='Pass ERP' ])
        {
           // cr.status__C='cancelled';
            Candidate_Requirement__c crERP1 = cr.clone(false,true,false,false);
            Candidate_Requirement__c crERP2 = cr.clone(false,true,false,false);
             crERP1.Name = 'Pass ERP1';
             crERP1.Exam__c = 'ERP Part I';
             crERP1.status__C ='Initial';
            
             crERP2.Name = 'Pass ERP2';
             crERP2.Exam__c = 'ERP Part II';
             crERP2.status__C='Initial';
            
            lstUpsert.add(crERP1);
          lstUpsert.add(crERP2);
         // lstUpsert1.add(cr);
            
        }
        
      // update lstUpsert1;
        upsert lstUpsert;
        
    }
    
  

   global void finish(Database.BatchableContext BC){
   
   }
}