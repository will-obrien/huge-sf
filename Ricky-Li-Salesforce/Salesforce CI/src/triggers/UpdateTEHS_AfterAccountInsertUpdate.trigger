trigger UpdateTEHS_AfterAccountInsertUpdate on Account (after insert, after update) {
    
    Set<String> acctIds = new Set<String>();
    for(Account a: trigger.new){        
        if(a.Evaluation_Email__c != null){
            String tempId = a.Id;
            if(tempId.length() >= 15){             
                acctIds.add(tempId.left(15));
            }
        }
    }
    
    List<Tour_Evaluation_Historical_Summary__c> tehsList = [select Id, Error__c
                                        from Tour_Evaluation_Historical_Summary__c 
                                        where Evaluation_Email_Address__c != null
                                        and Error__c = 'no evaluation email on file' 
                                        and Tour_Evaluation__r.Account__r.Id in : acctIds];
    
    List<Tour_Evaluation_Historical_Summary__c> updatedTehs = new List<Tour_Evaluation_Historical_Summary__c>();
    
    for(Tour_Evaluation_Historical_Summary__c tehs: tehsList){
        tehs.Error__c = 'evaluation email was added after end date';
        updatedTehs.add(tehs);
    }                                
    try{
        update(updatedTehs);
    }catch(Exception e){}
}