/**********************************************************************************************************************
*   Market Traders Institute, Inc.    CONFIDENTIAL
* ---------------------------------------------------------------------------------------------------------------------
*   [2015] Market Traders Institute
*   All Rights Reserved
*
*   NOTICE:  All information contained herein is, and remains the property of Market Traders Institute, Inc. and its
*   suppliers, if any.  The intellectual and technical concepts contained herein are proprietary to Market Traders 
*   Institute, Inc. and its suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are 
*   protected by trade secret or copyright law.  Dissemination of this information or reproduction of this material
*   is strictly forbidden unless prior written permission is obtained from Market Traders Institute, Inc.
*
*   Date Created:       4/8/2014
*   Author:             Jim HUtcherson
*   Last Modified:      1/27/2015
*   Last Modified By:   Asha Calderon
*
*   7/31/2015 - Added code to support addition of USC (Ultimate Stock Course), code cleanup & comments
*   11.20.15 - aac added first stamp fields for lead - USOP, Micro & UTP
*   1.27.16 - aac added first stamp fields for account - USOP
*   
**********************************************************************************************************************/

/**
 *  constructor
 */
public with sharing class LeadSourceStamper {
    public Boolean BYPASS = false;
    
    private Date sixtyDaysAgo {get; set;}
    private Map<Id, Account> accountMap {get; set;}
    private Map<Id, Lead> leadMap {get; set;}
    
    public LeadSourceStamper() {
        this.sixtyDaysAgo = Date.today().addDays(-60);
        System.debug('@asha:@debug: LeadSourceStamper: Starting LeadSourceStamper');
    }
    
    
    /**
    *   clears UTP related lead source fields on an account
    */
    public void clearUTPLeadSourceData(Account account) {
        account.First_UTP_Lead_Source__pc = null;
        account.First_UTP_Lead_Source_Detail__pc = null;
        account.First_UTP_Lead_Source_Date__pc = null;
        account.First_UTP_Offer__pc = null;
        account.First_UTP_Offer_Type__pc = null;
        account.First_UTP_IP_Address__pc = null;
        account.First_UTP_URL__pc = null;
        
        account.Curr_UTP_Lead_Source__pc = null;
        account.Curr_UTP_Lead_Source_Detail__pc = null;
        account.Curr_UTP_Lead_Source_Date__pc = null;
        account.Curr_UTP_Offer__pc = null;
        account.Curr_UTP_Offer_Type__pc = null;
        account.Curr_UTP_IP_Address__pc = null;
        account.Curr_UTP_URL__pc = null;
        account.Curr_UTP_Lead_Source_PREV__pc = null;
        account.Curr_UTP_Lead_Source_Detail_PREV__pc = null;
        account.Curr_UTP_Lead_Source_Date_PREV__pc = null;
    }
    
    
    /**
    *   clears UOC related lead source fields on an account
    */
    public void clearUOCLeadSourceData(Account account) {
        account.First_UOC_Lead_Source__pc = null;
        account.First_UOC_Lead_Source_Detail__pc = null;
        account.First_UOC_Lead_Source_Date__pc = null;
        account.First_UOC_Offer__pc = null;
        account.First_UOC_Offer_Type__pc = null;
        account.First_UOC_IP_Address__pc = null;
        account.First_UOC_URL__pc = null;
        
        account.Curr_UOC_Lead_Source__pc = null;
        account.Curr_UOC_Lead_Source_Detail__pc = null;
        account.Curr_UOC_Lead_Source_Date__pc = null;
        account.Curr_UOC_Offer__pc = null;
        account.Curr_UOC_Offer_Type__pc = null;
        account.Curr_UOC_IP_Address__pc = null;
        account.Curr_UOC_URL__pc = null;
        account.Curr_UOC_Lead_Source_PREV__pc = null;
        account.Curr_UOC_Lead_Source_Detail_PREV__pc = null;
        account.Curr_UOC_Lead_Source_Date_PREV__pc = null;
    }
    
    
    /**
    *   clears LMFS related lead source fields on an account
    */
    public void clearLMFSLeadSourceData(Account account) {
        account.First_LMFS_Lead_Source__pc = null;
        account.First_LMFS_Lead_Source_Detail__pc = null;
        account.First_LMFS_Lead_Source_Date__pc = null;
        account.First_LMFS_Offer__pc = null;
        account.First_LMFS_Offer_Type__pc = null;
        account.First_LMFS_URL__pc = null;
        
        account.Curr_LMFS_Lead_Source__pc = null;
        account.Curr_LMFS_Lead_Source_Detail__pc = null;
        account.Curr_LMFS_Lead_Source_Date__pc = null;
        account.Curr_LMFS_Offer__pc = null;
        account.Curr_LMFS_Offer_Type__pc = null;
        account.Curr_LMFS_URL__pc = null;
        account.Curr_LMFS_Lead_Source_PREV__pc = null;
        account.Curr_LMFS_Lead_Source_Detail_PREV__pc = null;
        account.Curr_LMFS_Lead_Source_Date_PREV__pc = null;
        
        account.Last_LMFS_Lead_Source__pc = null;
        account.Last_LMFS_Lead_Source_Detail__pc = null;
        account.Last_LMFS_Lead_Source_Date__pc = null;
        account.Last_LMFS_Offer__pc = null;
        account.Last_LMFS_Offer_Type__pc = null;
        account.Last_LMFS_URL__pc = null;
    }
    
    /**
    *   clears UTP related lead source fields on an account
    */
    public void clearUSCLeadSourceData(Account account) {
        //aac added 1.27.16
        account.First_USOP_Lead_Source__pc = null;
        account.First_USOP_Lead_Source_Date__pc = null;
        account.First_USOP_Lead_Source_Detail__pc = null;
        account.First_USOP_Offer__pc = null;
        account.First_USOP_Offer_Type__pc = null;
        account.First_USOP_Offer_Type__pc = null;
        account.First_USOP_URL__pc = null;
                
        account.Curr_USC_Lead_Source__pc = null;
        account.Curr_USC_Lead_Source_Detail__pc = null; 
        account.Curr_USC_Lead_Source_Date__pc = null;
        account.Curr_USC_Offer__pc = null;
        account.Curr_USC_Offer_Type__pc = null;
        account.Curr_USC_IP_Address__pc = null;
        account.Curr_USC_URL__pc = null;
        account.Curr_USC_Lead_Source_PREV__pc = null;
        account.Curr_USC_Lead_Source_Detail_PREV__pc = null;
        account.Curr_USC_Lead_Source_Date_PREV__pc = null;
    }
    
    
    /**
    *   clears ALL related lead source fields on an account (NOTE: Not ALL Lead source fields, only those labeled with 'ALL')
    */
    public void clearAllLeadSourceData(Account account) {
        account.First_ALL_Lead_Source__pc = null;
        account.First_ALL_Lead_Source_Detail__pc = null;
        account.First_ALL_Lead_Source_Date__pc = null;
        account.First_ALL_Offer__pc = null;
        account.First_ALL_Offer_Type__pc = null;
        account.First_ALL_IP_Address__pc = null;
        account.First_ALL_URL__pc = null;
        
        account.Curr_ALL_Lead_Source__pc = null;
        account.Curr_ALL_Lead_Source_Detail__pc = null;
        account.Curr_ALL_Lead_Source_Date__pc = null;
        account.Curr_ALL_Offer__pc = null;
        account.Curr_ALL_Offer_Type__pc = null;
        account.Curr_ALL_IP_Address__pc = null;
        account.Curr_ALL_URL__pc = null;
        account.Curr_ALL_Lead_Source_PREV__pc = null;
        account.Curr_ALL_Lead_Source_Detail_PREV__pc = null;
        account.Curr_ALL_Lead_Source_Date_PREV__pc = null;
    }
    
    
    /**
    *   clears lead source fields on an lead
    */
    public void clearLeadData(Lead lead) {
        lead.LeadSource = null;
        // UTP
        lead.Lead_Source_UTP__c = null;
        lead.Lead_Source_Detail__c = null;
        lead.Lead_Source_Date__c = null;
        lead.URL__c = null;
        lead.Offer__c = null;
        lead.Offer_Type__c = null;
        lead.Lead_Source_previous__c = null;
        lead.Lead_Source_Detail_previous__c = null;
        lead.Lead_Source_Date_previous__c = null;
    
    //aac 11.20.15  first lead source stamping
        lead.First_UTP_IP_Address__c     = null;
        lead.First_UTP_Lead_Source__c = null;
        lead.First_UTP_Lead_Source_Date__c = null;
        lead.First_UTP_Lead_Source_Detail__c = null;
        lead.First_UTP_Offer__c = null; 
        lead.First_UTP_Offer_Type__c = null;
        lead.First_UTP_URL__c = null;
        
        //USOP
        lead.First_USOP_IP_Address__c = null;   
        lead.First_USOP_Lead_Source__c = null;  
        lead.First_USOP_Lead_Source_Date__c = null; 
        lead.First_USOP_Lead_Source_Detail__c = null;   
        lead.First_USOP_Offer__c = null;         
        lead.First_USOP_Offer_Type__c = null;   
        lead.First_USOP_URL__c = null;  
        
        //Micro
        lead.First_Micro_IP_Address__c = null;  
        lead.First_Micro_Lead_Source__c = null; 
        lead.First_Micro_Lead_Source_Date__c = null;    
        lead.First_Micro_Lead_Source_Detail__c = null;  
        lead.First_Micro_Offer__c = null;   
        lead.First_Micro_Offer_Type__c = null;  
        lead.First_Micro_URL__c = null; 
    //aac 11.20.15  
        // UOC
        lead.Lead_Source_UOC__c = null;
        lead.Lead_Source_Detail_UOC__c = null;
        lead.Lead_Source_Date_UOC__c = null;
        lead.URL_UOC__c = null;
        lead.Offer_UOC__c = null;
        lead.Offer_Type_UOC__c = null;
        lead.Lead_Source_UOC_PREV__c = null;
        lead.Lead_Source_Detail_UOC_PREV__c = null;
        lead.Lead_Source_Date_UOC_PREV__c = null;
        // LMFS     
        lead.Lead_Source_LMFS__c = null;
        lead.Lead_Source_Detail_LMFS__c = null;
        lead.Lead_Source_Date_LMFS__c = null;
        lead.URL_LMFS__c = null;
        lead.Offer_LMFS__c = null;
        lead.Offer_Type_LMFS__c = null;
        lead.Lead_Source_LMFS_PREV__c = null;
        lead.Lead_Source_Detail_LMFS_PREV__c = null;
        lead.Lead_Source_Date_LMFS_PREV__c = null;
        // USOP (previously USC, but repurposed as USOP on 10/5/2015)
        lead.Lead_Source_USC__c = null;
        lead.Lead_Source_Detail_USC__c = null;
        lead.Lead_Source_Date_USC__c = null;
        lead.URL_USC__c = null;
        lead.Offer_USC__c = null;
        lead.Offer_Type_USC__c = null;
        lead.Lead_Source_USC_PREV__c = null;
        lead.Lead_Source_Detail_USC_PREV__c = null;
        lead.Lead_Source_Date_USC_PREV__c = null;       
    }
    
    
    /**
    *   Overloaded version of the method that accepts a lead map.  Stamps original lead source data on account(s).
    */
    public void stampLeadSources(Map<Id, Lead> leadMap) {
        this.leadMap = leadMap;
        this.accountMap = new Map<Id, Account>();
        
        for (Lead lead : leadMap.values()) {
            this.clearLeadData(lead);
        }

        List<Lead_Sources__c> leadsources = [SELECT Id, IP_Address__c, Product__c, Do_Not_Update_Parent__c, Account__c, Lead_Source_Date__c, Lead_Source__c,
                                                Lead_Source_Detail__c, Offer__c,Offer_Type__c, URL__c, Lead__c, Override_Lead_Source_Rules__c 
                                                FROM Lead_Sources__c 
                                                WHERE Lead__c IN :leadMap.keySet() 
                                                ORDER BY Lead_Source_Date__c ASC];
                                                
        for (Lead_Sources__c leadSource : leadsources) {
            if (leadSource.Do_Not_Update_Parent__c == true) {
                continue;
            }
            
            if (leadSource.Product__c.equals('UTP')) {
                this.stampOriginalUTP(leadSource);
            }
            else if (leadSource.Product__c.equals('UOC')) {
                this.stampOriginalUOC(leadSource);
            }
            else if ((leadSource.Product__c.equals('LMFS')) || (leadSource.Product__c.equals('Micro'))) {
                this.stampOriginalLMFS(leadSource);
            }
            else if ((leadSource.Product__c.equals('USC')) || (leadSource.Product__c.equals('USOP'))) {     // modified to handle USC or USOP on 10/5/2015
                this.stampOriginalUSC(leadSource);   // modified to handle USC or USOP on 10/5/2015
            }
        }
    }
    
    
    /**
    *   Overloaded version of the method that accepts an account map.  Clears all lead source fields on account(s) and stamps the account with new values.
    */
    public void stampLeadSources(Map<Id, Account> accountMap) {
        this.accountMap = accountMap;
        
        for (Account account : accountMap.values()) {
            clearUTPLeadSourceData(account);
            clearUOCLeadSourceData(account);
            clearLMFSLeadSourceData(account);
            clearUSCLeadSourceData(account);       // modified to handle USC or USOP on 10/5/2015
            clearALLLeadSourceData(account);
        }
        
        this.leadMap = new Map<Id, Lead>();

        List<Lead_Sources__c> leadsources = [SELECT Id, IP_Address__c, Product__c, Do_Not_Update_Parent__c, Account__c, Lead_Source_Date__c, Lead_Source__c,
                                                Lead_Source_Detail__c, Offer__c, Offer_Type__c, URL__c, Lead__c, Override_Lead_Source_Rules__c
                                                FROM Lead_Sources__c 
                                                WHERE Account__c IN :accountMap.keySet() 
                                                ORDER BY Lead_Source_Date__c ASC];
                                                
        for (Lead_Sources__c leadSource : leadsources) {
            if (leadSource.Do_Not_Update_Parent__c == true) {
                continue;
            }
            
            this.stampAll(leadSource);
            
            if (leadSource.Product__c.equals('UTP')) {
                this.stampOriginalUTP(leadSource);
                this.stampUTP(leadSource);
            }
            else if (leadSource.Product__c.equals('UOC')) {
                this.stampOriginalUOC(leadSource);
                this.stampUOC(leadSource);
            }
            else if ((leadSource.Product__c.equals('LMFS')) || (leadSource.Product__c.equals('Micro'))) {
                this.stampOriginalLMFS(leadSource);
                this.stampLMFS(leadSource);
            }
            else if ((leadSource.Product__c.equals('USC')) || (leadSource.Product__c.equals('USOP'))) {     // modified to handle USC or USOP on 10/5/2015
                this.stampOriginalUSC(leadSource);  // modified to handle USC or USOP on 10/5/2015
                this.stampUSC(leadSource);          // modified to handle USC or USOP on 10/5/2015
            }
        }
    }
    
    
    /**
    *   Overloaded version of the method that accepts an account map.  Clears all lead source fields on account(s) and stamps the account with new values from lead source(s).
    */
    public void stampLeadSources(List<Lead_Sources__c> leadsources, Boolean allowLeadUpdate) { 
        if (!BYPASS) {
            Set<String> leadIds = new Set<String>();
            Set<String> accountIds = new Set<String>();
            for (Lead_Sources__c leadSource : leadsources) {
                if (leadSource.Account__c != null) {
                    accountIds.add(leadSource.Account__c);
                }
                
                if (leadSource.Lead__c != null) {
                    leadIds.add(leadSource.Lead__c);
                }
            }
            
            this.accountMap = new Map<Id,Account>([
                SELECT 
                    id, CreatedDate, PB_UTP_Summary_Client__c,
                    // piggyback fields (won regardless)
                    PB_WonRegardless_UTP_OnDemand__c, PB_WonRegardless_Live_Market_Fx_Sess__c, 
                    PB_WonRegardless_Ultimate_Stock_Options__c, PB_WonRegardless_Ultimate_Options_Course__c,
                    Micro_Won_Regardless_First_Date__c, Equities_Won_Regardless_First_Date__pc,
                    // piggy back fields (close date)
                    //PB_CloseDate_Ultimate_Options_Course__c, PB_CloseDate_Ultimate_Stock_Options__c,
                    // UTP
                    Lead_Source_UTP__c, Lead_Source_Detail__c, Lead_Source_Date__c,
                    Offer__c, Offer_Type__c, Lead_URL__c,
                    Lead_Source_previous__c, Lead_Source_Detail_previous__c, Lead_Source_Date_previous__c,
                    // UOC
                    Lead_Source_UOC__c, Lead_Source_Detail_UOC__c, Lead_Source_Date_UOC__c,
                    Offer_UOC__c, Offer_Type_UOC__c, Lead_URL_UOC__c,
                    Lead_Source_UOC_PREV__c, Lead_Source_Detail_UOC_PREV__c, Lead_Source_Date_UOC_PREV__c,
                    // USC
                    Lead_Source_USC__pc, Lead_Source_Detail_USC__pc, Lead_Source_Date_USC__pc,
                    Offer_USC__pc, Offer_Type_USC__pc, Lead_URL_USC__pc,
                    Lead_Source_USC_PREV__pc, Lead_Source_Detail_USC_PREV__pc, Lead_Source_Date_USC_PREV__pc,
                    // LMFS
                    Lead_Source_LMFS__c, Lead_Source_Detail_LMFS__c, Lead_Source_Date_LMFS__c,
                    Offer_LMFS__c, Offer_Type_LMFS__c, Lead_URL_LMFS__c,
                    Lead_Source_LMFS_PREV__c, Lead_Source_Detail_LMFS_PREV__c, Lead_Source_Date_LMFS_PREV__c,
                    // UTP part 2
                    First_UTP_Lead_Source__pc, First_UTP_Lead_Source_Detail__pc, First_UTP_Lead_Source_Date__pc,
                    First_UTP_Offer__pc, First_UTP_Offer_Type__pc, First_UTP_IP_Address__pc, First_UTP_URL__pc,
                    Curr_UTP_Lead_Source__pc, Curr_UTP_Lead_Source_Detail__pc, Curr_UTP_Lead_Source_Date__pc,
                    Curr_UTP_Offer__pc, Curr_UTP_Offer_Type__pc, Curr_UTP_IP_Address__pc, Curr_UTP_URL__pc,
                    Curr_UTP_Lead_Source_PREV__pc, Curr_UTP_Lead_Source_Detail_PREV__pc, Curr_UTP_Lead_Source_Date_PREV__pc,
                    // UOC part 2
                    First_UOC_Lead_Source__pc, First_UOC_Lead_Source_Detail__pc, First_UOC_Lead_Source_Date__pc,
                    First_UOC_Offer__pc, First_UOC_Offer_Type__pc, First_UOC_IP_Address__pc, First_UOC_URL__pc,
                    Curr_UOC_Lead_Source__pc, Curr_UOC_Lead_Source_Detail__pc, Curr_UOC_Lead_Source_Date__pc,
                    Curr_UOC_Offer__pc, Curr_UOC_Offer_Type__pc, Curr_UOC_IP_Address__pc, Curr_UOC_URL__pc,
                    Curr_UOC_Lead_Source_PREV__pc, Curr_UOC_Lead_Source_Detail_PREV__pc, Curr_UOC_Lead_Source_Date_PREV__pc,
                    // LMFS part 2
                    First_LMFS_Lead_Source__pc, First_LMFS_Lead_Source_Detail__pc, First_LMFS_Lead_Source_Date__pc,
                    First_LMFS_Offer__pc, First_LMFS_Offer_Type__pc, First_LMFS_URL__pc,
                    Curr_LMFS_Lead_Source__pc, Curr_LMFS_Lead_Source_Detail__pc, Curr_LMFS_Lead_Source_Date__pc,
                    Curr_LMFS_Offer__pc, Curr_LMFS_Offer_Type__pc, Curr_LMFS_URL__pc,
                    Curr_LMFS_Lead_Source_PREV__pc, Curr_LMFS_Lead_Source_Detail_PREV__pc, Curr_LMFS_Lead_Source_Date_PREV__pc,
                    Last_LMFS_Lead_Source__pc, Last_LMFS_Lead_Source_Detail__pc, Last_LMFS_Lead_Source_Date__pc,
                    Last_LMFS_Offer__pc, Last_LMFS_Offer_Type__pc, Last_LMFS_URL__pc,
                    // USOP (previously USC until repurposed on 10/5/2015)
                    //First_USC_Lead_Source__pc,First_UOC_Lead_Source_Detail__pc,First_UOC_Lead_Source_Date__pc,
                    //First_USC_Offer__pc,First_UOC_Offer_Type__pc,First_UOC_IP_Address__pc,First_UOC_URL__pc,
                    Curr_USC_Lead_Source__pc, Curr_USC_Lead_Source_Detail__pc, Curr_USC_Lead_Source_Date__pc,
                    Curr_USC_Offer__pc, Curr_USC_Offer_Type__pc, Curr_USC_IP_Address__pc, Curr_USC_URL__pc,
                    Curr_USC_Lead_Source_PREV__pc, Curr_USC_Lead_Source_Detail_PREV__pc, Curr_USC_Lead_Source_Date_PREV__pc,
                    //aac added 1.27.16
                    First_USOP_Lead_Source_Detail__pc,First_USOP_Lead_Source_Date__pc,First_USOP_Lead_Source__pc,
                    First_USOP_Offer__pc,First_USOP_Offer_Type__pc,First_USOP_URL__pc,
                    // ALL
                    First_ALL_Lead_Source__pc, First_ALL_Lead_Source_Detail__pc, First_ALL_Lead_Source_Date__pc,
                    First_ALL_Offer__pc, First_ALL_Offer_Type__pc, First_ALL_IP_Address__pc, First_ALL_URL__pc,
                    Curr_ALL_Lead_Source__pc, Curr_ALL_Lead_Source_Detail__pc, Curr_ALL_Lead_Source_Date__pc, Curr_ALL_Offer__pc,
                    Curr_ALL_Offer_Type__pc, Curr_ALL_IP_Address__pc, Curr_ALL_URL__pc, Curr_ALL_Lead_Source_PREV__pc,
                    Curr_ALL_Lead_Source_Detail_PREV__pc, Curr_ALL_Lead_Source_Date_PREV__pc
                FROM Account WHERE id in :accountIds]);
            
            for (Account account : accountMap.values()) {
                System.debug('@@@ clearing account lead source data...');
                clearUTPLeadSourceData(account);
                clearUOCLeadSourceData(account);
                clearLMFSLeadSourceData(account);
                clearUSCLeadSourceData(account);    // modified to handle USC or USOP on 10/5/2015
                clearALLLeadSourceData(account);
            }
    
            this.leadMap = new Map<Id,Lead>([SELECT Id, CreatedDate,
                                                // UTP fields
                                                Lead_Source_UTP__c, Lead_Source_Detail__c, Lead_Source_Date__c, 
                                                Offer__c, Offer_Type__c, URL__c,
                                                Lead_Source_previous__c, Lead_Source_Detail_previous__c, Lead_Source_Date_previous__c,
                                                // UOC fields
                                                Lead_Source_UOC__c, Lead_Source_Detail_UOC__c, Lead_Source_Date_UOC__c, 
                                                Offer_UOC__c, Offer_Type_UOC__c, URL_UOC__c,
                                                Lead_Source_UOC_PREV__c, Lead_Source_Detail_UOC_PREV__c, Lead_Source_Date_UOC_PREV__c,
                                                // USOP (previously USC) fields
                                                Lead_Source_USC__c, Lead_Source_Detail_USC__c, Lead_Source_Date_USC__c, 
                                                Offer_USC__c, Offer_Type_USC__c, URL_USC__c,
                                                Lead_Source_USC_PREV__c, Lead_Source_Detail_USC_PREV__c, Lead_Source_Date_USC_PREV__c,
                                                // LMFS fields
                                                Lead_Source_LMFS__c, Lead_Source_Detail_LMFS__c, Lead_Source_Date_LMFS__c, 
                                                Offer_LMFS__c, Offer_Type_LMFS__c, URL_LMFS__c,
                                                Lead_Source_LMFS_PREV__c, Lead_Source_Detail_LMFS_PREV__c, Lead_Source_Date_LMFS_PREV__c,
                                                IP_Address__c,                                              
                                                //aac 11.20.15 new stamper fields
                                                //utp
                                                First_UTP_IP_Address__c, First_UTP_Lead_Source__c,  First_UTP_Lead_Source_Date__c, First_UTP_Lead_Source_Detail__c, First_UTP_Offer__c, First_UTP_Offer_Type__c, First_UTP_URL__c,
                                                //usop
                                                First_USOP_IP_Address__c, First_USOP_Lead_Source__c, First_USOP_Lead_Source_Date__c, First_USOP_Lead_Source_Detail__c, First_USOP_Offer__c, First_USOP_Offer_Type__c, First_USOP_URL__c,
                                                //micro
                                                First_Micro_IP_Address__c, First_Micro_Lead_Source__c, First_Micro_Lead_Source_Date__c, First_Micro_Lead_Source_Detail__c, First_Micro_Offer__c, First_Micro_Offer_Type__c, First_Micro_URL__c
                                                FROM Lead 
                                                WHERE id in :leadIds AND IsConverted = false]);
                                                
            for (Lead lead : leadMap.values()) {
                this.clearLeadData(lead);
            }
            
            List<Lead_Sources__c> allLeadSources = [SELECT Id, IP_Address__c, Product__c, Do_Not_Update_Parent__c, Account__c, Lead_Source_Date__c, Lead_Source__c,
                                                        Lead_Source_Detail__c, Offer__c, Offer_Type__c, URL__c, Lead__c, Override_Lead_Source_Rules__c
                                                        FROM Lead_Sources__c 
                                                        WHERE Account__c IN :accountMap.keySet() OR Lead__c IN :leadMap.keySet() 
                                                        ORDER BY Lead_Source_Date__c ASC];
            
            for (Lead_Sources__c leadSource : allLeadSources) {
                if (leadSource.Do_Not_Update_Parent__c == true) {
                    continue;
                }
                
                this.stampAll(leadSource);
                
                if (leadSource.Product__c.equals('UTP')) {
                    System.debug('@@@ calling stamping for UTP...');
                    this.stampOriginalUTP(leadSource);
                    this.stampUTP(leadSource);
                }
                else if (leadSource.Product__c.equals('UOC')) {
                    System.debug('@@@ calling stamping for UOC...');
                    this.stampOriginalUOC(leadSource);
                    this.stampUOC(leadSource);
                }
                else if ((leadSource.Product__c.equals('LMFS')) || (leadSource.Product__c.equals('Micro'))) {
                    System.debug('@@@ calling stamping for LMFS or Micro...');
                    this.stampOriginalLMFS(leadSource);
                    this.stampLMFS(leadSource);
                }
                else if ((leadSource.Product__c.equals('USC')) || (leadSource.Product__c.equals('USOP'))) {
                    System.debug('@@@ calling stamping for USOP/USC...');
                    this.stampOriginalUSC(leadSource);
                    this.stampUSC(leadSource);
                }
            }
    
            if (!this.accountMap.isEmpty()) {
                Database.update(accountMap.values());
            }
            
            if (!this.leadMap.isEmpty() && allowLeadUpdate) {
                Database.update(leadMap.values());
            }
        }
    }
    
    public void stampAll(Lead_Sources__c leadSource) {
        try{
            Account account = this.accountMap.get(leadSource.Account__c);
            if (account != null) {
                system.debug('stampALL Account Found.');                
                String firstLeadSource = account.First_ALL_Lead_Source__pc;
                String firstLeadSourceDetail = account.First_ALL_Lead_Source_Detail__pc;
                Date firstLeadSourceDate = account.First_ALL_Lead_Source_Date__pc;
                String firstOffer = account.First_ALL_Offer__pc;
                String firstOfferType = account.First_ALL_Offer_Type__pc;
                String firstIPAddress = account.First_ALL_IP_Address__pc; 
                String firstURL = account.First_ALL_URL__pc;
                
                String currentLeadSource = account.Curr_ALL_Lead_Source__pc;
                String currentLeadSourceDetail = account.Curr_ALL_Lead_Source_Detail__pc;
                Date currentLeadSourceDate = account.Curr_ALL_Lead_Source_Date__pc;
                String currentOffer = account.Curr_ALL_Offer__pc;
                String currentOfferType = account.Curr_ALL_Offer_Type__pc;
                String currentIPAddress = account.Curr_ALL_IP_Address__pc;
                String currentURL = account.Curr_ALL_URL__pc;
                String previousLeadSource = account.Curr_ALL_Lead_Source_PREV__pc;
                String previousLeadSourceDetail = account.Curr_ALL_Lead_Source_Detail_PREV__pc;
                Date previousLeadSourceDate = account.Curr_ALL_Lead_Source_Date_PREV__pc;
    
                system.debug('stampALL LeadSource prior to client.');
                if (firstLeadSource == null || firstLeadSourceDate == null) {
                    account.First_ALL_Lead_Source__pc = leadSource.Lead_Source__c;
                    account.First_ALL_Lead_Source_Detail__pc = leadSource.Lead_Source_Detail__c;
                    account.First_ALL_Lead_Source_Date__pc = leadSource.Lead_Source_Date__c;
                    account.First_ALL_Offer__pc = leadSource.Offer__c;
                    account.First_ALL_Offer_Type__pc = leadSource.Offer_Type__c;
                    account.First_ALL_IP_Address__pc = leadSource.IP_Address__c;
                    account.First_ALL_URL__pc = leadSource.URL__c;
                }
                    
                if (currentLeadSource == null || currentLeadSourceDate == null) {
                    account.Curr_ALL_Lead_Source__pc = leadSource.Lead_Source__c;
                    account.Curr_ALL_Lead_Source_Detail__pc = leadSource.Lead_Source_Detail__c;
                    account.Curr_ALL_Lead_Source_Date__pc = leadSource.Lead_Source_Date__c;
                    account.Curr_ALL_Offer__pc = leadSource.Offer__c;
                    account.Curr_ALL_Offer_Type__pc = leadSource.Offer_Type__c;
                    account.Curr_ALL_IP_Address__pc = leadSource.IP_Address__c;
                    account.Curr_ALL_URL__pc = leadSource.URL__c;
                }
                else if (currentLeadSourceDate.daysBetween(leadSource.Lead_Source_Date__c) > 60 || leadSource.Override_Lead_Source_Rules__c) {
                    account.Curr_ALL_Lead_Source__pc = leadSource.Lead_Source__c;
                    account.Curr_ALL_Lead_Source_Detail__pc = leadSource.Lead_Source_Detail__c;
                    account.Curr_ALL_Lead_Source_Date__pc = leadSource.Lead_Source_Date__c;
                    account.Curr_ALL_Offer__pc = leadSource.Offer__c;
                    account.Curr_ALL_Offer_Type__pc = leadSource.Offer_Type__c;
                    account.Curr_ALL_IP_Address__pc = leadSource.IP_Address__c;
                    account.Curr_ALL_URL__pc = leadSource.URL__c;
                    account.Curr_ALL_Lead_Source_PREV__pc = currentLeadSource;
                    account.Curr_ALL_Lead_Source_Detail_PREV__pc = currentLeadSourceDetail;
                    account.Curr_ALL_Lead_Source_Date_PREV__pc = currentLeadSourceDate;
                }
            }
        }
        catch(Exception ex) {
            system.debug(ex);
        }
    }
    
    public void stampUOC(Lead_Sources__c leadSource) {
        try{
            Account account = this.accountMap.get(leadSource.Account__c);
            if (account != null) {
                String firstLeadSource = account.First_UOC_Lead_Source__pc;
                String firstLeadSourceDetail = account.First_UOC_Lead_Source_Detail__pc;
                Date firstLeadSourceDate = account.First_UOC_Lead_Source_Date__pc;
                String firstOffer = account.First_UOC_Offer__pc;
                String firstOfferType = account.First_UOC_Offer_Type__pc;
                String firstIPAddress = account.First_UOC_IP_Address__pc; 
                String firstURL = account.First_UOC_URL__pc;
                
                String currentLeadSource = account.Curr_UOC_Lead_Source__pc;
                String currentLeadSourceDetail = account.Curr_UOC_Lead_Source_Detail__pc;
                Date currentLeadSourceDate = account.Curr_UOC_Lead_Source_Date__pc;
                String currentOffer = account.Curr_UOC_Offer__pc;
                String currentOfferType = account.Curr_UOC_Offer_Type__pc;
                String currentIPAddress = account.Curr_UOC_IP_Address__pc;
                String currentURL = account.Curr_UOC_URL__pc;
                String previousLeadSource = account.Curr_UOC_Lead_Source_PREV__pc;
                String previousLeadSourceDetail = account.Curr_UOC_Lead_Source_Detail_PREV__pc;
                Date previousLeadSourceDate = account.Curr_UOC_Lead_Source_Date_PREV__pc;
                
                if (firstLeadSource == null || firstLeadSourceDate == null) {
                    account.First_UOC_Lead_Source__pc = leadSource.Lead_Source__c;
                    account.First_UOC_Lead_Source_Detail__pc = leadSource.Lead_Source_Detail__c;
                    account.First_UOC_Lead_Source_Date__pc = leadSource.Lead_Source_Date__c;
                    account.First_UOC_Offer__pc = leadSource.Offer__c;
                    account.First_UOC_Offer_Type__pc = leadSource.Offer_Type__c;
                    account.First_UOC_IP_Address__pc = leadSource.IP_Address__c;
                    account.First_UOC_URL__pc = leadSource.URL__c;
                }
    
                if (account.PB_WonRegardless_Ultimate_Options_Course__c == null || leadSource.Lead_Source_Date__c <= account.PB_WonRegardless_Ultimate_Options_Course__c || leadSource.Override_Lead_Source_Rules__c) {
                    if (currentLeadSource == null || currentLeadSourceDate == null) {
                        account.Curr_UOC_Lead_Source__pc = leadSource.Lead_Source__c;
                        account.Curr_UOC_Lead_Source_Detail__pc = leadSource.Lead_Source_Detail__c;
                        account.Curr_UOC_Lead_Source_Date__pc = leadSource.Lead_Source_Date__c;
                        account.Curr_UOC_Offer__pc = leadSource.Offer__c;
                        account.Curr_UOC_Offer_Type__pc = leadSource.Offer_Type__c;
                        account.Curr_UOC_IP_Address__pc = leadSource.IP_Address__c;
                        account.Curr_UOC_URL__pc = leadSource.URL__c;
                    }
                    else if (currentLeadSourceDate.daysBetween(leadSource.Lead_Source_Date__c) > 60 || leadSource.Override_Lead_Source_Rules__c) {
                        account.Curr_UOC_Lead_Source__pc = leadSource.Lead_Source__c;
                        account.Curr_UOC_Lead_Source_Detail__pc = leadSource.Lead_Source_Detail__c;
                        account.Curr_UOC_Lead_Source_Date__pc = leadSource.Lead_Source_Date__c;
                        account.Curr_UOC_Offer__pc = leadSource.Offer__c;
                        account.Curr_UOC_Offer_Type__pc = leadSource.Offer_Type__c;
                        account.Curr_UOC_IP_Address__pc = leadSource.IP_Address__c;
                        account.Curr_UOC_URL__pc = leadSource.URL__c;
                        account.Curr_UOC_Lead_Source_PREV__pc = currentLeadSource;
                        account.Curr_UOC_Lead_Source_Detail_PREV__pc = currentLeadSourceDetail;
                        account.Curr_UOC_Lead_Source_Date_PREV__pc = currentLeadSourceDate;
                    }
                }
            }
        }
        catch(Exception ex) {
            system.debug(ex);
        }
    }
    
    
    public void stampUSC(Lead_Sources__c leadSource) {
        try{
            Account account = this.accountMap.get(leadSource.Account__c);
            //added aac 11.20.15        
            Lead ld = this.leadMap.get(leadSource.Lead__c);
            
            System.debug('@@@ stamping USOP...');
            
            if (account != null) {
                
                System.debug('@@@ stamping account USOP...');
                
                //String firstLeadSource = account.First_UOC_Lead_Source__pc;
                //String firstLeadSourceDetail = account.First_UOC_Lead_Source_Detail__pc;
                //Date firstLeadSourceDate = account.First_UOC_Lead_Source_Date__pc;
                //String firstOffer = account.First_UOC_Offer__pc;
                //String firstOfferType = account.First_UOC_Offer_Type__pc;
                //String firstIPAddress = account.First_UOC_IP_Address__pc; 
                //String firstURL = account.First_UOC_URL__pc;
                
                String currentLeadSource = account.Curr_USC_Lead_Source__pc;
                String currentLeadSourceDetail = account.Curr_USC_Lead_Source_Detail__pc;
                Date currentLeadSourceDate = account.Curr_USC_Lead_Source_Date__pc;
                String currentOffer = account.Curr_USC_Offer__pc;
                String currentOfferType = account.Curr_USC_Offer_Type__pc;
                String currentIPAddress = account.Curr_USC_IP_Address__pc;
                String currentURL = account.Curr_USC_URL__pc;
                String previousLeadSource = account.Curr_USC_Lead_Source_PREV__pc;
                String previousLeadSourceDetail = account.Curr_USC_Lead_Source_Detail_PREV__pc;
                Date previousLeadSourceDate = account.Curr_USC_Lead_Source_Date_PREV__pc;
                
                /*if (firstLeadSource == null || firstLeadSourceDate == null) {
                    account.First_UOC_Lead_Source__pc = leadSource.Lead_Source__c;
                    account.First_UOC_Lead_Source_Detail__pc = leadSource.Lead_Source_Detail__c; 
                    account.First_UOC_Lead_Source_Date__pc = leadSource.Lead_Source_Date__c;
                    account.First_UOC_Offer__pc = leadSource.Offer__c;
                    account.First_UOC_Offer_Type__pc = leadSource.Offer_Type__c;
                    account.First_UOC_IP_Address__pc = leadSource.IP_Address__c;
                    account.First_UOC_URL__pc = leadSource.URL__c;
                }*/
                //aac added for usop changes 1.27.16
                System.debug('@asha:@debug: LeadSourceStamper: Starting Account USOP first lead source updates.');
                String firstLeadSource = account.First_USOP_Lead_Source__pc;
                String firstLeadSourceDetail = account.First_USOP_Lead_Source_Detail__pc;
                Date firstLeadSourceDate = account.First_USOP_Lead_Source_Date__pc;
                String firstOffer = account.First_USOP_Offer__pc;
                String firstOfferType = account.First_USOP_Offer_Type__pc;
                String firstIPAddress = account.First_USOP_IP_Address__pc; 
                String firstURL = account.First_USOP_URL__pc;
                
                if (firstLeadSource == null || firstLeadSourceDate == null) {
                    system.debug('@asha: @debug: LeadSourceStamper: Account stamping USOP first lead source.');
                    account.First_USOP_Lead_Source__pc = leadSource.Lead_Source__c;
                    account.First_USOP_Lead_Source_Detail__pc = leadSource.Lead_Source_Detail__c; 
                    account.First_USOP_Lead_Source_Date__pc = leadSource.Lead_Source_Date__c;
                    account.First_USOP_Offer__pc = leadSource.Offer__c;
                    account.First_USOP_Offer_Type__pc = leadSource.Offer_Type__c;
                    account.First_USOP_IP_Address__pc = leadSource.IP_Address__c;
                    account.First_USOP_URL__pc = leadSource.URL__c;
                }
                
                if (account.PB_WonRegardless_Ultimate_Stock_Options__c == null || leadSource.Lead_Source_Date__c <= account.PB_WonRegardless_Ultimate_Stock_Options__c || leadSource.Override_Lead_Source_Rules__c) {
                    if (currentLeadSource == null || currentLeadSourceDate == null) {
                        account.Curr_USC_Lead_Source__pc = leadSource.Lead_Source__c;
                        account.Curr_USC_Lead_Source_Detail__pc = leadSource.Lead_Source_Detail__c;
                        account.Curr_USC_Lead_Source_Date__pc = leadSource.Lead_Source_Date__c;
                        account.Curr_USC_Offer__pc = leadSource.Offer__c;
                        account.Curr_USC_Offer_Type__pc = leadSource.Offer_Type__c;
                        account.Curr_USC_IP_Address__pc = leadSource.IP_Address__c;
                        account.Curr_USC_URL__pc = leadSource.URL__c;
                    }
                    else if (currentLeadSourceDate.daysBetween(leadSource.Lead_Source_Date__c) > 60 || leadSource.Override_Lead_Source_Rules__c) {
                        account.Curr_USC_Lead_Source__pc = leadSource.Lead_Source__c;
                        account.Curr_USC_Lead_Source_Detail__pc = leadSource.Lead_Source_Detail__c;
                        account.Curr_USC_Lead_Source_Date__pc = leadSource.Lead_Source_Date__c;
                        account.Curr_USC_Offer__pc = leadSource.Offer__c;
                        account.Curr_USC_Offer_Type__pc = leadSource.Offer_Type__c;
                        account.Curr_USC_IP_Address__pc = leadSource.IP_Address__c;
                        account.Curr_USC_URL__pc = leadSource.URL__c;
                        account.Curr_USC_Lead_Source_PREV__pc = currentLeadSource;
                        account.Curr_USC_Lead_Source_Detail_PREV__pc = currentLeadSourceDetail;
                        account.Curr_USC_Lead_Source_Date_PREV__pc = currentLeadSourceDate;
                    }
                }
             }
             
             //added aac 11.20.15 - USOP
            if (ld != null) {
                String firstLeadSource = ld.First_USOP_Lead_Source__c;
                String firstLeadSourceDetail = ld.First_USOP_Lead_Source_Detail__c;
                Date firstLeadSourceDate = ld.First_USOP_Lead_Source_Date__c;
                String firstOffer = ld.First_USOP_Offer__c;
                String firstOfferType = ld.First_USOP_Offer_Type__c;
                String firstIPAddress = ld.First_USOP_IP_Address__c; 
                String firstURL = ld.First_USOP_URL__c;
                
                if (firstLeadSource == null || firstLeadSourceDate == null) {
                    system.debug('@asha: @debug: LeadSourceStamper: Lead stampUSOP no first lead source.');
                    ld.First_USOP_Lead_Source__c = leadSource.Lead_Source__c;
                    ld.First_USOP_Lead_Source_Detail__c = leadSource.Lead_Source_Detail__c;
                    ld.First_USOP_Lead_Source_Date__c = leadSource.Lead_Source_Date__c;
                    ld.First_USOP_Offer__c = leadSource.Offer__c;
                    ld.First_USOP_Offer_Type__c = leadSource.Offer_Type__c;
                    ld.First_USOP_IP_Address__c = leadSource.IP_Address__c;
                    ld.First_USOP_URL__c = leadSource.URL__c;
                }   
            }
        }
        catch(Exception ex) {
            system.debug(ex);
        }
    }

    public void stampUTP(Lead_Sources__c leadSource) {
        System.debug('@@@ In stampUTP...');
        try {
            Account account = this.accountMap.get(leadSource.Account__c);
            //added aac 11.20.15        
            Lead ld = this.leadMap.get(leadSource.Lead__c);
            
            if (account != null) {
                String firstLeadSource = account.First_UTP_Lead_Source__pc;
                String firstLeadSourceDetail = account.First_UTP_Lead_Source_Detail__pc;
                Date firstLeadSourceDate = account.First_UTP_Lead_Source_Date__pc;
                String firstOffer = account.First_UTP_Offer__pc;
                String firstOfferType = account.First_UTP_Offer_Type__pc;
                String firstIPAddress = account.First_UTP_IP_Address__pc; 
                String firstURL = account.First_UTP_URL__pc;
                
                String currentLeadSource = account.Curr_UTP_Lead_Source__pc;
                String currentLeadSourceDetail = account.Curr_UTP_Lead_Source_Detail__pc;
                Date currentLeadSourceDate = account.Curr_UTP_Lead_Source_Date__pc;
                String currentOffer = account.Curr_UTP_Offer__pc;
                String currentOfferType = account.Curr_UTP_Offer_Type__pc;
                String currentIPAddress = account.Curr_UTP_IP_Address__pc;
                String currentURL = account.Curr_UTP_URL__pc;
                String previousLeadSource = account.Curr_UTP_Lead_Source_PREV__pc;
                String previousLeadSourceDetail = account.Curr_UTP_Lead_Source_Detail_PREV__pc;
                Date previousLeadSourceDate = account.Curr_UTP_Lead_Source_Date_PREV__pc;
                
                if (firstLeadSource == null || firstLeadSourceDate == null) {
                    system.debug('stampUTP no first lead source.');
                    account.First_UTP_Lead_Source__pc = leadSource.Lead_Source__c;
                    account.First_UTP_Lead_Source_Detail__pc = leadSource.Lead_Source_Detail__c;
                    account.First_UTP_Lead_Source_Date__pc = leadSource.Lead_Source_Date__c;
                    account.First_UTP_Offer__pc = leadSource.Offer__c;
                    account.First_UTP_Offer_Type__pc = leadSource.Offer_Type__c;
                    account.First_UTP_IP_Address__pc = leadSource.IP_Address__c;
                    account.First_UTP_URL__pc = leadSource.URL__c;
                }
    
                if (account.PB_WonRegardless_UTP_OnDemand__c == null || leadSource.Lead_Source_Date__c <= account.PB_WonRegardless_UTP_OnDemand__c || leadSource.Override_Lead_Source_Rules__c) {
                    if (currentLeadSource == null || currentLeadSourceDate == null) {
                        account.Curr_UTP_Lead_Source__pc = leadSource.Lead_Source__c;
                        account.Curr_UTP_Lead_Source_Detail__pc = leadSource.Lead_Source_Detail__c;
                        account.Curr_UTP_Lead_Source_Date__pc = leadSource.Lead_Source_Date__c;
                        account.Curr_UTP_Offer__pc = leadSource.Offer__c;
                        account.Curr_UTP_Offer_Type__pc = leadSource.Offer_Type__c;
                        account.Curr_UTP_IP_Address__pc = leadSource.IP_Address__c;
                        account.Curr_UTP_URL__pc = leadSource.URL__c;
                    }
                    else if (currentLeadSourceDate.daysBetween(leadSource.Lead_Source_Date__c) > 60 ||  leadSource.Override_Lead_Source_Rules__c) {
                        account.Curr_UTP_Lead_Source__pc = leadSource.Lead_Source__c;
                        account.Curr_UTP_Lead_Source_Detail__pc = leadSource.Lead_Source_Detail__c;
                        account.Curr_UTP_Lead_Source_Date__pc = leadSource.Lead_Source_Date__c;
                        account.Curr_UTP_Offer__pc = leadSource.Offer__c;
                        account.Curr_UTP_Offer_Type__pc = leadSource.Offer_Type__c;
                        account.Curr_UTP_IP_Address__pc = leadSource.IP_Address__c;
                        account.Curr_UTP_URL__pc = leadSource.URL__c;
                        account.Curr_UTP_Lead_Source_PREV__pc = currentLeadSource;
                        account.Curr_UTP_Lead_Source_Detail_PREV__pc = currentLeadSourceDetail;
                        account.Curr_UTP_Lead_Source_Date_PREV__pc = currentLeadSourceDate;
                    }
                }
            }
            //added aac 11.20.15 
            if (ld != null) {
                String firstLeadSource = ld.First_UTP_Lead_Source__c;
                String firstLeadSourceDetail = ld.First_UTP_Lead_Source_Detail__c;
                Date firstLeadSourceDate = ld.First_UTP_Lead_Source_Date__c;
                String firstOffer = ld.First_UTP_Offer__c;
                String firstOfferType = ld.First_UTP_Offer_Type__c;
                String firstIPAddress = ld.First_UTP_IP_Address__c; 
                String firstURL = ld.First_UTP_URL__c;
                
                if (firstLeadSource == null || firstLeadSourceDate == null) {
                    system.debug('@asha: @debug: LeadSourceStamper: Lead stampUTP no first lead source.');
                    ld.First_UTP_Lead_Source__c = leadSource.Lead_Source__c;
                    ld.First_UTP_Lead_Source_Detail__c = leadSource.Lead_Source_Detail__c;
                    ld.First_UTP_Lead_Source_Date__c = leadSource.Lead_Source_Date__c;
                    ld.First_UTP_Offer__c = leadSource.Offer__c;
                    ld.First_UTP_Offer_Type__c = leadSource.Offer_Type__c;
                    ld.First_UTP_IP_Address__c = leadSource.IP_Address__c;
                    ld.First_UTP_URL__c = leadSource.URL__c;
                }   
            }
        }
        catch(Exception ex) {
            system.debug(ex);
        }
    }
    
    
    public void stampLMFS(Lead_Sources__c leadSource) {
        try{
            Account account = this.accountMap.get(leadSource.Account__c);
            //added aac 11.20.15 - stamps micros
            Lead ld = this.leadMap.get(leadSource.Lead__c);
            if (account != null) {
              // save off existing values for first, current, and last fields
                String firstLeadSource = account.First_LMFS_Lead_Source__pc;
                String firstLeadSourceDetail = account.First_LMFS_Lead_Source_Detail__pc;
                Date firstLeadSourceDate = account.First_LMFS_Lead_Source_Date__pc;
                String firstOffer = account.First_LMFS_Offer__pc;
                String firstOfferType = account.First_LMFS_Offer_Type__pc;
                String firstURL = account.First_LMFS_URL__pc;
                
                String currentLeadSource = account.Curr_LMFS_Lead_Source__pc;
                String currentLeadSourceDetail = account.Curr_LMFS_Lead_Source_Detail__pc;
                Date currentLeadSourceDate = account.Curr_LMFS_Lead_Source_Date__pc;
                String currentOffer = account.Curr_LMFS_Offer__pc;
                String currentOfferType = account.Curr_LMFS_Offer_Type__pc;
                String currentURL = account.Curr_LMFS_URL__pc;
                String previousLeadSource = account.Curr_LMFS_Lead_Source_PREV__pc;
                String previousLeadSourceDetail = account.Curr_LMFS_Lead_Source_Detail_PREV__pc;
                Date previousLeadSourceDate = account.Curr_LMFS_Lead_Source_Date_PREV__pc;
                
                String lastLeadSource = account.Last_LMFS_Lead_Source__pc;
                String lastLeadSourceDetail = account.Last_LMFS_Lead_Source_Detail__pc;
                Date lastLeadSourceDate = account.Last_LMFS_Lead_Source_Date__pc;
                String lastOffer = account.Last_LMFS_Offer__pc;
                String lastOfferType = account.Last_LMFS_Offer_Type__pc;
                String lastURL = account.Last_LMFS_URL__pc;
    
        // no first lead source or first lead source date, use current lead source as the first          
                if (firstLeadSource == null || firstLeadSourceDate == null) {
                    account.First_LMFS_Lead_Source__pc = leadSource.Lead_Source__c;
                    account.First_LMFS_Lead_Source_Detail__pc = leadSource.Lead_Source_Detail__c;
                    account.First_LMFS_Lead_Source_Date__pc = leadSource.Lead_Source_Date__c;
                    account.First_LMFS_Offer__pc = leadSource.Offer__c;
                    account.First_LMFS_Offer_Type__pc = leadSource.Offer_Type__c;
                    account.First_LMFS_URL__pc = leadSource.URL__c;
                }
                
                
          // if (both fields are null) OR
          // if (the lead source date is <= the earliest of the 2 fields) OR 
          // if (override lead source rules)
          Date earliestFirstDate = null;
          if ((account.Micro_Won_Regardless_First_Date__c != null) && (account.Equities_Won_Regardless_First_Date__pc != null)) {
            earliestFirstDate = (account.Micro_Won_Regardless_First_Date__c < account.Equities_Won_Regardless_First_Date__pc) ? account.Micro_Won_Regardless_First_Date__c : account.Equities_Won_Regardless_First_Date__pc;
          }
          else { 
            if (account.Micro_Won_Regardless_First_Date__c != null) {
              earliestFirstDate = account.Micro_Won_Regardless_First_Date__c;
            }
            else if (account.Equities_Won_Regardless_First_Date__pc != null) {
              earliestFirstDate = account.Equities_Won_Regardless_First_Date__pc;
            }
          }
          
          //if (account.PB_WonRegardless_Live_Market_Fx_Sess__c == null || leadSource.Lead_Source_Date__c <= account.PB_WonRegardless_Live_Market_Fx_Sess__c || leadSource.Override_Lead_Source_Rules__c) {
                if ((earliestFirstDate == null) || (leadSource.Lead_Source_Date__c <= earliestFirstDate) || (leadSource.Override_Lead_Source_Rules__c)) {
                    // no current lead source or current lead source date
                    if (currentLeadSource == null || currentLeadSourceDate == null) {
                        account.Curr_LMFS_Lead_Source__pc = leadSource.Lead_Source__c;
                        account.Curr_LMFS_Lead_Source_Detail__pc = leadSource.Lead_Source_Detail__c;
                        account.Curr_LMFS_Lead_Source_Date__pc = leadSource.Lead_Source_Date__c;
                        account.Curr_LMFS_Offer__pc = leadSource.Offer__c;
                        account.Curr_LMFS_Offer_Type__pc = leadSource.Offer_Type__c;
                        account.Curr_LMFS_URL__pc = leadSource.URL__c;
                    }
                    else if (currentLeadSourceDate.daysBetween(leadSource.Lead_Source_Date__c) > 60 || leadSource.Override_Lead_Source_Rules__c) {
                        account.Curr_LMFS_Lead_Source__pc = leadSource.Lead_Source__c;
                        account.Curr_LMFS_Lead_Source_Detail__pc = leadSource.Lead_Source_Detail__c;
                        account.Curr_LMFS_Lead_Source_Date__pc = leadSource.Lead_Source_Date__c;
                        account.Curr_LMFS_Offer__pc = leadSource.Offer__c;
                        account.Curr_LMFS_Offer_Type__pc = leadSource.Offer_Type__c;
                        account.Curr_LMFS_URL__pc = leadSource.URL__c;
                        account.Curr_LMFS_Lead_Source_PREV__pc = currentLeadSource;
                        account.Curr_LMFS_Lead_Source_Detail_PREV__pc = currentLeadSourceDetail;
                        account.Curr_LMFS_Lead_Source_Date_PREV__pc = currentLeadSourceDate;
                    }
                }
                
                if (lastLeadSource == null || lastLeadSourceDate == null) {
                    account.Last_LMFS_Lead_Source__pc = leadSource.Lead_Source__c;
                    account.Last_LMFS_Lead_Source_Detail__pc = leadSource.Lead_Source_Detail__c;
                    account.Last_LMFS_Lead_Source_Date__pc = leadSource.Lead_Source_Date__c;
                    account.Last_LMFS_Offer__pc = leadSource.Offer__c;
                    account.Last_LMFS_Offer_Type__pc = leadSource.Offer_Type__c;
                    account.Last_LMFS_URL__pc = leadSource.URL__c;
                }
                else if (leadSource.Lead_Source_Date__c > lastLeadSourceDate) {
                    account.Last_LMFS_Lead_Source__pc = leadSource.Lead_Source__c;
                    account.Last_LMFS_Lead_Source_Detail__pc = leadSource.Lead_Source_Detail__c;
                    account.Last_LMFS_Lead_Source_Date__pc = leadSource.Lead_Source_Date__c;
                    account.Last_LMFS_Offer__pc = leadSource.Offer__c;
                    account.Last_LMFS_Offer_Type__pc = leadSource.Offer_Type__c;
                    account.Last_LMFS_URL__pc = leadSource.URL__c;
                }
            }
            
            //added aac 11.20.15 - micros
            if (ld != null) {
                String firstLeadSource = ld.First_Micro_Lead_Source__c;
                String firstLeadSourceDetail = ld.First_Micro_Lead_Source_Detail__c;
                Date firstLeadSourceDate = ld.First_Micro_Lead_Source_Date__c;
                String firstOffer = ld.First_Micro_Offer__c;
                String firstOfferType = ld.First_Micro_Offer_Type__c;
                String firstIPAddress = ld.First_Micro_IP_Address__c; 
                String firstURL = ld.First_Micro_URL__c;
                
                if (firstLeadSource == null || firstLeadSourceDate == null) {
                    system.debug('@asha: @debug: LeadSourceStamper: Lead stampMicro no first lead source.');
                    ld.First_Micro_Lead_Source__c = leadSource.Lead_Source__c;
                    ld.First_Micro_Lead_Source_Detail__c = leadSource.Lead_Source_Detail__c;
                    ld.First_Micro_Lead_Source_Date__c = leadSource.Lead_Source_Date__c;
                    ld.First_Micro_Offer__c = leadSource.Offer__c;
                    ld.First_Micro_Offer_Type__c = leadSource.Offer_Type__c;
                    ld.First_Micro_IP_Address__c = leadSource.IP_Address__c;
                    ld.First_Micro_URL__c = leadSource.URL__c;
                }   
            }
        }
        catch(Exception ex) {
            system.debug(ex);
        }
    }
    
    
    
    /**
    *   This is the method that stamps the info on the lead
    *   There are no fields for specialization
    */
/*  public void stampOriginal(Lead_Sources__c leadSource) {
        Account account = this.accountMap.get(leadSource.Account__c);
        Lead lead = this.leadMap.get(leadSource.Lead__c);
        
        if (account != null) {
            String currentLeadSource = account.PersonLeadSource;
            String currentLeadSourceDetail = account.Lead_Source_Detail__c;
            Date currentLeadSourceDate = account.Lead_Source_Date__c;
            String currentOffer = account.Offer__c;
            String currentOfferType = account.Offer_Type__c;
            String currentURL = account.Lead_URL__c;
            
            String previousLeadSource = account.Lead_Source_previous__c;
            String previousLeadSourceDetail = account.Lead_Source_Detail_previous__c;
            Date previousLeadSourceDate = account.Lead_Source_Date_previous__c;
            
            if (account.PB_WonRegardless_UTP_OnDemand__c == null || leadSource.Lead_Source_Date__c <= account.PB_WonRegardless_UTP_OnDemand__c ||  leadSource.Override_Lead_Source_Rules__c) {
                if (currentLeadSource == null) {
                    account.PersonLeadSource = leadSource.Lead_Source__c;
                    account.Lead_Source_Detail__c = leadSource.Lead_Source_Detail__c;
                    account.Lead_Source_Date__c = leadSource.Lead_Source_Date__c;
                    account.Offer__c = leadSource.Offer__c;
                    account.Offer_Type__c = leadSource.Offer_Type__c;
                    account.Lead_URL__c = leadSource.URL__c;
                    
                }
                else {
                    if (currentLeadSourceDate == null || (leadSource.Lead_Source_Date__c != null && currentLeadSourceDate.daysBetween(leadSource.Lead_Source_Date__c) > 60) ||  leadSource.Override_Lead_Source_Rules__c) {
                        account.PersonLeadSource = leadSource.Lead_Source__c;
                        account.Lead_Source_Detail__c = leadSource.Lead_Source_Detail__c;
                        account.Lead_Source_Date__c = leadSource.Lead_Source_Date__c;
                        account.Offer__c = leadSource.Offer__c;
                        account.Offer_Type__c = leadSource.Offer_Type__c;
                        account.Lead_URL__c = leadSource.URL__c;
                        account.Lead_Source_previous__c = currentLeadSource;
                        account.Lead_Source_Detail_previous__c = currentLeadSourceDetail;
                        account.Lead_Source_Date_previous__c = currentLeadSourceDate;
                    }
                }
            }
        }
        else if (lead != null) {                                            // stamp the lead
            String currentLeadSource = lead.LeadSource;
            String currentLeadSourceDetail = lead.Lead_Source_Detail__c;
            Date currentLeadSourceDate = lead.Lead_Source_Date__c;
            String currentOffer = lead.Offer__c;
            String currentOfferType = lead.Offer_Type__c;
            String currentURL = lead.URl__c;
            
            String previousLeadSource = lead.Lead_Source_previous__c;
            String previousLeadSourceDetail = lead.Lead_Source_Detail_previous__c;
            Date previousLeadSourceDate = lead.Lead_Source_Date_previous__c;
            
            
            // stamp the lead with info
            if (currentLeadSource == null) {
                lead.LeadSource = leadSource.Lead_Source__c;
                lead.Lead_Source_Detail__c = leadSource.Lead_Source_Detail__c;
                lead.Lead_Source_Date__c = leadSource.Lead_Source_Date__c;
                lead.Offer__c = leadSource.Offer__c;
                lead.Offer_Type__c = leadSource.Offer_Type__c;
                lead.URl__c = leadSource.URL__c;
            }
            else {
                if (currentLeadSourceDate == null || (leadSource.Lead_Source_Date__c != null && currentLeadSourceDate.daysBetween(leadSource.Lead_Source_Date__c) > 60) || leadSource.Override_Lead_Source_Rules__c) {
                    lead.LeadSource = leadSource.Lead_Source__c;
                    lead.Lead_Source_Detail__c = leadSource.Lead_Source_Detail__c;
                    lead.Lead_Source_Date__c = leadSource.Lead_Source_Date__c;
                    lead.Offer__c = leadSource.Offer__c;
                    lead.Offer_Type__c = leadSource.Offer_Type__c;
                    lead.URl__c = leadSource.URL__c;
                    lead.Lead_Source_previous__c = currentLeadSource;
                    lead.Lead_Source_Detail_previous__c = currentLeadSourceDetail;
                    lead.Lead_Source_Date_previous__c = currentLeadSourceDate;
                }
            }
        }
    }
*/
    
    /**
    *   This is a method that stamps UTP info on the lead
    */
    public void stampOriginalUTP(Lead_Sources__c leadSource) {
        System.debug('@@@ In stampOriginalUTP...');
        
        Account account = this.accountMap.get(leadSource.Account__c);
        Lead lead = this.leadMap.get(leadSource.Lead__c);
        
        if (account != null) {
            String currentLeadSource = account.Lead_Source_UTP__c;
            String currentLeadSourceDetail = account.Lead_Source_Detail__c;
            Date currentLeadSourceDate = account.Lead_Source_Date__c;
            String currentOffer = account.Offer__c;
            String currentOfferType = account.Offer_Type__c;
            String currentURL = account.Lead_URL__c;
            
            String previousLeadSource = account.Lead_Source_previous__c;
            String previousLeadSourceDetail = account.Lead_Source_Detail_previous__c;
            Date previousLeadSourceDate = account.Lead_Source_Date_previous__c;
            
            if (account.PB_WonRegardless_UTP_OnDemand__c == null || leadSource.Lead_Source_Date__c <= account.PB_WonRegardless_UTP_OnDemand__c ||  leadSource.Override_Lead_Source_Rules__c) {
                if (currentLeadSource == null) {
                    account.Lead_Source_UTP__c = leadSource.Lead_Source__c;
                    account.Lead_Source_Detail__c = leadSource.Lead_Source_Detail__c;
                    account.Lead_Source_Date__c = leadSource.Lead_Source_Date__c;
                    account.Offer__c = leadSource.Offer__c;
                    account.Offer_Type__c = leadSource.Offer_Type__c;
                    account.Lead_URL__c = leadSource.URL__c;
                }
                else {
                    if (currentLeadSourceDate == null || (leadSource.Lead_Source_Date__c != null && currentLeadSourceDate.daysBetween(leadSource.Lead_Source_Date__c) > 60) ||  leadSource.Override_Lead_Source_Rules__c) {
                        account.Lead_Source_UTP__c = leadSource.Lead_Source__c;
                        account.Lead_Source_Detail__c = leadSource.Lead_Source_Detail__c;
                        account.Lead_Source_Date__c = leadSource.Lead_Source_Date__c;
                        account.Offer__c = leadSource.Offer__c;
                        account.Offer_Type__c = leadSource.Offer_Type__c;
                        account.Lead_URL__c = leadSource.URL__c;
                        account.Lead_Source_previous__c = currentLeadSource;
                        account.Lead_Source_Detail_previous__c = currentLeadSourceDetail;
                        account.Lead_Source_Date_previous__c = currentLeadSourceDate;
                    }
                }
            }
        }
        else if (lead != null) {                                            // stamp the lead
            System.debug('@@@ the lead is valid in stampOriginalUTP...');
            String currentLeadSource = lead.Lead_Source_UTP__c;
            String currentLeadSourceDetail = lead.Lead_Source_Detail__c;
            Date currentLeadSourceDate = lead.Lead_Source_Date__c;
            String currentOffer = lead.Offer__c;
            String currentOfferType = lead.Offer_Type__c;
            String currentURL = lead.URl__c;
            
            String previousLeadSource = lead.Lead_Source_previous__c;
            String previousLeadSourceDetail = lead.Lead_Source_Detail_previous__c;
            Date previousLeadSourceDate = lead.Lead_Source_Date_previous__c;
            
            // stamp the lead with info
            if (currentLeadSource == null) {
                lead.Lead_Source_UTP__c = leadSource.Lead_Source__c;
                lead.Lead_Source_Detail__c = leadSource.Lead_Source_Detail__c;
                lead.Lead_Source_Date__c = leadSource.Lead_Source_Date__c;
                lead.Offer__c = leadSource.Offer__c;
                lead.Offer_Type__c = leadSource.Offer_Type__c;
                lead.URl__c = leadSource.URL__c;
                lead.IP_Address__c = leadSource.IP_Address__c;
            }
            else {
                if (currentLeadSourceDate == null || (leadSource.Lead_Source_Date__c != null && currentLeadSourceDate.daysBetween(leadSource.Lead_Source_Date__c) > 60) || leadSource.Override_Lead_Source_Rules__c) {
                    lead.Lead_Source_UTP__c = leadSource.Lead_Source__c;
                    lead.Lead_Source_Detail__c = leadSource.Lead_Source_Detail__c;
                    lead.Lead_Source_Date__c = leadSource.Lead_Source_Date__c;
                    lead.Offer__c = leadSource.Offer__c;
                    lead.Offer_Type__c = leadSource.Offer_Type__c;
                    lead.URl__c = leadSource.URL__c;
                    lead.IP_Address__c = leadSource.IP_Address__c;
                    lead.Lead_Source_previous__c = currentLeadSource;
                    lead.Lead_Source_Detail_previous__c = currentLeadSourceDetail;
                    lead.Lead_Source_Date_previous__c = currentLeadSourceDate;
                }
            }
        }
    }
    
    /**
    *   This is a method that stamps UOC info on the lead
    */
    public void stampOriginalUOC(Lead_Sources__c leadSource) {
        Account account = this.accountMap.get(leadSource.Account__c);
        Lead lead = this.leadMap.get(leadSource.Lead__c);
        
        if (account != null) {
            String currentLeadSource = account.Lead_Source_UOC__c;
            String currentLeadSourceDetail = account.Lead_Source_Detail_UOC__c;
            Date currentLeadSourceDate = account.Lead_Source_Date_UOC__c;
            String currentOffer = account.Offer_UOC__c;
            String currentOfferType = account.Offer_Type_UOC__c;
            String currentURL = account.Lead_URL_UOC__c;
            
            String previousLeadSource = account.Lead_Source_UOC_PREV__c;
            String previousLeadSourceDetail = account.Lead_Source_Detail_UOC_PREV__c;
            Date previousLeadSourceDate = account.Lead_Source_Date_UOC_PREV__c;
            
            if (account.PB_WonRegardless_Ultimate_Options_Course__c == null || leadSource.Lead_Source_Date__c <= account.PB_WonRegardless_Ultimate_Options_Course__c ||  leadSource.Override_Lead_Source_Rules__c) {
                if (currentLeadSource == null) {
                    account.Lead_Source_UOC__c = leadSource.Lead_Source__c;
                    account.Lead_Source_Detail_UOC__c = leadSource.Lead_Source_Detail__c;
                    account.Lead_Source_Date_UOC__c = leadSource.Lead_Source_Date__c;
                    account.Offer_UOC__c = leadSource.Offer__c;
                    account.Offer_Type_UOC__c = leadSource.Offer_Type__c;
                    account.Lead_URL_UOC__c = leadSource.URL__c;
                }
                else {
                    if (currentLeadSourceDate == null || (leadSource.Lead_Source_Date__c != null && currentLeadSourceDate.daysBetween(leadSource.Lead_Source_Date__c) > 60) ||  leadSource.Override_Lead_Source_Rules__c) {
                        account.Lead_Source_UOC__c = leadSource.Lead_Source__c;
                        account.Lead_Source_Detail_UOC__c = leadSource.Lead_Source_Detail__c;
                        account.Lead_Source_Date_UOC__c = leadSource.Lead_Source_Date__c;
                        account.Offer_UOC__c = leadSource.Offer__c;
                        account.Offer_Type_UOC__c = leadSource.Offer_Type__c;
                        account.Lead_URL_UOC__c = leadSource.URL__c;
                        account.Lead_Source_UOC_PREV__c = currentLeadSource;
                        account.Lead_Source_Detail_UOC_PREV__c = currentLeadSourceDetail;
                        account.Lead_Source_Date_UOC_PREV__c = currentLeadSourceDate;
                    }
                }
            }
        }
        else if (lead != null) {                                            // stamp the lead
            String currentLeadSource = lead.Lead_Source_UOC__c;
            String currentLeadSourceDetail = lead.Lead_Source_Detail_UOC__c;
            Date currentLeadSourceDate = lead.Lead_Source_Date_UOC__c;
            String currentOffer = lead.Offer_UOC__c;
            String currentOfferType = lead.Offer_Type_UOC__c;
            String currentURL = lead.URL_UOC__c;
            
            String previousLeadSource = lead.Lead_Source_UOC_PREV__c;
            String previousLeadSourceDetail = lead.Lead_Source_Detail_UOC_PREV__c;
            Date previousLeadSourceDate = lead.Lead_Source_Date_UOC_PREV__c;
            
            // stamp the lead with info
            if (currentLeadSource == null) {
                lead.Lead_Source_UOC__c = leadSource.Lead_Source__c;
                lead.Lead_Source_Detail_UOC__c = leadSource.Lead_Source_Detail__c;
                lead.Lead_Source_Date_UOC__c = leadSource.Lead_Source_Date__c;
                lead.Offer_UOC__c = leadSource.Offer__c;
                lead.Offer_Type_UOC__c = leadSource.Offer_Type__c;
                lead.URL_UOC__c = leadSource.URL__c;
                lead.IP_Address__c = leadSource.IP_Address__c;
            }
            else {
                if (currentLeadSourceDate == null || (leadSource.Lead_Source_Date__c != null && currentLeadSourceDate.daysBetween(leadSource.Lead_Source_Date__c) > 60) || leadSource.Override_Lead_Source_Rules__c) {
                    lead.Lead_Source_UOC__c = leadSource.Lead_Source__c;
                    lead.Lead_Source_Detail_UOC__c = leadSource.Lead_Source_Detail__c;
                    lead.Lead_Source_Date_UOC__c = leadSource.Lead_Source_Date__c;
                    lead.Offer_UOC__c = leadSource.Offer__c;
                    lead.Offer_Type_UOC__c = leadSource.Offer_Type__c;
                    lead.URL_UOC__c = leadSource.URL__c;
                    lead.IP_Address__c = leadSource.IP_Address__c;
                    lead.Lead_Source_UOC_PREV__c = currentLeadSource;
                    lead.Lead_Source_Detail_UOC_PREV__c = currentLeadSourceDetail;
                    lead.Lead_Source_Date_UOC_PREV__c = currentLeadSourceDate;
                }
            }
        }
    }
    
    
    /**
    *   This is a method that stamps USOP (previously USC) info on the lead
    */
    public void stampOriginalUSC(Lead_Sources__c leadSource) {
        Account account = this.accountMap.get(leadSource.Account__c);
        Lead lead = this.leadMap.get(leadSource.Lead__c);
        
        System.debug('@@@ stamping original USOP...');
        
        if (account != null) {
            System.debug('@@@ stamping account USOP...');
            String currentLeadSource = account.Lead_Source_USC__pc;
            String currentLeadSourceDetail = account.Lead_Source_Detail_USC__pc;
            Date currentLeadSourceDate = account.Lead_Source_Date_USC__pc;
            String currentOffer = account.Offer_USC__pc;
            String currentOfferType = account.Offer_Type_USC__pc;
            String currentURL = account.Lead_URL_USC__pc; 
            
            String previousLeadSource = account.Lead_Source_USC_PREV__pc;
            String previousLeadSourceDetail = account.Lead_Source_Detail_USC_PREV__pc;
            Date previousLeadSourceDate = account.Lead_Source_Date_USC_PREV__pc;
            
            if (account.PB_WonRegardless_Ultimate_Stock_Options__c == null || leadSource.Lead_Source_Date__c <= account.PB_WonRegardless_Ultimate_Stock_Options__c ||  leadSource.Override_Lead_Source_Rules__c) {
                if (currentLeadSource == null) {
                    account.Lead_Source_USC__pc = leadSource.Lead_Source__c;
                    account.Lead_Source_Detail_USC__pc = leadSource.Lead_Source_Detail__c;
                    account.Lead_Source_Date_USC__pc = leadSource.Lead_Source_Date__c;
                    account.Offer_USC__pc = leadSource.Offer__c;
                    account.Offer_Type_USC__pc = leadSource.Offer_Type__c;
                    account.Lead_URL_USC__pc = leadSource.URL__c;
                }
                else {
                    if (currentLeadSourceDate == null || (leadSource.Lead_Source_Date__c != null && currentLeadSourceDate.daysBetween(leadSource.Lead_Source_Date__c) > 60) ||  leadSource.Override_Lead_Source_Rules__c) {
                        account.Lead_Source_USC__pc = leadSource.Lead_Source__c;
                        account.Lead_Source_Detail_USC__pc = leadSource.Lead_Source_Detail__c;
                        account.Lead_Source_Date_USC__pc = leadSource.Lead_Source_Date__c;
                        account.Offer_USC__pc = leadSource.Offer__c;
                        account.Offer_Type_USC__pc = leadSource.Offer_Type__c;
                        account.Lead_URL_USC__pc = leadSource.URL__c;
                        account.Lead_Source_USC_PREV__pc = currentLeadSource;
                        account.Lead_Source_Detail_USC_PREV__pc = currentLeadSourceDetail;
                        account.Lead_Source_Date_USC_PREV__pc = currentLeadSourceDate;
                    }
                }
            }
        }
        else if (lead != null) {                                            // stamp the lead
            String currentLeadSource = lead.Lead_Source_USC__c;
            String currentLeadSourceDetail = lead.Lead_Source_Detail_USC__c;
            Date currentLeadSourceDate = lead.Lead_Source_Date_USC__c;
            String currentOffer = lead.Offer_USC__c;
            String currentOfferType = lead.Offer_Type_USC__c;
            String currentURL = lead.URL_USC__c;
            
            String previousLeadSource = lead.Lead_Source_USC_PREV__c;
            String previousLeadSourceDetail = lead.Lead_Source_Detail_USC_PREV__c;
            Date previousLeadSourceDate = lead.Lead_Source_Date_USC_PREV__c;
            
            // stamp the lead with info
            if (currentLeadSource == null) {
                lead.Lead_Source_USC__c = leadSource.Lead_Source__c;
                lead.Lead_Source_Detail_USC__c = leadSource.Lead_Source_Detail__c;
                lead.Lead_Source_Date_USC__c = leadSource.Lead_Source_Date__c;
                lead.Offer_USC__c = leadSource.Offer__c;
                lead.Offer_Type_USC__c = leadSource.Offer_Type__c;
                lead.URL_USC__c = leadSource.URL__c;
                //lead.IP_Address__c = leadSource.IP_Address__c;
            }
            else {
                if (currentLeadSourceDate == null || (leadSource.Lead_Source_Date__c != null && currentLeadSourceDate.daysBetween(leadSource.Lead_Source_Date__c) > 60) || leadSource.Override_Lead_Source_Rules__c) {
                    lead.Lead_Source_USC__c = leadSource.Lead_Source__c;
                    lead.Lead_Source_Detail_USC__c = leadSource.Lead_Source_Detail__c;
                    lead.Lead_Source_Date_USC__c = leadSource.Lead_Source_Date__c;
                    lead.Offer_USC__c = leadSource.Offer__c;
                    lead.Offer_Type_USC__c = leadSource.Offer_Type__c;
                    lead.URL_USC__c = leadSource.URL__c;
                    //lead.IP_Address__c = leadSource.IP_Address__c;
                    lead.Lead_Source_USC_PREV__c = currentLeadSource;
                    lead.Lead_Source_Detail_USC_PREV__c = currentLeadSourceDetail;
                    lead.Lead_Source_Date_USC_PREV__c = currentLeadSourceDate;
                }
            }
        }
    }
    
    /**
    *   This is a method that stamps LMFS info on the lead or account
    */
    public void stampOriginalLMFS(Lead_Sources__c leadSource) {
        Account account = this.accountMap.get(leadSource.Account__c);
        Lead lead = this.leadMap.get(leadSource.Lead__c);
        
        if (account != null) {
            String currentLeadSource = account.Lead_Source_LMFS__c;
            String currentLeadSourceDetail = account.Lead_Source_Detail_LMFS__c;
            Date currentLeadSourceDate = account.Lead_Source_Date_LMFS__c;
            String currentOffer = account.Offer_LMFS__c;
            String currentOfferType = account.Offer_Type_LMFS__c;
            String currentURL = account.Lead_URL_LMFS__c;
            
            String previousLeadSource = account.Lead_Source_LMFS_PREV__c;
            String previousLeadSourceDetail = account.Lead_Source_Detail_LMFS_PREV__c;
            Date previousLeadSourceDate = account.Lead_Source_Date_LMFS_PREV__c;
            
            if (account.PB_WonRegardless_Live_Market_Fx_Sess__c == null || leadSource.Lead_Source_Date__c <= account.PB_WonRegardless_Live_Market_Fx_Sess__c ||  leadSource.Override_Lead_Source_Rules__c) {
                if (currentLeadSource == null) {
                    account.Lead_Source_LMFS__c = leadSource.Lead_Source__c;
                    account.Lead_Source_Detail_LMFS__c = leadSource.Lead_Source_Detail__c;
                    account.Lead_Source_Date_LMFS__c = leadSource.Lead_Source_Date__c;
                    account.Offer_LMFS__c = leadSource.Offer__c;
                    account.Offer_Type_LMFS__c = leadSource.Offer_Type__c;
                    account.Lead_URL_LMFS__c = leadSource.URL__c;
                    
                }
                else {
                    if (currentLeadSourceDate == null || (leadSource.Lead_Source_Date__c != null && currentLeadSourceDate.daysBetween(leadSource.Lead_Source_Date__c) > 60) ||  leadSource.Override_Lead_Source_Rules__c) {
                        account.Lead_Source_LMFS__c = leadSource.Lead_Source__c;
                        account.Lead_Source_Detail_LMFS__c = leadSource.Lead_Source_Detail__c;
                        account.Lead_Source_Date_LMFS__c = leadSource.Lead_Source_Date__c;
                        account.Offer_LMFS__c = leadSource.Offer__c;
                        account.Offer_Type_LMFS__c = leadSource.Offer_Type__c;
                        account.Lead_URL_LMFS__c = leadSource.URL__c;
                        account.Lead_Source_LMFS_PREV__c = currentLeadSource;
                        account.Lead_Source_Detail_LMFS_PREV__c = currentLeadSourceDetail;
                        account.Lead_Source_Date_LMFS_PREV__c = currentLeadSourceDate;
                    }
                }
            }
        }
        else if (lead != null) {                                            // stamp the lead
            String currentLeadSource = lead.Lead_Source_LMFS__c;
            String currentLeadSourceDetail = lead.Lead_Source_Detail_LMFS__c;
            Date currentLeadSourceDate = lead.Lead_Source_Date_LMFS__c;
            String currentOffer = lead.Offer_LMFS__c;
            String currentOfferType = lead.Offer_Type_LMFS__c;
            String currentURL = lead.URL_LMFS__c;
            
            String previousLeadSource = lead.Lead_Source_LMFS_PREV__c;
            String previousLeadSourceDetail = lead.Lead_Source_Detail_LMFS_PREV__c;
            Date previousLeadSourceDate = lead.Lead_Source_Date_LMFS_PREV__c;
            
            
            // stamp the lead with info
            if (currentLeadSource == null) {
                lead.Lead_Source_LMFS__c = leadSource.Lead_Source__c;
                lead.Lead_Source_Detail_LMFS__c = leadSource.Lead_Source_Detail__c;
                lead.Lead_Source_Date_LMFS__c = leadSource.Lead_Source_Date__c;
                lead.Offer_LMFS__c = leadSource.Offer__c;
                lead.Offer_Type_LMFS__c = leadSource.Offer_Type__c;
                lead.URL_LMFS__c = leadSource.URL__c;
                lead.IP_Address__c = leadSource.IP_Address__c;
            }
            else {
                if (currentLeadSourceDate == null || (leadSource.Lead_Source_Date__c != null && currentLeadSourceDate.daysBetween(leadSource.Lead_Source_Date__c) > 60) || leadSource.Override_Lead_Source_Rules__c) {
                    lead.Lead_Source_LMFS__c = leadSource.Lead_Source__c;
                    lead.Lead_Source_Detail_LMFS__c = leadSource.Lead_Source_Detail__c;
                    lead.Lead_Source_Date_LMFS__c = leadSource.Lead_Source_Date__c;
                    lead.Offer_LMFS__c = leadSource.Offer__c;
                    lead.Offer_Type_LMFS__c = leadSource.Offer_Type__c;
                    lead.URL_LMFS__c = leadSource.URL__c;
                    lead.IP_Address__c = leadSource.IP_Address__c;
                    lead.Lead_Source_LMFS_PREV__c = currentLeadSource;
                    lead.Lead_Source_Detail_LMFS_PREV__c = currentLeadSourceDetail;
                    lead.Lead_Source_Date_LMFS_PREV__c = currentLeadSourceDate;
                }
            }
        }
    }
}