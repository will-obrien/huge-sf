/*********************************************************************
Name : Test_DuplicateLeadDeleteBatch 
Created On : dec 20 , 2011  
Created By : Lalit Bohra
Description : batch for deleting the leads where lead.tobedelted is set to true 
**********************************************************************/
global class  DuplicateLeadDeleteBatch implements Database.Batchable<SObject>, Database.AllowsCallouts{
	public Id LeadId{set;get;}
	global database.Querylocator start(Database.BatchableContext BC){		
    	if(LeadId !=null && test.isRunningTest()){
    		return database.getQueryLocator([Select Id From Lead where To_be_Deleted__c = true and Id =:LeadId]);
    	}    	 
    	return database.getQueryLocator([Select Id From Lead where To_be_Deleted__c = true]);
    }
    global void execute(Database.BatchableContext BC,Sobject[] scope){ 
    	system.debug('---------------- scope.size()'+scope.size());
    	if(scope != null && scope.size()>0){
    	List<Lead> LeadList=(List<Lead>) scope;    	
    		delete LeadList;
    	}
    }
    global void finish(Database.BatchableContext BC)
    {
        // not implemented.
    }
}