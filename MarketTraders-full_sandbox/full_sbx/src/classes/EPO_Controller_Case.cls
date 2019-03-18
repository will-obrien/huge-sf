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
\====================================================================================================================*/


public without sharing class EPO_Controller_Case {
    
    private ApexPages.StandardController stdCont {get; set;}
    public Case epoCase {get; set;}
    private Map<Id, Opportunity> oppMap {get; set;}
    private Map<Id, OpportunityLineItem> OLIMap {get; set;}
    private Map<Id, OpportunityLineItemSchedule> schedMap {get; set;}
    
    private Decimal amountTotal {get; set;}
    public Decimal amountPaid {get; private set;}
    public Decimal lastPaymentAmount {get; private set;}
    public Date lastPaymentDate {get; private set;}
    public Boolean oppPresent {get; private set;}
    public Boolean typeCorrect {get; private set;}
    
    public Map<String, String> schedCommTrans = new Map<String, String>();
    
    
    /********************************
    *
    *   constructor
    *
    *   @description: creates instance of the class and aggregates data for display
    * 
    **/
    public EPO_Controller_Case(ApexPages.StandardController sc) {
        // get the opportunity data for the current account
        // get acct id
        this.stdCont = sc;
        List<String> addlFields = new List<String>();
        if (!Test.isRunningTest()) {
            addlFields.add('Opportunity_Link__c');
            addlFields.add('Type');
            stdCont.addFields(addlFields);
        }
        this.epoCase = (Case)stdCont.getRecord();  
        
        typeCorrect = epoCase.Type.equals('EPO') ? true : false;
        oppPresent = epoCase.Opportunity_Link__c != null ? true : false;
        
        // get opportunity info
        oppMap = new Map<Id, Opportunity>([SELECT Id, Name 
                                                FROM Opportunity 
                                                WHERE Id = :epoCase.Opportunity_Link__c]);
        
        // get the OLIs in a map
        OLIMap = new Map<Id, OpportunityLineItem>([SELECT Id, Name, TotalPrice 
                                                    FROM OpportunityLineItem 
                                                    WHERE OpportunityId IN :oppMap.keySet()]);
        
        // get OLI schedules in a map - need all schedules so that next payment can be identified, results are ordered ascending
        schedMap = new Map<Id, OpportunityLineItemSchedule>([SELECT Id, Revenue, ScheduleDate, OpportunityLineItemId, Description 
                                                                    FROM OpportunityLineItemSchedule 
                                                                    WHERE OpportunityLineItemId IN :OLIMap.keySet()
                                                                    ORDER BY ScheduleDate ASC]);
                                                                    
        Map<String, ScheduleCommentTranslation__c> schedulecommentmap = ScheduleCommentTranslation__c.getAll();
        schedCommTrans = new Map<String, String>();
        for (String scomment : schedulecommentmap.keyset()) {
            schedCommTrans.put(schedulecommentmap.get(scomment).Comment_Contains__c,schedulecommentmap.get(scomment).Comment_Meaning__c);
        }
                                                                    
        
        // now have all schedules related to opp products on "payment plan" opportunities for this account
        // calculate account paid and map schedules to OLIs
        amountPaid = 0.0;
        for (OpportunityLineItemSchedule olisched : schedMap.values()) {
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
        amountTotal = 0.0;
        for (OpportunityLineItem oli : OLIMap.values()) {
            amountTotal += oli.TotalPrice;
        }
    }
    
    
    /**************************************
    *
    * @description:
    * getAmountOwed - accessor for amount owed
    *  
    **/
    public Decimal getAmountOwed() {
        return amountTotal - amountPaid;
    }
}