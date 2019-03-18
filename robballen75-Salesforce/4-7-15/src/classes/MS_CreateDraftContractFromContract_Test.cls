/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(SeeAllData=true)
private class MS_CreateDraftContractFromContract_Test {

        public static testMethod void myUnitTest() 
    {
    	
   		user u = [select id from user limit 1];
					
    	 //Set up an acct to use later in the test
    	account acct  = new account();
		acct.name = 'Test Company';
		acct.Industry = 'Law Firm - USA';
		acct.BillingCountry = 'United States';
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
		newCont.Contract_Sub_Type__c = 'Subscription';
		newCont.Contract_Term_Length_Yrs__c = 3;
		insert newCont;
		string id = newCont.Id;
		

//Set up contract product
RecordType rt =[select name from recordtype where name = 'site licenses'];
		
contract_product__c cp = new contract_product__c (recordType= rt);
	cp.Product__c='French Canadian';
	cp.Contract__c=id;
	insert cp;
	
site__c site1 = new site__c();
site1.name='Boston';
site1.account__C = acct.id;
insert site1;

contract_site__c csite = new contract_site__c();
csite.site__c = site1.id;
csite.contract__c = id;
insert csite;    	
    	
system.debug('just started');
test.starttest();    	

        PageReference pageRef = Page.CreateDraftContract;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(newCont);
        CreateDraftContractFromContract controller = new CreateDraftContractFromContract(sc);
        ApexPages.currentPage().getParameters().put('Id',newCont.id);
        controller.create();
   		contract c2 = [select id from contract where previous_term_contract__c = :newCont.id];
        
        system.assertEquals(newCont.id, id);
		
		delete c2;
		newCont.Contract_Term_Length_Yrs__c = 2;
		update newCont;
		controller.create();
		
       
	

        test.stoptest();
        
        
    }
        
        
     
   
   
   
}