//******************************************************************************************
//
//  MS_UpdateInstallKeyOnContractProductChange
//
//  Updates the install key whenever a contract product changes.
//  Calculates the install key based on the currently licenced products.
//  Determined by checking the contract_product__c.product entries for a given account.
//  On delete, if all CPs have been removed, populate a key which indicates no licenced products. 
//  History:
// 3/24/2010    Robb Allen 
// 7/22/2010	Robb Allen - Modified to add logic for French Canadian key generation
// 2/12/2013    Robb Allen - Modified to support Author's Toolkit
// ******************************************************************************************

trigger MS_UpdateInstallKeyOnContractProductChange on Contract_Product__c (before delete, after update, after insert) {
    
    
string CustomerID = '';
string CustomerIndustry = '';
string CustomerCountry = '';
string DocXtools = '4';
string DocID = 'J';
string Metadata = '9';
string Numbering = 'V';
string TOC = 'H';
string CustRegion = '';
string CustIndustry = '';
boolean isFC = False;
//boolean hasAT = False;
boolean hasEssentials = False;
integer i;
    
    
//Only processing on a single insert for now.  Company workflow does not involve importing or mass updating contract products / contracts.
//Can rewrite if requirements change.
    if (trigger.size == 1)
    {

// Have to detemrine if we're in an update vs. a delete, as trigger.new is not valid on a delete.
if (system.trigger.isUpdate || system.trigger.isInsert) {

    
    // Look up account and industry for current contract:contract/product
        contract_product__c Customer = [select contract__r.id, contract__r.account.id, contract__r.account.industry, contract__r.account.BillingCountry from contract_product__c where contract_product__c.id = :trigger.new[0].id];
        CustomerId = customer.contract__r.account.Id;       
        CustomerIndustry = customer.contract__r.account.industry;
        CustomerCountry = customer.contract__r.account.BillingCountry;
        system.debug('customerid=' + CustomerId);
        system.debug('customerindustry=' + CustomerIndustry);
        system.debug('cusotmerCountry=' + CustomerCountry);
        system.debug('contractId=' + customer.contract__r.id);
    // Generate the Region and Industry parts of the install key.  Always need to do this, so no need to be in the loop.
    
    if (CustIndustry == '')
        {
        	if (CustomerCountry != null) 
        	{
                    if (CustomerCountry.contains('USA') || CustomerCountry.contains('United States') || CustomerCountry.contains('Canada')) 
                    {
                    	system.debug('region set to 1033 because customerCountry=usa');
                         CustRegion = '1033';
                    } else 
                    {
                    	system.debug('region set to 2057');
                        CustRegion = '2057';
                    }  
        	} else {
        		system.debug('region set to 1033 as default');
        		CustRegion = '1033';
        	}
        	if (CustomerIndustry != null)
        	{
                    if (CustomerIndustry.contains('Law')) 
                    {
                        CustIndustry = '81';
                    } else if (CustomerIndustry.contains('Life'))
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
    
    

        
        
    // Loop through all of the contract products for the given account and build the install key.   
            for (contract_product__c cp : [select contract__r.name, product__c from contract_product__c where contract__r.enddate > today and product__c != 'services' and contract__r.account.id = :CustomerId]) { 
    system.debug('contractproduct=' + cp.product__c);
    system.debug('contract name = ' + cp.contract__r.name);
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
							}
							  else if (cp.product__c.contains('Express'))
            				{
            					hasEssentials = True;
							}
                
    // End contract product loop
        }
        system.debug('just ended contract product loop');
        
        
      
       	system.debug('just checked for atk and no docx');
       	// Check to see if they are Life Sciences industry and have DocXtools.  If so, give them "P"
       	  	if (DocXtools == 'Q' && CustIndustry == '28')
       	{
       		DocXtools = 'P';
       		Numbering = '7';
       		Toc = '3';
       	}
       	system.debug('just checked for LS and DocX');
       	// Check to see if they have DocXssentials - if so, rejigger the key as that comes with all modules.
       	if (hasEssentials == True)
       	{
       		DocXtools = 'Q';
       		DocID = 'T';
       		Numbering = '7';
       		TOC = '3';
       	}
          system.debug('just checked for essentials');
    // Perform the update on the account with the built install key
        system.debug('getting ready to update the account with the install key');
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
	          	if (isFC == true) {
        				licRecord.Microsystems_FC_Install_key__c = '3084-' + CustIndustry + '-' + DocXtools + DocID + Metadata + Numbering + TOC;
        			}
        			
	          	insert licRecord;
	          	
	          }
    
    //end update  or insert trigger processing  
    } else  {
        
       
    //This is the before delete trigger 
        
    contract_product__c Customer = [select contract__r.account.id, contract__r.account.industry, contract__r.account.BillingCountry from contract_product__c where contract_product__c.id = :trigger.old[0].id];
    String CustomerId2 = customer.contract__r.account.id;
    String CustomerIndustry2 = Customer.contract__r.account.industry;
    String CustomerCountry2 = Customer.contract__r.account.BillingCountry;
  
    
try  {
	

    
    // Generate the Region and Industry parts of the install key.  Always need to do this, so no need to be in the loop.
            if (CustIndustry == '')
        {
        	if (CustomerCountry2 != null) 
        	{
                    if (CustomerCountry2.contains('USA') || CustomerCountry2.contains('United States') || CustomerCountry2.contains('Canada')) 
                    {
                         CustRegion = '1033';
                    } else 
                    {
                        CustRegion = '2057';
                    }  
        	} else {
        		CustRegion = '1033';
        	}
        	if (CustomerIndustry2 != null)
        	{
                    if (CustomerIndustry2.contains('Law')) 
                    {
                        CustIndustry = '81';
                    } else if (CustomerIndustry2.contains('Life'))
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
    
// Loop through all of the contract products for the given account and build the install key.   
                
            for (contract_product__c cp : [select product__c, contract__r.account.industry from contract_product__c where contract__r.enddate > today and product__c != 'services' and contract__r.account.id = :CustomerId2 and contract_product__c.id != :trigger.old[0].id]) { 
            
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
							}
							 else if (cp.product__c.contains('Express'))
            				{
            					hasEssentials = True;
							}
    //end loop of contract products for given account
    }              
    
    
        
          
    	 // Check to see if they are Life Sciences industry and have DocXtools.  If so, give them "P"
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
     
 
 
        Integer licCount = [select count() from LicenseKeyInformation__c WHERE Linked_Account__c = :CustomerID2];
	          if ( licCount > 0 ) {
        			LicenseKeyInformation__c licRecord = [select Id from LicenseKeyInformation__c where Linked_Account__c = :CustomerID2 limit 1];
        			licRecord.Microsystems_Install_Key__c = CustRegion + '-' + CustIndustry + '-' + DocXtools + DocID + Metadata + Numbering + TOC;
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
	          	licRecord.Linked_Account__c = CustomerId2;
	          	if (isFC == True) {
        				licRecord.Microsystems_FC_Install_key__c = '3084-' + CustIndustry + '-' + DocXtools + DocID + Metadata + Numbering + TOC;
        			} else if (isFC == false)
        			{
        				licRecord.Microsystems_FC_Install_key__c = '';
        			}
	          	insert licRecord;
	          	
	          }
  
} catch (System.NullPointerException np) {
}


    //end if update / delete trigger
    }
    // end check to ensure we're only dealing with a single record
    }       
    // end function
}