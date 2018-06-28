/**
 * Controller class for the PGIQuotesTab.page. Contains the logic,
 *  1) To dispalay quotes list on the page.
 *	2) To provide pagination for the quotes list on the page.
 *	3) To sort the columns displayed on the page for quotes list.
 *
 * @author Amit M.
 * @version 1.0
 */
public with sharing class PGIQuotesTabController {

	/* Stores constant value for page size. */
	private static final Integer PAGE_SIZE = 25;
	
	/* Stores select part of query string used in set controller. */
	private static final String SELECT_QUOTES_QUERY = 'SELECT Id, OpportunityId, Opportunity.Name, Opportunity.AccountId, '+
										'Opportunity.Account.Name, QuoteNumber, '+
                						'Status, Total_Contract_Value__c, Total_MRR__c ';
                					
    /* Stores the quote owner field name. */	
    private static final String QUOTE_OWNER_FIELD = 'Quote_Owner__c';
    
    /* Stores the from clause for quote selection query. */
    private static final String FROM_CLAUSE = 'FROM Quote';
    
    /* Stores name of default column used for sorting. */
    public static final String DEFAULT_SORT_COLUMN = 'QuoteNumber';
    
    /* Stores boolean value to check if set controller needs to be refreshed. */
	private Boolean refreshSetController = false;
	
	/* Stores old view value of the page. */
	private String oldView;
	
	/* Stores current page number selected in pagination. */
	private Integer currentPageNumber;
	
	/* Stores sort direction used in the sorting on the page. */
	public String sortDirection
	{
		get;
		set;
	}
	
	/* Stores sort column name used to sort the records on the page. */
	public String sortExpression
	{
		get
		{
			if (sortExpression == null || sortExpression == '')
        	{
        		sortExpression = DEFAULT_SORT_COLUMN;
        	}
        	return sortExpression;
		}
		set;
	}
	
	/* Stores boolean to check if quote owner should be displayed. */
	public Boolean showQuoteOwner
	{
		get
		{
			return (!this.selectedView.equalsIgnoreCase(PGIAppConstants.QUOTES_VIEW_OPTIONS[0]));
		}
		set;
	}
	
	/* Stores list of quote objects. */
	public List<Quote> quoteList
	{
		get
		{
			return (List<Quote>)this.setController.getRecords();
		}
		set;
	}
	
	/* Stores current view selected on the page. */
	public String selectedView
	{
		get
		{
			if (selectedView == null)
			{
				selectedView = PGIAppConstants.QUOTES_VIEW_OPTIONS[0].toUpperCase();
				oldView = selectedView;
			}
			return selectedView;
		}
		set;
	}
	
	/* Stores list of view options available on the page. */
	public List<Selectoption> views
	{
		get
		{
			if (views == null || views.isEmpty())
			{
				views = this.getViewOptions();
			}
			return views;
		}
		set;
	}
	
	/* Stores standard set controller used for pagination on the page. */
	private ApexPages.StandardSetController setController 
	{
        get
        {
            if(setController == null || this.refreshSetController)
            {
                setController = new ApexPages.StandardSetController(
                					Database.getQueryLocator(this.generateQueryString()));
                setController.setPageSize(PAGE_SIZE);
                // if controller is refreshed then set the page number to the old page number 
                // when controller was refreshed.
                if (this.refreshSetController)
                {
                	setController.setPageNumber(this.currentPageNumber);
                }
                refreshSetController = false;
            }
            return setController;
        }
        set;
    }
    
    /* Stores boolean to check if page count should be displaed on page or not. */
    public Boolean showPageCount
    {
    	get
    	{
    		return (this.setController.getHasNext() || this.setController.getHasPrevious());
    	}
    	set;
    }
    
    /* Indicates whether there are more records after the current page set. */
	public Boolean hasNext 
	{
		get 
		{
			return this.setController.getHasNext();
		}
		set;
	}
 
	/* Indicates whether there are more records before the current page set. */
	public Boolean hasPrevious 
	{
		get 
		{
			return this.setController.getHasPrevious();
		}
		set;
	}
 
	/* Returns the page number of the current page set. */
	public Integer pageNumber 
	{
		get 
		{
			return this.setController.getPageNumber();
		}
		set;
	}
	
	/**
	 * Gets the page count string, which is displayed on the page for pagination.
	 *
	 * @returns page count value string.
	 */ 
	public String getPageCount()
	{
		String pageCount = '';
		Integer startingCount = (this.setController.getPageNumber() - 1)* PAGE_SIZE;
		Integer endingCount = startingCount + PAGE_SIZE;
		Integer totalRecords = setController.getResultSize();
		// set the values in string array to be replaced in the custom label.
		String[] messageValues = new String[]{
								String.valueOf(startingCount + 1), 
								(endingCount > totalRecords) ? String.valueOf(totalRecords) : String.valueOf(endingCount), 
								String.valueOf(totalRecords)};
		return String.format(system.Label.PGI_PaginationCount, messageValues);
	}
	
	/**
	 * Refreshes the quote list on change of view and sorting on the page.
	 *
	 * @returns return the next page reference.
	 */ 
	public Pagereference refreshQuoteList()
	{
		this.updateSortDirection();
		// save the current page number before refreshing the set controller.
		this.currentPageNumber = this.setController.getPageNumber();
		refreshSetController = true;
		return null;
	}
	
	/**
	 * Changes the sort direction if the view has not been changed, otherwise sets the default values
	 * for page number, sort expression and sort direction. Sets the old view to current view.
	 *
	 */ 
	private void updateSortDirection()
	{
		if (this.sortDirection != null)
		{
			// if view has not changed then change the sort direction.
			if (this.oldView.equalsIgnoreCase(this.selectedView))
			{
				this.sortDirection = (this.sortDirection == PGIAppConstants.SORT_DIRECTION_ASC) 
								? PGIAppConstants.SORT_DIRECTION_DESC 
								: PGIAppConstants.SORT_DIRECTION_ASC;
			}
			else
			{
				this.currentPageNumber = 1;
				this.sortExpression = DEFAULT_SORT_COLUMN;
				this.sortDirection = PGIAppConstants.SORT_DIRECTION_ASC;
				this.oldView = this.selectedView;
			}
		}
	}
	
	/**
	 * Forwards the request to the detail page of selected value in the quote list on page.
	 *
	 * @returns, pagereference object.
	 */
	public Pagereference openSelectedLink()
	{
		return new Pagereference('/' + System.currentPageReference().getParameters().get('objectId'));
	}
	
	/**
	 * Generates the query string based on the selected view or selected sorting on the page.
	 *
	 * @returns, pagereference object.
	 */
	private String generateQueryString()
	{
		String selectClause = SELECT_QUOTES_QUERY;
		String whereClause = '';
		// where condition to get my quotes.
		if (PGIAppConstants.QUOTES_VIEW_OPTIONS[0].equalsIgnoreCase(this.selectedView))
		{
			whereClause = ' WHERE Opportunity.OwnerId=\'' + Userinfo.getUserId() + '\'';
		}
		// where condition to get quotes with attachments.
		else if (PGIAppConstants.QUOTES_VIEW_OPTIONS[1].equalsIgnoreCase(this.selectedView))
		{
			selectClause = selectClause + PGIAppConstants.COMMA + QUOTE_OWNER_FIELD;
			whereClause = ' WHERE CountofQuote__c > 0.0';
		}
		// where condition to get quotes without attachments.
		else if (PGIAppConstants.QUOTES_VIEW_OPTIONS[2].equalsIgnoreCase(this.selectedView))
		{
			selectClause = selectClause + PGIAppConstants.COMMA + QUOTE_OWNER_FIELD;
			whereClause = ' WHERE CountofQuote__c <= 0.0';
		}
		if (this.sortDirection == null)
		{
			this.sortDirection = PGIAppConstants.SORT_DIRECTION_ASC;
		}
		SortingHelper sortingHelper = new SortingHelper(this.sortDirection, this.sortExpression);
		return selectClause 
						+ PGIAppConstants.SPACE
						+ FROM_CLAUSE
						+ whereClause 
						+ sortingHelper.getOrderByClause() 
						+ PGIAppConstants.SPACE 
						+ PGIAppConstants.RECORDS_LIMIT_FOR_SET_CONTROLLER;
	}
	
	/**
	 * Creates list of view options available on the page.
	 *
	 * @returns list of view options.
	 */
	private List<Selectoption> getViewOptions()
	{
		List<Selectoption> viewOptions = new List<Selectoption>();
		PGIAppStaticResources staticResources = PGIAppStaticResources.getInstance();
		for (Integer i = 0; i < PGIAppConstants.QUOTES_VIEW_OPTIONS.size(); i++)
		{
			String viewOption = PGIAppConstants.QUOTES_VIEW_OPTIONS[i];
			if (i == 0)
			{
				viewOptions.add(new Selectoption(viewOption.toUpperCase(), viewOption));
			}
			else if (staticResources.attachmentViewProfiles.containsKey(Userinfo.getProfileId()))
			{
				viewOptions.add(new Selectoption(viewOption.toUpperCase(), viewOption));
			}
		}
		return viewOptions;
	}

	/**
	 * Returns the first page of records.
	 */
 	public void first() 
 	{
 		this.setController.first();
 	}
 
	/**
	 * Returns the last page of records.
	 */
 	public void last() 
 	{
 		this.setController.last();
 	}
 
	/**
	 * Returns the previous page of records.
	 */
 	public void previous() 
 	{
 		this.setController.previous();
 	}
 
	/**
	 * Returns the next page of records.
	 */
 	public void next() 
 	{
 		this.setController.next();
 	}
}