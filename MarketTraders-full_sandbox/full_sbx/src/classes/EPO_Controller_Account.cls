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
*   Date Created:       8/26/2015
*   Author:             Sean Murphy
*   Last Modified:      9/22/2015
*   Last Modified By:   Sean Murphy
*
*   9/22/2015 - Code cleanup 
*   
**********************************************************************************************************************/

/*====================================================================================================================\
|   Design notes
|   The data for the EPO is going to come from the Account's opportunities.  The fields that are of concern are:
|       1)  Total Amount Paid for all opportunities     // calc from schedules (how do we handle different comments, i.e., Paid, Default, etc.)
|       2)  Total Amount Owed for all opportunities     // calc from schedules and olis
|       3)  Last Payment Amount for any opportunity     // pull from schedules
|       4)  Last Payment Date for any opportunity       // pull from schedules
|
|   Additionally, the user needs to be presented the following for each opp line item/opp for the account:
|       1)  Plan sub-status
|       2)  Amount Paid
|       3)  Amount Owed
|       4)  Last Payment Amount
|       5)  Last Payment Date
|       6)  Next Payment Amount
|       7)  Next Payment Date
|       8)  Number of payments remaining
|
\====================================================================================================================*/


public without sharing class EPO_Controller_Account {
    
    private ApexPages.StandardController stdCont {get; set;}
    private Account acct {get; set;}
    private Map<Id, Opportunity> oppMap {get; set;}
    private Map<Id, OpportunityLineItem> OLIMap {get; set;}
    private Map<Id, Product2> prodMap {get; set;}
    private Map<Id, PricebookEntry> pbeMap {get; set;}
    private Map<Id, OpportunityLineItemSchedule> schedMap {get; set;}
    private Map<Id, List<OpportunityLineItemSchedule>> oliSchedMap {get; set;}
    private List<OppLineItemWrapper> oliWrapList {get; private set;}
    
    private Decimal accountTotal {get; set;}
    public Decimal amountPaid {get; private set;}
    public Decimal lastPaymentAmount {get; private set;}
    public Date lastPaymentDate {get; private set;}
    public Boolean oppDataPresent {get; set;}
    
    public Map<String, String> schedCommTrans = new Map<String, String>();
    
    /********************************
    *
    *   constructor
    *
    *   @description: creates instance of the class and aggregates data for display
    * 
    **/
    public EPO_Controller_Account(ApexPages.StandardController sc) {
        // get the opportunity data for the current account
        // get acct id
        this.stdCont = sc;
        this.acct = (Account)stdCont.getRecord();
        
        // get the related opportunities in a map (only sub-stage of "payment plan")
        oppMap = new Map<Id, Opportunity>([SELECT Id, Name 
                                                    FROM Opportunity 
                                                    WHERE AccountId = :acct.Id AND Sub_Stage__c = 'Payment Plan']);
        
        System.debug('@@@ oppMap.size: ' + oppMap.size());
                                                    
        if (oppMap.size() > 0) {
            oppDataPresent = true;
        }
        
        // get the OLIs in a map
        OLIMap = new Map<Id, OpportunityLineItem>([SELECT Id, Name, TotalPrice, Product2Id, PricebookEntryId 
                                                    FROM OpportunityLineItem 
                                                    WHERE OpportunityId IN :oppMap.keySet()]);
                                                    
        System.debug('@@@ oli map size: ' + OLIMap.size());
                                                    
        // get products and pricebook entries
        Set<Id> prodIds = new Set<ID>();
        Set<Id> pbeIds = new Set<Id>();
        for (OpportunityLineItem oli : OLIMap.values()) {
            prodIds.add(oli.Product2Id);
            pbeIds.add(oli.PricebookEntryId);
        }
        
        prodMap = new Map<Id, Product2>([SELECT Id, Name FROM Product2 WHERE Id in :prodIds]);
        
        // get pricebook entries
        pbeMap = new Map<Id, PricebookEntry>([SELECT Id, Name FROM PricebookEntry WHERE Id in :pbeIds]);
        
        // get OLI schedules in a map - need all schedules so that next payment can be identified, results are ordered ascending
        schedMap = new Map<Id, OpportunityLineItemSchedule>([SELECT Id, Revenue, ScheduleDate, OpportunityLineItemId, Description
                                                                    FROM OpportunityLineItemSchedule 
                                                                    WHERE OpportunityLineItemId IN :OLIMap.keySet()
                                                                    ORDER BY ScheduleDate ASC]);
                                                                    
        System.debug('@@@ schedMap size: ' + schedMap.size());
  
        Map<String, ScheduleCommentTranslation__c> schedulecommentmap = ScheduleCommentTranslation__c.getAll();
        schedCommTrans = new Map<String, String>();
        for (String scomment : schedulecommentmap.keyset()) {
            schedCommTrans.put(schedulecommentmap.get(scomment).Comment_Contains__c, schedulecommentmap.get(scomment).Comment_Meaning__c);
        }
        
        // now have all schedules related to opp products on "payment plan" opportunities for this account
        // calculate account paid and map schedules to OLIs
        amountPaid = 0.0;
        oliSchedMap = new Map<Id, List<OpportunityLineItemSchedule>>();
        for (OpportunityLineItemSchedule olisched : schedMap.values()) {
            System.debug('@@@ processing oli schedule with id: ' + olisched.Id);
            if (oliSchedMap.containsKey(olisched.OpportunityLineItemId)) {
                oliSchedMap.get(olisched.OpportunityLineItemId).add(olisched);
            }
            else {
                List<OpportunityLineItemSchedule> schedList = new List<OpportunityLineItemSchedule>();
                schedList.add(olisched);
                oliSchedMap.put(olisched.OpportunityLineItemId, schedList);
            }
            
            if ((olisched.ScheduleDate <= Date.today()) && (olisched.Revenue != null)) {
                System.debug('@@@ adding revenue to account paid: ' + olisched.Revenue); 
                String comment = olisched.Description.toLowerCase().trim();
                if (schedCommTrans.containskey(comment)) {
                    if (schedCommTrans.get(comment).toLowerCase().equals('paid')) { 
                        amountPaid += olisched.Revenue;
                        lastPaymentAmount = olisched.Revenue;
                        lastPaymentDate = olisched.ScheduleDate;
                    }
                }
            }
        }
        
        // calculate account balance and wrap the OLI
        accountTotal = 0.0;
        oliWrapList = new List<OppLineItemWrapper>();
        for (OpportunityLineItem oli : OLIMap.values()) {
            oliWrapList.add(wrapOLI(oli));
            accountTotal += oli.TotalPrice;
        }
        
        System.debug('@@@ OLI wrap list size:' + oliWrapList.size());
    }
    
    
    /**************************************
    *
    *   @description:
    *   wrapOLI - wraps opportunity line items for use in visualforce page
    *  
    *   @param:  oli - opportunity line item to be wrapped in wrapper class
    **/
    private OppLineItemWrapper wrapOLI(OpportunityLineItem oli) {
        OppLineItemWrapper oliWrap = new OppLineItemWrapper();
        oliWrap.OLI = oli;
        
        // IF USING PRODUCT NAME UNCOMMENT THIS AND COMMENT THE PRICEBOOK ENTRY NAME SECTION IMMEDIATELY BELOW
//      if (prodMap.containsKey(oli.Product2Id)) {
//          oliWrap.product = prodMap.get(oli.Product2Id).Name;
//      }
//      else {
//          oliWrap.product = 'Unknown';
//      }
        
        // IF USING PRICEBOOK ENTRY NAME UNCOMMENT THIS AND COMMENT THE PRODUCT NAME SECTION IMMEDIATELY ABOVE
        if (pbeMap.containsKey(oli.PricebookEntryId)) {
            oliWrap.product = pbeMap.get(oli.PricebookEntryId).Name;
        }
        else {
            oliWrap.product = 'Unknown';
        }
        
        Date currDate = Date.today();
        if (oliSchedMap.containsKey(oli.Id)) {
            for (OpportunityLineItemSchedule os : oliSchedMap.get(oli.Id)) {
             String comment = os.Description.toLowerCase().trim();
                if ((os.ScheduleDate <= currDate) && (os.Revenue != 0.0)) {               
                    if (schedCommTrans.containskey(comment)) {
                         if (schedCommTrans.get(comment) == 'paid'){
                            oliWrap.amtPaid += os.Revenue;
                            oliWrap.lastPmtAmt = os.Revenue;
                            oliWrap.lastPmtDate = os.ScheduleDate;
                         }
                    }
                }
                
                if ((os.ScheduleDate > currDate) && (oliWrap.nextPmtAmt == null) && (oliWrap.nextPmtDate == null)) {
                    if (os.Revenue != null) {
                        oliWrap.nextPmtAmt = os.Revenue;
                    }
                    
                    if (os.ScheduleDate != null) {
                        oliWrap.nextPmtDate = os.ScheduleDate;
                    }
                }
                
                // increment remaining payments
                if ((!os.Description.toLowerCase().contains('paid')) && (os.Revenue != null) && (os.ScheduleDate != null)) {
                    if(schedCommTrans.containskey(comment)){
                        if ((!schedCommTrans.get(comment).toLowerCase().equals('paid')) || (!schedCommTrans.get(comment).toLowerCase().equals('discount'))) {
                            oliWrap.pmtsRemaining++;
                        }
                    }
                }
            }
        }
        
        oliWrap.amtOwed = oli.TotalPrice - oliWrap.amtPaid;
        
        return oliWrap;
    }
    
    
    /**************************************
    *
    *   @description:
    *   getAmountOwed - accessor for amount owed
    *  
    **/
    public Decimal getAmountOwed() {
        return accountTotal - amountPaid;
    }
    
    
    /**************************************
    *
    *   @description:
    *   getSortedOLIWraps - accessor for sorted list of opportunity line item wrappers
    *  
    **/
    public List<OppLineItemWrapper> getSortedOLIWraps() {
        if (oliWrapList != null) {
            if (oliWrapList.size() > 1) {
                oliWrapList.sort();
            }
            return oliWrapList;
        }
        else {
            return new List<OppLineItemWrapper>();
        }
    }
    
    
    
    /**************************************
    *
    *   @description:
    *   OppLineItemWrapper - wrapper class for opportunity line items
    *  
    **/
    public class OppLineItemWrapper implements Comparable {
        
        public OpportunityLineItem OLI {get; set;}
        public String status {get; set;}
        public String product {get; set;}
        public Decimal amtPaid {get; set;}
        public Decimal amtOwed {get; set;}
        public Decimal lastPmtAmt {get; set;}
        public Date lastPmtDate {get; set;}
        public Decimal nextPmtAmt {get; set;}
        public Date nextPmtDate {get; set;}
        public Decimal pmtsRemaining {get; set;}
        
        public OppLineItemWrapper() {
            OLI = null;
            status = '';
            product = '';
            amtPaid = 0.0;
            amtOwed = 0.0;
            lastPmtAmt = null;
            lastPmtDate = null;
            nextPmtAmt = null;
            nextPmtDate = null;
            pmtsRemaining = 0;
        }
        

        /**************************************
        *
        *   @description:
        *   compareTo - comparable interface methods (this sorts descending based on last payment date)
        *
        *   @param: Object - object to be compared with this instance
        *
        **/
        public Integer compareTo(Object compareTo) {
            OppLineItemWrapper compareToWrap = (OppLineItemWrapper)compareTo;
            if (nextPmtDate == compareToWrap.nextPmtDate) {
                return 0;
            }
            
            if (nextPmtDate > compareToWrap.nextPmtDate) {
                return 1;
            }
            
            return -1;
        }
    }
}