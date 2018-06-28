trigger MS_UpdateInstallKeyOnContractEndDateChange on Contract (after update) {

//Also updates / clears the Patent Companion checkbox on the account if there are no active PC contracts

if (trigger.size == 1)
	{
		
string CustomerID = '';
string DocXtools = '4';
string DocID = 'J';
string Metadata = '9';
string Numbering = 'V';
string TOC = 'H';
string CustRegion = '';
string CustIndustry = '';
integer i;
boolean isFC = False;
boolean hasAT = False;
boolean hasEssentials = False;
boolean hasPatentCompanion = False;


CustomerId = trigger.new[0].AccountId;
account A2 = [select industry, BillingCountry, Patent_Companion__c from account where id = :CustomerId];
String AccountIndustry = a2.industry;
string AccountCountry = a2.BillingCountry;


		if ((trigger.new[0].EndDate != trigger.old[0].endDate) || (trigger.new[0].Status != trigger.old[0].Status))  
			{
		
			Integer CPCount = [select count() from contract_product__c where contract__r.enddate > today and product__c != 'services' and contract__r.account.id = :CustomerId];
				if (CPCount > 0) 
					{
			
			
				for (contract_product__c cp : [select product__c, contract__r.account.industry, contract__r.account.BillingCountry from contract_product__c where contract__r.enddate > today and product__c != 'services' and contract__r.account.id = :CustomerId]) {
system.debug('product is');				 
system.debug(cp.product__c);
					if (CustRegion == '') 
						{
				
						if (cp.contract__r.account.BillingCountry != null)
						{
								if (cp.contract__r.account.BillingCountry.contains('USA') || cp.contract__r.account.BillingCountry.contains('United States') || cp.contract__r.account.BillingCountry.contains('Canada')) 
									{
						 		 	CustRegion = '1033';
									} else 
				 					{
				  					CustRegion = '2057';
				    				}  
					   	} else {
					   		CustRegion = '1033';
					   	}
						}
				if (Custindustry == '') 
					  {	
					  	
					  	if (cp.contract__r.account.industry != null)
					  	{
							if (cp.contract__r.account.industry.contains('Law')) 
								{
				 					CustIndustry = '81';
								} else if (cp.contract__r.account.industry.contains('Life'))
								{
			  						CustIndustry = '28';
								}  else {
									//set to "other" if not law or life
									CustIndustry = '00';
								}
					  	} else {
					  		CustIndustry = '00';
					  	}
					  		
					}
			
						if (cp.product__c == 'Knowledge Partnership' || cp.product__c == 'DocXtools')
							{
								DocXtools = 'Q';
							} else if (cp.product__c == 'TOC') 
							{
								TOC = '3';			
							} else if (cp.product__c == 'Numbering')
							{
								Numbering = '7';
							} else if (cp.product__c == 'DocID')
							{
								DocID = 'T';
							} else if (cp.product__c == 'Metadata' || cp.product__c =='Metadata Module: Server' || cp.product__c =='3BClean Server')
							{
								Metadata = 'J';
							} else if (cp.product__c == 'Metadata Module: Desktop' || cp.product__c== '3BClean Desktop')
							{
								Metadata = 'Z';
							} else if (cp.product__c == 'Metadata Module: Desktop with Mobile' || cp.product__c=='3BClean Desktop with Mobile')
							{
								Metadata = 'R';	
							} else if (cp.product__c == 'K2 DocXssentials')
							{
								DocXtools = 'K';	
							} else if (cp.product__c == 'French Canadian')
							{
								isFC = True;
							} else if (cp.product__c.contains('Express'))
            				{
            					hasEssentials = True;
							} else if (cp.product__c == 'Patent Companion')
							{
							 hasPatentCompanion = True;
							}
			
			// end contract product loop
		}
		
		      // Check to see if they licensed only Author's Toolkit and not DocX. If so, set the first install key position to be "A".
       if (DocXtools == '4' && hasAT==True)
        {
          	DocXtools = 'A';
          	Numbering = '7';
       		Toc = '3';
       	}
       	
       	if (DocXtools == 'Q' && CustIndustry == '28')
       	{
       		DocXtools = 'P';
       		Numbering = '7';
       		Toc = '3';
       	}
          
		           	// Check to see if they have DocXssentials - if so, rejigger the key as that comes with all modules.
       	if (hasEssentials == True)
       	{
       		DocXtools = 'Q';
       		DocID = 'T';
       		Numbering = '7';
       		TOC = '3';
       	}
		system.debug('checking PC checkbox.');
		system.debug(hasPatentCompanion);
		a2.Patent_Companion__c = hasPatentCompanion;
		update a2;
		
		 Integer licCount = [select count() from LicenseKeyInformation__c WHERE Linked_Account__c = :CustomerID];
	          if ( licCount > 0 ) {
        			LicenseKeyInformation__c licRecord = [select Id from LicenseKeyInformation__c where Linked_Account__c = :CustomerID limit 1];
        			licRecord.Microsystems_Install_Key__c = CustRegion + '-' + CustIndustry + '-' + DocXtools + DocID + Metadata + Numbering + TOC;
        			
        			//If isFC = true, then update the FC key as well.
        			if (isFC == True) {
        				licRecord.Microsystems_FC_Install_key__c = '3084-' + CustIndustry + '-' + DocXtools + DocID + Metadata + Numbering + TOC;
        			}else if (isFC == false)
        			{
        				licRecord.Microsystems_FC_Install_key__c = '';
        			}
        			update licRecord;
	          }
	          else{
	          	
	          	LicenseKeyInformation__c licRecord = new LicenseKeyInformation__C(); 
	          	licRecord.Microsystems_Install_Key__c = CustRegion + '-' + CustIndustry + '-' + DocXtools + DocID + Metadata + Numbering + TOC;
	          	licRecord.Linked_Account__c = CustomerId;
	          	
        			//If isFC = true, then update the FC key as well.
        			if (isFC == True) {
        				licRecord.Microsystems_FC_Install_key__c = '3084-' + CustIndustry + '-' + DocXtools + DocID + Metadata + Numbering + TOC;
        			}else if (isFC == false)
        			{
        				licRecord.Microsystems_FC_Install_key__c = '';
        			}
	          	insert licRecord;
	          	
	          }
					}else
					// no more contracts, so have to fall back to a key with nothing installed.
						{
							
					system.debug('checking PC checkbox.');
					system.debug(hasPatentCompanion);
					a2.Patent_Companion__c = hasPatentCompanion;
					update a2;
							
					if (CustRegion == '') 
				{
					if (AccountCountry != null)
					{
					if (AccountCountry.contains('USA') || AccountCountry.contains('United States') || AccountCountry.contains('Canada')) 
					{
				 		 CustRegion = '1033';
					} else 
					{
				  		CustRegion = '2057';
					 }
					} else {
						CustRegion = '1033';
					}  
				}
				
			if (Custindustry == '') 
			{	
				if (AccountIndustry != null)
				{
					if (AccountIndustry.contains('Law')) 
					{
				 		CustIndustry = '81';
					} else if (AccountIndustry.contains('Life'))
					{
			  			CustIndustry = '28';
					}  else {
						//set to "other" if not law or life
						CustIndustry = '00';
					}
				} else {
					CustIndustry = '00';
				}
			}
					
				 Integer licCount = [select count() from LicenseKeyInformation__c WHERE Linked_Account__c = :CustomerID];
	          if ( licCount > 0 ) {
        			LicenseKeyInformation__c licRecord = [select Id from LicenseKeyInformation__c where Linked_Account__c = :CustomerID limit 1];
        			licRecord.Microsystems_Install_Key__c = CustRegion + '-' + CustIndustry + '-' + DocXtools + DocID + Metadata + Numbering + TOC;
        			//licRecord.X3BClean_License_Key_Account__c = CustomerId;
        			//If isFC = true, then update the FC key as well.
        			if (isFC == True) {
        				licRecord.Microsystems_FC_Install_key__c = '3084-' + CustIndustry + '-' + DocXtools + DocID + Metadata + Numbering + TOC;
        			}else if (isFC == false)
        			{
        				licRecord.Microsystems_FC_Install_key__c = '';
        			}
        			update licRecord;
	          }
	          else{
	          	
	          	LicenseKeyInformation__c licRecord = new LicenseKeyInformation__C(); 
	          	licRecord.Microsystems_Install_Key__c = CustRegion + '-' + CustIndustry + '-' + DocXtools + DocID + Metadata + Numbering + TOC;
	          	licRecord.Linked_Account__c = CustomerId;
	          	
        			//If isFC = true, then update the FC key as well.
        			if (isFC == True) {
        				licRecord.Microsystems_FC_Install_key__c = '3084-' + CustIndustry + '-' + DocXtools + DocID + Metadata + Numbering + TOC;
        			}else if (isFC == false)
        			{
        				licRecord.Microsystems_FC_Install_key__c = '';
        			}
	          	insert licRecord;
	          	
	          }
				}	
					
						
			}
			

	}




}