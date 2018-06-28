global class Batch_Sync_IE_Individual implements Database.Batchable<sObject>, Database.AllowsCallouts,  Database.Stateful{
    /**!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!**
     ** THIS IS INTENDED TO BE RUN IN BATCHES OF 10 ONLY **
     **!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!**/ 
     
    global string processingStatus = 'Pending'; 
    global boolean hasErrors = false;
    
    global Batch_Sync_IE_Individual(string status)
    {
    	processingStatus = status;
    } 
    
    global Database.querylocator start(Database.BatchableContext BC)
    { 
        //
        // Iterate over the objects of interest
        //
        /*
          
        */
        return Database.getQueryLocator([Select Id
											  , FirstName
											  , LastName
											  , Middle_Name__c
											  , Email
											  , Phone
											  , MobilePhone
											  , IE_Username__c
											  , IE_Accessed__c
											  , IE_Inactive__c
											  , LastModifiedDate
											  , IE_Updated_Date__c
											  , IE_ID__c
											  , IE_Contact__c
											  , AccountId
        									 //address data
											  , (Select Address__r.Country__c
												        , Address__r.Postal_Code__c
												        , Address__r.State_Province__c
													    , Address__r.State_Province_ISO_Code__c
													    , Address__r.Country_ISO_Code__c
												        , Address__r.County__c
												        , Address__r.City__c
												        , Address__r.Address_Line_4__c
												        , Address__r.Address_Line_3__c
												        , Address__r.Address_Line_2__c
												        , Address__r.Address_Line_1__c
												        , Address__r.Name
												        , Address__r.IE_ID__c
												        , Address__c 
												        , Address__r.LastModifiedDate
												     From Contact_Addresses__r
												    //where Primary_Mail_To__c = true 
												      ) 
        									 //role data
        									 ,(Select Role__c, Master_Admin__c, Asset__c From Contact_Subscriptions__r)
        								  from Contact  
        								 where IE_Sync_Status__c = :processingStatus
        								   and IE_Contact__c = true]);
       
    }

    //Main execute method
    global void execute(Database.BatchableContext BC, List<Contact> contacts)
    {
    	TriggerUtility.limitIntegrationBatch = true;
       //populate the objects for integration
       IE_IntegrationObjects.IE_UserList IndividualsPost = new IE_IntegrationObjects.IE_UserList();
       IndividualsPost.Individuals = new list<IE_IntegrationObjects.IE_User>();
       IE_IntegrationObjects.IE_UserList IndividualsPut = new IE_IntegrationObjects.IE_UserList();
       IndividualsPut.Individuals = new list<IE_IntegrationObjects.IE_User>();
       
       //defione the response objects
       IE_IntegrationObjects.IE_UserListResponse IndividualsPostResponse = new IE_IntegrationObjects.IE_UserListResponse();
       IE_IntegrationObjects.IE_UserListResponse IndividualsPutResponse = new IE_IntegrationObjects.IE_UserListResponse();
       
       map<Id, Contact> contactMap = new map<Id, Contact>();
       map<Id, Account> accountMap = new map<Id, Account>();
       map<Id, Address__c> addressMap = new map<Id, Address__c>();
       list<Integration_Error__c> integrationErrorList = new list<Integration_Error__c>();
       
       //get the greater of the two - most recently modified contact_subscription record or the last modified date on the contact record
       map<Id, DateTime> maxSubscriptionDate = new map<Id, DateTime>();
       for(AggregateResult ar : [Select Contact__c, max(LastModifiedDate) dt from Contact_Subscription__c where Contact__c in :contacts group by Contact__c])
       {
       		maxSubscriptionDate.put(String.ValueOf(ar.get('Contact__c')), (DateTime)ar.get('dt'));
       }
       for(Contact c : contacts)
       {
       		//get the address data
       		IE_IntegrationObjects.IE_Address address = new IE_IntegrationObjects.IE_Address();
       		for(Contact_Address__c addr : c.Contact_Addresses__r)
       		{
       			address.AddressLine1 = addr.Address__r.Address_Line_1__c;
				address.AddressLine2 = addr.Address__r.Address_Line_2__c;
				address.AddressLine3 = addr.Address__r.Address_Line_3__c;
				address.AddressLine4 = addr.Address__r.Address_Line_4__c;
				address.City 		 = addr.Address__r.City__c;
				address.Country 	 = addr.Address__r.Country_ISO_Code__c;  
				address.StateCode 	 = addr.Address__r.State_Province_ISO_Code__c;
				address.ZipCode 	 = addr.Address__r.Postal_Code__c;
				address.SFDCId		 = addr.Address__r.Id;
				address.IEId		 = addr.Address__r.IE_ID__c;
				address.LastModifiedDate = DateTime.newInstance(addr.Address__r.LastModifiedDate.dateGmt()
															   ,addr.Address__r.LastModifiedDate.timeGmt());
				addressMap.put(addr.Address__r.Id, addr.Address__r);
				break;
       		}
       		 
       		//get the Organization data
       		/*
       		IE_IntegrationObjects.IE_Organization org = new IE_IntegrationObjects.IE_Organization();
			org.OrganizationName = c.Account.Name;
			org.SFDCId 			 = c.AccountId;
			org.PhoneNumber 	 = c.Account.Phone;
       		accountMap.put(c.AccountId, new Account(Id = c.AccountId));
       		*/
       		
       		//get the Roles
       		list<IE_IntegrationObjects.IE_Role> ieRoles = new list<IE_IntegrationObjects.IE_Role>();
       		for(Contact_Subscription__c sub : c.Contact_Subscriptions__r)
       		{
       			list<String> equipmentRoles = sub.Role__c.split(';');
       			for(String r : equipmentRoles)
       			{
       				IE_IntegrationObjects.IE_Role role = new IE_IntegrationObjects.IE_Role();
	       			role.Type 		 = r;
	       			role.UnitSFDCId  = sub.Asset__c;
	       			role.MasterAdmin = String.valueOf(sub.Master_Admin__c); 
	       			if(role.MasterAdmin == null) role.MasterAdmin = 'false';
	       			ieRoles.add(role);
       			}
       		}
       		
       		//create the Individual and add it to the list
       		DateTime maxDate = c.LastModifiedDate;
       		if(maxSubscriptionDate.containsKey(c.Id))
       		{
       			if(maxSubscriptionDate.get(c.Id) > maxDate)
       				maxDate = maxSubscriptionDate.get(c.Id);
       		}
	       	IE_IntegrationObjects.IE_User ieUser = new IE_IntegrationObjects.IE_User();
       		ieUser.FirstName 	= c.FirstName;
   		    ieUser.MiddleName 	= c.Middle_Name__c;
   		    ieUser.LastName 	= c.LastName;
   		    ieUser.EmailAddress = c.email;
   		    ieUser.Roles 		= ieRoles;
   		    ieUser.Address 		= address;
   		    ieUser.CellPhone	= c.MobilePhone;
   		    ieUser.WorkPhone	= c.Phone;
   		    ieUser.SFDCId 		= c.Id;
   		    ieUser.UserName		= c.IE_Username__c;
   		    ieUser.OrganizationSFDCId = c.AccountId;
   		    ieUser.IEId 		= c.IE_ID__c;
			ieUser.LastModifiedDate	= DateTime.newInstance(maxDate.dateGmt()
														  ,maxDate.timeGmt());
   		    
   		    if(c.IE_ID__c == null)
       			IndividualsPost.Individuals.add(ieUser);
       		else
       			IndividualsPut.Individuals.add(ieUser);
       		
       		//store the contact in the map to retrieve response status
       		contactMap.put(c.Id, c);	
       }
       
       //
       // call the service - Determine PUT or POST
       //
       
       String jsonPostResponse = '';
       String jsonPutResponse = '';
       //Process the POST
       try{
	       if(IndividualsPost.Individuals != null && IndividualsPost.Individuals.size() > 0)
	       {
		       System.debug('::::::INDIVIDUALS POST::::::'+JSON.serialize(IndividualsPost));
		       
		       HTTPResponse response = IE_IntegrationObjects.sendIeRequest(IE_Service_Configuration__c.getInstance().IndividualService__c
		                                                                , 'POST'
		                                                                , JSON.serialize(IndividualsPost));
		       
		       if(response.getStatusCode() == 200)
		        { 
		            //iterate over the response checking for errors maybe we just return the body
		            if(Test.isRunningTest())
		            	jsonPostResponse = JSON.serialize(JSON.serialize(IndividualsPost));//for testing purposes since we can make a call-out
		            else
		            	jsonPostResponse = response.getBody();
		            system.debug(':::: INDIVIDUALS jsonPostResponse:::::'+jsonPostResponse);
		            IndividualsPostResponse = (IE_IntegrationObjects.IE_UserListResponse)JSON.deserialize(jsonPostResponse, IE_IntegrationObjects.IE_UserListResponse.class);
		        }
		        else{ 
		        	//log the error
		        	integrationErrorList.add(new Integration_Error__c(Direction__c = 'Outbound POST'
       															, Error_Description__c = 'Transmission Error ['+response.getStatusCode()+']'
       															, Integration_Object__c = 'Contact'
       															, Integration_Point__c = 'IE'
       															, Request_Data__c =  JSON.serialize(IndividualsPost)));
       				hasErrors = true;
		        }
	       }
       }
       catch(Exception e)
       {
       		//log the error
       		integrationErrorList.add(new Integration_Error__c(Direction__c = 'Outbound POST'
       															, Error_Description__c = 'CALLOUT_EXCEPTION ' + e.getMessage()
       															, Integration_Object__c = 'Contact'
       															, Integration_Point__c = 'IE'
       															, Request_Data__c = JSON.serialize(IndividualsPost) ));
   			hasErrors = true;
       }
       
       //Process the PUT ** Sales_Rep_Quota__c.Current_Quota__c = true **
       
       try{
	       if(IndividualsPut.Individuals != null && IndividualsPut.Individuals.size() > 0)
	       {
		       System.debug(':::::INDIVIDUALS PUT:::::'+JSON.serialize(JSON.serialize(IndividualsPut)));
		       HTTPResponse response = IE_IntegrationObjects.sendIeRequest(IE_Service_Configuration__c.getInstance().IndividualService__c
		                                                                , 'PUT'
		                                                                , JSON.serialize(IndividualsPut));
		       
		       if(response.getStatusCode() == 200)
		        { 
		            //iterate over the response checking for errors maybe we just return the body
		            if(Test.isRunningTest())
		            	jsonPutResponse = JSON.serialize(JSON.serialize(IndividualsPut));//for testing purposes since we can make a call-out
		            else
		            	jsonPutResponse = response.getBody();
		            	
		            system.debug(':::: INDIVIDUALS jsonPutResponse:::::'+jsonPutResponse);
		            IndividualsPutResponse = (IE_IntegrationObjects.IE_UserListResponse)JSON.deserialize(jsonPutResponse, IE_IntegrationObjects.IE_UserListResponse.class);
		        }
		        else{ 
		        	//log the error
		        	integrationErrorList.add(new Integration_Error__c(Direction__c = 'Outbound PUT'
       															, Error_Description__c = 'Transmission Error ['+response.getStatusCode()+' ] '//+response.getHeader()+']'
       															, Integration_Object__c = 'Contact'
       															, Integration_Point__c = 'IE'
       															, Request_Data__c = JSON.serialize(IndividualsPost)));
       				hasErrors = true;
		        }
	       }
       }
       catch(Exception e)
       {
       		//log the error
       		integrationErrorList.add(new Integration_Error__c(Direction__c = 'Outbound PUT'
       															, Error_Description__c = 'CALLOUT_EXCEPTION '+ e.getMessage()
       															, Integration_Object__c = 'Contact'
       															, Integration_Point__c = 'IE'
       															, Request_Data__c =  JSON.serialize(IndividualsPut)));
       		hasErrors = true;
       }
       
       if(!hasErrors)
       {
	       if(IndividualsPostResponse.Individuals != null && IndividualsPostResponse.Individuals.size() > 0)
	       		processResponse(IndividualsPostResponse, hasErrors, contactMap, addressMap, integrationErrorList);
	       if(IndividualsPutResponse.Individuals != null && IndividualsPutResponse.Individuals.size() > 0)
	       		processResponse(IndividualsPutResponse, hasErrors, contactMap, addressMap, integrationErrorList);
       }  
       
       //update the records with the IE Keys
       update contactMap.values();
       if(addressMap.size() > 0)
       		update addressMap.values();
       if(integrationErrorList.size() > 0)
       		insert integrationErrorList;
       
         
    }
    
    global void finish(Database.BatchableContext BC)
    {
		if(! this.hasErrors  || Test.isRunningTest())
		{
			//call the next batch in the chain if there are no fatal errors
			Database.executeBatch(new Batch_Sync_IE_Subscription('Pending'));
		}
    }
    
    global void processResponse(IE_IntegrationObjects.IE_UserListResponse Individuals, boolean hasErrors, 
    							map<Id, Contact> contactMap, map<Id, Address__c> addressMap, list<Integration_Error__c> integrationErrorList)
    {
    	
       	//Parse the response for errors
       	// retrieve the IE IDs and update the base as well as the child objects if they are null
       	// update the status to Processed
       
       	//log errors
       	//update the status to Error
       	
       	TriggerUtility.limitIntegrationBatch = true;
       	for(IE_IntegrationObjects.IE_User individual : Individuals.Individuals)
       	{
       		
       		
       			
       		if(individual.errors != null && individual.errors.size() > 0 )
       		{
       			contactMap.get(individual.SFDCId).IE_Sync_Status__c = 'Error';
       			integrationErrorList.add(new Integration_Error__c(Direction__c = 'Outbound'
       															, Error_Description__c = String.ValueOf(individual.errors)
       															, Integration_Object__c = 'Contact'
       															, Integration_Object_Id__c = individual.SFDCId
       															, Integration_Point__c = 'IE'
       															, Request_Data__c = JSON.serialize(individual) ));
       		}
       		else
       		{
       			contactMap.get(individual.SFDCId).IE_Sync_Status__c = 'Processed';
       			contactMap.get(individual.SFDCId).IE_Id__c = individual.IEId;
       		}
       		
       		if(individual.Address != null && addressMap.containsKey(individual.Address.SFDCId))
       		{
       			if(individual.Address.errors != null && individual.Address.errors.size() > 0)
	       		{
	       			addressMap.get(individual.Address.SFDCId).IE_Sync_Status__c = 'Error';
	       			integrationErrorList.add(new Integration_Error__c(Direction__c = 'Outbound'
	       															, Error_Description__c = String.ValueOf(individual.Address.errors)
	       															, Integration_Object__c = 'Address'
	       															, Integration_Object_Id__c = individual.Address.SFDCId
	       															, Integration_Point__c = 'IE'
	       															, Request_Data__c = JSON.serialize(individual) ));
	       		}
	       		else
	       		{
	       			if(addressMap.containsKey(individual.SFDCId))
	       			{
	       			  	addressMap.get(individual.Address.SFDCId).IE_Id__c = individual.Address.IEId;
       					addressMap.get(individual.Address.SFDCId).IE_Sync_Status__c = 'Processed';
	       			}
	       		
	       		}
       		}
       		
       			
       	}
    }
    

}