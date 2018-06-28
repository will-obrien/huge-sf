/*******************************************************************
 * Custom controller for the "Storing the User's Location" recipe. 
 * Captures a lead and the user's geolocation coordinates via a 
 * JavaScript remote action 
 *******************************************************************/
public with sharing class MobileLeadLocationCaptureController 
{
	// the remote action to capture the lead into Salesforce
	@RemoteAction
	public static String CreateLead(String fName, String lName, String inCompany, String inEmail, String inPhone,
									Double latitude, Double longitude)
    {
    	Lead newLead=new Lead(FirstName=fName,
    						  LastName=lName,
    						  Company=inCompany,
    						  Email=inEmail,
    						  Phone=inPhone);
    						  
    	if (null!=latitude)
    	{
    		newLead.Location__Latitude__s=latitude;
    		newLead.Location__Longitude__s=longitude;
    	}
    	
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