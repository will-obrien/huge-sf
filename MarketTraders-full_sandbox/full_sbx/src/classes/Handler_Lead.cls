public with sharing class Handler_Lead extends Handler {
    
    public class HandlerLeadException extends Exception {}
    
    
    private List<Lead> newList;
    private Map<Id,Lead> newMap;
    private List<Lead> oldList;
    private Map<Id,Lead> oldMap;
    private static Map<Id, Lead_Sources__c> leadSrcMap {get; set;} 
    
    public static boolean BYPASS = false;
    public static Boolean BEFOREFIRED = false;
    public static Boolean AFTERFIRED = false;

    
    /**
    *   constructor
    */
    public Handler_Lead() {
    }
    
    public Handler_Lead(String typeOfHandler) {
        handlerType = typeOfHandler;
    }
    
    
    /**
    *   main entry point method, used in dispatcher architecture
    */
    public override void mainEntry(String triggerObject,
        Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate,
        Boolean isDelete, Boolean isUndelete, Boolean isExecuting, List<SObject> newList,
        Map<Id,SObject> newMap, List<SObject> oldList, Map<Id,SObject> oldMap)
    {

        System.debug('@asha: @debug: isBefore: '+isBefore+' Beforefired:'+Handler_Lead.BEFOREFIRED+' isAfter: '+isAfter+ ' AfterFired:'+Handler_Lead.AFTERFIRED);
        this.newList = (List<Lead>)newList;
        this.newMap = (Map<Id,Lead>)newMap;
        this.oldList = (List<Lead>)oldList;
        this.oldMap = (Map<Id,Lead>)oldMap;
            
        if (isBefore && !Handler_Lead.BEFOREFIRED) {
            // for lead source deletion
            leadSrcMap = new Map<Id, Lead_Sources__c>();
            
            if (isInsert) {
                setLeadOwnerName(this.newList);
                setLeadCountryList(this.newList);
                CyclicalNumberManager.generateValue(this.newList, 100);
            }
            
            if (isUpdate) {
                setLeadOwnerName(this.newList);
                setLeadCountryList(this.newList);
                Handler_Lead.syncLeadSourceData(this.newList);
                LeadSourceStamper stamper = new LeadSourceStamper();
                stamper.stampLeadSources(this.newMap);
            }
            
            if (isDelete) {
                Set<Id> leadIds = new Set<Id>(); 
                for (Lead ld : this.oldMap.values()) {
                    leadIds.add(ld.Id);
                }
                
                leadSrcMap = new Map<Id, Lead_Sources__c>([SELECT Id, Name from Lead_Sources__c where Lead__c in :leadIds]);
            }
            
            Handler_Lead.BEFOREFIRED = true;
        }
        else if (isAfter && !Handler_Lead.AFTERFIRED) {
        List<id> listleadids = new List<Id>();
            if (isInsert || isUpdate) {
                //  commenting this out prevents a lead source from being created
                Handler_Lead.syncLeadSourceData(this.newList);               
                // only dedupe if 1 lead being processed
                  System.debug('@asha: @debug: Handler_Lead - Lead size: ' + newList.size());
                if (this.newList.size() == 1) {
                    Map<Id, Lead> dupeMap = getDupeMap(this.newList);                  
                    if (!dupeMap.isEmpty()) {
                     System.debug('@asha: @debug: Handler_Lead - starting lead merger: Merging Lead ' + newList[0]);
                     
                    // Set<ID> leadsreturnfromMerge = LeadMerger.mergeLead(this.newList[0], dupeMap.get(this.newList[0].Id));
                     //listleadids.addAll(leadsreturnfromMerge); 
                     LeadMerger.mergeLead(this.newList[0], dupeMap.get(this.newList[0].Id));                    
                     System.debug('@asha: @debug: Handler_Lead - lead merger complete'); 

                    }
                }               
    
                   listleadids.addAll(newMap.keyset()); 
          
                  // if(!Handler_Lead.BYPASS){
                       //LeadAutoConverter.convertLead(listleadids);
                     //  System.debug('@asha: @debug: Handler_Lead - completed lead auto conversion');
                  // }
           }
            
            if (isUpdate) {
                Map<Id, Id> convertedLeadMap = new Map<Id, Id>();
                for(Lead lead : this.newList) {
                    if (lead.IsConverted) {
                       convertedLeadMap.put(lead.Id, lead.ConvertedAccountId);
                    }
                }
                    
                if (!convertedLeadMap.isEmpty()) {
                    LeadConversionAugmenter augmenter = new LeadConversionAugmenter(convertedLeadMap);
                    augmenter.tranferReferrals();
                    augmenter.tranferLeadSources();
                    augmenter.tranferWebinarAttendances();
                }
            }
            else if (isDelete) {
                deleteLeadSources();
            }
            
           
            Handler_Lead.AFTERFIRED = true;
        }
        System.debug('@asha: @debug: Ending Handler_Lead ');
        TriggerDispatcher.activeHandler = null;
        Handler_Lead.AFTERFIRED = false;
        Handler_Lead.BEFOREFIRED = false;
    }
    
    
    /**
    *   in progress entry point method, used in dispatcher architecture
    */
    public override void inProgressEntry(String triggerObject,
        Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate,
        Boolean isDelete, Boolean isUndelete, Boolean isExecuting, List<SObject> newList,
        Map<Id,SObject> newMap, List<SObject> oldList, Map<Id,SObject> oldMap)
    {
        system.debug('In Progress Entry: ' + triggerObject);

        if (triggerObject == 'Lead' && isBefore && isUpdate) {
     
             System.debug('@asha: @debug: Handler_Lead - Sync Lead Source Data Started');  

             Handler_Lead.syncLeadSourceData((List<Lead>)newList);
             System.debug('@asha: @debug: Handler_Lead - Sync Lead Source Data Completed - Starting LeadSource Stamper');

             LeadSourceStamper stamper = new LeadSourceStamper();
             stamper.stampLeadSources((Map<Id, Lead>)newMap);
             System.debug('@asha: @debug: Handler_Lead - Lead Source Stamper Completed');
        }
        // new
        else if ((triggerObject.equals('Lead Source')) && isAfter && isUpdate) {
            LeadSourceStamper stamper = new LeadSourceStamper();
            stamper.stampLeadSources((List<Lead_Sources__c>)newList, false);
        }
        
        // end new
    }
    
    /**
    *   @author Jim Hutcherson
    *   @date June 23 2014
    *   @description This method provides a 1 to 1 map with the current context leads and the master they will be merged to if one exists.
    */
    @TestVisible
    private String generateRandomString() {
        Integer len = 8;
        String password;
        while (password == null || password.isNumeric()) {
            Blob blobKey = crypto.generateAesKey(128);
            String key = EncodingUtil.convertToHex(blobKey);
            password = key.substring(0, len);
        }
        System.debug('************ ' + password);
        return password;
    }
    
    /**
    *   @author Jim Hutcherson
    *   @date May 19 2014
    *   @description This method provides a 1 to 1 map with the current context leads and the master they will be merged to if one exists.
    */
    public static Map<Id,Lead> getDupeMap(List<Lead> leads) {

        Logger logger = new Logger('getdupemap');
        // collect unique emails and alternate emails in a set
        Set<String> emails = new Set<String>();
        for (Lead lead: leads) {
            if (lead.Email != null)
            {
                emails.add(lead.Email.toLowerCase());
            }
            
            if (lead.Alternate_Email__c != null) {
                emails.add(lead.Alternate_Email__c.toLowerCase());
            }   
        }

        List<Lead> possibleDuplicateLeads = [SELECT Id, CreatedDate, Email, Alternate_Email__c, FirstName, LastName/*, Lead_Total_Calls__c*/
                                                FROM Lead 
                                                WHERE (Email IN :emails OR Alternate_Email__c IN :emails) 
                                                AND isConverted = false 
                                                AND isDeleted = false 
                                                ORDER BY CreatedDate ASC];
                                              

        Map<String,Lead> oldestLeadByEmail = new Map<String,Lead>();
        for (Lead possibleDuplicateLead : possibleDuplicateLeads) {
            if (possibleDuplicateLead.Email != null && oldestLeadByEmail.get(possibleDuplicateLead.Email.toLowerCase()) == null) {
                oldestLeadByEmail.put(possibleDuplicateLead.Email.toLowerCase(), possibleDuplicateLead);
            }
            
            if (possibleDuplicateLead.Alternate_Email__c != null && oldestLeadByEmail.get(possibleDuplicateLead.Alternate_Email__c.toLowerCase()) == null) {
                oldestLeadByEmail.put(possibleDuplicateLead.Alternate_Email__c.toLowerCase(), possibleDuplicateLead);
            }
        }

        Map<Id, Lead> dupeMap = new Map<Id, Lead>();
        /*for (Lead lead : possibleDuplicateLeads) { //instead of doing just the leads activated by trigger do all dups
            Lead masterLeadByEmail = null;
            Lead masterLeadByAlternateEmail= null;
            if (lead.Email != null) {
                masterLeadByEmail = oldestLeadByEmail.get(lead.Email.toLowerCase());
            }
            
            if (lead.Alternate_Email__c != null) {
                masterLeadByAlternateEmail = oldestLeadByEmail.get(lead.Alternate_Email__c.toLowerCase());
            }
            
            if (masterLeadByEmail != null && masterLeadByAlternateEmail != null && masterLeadByEmail.Id !=masterLeadByAlternateEmail.Id) {
                if (masterLeadByEmail.CreatedDate < masterLeadByAlternateEmail.CreatedDate) {
                    if (lead.Id != masterLeadByEmail.Id) {
                        dupeMap.put(lead.Id,masterLeadByEmail);
                    }
                }
                else {
                    if (lead.Id != masterLeadByAlternateEmail.Id) {
                        dupeMap.put(lead.Id,masterLeadByAlternateEmail);
                    }
                }
            }
            else if (masterLeadByEmail != null) {
                if (lead.Id != masterLeadByEmail.Id) {
                    dupeMap.put(lead.Id,masterLeadByEmail);
                }
            }
            else if (masterLeadByAlternateEmail != null) {
                if (lead.Id != masterLeadByAlternateEmail.Id) {
                    dupeMap.put(lead.Id,masterLeadByAlternateEmail);
                }
            }
        }*/
        
        
          for(Integer i = 0; i < possibleDuplicateLeads.size() ; i++){
            Lead CurrentLead =  possibleDuplicateLeads[possibleDuplicateLeads.size() - (i+1)];
            Lead masterLeadByEmail = null;
            Lead masterLeadByAlternateEmail= null;  
            
            if(CurrentLead.Email != null && CurrentLead.Alternate_Email__c != null){ 
                        masterLeadByEmail = oldestLeadByEmail.get(CurrentLead.Email);
                        masterLeadByAlternateEmail = oldestLeadByEmail.get(CurrentLead.Alternate_Email__c);
                        masterLeadByEmail = masterLeadByEmail.CreatedDate <= masterLeadByAlternateEmail.CreatedDate ? masterLeadByEmail : masterLeadByAlternateEmail;
            }else{
               masterLeadByEmail = (CurrentLead.Email != null) ? oldestLeadByEmail.get(CurrentLead.Email) : null;
               masterLeadByAlternateEmail = (CurrentLead.Alternate_Email__c != null) ? oldestLeadByEmail.get(CurrentLead.Alternate_Email__c) : null;
               masterLeadByEmail = (masterLeadByEmail != null) ? masterLeadByEmail : masterLeadByAlternateEmail;            
           } 
            
            if(masterLeadByEmail != null){
             dupeMap.put(CurrentLead.Id,masterLeadByEmail);
            }   
        }  
        logger.emailDebugResults(new List<String>{'sfdev@markettraders.com'});
        return dupeMap;
    }
    
    
    /**
    *   @author Jim Hutcherson
    *   @date 2014
    *   @description Ported over from a trigger.
    *
    */
    private static void setLeadOwnerName(List<Lead> leads) {
        try{
            Set<Id> ownerIds = new Set<Id>();
            for (Lead lead : leads) {
                ownerIds.add(lead.OwnerId);
            }
            Map<Id, User> userMap = new Map<Id,User>([SELECT Id, Name FROM User WHERE Id in :ownerIds]);
            for (Lead lead : leads) {
                lead.Owner_Name__c = userMap.get(lead.OwnerId).Name;
            }
        }
        catch(Exception ex) {
            system.debug(ex);
        }
    }
    
    
    /**
    *   @author Jim Hutcherson
    *   @date 2014
    *   @description Ported over from a trigger.
    *
    */
    private static void setLeadCountryList(List<Lead> leads) {
        Set<String> countryNames = new Set<String>();
        for (Lead l : leads) {
            if ( l.CountryList__c != null) {
                countryNames.add(l.CountryList__c);
            }
        }
    
        Map<String, Country_List_Reference__c> validCountries = new Map<String, Country_List_Reference__c>();
        List<Country_List_Reference__c> countryListReferences = [SELECT Id, Name, MTI_Region__c, Country__c FROM Country_List_Reference__c WHERE Name IN :countryNames];
        
        for (Country_List_Reference__c countryListReference : countryListReferences) {
            validCountries.put(countryListReference.Name, countryListReference);
        }
    
        for (Lead l : leads) {
            if (l.CountryList__c != null) { 
                if (validCountries.containsKey(l.CountryList__c)) { 
                    l.Region__c = validCountries.get(l.CountryList__c).MTI_Region__c;
                    l.CountryList__c = validCountries.get(l.CountryList__c).Country__c;
                }
                else { 
                    l.Region__c = '(UNKNOWN COUNTRY LIST ENTRY)';
                }
            }
            else { 
                l.Region__c = '(COUNTRY LIST IS EMPTY)';
            }
        }
    }
  
    
    
    /**
     * @author Jim Hutcherson
     * @date May 13 2014
     * @description synchronizes the lead source fields with the lead source records during inserts and updates
     *
     * @param newList List<Lead>
     **/
    public static void syncLeadSourceData(List<Lead> leads) {
        Set<Id> leadIds = new Set<Id>();
        for (Lead lead : leads) {
            if (lead.Id != null && lead.IsConverted == false) {
                leadIds.add(lead.Id);
            }
        }
        
        Map<Id,Set<String>> leadSourceMap = new Map<Id,Set<String>>();
        if (leadIds != null) {
            List<Lead_Sources__c> updatingLeadSources = [SELECT Id, Lead__c, Lead_Source__c, Lead_Source_Date__c, Lead_Source_Detail__c 
                                                            FROM Lead_Sources__c 
                                                            WHERE Lead__c IN :leadIds];
                                                            
            for (Lead_Sources__c leadSource : updatingLeadSources) {
                if (leadSourceMap.get(leadSource.Lead__c) == null) {
                    leadSourceMap.put(leadSource.Lead__c,new Set<String>());
                }
                
                leadSourceMap.get(leadSource.Lead__c).add(String.valueOf(leadSource.Lead_Source_Date__c) + '-' + leadSource.Lead_Source__c + '-' + leadSource.Lead_Source_Detail__c);
            }
        }
        
        List<Lead_Sources__c> leadSourcesToInsert = new List<Lead_Sources__c>();
        for (Lead lead : leads) {
            if (lead.IsConverted == false) {
                LeadSourcePlaceHolder placeHolder = new LeadSourcePlaceHolder(lead);
                Set<String> leadSources = leadSourceMap.get(lead.Id);
                if (leadSources == null) {
                    leadSources = new Set<String>();
                }
                
                if (placeHolder.getCurrentPlaceHolderKey() != null) {
                    if (!leadSources.contains(placeHolder.getCurrentPlaceHolderKey()) && placeHolder.leadSource != null && placeHolder.leadSource != '') {
                        Lead_Sources__c leadSource = new Lead_Sources__c();
                        leadSource.Lead__c = lead.Id;
                        leadSource.Lead_Source__c = placeHolder.leadSource;
                        leadSource.Lead_Source_Date__c = placeHolder.leadSourceDate;
                        leadSource.Lead_Source_Detail__c = placeHolder.leadSourceDetail;
                        leadSource.Offer__c = placeHolder.offer;
                        leadSource.Offer_Type__c = placeHolder.offerType;
                        leadSource.URL__c = placeHolder.url;
                        leadSourcesToInsert.add(leadSource);
                    }
                }
                
                if (placeHolder.getPreviousPlaceHolderKey() != null) {
                    if (!leadSources.contains(placeHolder.getPreviousPlaceHolderKey()) && placeHolder.leadSource != null && placeHolder.leadSource != '') {
                        Lead_Sources__c leadSource = new Lead_Sources__c();
                        leadSource.Lead__c = lead.Id;
                        leadSource.Lead_Source__c = placeHolder.previousLeadSource;
                        leadSource.Lead_Source_Date__c = placeHolder.previousLeadSourceDate;
                        leadSource.Lead_Source_Detail__c = placeHolder.previousLeadSourceDetail;
                        leadSourcesToInsert.add(leadSource);
                    }
                }
            }
        }
        
        if (!leadSourcesToInsert.isEmpty()) {
            System.debug('@asha: @debug: Inserting Lead Sources ');
            Database.insert(leadSourcesToInsert);
            System.debug('@asha: @debug: End Inserting Lead Sources');
        }
    }
    
    private static void deleteLeadSources() {
        if ((leadSrcMap != null) && (leadSrcMap.size() > 0)) {
            try {
                delete leadSrcMap.values();
            }
            catch (Exception ex) {
                throw new HandlerLeadException('Unable to delete lead sources during lead deletion.');
            }
        }
    }
}