trigger calculateExamAttempts on Exam_Attempt__c (before update, after insert,after update) {



   List<Exam_Attempt__c> lstEAttempts = new List<Exam_Attempt__c>();
   Map<Id,Exam_Attempt__c> mapEA = new Map<Id,Exam_Attempt__c>();

    if(trigger.isUpdate)
    {
        for(Exam_Attempt__c obj : trigger.new)
        {
            if(trigger.oldMap.get(obj.Id).Result__c != obj.Result__c && obj.Result__c == 'Pass'&& obj.Result__c != '')
                mapEA.put(obj.Candidate_Requirement__c,obj);
            else if(trigger.oldMap.get(obj.Id).Result__c != obj.Result__c && trigger.oldMap.get(obj.Id).Result__c == 'Pass')
                mapEA.put(obj.Candidate_Requirement__c,obj);
        }
        
    }
    

 
    
  
    if(!mapEA.isEmpty())
    {
    
        List<Candidate_Requirement__c>  lstCR = new List<Candidate_Requirement__c>();
        for(Candidate_Requirement__c objCR : [select id,Name,Date_of_Completion__c,Status__c from Candidate_Requirement__c where id in: mapEA.keySet()])
        {
            Exam_Attempt__c objEA = mapEA.get(objCR.Id);
            if(objEA.Result__c == 'Pass')
            {
                objCR.Date_of_Completion__c = mapEA.get(objCR.Id).Exam_Date__c;
                objCR.Status__c = 'Completed';
            }
            else
            {
                objCR.Date_of_Completion__c = null;
                objCR.Status__c = null;
            }
            lstCR.add(objCR);
        }
        if(!lstCR.isEmpty())
            update lstCR;
    }

}