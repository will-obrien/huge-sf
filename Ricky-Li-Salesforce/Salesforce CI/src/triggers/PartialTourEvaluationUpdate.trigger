trigger PartialTourEvaluationUpdate on Tour_Evaluation__c (after Update) {
    Set<Id> partialCompleteTeIds = new Set<Id>();
    Set<Id> incompleteTeIds = new Set<Id>();
    //Bulkified
    for(Tour_Evaluation__c te: Trigger.new){
    	if(te.NPS_Rating__c == null && te.Date_Completed__c != null && te.SumEvaluationScores__c == 0)
    		incompleteTeIds.add(te.Id);
    	else if(te.Transportation_Rating__c == NULL && te.Date_Completed__c != NULL)
    		partialCompleteTeIds.add(te.Id);
    }
    
    List <Tour_Evaluation_Historical_Summary__c> tehsPartialComplete = [Select Id, Status__c from Tour_Evaluation_Historical_Summary__c where Tour_Evaluation__c in: partialCompleteTeIds];
    List <Tour_Evaluation_Historical_Summary__c> tehsIncomplete = [Select Id, Status__c from Tour_Evaluation_Historical_Summary__c where Tour_Evaluation__c in: incompleteTeIds];
    
    List <Tour_Evaluation_Historical_Summary__c> tehsUpdate = new List <Tour_Evaluation_Historical_Summary__c>();
    
    for(Tour_Evaluation_Historical_Summary__c tehs: tehsPartialComplete){
    	tehs.Status__c = 'partially complete';
    	tehsUpdate.add(tehs);
    }
    
    for(Tour_Evaluation_Historical_Summary__c tehs: tehsIncomplete){
    	tehs.Status__c = 'Incomplete';
    	tehsUpdate.add(tehs);
    }
    
    update tehsUpdate;

}