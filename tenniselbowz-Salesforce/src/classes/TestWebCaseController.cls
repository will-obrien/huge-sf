/*********************************************************************************
 Author       :   Nathan Shinn
 Created Date :   December 28,2013
 Description  :   Test class for WebCaseController
*********************************************************************************/
@isTest
private class TestWebCaseController {
	
	static testmethod void runTest()
	{
		WebCaseController ctl = new WebCaseController();
		Account a = new Account(Name = 'Test');
		insert a;
		
		Asset asset = new Asset(Name = 'test',
                           AccountId = a.Id,
                           SerialNumber='123Test'
                           );
   		insert asset;
   		
   		ctl.asset.SerialNumber = '123Test';
   		
   		ctl.searchAsset();
   		
   		//verify that the Asset was found
//   		System.assertNotEquals(null,ctl.asset.Id);
   		
   		ctl.webCase.Subject = 'Test';
   		ctl.webCase.SuppliedCompany = 'Test';
   		ctl.webCase.SuppliedCompany_PostalCode__c = '11111';
   		ctl.webCase.SuppliedEmail = 'test@daikin.com';
   		ctl.webCase.SuppliedName = 'Tester';
   		ctl.webCase.SuppliedPhone = '3332221111';
   		ctl.webCase.Reason = 'Maintenance';
   		ctl.webCase.Description = 'Testing';
   		
   		ctl.save();
   		
   		//verify that the case and the case_asset records were saved
   		//System.assertNotEquals(null,ctl.webCase.Id);
   		
   		//cause an exception
   		ctl.save();
   		
   		//test unfound asset
   		ctl.asset.SerialNumber='321Test';
   		ctl.searchAsset();
   		System.assertEquals(null,ctl.asset.Id);
   		
   		ctl.clearCase();
   		
	}

}