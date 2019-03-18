@RestResource(urlMapping='/IEUnitService/*')
global without sharing class IE_UnitService { 
 
	@HttpPut
    global Static IE_IntegrationObjects.IE_UnitListResponse doPut(list<IE_IntegrationObjects.IE_Unit> Units)
    {
    	//disable trigger functionality
        TriggerUtility.limitIeServiceIntegration = true;
        
    	System.Debug('::::Units::::'+Units);
    	IE_IntegrationObjects.IE_UnitListResponse response = new IE_IntegrationObjects.IE_UnitListResponse();
    	response.Units = Units;
    	response.errors = new list<IE_IntegrationObjects.IE_Error>();
    	list<Asset> assets = new list<Asset>();
    	Integer cnt = 0;
    	for(IE_IntegrationObjects.IE_Unit unit : Units)
    	{
    		try{
	    		assets.add( new asset(Id = unit.SFDCId
	    							, Commissioned__c = unit.Commissioned
	    							, IE_Updated_Date__c = unit.LastModifiedDate));
    		}
    		catch(Exception e)
    		{
    			response.Units[cnt].errors = new list<IE_IntegrationObjects.IE_Error>(); 
				response.Units[cnt].errors.add(new IE_IntegrationObjects.IE_Error('SALESFORCE_CONFIGURATION_ERROR', e.getMessage()));   
    			response.errors.add(new IE_IntegrationObjects.IE_Error('SALESFORCE_CONFIGURATION_ERROR', e.getMessage())); 
				
				assets.add( new asset(Commissioned__c = unit.Commissioned));
    		}
    		cnt++;
    	}
    	
    	list<Database.Saveresult> srList = new list<Database.Saveresult>();
    	cnt = 0;
    	
		srList = Database.Update(assets, false);
		for(Database.Saveresult res : srList)
		{
			if(!res.isSuccess())
			{
				//processingErrors.put(res.getId(), res.getErrors());
				response.Units[cnt].errors = new list<IE_IntegrationObjects.IE_Error>(); 
				for(Database.Error err : res.getErrors())
				{
					response.Units[cnt].errors.add(new IE_IntegrationObjects.IE_Error('SALESFORCE_DML_ERROR', err.getMessage()));   
    				response.errors.add(new IE_IntegrationObjects.IE_Error('SALESFORCE_DML_ERROR', err.getMessage()));  
					
				}
			}
			else
			{
				response.Units[cnt].SFDCId = res.getId();
			}
			
			cnt ++;
		}
		
		return response;
    }
}