@isTest
private class TestCase_AssetTriggerHandler {
	
	static testMethod void runTest()
	{
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
		
		//create an account for the assets
		Account a = new Account(Name = 'Test');
		insert a;
		
		//create some Assets
		Asset a1 = new Asset(Name = 'test',
                             AccountId = a.Id,
                             SerialNumber='123Test'
                             );
        insert a1;
		Asset a2 = new Asset(Name = 'test',
                             AccountId = a.Id,
                             SerialNumber='1234Test'
                             );
   		insert a2;
		
		//create case Asset records
		Case_Asset__c ca1 = new Case_Asset__c(Case__c = webCase.Id
   			                                 ,Asset__c = a1.Id);
   	    
   	    
   	    Case_Asset__c ca2 = new Case_Asset__c(Case__c = webCase.Id
   			                                 ,Asset__c = a2.Id);
   	    list<Case_Asset__c> caseAssets = new list<Case_Asset__c>{ca1,ca2};
   	    
   	    list<Database.Saveresult> sr = Database.insert(caseAssets, false) ;
   	    
		//verify successful insert
		for(Database.Saveresult r : sr)
		{
			System.assertEquals(true,r.isSuccess());
		}
		
		//add the same asset in a separate case asset record using the same case
		Case_Asset__c ca3 = new Case_Asset__c(Case__c = webCase.Id
   			                                 ,Asset__c = a2.Id);
		Database.Saveresult srErr = Database.insert(ca3, false) ;
		
		//validate an error is raised
		System.assertEquals(false,srErr.isSuccess());
		system.AssertEquals(srErr.getErrors()[0].getMessage(), Case_AssetTriggerHandler.DUPLICATE_CASE_ASSET_ERROR);
		
		//update the existing case asset record with a duplicate asset
		ca2.Asset__c = a1.Id;
		srErr = Database.update(ca2, false) ;
		
		//validate an error is raised on update
		System.assertEquals(false,srErr.isSuccess());
		system.AssertEquals(srErr.getErrors()[0].getMessage(), Case_AssetTriggerHandler.DUPLICATE_CASE_ASSET_ERROR);

		
	}

}