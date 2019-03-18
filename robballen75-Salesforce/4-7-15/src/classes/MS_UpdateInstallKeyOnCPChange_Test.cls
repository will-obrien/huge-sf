// *********************************************************************************** 
//
//  UpdateL2UserTest
//  
//  Test class for the MS_UpdateInstallKeyOnContractProductChange trigger.
//  3/25/10 - RCA - Initial Creation
// ***********************************************************************************
@isTest
private class MS_UpdateInstallKeyOnCPChange_Test {

    static testMethod void myUnitTest()
    {
    	
    //Set up an acct to use later in the test
    	account acct  = new account();
		acct.name = 'Test Company';
		acct.Industry = 'Law Firm - UK(House)';
		acct.BillingCountry='France';
		insert acct;
		
		account acctUS  = new account();
		acctUS.name = 'Test Company';
		acctUS.Industry = 'Life Sciences';
		acctUS.BillingCountry='USA';
		insert acctUS;
		
		RecordType rt =[select name from recordtype where name = 'site licenses'];
		
					
//Set up a contract to use later in the test					
		contract newCont = new contract();
		newCont.accountID = acct.id;
		newCont.name='test contract';
		newCont.status = 'Draft';
		newCont.startDate = date.today();
		newCont.endDate = date.today() + 90;
		
insert newCont;
string id = newCont.Id;

//Set up a US contract to use later in the test					
		contract newContUS = new contract();
		newContUS.accountID = acctUS.id;
		newContUS.name='test contract';
		newContUS.status = 'Draft';
		newContUS.startDate = date.today();
		newContUS.endDate = date.today() + 90;
		//newCont.Year1_Billing_Amount__c = 100;
		//newCont.Year2_Billing_Amount__c = 100;
		//newCont.Year3_Billing_Amount__c = 100;
		//newCont.Year4_Billing_Amount__c = 100;
insert newContUS;
string idUS = newContUS.Id;
test.starttest();
system.debug('STARTING TEST!');
    	
	//add a new contract product associated to a contract for the above account.  
	contract_product__c cp = new contract_product__c (recordType= rt);
	cp.Product__c='French Canadian';
	cp.Contract__c=id;
	insert cp;
system.debug('JUST INSERTED FIRST CONTRACT PRODUCT');
	LicenseKeyInformation__c licKeyInfo2 = [select id, Microsystems_FC_Install_key__c from LicenseKeyInformation__c where Linked_Account__c = :acct.id];
	system.assertEquals('3084-81-4J9VH', licKeyInfo2.Microsystems_FC_Install_Key__c);
system.debug('JUST DID FIRST ASSERT');
	//update account to have different industries - to get a different key
	acct.Industry = 'Law Firm - USA';
	acct.BillingCountry = 'United States';
	update acct;
		system.debug('billing country=');
		system.debug(acct.BillingCountry);
	//update contract product to test modify of CP
	cp.Product_Description__c = 'changing account industry to Law Firm US';
	cp.product__c = 'DocXtools';
	update cp;
	
	LicenseKeyInformation__c licKeyInfo3 = [select id, Microsystems_Install_Key__c from LicenseKeyInformation__c where Linked_Account__c = :acct.id];
		system.assertEquals('1033-81-QJ9VH',licKeyInfo3.Microsystems_Install_Key__c);
	
	
		//update account to have null  industry - to get a different key
	acct.Industry = null;
	update acct;
		
	//update contract product to test modify of CP
	cp.Product_Description__c = 'changing account industry null';
	update cp;
	
	//adding TOC product
	contract_product__c cp2 = new contract_product__c (recordType=rt);
	cp2.Product__c='TOC';
	cp2.Contract__c=id;
	insert cp2;
	
	//adding Numbering product
	contract_product__c cp3 = new contract_product__c (recordType=rt);
	cp3.Product__c='Numbering';
	cp3.Contract__c=id;
	insert cp3;
	
		//adding DocID product
	contract_product__c cp4 = new contract_product__c (recordType=rt);
	cp4.Product__c='DocID';
	cp4.Contract__c=id;
	insert cp4;
	
			//adding Metadata server product
	contract_product__c cp5 = new contract_product__c (recordType=rt);
	cp5.Product__c='3BClean Server';
	cp5.Contract__c=id;
	insert cp5;
	
	LicenseKeyInformation__c licKeyInfo9 = [select id, Microsystems_Install_Key__c from LicenseKeyInformation__c where Linked_Account__c = :acct.id];
		system.assertEquals('1033-00-QTJ73',licKeyInfo9.Microsystems_Install_Key__c);
	
	
	delete cp5;
	contract_product__c cp6 = new contract_product__c (recordType=rt);
	cp6.Product__c='3BClean Desktop';
	cp6.Contract__c=id;
	insert cp6;
	
		//update account to have Other industry - to get a different key
	acct.Industry = 'Other';
	update acct;
		
	//update contract product to test modify of CP
	cp.Product_Description__c = 'changing account industry to not life or legal';
	update cp;
	
	LicenseKeyInformation__c licKeyInfo8 = [select id, Microsystems_Install_Key__c from LicenseKeyInformation__c where Linked_Account__c = :acct.id];
		system.assertEquals('1033-00-QTZ73',licKeyInfo8.Microsystems_Install_Key__c);
	
	//delete 3bclean desktop so I can add desktop + mobile
	delete cp6;
	contract_product__c cp7 = new contract_product__c (recordType=rt);
	cp7.Product__c='3BClean Desktop with Mobile';
	cp7.Contract__c=id;
	insert cp7;
	
	//update account to have life science industries - to get a different key
	acct.Industry = 'Life Sciences';
	acct.BillingCountry = 'United States';
	update acct;
	//update contract product to test modify of CP
	cp.Product_Description__c = 'changing account industry to Life Sciences';
	update cp;
	
	LicenseKeyInformation__c licKeyInfo7 = [select id, Microsystems_Install_Key__c from LicenseKeyInformation__c where Linked_Account__c = :acct.id];
		system.assertEquals('1033-28-PTR73',licKeyInfo7.Microsystems_Install_Key__c);
	
	
	//update account to have no billing country
	
	acct.BillingCountry = null;
	update acct;
		
	//update contract product to test modify of CP
	cp.Product_Description__c = 'changing account billing country to be null';
	update cp;
	
	LicenseKeyInformation__c licKeyInfo6 = [select id, Microsystems_Install_Key__c from LicenseKeyInformation__c where Linked_Account__c = :acct.id];
		system.assertEquals('1033-28-PTR73',licKeyInfo6.Microsystems_Install_Key__c);
	
	
	//update account to have 'other' industry
	acct.Industry = 'Other';
	update acct;
		
	//update contract product to test modify of CP
	cp.Product_Description__c = 'changing account industry to Other';
	cp.Product__c = 'Numbering';
	update cp;
	//account acct3 = [select Install_Key__c from account where id = :acct.id];
	LicenseKeyInformation__c licKeyInfo4 = [select id, Microsystems_Install_Key__c from LicenseKeyInformation__c where Linked_Account__c = :acct.id];
	system.assertEquals('1033-00-4TR73',licKeyInfo4.Microsystems_Install_Key__c);
		
    contract_product__c cp8 = new contract_product__c (recordType=rt);
	cp8.Product__c='K2 DocXssentials';
	cp8.Contract__c=id;
	insert cp8;
    
    
	//update account to have different industry
	acct.Industry = 'Life Sciences';
	update acct;
	
	//now, let's delete the CP added above - this should test the delete trigger, and recalc the install key field.
	delete cp;
	update acct;
	
	
	
	
	//account acct6 = [select Install_Key__c from account where id = :acct.id];
	LicenseKeyInformation__c licKeyInfo5 = [select id, Microsystems_Install_Key__c from LicenseKeyInformation__c where Linked_Account__c = :acct.id];
		system.assertEquals('1033-28-KTR73',licKeyInfo5.Microsystems_Install_Key__c);
	
	
		
	contract_product__c cp9 = new contract_product__c (recordType=rt);
	cp9.Product__c='French Canadian';
	cp9.Contract__c=id;
	insert cp9;
		
	LicenseKeyInformation__c licKeyInfo10 = [select id, Microsystems_FC_Install_key__c from LicenseKeyInformation__c where Linked_Account__c = :acct.id];
	system.assertEquals('3084-28-KTR73',licKeyInfo10.Microsystems_FC_Install_key__c);
		
	contract_product__c cp10 = new contract_product__c (recordType=rt);
	cp10.Product__c='Express';
	cp10.Contract__c=id;
	insert cp10;
		
	LicenseKeyInformation__c licKeyInfo11 = [select id, Microsystems_Install_Key__c from LicenseKeyInformation__c where Linked_Account__c = :acct.id];
	system.assertEquals('1033-28-QTR73',licKeyInfo11.Microsystems_Install_key__c);	
		
	
	
	
		
		
	test.stoptest();
          

  
   }
    
    
}