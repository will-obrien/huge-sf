public with sharing class Handler_Account extends Handler {
    
    public class HandlerAccountException extends Exception {}
    
    private List<Account> newList;
    private Map<Id,Account> newMap;
    private List<Account> oldList;
    private Map<Id,Account> oldMap;
    private Map<Id,Contact> relatedContactMap;
    private static Map<Id, Lead_Sources__c> leadSourceMap {get; set;} 
    
    public static Boolean BYPASS = false;
    public static Boolean BYPASSPROCESSOR = false;
    public static Boolean BYPASSMERGE = false;
    public static Boolean BEFOREFIRED = false;
    public static Boolean AFTERFIRED = false;
    public static Boolean ALLOW_WEBCHARTING_UPDATE = false;

    
    public Handler_Account() {
    }
    
    public Handler_Account(String typeOfHandler) {
        handlerType = typeOfHandler;
    }
    
    public override void mainEntry(String triggerObject,
        Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate,
        Boolean isDelete, Boolean isUndelete, Boolean isExecuting, List<SObject> newList,
        Map<Id,SObject> newMap, List<SObject> oldList, Map<Id,SObject> oldMap)
    {
        system.debug(LoggingLevel.ERROR, '@@@@ Main Entry: ' + triggerObject);
        system.debug(LoggingLevel.ERROR, '@@@@ BYPASSMERGE: ' + Handler_Account.BYPASSMERGE);
        system.debug(LoggingLevel.ERROR, '@@@@ BYPASS: ' + Handler_Account.BYPASS);
        system.debug(LoggingLevel.ERROR, '@@@@ BEFOREFIRED: ' + Handler_Account.BEFOREFIRED);
        system.debug(LoggingLevel.ERROR, '@@@@ AFTERFIRED: ' + Handler_Account.AFTERFIRED);
        system.debug(LoggingLevel.ERROR, '@@@@ ALLOW_WEBCHARTING_UPDATE: ' + Handler_Account.ALLOW_WEBCHARTING_UPDATE);
        
        try {
            this.newList = (List<Account>)newList;
            this.newMap = (Map<Id,Account>)newMap;
            this.oldList = (List<Account>)oldList;
            this.oldMap = (Map<Id, Account>)oldMap;
            
            if(!Handler_Account.BYPASSMERGE) {
                System.debug(LoggingLevel.ERROR,'Primary Logic Firing: ' + triggerObject);
                if (isBefore && !Handler_Account.BEFOREFIRED) {
                	System.debug(LoggingLevel.ERROR, '@@@@ IS BEFORE and NOT BEFOREFIRED passed...');
                   if (!Handler_Account.BYPASS) {
                   		System.debug(LoggingLevel.ERROR,'@@@@ BYPASS PASSED...');  
                        if (isInsert) {
                            setAccountCountryList(this.newList);
                            CyclicalNumberManager.generateValue(this.newList, 100);
                            CreateEnrollment.onInsert(newList);
                        }
                        else if (isUpdate) {
                        	System.debug(LoggingLevel.ERROR,'@@@@ IS UPDATE...'); 
                            // stamp the lead source
                            System.debug(LoggingLevel.ERROR, '@@@@ stamping lead source BEFORE UPDATE...');
                            LeadSourceStamper stamper = new LeadSourceStamper();
                            stamper.stampLeadSources(this.newMap);
                            // set the account country list
                            System.debug(LoggingLevel.ERROR, '@@@@ setting account country BEFORE UPDATE...');
                            setAccountCountryList(this.newList);
                            // piggyback trigger no validation
                            System.debug(LoggingLevel.ERROR, '@@@@ piggyback no validation BEFORE UPDATE...');
                            piggyBackTriggerNoVal(this.newList,this.oldMap);
                            // stamp webinar data
                            System.debug(LoggingLevel.ERROR, '@@@@ stamping webinar data BEFORE UPDATE...');
                            AccountStamper.stampWebinarData(this.newMap);
                            // refresh the call log fields
                            System.debug(LoggingLevel.ERROR, '@@@@ call logging BEFORE UPDATE...');
                            CallLogger.refreshAccountCallLogFields(this.newMap);
                            if(!Handler_Account.BYPASSPROCESSOR){
                            //paridiso changes added by aac 5.12.15
                                CreateEnrollment.onUpdate((Map<Id, Account>)newMap, (Map<Id, Account>)oldMap);
                            }
                        }
                   }
                   System.debug(LoggingLevel.ERROR, '@@@@ setting Handler_Account.BEFOREFIRED to TRUE'); 
                   Handler_Account.BEFOREFIRED = true;
                }
                else if (isAfter) {  // && !Handler_Account.AFTERFIRED) {
                	
                	if (!Handler_Account.AFTERFIRED) {	
	                	/* if(isUpdate || isInsert){
	                        if(!System.isBatch() && !System.isFuture()){
	                           //AccountMerger mergeAccounts = new AccountMerger(this.newMap.keyset());
	                           //Database.executeBatch(mergeAccounts);
	                           AccountMerger.mergeaccountasynch(this.newMap.keyset());
	                        }else{
	                            if(!Handler_Account.BYPASSMERGE){
	                                AccountMerger.mergeAccounts(newList); 
	                            }
	                        }
	                    } */
	                    
	                    if (isUpdate) {
	                        piggyBackTrigger(this.newList);
	                        //if(!Handler_Account.BYPASSPROCESSOR) {
	                        //  CreateEnrollment.onUpdate((Map<Id, Account>)newMap, (Map<Id, Account>)oldMap);
	                        //}
				System.debug(LoggingLevel.ERROR,'@@@@ calling SharedLoginToQueue...');
	                        SharedLoginToQueue.queueCallouts(this.oldMap ,this.newMap );
	                    }
	                    else if (isDelete) {
	                        // delete lead source records associated with the account(s) being deleted
	                        System.debug(LoggingLevel.ERROR, '@@@ attempting to delete lead sources...');
	                        Set<Id> acctIds = new Set<Id>(); 
	                        
	                        for (Account acct : this.oldMap.values()) {
	                            acctIds.add(acct.Id);
	                        }
	                        
	                        List<Id> tempList = new List<Id>();
	                        tempList.addAll(acctIds);
	                        
	                        System.debug(LoggingLevel.ERROR, '@@@ account id to query for lead sources: ' + tempList[0]);
	                        leadSourceMap = new Map<Id, Lead_Sources__c>([SELECT Id, Name from Lead_Sources__c where Account__c in :acctIds]);
	                        deleteLeadSources();
	                    }
	                    System.debug(LoggingLevel.ERROR, '@@@@ setting Handler_Account.AFTERFIRED to TRUE');
	                    Handler_Account.AFTERFIRED = true;
                	}
                	
                	if (Handler_Account.ALLOW_WEBCHARTING_UPDATE) {
                		SharedLoginToQueue.queueCallouts(this.oldMap, this.newMap);
                		System.debug(LoggingLevel.ERROR, '@@@@ setting Handler_Account.ALLOW_WEBCHARTING_UPDATE to FALSE');
                		Handler_Account.ALLOW_WEBCHARTING_UPDATE = false;
                	}
                }                
                
                TriggerDispatcher.activeHandler = null;
          }
        }
        catch(Exception ex) {
            Logger logger = new Logger('Account Handler');
            logger.log(ex.getMessage());
            logger.log(ex.getStackTraceString());
            logger.emailDebugResults(new List<String>{'sfdev@markettraders.com'});
        }
    }
    
    
    public override void inProgressEntry(String triggerObject,
        Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate,
        Boolean isDelete, Boolean isUndelete, Boolean isExecuting, List<SObject> newList,
        Map<Id,SObject> newMap, List<SObject> oldList, Map<Id,SObject> oldMap)
    {
      system.debug(LoggingLevel.ERROR, '@@@@ In Progress Entry: ' + triggerObject);
    }
    
    
    private static void setAccountCountryList(List<Account> accounts) {
        Set<String> countryNames = new Set<String>();
        
        for (Account a : accounts) {
            if (a.Country_List__c != null) {
                countryNames.add(a.Country_List__c );
            }
        }
    
        Map<String, Country_List_Reference__c> validCountries = new Map<String, Country_List_Reference__c>();
        List<Country_List_Reference__c> countryListReferences = [SELECT Id, Name, MTI_Region__c, Country__c FROM Country_List_Reference__c WHERE Name IN :countryNames];
        
        for ( Country_List_Reference__c countryListReference :  countryListReferences) {
            validCountries.put( countryListReference.Name,countryListReference);
        }
    
        for (Account a : accounts) {
            if (a.Country_List__c != null ) { 
                if (validCountries.containsKey(a.Country_List__c)) { 
                    a.Region__c = validCountries.get(a.Country_List__c).MTI_Region__c;
                    a.Country_List__c = validCountries.get(a.Country_List__c).Country__c;
                }
                else { 
                    a.Region__c = '(UNKNOWN COUNTRY LIST ENTRY)';
                }
            }
            else { 
                a.Region__c = '(COUNTRY LIST IS EMPTY)';
            }
        }
    }
    
    
    private void piggyBackTriggerNoVal(List<Account> newList,Map<Id,Account> oldMap) {
        for (Account a :newList) {  
            Account oldVal = oldMap.get(a.Id);
            
            if (a.Opp_Closed_Won_Val_Bypass__c == true) {
              a.Opp_Closed_Won_Val_Bypass2__c = true;
            }
            else if (PiggybackTriggerManager.PBOppFromAccountCheck != true) {
              a.Opp_Closed_Won_Val_Bypass__c = true;
            }
        }
    }
    
    
    private void piggyBackTrigger(List<Account> newList) {
        try {
            Account[] acctsInTriggerSet = new List<Account>();
            Opportunity[] opptysToUpdate= new List<Opportunity>();
            
            for (Account a :newList) {  
                acctsInTriggerSet.add(a);
            }
    
            if (PiggybackTriggerManager.PBOppFromAccountCheck == true) {
                //Do nothing, the calculation is done
            }
            else {
                for (Opportunity o : [SELECT id, Name FROM Opportunity WHERE Accountid IN :acctsInTriggerSet FOR UPDATE]) {
                    opptysToUpdate.add(o); 
                } 
                update opptysToUpdate;
            }
        }
        catch(Exception ex) {
            Logger logger = new Logger();
            logger.log(ex.getMessage());
            logger.log(ex.getStackTraceString());
            logger.emailDebugResults(new List<String>{'sfdev@markettraders.com'});
        }
    }

    
    private static void deleteLeadSources() {
        if ((leadSourceMap != null) && (leadSourceMap.size() > 0)) {
            try {
                delete leadSourceMap.values();
            }
            catch (Exception ex) {
                throw new HandlerAccountException('Unable to delete lead sources during account deletion.');
            }
        }
    }
}