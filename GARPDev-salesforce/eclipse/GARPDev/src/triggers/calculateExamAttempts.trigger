trigger calculateExamAttempts on Exam_Attempt__c (before update, after insert,after update,after delete) {
     
   List<Exam_Attempt__c> lstExamAttempts = new List<Exam_Attempt__c>();
   if(trigger.isafter)
   {
       Set<String> setSiteIDs = new Set<String>();
       
       
       if(trigger.isDelete)
            lstExamAttempts = trigger.old;
       else
        {   
            if(trigger.isUpdate)
            {
                lstExamAttempts.addAll(trigger.old);
                lstExamAttempts.addAll(trigger.new);
            }
            else
                lstExamAttempts = trigger.new;
            
        }
        
        
            
       for(Exam_Attempt__c obj : lstExamAttempts)
       {
            String strId = obj.Site__c;
            if(strId.length() == 18)
            {
                strId = strId.substring(0,15);
            }
            System.debug('StrId == '+strId);
            setSiteIDs.add(strId);
       }
       system.debug('setSiteIDs === '+setSiteIDs);
       examptAttempts objAttemtps = new examptAttempts();
       objAttemtps.getExamAttempts(setSiteIDs);
       
       
       if ( trigger.isUpdate ) {
         //GARP_trigger_util.clear_memberID2EA_ifDone ( trigger.new ) ;
       }
    }
      
    //  Code to identify and link sibling EAs (siblings are EAs linked to same member)
   // if ( trigger.isBefore && trigger.isUpdate ) {
  //    update GARP_trigger_util.LinkEAs ( trigger.new ) ; 
  //  }  
}