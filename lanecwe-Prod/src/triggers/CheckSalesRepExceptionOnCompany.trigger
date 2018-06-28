/*********************************************************************
Name : CheckSalesRepExceptionOnCompany 
Created On : dec 30, 2011  
Created By : Lalit Bohra
Description : Trigger on Company for updating the company TESLA_SALESREP_EXCEPTION__c when we done have any match in user via TESLA_SALESMANAGER_ID__c.
Task :T-20272
**********************************************************************/
trigger CheckSalesRepExceptionOnCompany on Company__c (before insert, before update) {
	//Identified that the trigger Enable/Disabled by User in custom setting 'Trigger Settings'
	// getting the PGI ntegration User Id for updating the lead.LeadSource when ever record is being inserted by PGI ntegration User.
    Id PGIntegrationUserId;
    PGIAppStaticResources staticResources = PGIAppStaticResources.getInstance();
    if (staticResources.pgiIntegrationUser != null)
    {
    	PGIntegrationUserId = staticResources.pgiIntegrationUser.Id;
    }
	if(test.isRunningTest() || PGIntegrationUserId != null && UserInfo.GetUserId() ==PGIntegrationUserId){ 
    	//Identified that the trigger Enable/Disabled by User in custom setting 'Trigger Settings'
	    Boolean isInActiveTrigger = false;
	    // query form Custom setting
	    for(Trigger_Settings__c ts : [Select InactivateCheckSalesRepExceptionOnComp__c From Trigger_Settings__c]){
	        // Set settting into veriable
	        isInActiveTrigger = ts.InactivateCheckSalesRepExceptionOnComp__c;
	    }
	   // system.debug('---------isInActiveTrigger----------------'+isInActiveTrigger);
		//  is trigger execute?
		if(isInActiveTrigger == false){
		    set<String> CompanySalesRepEmailSet = new set<String>();
		    boolean RunTrigger=false;
		    list<User> UserList=null;
		    map<String,Id> UserMap= new map<String,Id>();
		    for(Company__c objComp:trigger.new){
		        // storing all the Company TESLA_SALESMANAGER_ID__c in set for fetching all the users 
		        if(objComp.TESLA_SALESMANAGER_ID__c != null && objComp.TESLA_SALESMANAGER_ID__c !=''){
		            CompanySalesRepEmailSet.add(objComp.TESLA_SALESMANAGER_ID__c);
		        }
		    }
		    if(CompanySalesRepEmailSet != null && CompanySalesRepEmailSet.size()>0){
		            UserList = [Select id,TESLA_SALESMANAGER_ID__c from User where TESLA_SALESMANAGER_ID__c  in:CompanySalesRepEmailSet];
		            for(User user:UserList){
		                // creating a user map where TESLA_SALESMANAGER_ID__c is key and value is user id.
		                if(!UserMap.ContainsKey(user.TESLA_SALESMANAGER_ID__c)){
		                    UserMap.put(user.TESLA_SALESMANAGER_ID__c,user.Id);
		                }   
		            }
		    }
		    for(Company__c objComp:trigger.new){
		        // if no user exists with sales manager id then we will check the flag SALESREP_EXCEPTION =true
		        if(!UserMap.ContainsKey(objComp.TESLA_SALESMANAGER_ID__c)){
		          //  system.debug('------------- updting the exception flag=true');
		            objComp.TESLA_SALESREP_EXCEPTION__c =true;
		        }
		        else{
		            objComp.TESLA_SALESREP_EXCEPTION__c =false;
		        }
		    }
		}
	}
}