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
*   Date Created:       11/13/2015
*   Author:             Sean Murphy
*   Last Modified:      1/6/2016
*   Last Modified By:   Sean Murphy
*
*   11/13/15 - Class created
*   1/6/15 - corrected null pointer exception when iterating over payment terms list
*   
**********************************************************************************************************************/

public without sharing class PaymentActivityHelper {

    /********************************
    *
    *   constructor
    *
    *   @description: creates instance of the class
    * 
    **/
    
    
    public PaymentActivityHelper() {
    }
    
    
    
    /**************************************
    *
    *   @description:
    *   calcStreaks - calculates the approvals and declines streak and updates the related payment terms
    *  
    *   @param:  pmtActivities - payment activities to drive streak calculation (add'l pmt activities will be queried)
    **/
    public static void calcStreaks(List<Payment_Activity__c> pmtActivities) {
        // get necessary fields for payment terms record associated with this payment 
        Set<Id> termsIds = new Set<Id>();
        for (Payment_Activity__c pa : pmtActivities) {
            if (pa.Payment_Terms__c != null) {
                termsIds.add(pa.Payment_Terms__c);
            }
        }
        
        Map<Id, Payment_Terms__c> terms = new Map<Id, Payment_Terms__c>([SELECT Id, Longest_Streak_Approvals__c, Longest_Streak_Declines__c 
                                                                            FROM Payment_Terms__c 
                                                                            WHERE Id in :termsIds]);
                                                                            
        // get all payments activities for the collected terms
        Map<Id, Payment_Activity__c> activityMap = new Map<Id, Payment_Activity__c>([SELECT Id, Date__c, Outcome__c, Payment_Terms__c
                                                                                        FROM Payment_Activity__c
                                                                                        WHERE Payment_Terms__c in :terms.keySet()
                                                                                        AND (Outcome__c = 'Approved' OR Outcome__c = 'Declined')
                                                                                        ORDER BY Date__c ASC]);
        
        // map activities to term ascending by date
        Map<Id, List<Payment_Activity__c>> termToActivitiesMap = new Map<Id, List<Payment_Activity__c>>();
                                                                            
        for (Payment_Activity__c pa : activityMap.values()) {
            if (pa.Payment_Terms__c != null) {
                if (termToActivitiesMap.containsKey(pa.Payment_Terms__c)) {
                    termToActivitiesMap.get(pa.Payment_Terms__c).add(pa);
                }
                else {
                    List<Payment_Activity__c> newActivityList = new List<Payment_Activity__c>();
                    newActivityList.add(pa);
                    termToActivitiesMap.put(pa.Payment_Terms__c, newActivityList);
                }
            }
        }
        
        // iterate over payment terms
        for (Payment_Terms__c pt : terms.values()) {
            if (termToActivitiesMap.containsKey(pt.Id)) {
                List<Payment_Activity__c> activities = termToActivitiesMap.get(pt.Id);
                Integer tempApprovalStreak = 0;
                Integer maxApprovalStreak = 0;
                Boolean approvalStreakOver = true;
                Integer tempDeclineStreak = 0;
                Integer maxDeclineStreak = 0;
                Boolean declineStreakOver = true;
            
                for (Payment_Activity__c pa : activities) {
                    if (pa.Outcome__c.equals('Approved')) {
                        approvalStreakOver = false;
                        declineStreakOver = true;
                        tempApprovalStreak++;
                        if (tempDeclineStreak > maxDeclineStreak) {
                            maxDeclineStreak = tempDeclineStreak;
                            tempDeclineStreak = 0;
                        }
                    }
                    else if (pa.Outcome__c.equals('Declined')) {
                        declineStreakOver = false;
                        approvalStreakOver = true;
                        tempDeclineStreak++;
                        if (tempApprovalStreak > maxApprovalStreak) {
                            maxApprovalStreak = tempApprovalStreak;
                            tempApprovalStreak = 0;
                        }
                    }
                }
            
                if (tempApprovalStreak > maxApprovalStreak) {
                    pt.Longest_Streak_Approvals__c = tempApprovalStreak;
                }
                else {
                    pt.Longest_Streak_Approvals__c = maxApprovalStreak;
                }
                
                if (tempDeclineStreak > maxDeclineStreak) {
                    pt.Longest_Streak_Declines__c = tempDeclineStreak;
                }
                else {
                    pt.Longest_Streak_Declines__c = maxDeclineStreak;
                }
            }
        }
        
        update terms.values();  
    }
    
    //public Payment_Activity__c[] Payments { get; set; }
    
    public static void aggTotal(List<Payment_Activity__c> paymentList){
        
        Set<Id> oppIds = new Set<Id>();
        List<opportunity> oppsToUpdate = new list<Opportunity>();
        
        // Loop all payment activities and collect the oppIds
        for(Payment_Activity__c paymentInstance : paymentList ) {
            if ( paymentInstance.Opportunity__c != null ) {
                oppIds.add(paymentInstance.Opportunity__c);
            }
        }
        
        // Query all oppIds and related payment activities and total the amounts based on date
        for (opportunity tmp : [select id, closeDate, Same_Day_Cash__c, Same_Month_Cash__c, (select Name, amount__c, Date__c, Outcome__c, Payment_Status__c from payment_activities__r) from opportunity where id IN :oppIds]){
            
            Decimal sameDaytotal = 0;
            Decimal sameMonthTotal = 0;
            
            String paDay;
            String paMonth;
            String paYear;
                
            String oppDay;
            String oppMonth;
            String oppYear;
            
            for(Payment_Activity__c tmpPA : tmp.payment_activities__r){
                //if same day then sameDayTotal += tmpA.Amount__c
                // IF the opportunity closeDate is the same day as the Payment_Activity__c's DAte__c then increment the sameDayTotal by the Payment_Activity__c's Amount__c field
                
                if ((tmpPA.Outcome__c == 'Declined') || (tmpPA.Payment_Status__c == 'Credit')) {
                	System.debug('@@@@ doing nothing.');
                }
                else {
                    paDay = String.valueof(tmpPA.Date__c.Day());
                    paMonth = String.valueof(tmpPA.Date__c.Month());
                    paYear = String.valueof(tmpPA.Date__c.Year());
                
                    oppDay = String.valueof(tmp.closeDate.Day());
                    oppMonth = String.valueof(tmp.closeDate.Month());
                    oppYear = String.valueof(tmp.closeDate.Year());

                    if ((paDay == oppDay) && (paMonth == oppMonth) && (paYear == oppYear)) {
                        sameDayTotal += tmpPA.Amount__c;
                        sameMonthTotal += tmpPA.Amount__c;
                    }
                    else if ((paMonth == oppMonth) && (paYear == oppYear) && (tmpPa.Amount__c != null)) { 
                        sameMonthTotal += tmpPA.Amount__c;
                    }
                }

                //if same month then sameMonthTotal += tmpA.amount__c
                //// IF the opportunity closeDate is the same month as the Payment_Activity__c's DAte__c then increment the sameDayTotal by the Payment_Activity__c's Amount__c
            }
            
            tmp.Same_Day_Cash__c = sameDaytotal;
            tmp.Same_Month_Cash__c = sameMonthtotal;
            oppsToUpdate.add(tmp); 
        }
        
        update oppsToUpdate;
        
        return;
    }
    
    public static void createCashReceipt(List<Payment_Activity__c> paymentList){
            Set<Id> oppIds = new Set<Id>();
             for(Payment_Activity__c pa: paymentList){
                oppIds.add(pa.opportunity__c);
             }
             
             List<AcctSeed__Accounting_Period__c> accountPeriod = [
                    SELECT id ,AcctSeed__Start_Date__c ,AcctSeed__End_Date__c 
                    from AcctSeed__Accounting_Period__c 
                    where AcctSeed__Status__c = 'Open'
                    order by AcctSeed__Start_Date__c asc
                    
                ];
                
            List<AcctSeed__GL_Account__c> bankingAccount = [SELECT id,name from AcctSeed__GL_Account__c where   Name like '1260%'   ];
             
             List<opportunity> opps = [select id,accountID from opportunity where id in : oppIds];
            
            List<AcctSeed__Cash_Receipt__c> cashReceipts = new List<AcctSeed__Cash_Receipt__c>();      
            for(Payment_Activity__c pa: paymentList){
                if(pa.Payment_Status__c == 'paid'){
                    //cash receipt
                    
                    

                    AcctSeed__Cash_Receipt__c newCR = new AcctSeed__Cash_Receipt__c();
                    //get accounting period
                    for(AcctSeed__Accounting_Period__c ap :accountPeriod){
                        if(ap.AcctSeed__Start_Date__c <= pa.date__c && ap.AcctSeed__End_Date__c >= pa.date__c){
                            newCR.AcctSeed__Accounting_Period__c = ap.id;
                        }
                    
                    }
                    if(newCR.AcctSeed__Accounting_Period__c == null){
                            newCR.AcctSeed__Accounting_Period__c = accountPeriod[0].id;
                    }
                    
                    for(opportunity o:opps){
                        if(o.id == pa.opportunity__c){
                            newCR.AcctSeed__Account__c = o.accountid;
                        }
                    }
                    
                    newCR.AcctSeed__Amount__c = pa.amount__c;
                    if(pa.Authorization_Decline_Number__c != null){
                        newCR.AcctSeed__Payment_Reference__c = pa.Authorization_Decline_Number__c;
                    } else {
                        newCR.AcctSeed__Payment_Reference__c = 'Required';
                    }
                    
                    newCr.AcctSeed__Bank_Account__c = bankingAccount[0].id;
                    cashReceipts.add(newCR);
                    
                }
             }
             insert cashReceipts;
            
        
        return;
    }
    
}