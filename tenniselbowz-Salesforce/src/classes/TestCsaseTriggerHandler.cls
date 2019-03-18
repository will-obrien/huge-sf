@isTest
private class TestCsaseTriggerHandler {
	
	static testmethod void runTest()
	{
		//create an account for the assets
		Account a = new Account(Name = 'Test');
		insert a;
		
		//create some Assets
		list<Asset> assets = new list<Asset>{new Asset(Name = 'test',
						                           AccountId = a.Id,
						                           SerialNumber='123Test'
						                           )
						                     ,new Asset(Name = 'test1',
						                           AccountId = a.Id,
						                           SerialNumber='1234Test'
						                           )};
   		insert assets;
   		
   		//create a new case
   		Case webCase = new Case();
   		
   		webCase.Subject = 'Test';
   		webCase.SuppliedCompany = 'Test';
   		webCase.SuppliedCompany_PostalCode__c = '11111';
   		webCase.SuppliedEmail = 'test@daikin.com';
   		webCase.SuppliedName = 'Tester';
   		webCase.SuppliedPhone = '3332221111';
   		webCase.Reason = 'Maintenance';
   		webCase.Description = 'Testing';
   		
   		insert webCase;
   		
   		list<Case_Asset__c> caseAssets = new list<Case_Asset__c>();
   		//associate the assets to the case
   		for(Asset ast : assets)
   		{
   			caseAssets.add(new Case_Asset__c(Case__c = webCase.Id
   			                                ,Asset__c = ast.Id));
   		}
   		
   		insert caseAssets;
		
		//close the case
		webCase.Status = 'Closed';
		DataBase.Saveresult sres = Database.update(webCase, false);
		
		//verify that we have an error and also the error message we are expecting
		system.AssertEquals(false, sres.isSuccess());
	    system.AssertEquals(sres.getErrors()[0].getMessage(), CsaseTriggerHandler.CLOSE_WITHOUT_FAILURE_MESSAGE);
		
		//verify rule does not evaluate unles case is set to close
		webCase.Status = 'Working';
		sres = Database.update(webCase, false);
		system.AssertEquals(true, sres.isSuccess());
		
		// add the failure cause to clear the case for closing 
		for(Case_Asset__c ca : caseAssets)
		{
			ca.Failure_Cause__c = 'Electrical';
			ca.Failure_Category__c = 'Electrical';
		}
		update caseAssets;
		
		//close the case
		webCase.Status = 'Closed';
		sres = Database.update(webCase, false);
		
		//verify that we have no errors
		system.AssertEquals(true, sres.isSuccess());
		
	}

}