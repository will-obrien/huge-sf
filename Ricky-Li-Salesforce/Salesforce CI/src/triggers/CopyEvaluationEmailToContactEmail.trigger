trigger CopyEvaluationEmailToContactEmail on Account (before update){
    for(Account account : trigger.new){
        if(account.Evaluation_Email__c != null)
            Account.PersonEmail = Account.Evaluation_Email__c;  
    }
}