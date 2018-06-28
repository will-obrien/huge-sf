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
*   Date Created:       12/29/2015
*   Author:             Coastal Cloud
*   Last Modified:      4/4/2015
*   Last Modified By:   Sean Murphy
*
*   11/17/15 - coastal cloud: Class created (outsourced)
*   11/17-11/23/15 - sm: Implementation of required functionality
*   11/24/15 - sm: Code cleanup, comments completed
*	3/21/16  - sm: implemented merchant integration functionality
*	4/4/16   - sm: code cleanup
*   
**********************************************************************************************************************/

public with sharing class PaymentTermsController { 

    private static final Integer MAX_DOWNPAYMENTS = 4;
    private static final Integer DAILY = 1;
    private static final Integer WEEKLY = 7;
    private static final Integer BIWEEKLY = 14;

    public String oppId {get; set;}
    public List<Opportunity> opp {get; private set;}
    public Payment_Terms__c newTerms {get; set;}
    private List<Payment_Terms__c> activeTerms {get; set;}
    public List<AcctSeed__Billing__c> billing {get; private set;}
    private List<Payment_Terms__c> termsForUpsert {get; set;}
    private Boolean isPendingTerms {get; set;}
    
    public List<PlannedPaymentWrapper> downPaymentWraps {get; set;}
    public List<PlannedPaymentWrapper> regPaymentWraps {get; set;}
    public List<OpportunityLineItem> oppProducts {get; set;}
    
    public Integer numOfDownPayments {get; set;}
    public Integer numOfRegPayments {get; set;}
    public Decimal discount {get; set;}
    public Date dpStartDate {get; set;}
    public Date regStartDate {get; set;}
    public String dpFrequency {get; set;}
    public String regFrequency {get; set;}
    public Decimal totalOfDownpayments {get; set;}
    public Decimal totalOfRegPayments {get; set;}
    public String dpCalcType {get; set;}
    public String regCalcType {get; set;}
    
    public Boolean showDPCountError {get; set;}
    public Boolean showDPMaxError {get; set;}
    public Boolean showDPDateError {get; set;}
    public Boolean showDPTotalError {get; set;}
    public Boolean showRegCountError {get; set;}
    public Boolean showRegDateError {get; set;}
    public Boolean showRegTotalError {get; set;}
    
    public Boolean disableDP {get; set;}
    public Boolean disableReg {get; set;}
    
    private Boolean stampFirstTermInfoOnOpp {get; set;}
    
    private static List<String> allowedProfileNames;
    private static Map<Id, Profile> userProfilesMap;
    public Boolean allowedProfile {get; private set;}
    
    
    /********************************
    *
    *   constructor
    *
    *   @description: creates instance of the class
    * 
    **/
    public PaymentTermsController() {
    }
    
    
    /**************************************
    *
    *   @description:
    *   init - inits data for use within page
    *  
    **/
    public void init() {
        oppId = ApexPages.currentPage().getParameters().get('oid');
        isPendingTerms = false;
        
        allowedProfileNames = new List<String>{'System Administrator', 'MTI SF Automation', 'MTI Administrative Assistant', 'MTI Accounting (level 2)', 'MTI Accounting (Management)', 'MTI Accounting (Payables)', 'MTI Accounting (reporting)', 'MTI Manager (Corporate)', 'MTI Manager (Department)'};
        userProfilesMap = new Map<Id, Profile>([SELECT Id, Name FROM Profile WHERE Name in :allowedProfileNames]);
        
        String profId = UserInfo.getProfileId();
        
        if (userProfilesMap.containsKey(profId)) {
        	allowedProfile = true;
        }
        else {
        	allowedProfile = false;
        }
        
        // get related records
        if (!String.isBlank(oppId)) {
            opp = [SELECT Id, Name, AccountId, amount, Remaining_Balance__c, Sale_Invoice_Qty_Payments_After_Down__c, Sale_Invoice_First_Date_After_Down__c,
            			ptsTotalDownPmts__c, ptsTotalAfterDownPmts__c 
            		FROM Opportunity WHERE Id = :oppId LIMIT 1];
            		
            if (opp.size() > 0) {
                billing = [SELECT Id, Name FROM AcctSeed__Billing__c WHERE AcctSeed__Opportunity__c = :oppId LIMIT 1];
                activeTerms = [SELECT Id, Name, Active__c, Payment_Terms_Type__c FROM Payment_Terms__c WHERE  Active__c = true and Opportunity__c =: opp[0].Id LIMIT 1];
            }
            if (billing.size() > 0) {
                //activeTerms = [SELECT Id, Name, Active__c FROM Payment_Terms__c WHERE Billing__c = :billing[0].Id AND Active__c = true LIMIT 1];
                
            }
        }
        
        // init payment terms
        termsForUpsert = new List<Payment_Terms__c>();
        newTerms = new Payment_Terms__c();
        
        if(activeTerms != null && activeTerms.size() > 0) {
        	if (activeTerms[0].Payment_Terms_Type__c == 'Pending') {
        		System.debug('@@@@ pending terms were found.');
				newTerms.First_Payment_Term__c = true;
				activeTerms[0].Payment_Terms_Type__c = null;
				newTerms = activeTerms[0];
				isPendingTerms = true;       		
        	}
        	else {
	            newTerms.First_Payment_Term__c = false;
        	}
        }
        else {
            newTerms.First_Payment_Term__c = true;
        }

		stampFirstTermInfoOnOpp = newTerms.First_Payment_Term__c;
        
        if ((opp != null) && (opp.size() > 0) && (!isPendingTerms)) {
            newTerms.Opportunity__c = opp[0].Id;
            newTerms.Account__c = opp[0].AccountId;
        }
        
        newTerms.Active__c = true;
                
        if ((billing != null) && (billing.size() > 0)) {
            newTerms.Billing__c = billing[0].Id;
        }
        
        termsForUpsert.add(newTerms);
        
        oppProducts = [SELECT ID, Quantity, UnitPrice, Description, PriceBookEntry.Product2.Name, discount, ListPrice, totalPrice      
            			FROM OpportunityLineItem 
            			WHERE opportunityid =: opp[0].id];
        
        if ((activeTerms != null) && (activeTerms.size() > 0) && (!isPendingTerms)) {
            activeTerms[0].Date_Voided__c = Date.today();
            activeTerms[0].Active__c = false;
            termsForUpsert.add(activeTerms[0]);
            totalOfRegPayments = opp[0].Remaining_Balance__c;
        }
        else {
            totalOfRegPayments = oppProducts[0].TotalPrice;
        }
        
        //calc payment amount ??
        
        // init page variables
        downPaymentWraps = new List<PlannedPaymentWrapper>();
        regPaymentWraps = new List<PlannedPaymentWrapper>();
        numOfDownPayments = null;
        numOfRegPayments = null;
        dpFrequency = 'Daily';
        regFrequency = 'Monthly';
        totalOfDownpayments = null;
        //totalOfRegPayments = null;
        dpCalcType = 'Auto';
        regCalcType = 'Auto';
        disableDP = false;
        disableReg = false;
        //discount = 0;
    }
    
    
    /**************************************
    *
    *   @description:
    *   getFrequencies - accessor for payment frequencies for radio buttons
    *  
    **/
    public List<SelectOption> getRegFrequencies() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Monthly','Monthly'));
        options.add(new SelectOption('BiWeekly','Bi-Weekly'));
        options.add(new SelectOption('Weekly','Weekly'));
        options.add(new SelectOption('Custom','Custom')); 
        return options;
    }
    
    
    /**************************************
    *
    *   @description:
    *   getFrequencies - accessor for payment frequencies for radio buttons
    *  
    **/
    public List<SelectOption> getDPFrequencies() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Daily','Daily'));
        options.add(new SelectOption('Weekly','Weekly'));
        options.add(new SelectOption('BiWeekly','Bi-Weekly'));
        options.add(new SelectOption('Custom','Custom')); 
        return options;
    }
    
    
    /**************************************
    *
    *   @description:
    *   getCalcTypes - accessor for calculation types for radio buttons
    *  
    **/
    public List<SelectOption> getCalcTypes() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Manual','Manual'));
        options.add(new SelectOption('Auto','Auto (Evenly Divided)'));
        return options;
    }
    
    
    /**************************************
    *
    *   @description:
    *   createDPWrappers - creates wrappers for planned payments based on terms entered for down payments
    *  
    **/
    public void createDPWrappers() {
        // handle no number of payments error
        if ((numOfDownPayments == null) || (numOfDownPayments <= 0)) {
            showDPCountError = true;
        }
        else {
            showDPCountError = false;
        }
        
        // handle too many payments error
        if (numOfDownPayments > MAX_DOWNPAYMENTS) {
            showDPMaxError = true;
        }
        else {
            showDPMaxError = false;
        }
        
        // handle no date error
        if (dpStartDate == null) {
            showDPDateError = true;
        }
        else {
            showDPDateError = false;
        }
        
        // handle no total amount error
        if ((totalOfDownpayments == null) || (totalOfDownpayments <= 0)) {
            showDPTotalError = true;
        }
        else {
            showDPTotalError = false;
        }
        
        if ((!showDPCountError) && (!showDPMaxError) && (!showDPDateError) && (!showDPTotalError)) {
            downPaymentWraps = new List<PlannedPaymentWrapper>();
            createPaymentWraps(totalOfDownpayments, numOfDownPayments, dpCalcType, downPaymentWraps, dpStartDate, dpFrequency, true);
            disableDP = true;
        }
    }
    
    
    /**************************************
    *
    *   @description:
    *   createRegWrappers - creates wrappers for planned payments based on terms entered for regular payments
    *  
    **/
    public void createRegWrappers() {
        // handle no number of payments error
        if ((numOfRegPayments == null) || (numOfRegPayments <= 0)) {
            showRegCountError = true;
        }
        else {
            showRegCountError = false;
        }
        
        // handle no date error
        if (regStartDate == null) {
            showRegDateError = true;
        }
        else {
            showRegDateError = false;
        }
        
        // handle no total amount error
        if ((totalOfRegPayments == null) || (totalOfRegPayments <= 0)) {
            showRegTotalError = true;
        }
        else {
            showRegTotalError = false;
        }
        
        if ((!showRegCountError) && (!showRegDateError) && (!showRegTotalError)) {
            regPaymentWraps = new List<PlannedPaymentWrapper>();
            createPaymentWraps(totalOfRegPayments, numOfRegPayments, regCalcType, regPaymentWraps, regStartDate, regFrequency, false);
            disableReg = true;
        }
    }
    
    
    /**************************************
    *
    *   @description:
    *   createPaymentWraps - builds a list of planned payments and wrappers
    *  
    *   @param:  totalOfPayments - the expected total of the planned payments
    *   @param:  numberOfPayments - the number of payment wrappers to created
    *   @param:  calcType - the calculation type to be applied to the payments
    *   @param:  wrapList - list of payment wrappers being processed
    *   @param:  startDate - the original start date for the sequence 
    *   @param:  frequency - the frequency of the planned payments
    *   @param:  isDownpayment - flag indicating if downpayments are being processed
    **/
    public void createPaymentWraps(Decimal totalOfPayments, Integer numberOfPayments, String calcType, List<PlannedPaymentWrapper> wrapList, Date startDate, String frequency, Boolean isDownpayment) {
        Planned_Payment__c pmt;
        PlannedPaymentWrapper pmtWrap;
        Decimal paymentPer;
        
        if (calcType.equals('Auto')) {
            paymentPer = totalOfPayments / numberOfPayments;
        }
        
        System.debug('@@@ payment per: ' + paymentPer);
        
        Decimal totalAdded = 0;
        for (Integer i = 0; i < numberOfPayments; i++) {
            pmt = new Planned_Payment__c();
            if (calcType.equals('Auto')) {
                pmt.Amount_Due__c = paymentPer.setScale(2);
                totalAdded += pmt.Amount_Due__c;
                System.debug('@@@ totalAdded for payment ' + (i+1) + ':' + totalAdded);
                // if last payment
                if ((numberOfPayments > 1) && (i+1 == numberOfPayments)) {
                    if ((totalOfPayments - totalAdded) >= 0) {
                        wrapList[0].payment.Amount_Due__c += (totalOfPayments - totalAdded);
                    }
                    else {
                        pmt.Amount_Due__c += (totalOfPayments - totalAdded);            
                    }
                }
            }
            else {
                pmt.Amount_Due__c = 0;
            }
            
            pmt.Status__c = 'Scheduled';
            pmt.Down_Payment__c = isDownpayment;
            if(isDownpayment){
                pmt.PP_Type__c = 'Down Payment';
            } else {
                pmt.PP_Type__c = 'Recurring Payment';
            }
            pmt.Due_Date__c = getSequenceDate(i, startDate, frequency);
            
            pmtWrap = new PlannedPaymentWrapper(i+1, pmt);
            System.debug('@@@ adding payment number ' + (i+1) + ' with contents ' + pmt);
            wrapList.add(pmtWrap);
        }
        
        // set next due
        setNextDue();
    }
    
    
    /**************************************
    *
    *   @description:
    *   setNextDue - determines the appropriate "next due" planned payment and sets status accordingly
    *  
    **/
    private void setNextDue() {
        if (downPaymentWraps.size() > 0) {
            if (regPaymentWraps.size() > 0) {
                regPaymentWraps[0].payment.Status__c = 'Scheduled';
            }
            downPaymentWraps[0].payment.Status__c = 'Next Due';
        }
        else if (regPaymentWraps.size() > 0) {
            regPaymentWraps[0].payment.Status__c = 'Next Due';
        }
    }
    
        
    /**************************************
    *
    *   @description:
    *   getSequenceDate - generates next date in sequence for a planned payment
    *  
    *   @param:  sequence - the index in the sequence of planned payments
    *   @param:  startDate - the original start date for the sequence
    *   @param:  frequency - the frequency of the planned payments
    **/
    public Date getSequenceDate(Integer sequence, Date startDate, String frequency) {
        if (frequency.equals('Daily')) {
            return startDate.addDays(sequence * DAILY);
        }
        else if (frequency.equals('Weekly')) {
            return startDate.addDays(sequence * WEEKLY);
        }
        else if (frequency.equals('BiWeekly')) {
            return startDate.addDays(sequence * BIWEEKLY);
        }
        else if (frequency.equals('Monthly')) {
            // increment month by sequence
            Date newDate = startDate.addMonths(sequence);
            // if day <= last day of month, use it (need month and year)
            if (startDate.day() > Date.daysInMonth(newDate.year(), newDate.month())) {
                newDate = Date.newInstance(newDate.year(), newDate.month(), Date.daysInMonth(newDate.year(), newDate.month()));
            }
            return newDate;
        }
        else {
            return null;
        }
    }
    
    
    /**************************************
    *
    *   @description:
    *   createTermsAndPlannedPayments - inserts/upserts the payment terms and planned payments
    *  
    **/
    public PageReference createTermsAndPlannedPayments() {
        
        // if totals do not match, pop dialog/create error message
        
        //calculate discount - if first term or switching terms
        if ((activeTerms != null) && (activeTerms.size() > 0) && (!isPendingTerms)) {
        	discount = opp[0].Remaining_Balance__c - (getTotalOfPlannedRegPayments() + getTotalOfPlannedDownPayments());
        } else {
           // discount = oppProducts[0].listPrice - oppProducts[0].unitPrice;
            discount = (oppProducts[0].listPrice * oppProducts[0].quantity) - (oppProducts[0].unitPrice * oppProducts[0].quantity);
        }
        
        if (newTerms == null) {
            // prompt user that terms OR no payments have been created
            termsForUpsert.clear();
        }
        else {
            for(Payment_Terms__c pt : termsForUpsert){
                if (pt.active__c) {
                    pt.discount__c = discount;
                    pt.Sales_Price__c = getTotalOfPlannedRegPayments() + getTotalOfPlannedDownPayments();
                    pt.Terms_Number_of_Payments_Not_inc_Down__c = numOfRegPayments;
                }
            }
            
            upsert termsForUpsert;
        }
        
        Planned_Payment__c payment;
        List<Planned_Payment__c> newPayments = new List<Planned_Payment__c>();
        Decimal downPaymentTotal = 0;
        if (termsForUpsert.size() > 0) {
            if (downPaymentWraps.size() > 0) {
            	downPaymentWraps.sort();
                for (PlannedPaymentWrapper dpw : downPaymentWraps) {
                    if (dpw.payment != null) {
                    	if (dpw.payment.Amount_Due__c != null) {
                    		downPaymentTotal += dpw.payment.Amount_Due__c;
                    	}
                    	
                    	dpw.payment.Payment_Terms__c = newTerms.Id;
                        newPayments.add(dpw.payment);
                    }
                }   
            }
            
            Decimal regPmtCount = 0;
            Decimal regPmtTotal = 0;
            Date firstRegPmtDate = null;
            if (regPaymentWraps.size() > 0) {
                // create the planned payments
                for (PlannedPaymentWrapper pw : regPaymentWraps) {
                    if (pw.payment != null) {
                    	regPmtCount++;
                        pw.payment.Payment_Terms__c = newTerms.Id;
                        newPayments.add(pw.payment);
                        
                        if (firstRegPmtDate == null) {
                        	firstRegPmtDate = pw.payment.Due_Date__c;
                        }
                        else if ((pw.payment.Due_Date__c != null) && (pw.payment.Due_Date__c < firstRegPmtDate)) {
                        	firstRegPmtDate = pw.payment.Due_Date__c;
                        }
                        
                        if (pw.payment.Amount_Due__c != null) {
                        	regPmtTotal += pw.payment.Amount_Due__c;
                        }
                    }
                }
            }
            
            // stamp terms and payment info on opp
            if (stampFirstTermInfoOnOpp) {
            	opp[0].Sale_Invoice_Qty_Payments_After_Down__c = regPmtCount;
            	opp[0].Sale_Invoice_First_Date_After_Down__c = firstRegPmtDate;
            	opp[0].ptsTotalDownPmts__c = downPaymentTotal;
            	opp[0].ptsTotalAfterDownPmts__c = regPmtTotal;
            }
            
            if (newPayments.size() > 0) {
                insert newPayments;
            }
        }
        
        if ((stampFirstTermInfoOnOpp) && (opp[0] != null)) {
        	update opp[0];
        }

		if (allowedProfile) { 
			PageReference pmtOptionPage = new PageReference('/apex/RecordPaymentOption');
			return pmtOptionPage;
		}
		else {
			PageReference oppPage;
	        if (opp.size() > 0) {
	            oppPage = new ApexPages.StandardController(opp[0]).view();
	        }
	        else {
	            oppPage = new PageReference('/006/o');
	        }           
	        oppPage.setRedirect(true);
	        return oppPage;
		}
    }
    
    
    /**************************************
    *
    *   @description:
    *   cancelPayments - redirects to either source opportunity page or opportunity tab
    *  
    **/
    public PageReference cancelPayments() {
        return navigateToOpp();
    }
    
    
    /**************************************
    *
    *   @description:
    *   resetDPWrappers - clears/resets all necessary downpayment related page variables
    *  
    **/
    public void resetDPWrappers() {
        downPaymentWraps = new List<PlannedPaymentWrapper>();
        numOfDownPayments = null;
        totalOfDownpayments = null;
        dpStartDate = null;
        dpFrequency = 'Daily';
        dpCalcType = 'Auto';
        showDPCountError = false;
        showDPMaxError = false;
        showDPDateError = false;
        showDPTotalError = false;
        disableDP = false;
        // set next due
        setNextDue();
        if ((activeTerms != null) && (activeTerms.size() > 0)) {
           
            totalOfRegPayments = opp[0].Remaining_Balance__c;
        } else {
            totalOfRegPayments = oppProducts[0].TotalPrice;
        }
    }
    
    
    /**************************************
    *
    *   @description:
    *   resetDPWrappers - clears/resets all necessary regular payments related page variables
    *  
    **/
    public void resetRegWrappers() {
        regPaymentWraps = new List<PlannedPaymentWrapper>();
        numOfRegPayments = null;
        totalOfRegPayments = null;
        regStartDate = null;
        regFrequency = 'Monthly';
        regCalcType = 'Manual';
        showRegCountError = false;
        showRegDateError = false;
        showRegTotalError = false;
        disableReg = false;
        // set next due
        setNextDue();
    }
    
    
    /**************************************
    *
    *   @description:
    *   getShowButtons - accessor for flag to show/hide "Submit" and "Cancel" buttons
    *  
    **/
    public boolean getShowButtons() {
        if (((downPaymentWraps != null) && (downPaymentWraps.size() > 0)) ||  ((regPaymentWraps != null) && (regPaymentWraps.size() > 0))) {
            return true;
        }
        else {
            return false;
        }
    }
    
    
    /**************************************
    *
    *   @description:
    *   getDownpaymentsExist - accessor for flag indicating that downpayments exist
    *  
    **/
    public Boolean getDownpaymentsExist() {
        if ((downPaymentWraps != null) && (downPaymentWraps.size() > 0)) {
            return true;
        }
        else {
            return false;
        }
    }
    
    
    /**************************************
    *
    *   @description:
    *   getRegularPaymentsExist - accessor for flag indicating that regular payments exist
    *  
    **/
    public Boolean getRegularPaymentsExist() {
        if ((regPaymentWraps != null) && (regPaymentWraps.size() > 0)) {
            return true;
        }
        else {
            return false;
        }
    }
    
    
    /**************************************
    *
    *   @description:
    *   getTotalOfPlannedDownPayments - accessor for calculated total of planned down payments
    *  
    **/
    public Decimal getTotalOfPlannedDownPayments() {
        if (downPaymentWraps.size() > 0) {
            Decimal totalAmounts = 0;
            for (PlannedPaymentWrapper ppw : downPaymentWraps) {
                totalAmounts += ppw.payment.Amount_Due__c;
            }
            return totalAmounts;
        }
        else {
            return 0;
        }
    }
    
    
    /**************************************
    *
    *   @description:
    *   getTotalOfPlannedRegPayments - accessor for calculated total of planned regular payments
    *  
    **/
    public Decimal getTotalOfPlannedRegPayments() {
        if (regPaymentWraps.size() > 0) {
            Decimal totalAmounts = 0;
            for (PlannedPaymentWrapper ppw : regPaymentWraps) {
                totalAmounts += ppw.payment.Amount_Due__c;
            }
            return totalAmounts;
        }
        else {
            return 0;
        }
    }
    
    
    /**************************************
    *
    *   @description:
    *   navigateToRecordPayment - navigate to the create payment visualforce page
    *  
    **/
    public PageReference navigateToRecordPayment() {
    	String pageRefUrl = '/apex/CreatePayment?oid=' + oppId;
		
		/*if ((isPendingTerms != null) && (isPendingTerms)) {
			pageRefUrl += '&pend=1';
		}*/
    	
    	PageReference recPmtPage = new PageReference(pageRefUrl);
    	return recPmtPage;
    }
    
    
    /**************************************
    *
    *   @description:
    *   navigateToOpp - redirect to opportunity detail page or opportunity tab
    *  
    **/
    public PageReference navigateToOpp() {
    	PageReference oppPage;
        if ((opp != null) && (opp.size() > 0)) {
            oppPage = new ApexPages.StandardController(opp[0]).view();
        }
        else {
            oppPage = new PageReference('/006/o');
        }           
        oppPage.setRedirect(true);
        return oppPage;
    }
    
    
    //============================================================================================================================
    //      WRAPPER CLASSES
    //============================================================================================================================
        
    // payment term wrapper class
    public class PaymentTermsWrapper {
        public Payment_Terms__c pmtTerms {get; set;}
        
        public PaymentTermsWrapper() {
        }
        
        public PaymentTermsWrapper(Payment_Terms__c terms) {
            pmtTerms = terms;
        }
    }
    
    
    // plan payment wrapper class
    public class PlannedPaymentWrapper implements Comparable {
        public Planned_Payment__c payment {get; set;}
        public Boolean isDownPayment {get; set;}
        public Integer paymentNumber {get; protected set;}
        
        
        public PlannedPaymentWrapper() {
        }
        
        public PlannedPaymentWrapper(Planned_Payment__c pmt) {
            payment = pmt;
        }
        
        public PlannedPaymentWrapper(Integer pmtNum, Planned_Payment__c pmt) {
            paymentNumber = pmtNum;
            payment = pmt;
        }
        
        public Integer compareTo(Object compareTo) {
        	PlannedPaymentWrapper compareToWrapper = (PlannedPaymentWrapper)compareTo;
        	if ((compareToWrapper.payment != null) && (payment != null)) {
        		if ((payment.Due_Date__c != null) && (compareToWrapper.payment.Due_Date__c != null)) {
        			if (payment.Due_Date__c == compareToWrapper.payment.Due_Date__c) {
        				return 0;
        			}
        			if (payment.Due_Date__c > compareToWrapper.payment.Due_Date__c) {
        				return 1;
        			}
        			return -1;
        		}
        		else {
        			return 0;
        		}
        	}
        	else return 0;
        }
    }
}