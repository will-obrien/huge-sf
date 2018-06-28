/**
 * This is the test class for the PGIQuotesTabController class and SortingHelper class. 
 * It contains test methods to test the functionality of pagination and sorting on the VF quotes tab.
 *
 * @author Amit M.
 * @version 1.0
 */
@isTest
private class Test_PGIQuotesTabConroller {

	/* Store instance of opportunity object. */
	private static Opportunity opportunity;
	
	/**
	 * Unit test the quotes tab functionality for different view options and filters.
	 */
    static testMethod void UnitTest_TestQuoteListSorting() 
    {
    	Test.startTest();
    	setUp(false);
    	// create instance of controller.
    	PGIQuotesTabController controller = new PGIQuotesTabController();
    	
    	// check if quote list of populated properly or not.
    	List<Quote> quoteList = controller.quoteList;
    	system.assertNotEquals(quoteList, NULL);
    	system.assertEquals(quoteList.isEmpty(), false);
    	system.assertEquals(quoteList.size(), 1);
    	system.assertEquals(controller.sortExpression, PGIQuotesTabController.DEFAULT_SORT_COLUMN);
    	system.assertEquals(controller.sortDirection, PGIAppConstants.SORT_DIRECTION_ASC);
    	
    	// refresh quote list and see if sorting direction changes properly or not.
    	Boolean showQuoteOwner = controller.showQuoteOwner;
    	controller.refreshQuoteList();
    	system.assertEquals(controller.sortDirection, PGIAppConstants.SORT_DIRECTION_DESC);
    	
    	// get the available view and change the view.
    	List<Selectoption> selectOptionList = controller.views;
    	system.assertNotEquals(selectOptionList, NULL);
    	system.assertEquals(selectOptionList.isEmpty(), false);
    	system.assertEquals(selectOptionList.size(), PGIAppConstants.QUOTES_VIEW_OPTIONS.size());
    	
    	// Change the quote list view filter.
    	controller.selectedView = selectOptionList.get(1).getValue();
    	
    	// refresh quote list after view change and check if all the values are reset properly.
    	controller.refreshQuoteList();
    	system.assertEquals(controller.sortDirection, PGIAppConstants.SORT_DIRECTION_ASC);
    	quoteList = controller.quoteList;
    	system.assertEquals(quoteList.isEmpty(), true);
    	
    	controller.selectedView = selectOptionList.get(2).getValue();
    	// refresh quote list after view change and check if all the values are reset properly.
    	controller.refreshQuoteList();
    	quoteList = controller.quoteList;
    	system.assertEquals(quoteList.size(), 1);
    	system.assertEquals(controller.sortDirection, PGIAppConstants.SORT_DIRECTION_ASC);
    	
    	// open the opportunity detail page by passing the opprotunity id as parameter.
    	ApexPages.currentPage().getParameters().put('objectId', opportunity.Id);
    	Pagereference reference = controller.openSelectedLink();
    	system.assertNotEquals(reference.getUrl(), NULL);
    	
    	Test.stopTest();
    }
    
    /**
	 * Unit tests the quotes tab functionality pagination.
	 */
    static testMethod void UnitTest_TestQuoteListPagination() 
    {
    	Test.startTest();
    	setUp(true);
    	// create instance of controller.
    	PGIQuotesTabController controller = new PGIQuotesTabController();
    	
    	// check if quote list of populated properly or not.
    	List<Quote> quoteList = controller.quoteList;
    	system.assertNotEquals(quoteList, NULL);
    	system.assertEquals(quoteList.isEmpty(), false);
    	system.assertEquals(quoteList.size(), 25);
    	system.assertEquals(controller.sortExpression, PGIQuotesTabController.DEFAULT_SORT_COLUMN);
    	system.assertEquals(controller.sortDirection, PGIAppConstants.SORT_DIRECTION_ASC);
    	
    	if (controller.showPageCount)
    	{
	    	String pageCountString = controller.getPageCount();
	    	system.assertNotEquals(pageCountString, NULL);
    	}
    	if (controller.hasNext)
    	{
    		controller.next();
    		system.assertEquals(controller.pageNumber, 2);
    		quoteList = controller.quoteList;
    	}
    	if (controller.hasPrevious)
    	{
    		controller.previous();
    		system.assertEquals(controller.pageNumber, 1);
    		quoteList = controller.quoteList;
    	}
    	if (controller.hasNext)
    	{
    		controller.last();
    		system.assertEquals(controller.pageNumber, 2);
    		quoteList = controller.quoteList;
    	}
    	if (controller.hasPrevious)
    	{
    		controller.first();
    		system.assertEquals(controller.pageNumber, 1);
    		quoteList = controller.quoteList;
    	}
    }
    
    /**
     * Sets up unit test data for testing.
     */
    private static void setUp(Boolean createQuoteList)
    {
    	Account account = PGITestUtilities.getAccountDetails();
		insert account;
		system.assertNotEquals(account.Id, null);
		opportunity = PGITestUtilities.getOpportunityDetails();
		opportunity.AccountId = account.Id;
		// set the probability here to 10%, otherwise custom validation fails.
		opportunity.Prob_Input__c = '10';
		insert opportunity;
		system.assertNotEquals(opportunity.Id, null);
		Contact contact = PGITestUtilities.getContactDetails(account.Id);
		contact.email='test@salesforce.com';
        contact.title='Mr';
        // create mutliple quotes for pagination functionality testing.
        if (createQuoteList)
        {
        	List<Quote> testQuoteList = new List<Quote>();
        	for (Integer i = 0; i < 50; i++)
        	{
        		testQuoteList.add(PGITestUtilities.getQuoteDetails(account.Id, contact.Id ,opportunity.Id));
        	}
        	insert testQuoteList;
        }
        else
        {
			Quote quote = PGITestUtilities.getQuoteDetails(account.Id, contact.Id ,opportunity.Id); 
			insert quote;
        }
    }
}