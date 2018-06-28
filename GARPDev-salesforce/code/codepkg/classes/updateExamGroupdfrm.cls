global class updateExamGroupdfrm implements Database.Batchable<sObject>,Database.StateFul{
    
   global Database.QueryLocator start(Database.BatchableContext BC){
      
     //run this batch for only one record at once.

         String StrDefered = 'Pending';       
         String oppstatus = 'closed';
         Set<String> strSection = new Set<String>{'FRM Part 1','FRM Part 2'};
         return Database.getQueryLocator('select id,Section__c,Exam_Site__r.Exam_Site_Code_idetifier__c,Opportunity__c,Deferral_Status__c,Candidate_Commitment__c,Member__c,Candidate_Requirement__c,Exam_Site__c,Defered__c from Exam_Attempt__c where  Defered__c =: StrDefered  and Opportunity_StageName__c =:oppstatus and cancelled__c !=true and Section__c in: strSection and Exam_Date__c = 2015-11-21'); 
   
   }

   global void execute(Database.BatchableContext BC, List<Exam_Attempt__c> scope){
        
        Map<String,Id> mapOldSiteCodes = new Map<String,Id>();
        Map<String,Id> mapNewSiteCodes = new Map<String,Id>();
        List<Exam_Attempt__c> lstToUpdate = new List<Exam_Attempt__c>();
        List<Exam_Attempt__c> lstToUpdate1 = new List<Exam_Attempt__c>();
         
        for(Exam_sites__c  objSite : [select id,name,Exam_Site_Code_idetifier__c from Exam_sites__c where Exam__r.Exam_Group__c ='a1c400000039NuE'])
        {
            mapNewSiteCodes.put(objSite.Exam_Site_Code_idetifier__c,objSite.Id);
        }
         if(test.isRunningTest()){
        for(Exam_sites__c  objSite : [select id,name,Exam_Site_Code_idetifier__c from Exam_sites__c])
        {
            mapNewSiteCodes.put(objSite.Exam_Site_Code_idetifier__c,objSite.Id);
        }}
       
        Map<Id,Exam_Attempt__c> mapDetails = new Map<Id,Exam_Attempt__c>();
        for(Exam_Attempt__c obj : scope)  
        {
            mapOldSiteCodes.put(obj.Exam_Site__r.Exam_Site_Code_idetifier__c,obj.Exam_Site__c);
            Exam_Attempt__c clonedRec = obj.clone(false,true,false,false);
           
            clonedRec.Exam_Site__c = mapNewSiteCodes.get(obj.Exam_Site__r.Exam_Site_Code_idetifier__c);
            clonedRec.Defered__c = 'Approved';
            clonedRec.Deferral_Status__c = 'Deferred In';
            clonedRec.Cloned_From__c = obj.id;

            obj.Defered__c = 'Approved';
            obj.Cancelled__c =true;
            obj.Cancel_Reason__c ='Deferral';
            obj.Deferral_Status__c ='Deferred Out';
                   
           lstToUpdate.add(obj);
           lstToUpdate1.add(clonedRec);
            
        }

       upsert lstToUpdate;
       upsert lstToUpdate1;
       
      
        }
    
  global void finish(Database.BatchableContext BC){
   
   }
}