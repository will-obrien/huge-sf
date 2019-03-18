trigger MS_UpdateAccountLastUpdateField on Account (before insert, before update) {
   
  // Set flag to detect if we need to update the last updated field for a new account
    
    string currentUser = UserInfo.getUserId();
    
    
    for (integer idx = 0; idx< trigger.new.size(); idx++)
    {
    	
    
    
    if (system.trigger.isUpdate)
    {
    
    	// Compare the specified account fields (account at a glance) to see if they have changed  
    	// if so, update the last updated field date and by fields.
 		if (trigger.new[idx].Customer_Since_Date__c != trigger.old[idx].Customer_since_date__c 
    		 
    		 
    		 || trigger.new[idx].DocXtools_Version__c    != trigger.old[idx].DocXtools_Version__c
			 || trigger.new[idx].DocXtools_Users_Deployed__c    != trigger.old[idx].DocXtools_Users_Deployed__c    		    
			 || trigger.new[idx].DocXtools_Users_Licensed__c    != trigger.old[idx].DocXtools_Users_Licensed__c
			 || trigger.new[idx].DocXtools_Upgrade_Plans__c    != trigger.old[idx].DocXtools_Upgrade_Plans__c
			 || trigger.new[idx].DocXtools_Deployment_Status__c    != trigger.old[idx].DocXtools_Deployment_Status__c
    		 || trigger.new[idx].DocXtools_Included_on_Desktop_Image__c    != trigger.old[idx].DocXtools_Included_on_Desktop_Image__c 
    		 || trigger.new[idx].DocXtools_Deployed_Groups_NEW__c    != trigger.old[idx].DocXtools_Deployed_Groups_NEW__c 
    		 || trigger.new[idx].DocXtools_Groups_Getting_High_Value__c    != trigger.old[idx].DocXtools_Groups_Getting_High_Value__c 
    		 || trigger.new[idx].Skills_Assessment_Deployed_NEW__c    != trigger.old[idx].Skills_Assessment_Deployed_NEW__c 
    		 || trigger.new[idx].Comparison_Deployed__c != trigger.old[idx].Comparison_Deployed__c
    		 || trigger.new[idx].MIAFD_Configured__c != trigger.old[idx].MIAFD_Configured__c
    		 || trigger.new[idx].Numbering_TOC_Deployed__C != trigger.old[idx].Numbering_TOC_Deployed__C
    		 || trigger.new[idx].Date_Last_Met_with_the_IT_Project_Team__c != trigger.old[idx].Date_Last_Met_with_the_IT_Project_Team__c
    		 || trigger.new[idx].Date_Last_Met_with_Contract_Signer__c != trigger.old[idx].Date_Last_Met_with_Contract_Signer__c
    		 || trigger.new[idx].X3BClean_Upgrade_Plans__c != trigger.old[idx].X3BClean_Upgrade_Plans__c
    		 || trigger.new[idx].DocXtools_Upgrade_Plans__c != trigger.old[idx].DocXtools_Upgrade_Plans__c
    		 || trigger.new[idx].EagleEye_Upgrade_Plans__c != trigger.old[idx].EagleEye_Upgrade_Plans__c
    		 || trigger.new[idx].EagleEye_Users_Deployed__c != trigger.old[idx].EagleEye_Users_Deployed__c
    		 || trigger.new[idx].EagleEye_Users_Licensed__c != trigger.old[idx].EagleEye_Users_Licensed__c
    		 || trigger.new[idx].EagleEye_Version_Deployed__c != trigger.old[idx].EagleEye_Version_Deployed__c
    		 || trigger.new[idx].AccountNumber != trigger.old[idx].AccountNumber
    		 || trigger.new[idx].Traffic_Signal_Deployed__c != trigger.old[idx].Traffic_Signal_Deployed__c
    		 || trigger.new[idx].Cross_References_Configured__c != trigger.old[idx].Cross_References_Configured__c
    		 || trigger.new[idx].DOCID_Deployed__c != trigger.old[idx].DOCID_Deployed__c
    		 || trigger.new[idx].DocXtools_French_Canadian_Deployed__c != trigger.old[idx].DocXtools_French_Canadian_Deployed__c
    		 || trigger.new[idx].X3BClean_Des__c != trigger.old[idx].X3BClean_Des__c
    		 || trigger.new[idx].X3BClean_Version_Deployed__c != trigger.old[idx].X3BClean_Version_Deployed__c
    		 || trigger.new[idx].reference__c != trigger.old[idx].reference__c
    		 || trigger.new[idx].Number_of_Cases_in_90_Days__c != trigger.old[idx].Number_of_Cases_in_90_Days__c
			 || trigger.new[idx].Negative_Resolution_Cases_Last_90_Days__c != trigger.old[idx].Negative_Resolution_Cases_Last_90_Days__c
    		 || trigger.new[idx].Patent_Companion_Users_Deployed__c != trigger.old[idx].Patent_Companion_Users_Deployed__c
    		 || trigger.new[idx].Patent_Companion_Users_Licensed__c != trigger.old[idx].Patent_Companion_Users_Licensed__c)
    		 
    		
    	
    		  
    		  {
    
    			//Update the account last updated field because one of the above was true		
    			trigger.new[idx].at_a_glance_last_updated__c = date.today();
    			trigger.new[idx].MS_AtAGlanceLastUpdatedByUser__c = currentuser;
    		 }
    		 
    		 
    	//Now, check the Account Environment fields.  If any have changed, update the appropriate
    	//last edit by and date fields.
    	 if (trigger.new[idx].Primary_Operating_Systems__c != trigger.old[idx].Primary_Operating_Systems__c 
    		 || trigger.new[idx].PrimaryWordProc__c != trigger.old[idx].PrimaryWordProc__c
    		 || trigger.new[idx].Email_System__c    != trigger.old[idx].Email_System__c 
    		 || trigger.new[idx].DMS__c    != trigger.old[idx].DMS__c
    		 || trigger.new[idx].DMS_Front_End_Profiling__c    != trigger.old[idx].DMS_Front_End_Profiling__c
    		 || trigger.new[idx].Templates__c    != trigger.old[idx].Templates__c 
    		 || trigger.new[idx].Numbering_Tool__c    != trigger.old[idx].Numbering_Tool__c 
    		 || trigger.new[idx].Outsourced_Document_Production_Vendor__c    != trigger.old[idx].Outsourced_Document_Production_Vendor__c
    		 || trigger.new[idx].MetaData_Tool__c    != trigger.old[idx].MetaData_Tool__c 
    		 || trigger.new[idx].Compare_Tool__c    != trigger.old[idx].Compare_Tool__c 
    		 || trigger.new[idx].TOA_Tool__c    != trigger.old[idx].TOA_Tool__c 
    		 || trigger.new[idx].X02007_Migration_Plan__c    != trigger.old[idx].X02007_Migration_Plan__c 
    		 || trigger.new[idx].Next_Office_Version__c    != trigger.old[idx].Next_Office_Version__c
    		 || trigger.new[idx].Date_for_2010__c    != trigger.old[idx].Date_for_2010__c
    		 || trigger.new[idx].Agreement_Checker__c    != trigger.old[idx].Agreement_Checker__c 
    		 || trigger.new[idx].Date_for_Office_2015__c    != trigger.old[idx].Date_for_Office_2015__c 
    		 || trigger.new[idx].X2013_Plans__c    != trigger.old[idx].X2013_Plans__c 
    		 || trigger.new[idx].Date_for_Word_2013__c    != trigger.old[idx].Date_for_Word_2013__c    
    		 )
    		  
    		
    		  
    		  
    		  
    		  
    		  
    		  
    		  
    		  {
    
    				//Update the account last updated field because one of the above was true		
				    trigger.new[idx].last_updated__c = date.today();
    				trigger.new[idx].MSAccountEnvironmentLast_Updated_By__c = currentuser;
    		  }
    		 
    // If this is a new account, only fill in the last update field if one the 
    //specified account at a glance fields are not null    
    } else 
    	{
    		
    		if (trigger.new[idx].Customer_Since_Date__c != null
  		  	 ||	trigger.new[idx].DocXtools_Version__c    != null
			 || trigger.new[idx].DocXtools_Users_Deployed__c    != null 		    
			 || trigger.new[idx].DocXtools_Users_Licensed__c    != null
			 || trigger.new[idx].DocXtools_Upgrade_Plans__c    != null
			 || trigger.new[idx].DocXtools_Deployment_Status__c    != '--none--'
    		 || trigger.new[idx].DocXtools_Included_on_Desktop_Image__c    != 'No'
    		 || trigger.new[idx].DocXtools_Deployed_Groups_NEW__c    != null 
    		 || trigger.new[idx].DocXtools_Groups_Getting_High_Value__c    != null 
    		 || trigger.new[idx].Skills_Assessment_Deployed_NEW__c    != 'Unknown' 
    		 || trigger.new[idx].Comparison_Deployed__c != null
    		 || trigger.new[idx].MIAFD_Configured__c != null
    		 || trigger.new[idx].Numbering_TOC_Deployed__C != null
    		 || trigger.new[idx].Date_Last_Met_with_the_IT_Project_Team__c != null
    		 || trigger.new[idx].Date_Last_Met_with_Contract_Signer__c != null
    		 || trigger.new[idx].X3BClean_Upgrade_Plans__c != null
    		 || trigger.new[idx].DocXtools_Upgrade_Plans__c != null
    		 || trigger.new[idx].EagleEye_Upgrade_Plans__c != null
    		 || trigger.new[idx].EagleEye_Users_Deployed__c != null
    		 || trigger.new[idx].EagleEye_Users_Licensed__c != null
    		 || trigger.new[idx].EagleEye_Version_Deployed__c != null
    		 || trigger.new[idx].Traffic_Signal_Deployed__c != '--none--'
    		 || trigger.new[idx].Cross_References_Configured__c != null
    		 || trigger.new[idx].DOCID_Deployed__c != null
    		 || trigger.new[idx].DocXtools_French_Canadian_Deployed__c != null
    		 || trigger.new[idx].X3BClean_Des__c != null
    		 || trigger.new[idx].X3BClean_Version_Deployed__c != null
    		 || trigger.new[idx].reference__c != null
    		 || trigger.new[idx].Number_of_Cases_in_90_Days__c != null
			 || trigger.new[idx].Negative_Resolution_Cases_Last_90_Days__c != null
    		 || trigger.new[idx].Patent_Companion_Users_Deployed__c != null
    		 || trigger.new[idx].Patent_Companion_Users_Licensed__c != null)
    		
    			{
    				
    				system.debug('just finished checking all fields for insert - going to update field');
    				
    				//fieldUpdated = true;
    	 			trigger.new[idx].MS_AtAGlanceLastUpdatedByUser__c = currentuser;
        			trigger.new[idx].at_a_glance_last_updated__c = date.today();
    			}
   
	 		//Check the account environment fields on new account creation.
	 		//If any of the monitored fields have been udpated, set the last 
	 		//modified by and date fields. 		
			  if (trigger.new[idx].Primary_Operating_Systems__c != null 
    		 || trigger.new[idx].PrimaryWordProc__c != null
    		 || trigger.new[idx].Email_System__c    != null 
    		 || trigger.new[idx].DMS__c    != null
    		 || trigger.new[idx].DMS_Front_End_Profiling__c    != false
    		 || trigger.new[idx].Templates__c    != null 
    		 || trigger.new[idx].Numbering_Tool__c    != null 
    		 || trigger.new[idx].Outsourced_Document_Production_Vendor__c    != null
    		 || trigger.new[idx].MetaData_Tool__c    != null 
    		 || trigger.new[idx].Compare_Tool__c    != null 
    		 || trigger.new[idx].TOA_Tool__c    != null 
    		 || trigger.new[idx].X02007_Migration_Plan__c    != null 
    		 || trigger.new[idx].Next_Office_Version__c    != null
    		 || trigger.new[idx].Date_for_2010__c    != null
    		 || trigger.new[idx].Agreement_Checker__c    != null 
    		 || trigger.new[idx].Date_for_Office_2015__c    != null 
    		 || trigger.new[idx].X2013_Plans__c    != null 
    		 || trigger.new[idx].Date_for_Word_2013__c    != null    
    		 )
  				
  				
    				{
    					system.debug(trigger.new[idx].DMS_Front_End_Profiling__c);
	        			trigger.new[idx].MSAccountEnvironmentLast_Updated_By__c = currentuser;
        				trigger.new[idx].last_updated__c = date.today();
					}
     
     
    		} //End actions for new case    
    		      	
    } //End bulk safe loop
	}