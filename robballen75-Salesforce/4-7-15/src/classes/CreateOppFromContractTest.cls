@isTest
private class CreateOppFromContractTest {
 
        
          public static testMethod void myUnitTest() 
    {
    	
   		user u = [select id from user limit 1];
					
    	 //Set up an acct to use later in the test
    	account acct  = new account();
		acct.name = 'Test Company';
		acct.Industry = 'Law Firm - UK(House)';
		acct.BillingCountry = 'France';
	    acct.Client_Relations_Account_Owner__c = u.id; 
		insert acct;
					
	
//Set up a contract to use later in the test					
		contract newCont = new contract();
		newCont.accountID = acct.id;
		newCont.name='DocXtools contract';
		newCont.status = 'Draft';
		newCont.startDate = date.today() - 360;
		newCont.endDate = date.today() + 90;
		newCont.Currency_Type__c = 'other';
		insert newCont;
		string id = newCont.Id;

//Set up contract product
RecordType rt =[select name from recordtype where name = 'site licenses'];
		
contract_product__c cp = new contract_product__c (recordType= rt);
	cp.Product__c='French Canadian';
	cp.Contract__c=id;
	insert cp;
	
contract_product__c cp2 = new contract_product__c (recordType= rt);
	cp2.Product__c='DocXtools';
	cp2.Contract__c=id;
	insert cp2;
		
    	
system.debug('just started');
test.starttest();    	

        PageReference pageRef = Page.CreateRenewalOpportunity;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(newCont);
       CreateOppFromContract controller = new CreateOppFromContract(sc);
        ApexPages.currentPage().getParameters().put('Id',newCont.id);
       controller.create();
   
        opportunity o = [select id,Related_Renewal_Contract__c   from opportunity where Related_Renewal_Contract__c = :newCont.id];
        system.assertEquals(newCont.id, id);
		
		delete o;
		delete cp2;
		newCont.currency_type__c = '�';
		update newCont;
		controller.create();
		
        newCont.Contract_Type__C = 'Agreement (Initial)';
        newCont.Contract_Sub_Type__c = 'Perpetual';
        newCont.Currency_type__c = '�';
	    newCont.Year_1_License_Amount_3BClean__c = 100;
	    update newCont;
	    controller.create();
	
		
        test.stoptest();
        
        
    }
        
        
        
    }