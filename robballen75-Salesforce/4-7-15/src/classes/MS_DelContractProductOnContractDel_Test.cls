// *********************************************************************************** 
//  MS_DeleteContractProductOnCtrctDel_Test
//  
//  Test class for the MS_DeleteContractProductOnContractDelete trigger
//   
//  History:
//  4/2/10 Robb Allen - Created
// ***********************************************************************************
@isTest
private class MS_DelContractProductOnContractDel_Test {

    static testMethod void myUnitTest() {
        
//Set up an acct to use later in the test
   	account acct  = new account();
		acct.name = 'Test Company';
		acct.Industry = 'Law Firm - UK(House)';
	insert acct;
					
//Set up a contract to use later in the test					
	contract newCont = new contract();
		newCont.accountID = acct.id;
		newCont.name='test contract';
		newCont.status = 'Draft';
		newCont.startDate = date.today();
		newCont.endDate = date.today() + 90;
//		newCont.Year1_Billing_Amount__c = 100;
//		newCont.Year2_Billing_Amount__c = 100;
//		newCont.Year3_Billing_Amount__c = 100;
//		newCont.Year4_Billing_Amount__c = 100;
		insert newCont;
	//string contractNumber = newCont.ContractNumber;
	string id = newCont.id;

//add a new contract product associated to a contract for the above account.  
	contract_product__c cp = new contract_product__c (recordType= [select name from recordtype where name = 'site licenses']);
		cp.Product__c='DocXtools';
		cp.Contract__c=id;
	insert cp;

// verify that there is one contract_product__c for the given contract
integer cpCount = [select count() from contract_product__c where contract__c = :id];
system.assertEquals(1, cpCount);	
	
test.starttest();

//delte contract
delete newCont;

// verify there are no contract_products__c objects for the contract that was just deleted.
cpCount = [select count() from contract_product__c where contract__c = :id];        
system.assertEquals(0, cpCount);
            }
}