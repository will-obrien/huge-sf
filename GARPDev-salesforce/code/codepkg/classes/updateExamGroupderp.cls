global class updateExamGroupderp implements Database.Batchable<sObject>,Database.StateFul{
    
   global Database.QueryLocator start(Database.BatchableContext BC){
      
     //run this batch for only one record at once.

         String StrDefered = 'Pending';
         //string id ='a1a40000004CXW2';
         String oppstatus = 'closed';
         Set<String> strSection = new Set<String>{'ERP'};
    
     return Database.getQueryLocator('select id,Section__c,Exam_Site__r.Exam_Site_Code_idetifier__c,Opportunity__c,Deferral_Status__c,Candidate_Commitment__c,Member__c,Candidate_Requirement__c,Exam_Site__c,Defered__c from Exam_Attempt__c where  Defered__c =: StrDefered  and Opportunity_StageName__c =:oppstatus and cancelled__c !=true and Exam_Date__c = 2015-11-21 and Section__c in: strSection');  
   }

   global void execute(Database.BatchableContext BC, List<Exam_Attempt__c> scope){
        
        Map<String,Id> mapOldSiteCodes = new Map<String,Id>();
        Map<String,Id> mapNewSiteCodes = new Map<String,Id>();
        List<Exam_Attempt__c> lstToUpdate = new List<Exam_Attempt__c>();
        List<Exam_Attempt__c> lstToUpdate1 = new List<Exam_Attempt__c>();
        List<Exam_Attempt__c> lstToUpdate2= new List<Exam_Attempt__c>();
        Map<Id,Id> mapContractsWithEA = new MaP<Id,Id>();
        set<Id> setContracts = new Set<Id>();
        Map<Id,list<Exam_Attempt__c>> mapIds = new Map<Id,List<Exam_Attempt__c>>();
        for(Exam_Attempt__c obj : scope)  
        {
          if(obj.Section__c == 'ERP')
                setContracts.add(obj.Candidate_Commitment__c);
                
        Map<Id,Map<String,Id>> mapCandidateRequirements = new Map<Id,Map<String,Id>>();
        for(Candidate_Requirement__c cr : [select id,Name,Candidate_Commitment__c from Candidate_Requirement__c where Candidate_Commitment__c in: setContracts and Name like '%Pass ERP%'])
        {
            if(mapCandidateRequirements.containsKey(cr.Candidate_Commitment__c))
            {
                mapCandidateRequirements.get(cr.Candidate_Commitment__c).put(cr.Name,cr.Id);
            }
            else
                mapCandidateRequirements.put(cr.Candidate_Commitment__c,new Map<String,Id>{cr.Name=>cr.Id});
        }

                    system.debug('mapCandidateRequirements == '+mapCandidateRequirements);       
                    obj.Defered__c = 'Approved';
                    obj.Cancelled__c =true;
                    obj.Cancel_Reason__c ='Deferral';
                    obj.Deferral_Status__c ='Deferred Out';
                      system.debug('obj.Exam_Site__c :'+obj.Exam_Site__c);
                    system.debug('obj.Exam_Site__c :'+obj.Candidate_Commitment__c);
                    ERPsplit__c split = ERPsplit__c.getvalues(obj.Exam_Site__c);
                    system.debug('split :'+split);
                    Exam_Attempt__c erp1 = obj.clone(false,true,false,false);
                    erp1.Exam_Site__c = split.ERP1__c;
                    erp1.Defered__c = 'Approved';
                    erp1.Deferral_Status__c = 'Deferred In';
                    erp1.Cancelled__c = false;
                    Map<String,Id> mapValues = mapCandidateRequirements.get(obj.Candidate_Commitment__c);
                    system.debug('mapValues :'+obj.Candidate_Commitment__c);
                    erp1.Candidate_Requirement__c = mapValues.get('Pass ERP1');
                    erp1.cloned_from__c = obj.Id;
                    mapIds.put(erp1.cloned_from__c, new List<Exam_Attempt__c>{erp1});
                    
                    Exam_Attempt__c erp2 = obj.clone(false,true,false,false);
                    erp2.Exam_Site__c = split.ERP2__c;
                    erp2.Defered__c = 'Approved';
                    erp2.Deferral_Status__c = 'Deferred In';
                    erp2.Cancelled__c = false;
                    erp2.Candidate_Requirement__c = mapValues.get('Pass ERP2');
                    erp2.cloned_from__c = obj.Id;
                    if(mapIds.containskey(erp2.cloned_from__c))
                        mapIds.get(erp2.cloned_from__c).add(erp2);
                    


                    lstToUpdate.add(obj);
                    lstToUpdate1.add(erp1);
                    lstToUpdate2.add(erp2);    
        }
        upsert lstToUpdate;
        upsert lstToUpdate1;
        upsert lstToUpdate2;
        }
    
  global void finish(Database.BatchableContext BC){
   
   }
}