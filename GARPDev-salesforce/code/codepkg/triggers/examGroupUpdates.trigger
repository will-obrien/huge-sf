trigger examGroupUpdates on Exam_Group__c (after update) {
    
    if(!examGroupUtils.isRecursive)
        examGroupUtils.onAfterUpdate(trigger.New);

}