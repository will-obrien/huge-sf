global class batchDeletePRS implements Database.Batchable<sObject>,Database.StateFul{

    global Database.QueryLocator start(Database.BatchableContext BC){

	ID userID = '00540000003QoNM';
	return Database.getQueryLocator('select id,name from Candidate_Requirement__c where createddate =today and CreatedById=:userID');         
    }
    
    global void execute(Database.BatchableContext BC, List<Candidate_Requirement__c> scope){
        
        List<Candidate_Requirement__c> lstDeletePRS = new List<Candidate_Requirement__c>();
        for(Candidate_Requirement__c cr : scope)
        {
            lstDeletePRS.add(cr);
        }
        delete lstDeletePRS;
    }
    
     global void finish(Database.BatchableContext BC){
   
   }
}