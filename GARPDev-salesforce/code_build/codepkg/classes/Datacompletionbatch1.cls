global class Datacompletionbatch1 implements Database.Batchable<SObject>
{
   global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id,name,Candidate_Commitment__c,Section__c,Cancelled__c,Candidate_Requirement__c from Exam_Attempt__c');
     }
    
    
    global void execute(Database.BatchableContext BC, List<Exam_Attempt__c> scope){
        List<Id> lstContracts = new List<Id>();
        List<Exam_Attempt__c> lstExamAttempts = new List<Exam_Attempt__c>();
        for(Exam_Attempt__c obj : scope)
        {
            lstContracts.add(obj.Candidate_Commitment__c);
            
        }
        
        Map<String,Candidate_Requirement__c> mapProgRequirements = new Map<String,Candidate_Requirement__c>();
        for(Candidate_Requirement__c objCR : [select id,name,Candidate_Commitment__c from Candidate_Requirement__c where Candidate_Commitment__c in: lstContracts])
        {
            mapProgRequirements.put(objCR.Name+'&'+objCR.Candidate_Commitment__c,objCR);
        }
        
        for(Exam_Attempt__c obj : scope)
        {
            String strSection = '';
            if(obj.Section__c == 'FRM Part 1')
                strSection = 'FRM PART 1';
            else if(obj.Section__c == 'FRM Part 2')
                strSection = 'FRM PART 2';
            else if(obj.Section__c == 'ERP')
                strSection = 'PASS ERP';
            else if(obj.Section__c == 'Icbrr Part I')
                strSection = 'PASS ICBRR';
            else if(obj.Section__c == 'Icbrr Part II')
                strSection = 'PASS ICBRR';
            else if(obj.Section__c == 'ICBRR')
                strSection = 'PASS ICBRR';
            
            if(obj.name !='')
            {
                if(obj.Section__c == 'FRM FULL Program' && mapProgRequirements.containsKey('FRM FULL'+'&'+obj.Candidate_Commitment__c))
                    obj.Candidate_Requirement__c = mapProgRequirements.get('FRM FULL'+'&'+obj.Candidate_Commitment__c).Id;
                else if(obj.Section__c == 'FRM FULL Program' && mapProgRequirements.containsKey('FRM PART 1'+'&'+obj.Candidate_Commitment__c))
                    obj.Candidate_Requirement__c = mapProgRequirements.get('FRM PART 1'+'&'+obj.Candidate_Commitment__c).Id;
                else
                    obj.Candidate_Requirement__c = mapProgRequirements.get(strSection+'&'+obj.Candidate_Commitment__c) != null ? mapProgRequirements.get(strSection+'&'+obj.Candidate_Commitment__c).Id : null;
            }
            
            lstExamAttempts.add(obj);
            
        }
        
        if(lstExamAttempts.size() > 0)
            update lstExamAttempts;
        
    }
   
    global void finish(Database.BatchableContext BC){
         
       
    }

}