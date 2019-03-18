@RestResource(urlMapping='/IESubscriptionService/*')
global without sharing class IE_SubscriptionService {
 
	@HttpPut
    global Static IE_IntegrationObjects.IE_SubscriptionListResponse doPut(list<IE_IntegrationObjects.IE_Subscription> Subscriptions)
    {
    	//disable trigger functionality
        TriggerUtility.limitIeServiceIntegration = true;
        
    	System.Debug('::::Subscriptions::::'+Subscriptions);
    	IE_IntegrationObjects.IE_SubscriptionListResponse response = new IE_IntegrationObjects.IE_SubscriptionListResponse();
    	response.Subscriptions = Subscriptions;
    	response.errors = new list<IE_IntegrationObjects.IE_Error>();
    	return response;
    	//won't get hit we return...
    	
    	set<Id> subscriptionIds = new set<Id>();
    	map<Id, Subscription__c> sbscriptionMap = new map<Id, Subscription__c>();
    	list<Subscription__c> subscriptionList = new list<Subscription__c>();
    	map<Id, list<Database.Error>> processingErrors = new map<Id, list<Database.Error>>();
    	
    	for(IE_IntegrationObjects.IE_Subscription sub : Subscriptions)
    	{
    		subscriptionList.add( new Subscription__c(Id = sub.SFDCId
    				                                 ,Type__c = sub.Type
    				                                 ,Active__c = sub.Active));
    		/*
    		if(sub.SFDCId == null)
    		{
    			sub.ErrorCode = 'MISSING_OR_INVALID_ID_FOR_UPDATE';
    			if(sub.errors.size() == 0)
    				sub.errors = new list<String>{'Salesforce Id Required for Update'};
    			else
    				sub.errors.add('Salesforce Id Required for Update');
    		}
    		else
    		{
    			//check for a valid Salesforce Id
    			if(IE_IntegrationObjects.isValidSalesforceId(sub.SFDCId))
    			{
    				sbscriptionMap.put(sub.SFDCId, new Subscription__c(Id = sub.SFDCId
    				                                           			,Type__c = sub.Type));
    			}		
    			else
    			{
    				sub.ErrorCode = 'MISSING_OR_INVALID_ID_FOR_UPDATE';
    				if(sub.errors.size() == 0)
	    				sub.errors = new list<String>{'Salesforce Id is invalid: '+sub.SFDCId};
	    			else
	    				sub.errors.add('Salesforce Id is invalid: '+sub.SFDCId);
    			}
    		}
    		*/
    	}
    	list<Database.Saveresult> srList = new list<Database.Saveresult>();
    	Integer cnt = 0;
    	//if(sbscriptionMap.size() > 0)
    	//{
    		srList = Database.Update(subscriptionList, false);
    		for(Database.Saveresult res : srList)
    		{
    			if(!res.isSuccess())
    			{
    				//processingErrors.put(res.getId(), res.getErrors());
    				Subscriptions[cnt].errors = new list<IE_IntegrationObjects.IE_Error>(); 
    				for(Database.Error err : res.getErrors())
    				{
    					Subscriptions[cnt].errors.add(new IE_IntegrationObjects.IE_Error('SALESFORCE_DML_ERROR', err.message)); 
    					response.errors.add(new IE_IntegrationObjects.IE_Error('SALESFORCE_DML_ERROR', err.message)); 
    					
    				} 
    			}
    			else
    			{
    				Subscriptions[cnt].SFDCId = res.getId();
    			}
    			
    			cnt ++;
    		}
    	//}
    	/*
    	//add the processing errors to the response
    	for(IE_IntegrationObjects.IE_Subscription sub : response.Subscriptions)
    	{
    		if(processingErrors.containsKey(sub.SFDCId))
    		{
    			list<Database.Error> errors = processingErrors.get(sub.SFDCId);
    			sub.ErrorCode = 'SALESFORCE_DML_ERROR';//errors[0].getStatusCode();
    			list<String> messages = new list<String>();
    			for(Database.Error err : errors)
    			{
					if(sub.errors.size() == 0)
	    				sub.errors = new list<String>{err.getMessage()};
	    			else
	    				sub.errors.add(err.getMessage());
    			}
    		}
    		else
    		{
    			sub.ErrorCode = 'NO_DML_ERROR';
    			sub.errors = new list<String>{'Nuthin'+processingErrors};
    		}
    	}*/
    	
    	response.Subscriptions = Subscriptions;
    	return response;
    }

}