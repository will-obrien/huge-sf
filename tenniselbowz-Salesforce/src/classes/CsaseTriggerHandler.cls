public without sharing class CsaseTriggerHandler {
	
	public static string CLOSE_WITHOUT_FAILURE_MESSAGE = 'When closing a case with assets, you must add a Failure Cause to each associated Case Asset record.';
	
	public static void onBeforeUpdate(map<Id,Case> newMap, map<Id,Case> oldMap)
	{
		validateCaseAsset(newMap.values());
	}
	
	public static void validateCaseAsset(list<Case> cases)
	{
		/* if closing
           query assets for failure cause
           if there are any case assets with no failure Cause then throw an error
           if no assets exist then move on.
         */
         set<Id> caseIds = new set<Id>();
         for(Case c : cases)
         {
         	if(c.Status == 'Closed')
         	  caseIds.add(c.Id);
         }
         map<Id, Integer> errorMap = new map<Id, integer>();
         
         for(AggregateResult ar : [Select Case__c, count(Id) cnt 
                                     from Case_Asset__c 
                                    where Case__c in :caseIds
                                      and Failure_Cause__c = null
                                    group by Case__c
                                    ])
         {
         	errorMap.put((String)ar.get('Case__c'), (Integer)ar.get('cnt'));
         }
         
         
         for(Case c : cases)
         {
         	if(errorMap.containsKey(c.Id))
         	   c.addError(CLOSE_WITHOUT_FAILURE_MESSAGE);
         }
         
         
	}

}