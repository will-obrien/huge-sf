/**********************************************************************************************************************
*	Market Traders Institute, Inc.    CONFIDENTIAL
* ---------------------------------------------------------------------------------------------------------------------
*	[2015] Market Traders Institute
*	All Rights Reserved
*
*	NOTICE:  All information contained herein is, and remains the property of Market Traders Institute, Inc. and its
*	suppliers, if any.  The intellectual and technical concepts contained herein are proprietary to Market Traders 
*	Institute, Inc. and its suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are 
*	protected by trade secret or copyright law.  Dissemination of this information or reproduction of this material
*	is strictly forbidden unless prior written permission is obtained from Market Traders Institute, Inc.
*
*	Date Created:		4/13/2015
*	Author:				Asha Calderon
*	Last Modified:		5/6/2015
*	Last Modified By:	Asha Calderon
*
*   
*   
**********************************************************************************************************************/

/**********************************
	@description:
	Used in connection with the Handler_Lead class 
	to auto convert incoming leads to accounts.

***********************************/
public class LeadAutoConverter{


	/**********************
	* @method: convertLead 
	* @params: 
	*  lead_IDs = list of lead ids passed in from handler_lead
	*
	**********/
	@future
	public static void convertLead(List<ID> lead_IDs){
		        Boolean log = false;
		        Logger logger = new Logger('ERROR: LEAD AUTO-CONVERTER');
	            //query the leads from the ids
	            List<Lead> leadsInserted = [Select id, email, Alternate_Email__c, createddate, isconverted from Lead where id in: lead_IDs and isconverted = false];
	            //find accounts
	            Map<ID,ID> mapleadToAccount = new Map<ID,ID>();
                mapleadToAccount = findAccountToConvert(leadsInserted);
				System.debug('@asha: @debug: LeadAutoConverter - created map of lead to account, size: '+ mapleadtoAccount.size());
                Set<ID> leadIDs = mapleadToAccount.keySet();
                LeadStatus convertStatus = [
                      select MasterLabel
                      from LeadStatus
                      where IsConverted = true
                      limit 1
                 ];
                //add leads to list to convert 
                list<Database.LeadConvert> listofleadconversions = new list<Database.LeadConvert>();

                System.debug('@asha: @debug: LeadAutoConverter - list of leadids , size: '+ leadIDs.size());
                for(ID leadID : leadIDs){
                    if(leadID != null){
                    
                        Database.LeadConvert lc = new Database.LeadConvert();
                        lc.setLeadId(leadID);
                        lc.setConvertedStatus(convertStatus.MasterLabel);
                        if(mapleadToAccount.get(leadID) != null){
                            lc.setAccountID(mapleadToAccount.get(leadID));
                        }
                        lc.setDoNotCreateOpportunity(true);
                        listofleadconversions.add(lc);
                    }
                }
                Handler_Lead.BYPASS = true;
                Handler_Account.BYPASS = true;
                if(!listofleadconversions.isEmpty()){
                	System.debug('@asha: @debug: LeadAutoConverter - Starting Conversions');
			  		try{
	                    list<Database.LeadConvertResult> lcr = Database.convertLead(listofleadconversions);             
	                	System.debug('@asha: @debug: LeadAutoConverter - Conversion complete');   
	                    for(Database.LeadConvertResult result : lcr){                         
	                        if(!result.isSuccess()){  
	                            log = true;
	                            logger.log('Error converting Lead ID: '+ result.getLeadId()+'<br/>' );                       
	                            for(Database.Error error : result.getErrors()){
	                                logger.log(error.getMessage());
	                            }
	                        }
	                    }
                	}catch(Exception e){    
                   	 system.debug(e);
                	}  
                } 

                Handler_Account.BYPASS = false;
                Handler_Lead.BYPASS = false;
                //if errors send errors via email
                if(log){
                     logger.emailDebugResults(new List<String>{'sfdev@markettraders.com'});
                }   
	}

	/***************************************
	*    @method: findAccountToConvert
	*    @description:    
	*    added to handle lead autoconversion
	*    sends map of lead id to acct ids to asynchronous method LeadAutoConverter convertLead   
	*    handle account de-duplications
	*    @params: 
	*    leadsInserted = list of leads
	*    @return:
	*    Map<id,id> = returns a map of lead ids (key) to account ids 
	*    
	**********************************************/
    public static Map<ID,ID> findAccountToConvert(List<Lead> leadsInserted){

        Map<ID,ID> mapLeadToAcct = new Map<ID,ID>();
        Set<Lead> leadsToConvert = new Set<lead>();
        if(leadsInserted != null && leadsInserted.size() > 0){
	            List<String> emailsfromLeads = new List<String>();
	            for(Lead ld: leadsInserted){
	                //add email to list of emails 
	                  if(ld.Email != null){
	                     emailsfromLeads.add(ld.Email);
	                     leadsToConvert.add(ld);   
	                  }
	                  
	                  if(ld.Alternate_Email__c != null){
	                      emailsfromLeads.add(ld.Alternate_Email__c);     
	                      leadsToConvert.add(ld);   
	                  }
	            }  
	
	            if(leadsToConvert.size() > 0){  
		              //query accts with same email address as the lead
		              List<Account> listofAccounts = [Select id, PersonEmail, Alternate_Email__c, createddate  from Account where (PersonEmail in: emailsfromLeads OR Alternate_Email__c in: emailsfromLeads) ORDER BY CreatedDate ASC];   
		                
	               	  Map<String,Account>  mapEmailToAcct = new Map<String,Account>();
	
	                  if(listofAccounts.size() > 0){                 
	                       //iterate through accts add to map emails
	                      for(Account a: listofAccounts){ 
		                        if(!mapEmailToAcct.containskey(a.PersonEmail)){
		                            mapEmailToAcct.put(a.PersonEmail,a);
		                        }
		                        if(!mapEmailToAcct.containskey(a.Alternate_Email__c)){
		                            mapEmailToAcct.put(a.Alternate_Email__c,a);
		                        }       
	                      }
	                   } 
	                   
	                   for(Lead ld : leadsToConvert){
	                          Account primaryacct = null;
	                          if(!String.isblank(ld.Email) && !String.isblank(ld.Alternate_Email__c)){
	                              primaryacct = (mapEmailToAcct.containskey(ld.Email)) ? mapEmailToAcct.get(ld.Email) : null;
	                              Account alternateacct = (mapEmailToAcct.containskey(ld.Alternate_Email__c)) ? mapEmailToAcct.get(ld.Alternate_Email__c) : null;                             
	                              
	                              if(primaryacct != null && alternateacct != null ){
	                                  primaryacct = (primaryacct.createddate < alternateacct.createddate) ? primaryacct : alternateacct ;                             
	                              }else{
	                                  primaryacct = (primaryacct != null) ? primaryacct :alternateacct;
	                              }                           
	                              
	                          }else{                                                            
	                              String lead_email = (!String.isblank(ld.Email)) ? ld.Email : ld.Alternate_Email__c;                              
	                              primaryacct = (mapEmailToAcct.containskey(lead_email)) ? mapEmailToAcct.get(lead_email) : null;
	                          }
	
	                          if(primaryacct != null){
	                             mapLeadToAcct.put(ld.id,primaryacct.id);
	                          }else{
	                              mapLeadToAcct.put(ld.id,null);
	                          }                       
	                  }
	              }
        }  
 
        return mapLeadToAcct ;
    }

}