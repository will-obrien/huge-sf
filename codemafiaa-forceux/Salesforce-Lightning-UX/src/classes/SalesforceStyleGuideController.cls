public with sharing class SalesforceStyleGuideController 
{
	public Lightning_Form__c form {get;set;}
	public List<SelectOption> options {get;set;}
	
	
	public SalesforceStyleGuideController()
	{
		form = new Lightning_Form__c();
		
		options = new List<SelectOption>();
        
		Schema.DescribeFieldResult fieldResult = Lightning_Form__c.Known_For__c.getDescribe();
		
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		        
	    for( Schema.PicklistEntry f : ple)
	    {
	        options.add(new SelectOption(f.getLabel(), f.getValue()));
	    }      
	}
	
	public void save()
	{
		insert form;
	}
	
	public void reset()
	{
		form = new Lightning_Form__c();
	}
}