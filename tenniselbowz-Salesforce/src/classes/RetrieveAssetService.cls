@RestResource(urlMapping='/RetrieveAsset/*')
global with sharing class RetrieveAssetService {
 
	global class ServiceAsset
	{
		public string	AssetId{get;set;}
		public string	SerialNumber{get;set;}
		public string	Model{get;set;}
		public string	ProductName{get;set;}
		public boolean	Valid{get;set;}
		public string CodeStringFormat{get;set;}
		public list<string> CodeValues{get;set;}
	}
	
	
    @HttpGet
    global Static ServiceAsset getAsset()
    {
    	string serialNum = RestContext.request.params.get('SerialNumber'); 
    	ServiceAsset response = new ServiceAsset();
    	response.SerialNumber = serialNum;
    	response.Valid = false;
    	
    	for(Asset a : [select SerialNumber
							, Product2.ProductCode
							, Product2.Name
							, Id
							, Format_Number__c
							, Current_Code_String_Breakdown__c
							, Code_String_Breakdown__c
						from Asset
					   where SerialNumber = :serialNum])	
		{
			string codeStringBreakDown = '';
            
            if(a.Current_Code_String_Breakdown__c != null) 
            	codeStringBreakDown = a.Current_Code_String_Breakdown__c;
            else  
            	codeStringBreakDown = a.Code_String_Breakdown__c;
            	
			response.SerialNumber 	= a.SerialNumber;
			response.Model			= a.Product2.ProductCode;
			response.ProductName	= a.Product2.Name;
			response.AssetId 		= a.Id;
			response.Valid 			= true;
			response.CodeStringFormat = a.Format_Number__c;
			response.CodeValues = Batch_Sync_IE_Unit.getCodeStringValues(codeStringBreakDown);
			
			
			
		}
		
		return response;
    }

}