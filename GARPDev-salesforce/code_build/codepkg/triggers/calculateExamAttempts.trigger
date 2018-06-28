trigger calculateExamAttempts on Exam_Attempt__c (before update, after insert,after update) {



   List<Exam_Attempt__c> lstEAttempts = new List<Exam_Attempt__c>();
   Map<Id,Exam_Attempt__c> mapEA = new Map<Id,Exam_Attempt__c>();
  /*
   if(trigger.isafter )
   {
       Set<String> setSiteIDs = new Set<String>();
       List<Exam_Attempt__c> lstExamAttempts = new List<Exam_Attempt__c>();
       if(trigger.isDelete )
            lstExamAttempts = trigger.old;
       else
            lstExamAttempts = trigger.new;
            
       
       for(Exam_Attempt__c obj : lstExamAttempts)
       {
            String strId = obj.Site__c;
            if(strId.length() == 18)
            {
                strId = strId.substring(0,15);
            }
            setSiteIDs.add(strId);
            
       }
      
       examptAttempts objAttemtps = new examptAttempts();
       objAttemtps.getExamAttempts(setSiteIDs);
       
      
       
    }*/
    
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
    

    // for cloning and switching the frm2 when frm1 is failed
    if(!ExamAttemptsUtils.isRecursive && trigger.isBefore && trigger.isUpdate) {
        
        for(Exam_Attempt__c obj : trigger.new)
        {
            if(obj.Result__c != Trigger.OldMap.get(obj.Id).Result__c && obj.Section__c == 'FRM Part 1')// && obj.Section__c != Trigger.OldMap.get(obj.Id).Section__c)
              ExamAttemptsUtils.onBeforeUpdate(trigger.oldMap,trigger.new);

        }
        
    }
    
    // to create icbrr records.
    if(trigger.isinsert) {
         
        ExamAttemptsUtils.oninsert(trigger.oldMap,trigger.new);
        }
    //Code merge ends here

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
/*
    List<Exam_Attempt__c> lstEAS = new List<Exam_Attempt__c>();
        for(Exam_Attempt__c objEA : Trigger.New)
        {
          if(trigger.isBefore)
          {
              if(trigger.isUpdate && objEA.Exam_Site__c != Trigger.OldMap.get(objEA.ID).Exam_Site__c)
                  lstEAS.add(objEA);
              else if(trigger.isInsert)
                  lstEAS.add(objEA);
          }

        }
       system.debug('lstEAS == '+lstEAS);
        if(lstEAS.size() > 0)
          AutoCandidateGeneration.AddCandidateId(lstEAS);*/
}