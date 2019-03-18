/*******************************************************************
 * Custom controller for the "Mobile Visualforce Forms" recipe. 
 * Captures a lead via a JavaScript remote action 
 *******************************************************************/
public with sharing class MobileLeadCaptureController 
{
	
	// the remote action to capture the lead into Salesforce
	@RemoteAction
	public static String CreateLead(String fName, String lName, String inCompany, String inEmail, String inPhone)
    {
    	Lead newLead=new Lead(FirstName=fName,
    						  LastName=lName,
    						  Company=inCompany,
    						  Email=inEmail,
    						  Phone=inPhone);
    	
    	String result='SUCCESS';
    	
    	try
    	{					  
    		insert newLead;
    	}
    	catch (Exception e)
    	{
    		result=e.getMessage();
    	}
    	
    	return result;
    }
    
}