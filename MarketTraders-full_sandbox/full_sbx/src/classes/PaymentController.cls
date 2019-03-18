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
*   Author:             Coastal Cloud (outsourced)
*   Last Modified:      4/27/2016
*   Last Modified By:   Sean Murphy
*
*   12/29/15 - coastal cloud: class created
*   4/3/16   - sm: merchant integration development completed
*   4/4/16   - sm: code cleanup
*   4/18/16  - sm: added callout exception handling
*   4/27/16  - sm: added conditional creation of term payment source to processRunMoney
*   
**********************************************************************************************************************/
public without sharing class PaymentController {
    // constants
    private static final Integer NO_MODE = 0;
    private static final Integer RUN_MONEY_MODE = 1;
    private static final Integer MANUAL_MODE = 2;
    private static final Integer APPLY_PMTS_MODE = 3;
    
    // local data
    public String oppId {get; set;}
    public String acctId {get; set;}
    public Opportunity opp {get; private set;}
    public Account acct {get; private set;}
    public Payment_Activity__c paymentActivity {get; set;}
    public List<Payment_Terms__c> activeTermsList {get; set;}
    public List<Planned_Payment__c> plannedPayments {get; set;}
    public List<PlannedPaymentWrapper> plannedPaymentWraps {get; set;}
    public List<PaymentActivityWrapper> paymentActivityWrapList {get; private set;}
    private Map<String, PaymentSourceWrapper> paymentSourcesMap;
    public String selectedPaymentSourceId {get; set;}
    public String primaryPaymentSourceId {get; private set;}
    public PaymentSourceWrapper primarySource {get; private set;}
    private List<Payment_Activity_Payment_Source__c> papsList {get; private set;}
    public Boolean calloutException {get; private set;}
    
    // control data
    private Integer processMode {get; private set;}
    public Decimal totalSelectedPayments {get; private set;}
    public Boolean processCard {get; set;}
    public Boolean enablePendingPayments {get; private set;}
    public Boolean showRunMoneyFields {get; private set;}
    public Boolean showPaymentInfoFields {get; set;}
    public Boolean showPmtInfoSection {get; set;}
    public Boolean enableEditPaymentSource {get; private set;}
    private static List<String> allowedProfileNames;
    private static Map<Id, Profile> userProfilesMap;
    public Boolean displayApprovedDlg {get; private set;}
    public Boolean displayDeclinedDlg {get; private set;}
    public Boolean displayErrorDlg {get; private set;}
    public Boolean allowedProfile {get; private set;}
    public Boolean transactionApproved {get; private set;}
    
    // custom exception class
    public class PaymentControllerException extends Exception { }
    
    
    /********************************
    *
    *   constructor
    *
    *   @description: creates instance of the class
    * 
    **/
    public PaymentController() {
        oppId = ApexPages.currentPage().getParameters().get('oid');
        paymentActivityWrapList = new List<PaymentActivityWrapper>();
        plannedPaymentWraps = new List<PlannedPaymentWrapper>();
        totalSelectedPayments = 0;
        primarySource = null;
        selectedPaymentSourceId = '';
        processCard = false;
        enablePendingPayments = true;
        showRunMoneyFields = false;
        showPaymentInfoFields = true;
        showPmtInfoSection = true;
        processMode = NO_MODE;
        displayApprovedDlg = false;
        displayDeclinedDlg = false;
        allowedProfile = false;
        transactionApproved = false;
        enableEditPaymentSource = false;
        calloutException = false;
        
        // get profile of running user and flag if allowed profile
        allowedProfileNames = new List<String>{'System Administrator', 'MTI SF Automation', 'MTI Administrative Assistant', 'MTI Accounting (level 2)', 'MTI Accounting (Management)', 'MTI Accounting (Payables)', 'MTI Accounting (reporting)', 'MTI Manager (Corporate)', 'MTI Manager (Department)'};
        userProfilesMap = new Map<Id, Profile>([SELECT Id, Name FROM Profile WHERE Name in :allowedProfileNames]);
        
        String profId = UserInfo.getProfileId();
        
        if (userProfilesMap.containsKey(profId)) {
            allowedProfile = true;
        }
        
        // get opportunity (if applicable)
        System.debug('@@@@ opp Id: ' + oppId);
        if (oppId != null) {
            opp = [SELECT Id, Name, AccountId, Credit_Card_Manual_Run_Result__c, Credit_Card_Manual_Run_By__c FROM Opportunity WHERE Id = :oppId];
            // get active term (if applicable)
            activeTermsList = [SELECT Id, Name, Active__c, Payment_Terms_Type__c 
                                FROM Payment_Terms__c 
                                WHERE  Active__c = true 
                                AND Opportunity__c = :oppId LIMIT 1];
                                
            System.debug('@@@@ active terms list: ' + activeTermsList);
        }
        
        // set acct id and get account
        if ((acctId == null) && (opp != null)) {
            acctId = opp.AccountId;
            acct = [SELECT FirstName, LastName FROM Account WHERE Id = :acctId];
        }

        // init payment activity
        paymentActivity = new Payment_Activity__c();
        paymentActivity.Opportunity__c = oppId;
        paymentActivity.Account__c  = acctId;
        paymentActivity.Date__c = DateTime.now();
        
        // get orphan payment activities and planned payments (if applicable)
        if ((activeTermsList != null) && (activeTermsList.size() > 0)) {
            paymentActivity.payment_terms__c = activeTermsList[0].id;
            
            // get orphan payment activities
            List<Payment_Activity__c> pendingPmtActivities = [SELECT Id, Date__c, Amount__c, Payment_Type__c, Authorization_Decline_Number__c,
                                                                    Outcome__c, Payment_Status__c, Processed_By__c
                                                                FROM Payment_Activity__c
                                                                WHERE Payment_Terms__c = :paymentActivity.payment_terms__c
                                                                AND Outcome__c = 'Approved'
                                                                AND Payment_Count__c = 0
                                                                ORDER BY Date__c ASC];
                                                                
            System.debug('@@@@ pending pmt activities: ' + pendingPmtActivities);
            
            // if orphan payment activities exist                                                    
            if ((pendingPmtActivities != null) && (pendingPmtActivities.size() > 0)) {
                // create and collect orphan payment wrappers
                Set<Id> pmtActivityIds = new Set<Id>();
                System.debug('@@@@ adding payment activity wraps...');
                for (Payment_Activity__c pa : pendingPmtActivities) {
                    pmtActivityIds.add(pa.Id);
                    paymentActivityWrapList.add(new PaymentActivityWrapper(pa));
                }
                
                papsList = [SELECT Id, Payment_Source__c, Payment_Activity__c 
                            FROM Payment_Activity_Payment_Source__c 
                            WHERE Payment_Activity__c IN :pmtActivityIds];
            }
            
            // get planned payments
            plannedPayments = [SELECT ID, Amount_Due__c, Due_Date__c, Due__c,status__c 
                                FROM Planned_Payment__c 
                                WHERE Payment_Terms__c = :activeTermsList[0].id
                                AND due__c > 0 
                                ORDER BY Due_Date__c ASC];
        }
   
        // wrap planned payments (if applicable)
        if (plannedPayments != null) {
            for (Planned_Payment__c p : plannedPayments) {
                plannedPaymentWraps.add(new PlannedPaymentWrapper(p));
            }
        }
        
        // wrap payment sources
        refreshPaymentSources();
    }
    
    
    /**************************************
    *
    *   @description:
    *   process - create payment activity and payments (if applicable); create term (if applicable)
    *  
    **/
    public pageReference process() {
        System.debug('@@@@ process mode: ' + processMode);
        Boolean errorsFound = false;
        if (processMode != null) {
            if (processMode == NO_MODE) {
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No process mode applied.  Please re-enter info and try again.  If the error persists, contact the MIT Salesforce development team.'));
                return null;
            }
            else if (processMode == RUN_MONEY_MODE) {
                System.debug('@@@@ processing run money...');
                errorsFound = processRunMoney();
            }    
            else if (processMode == MANUAL_MODE) {
                System.debug('@@@@ processing manual...');
                errorsFound = processManual();
            } 
            else if (processMode == APPLY_PMTS_MODE) {
                System.debug('@@@@ processing apply payments...');
                errorsFound = processApplyPayments();
            }
            else {
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No process mode applied.  Please re-enter info and try again.  If the error persists, contact the MIT Salesforce development team.'));
                return null;
            }
        }
        
        if (errorsFound) {
            System.debug('@@@@ ERRORS FOUND.');
            return null;
        }
        
        // redirect to opp, acct, or home page
        if (processMode == RUN_MONEY_MODE) {
            return null;
        }
        else {
            PageReference pageRef;
            
            if (oppId != null) {
                pageRef = new PageReference('/'+ oppId);
            }
            else if (acctId != null) {
                pageRef = new PageReference('/' + acctId);
            }
            else {
                pageRef = new PageReference('home/home.jsp');
            }
            
            return pageRef;
        }
    }
    
    
    /**************************************
    *
    *   @description:
    *   processRunMoney - callout to merchant and create payment activity and payments (if applicable); create terms (if applicable)
    *  
    **/
    private Boolean processRunMoney() {
        try {
            if ((selectedPaymentSourceId != null) && (paymentActivity != null) && (paymentActivity.amount__c != null)) {
                // callout to merchant
                RocketGateIntegrationHelper.RocketGateResponseBody resp = null;
                if (!Test.isRunningTest()) {
                    resp = RocketGateIntegrationHelper.requestPurchase(paymentSourcesMap.get(selectedPaymentSourceId).src, acctId, paymentActivity.amount__c);
                }
                else {
                    resp = new RocketGateIntegrationHelper.RocketGateResponseBody();
                    Integer ccExpYear = Integer.valueOf(paymentSourcesMap.get(selectedPaymentSourceId).src.Credit_Card_Exp_Year__c);
                    if (ccExpYear >= Date.today().year()) {
                        resp.success = 'true';
                        resp.responseCode = '0';
                        resp.transactionId = '1000153CDE69MTI';
                        resp.authCode = '121212';
                    }
                    else {
                        resp.success = 'false';
                        resp.errorText = 'Declined - Invalid expiration date';
                    }
                }
                
                if (resp != null) {
                    // complete init of payment activity
                    paymentActivity.Authorization_Decline_Number__c = resp.authCode;
                    paymentActivity.Payment_Type__c = 'Credit Card';
                    paymentActivity.Merchant_Transaction_Id__c = resp.transactionId;
                    paymentActivity.PA_CC_Last_4__c = paymentSourcesMap.get(selectedPaymentSourceId).getLast4();
        
                    if (resp.success == 'true') {
                        paymentActivity.Payment_Status__c = 'Paid';
                        paymentActivity.Outcome__c = 'Approved';
                        transactionApproved = true;
                        displayApprovedDlg = true;
                        displayDeclinedDlg = false;
                    }
                    else {
                        paymentActivity.Merchant_Error_Text__c = resp.errorText;
                        paymentActivity.Outcome__c = 'Declined';
                        transactionApproved = false;
                        displayDeclinedDlg = true;
                        displayApprovedDlg = false;
                    }
    
                    paymentActivity.Processed_By__c = UserInfo.getUserId();
                    if (opp.Credit_Card_Manual_Run_By__c == null) {
                        opp.Credit_Card_Manual_Run_By__c = paymentActivity.Processed_By__c;
                    }
                
                    if (opp.Credit_Card_Manual_Run_Result__c == null) {
                        opp.Credit_Card_Manual_Run_Result__c = paymentActivity.Outcome__c;
                    }
    
                    // insert "pending" payment terms
                    if (paymentActivity.Payment_Terms__c == null) {
                        Payment_Terms__c newTerms = new Payment_Terms__c(Opportunity__c = oppId, Active__c = true, First_Payment_Term__c = true, Payment_Terms_Type__c = 'Pending');
                        insert newTerms;
                        
                        if (activeTermsList == null) {
                            activeTermsList = new List<Payment_Terms__c>();
                        }
                        activeTermsList.add(newTerms);
                        paymentActivity.Payment_Terms__c = newTerms.Id;
                        
                        // insert primary term payment source
                        if (paymentActivity.Outcome__c == 'Approved') {
                            Term_Payment_Source__c tps = new Term_Payment_Source__c();
                            tps.Primary__c = true;
                            tps.Payment_Source__c = selectedPaymentSourceId;
                            tps.Terms__c = newTerms.Id;
                            insert tps;
                        }
                    }
                    
                    // insert the payment activity
                    insert paymentActivity;
            
                    // insert junction object
                    Payment_Activity_Payment_Source__c actSrcJunction = new Payment_Activity_Payment_Source__c(Payment_Activity__c = paymentActivity.Id, Payment_Source__c=selectedPaymentSourceId);
                    insert actSrcJunction;
                    
                    // update the opp
                    update opp;
                }
                else {
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Unable to process card.  Please contact MTI Salesforce Development Team.'));
                    return true;
                }
    
            }
            else {
                // add error message
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No payment source selected, no valid payment activity, or no payment activity amount.  Please correct and try again.'));
                return true;
            }
            
            return false;
        }
        catch (System.CalloutException sce) {
            calloutException = true;
            displayErrorDlg = true;
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<MerchantAcctEmailRecipients__c> emaillist = MerchantAcctEmailRecipients__c.getAll().values();
            List<String> recips = new List<String>();
            for (MerchantAcctEmailRecipients__c e : emaillist) {
                recips.add(e.User_Email__c);    
            }            
            String[] toAddresses = new String[] {'sfdev@markettraders.com',UserInfo.getUserEmail()}; 
            toAddresses.addAll(recips);
            mail.setToAddresses(toAddresses);
            mail.setReplyTo('sfdev@markettraders.com');
            mail.setSenderDisplayName('Merchant Account Integration');
            mail.setSubject('Merchant Account Integration Error');
            String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
            mail.setHtmlBody('There was an issue with the response from the merchant account for opportunity with Id <a href="' + baseURL + '/' + oppId + '">' + oppId + '</a>, however it is likely the payment was approved. DO NOT RESUBMIT THE CARD FOR PURCHASE!');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
            return false;
        }
        catch(Exception ex) {
            throw new PaymentControllerException(ex.getMessage() + '\n' + ex.getStackTraceString());
        }
    }
    
    
    /**************************************
    *
    *   @description:
    *   processManual - create manual payment activity and payments (if applicable); create terms (if applicable)
    *  
    **/
    private Boolean processManual() {
        //===============================
        //  Note that for this method there will ALWAYS be ONE payment activity to ONE OR MORE planned payments
        //===============================
        Boolean hasErrors = false;
        
        if (plannedPaymentWraps == null || plannedPaymentWraps.size() == 0 ) {
            Apexpages.addMessage( new ApexPages.Message (ApexPages.Severity.ERROR, 'No planned payments to process.'));
            return true;
        }
            
        List<Planned_Payment__c> updatePlannedPayments = new List<Planned_Payment__c>();
        Decimal sumPlannedPayments = 0;
        for (PlannedPaymentWrapper pw : plannedPaymentWraps) {
            sumPlannedPayments += pw.amount;
        }

        System.debug('sumPayments <> paymentActivity.amount__c : ' + String.valueOf(sumPlannedPayments != paymentActivity.amount__c));
        System.debug('sumPayments : ' + String.valueOf(sumPlannedPayments));
        System.debug('paymentActivity.amount__c : ' + String.valueOf(paymentActivity.amount__c));
        System.debug('paymentActivity.Outcome__c != \'Declined\' : ' + String.valueOf(paymentActivity.Outcome__c != 'Declined'));
        System.debug('paymentActivity.Outcome__c : ' + String.valueOf(paymentActivity.Outcome__c));
        
        // if totals don't match and the payment activity is not declined
        if (sumPlannedPayments <> paymentActivity.amount__c && paymentActivity.Outcome__c != 'Declined' ) {
            Apexpages.addMessage( new ApexPages.Message (ApexPages.Severity.ERROR, 'Payment totals do not match'));
            hasErrors = true;
        }
        
        if (hasErrors) {
            return true;
        }    
       
/* FOR POSSIBLE FUTURE USE:     
       // process payment through merchant account if no existing payment activity AND payment source selected AND payment activity has an amount    
       if ((processCard) && (selectedPaymentSourceId != null) && (paymentActivity != null) && (paymentActivity.amount__c != null)) {
            RocketGateIntegrationHelper.RocketGateResponseBody resp = requestPurchase.requestAuthorization(paymentSourcesMap.get(selectedPaymentSourceId).src, acctId, paymentActivity.amount__c);

            // complete init of payment activity
            paymentActivity.Authorization_Decline_Number__c  = resp.authCode;
            paymentActivity.Payment_Type__c = 'Credit Card';
            paymentActivity.Merchant_Transaction_Id__c = resp.transactionId;
                
            if (resp.success == 'true') {
                paymentActivity.Payment_Status__c = 'Paid';
                paymentActivity.Outcome__c = 'Approved';
            }
            else {
                paymentActivity.Merchant_Error_Text__c = resp.errorText;
                paymentActivity.Outcome__c = 'Declined';
            }
            
            paymentActivity.Processed_By__c = UserInfo.getUserId(); 
        }    
*/            
        //upsert  payment activity
        upsert paymentActivity;
        
        // insert junction record if credit card (Payment Activity Payment Source)
        if ((paymentActivity.Payment_Type__c == 'Credit Card') && (selectedPaymentSourceId != null)) {
            Payment_Activity_Payment_Source__c paps = new Payment_Activity_Payment_Source__c(Payment_Activity__c = paymentActivity.Id, Payment_Source__c=selectedPaymentSourceId);
            insert paps;
        }
        
        //create junction records (Payments)
        List<Payment__c> paymentList = new List<Payment__c>();
        for (PlannedPaymentWrapper ppw : plannedPaymentWraps){
            if (ppw.amount > 0) {
                Date dateTemp = Date.newInstance(paymentActivity.date__c.year(), paymentActivity.date__c.month(), paymentActivity.date__c.day());
                Payment__c newPayment = new Payment__c();
                newPayment.Planned_Payment__c = ppw.payment.id;
                newPayment.Payment_Activity__c =  paymentActivity.id;
                newPayment.Amount__c = ppw.amount;
                newPayment.PY_Paid_Date__c = dateTemp;
                paymentList.add(newPayment);

                // handle status overrides
                if(ppw.payment.due_date__c < dateTemp && !ppw.overRideStatus) { 
                    ppw.payment.status__c = 'Paid Late';
                }
                else if(!ppw.overRideStatus) {
                    ppw.payment.status__c = 'Paid';
                }
                
                //credits
                if (paymentActivity.Payment_Status__c == 'Credit' && !ppw.overRideStatus) {
                    ppw.payment.status__c = 'Credit';
                }
                updatePlannedPayments.add(ppw.payment);
            }
            else if (ppw.overRideStatus) {
                updatePlannedPayments.add(ppw.payment); 
            }
        }
            
        // insert junction objects (payments)
        if (paymentList.size() > 0) {
            insert paymentList;
        }
        
        // update planned payments
        if (updatePlannedPayments.size() > 0) {
           update updatePlannedPayments;
        }

        return false;
    }

    
    /**************************************
    *
    *   @description:
    *   processApplyPayments - create payment activity and payments (if applicable); create terms (if applicable); relate to planned payment(s)
    *  
    **/
    private Boolean processApplyPayments() {
        List<PaymentActivityWrapper> selectedActivityWraps = new List<PaymentActivityWrapper>();
        List<PlannedPaymentWrapper> selectedPlannedPaymentWraps = new List<PlannedPaymentWrapper>();
        Decimal totalActivities = 0;
        Decimal totalPlanned = 0;
        Boolean hasErrors = false;

        for (PaymentActivityWrapper paw : paymentActivityWrapList) {
            if (paw.Selected) {
                selectedActivityWraps.add(paw);
                totalActivities += paw.paymentActivity.Amount__c;
            }
        }

        for (PlannedPaymentWrapper ppw : plannedPaymentWraps) {
            if (ppw.amount > 0) {
                selectedPlannedPaymentWraps.add(ppw);
                totalPlanned += ppw.amount;
            }
        }

        // now have collected the payment activities and planned payments
        System.debug('@@@@ total activities: ' + totalActivities);
        System.debug('@@@@ total planned: ' + totalPlanned);

        // need to make sure the totals match
        if (totalActivities != totalPlanned) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Payment activity and planned payment totals do not match'));
            hasErrors = true;
        }
        
        if (hasErrors) {
            return true;
        }

        // loop through the lists
        List<Payment__c> paymentsForInsert = new List<Payment__c>();
        Set<Planned_Payment__c> plannedPmtsSet = new Set<Planned_Payment__c>();
        List<Planned_Payment__c> plannedPmtsForUpdate = new List<Planned_Payment__c>();
        Integer currentActivityIndex = 0;
        Integer currentPlannedIndex = 0;
        PaymentActivityWrapper currentActivityWrap = selectedActivityWraps[currentActivityIndex];
        Decimal currentActivityWrapBalance = currentActivityWrap.paymentActivity.Amount__c;
        PlannedPaymentWrapper currentPlannedWrap = selectedPlannedPaymentWraps[currentPlannedIndex];
        Decimal currentPlannedWrapBalance = currentPlannedWrap.amount;
        Date currentPlannedDate;
        Boolean done = false;
        
        Integer i = 0;
        
        System.debug('@@@@ sel act wrap size: ' + selectedActivityWraps.size());
        System.debug('@@@@ sel planned wrap size: ' + selectedPlannedPaymentWraps.size());
    
        do {
            i++;
            System.debug('@@@@ BEFORE curr act wrap bal: ' + currentActivityWrapBalance);
            System.debug('@@@@ BEFORE curr plnd wrap bal: ' + currentPlannedWrapBalance);
            
            // is there a balance on the activity and a balance on the planned
            if ((currentActivityWrapBalance > 0) && (currentPlannedWrapBalance > 0)) {
                // if the amount on the planned payment > 0, process the planned payment
                Payment__c newPmt = new Payment__c(Payment_Activity__c = currentActivityWrap.paymentActivity.Id, Planned_Payment__c = currentPlannedWrap.payment.Id);
                newPmt.PY_Credit__c = false;
                newPmt.PY_Paid_Date__c = currentActivityWrap.paymentActivity.Date__c.date();
                
                // handle overrides
                if(currentPlannedWrap.payment.Due_Date__c < newPmt.PY_Paid_Date__c && !currentPlannedWrap.overRideStatus) { 
                    currentPlannedWrap.payment.status__c = 'Paid Late';
                }
                else if(!currentPlannedWrap.overRideStatus) {
                    currentPlannedWrap.payment.status__c = 'Paid';
                }
                //credits
                if (paymentActivity.Payment_Status__c == 'Credit' && !currentPlannedWrap.overRideStatus) {
                    currentPlannedWrap.payment.status__c = 'Credit';
                }
                
                // add planned payment for update
                plannedPmtsSet.add(currentPlannedWrap.payment);
                
                // update amount
                if (currentActivityWrapBalance > currentPlannedWrapBalance) {
                    // activity will have balance
                    System.debug('@@@@ activity > planned...');
                    newPmt.Amount__c = currentPlannedWrapBalance;
                    currentActivityWrapBalance -= currentPlannedWrapBalance;
                    currentPlannedWrapBalance = 0;
                }
                else if (currentActivityWrapBalance <= currentPlannedWrapBalance) {
                    // planned will have balance
                    newPmt.Amount__c = currentActivityWrapBalance;
                    if (currentActivityWrapBalance < currentPlannedWrapBalance) {
                        System.debug('@@@@ planned > activity...');
                        currentPlannedWrapBalance -= currentActivityWrapBalance;
                        currentActivityWrapBalance = 0;
                    }
                    else {
                        System.debug('@@@@ activity == planned...');
                        currentActivityWrapBalance = 0;
                        currentPlannedWrapBalance = 0;
                    }
                }
                
                System.debug('@@@@ AFTER curr act wrap bal: ' + currentActivityWrapBalance);
                System.debug('@@@@ AFTER curr plnd wrap bal: ' + currentPlannedWrapBalance);

                // add the new payment for insert
                paymentsForInsert.add(newPmt);

                if ((currentActivityWrapBalance == 0) && (currentActivityIndex < (selectedActivityWraps.size() - 1))) {
                    System.debug('@@@@ incrementing curr act index...');
                    currentActivityIndex++;
                    currentActivityWrap = selectedActivityWraps[currentActivityIndex];
                    currentActivityWrapBalance = currentActivityWrap.paymentActivity.Amount__c;
                }

                if ((currentPlannedWrapBalance == 0) && (currentPlannedIndex < (selectedPlannedPaymentWraps.size() - 1))) {
                    System.debug('@@@@ incrementing curr planned index...');
                    currentPlannedIndex++;
                    currentPlannedWrap = selectedPlannedPaymentWraps[currentPlannedIndex];
                    currentPlannedWrapBalance = currentPlannedWrap.amount;
                }

                
                System.debug('@@@@ after index adjustments...curr act index: ' + currentActivityIndex);
                System.debug('@@@@ after index adjustments...curr planned index: ' + currentPlannedIndex);

                if ((currentActivityIndex == selectedActivityWraps.size() - 1) && (currentActivityWrapBalance == 0) && (currentPlannedIndex == selectedPlannedPaymentWraps.size() - 1) && (currentPlannedWrapBalance == 0)) {
                    done = true;
                }
            }
            
            if (i >= 100) {
                throw new PaymentControllerException('Uncontrolled loop in PaymentController class, applying pending payments for opportunity ' + oppId + '. Please notify the Salesforce Dev team with this info.');
            }
        } while (!done);
        
        if (paymentsForInsert.size() > 0) {
            insert paymentsForInsert;
        }
        
        if (plannedPmtsSet.size() > 0) {
            plannedPmtsForUpdate.addAll(plannedPmtsSet);
            update plannedPmtsForUpdate;
        } 
        
        return false;
    }
    
    
    /**************************************
    *
    *   @description:
    *   getHasPlannedPayments - return if planned payments exist
    *  
    **/
    public Boolean getHasPlannedPayments() {
        return (plannedPaymentWraps.size() > 0);
    }
    
    
    /**************************************
    *
    *   @description:
    *   getHasPaymentActivities - return if payment activities exist
    *  
    **/
    public Boolean getHasPaymentActivities() {
        return (paymentActivityWrapList.size() > 0);
    }
        

    /**************************************
    *
    *   @description:
    *   cancel - cancel operation and navigate to appropriate page
    *  
    **/
    public pageReference cancel() {
        // redirect to opp, acct, or home page
        PageReference pageRef;
        
        if (oppId != null) {
            pageRef = new PageReference('/'+ oppId);
        }
        else if (acctId != null) {
            pageRef = new PageReference('/' + acctId);
        }
        else {
            pageRef = new PageReference('home/home.jsp');
        }
        
        return pageRef;
    }
    
    
    /**************************************
    *
    *   @description:
    *   navigateToNext - set visibility flags and navigate to appropriate page
    *  
    **/
    public PageReference navigateToNext() {
        displayApprovedDlg = false;
        displayDeclinedDlg = false;
        if (transactionApproved) {
            PageReference oppPage;
            if (oppId != null) {
                oppPage = new PageReference('/'+ oppId);
            }
            else {
                oppPage = new PageReference('/006/o');
            }           
            oppPage.setRedirect(true);
            return oppPage;
        }
        else if (calloutException) {
            PageReference oppPage;
            if (oppId != null) {
                oppPage = new PageReference('/'+ oppId);
            }
            else {
                oppPage = new PageReference('/006/o');
            }           
            oppPage.setRedirect(true);
            return oppPage;
        }
        else {
            transactionApproved = false;
            paymentActivity = new Payment_Activity__c();
            paymentActivity.Opportunity__c = oppId;
            paymentActivity.Account__c  = acctId;
            paymentActivity.Date__c = DateTime.now();
            
            if ((activeTermsList != null) && (activeTermsList.size() > 0)) {
                paymentActivity.payment_terms__c = activeTermsList[0].id;
            }
            
            return null;
        }
    }

    
    /**************************************
    *
    *   @description:
    *   getNewPaymentSourceURL - return url to the standard new payment source page with values to prepopulate current account, first, and last name
    *  
    **/
    public String getNewPaymentSourceURL() {
        return URL.getSalesforceBaseUrl().toExternalForm() + '/a46/e?CF00N60000003BZ7q=' + acct.FirstName + '+' + acct.LastName + '&CF00N60000003BZ7q_lkid=' + acct.Id + '&retURL=%2F' + opp.Id;
    }
    

    /**************************************
    *
    *   @description:
    *   getEditPaymentSourceURL - return url to the standard edit payment source page for the selected payment source
    *  
    **/
    public String getEditPaymentSourceURL() {
        if (!String.isBlank(selectedPaymentSourceId)) {
            return URL.getSalesforceBaseUrl().toExternalForm() + '/' + selectedPaymentSourceId + '/e';   // ?&retURL=%2F' + opp.Id;
        }
        else {
            return null;
        }
    }
    
    
     /**************************************
    *
    *   @description:
    *   handlePmtSourceChange - set edit payment source flag base on selected payment source
    *  
    **/
    public void handlePmtSourceChange() {
        if (!String.isBlank(selectedPaymentSourceId)) {
            enableEditPaymentSource = true;
        }
        else {
            enableEditPaymentSource = false;
        }
    }
    
    
    /**************************************
    *
    *   @description:
    *   getPaymentSources - return list of payment sources for payment source picklist
    *  
    **/
    public List<SelectOption> getPaymentSources() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--Select--'));
        List<PaymentSourceWrapper> nonPrimary = new List<PaymentSourceWrapper>();
        for (PaymentSourceWrapper psw : paymentSourcesMap.values()) {
            if (psw.getIsPrimary()) {
                primarySource = psw;
            }
            else {
                nonPrimary.add(psw);
            }
        }
        
        if (primarySource != null) {
            options.add(new SelectOption(String.valueOf(primarySource.src.Id), (primarySource.getCardType() + ' - ' + primarySource.getLast4() + ' (*)')));
        }
        
        for (PaymentSourceWrapper wrap : nonPrimary) {
            options.add(new SelectOption(String.valueOf(wrap.src.Id), (wrap.getCardType() + '-' + wrap.getLast4())));
        }
        
        return options;
    }
    
    
    /**************************************
    *
    *   @description:
    *   refreshPaymentSources - refresh list of payment sources and return list of payment sources for payment source picklist 
    *  
    **/
    public void refreshPaymentSources() {
        paymentSourcesMap = new Map<String, PaymentSourceWrapper>();
        PaymentSourceWrapper newWrap;
        if (acctId != null) {
            for (Payment_Source__c ps : [SELECT Id, Credit_Card_Number__c, Credit_Card_Type__c, Credit_Card_CVV__c, Credit_Card_Exp_Month__c, Credit_Card_Exp_Year__c, Billing_Postal_Code__c, Primary__c FROM Payment_Source__c WHERE Account__c = :acctId]) {
                newWrap = new PaymentSourceWrapper(ps);
                paymentSourcesMap.put(ps.Id, newWrap);
                if (ps.Primary__c) {
                    primaryPaymentSourceId = newWrap.src.Id;
                }
            }
        }
    }
    
    
    /**************************************
    *
    *   @description:
    *   getPendingPayments - return list of wrapped pending payment activities
    *  
    **/
    public List<PaymentActivityWrapper> getPendingPayments() {
        if (paymentActivityWrapList != null) {
            return paymentActivityWrapList;
        }
        else {
            return null;
        }
    }
    
    
    /**************************************
    *
    *   @description:
    *   handlePaymentTypeChange - set flags to show or hide payment info fields and set process mode
    *  
    **/
    public void handlePaymentTypeChange() {
        if (paymentActivity.Payment_Type__c != null) {
            if (paymentActivity.Payment_Type__c == 'Credit Card') {
                showRunMoneyFields = true;
                enablePendingPayments = false;
                
                if (processCard) {
                    processMode = RUN_MONEY_MODE;
                }
                else {
                    processMode = MANUAL_MODE;
                }

                showPaymentInfoFields = !processCard;
            }
            else if (paymentActivity.Payment_Type__c != 'Credit Card') {
                if (paymentActivity.Payment_Type__c == '') {
                    enablePendingPayments = true;
                }
                else {
                    enablePendingPayments = false;
                }
                processCard = false;    // reset process card
                showPaymentInfoFields = true;
                showRunMoneyFields = false;
                processMode = MANUAL_MODE;
                selectedPaymentSourceId = null;
            }
        }
        else {
            showPaymentInfoFields = true;
            enablePendingPayments = true;
            showRunMoneyFields = false;
            processCard = false;
            processMode = MANUAL_MODE;
            selectedPaymentSourceId = null;
        }
        
        handlePmtSourceChange();
    }
    
    
    /**************************************
    *
    *   @description:
    *   getRunMoneyMode - return if process mode is RUN_MONEY_MODE
    *  
    **/
    public Boolean getRunMoneyMode() {
        return processMode == RUN_MONEY_MODE;
    }
    
    

    /**************************************
    *
    *   @description:
    *   handleSelectionChange - update data base on payment activity selection event
    *  
    **/
    public void handleSelectionChange() {
        totalSelectedPayments = 0;
        showPmtInfoSection = true;
        if ((paymentActivityWrapList != null) && (paymentActivityWrapList.size() > 0)) {
            for (PaymentActivityWrapper paw : paymentActivityWrapList) {
                if (paw.Selected) {
                    totalSelectedPayments += paw.paymentActivity.Amount__c;
                }
            }
        }
        
        if (totalSelectedPayments > 0) {
            processMode = APPLY_PMTS_MODE;
            showPmtInfoSection = false;
        }
    }
    


    
    //============================================================================================================================
    //      WRAPPER CLASSES
    //============================================================================================================================
    
    /******************************************
    *
    *   @description: wrapper class for planned payments
    *
    ******************************************/
    public class PlannedPaymentWrapper {
        public Planned_Payment__c payment {get; set;}
        public Decimal amount {get; set;}
        public Boolean overRideStatus {get; set;}

        public PlannedPaymentWrapper (Planned_Payment__c p) {
            payment = p;
            amount = 0;
            overRideStatus = false;
        }
    }    
    
    
    /******************************************
    *
    *   @description: wrapper class for payment sources
    *
    ******************************************/
    public class PaymentSourceWrapper {
        public Payment_Source__c src {get; set;}
        //private String last4 = '';
        
        public PaymentSourceWrapper(Payment_Source__c pmtSrc) {
            src = pmtSrc;
        }
        
        public String getLast4() {
            if (!String.isBlank(src.Credit_Card_Number__c)) {
                String last4 = src.Credit_Card_Number__c.right(4);
                return last4;
            }
            else {
                return 'none';
            }
        }
        
        public String getCardType() {
            if (!String.isBlank(src.Credit_Card_Type__c)) {
                return src.Credit_Card_Type__c;
            }
            else {
                return 'no card type';
            }
        }
        
        public Boolean getIsPrimary() {
            return src.Primary__c;
        }
    }
    
    
    
    /******************************************
    *
    *   @description: wrapper class for "pending" payment activities
    *
    ******************************************/
    public class PaymentActivityWrapper {
        public Payment_Activity__c paymentActivity {get; private set;}
        public Boolean selected {get; set;}
        
        public PaymentActivityWrapper(Payment_Activity__c pmtActivity) {
            selected = false;
            paymentActivity = pmtActivity;
        }
    }
}
