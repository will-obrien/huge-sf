@isTest
private class TestRetrieveAssetService {

	static testmethod void testThisClass()
	{
		//create an account for the assets
		Account a = new Account(Name = 'Test');
		insert a;
		
		//create some Assets
		Asset a1 = new Asset(Name = 'test',
                             AccountId = a.Id,
                             SerialNumber='123Test'
                             );
        insert a1;
        
        //call the service
        
        RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
 
		req.requestURI = 'https://cs8.salesforce.com/services/apexrest/RetrieveAsset?SerialNumber=123Test';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		RestContext.request.params.put('SerialNumber','123Test');
		RetrieveAssetService.ServiceAsset results = RetrieveAssetService.getAsset();
		System.debug(':::::results:::::'+results);
		
        //assert the results
        System.assertEquals('123Test',results.SerialNumber);
        
        
        
	}
}