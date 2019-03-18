@RestResource(urlMapping='/SfdcRecordUpdate/*')
global class IE_GeneralSobjectUpdateService {
	
	global class IE_Error
	{
		webservice string ErrorCode{get;set;}
		webservice string ErrorMessage{get;set;}
		
		global IE_Error(String errCode, String errMsg)
		{
			ErrorCode = errCode;
			ErrorMessage = errMsg;
		}
	}
	global class Field
	{
		webservice string name{get;set;}
		webservice string value{get;set;}
	}
	
	global class Record
	{
		webservice string SFDCId{get;set;}
		webservice list<field> fields{get;set;}
		webservice list<IE_Error> errors{get;set;}
		
	}
	 
	global class UpdateRequest
	{
		webservice list<Record> records{get;set;}
	}
	
	@HttpPut
	global static UpdateRequest doPut(list<record> records)
	{
		TriggerUtility.limitIeServiceIntegration = true;
		UpdateRequest response = new UpdateRequest();
		response.records = records;
		
		list<SObject> updateList = new list<Sobject>();
		map<string,map<String, Schema.SobjectField>> objectsDescribed = describeObjectFields();
		
		for(Record rec : response.records)
		{
			rec.errors = new list<IE_Error>();
			String errorMessage = '';
			String sObjetType = String.ValueOf(ID.valueOf(rec.SFDCId).getSObjectType());
			Sobject sob =  Schema.getGlobalDescribe().get(sObjetType).newSObject(rec.SFDCId) ;
			set<String> fieldList = new set<String>();
			fieldList.addAll(IE_Integration_Field_Set__c.getInstance(sObjetType).Field_List__c.split(','));
			//Error Handling for custom setting and field casting. Do not add to the update list and provide an error
			for(Field f : rec.fields)
			{
				if(fieldList.isEmpty() || !fieldList.contains(f.Name))
				{
					rec.errors = new list<IE_Error>{new IE_Error('UNAUTHORIZED FIELD', f.Name + ' Is Not Recognized as an Editable Field on Object '+sObjetType)};
					break;
				}
				try{
				
					Schema.DescribeFieldResult fieldsDescribed = objectsDescribed.get(sObjetType).get(f.Name).getDescribe();
					string dataType = 'String';//'UNDEFINED';
	                if(fieldsDescribed != null )
	                    dataType = fieldsDescribed.getSOAPType().name();
	                
	                
	                //Cast the source data to the destination data type
	                if(dataType == 'Boolean')
	                    sob.put(f.Name, Boolean.valueOf(f.value));
	                else if(dataType == 'Date' )
	                    sob.put(f.Name, Date.valueOf(f.value));
	                else if(dataType == 'DateTime')
	                    sob.put(f.Name, DateTime.valueOf(f.value));
	                else if(dataType == 'Double')
	                    sob.put(f.Name, Double.valueOf(f.value));
	                else if(dataType == 'Integer')
	                    sob.put(f.Name, Integer.valueOf(f.value));
	                else if(dataType == 'String')
	                    sob.put(f.Name, String.valueOf(f.value));
	                else if(dataType == 'Id')
	                    sob.put(f.Name, (Id)f.value);
				}
				catch(Exception e)
				{
					rec.errors = new list<IE_Error>{new IE_Error('FIELD EXCEPTION', e.getMessage())};
					errorMessage = e.getMessage();
					break;
				}
			}
			if(rec.errors != null && rec.errors.size() > 0)
			{
				sob.addError(rec.errors[0].ErrorMessage);
			}
			updateList.add(sob);
		
		}
		
		//perform the update
		Integer cnt = 0;
		
		if(updateList.size() > 0)
    	{
    		list<Database.SaveResult> results = database.update(updateList, false);
    		for(Database.SaveResult r : results)
    		{
    			if(!r.isSuccess())
    			{
    				if(response.records[cnt].errors == null)
    					response.records[cnt].errors = new list<IE_Error>();
    				for(Database.Error err : r.getErrors())
    				{
    					response.records[cnt].errors.add(new IE_Error('SALESFORCE_DML_ERROR', err.message));  
    					
    				}
    			}
    			cnt ++;
    		}
    	}
		
		return response;
		
		
	}
	
	global static map<string,map<String, Schema.SobjectField>> describeObjectFields()
    {
    	list<String> objectList = new list<String>{'Account', 'Contact', 'Asset','Address__c','Subscription__c'};
        
        map<String, IE_Integration_Field_Set__c> objectFieldSettingMap = IE_Integration_Field_Set__c.getAll();
        
        map<string,map<String, Schema.SobjectField>> objectsDescribed = new map<string,map<String, Schema.SobjectField>>();
		// Get the Global Describe which contains details for all objects
		Map<String, Schema.SObjectType> GlobalDescribe = new Map<String, Schema.SObjectType>();
		GlobalDescribe = Schema.getGlobalDescribe();
		
		//iterate through our supported objects and get the field information
		for(String sObj : objectFieldSettingMap.keySet())
		{
			objectsDescribed.put(sObj,GlobalDescribe.get(sObj).getDescribe().fields.getMap());
		}
		
		return objectsDescribed;
    }
    
    global static string getSampleJsonRequest()
    {
    	Record rec = new Record();
    	rec.SFDCId='003L000000LFPGS';
    	Field field = new Field();
    	field.name = 'FirstName';
    	field.value = 'Jethro';
    	
    	
    	Field field2 = new Field();
    	field2.name = 'LastName';
    	field2.value = 'Clampet';
    	
    	Field field3 = new Field();
    	field3.name = 'IE_Contact__c';
    	field3.value = 'true';
    	
    	
    	rec.fields = new list<Field>{field,field2,field3};
    	
    	Record rec2 = new Record();
    	rec2.SFDCId='001L000000LdepH';
    	Field field4 = new Field();
    	field4.name = 'Phone';
    	field4.value = '888-999-7777';
    	
    	
    	Field field5 = new Field();
    	field5.name = 'IE_Account__c';
    	field5.value = 'true';
    	
    	
    	rec2.fields = new list<Field>{field4,field5};
    	
    	
    	UpdateRequest ur = new UpdateRequest();
    	ur.records = new list<Record>{rec, rec2};
    	
    	string req = JSON.serialize(ur);
    	
    	return req;
    	
    }

}