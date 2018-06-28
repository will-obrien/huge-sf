global class batchExamAttemptCounter implements Database.Batchable<SObject>
{
   global Database.QueryLocator start(Database.BatchableContext BC){

        string strStat = 'Pending';
        return Database.getQueryLocator('select id,name,Member__c,Result__c,Section__c,Candidate_Commitment__r.AccountId,Exam_Site__r.Name,Exam_Site__r.Site__r.Name,Exam_Site__r.Exam__r.Exam_Group__r.Active__c,Site__c from Exam_Attempt__c where Exam_Site__r.Exam__r.Exam_Group__r.Active__c = true and Defered__c !=: strStat and Cancelled__c != true');
     }
    
    
    global void execute(Database.BatchableContext BC, List<Exam_Attempt__c> scope){
        Set<String> setSiteIDs = new Set<String>();
       for(Exam_Attempt__c obj : scope)
       {
            String strId = obj.Site__c;
            if(strId == null) continue;
            if(strId.length() == 18)
            {
                strId = strId.substring(0,15);
            }
            setSiteIDs.add(strId);
            
       }
      
       examptAttempts objAttemtps = new examptAttempts();
       objAttemtps.getExamAttempts(setSiteIDs);
        
    }
   
    global void finish(Database.BatchableContext BC){
         
       
    }

}