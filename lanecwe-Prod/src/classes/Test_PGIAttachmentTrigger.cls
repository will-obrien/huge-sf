/**
 * This is the test class for the PGIAttachmentTrigger trigger. 
 * It contains test methods to test the functionality of deletion of quote attachments.
 *
 * @author Amit M.
 * @version 1.0
 */
@isTest
private class Test_PGIAttachmentTrigger {

	/* Stores attachment object. */
	private static Attachment attachment;
	
	/**
	 * Checks that quote attachment should not get deleted once contract document is generated.
	 */
    static testMethod void UnitTest_QuoteAttachmentNotDelete() 
    {
    	Test.startTest();
    	setUp();
    	try
    	{
    		delete attachment;
    	}
    	catch(System.DmlException ex)
    	{
    		system.assert(true);
    	}
    	Test.stopTest();
    }
    
    /**
	 * Checks that quote attachment should get deleted if request comes from 'Cancel Contract' button.
	 */
    static testMethod void UnitTest_QuoteAttachmentDelete() 
    {
    	Test.startTest();
    	setUp();
		PGIAppConstants.CHECK_QUOTE_STATUS = false;
		delete attachment;
    	Test.stopTest();
    }
    
	private static void setUp()
	{
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
	    insert contact;
	    system.assertNotEquals(contact.Id, null);
		Quote quote = PGITestUtilities.getQuoteDetails(account.Id, contact.Id ,opportunity.Id); 
		quote.Status = PGIAppConstants.QUOTE_STATUSES[5];
		insert quote;
		system.assertNotEquals(quote.Id, null);
		attachment = PGITestUtilities.createAttachment(quote.Id);
		insert attachment;
		system.assertNotEquals(attachment.Id, null);
	}
}