/*******************************************************************
 * Extension controller for the "Search Before Create" recipe.
 * Executes a search for leads matching criteria and contains flags
 * to indicate if the create button should be displayed.
 *******************************************************************/
public with sharing class SearchLeadsExt 
{
	// The leads matching the search criteria
	public List<Lead> results { get; set;}
	
	// The lead containing the search criteria
	public Lead searchLead {get; set;}
	
	// The email address search criteria - stored in a string
	// to allow fragments to be entered
	public String email {get; set;}
	
	// Has a search been executed?
	public Boolean executed {get; set;}
	
	// Constructor
	public SearchLeadsExt(ApexPages.StandardController std)
	{
		searchLead=new Lead();
		executed=false;
	}
	
	// Indicates if there were any matches for the search
	public Boolean getMatches()
	{
		return ( (null!=results) && (0!=results.size()) );
	}
	
	// Action method to search for leads based on the user entered criteria 
	public PageReference executeSearch()
	{
		// clear the old results, if any
		if (null!=results)
		{
			results.clear();
		}
		
		// construct the where clause based on the user's inputs
		String whereStr='';
		if (!String.IsBlank(searchLead.FirstName))
		{
			String wcFName='%' + searchLead.FirstName + '%';
			whereStr+=' OR FirstName LIKE \'' + wcFName + '\'';
		}
		
		if (!String.IsBlank(searchLead.LastName))
		{
			String wcLName='%' + searchLead.LastName + '%';
			whereStr+=' OR LastName LIKE \'' + wcLName + '\'';
		}
		
		if (!String.IsBlank(searchLead.Company))
		{
			String wcComp='%' + searchLead.Company + '%';
			whereStr+=' OR Company LIKE \'' + wcComp + '\'';
		}
		
		if (!String.IsBlank(email))
		{
			String wcEmail='%' + email + '%';
			whereStr+=' OR Email LIKE \'' + wcEmail + '\'';
		}
		
		// only execute a search if criteria were supplued
		if (''!=whereStr)
		{
			String queryStr='select Id, FirstName, LastName, Company, Email from Lead where ' + whereStr.substring(4);
			results=Database.query(queryStr);
			
			executed=true;
		}
		else
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter the search criteria'));
		}
		
		return null;
	}
	
	// Action method to create a new lead - populates fields on the
	// lead record based on their HTML element IDs.  Note that this
	// is not supported by Salesforce.com
	public PageReference createNew()
	{
    	PageReference pr=new PageReference('/00Q/e');
    	pr.getParameters().put('nooverride', '1');
    	
    	if (!String.IsBlank(searchLead.FirstName))
    	{
    		pr.getParameters().put('name_firstlea2', searchLead.FirstName);
    	}
    	
    	if (!String.IsBlank(searchLead.LastName))
    	{
    		pr.getParameters().put('name_lastlea2', searchLead.LastName);
    	}
    	
    	if (!String.IsBlank(searchLead.Company))
    	{
    		pr.getParameters().put('lea3', searchLead.Company);
    	}
    	
    	if (!String.IsBlank(email))
    	{
    		pr.getParameters().put('lea11', email);
    	}
    	
    	return pr;
    }
}