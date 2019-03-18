global class Batch_Sync_IE_Subscription implements Database.Batchable<sObject>, Database.AllowsCallouts,  Database.Stateful{
    
    global string processingStatus = 'Pending'; 
    global boolean hasErrors = false;
    global Batch_Sync_IE_Subscription(string status)
    {
    	processingStatus = status;
    }
    
    global Database.querylocator start(Database.BatchableContext BC)
    { 
        //
        // Iterate over the objects of interest
        //
        return Database.getQueryLocator([select Type__c
											  , Start_Date__c
											  , End_Date__c
											  , Buyer_ID__c
											  , Asset__c
											  , IE_ID__c
											  , IE_Updated_Date__c
											  , Id
											  , LastModifiedDate
											  , Active__c
        								   from Subscription__c  
        								  where IE_Sync_Status__c = :processingStatus
        								    and IE_Subscription__c = true]);
       
    }
 
    //Main execute method
    global void execute(Database.BatchableContext BC, List<	Subscription__c> subscriptions)
    {
    	TriggerUtility.limitIntegrationBatch = true;
       //populate the objects for integration
       IE_IntegrationObjects.IE_SubscriptionList ieSubscriptionPost = new IE_IntegrationObjects.IE_SubscriptionList();
       		ieSubscriptionPost.Subscriptions = new list<IE_IntegrationObjects.IE_Subscription>();
       IE_IntegrationObjects.IE_SubscriptionList ieSubscriptionPut = new IE_IntegrationObjects.IE_SubscriptionList();
       		ieSubscriptionPut.Subscriptions = new list<IE_IntegrationObjects.IE_Subscription>();
       
       IE_IntegrationObjects.IE_SubscriptionListResponse ieSubscriptionPostResponse = new IE_IntegrationObjects.IE_SubscriptionListResponse();
       IE_IntegrationObjects.IE_SubscriptionListResponse ieSubscriptionPutResponse = new IE_IntegrationObjects.IE_SubscriptionListResponse();
       		
       map<Id, Subscription__c> subscriptionMap = new map<Id, Subscription__c>();
       list<Integration_Error__c> integrationErrorList = new list<Integration_Error__c>();
       
       for(Subscription__c s : subscriptions)
       {
       		//create the Individual and add it to the list
       		IE_IntegrationObjects.IE_Subscription ieSubscription = new IE_IntegrationObjects.IE_Subscription();
       		ieSubscription.Type			= s.Type__c;
			ieSubscription.StartDate	= s.Start_Date__c;
			ieSubscription.EndDate		= s.End_Date__c; 
			ieSubscription.BuyerID		= s.Buyer_ID__c;
			ieSubscription.UnitSFDCId	= s.Asset__c;
			ieSubscription.IEId			= s.IE_ID__c;
			ieSubscription.LastModifiedDate	= s.IE_Updated_Date__c;
			ieSubscription.SFDCId		= s.Id;
			ieSubscription.LastModifiedDate	= s.LastModifiedDate;
			ieSubscription.Active 		= s.Active__c;
   		    
   		    if(s.IE_ID__c == null)
       			ieSubscriptionPost.Subscriptions.add(ieSubscription);
       		else
       			ieSubscriptionPut.Subscriptions.add(ieSubscription);
       		
       		//store the Subscription__c in the map to retrieve response status
       		subscriptionMap.put(s.Id, s);	
       }
       
       //
       // call the service - Determine PUT or POST
       //
       
       String jsonPostResponse = '';
       String jsonPutResponse = '';
       //Process the POST
       try{
	       if(ieSubscriptionPost != null && ieSubscriptionPost.Subscriptions.size() > 0)
	       {
		       System.Debug(':::ieSubscriptionPost:::'+JSON.serialize(ieSubscriptionPost));
		       HTTPResponse response = IE_IntegrationObjects.sendIeRequest(IE_Service_Configuration__c.getInstance().SubscriptionService__c
		                                                                 , 'POST'
		                                                                 , JSON.serialize(ieSubscriptionPost));
		       
		       if(response.getStatusCode() == 200)
		        { 
		            //iterate over the response checking for errors maybe we just return the body
		            if(Test.isRunningTest())
		            	jsonPostResponse = JSON.serialize(ieSubscriptionPost);//for testing purposes since we can make a call-out
		            else
		            	jsonPostResponse = response.getBody();
		            	
		            System.Debug(':::ieSubscriptionPost Response:::'+jsonPostResponse);
		       	
		            ieSubscriptionPostResponse = (IE_IntegrationObjects.IE_SubscriptionListResponse)JSON.deserialize(jsonPostResponse, IE_IntegrationObjects.IE_SubscriptionListResponse.class);
		        }
		        else{ 
		        	//log the error
		        	integrationErrorList.add(new Integration_Error__c(Direction__c = 'Outbound'
       															, Error_Description__c = 'Transmission Error ['+response.getStatusCode()+']'
       															, Integration_Object__c = 'Subscription__c'
       															, Integration_Point__c = 'IE'
       															, Request_Data__c = JSON.serialize(ieSubscriptionPost) ));
       				hasErrors = true;
		        }
	       }
       }
       catch(Exception e)
       {
       		//log the error
       		integrationErrorList.add(new Integration_Error__c(Direction__c = 'Outbound'
       															, Error_Description__c = 'CALLOUT_EXCEPTION'
       															, Integration_Object__c = 'Subscription__c'
       															, Integration_Point__c = 'IE'
       															, Request_Data__c = e.getMessage() ));
   			hasErrors = true;
       }
       
       //Process the PUT 
       try{
	       if(ieSubscriptionPut != null && ieSubscriptionPut.Subscriptions.size() > 0)
	       {
		       System.Debug(':::ieSubscriptionPut:::'+JSON.serializePretty(ieSubscriptionPut));
		       HTTPResponse response = IE_IntegrationObjects.sendIeRequest(IE_Service_Configuration__c.getInstance().SubscriptionService__c
		                                                                 , 'PUT'
		                                                                 , JSON.serialize(ieSubscriptionPut));
		       
		       if(response.getStatusCode() == 200)
		        { 
		            //iterate over the response checking for errors maybe we just return the body
		            if(Test.isRunningTest())
		            	jsonPutResponse = JSON.serialize(ieSubscriptionPut);//for testing purposes since we can make a call-out
		            else
		            	jsonPutResponse = response.getBody();
		            	
		            System.Debug(':::ieSubscriptionPut Response:::'+jsonPutResponse);
		            	
		            ieSubscriptionPutResponse = (IE_IntegrationObjects.IE_SubscriptionListResponse)JSON.deserialize(jsonPutResponse, IE_IntegrationObjects.IE_SubscriptionListResponse.class);
		        }
		        else{ 
		        	//log the error
		        	integrationErrorList.add(new Integration_Error__c(Direction__c = 'Outbound'
	       															, Error_Description__c = 'Transmission Error ['+response.getStatusCode()+' ] '//+response.getHeader()+']'
	       															, Integration_Object__c = 'Subscription__c'
	       															, Integration_Point__c = 'IE'
	       															, Request_Data__c = JSON.serialize(ieSubscriptionPut) ));
       				hasErrors = true;
		        }
	       }
       }
       catch(Exception e)
       {
       		//log the error
       		integrationErrorList.add(new Integration_Error__c(Direction__c = 'Outbound'
   															, Error_Description__c = 'CALLOUT_EXCEPTION'
   															, Integration_Object__c = 'Subscription__c'
   															, Integration_Point__c = 'IE'
   															, Request_Data__c = 'Response: '+jsonPostResponse+jsonPutResponse+e.getMessage() ));
       		hasErrors = true;
       }
       
       
       boolean hasErrors = false;
       
       //process the responses adding IE Ids and/or Logging Errors
       if(ieSubscriptionPostResponse.Subscriptions != null && ieSubscriptionPostResponse.Subscriptions.size() > 0)
       		processResponse(ieSubscriptionPostResponse, hasErrors, subscriptionMap, integrationErrorList);
       if(ieSubscriptionPutResponse.Subscriptions != null && ieSubscriptionPutResponse.Subscriptions.size() > 0)
       		processResponse(ieSubscriptionPutResponse, hasErrors, subscriptionMap, integrationErrorList);
       
       //update the records with the IE Keys
       update subscriptionMap.values();
       
       if(integrationErrorList.size() > 0)
       		insert integrationErrorList;
        
        
    }
    
    global void finish(Database.BatchableContext BC)
    {
		
    }
    
    global void processResponse(IE_IntegrationObjects.IE_SubscriptionListResponse Subscriptions, boolean hasErrors,  
                                 map<Id, Subscription__c> subscriptionMap, list<Integration_Error__c> integrationErrorList)
    {
    	
       	//Parse the response for errors
       	// retrieve the IE IDs and update the base as well as the child objects if they are null
       	// update the status to Processed
       
       	//log errors
       	//update the status to Error
       	for(IE_IntegrationObjects.IE_Subscription subscription : Subscriptions.Subscriptions)
       	{ 
       		
       		
       		if(subscription.errors != null && subscription.errors.size() > 0)
       		{
       			subscriptionMap.get(subscription.SFDCId).IE_Sync_Status__c 				= 'Error';
       			integrationErrorList.add(new Integration_Error__c(Direction__c 			= 'Outbound'
       															, Error_Description__c 	= String.ValueOf(subscription.errors)
       															, Integration_Object__c = 'Subscription__c'
       															, Integration_Object_Id__c = subscription.SFDCId
       															, Integration_Point__c 	= 'IE'
       															, Request_Data__c 		= JSON.serialize(subscription) ));
       		}
       		else
       		{
       			subscriptionMap.get(subscription.SFDCId).IE_Sync_Status__c = 'Processed';
       			subscriptionMap.get(subscription.SFDCId).IE_Id__c = subscription.IEId;
       		}
       		
       		
       			
       	}
    }
    

}