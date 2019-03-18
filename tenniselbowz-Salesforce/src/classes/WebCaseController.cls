/***********************************************************************
 Author       :   Nathan Shinn
 Created Date :   December 26,2013
 Description  :   Controller for  WebCase and WebCaseConfirmation Pages
************************************************************************/
public without sharing class WebCaseController {
	
	public Case webCase{get;set;}
	public Asset asset{get;set;}
	public string FirstName{get;set;}
	public string LastName{get;set;}
	public string serialNumber{get;set;}
	public Integer searched{get;set;}
	public boolean showSuccessMessage{get;set;}
	
	//constructor
	public WebCaseController()
	{
		webCase = new Case(Origin='Web');//default values?
		asset = new Asset();
		searched = 0;
		showSuccessMessage = false;
	}
	
	//Used to submit the case
	public PageReference save()
	{
		//Save the case and Case_Asset Records
		try
		{
			// look for an associated contact with the same email
			Integer cnt = 0;
			for(Contact con : [select Id, AccountId 
			                     from Contact 
			                    where Email = :webCase.SuppliedEmail])
			{
				webCase.ContactId = con.Id;
				cnt ++;
			}
			
			//remove the contact association if more than one contact is found
			if(cnt > 1) webCase.ContactId = null;
			
			// Specify DML options to ensure the assignment rules are executed
			Database.DMLOptions dmlOpts = new Database.DMLOptions();
			dmlOpts.assignmentRuleHeader.useDefaultRule = true;
			dmlOpts.EmailHeader.triggerAutoResponseEmail = true;
		    webCase.setOptions(dmlOpts);
		    
		    //get the case record type based on the asset TRC group
		    for(RecordType rt : [Select Id from RecordType where SOBjectType = 'Case' and name = :asset.Product2.TRC_Group__c ])
		       webCase.RecordTypeId = rt.Id;
		    
		    //get the default when a matching record type can't be found   
		    if(webCase.RecordTypeId == null)
		       webCase.RecordTypeId = Default_Case_RecordType__c.getInstance().RecordTypeId__c;
			
			webCase.Origin = 'Web';
			
			webCase.Case_Details__c = webCase.Description;
			webCase.SuppliedName = webCase.Web_FirstName__c + ' '+ webCase.Web_LastName__c;
			insert webCase;
			
			//create the case asset record
		    Case_Asset__c ca = new Case_Asset__c(Case__c=webCase.Id, Asset__c=asset.Id);
		    insert ca;
		    
		    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'RecordType: '+ [Select RecordType.Name, Origin from Case where Id = :webCase.Id].RecordType.Name));
		}
		catch(Exception e)
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
			return null;
		}
		
		//redirect to the confirmation page
		
		return clearCase();//Page.WebCaseConfirmation;
	}
	
	//Search by Serial Number
	public PageReference searchAsset()
	{
		//lookup the asset by serial number
		searched = 1;
		showSuccessMessage = false;
		for(Asset a : [Select Id, Product2.ProductCode, Product2.Name, SerialNumber, Product2.TRC_Group__c 
		                 from Asset 
		                where SerialNumber = :serialNumber
		                  and SerialNumber != null])
		{
			asset = a;
			return null;//set the asset and return
		}
		
		//reconstruct an empty asset record
		asset = new Asset(SerialNumber=asset.SerialNumber);
		return null;
	}
	
	//used to clear the case values
	public PageReference clearCase()
	{
		//create new instances of the case and asset records to reinitialize
		showSuccessMessage = true;
		webCase = new Case();
		asset = new Asset();
		searched=0;
		serialNumber = '';
		
		return null;
	}
	
	public pageReference cancel()
	{
		PageReference p = Page.WebCase;
		p.setRedirect(true);
		
		return p;
	}

}