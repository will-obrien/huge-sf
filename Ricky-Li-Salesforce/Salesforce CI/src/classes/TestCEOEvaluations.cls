@isTest(SeeAllData=true)
Public Class TestCEOEvaluations{
    static testmethod void TestEvaluations(){
    	
    	User ceo = [SELECT Id From User Where FirstName='Con' and LastName='Yam' limit 1];
    	Account t = new Account(LastName = 'TestAccountName', Salutation='Mr.');
        //Insert the object virtually
        insert t;  
		
		System.runAs(ceo){      	
	        //Create a new instance of standard controller
	        ApexPages.StandardController sc = new ApexPages.standardController(t);
	
	        CEOEvaluations controller = new CEOEvaluations(sc);
	        
	        controller.getInitialTELSet();
	        
	        controller.Previous();
	        controller.Next();
	        
	        // The following code runs as user 'u' 
	      	System.debug('Current User: ' + UserInfo.getUserName());
	      	System.debug('Current Profile: ' + UserInfo.getProfileId());
   		}

    }
}