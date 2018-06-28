trigger beforeUpdateExamAttempts on Exam_Attempt__c (before update,after update,after insert) {

    if(!ExamAttemptsUtils.isRecursive && trigger.isBefore && trigger.isUpdate) {
        
        ExamAttemptsUtils.onBeforeUpdate(trigger.oldMap,trigger.new);
          }
    
    if(trigger.isinsert) {
         
        ExamAttemptsUtils.oninsert(trigger.oldMap,trigger.new);
        }
        
        
        
  

}