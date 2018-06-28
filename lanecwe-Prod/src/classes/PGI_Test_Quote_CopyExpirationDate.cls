/**
 * This is the test class for the PGI_Quote_CopyExpirationDate trigger and PGICopyExpirationDateHelper class. 
 * It contains test methods to test the functionality of copy expiration date trigger on quote object.
 *
 * @author Amit M.
 * @version 1.0
 */
@isTest(SeeAllData=true)
private class PGI_Test_Quote_CopyExpirationDate {

	/**
	 * Test method to check expiration date is copied properly on QLI.
	 */
	static testMethod void UnitTest_CopyExpirationDate() {
		
		Test.startTest();
		Account account = PGITestUtilities.getAccountDetails();
		insert account;
		system.assertNotEquals(account.Id, null);
		Opportunity opportunity = PGITestUtilities.getOpportunityDetails();
		opportunity.AccountId = account.Id;
		// set the probability here to 10%, otherwise custom validation fails.
		opportunity.Prob_Input__c = '10';
		insert opportunity;
		system.assertNotEquals(opportunity.Id, null);
		Contact contact = PGITestUtilities.getContactDetails(account.Id);
		contact.email='test@salesforce.com';
        contact.title='Mr';
		Quote quote = PGITestUtilities.getQuoteDetails(account.Id, contact.Id ,opportunity.Id); 
		quote.Desired_Service_Commencement_Date__c = Date.today().addDays(16);
		insert quote;
		system.assertNotEquals(quote.Id, null);
		Product2 product = PGITestUtilities.getStdProduct();
		product.IsActive = true;
		insert product;
		system.assertNotEquals(product.Id, null);
		PricebookEntry priceBookEntry = PGITestUtilities.CreatePriceBookEntryForProduct(product);
		insert priceBookEntry;
		system.assertNotEquals(priceBookEntry.Id, null);
		QuoteLineItem qli = PGITestUtilities.CreateQli(quote.Id, priceBookEntry.Id);
		// set the contract term for qli, so that expiration date is calculated properly.
		qli.Contract_Term__c = 2.0;
		insert qli;
		system.assertNotEquals(qli.Id, null);
		qli = [Select Id, Expiration_Date__c, Expiration_Date_Copy__c From QuoteLineItem Where Id =: qli.Id];
		quote.Desired_Service_Commencement_Date__c = Date.today().addDays(16);
		quote.CustomerSignature__c = Date.today().addDays(25);
		update quote;
		Test.stopTest();
		qli = [Select Id, Expiration_Date__c, Expiration_Date_Copy__c From QuoteLineItem Where Id =: qli.Id];
		if (qli != null)
		{
			system.assertEquals(qli.Expiration_Date_Copy__c, qli.Expiration_Date__c);
		}
	}
}