// *********************************************************************************** 
//
//  UpdateL2UserTest
//  
//  Test class for the MS_UpdateInstallKey trigger.
//  3/25/10 - RCA - Initial Creation
// ***********************************************************************************

@isTest
private class MS_UpdateInstallKeyOnContractChange_Test {

   static testMethod void myUnitTest()
    {
    	
    //Set up an acct to use later in the test
    account acct  = new account();
		acct.name = 'Test Company';
		acct.Industry = 'Law Firm - UK(House)';
		acct.BillingCountry = 'France';
	
	insert acct;
					
//Set up a contract to use later in the test					
	contract newCont = new contract();
		newCont.accountID = acct.id;
		newCont.name='DocXtools contract';
		newCont.status = 'Draft';
		newCont.startDate = date.today() - 360;
		newCont.endDate = date.today() + 90;
	//	newCont.Year1_Billing_Amount__c = 100;
	//	newCont.Year2_Billing_Amount__c = 100;
	//	newCont.Year3_Billing_Amount__c = 100;
	//	newCont.Year4_Billing_Amount__c = 100;
insert newCont;
string id = newCont.Id;



//Set up another contract to use later in the test					
	contract newCont2 = new contract();
		newCont2.accountID = acct.id;
		newCont2.name='DocID contract';
		newCont2.status = 'Draft';
		newCont2.startDate = date.today() - 360;
		newCont2.endDate = date.today() + 90;
	//	newCont2.Year1_Billing_Amount__c = 100;
	//	newCont2.Year2_Billing_Amount__c = 100;
	//	newCont2.Year3_Billing_Amount__c = 100;
	//	newCont2.Year4_Billing_Amount__c = 100;
insert newCont2;
string id2 = newCont2.Id;

//Add DOCID as a product to the DocID contract (newCont2) above
	contract_product__c cp2 = new contract_product__c (recordType= [select name from recordtype where name = 'site licenses']);
	cp2.Product__c='DocId';
	cp2.Contract__c=id2;
	insert cp2;
	


test.starttest();
	
    		
	//Add product associated to the DocXtools contract. Will now have DocID and DocXtools.
	contract_product__c cp = new contract_product__c (recordType= [select name from recordtype where name = 'site licenses']);
	cp.Product__c='DocXtools';
	cp.Contract__c=id;
	insert cp;
	
	//Check Licence key - should show DocXtools and DocID.
	LicenseKeyInformation__c licKeyInfo = [select id, Microsystems_Install_Key__c from LicenseKeyInformation__c where Linked_Account__c = :acct.id];
	system.assertEquals('2057-81-QT9VH', licKeyInfo.Microsystems_Install_Key__c);
	
	//update DocXtools contract to be expired (set to 10 days ago)
	newCont.endDate = date.today() - 10;
	update newCont;
		
	//check install key - should indicate only DocID, because the contract with DocXtools has expired
	LicenseKeyInformation__c licKeyInfo2 = [select id, Microsystems_Install_Key__c from LicenseKeyInformation__c where Linked_Account__c = :acct.id];
	system.assertEquals('2057-81-4T9VH',licKeyInfo2.Microsystems_Install_Key__c);
		
	}

}