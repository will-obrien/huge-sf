public without sharing class PiggybackRefactor {
    
    public class PiggybackRefactorException extends Exception {}
    
    private List<Opportunity> newOpps;
    private List<Opportunity> oldOpps;
    private Map<Id,Opportunity> newOppMap;
    private Map<Id,Opportunity> oldOppMap;
  
    public static Boolean BYPASS = false;
    
    public void beforeContext(List<SObject> newList, List<SObject> oldList, Map<Id, sObject> newMap, Map<Id, sObject> oldMap, Boolean isInsert, Boolean isUpdate) {
        System.debug(LoggingLevel.ERROR,'@@@@ control is in PiggybackRefactor class BEFORE context');
        this.newOpps = (List<Opportunity>)newList;
        this.oldOpps = (List<Opportunity>)oldList;
        this.newOppMap = (Map<Id ,Opportunity>)newMap;
        this.oldOppMap = (Map<Id, Opportunity>)oldMap;
        
        if (!PiggybackRefactor.BYPASS) {
            for(Opportunity opp : newOpps) {
                if (isInsert) {
                    if (opp.X3Clogic_Stage_Score__c < 1000) {
                        opp.X3CLogic_Status__c = 'INSERT';
                    }
                }
                else if (isUpdate) {
                    if ((opp.OwnerId != oldOppMap.get(opp.Id).OwnerId) && (opp.X3CLogic_Previous_Owner__c == null)) { //Owner Changed
                        opp.X3CLogic_Previous_Owner__c = oldOppMap.get(opp.Id).OwnerId;
                        if (opp.X3Clogic_Stage_Score__c < 1000) {
                            opp.X3CLogic_Status__c = 'INSERT';
                        }
                    }
                    else {
                        integer previousScore = (integer)oldOppMap.get(opp.Id).X3Clogic_Stage_Score__c;
                        
                        if ((opp.X3Clogic_Stage_Score__c == 10) && (previousScore != 10)) {
                            opp.X3CLogic_Status__c = 'REPLACE';
                        }
                        else if ((opp.X3Clogic_Stage_Score__c >= 1000) && (previousScore < 1000)) {
                            opp.X3CLogic_Status__c = 'REMOVE';
                        }
                    }
                }
            }
        }
    }
    
    
    
    public void afterContext(List<sObject> newList, List<sObject> oldList, Map<Id, sObject> newMap, Map<Id, sObject> oldMap, Boolean isInsert, Boolean isUpdate) {
        System.debug(LoggingLevel.ERROR,'@@@@ control is in PiggybackRefactor class AFTER context');
        this.newOpps = (List<Opportunity>)newList;
        this.oldOpps = (List<Opportunity>)oldList;
        this.newOppMap = (Map<Id ,Opportunity>)newMap;
        this.oldOppMap = (Map<Id, Opportunity>)oldMap;


        //  2015-04-12 AMalena - added "Moodle" client marker support - works like Client marker, but
        //  includes "Default" and "Collections" for blocking access,
        //  on top of "Refund" and "Cancelled" sub-stages (which are standard for "Client" marker blocking)
        //  ..."WonRegardless" stores a client marker NO MATTER the sub-stage, FYI
        //  pb_Moodle_ is the baseline name ("just like" pb_Client_)


        //   Not yet implemented from PB object:   Includes_Charting__c   checkbox (not needed currently)
        if (!PiggybackRefactor.BYPASS) {
            List<Opportunity> listOpportunity =     new List<Opportunity>();
            List<Id> listOpportunityId =            new List<Id>();
            List<Id> listAccountId =                new List<Id>();
    
            Map<Id,Opportunity> mapIdOpportunity =  new Map<Id,Opportunity>();
            List<String> listProductNames =         new List<String>();
            PiggybackTriggerManager objManager =    new PiggybackTriggerManager();
    
    
            // ----------------------------------------------------------------------------------------------------
            if (isInsert || isUpdate) {       // INSERTED or UPDATED opp.........
                for(Opportunity thisOpportunity: newOpps) {
                    if (isUpdate) {
                        if (oldOppMap.get(thisOpportunity.Id).Product__c != null) {
                            listProductNames.add(oldOppMap.get(thisOpportunity.Id).Product__c);
                        }
                    }
    
                    if (thisOpportunity.Product__c != null) {
                        listAccountId.add(thisOpportunity.AccountId);
                        listProductNames.add(thisOpportunity.Product__c);
                    }
                }   
            } else { //  DELETED opps.............................
                for(Opportunity thisOpportunity: oldOpps) {
                    if (thisOpportunity.Product__c != null) {
                        listAccountId.add(thisOpportunity.AccountId);
                        listProductNames.add(thisOpportunity.Product__c);
                    }
                }
            }
            // ----------------------------------------------------------------------------------------------------
    
    
            // Prepare Map for Products...
            List<Piggyback_OppToAcct__c> listPiggyback_OppToAcct =  new List<Piggyback_OppToAcct__c>();
            listPiggyback_OppToAcct =                               new List<Piggyback_OppToAcct__c>([
            Select  p.Trackable__c, 
                    p.Field_Owner_and_Role__c,
                    p.Subscription__c, 
                    p.Subscription_Gaps__c, 
                    p.Client_Marker_Only__c, 
                    p.FIELD_Closed_Won_Owner__c, 
                    p.FIELD_Guarantee_Term__c, 
                    p.Piggyback_Product_Reference__c, 
                    p.CloseWon_Regardless__c,
                    p.FIELDS_Sale_Invoicing_Data__c,
                    p.FIELD_Moodle_Access__c,
                    p.Includes_Invoice_Info__c,
                    p.Name, 
                    p.Id    
                        From Piggyback_OppToAcct__c p 
                        where name in :listProductNames
            ]);

            map<Id, User> userMap = new map<Id, User>([
                Select  u.Id, 
                        u.Name 
                            From User u
            ]);
    
    
            //Get Account and all opportunities related to these Opp's Account...
    
            map<String, Piggyback_OppToAcct__c> mapStringPiggyback = new map<String, Piggyback_OppToAcct__c> ();
    
            for(Piggyback_OppToAcct__c curr:listPiggyback_OppToAcct) {
                mapStringPiggyback.put(curr.Name, curr);
            }
    
            Map<Id, RecordType> mapIdRecordType = new Map<Id, RecordType>([
            Select  r.SobjectType, 
                    r.Name, 
                    r.Id    
                        From RecordType r 
                        where r.SobjectType = 'Opportunity'
            ]);
    
            //Get Account and all opportunities related to these Opp's Account...
            // any fields being referenced need to be pulled in here.......................
            Map<Id, Account> 
                mapIdAccount = new  
                Map<Id, Account>([
                    Select 
                        a.Id, 
                        a.pb_Filter_Edu_NewLd_DEC_Other_Latest__c, 
                        pb_Filter_Coll_LostOpp_Latest__c,
                        pb_Filter_Edu_LostOpp_Latest__c,
                        Client_Ultimate_Charting_Pro_Forex__pc,
                        Sub_End_Ultimate_Charting_Pro_Forex__pc,
                        Client_Ultimate_Charting_Pro_Stocks__pc,
                        Sub_End_Ultimate_Charting_Pro_Stocks__pc,
                            (Select     Id, 
                                        RecordTypeId, 
                                        CloseDate,
                                        OwnerId, 
                                        Owner.FirstName,
                                        Owner.LastName,
                                        Owner.UserRole.Name,
                                        Product__c, 
                                        CreatedDate, 
                                        StageName, 
                                        Sub_Stage__c, 
                                        Purchase_Amount__c, 
                                        Charting_Start__c, 
                                        Charting_Expiration__c, 
                                        Charting_Package__c, 
                                        Charting_Charge_Type__c,
                                        Summary_Of_Receivables__c,
                                        Payment_Plan__c,
                                        Promotions_Received__c,
                                        Promotions_Received_Used__c,
                                        Sale_Down_Payment_1_of_4__c,
                                        Sale_Down_Payment_2_of_4__c,
                                        Sale_Invoice_Qty_Payments_After_Down__c,
                                        Sale_Invoice_First_Date_After_Down__c,
                                        Sale_Invoice_Amount_Due_Per__c,
                                        Sale_TOTAL_Amount_To_Be_Invoiced__c,
                                        Sale_TOTAL_Down_Payment__c,
                                        Guarantee_Terms__c
        
                                            From Opportunities 
                                            where Product__c != null order by createddate ) 
                //                                    where Product__c != null order by closedate ) 
                            From Account a where id in :listAccountId AND IsPersonAccount = true
                ]);
            //     NOTE "order by" above... which sorts the Opps into CreateDate order..................
            //     (eventually needs updating to CloseDate order with backup of CreateDate possibly.............)
    
    
            Map<Id, Account> updateMap = new Map<Id, Account>{};
            // previous method...    List<Account> updateList = new List<Account>();
        
            for(Id thisAccountId: mapIdAccount.keySet()) {    //  Begin For loop of ACCOUNTS.......
                SObject accObj = new Account(Id = thisAccountId);
        
                //Additional loop to clear out old values....
                for(Piggyback_OppToAcct__c o:listPiggyback_OppToAcct) {
        
            // removed due to overload of calls to SOQL...  (late 2012)
            // accObj = objManager.SetNullFieldsForAccount(accObj, o.Piggyback_Product_Reference__c);
        
                }
        
                Account objAccount = mapIdAccount.get(thisAccountId);
        
                List<Opportunity> listCurrOps = new List<Opportunity>();
                listCurrOps = objAccount.Opportunities;
        
                Map<String, List<Opportunity>> mapString_Opportunity = new Map<String, List<Opportunity>> ();
                mapString_Opportunity = objManager.GetDistinctProductsForAccount(objAccount);
        
        
                // CLEAR ANY (non-specific-product) MARKERS BEING CALCULATED HERE
                Boolean     temp_pbFilterEduNewLdDECOther1 =        false;
                Boolean     temp_StageName1 =                       false;
                Boolean     temp_FilterCollLostOpp1 =               false;
                Date        temp_pbFilterEduNewLdDECOtherLatest1 =  null;
                Date        temp_StageName1Date =                   null;
                Date        temp_FilterCollLostOppLatest1 =         null;
        
                String      temp_UTPOnDemPayPlanType =              null;
                Double      temp_UTPOnDemRecv =                     null;
        
                Integer     tempOppCountPPTinhousefin1=             0;    // ...for Payment Plan Type counting
                Integer     tempOppCountPPTinhousepdoff1=           0;  
                Integer     tempOppCountPPTunivpurch1=              0;   
                Integer     tempOppCountPPTunivfin1=                0;   
                Integer     tempOppCountPPTunivpdoff1=              0;  
        
                String      tempPromosReceived1=                    '';
                
                Date tempForexSubscriptionEndDate = null;
                Date tempStocksSubscriptionEndDate = null;
                Date prevWebForexSubEndDate = objAccount.Sub_End_Ultimate_Charting_Pro_Forex__pc;
                Date prevWebStocksSubEndDate = objAccount.Sub_End_Ultimate_Charting_Pro_Stocks__pc;
               
                // ------------------------------------------------------------------------------------------------
                // looping ALL opps for current account
            
        
        
            // ========================== BEGIN LOOP OF ALL OPPORTUNITIES FOR THIS ACCOUNT =====================
                for(Opportunity o: objAccount.Opportunities) {
                    if( o.Payment_Plan__c == 'In-House Financed'   ) { tempOppCountPPTinhousefin1++;   }
                    if( o.Payment_Plan__c == 'In-House Paid Off'   ) { tempOppCountPPTinhousepdoff1++; }
                    if( o.Payment_Plan__c == 'Universal Purchased' ) { tempOppCountPPTunivpurch1++;    }
                    if( o.Payment_Plan__c == 'Universal Financed'  ) { tempOppCountPPTunivfin1++;      }
                    if( o.Payment_Plan__c == 'Universal Paid Off'  ) { tempOppCountPPTunivpdoff1++;    }
        
        
                    //Added check for null ====================================================================
                    if (mapIdRecordType.get(o.RecordTypeId) != null) {
        
                        // accumulate Promotions Received from all Closed Won opps...
                        if(    
                            o.StageName == 'Closed Won' &&
                            o.Promotions_Received__c != '' && 
                            o.Promotions_Received__c != null &&
                            o.Promotions_Received__c != 'null' 
                        )
                        {  
                            tempPromosReceived1 = tempPromosReceived1 + o.Promotions_Received__c;
                            if ( o.Promotions_Received_Used__c ) { 
                                tempPromosReceived1 = tempPromosReceived1 + ' [USED ' + String.valueOf(o.CloseDate).SubString(0,10) + ']';
                            }
                            tempPromosReceived1 = tempPromosReceived1 + '; ';
                        }
                        // END promotions received
        
                        // Marker for EDUCATION opps, either New, or Lost-DEC (or null), or other specific (for DRIP)
                        // FIELD:  pb_Filter_Edu_NewLd_DEC_Other__c
                        if(    
                            mapIdRecordType.get(o.RecordTypeId).Name == 'Education' &&
                            (   (
                                    o.StageName == 'New Deal'
                                )  ||
                                (   o.StageName == 'Closed Lost' &&
                                    (   o.Sub_Stage__c == 'Dead Email Campaign' ||
                                        o.Sub_Stage__c == null
                                    )
                                )  ||
                                (   o.StageName != 'Pending Charge' &&
                                    o.StageName != 'Closed Won' &&
                                    o.StageName != 'Closed Lost' &&
                                    o.StageName != 'Refund' &&
                                    o.StageName != 'Verbal Commitment' &&
                                    o.StageName != 'New Collections' &&
                                    o.StageName != 'Promise to Pay' &&
                                    o.StageName != 'Refuse to Pay'
                                )
                            )
                        )
                        {  // if this IS true above, then mark it...
                            temp_pbFilterEduNewLdDECOther1 = true;
        
                            if
                            (  // ...and check if CreatedDate is newer than previous found (end up with newest CreatedDate)
                                objAccount.pb_Filter_Edu_NewLd_DEC_Other_Latest__c  <   o.CreatedDate  ||
                                objAccount.pb_Filter_Edu_NewLd_DEC_Other_Latest__c  ==  null
                            ) {
                                temp_pbFilterEduNewLdDECOtherLatest1 = Date.newInstance( o.CreatedDate.year() , o.CreatedDate.month() , o.CreatedDate.day() ); 
                            }
        
                        }
                    // END FIELD:  pb_Filter_Edu_NewLd_DEC_Other__c
        
        
                    // Marker for LOST OPPS (usually used to mail people who we lost UTP on, to offer other things,
                    // so it's "okay" per EricJ to include "Not Interested" SubStage
                    // FIELD:  pb_Filter_Edu_LostOpp__c
                        if
                        (    mapIdRecordType.get(o.RecordTypeId).Name == 'Education' &&
                            o.StageName == 'Closed Lost'
                        ) {
                            temp_StageName1 = true;
                            if
                            (  // ...and check if CreatedDate is newer than previous found (end up with newest CreatedDate)
                                objAccount.pb_Filter_Edu_LostOpp_Latest__c  <  o.CreatedDate  || 
                                objAccount.pb_Filter_Edu_LostOpp_Latest__c  ==  null
                            ) {
                                temp_StageName1Date = Date.newInstance(o.CreatedDate.year(),o.CreatedDate.month(),o.CreatedDate.day());
                            }
                        }
                    // END FIELD:  pb_Filter_Edu_LostOpp__c
        
        
                    // Marker for LOST COLLEGE OPPS 
                    // it's "okay" per EricJ to include "Not Interested" SubStage per the same logic as Edu Lost Opps
                    // FIELD:  pb_Filter_Coll_LostOpp__c
                        if
                        (    mapIdRecordType.get(o.RecordTypeId).Name == 'College Course' &&
                            o.StageName == 'Closed Lost'
                        )
                        {
                            temp_FilterCollLostOpp1 = true;
                            if
                            (  // ...and check if CreatedDate is newer than previous found (end up with newest CreatedDate)
                                objAccount.pb_Filter_Coll_LostOpp_Latest__c  <   o.CreatedDate  || 
                                objAccount.pb_Filter_Coll_LostOpp_Latest__c  ==  null
                            ) {
                                temp_FilterCollLostOppLatest1 = Date.newInstance(o.CreatedDate.year(),o.CreatedDate.month(),o.CreatedDate.day());
                            }
                        }
                    // END FIELD:  pb_Filter_Coll_LostOpp__c
        
        
                    // UTP OnDemand receivable amount and payment plan type (most recent opp closed won)
                    // FIELD:  pb_UTP_OnDemand_Receivable__c
                    // FIELD:  pb_UTP_OnDemand_PaymentPlanType__c
                        if ( o.StageName == 'Closed Won' && o.Product__c == 'UTP OnDemand' )
                        {
                            temp_UTPOnDemPayPlanType =      o.Payment_Plan__c;
                            temp_UTPOnDemRecv =             o.Summary_of_Receivables__c;
                        }
                    // END FIELD:  pb_UTP_OnDemand_Receivable__c
                    // END FIELD:  pb_UTP_OnDemand_PaymentPlanType__c
        
                    }
                    //============================================================================= check for null
                    
                    
                    // UCS Web Charting
                    System.debug(LoggingLevel.ERROR,'@@@@ working on opp ' + o.Id);
                    System.debug(LoggingLevel.ERROR,'@@@@ stage name: ' + o.StageName);
                    System.debug(LoggingLevel.ERROR,'@@@@ product: ' + o.Product__c);
                    System.debug(LoggingLevel.ERROR,'@@@@ substage: ' + o.Sub_Stage__c);
                    System.debug(LoggingLevel.ERROR,'@@@@ charting expiration: ' + o.Charting_Expiration__c);
                    
                    if ((o.Sub_Stage__c != 'Cancelled') && (o.Sub_Stage__c != 'Refund') && (o.Charting_Expiration__c != null)) {
                    	if (o.Product__c == 'Ultimate Charting Pro (Forex Feed)') {
                    		prevWebForexSubEndDate = tempForexSubscriptionEndDate;
                    		tempForexSubscriptionEndDate = o.Charting_Expiration__c;
                    	}
                    	else if (o.Product__c == 'Ultimate Charting Pro (Stocks Feed)') {
                    		prevWebStocksSubEndDate = tempStocksSubscriptionEndDate;
                    		tempStocksSubscriptionEndDate = o.Charting_Expiration__c;
                    	}
                    }
                    
                    
/*                    if ((o.Product__c == 'Ultimate Charting Pro (Forex Feed)') && (o.Sub_Stage__c != 'Cancelled') && (o.Sub_Stage__c != 'Refund') && (o.Charting_Expiration__c != null)) {
                    	System.debug(LoggingLevel.ERROR,'@@@@ capturing expiration date ' + o.Charting_Expiration__c);
                    	tempForexSubscriptionEndDate = o.Charting_Expiration__c;
                    }
                    else if ()*/
        
                }	// end for loop on the account's opportunities
        
        
            // **   BE SURE TO COVER ALL FIELDS FOR SETTING TO NULL IF NOT SETTING AT ALL!!!!!!   **
            // **   BE SURE TO COVER ALL FIELDS FOR SETTING TO NULL IF NOT SETTING AT ALL!!!!!!   **
            // **   BE SURE TO COVER ALL FIELDS FOR SETTING TO NULL IF NOT SETTING AT ALL!!!!!!   **
            
            // NEED a DELETE routine that clears all fields with Try Catch......
            //      try{ accObj.put('PB_Stage_UTP_OnDemand__c','testtttttt'); } catch( DMLException exx ){ }
        
                if( tempPromosReceived1.length() > 250 ){
                    accObj.put('pb_Promotions_Received__c',     '.....' + tempPromosReceived1.SubString(0,249) );
                }else{
                    accObj.put('pb_Promotions_Received__c',     tempPromosReceived1 );
                }
        
                if ( tempOppCountPPTinhousefin1   == 0 ) { tempOppCountPPTinhousefin1   = null; }
                if ( tempOppCountPPTinhousepdoff1 == 0 ) { tempOppCountPPTinhousepdoff1 = null; }
                if ( tempOppCountPPTunivpurch1    == 0 ) { tempOppCountPPTunivpurch1    = null; }
                if ( tempOppCountPPTunivfin1      == 0 ) { tempOppCountPPTunivfin1      = null; }
                if ( tempOppCountPPTunivpdoff1    == 0 ) { tempOppCountPPTunivpdoff1    = null; }
                accObj.put('pb_Opps_PayPlan_InHouseFinanced__c'    , tempOppCountPPTinhousefin1   );  
                accObj.put('pb_Opps_PayPlan_InHousePaidOff__c'     , tempOppCountPPTinhousepdoff1 );
                accObj.put('pb_Opps_PayPlan_UniversalPurchased__c' , tempOppCountPPTunivpurch1    );
                accObj.put('pb_Opps_PayPlan_UniversalFinanced__c'  , tempOppCountPPTunivfin1      );
                accObj.put('pb_Opps_PayPlan_UniversalPaidOff__c'   , tempOppCountPPTunivpdoff1    );
        
                accObj.put('pb_Filter_Edu_NewLd_DEC_Other__c',          temp_pbFilterEduNewLdDECOther1);
                accObj.put('pb_Filter_Edu_NewLd_DEC_Other_Latest__c',   temp_pbFilterEduNewLdDECOtherLatest1);
        
                accObj.put('pb_Filter_Edu_LostOpp__c',          temp_StageName1);      
                accObj.put('pb_Filter_Edu_LostOpp_Latest__c',   temp_StageName1Date);
        
                accObj.put('pb_Filter_Coll_LostOpp__c',         temp_FilterCollLostOpp1);
                accObj.put('pb_Filter_Coll_LostOpp_Latest__c',  temp_FilterCollLostOppLatest1); 
        
                accObj.put('pb_UTP_OnDemand_PaymentPlanType__c',    temp_UTPOnDemPayPlanType);  
                accObj.put('pb_UTP_OnDemand_Receivable__c',         temp_UTPOnDemRecv);
                
                
     // NEW WEBCHARTING
                
                System.debug(LoggingLevel.ERROR,'@@@@@ processing web forex sub end date...');
                System.debug(LoggingLevel.ERROR,'@@@@@ forex sub end date...' + tempForexSubscriptionEndDate);
                System.debug(LoggingLevel.ERROR,'@@@@@ prev forex sub end date...' + prevWebForexSubEndDate);
                
                // forex feed web charting product
                accObj.put('Sub_End_Ultimate_Charting_Pro_Forex__pc', tempForexSubscriptionEndDate);
                if ((tempForexSubscriptionEndDate != null) && (tempForexSubscriptionEndDate >= Date.today())) {
                	System.debug(LoggingLevel.ERROR,'@@@@@ checking client ucs back office web forex checkbox...');
                	accObj.put('Client_Ultimate_Charting_Pro_Forex__pc', true);
                }
                else {
                	System.debug(LoggingLevel.ERROR,'@@@@@ unchecking client ucs back office web forex checkbox...');
                	accObj.put('Client_Ultimate_Charting_Pro_Forex__pc', false);
                }
                
                System.debug(LoggingLevel.ERROR,'@@@@@ processing web stocks sub end date...');
                System.debug(LoggingLevel.ERROR,'@@@@@ stocks sub end date...' + tempStocksSubscriptionEndDate);
                System.debug(LoggingLevel.ERROR,'@@@@@ prev stocks sub end date...' + prevWebStocksSubEndDate);
                
                // stock feed web charting product
                accObj.put('Sub_End_Ultimate_Charting_Pro_Stocks__pc', tempStocksSubscriptionEndDate);
                if ((tempStocksSubscriptionEndDate != null) && (tempStocksSubscriptionEndDate >= Date.today())) {
                	System.debug(LoggingLevel.ERROR,'@@@@@ checking client ucs back office web  stocks checkbox...');
                	accObj.put('Client_Ultimate_Charting_Pro_Stocks__pc', true);
                }
                else {
                	System.debug(LoggingLevel.ERROR,'@@@@@ unchecking client ucs back office web stocks checkbox...');
                	accObj.put('Client_Ultimate_Charting_Pro_Stocks__pc', false);
                }
                
                
     // END NEW WEBCHARTING  
        
        
        // ========================== END LOOP OF ALL OPPORTUNITIES FOR THIS ACCOUNT =====================
        
        
        // END of looping ALL opps for current account
        // ------------------------------------------------------------------------------------------------
        
        
        // -- begin FOR currProd mapString --
                String      tempFieldName =             null;
                Boolean     tempFIELDCWOwner =          false;
                Boolean     tempFIELDGuarTerm =         false;
                Boolean     tempIsTrackable =           false;
                Boolean     tempOwnerAndRole =          false;
                Boolean     tempClientMarkerOnly =      false;
                Boolean     tempIsSub =                 false;
                Boolean     tempIsSubGapDetect =        false;
                Boolean     tempWonRegardless =         false;
                Boolean     tempInvoiceInfo =           false;
                Boolean     tempFIELDSInvoiceData =     false;
                Boolean     tempFIELDMoodleAccess =     false;
        
                for(String currProd: mapString_Opportunity.keySet())        {
                    // start main process product wise now...
        
                    List<Opportunity> listTempOps = new List<Opportunity>();
                    listTempOps = mapString_Opportunity.get(currProd);
        
                    // Begin get PiggyBack Product...
                    if (mapStringPiggyback.get(currProd) != null)            {
                        tempFieldName =         mapStringPiggyback.get(currProd).Piggyback_Product_Reference__c;
                        tempFIELDCWOwner =      mapStringPiggyback.get(currProd).FIELD_Closed_Won_Owner__c;
                        tempFIELDGuarTerm =     mapStringPiggyback.get(currProd).FIELD_Guarantee_Term__c;
                        tempIsTrackable =       mapStringPiggyback.get(currProd).Trackable__c;
                        tempOwnerAndRole =      mapStringPiggyback.get(currProd).Field_Owner_and_Role__c;
                        tempClientMarkerOnly =  mapStringPiggyback.get(currProd).Client_Marker_Only__c;
                        tempIsSub =             mapStringPiggyback.get(currProd).Subscription__c;
                        tempIsSubGapDetect =    mapStringPiggyback.get(currProd).Subscription_Gaps__c;
                        tempWonRegardless  =    mapStringPiggyback.get(currProd).CloseWon_Regardless__c;
                        tempInvoiceInfo =       mapStringPiggyback.get(currProd).Includes_Invoice_Info__c;
                        tempFIELDSInvoiceData = mapStringPiggyback.get(currProd).FIELDS_Sale_Invoicing_Data__c;
                        tempFIELDMoodleAccess = mapStringPiggyback.get(currProd).FIELD_Moodle_Access__c;
             
                        if (tempFieldName != null)                {
        
                            Date        temp_CkCreateDate =         null;
                            Integer     temp_NumRefundCancels =     0;  
                            Integer     temp_NumDefaultCollections =0;  // 2015-04-12 added for "Moodle" marker use - mimics NumRefundCancels counter
                            Integer     temp_NumClosedWons =        0;  // this counter is for "proper" closed wons (no refund/cancel sub-stage)
            // 2015-06-04 when setting up the MOODLE addition, there was confusion on the use of the above variable...
            // it was used as if it was a count of CLosedWons, NOT ClosedWons minus any Refunds/Cancels...
            // On this day, it has been fixed (AMalena) inside the counting logic further down this trigger
                            Date        temp_PB_SubBegin =          null;
                            Date        temp_PB_CurrSubBeg =        null;
                            Date        temp_PB_SubEnd =            null;
                            Date        temp_PrevSubEnd =           null;
        
                            Date        temp_FirstSubEnd =          null;
                            Integer     temp_FirstGapLen =          0;
                            Integer     temp_LatestGapLen =         0;
                            Integer     temp_TotalGapLen =          0;
                            Integer     temp_TotalGaps =            0;
                            Integer     tempGapDivValue =           0;
                            Integer     tempSubDayDiff =            0;
                            
                            Decimal     temp_PB_Amount =            0;
                            Date        temp_PB_CloseDate_LATEST =  null;
                            Date        temp_CloseDate_FIRST =      null;
                            Date        temp_CloseDate_Regardless = null;
                            Date        temp_InvoiceInfo =          null;
                            String      temp_PB_Package =           null;
                            String      temp_PB_ChargeType =        null;
                            String      temp_PB_Close_Owner =       null;
                            String      temp_PB_Guar_Term =       null;
        
                            String      temp_PB_Stage =             null;
                            String      temp_PB_SubStage =          null;
                            String      temp_PB_RecordType =        null;
                            Date        temp_PB_CreateDate =        null;
                            String      temp_PB_Owner =             null;
                            String      temp_PB_OwnerRole =         null;
        
                            Decimal     temp_PB_SaleDown1 =         null;
                            Decimal     temp_PB_SaleDown2 =         null;
                            Decimal     temp_PB_SaleQtyInvs =       null;
                            Date        temp_PB_SaleFirstInv =      null;
                            Decimal     temp_PB_SalePerPay =        null;
                            Decimal     temp_Invoice_NumPayments =  null;
                            Decimal     temp_Invoice_TotalDown =    null;
    
    
    
    
            // ============================== Begin LOOP for Opps of CURRENT PRODUCT =================================
    
                            for (Opportunity currOp: listTempOps)                    {
        
                                if (temp_CkCreateDate == null)      {
                                    temp_CkCreateDate = currOp.CreatedDate.date();
                                }
        
                                if ( !tempClientMarkerOnly && currOp.CreatedDate.date() >= temp_CkCreateDate && tempIsTrackable == true )   {
                                    temp_PB_Stage  =        currOp.StageName;
                                    temp_PB_SubStage   =    currOp.Sub_Stage__c;
                                    temp_PB_RecordType =    mapIdRecordType.get(currOp.RecordTypeId).Name;
                                    temp_PB_CreateDate =    currOp.CreatedDate.date();
                                    temp_PB_Owner =         currOp.Owner.FirstName + ' ' + currOp.Owner.LastName;
                                    temp_PB_OwnerRole =     currOp.Owner.UserRole.Name;
                                }
        
            // Prior to 2015-05-12, this used currOp.StageName INAPPROPRIATELY - should have been Sub_Stage__c !!!!
            // Fixed - will impact number of proper "Client" markers as was designed.
                            if ( currOp.StageName == 'Closed Won' &&
                                 ( currOp.Sub_Stage__c == 'Refund' || currOp.Sub_Stage__c == 'Cancelled') 
                               )    {
                                    temp_NumRefundCancels++;
                               }
        
            // 2015-04-12 for "Moodle" marker (originally)
                            if ( currOp.StageName == 'Closed Won' &&
                                     ( currOp.Sub_Stage__c == 'Default' || currOp.Sub_Stage__c == 'Collections' ) 
                                   )    {
                                    temp_NumDefaultCollections++;
                                }
        
        
        
                                if (currOp.StageName == 'Closed Won' ) {
                                    temp_Invoice_NumPayments =  currOp.Sale_Invoice_Qty_Payments_After_Down__c;
                                    temp_Invoice_TotalDown =    currOp.Sale_TOTAL_Down_Payment__c;
                                    temp_CloseDate_Regardless = currOp.CloseDate;
                                    temp_PB_Close_Owner =       currOp.OwnerId;
                                    temp_PB_Guar_Term =         currOp.Guarantee_Terms__c;
                                } 
        
        
                                if (currOp.StageName == 'Closed Won' && currOp.Sub_Stage__c != 'Cancelled' && currOp.Sub_Stage__c != 'Refund') {
                                    temp_NumClosedWons++;
                                    if (currOp.Purchase_Amount__c != null || currOp.Sale_TOTAL_Amount_To_Be_Invoiced__c != null)  {
        
                                        if ( currOp.Sale_TOTAL_Amount_To_Be_Invoiced__c != null ) { 
                                            temp_PB_Amount = temp_PB_Amount + currOp.Sale_TOTAL_Amount_To_Be_Invoiced__c; 
                                        } else if ( currOp.Purchase_Amount__c != null ) { 
                                            temp_PB_Amount = temp_PB_Amount + currOp.Purchase_Amount__c; 
                                        }
                                        
                                        temp_PB_CloseDate_LATEST =  currOp.CloseDate; 
                                        temp_PB_SaleDown1 = currOp.Sale_Down_Payment_1_of_4__c;
                                        temp_PB_SaleDown2 = currOp.Sale_Down_Payment_2_of_4__c;
                                        temp_PB_SaleQtyInvs = currOp.Sale_Invoice_Qty_Payments_After_Down__c;
                                        temp_PB_SaleFirstInv = currOp.Sale_Invoice_First_Date_After_Down__c;
                                        temp_PB_SalePerPay = currOp.Sale_Invoice_Amount_Due_Per__c;
                                    }
                                    temp_CloseDate_FIRST =      currOp.CloseDate;
                                } else {
                                    temp_PB_CloseDate_LATEST = null; 
                                }
        
        
            // this is for old "Refunds" done via Refund StageName (way before 2014)..... (versus Sub-Stage)
            // company used to use Opps to give some refunds
                                if (currOp.StageName == 'Refund' && currOp.Purchase_Amount__c != null ) {
                                    temp_PB_Amount = temp_PB_Amount - currOp.Purchase_Amount__c;
                                }
        
        
                                if ( tempIsSub == true)   {  // ** begin ISSUB **
         
                                    if ( currOp.StageName == 'Closed Won' && currOp.Sub_Stage__c != 'Cancelled')   {
        
                                        temp_PB_CurrSubBeg =   currOp.Charting_Start__c;
                                        temp_PrevSubEnd =      temp_PB_SubEnd; 
                                        temp_PB_SubEnd =       currOp.Charting_Expiration__c;
                                        temp_PB_Package =      currOp.Charting_Package__c;
                                        temp_PB_ChargeType =   currOp.Charting_Charge_Type__c;
        
                                        if ( temp_PB_SubBegin == null )  {
                                            temp_PB_SubBegin =     currOp.Charting_Start__c;  // FIRST sub begin
                    // GAP DETECTION for MattM (AMalena) Dec 2012
                                            temp_FirstSubEnd =     temp_PB_SubEnd;
                                        }
        
                    // GAP DETECTION for MattM (AMalena) Dec 2012
                                        if ( temp_PrevSubEnd != null && temp_PB_CurrSubBeg != null ) { 
                                            tempSubDayDiff = temp_PrevSubEnd.daysBetween(temp_PB_CurrSubBeg);
                                        } else {
                                            tempSubDayDiff = 0;
                                        }
                                        if ( temp_PrevSubEnd != null && tempSubDayDiff > 1 ) {  
                                            if ( temp_FirstGapLen < 1 ) {
                                                temp_FirstGapLen = tempSubDayDiff;
                                            }
                                            temp_LatestGapLen = tempSubDayDiff;
                                            temp_TotalGapLen = temp_TotalGapLen + temp_LatestGapLen; // used for Avg calc only
                                            temp_TotalGaps++;
                                        }
        
                                    } 
                                    
                                } // ** end ISSUB **
                                
                            }  
        // ============================== End LOOP for Opps of CURRENT PRODUCT =================================
        
        
        
                        if ( temp_CkCreateDate != null ) {
    
        // **   BE SURE TO COVER ALL FIELDS FOR SETTING TO NULL IF NOT SETTING AT ALL!!!!!!   **
        // **   BE SURE TO COVER ALL FIELDS FOR SETTING TO NULL IF NOT SETTING AT ALL!!!!!!   **
        // **   BE SURE TO COVER ALL FIELDS FOR SETTING TO NULL IF NOT SETTING AT ALL!!!!!!   **
        
        
        // NEED a DELETE routine that clears all fields with Try Catch......
        //                        try{ accObj.put('PB_Stage_UTP_OnDemand__c','testtttttt'); } catch( DMLException exx ){ }
        
        
                                if ( tempFIELDSInvoiceData ) {
                                    accObj.put('pb_DownPay1_' + tempFieldName + '__c', temp_PB_SaleDown1 ) ;
                                    accObj.put('pb_DownPay2_' + tempFieldName + '__c', temp_PB_SaleDown2 ) ;
                                    accObj.put('pb_NumPays_' + tempFieldName + '__c', temp_PB_SaleQtyInvs ) ;
                                    accObj.put('pb_FirstPay_' + tempFieldName + '__c', temp_PB_SaleFirstInv ) ;
                                    accObj.put('pb_PerPay_' + tempFieldName + '__c', temp_PB_SalePerPay ) ;
                                }
        
                                if ( tempFIELDGuarTerm ) {
                                    if( temp_PB_Guar_Term != null ) {  // null handler 
                                        accObj.put('pb_Guarantee_' + tempFieldName + '__c', temp_PB_Guar_Term );
                                    } else {
                                        accObj.put('pb_Guarantee_' + tempFieldName + '__c',  null );
                                    }
                                }
            
                                if ( tempFIELDCWOwner ) {
                                    if( temp_PB_Close_Owner != null ) {  // null handler fix 2012-11-30 AMalena
                                        accObj.put('pb_Close_Owner_' + tempFieldName + '__c',  userMap.get(temp_PB_Close_Owner).name );
                                    } else {
                                        accObj.put('pb_Close_Owner_' + tempFieldName + '__c',  null );
                                    }
                                }
        
        
        
            // "CLIENT" marker - if there are MORE proper closed wons than refunds/cancels on the product
            // 2015-06-04 replaced below                        if (temp_NumClosedWons > 0 && temp_NumRefundCancels < temp_NumClosedWons )   {
                                if (temp_NumClosedWons > 0) {
                                    accObj.put('pb_Client_' + tempFieldName + '__c',  true );
                                    accObj.put('pb_CloseDate_' + tempFieldName + '__c',  temp_CloseDate_FIRST );
                                } else {    // CLEAR fields
                                    accObj.put('pb_Client_' + tempFieldName + '__c',  false );
                                    accObj.put('pb_CloseDate_' + tempFieldName + '__c',  null );
                                }
            // 2015-05-12 "Moodle" marker (if more proper Closed Wons than bad sub-stages - similar to above) (checkbox only)
            // FIRST DEPLOY:  Improperly grouped the FIELDMoodleAccess reference WITH the IF-THEN, causing ELSE to fire improperly
                                if ( tempFIELDMoodleAccess ) {
            // 2015-06-04 replaced below                            if( temp_NumClosedWons > 0 && ( temp_NumRefundCancels + temp_NumDefaultCollections ) < temp_NumClosedWons )   {
                                    if( temp_NumClosedWons > 0 && ( temp_NumDefaultCollections < temp_NumClosedWons ) )   {
                                        accObj.put('pb_Moodle_' + tempFieldName + '__c',  true );
                                    } else {    // CLEAR fields
                                        accObj.put('pb_Moodle_' + tempFieldName + '__c',  false );
                                    }
                                }
            // Only "WONREGARDLESS" products....       (date only)
                                if ( tempWonRegardless )    {
                                    accObj.put('pb_WonRegardless_' + tempFieldName + '__c',  temp_CloseDate_Regardless );
                                }
        
        
            // Only "INVOICE INFO" products....     added 2013-05-10 AMalena                 
                                if ( tempInvoiceInfo )    {
                                    accObj.put('pb_NumPymts_' + tempFieldName + '__c', temp_Invoice_NumPayments  );
                                    accObj.put('pb_TotalDown_' + tempFieldName + '__c', temp_Invoice_TotalDown  );
                                }
                                                    
            // ALL *EXCEPT* ClientMarker Only products.............
                                if ( !tempClientMarkerOnly )    {
                                    if ( temp_PB_Amount > 0)    {
                                        accObj.put('pb_Amount_' + tempFieldName + '__c',  temp_PB_Amount);
                                    } else { // CLEAR fields
                                        accObj.put('pb_Amount_' + tempFieldName + '__c',  null );
                                    }
                                }
            
            // IS TRACKABLE products......
                                if ( tempIsTrackable  )  {
                                    accObj.put('pb_Stage_'      + tempFieldName + '__c',  temp_PB_Stage );
                                    accObj.put('pb_SubStage_'   + tempFieldName + '__c',  temp_PB_SubStage  );
                                    accObj.put('pb_RecordType_' + tempFieldName + '__c',  temp_PB_RecordType );
                                    accObj.put('pb_CreateDate_' + tempFieldName + '__c',  temp_PB_CreateDate );
                                    
                                }
                                
            //Owner and Role.........                    
                                if( tempOwnerAndRole ) {
                                    accObj.put('pb_Owner_' + tempFieldName + '__c',  temp_PB_Owner );
                                    accObj.put('pb_OwnerRole_' + tempFieldName + '__c',  temp_PB_OwnerRole );
                                }
            
            // SUBSCRIPTION products.........
                                if ( tempIsSub == true )    {
                                    accObj.put('pb_SubBegin_' +    tempFieldName + '__c',   temp_PB_SubBegin);
                                    accObj.put('pb_CurrSubBeg_' +  tempFieldName + '__c',   temp_PB_CurrSubBeg);
                                    accObj.put('pb_SubEnd_' +      tempFieldName + '__c',   temp_PB_SubEnd);
                                    accObj.put('pb_PrevSubEnd_' +  tempFieldName + '__c',   temp_PrevSubEnd);
            
                                    // added 2012-01-09
                                    accObj.put('pb_Package_' +     tempFieldName + '__c',   temp_PB_Package);     
                                    accObj.put('pb_ChargeType_' +  tempFieldName + '__c',   temp_PB_ChargeType);  
                                }
        
                                if ( tempIsSubGapDetect == true )    {
                        // GAP DETECTION for MattM (AMalena) Dec 2012
                                    // added 2012-12-10
                                    accObj.put('pb_FrstSubEnd_' +  tempFieldName + '__c',   temp_FirstSubEnd);   
                                    accObj.put('pb_FrstGapLen_' +  tempFieldName + '__c',   temp_FirstGapLen);   
                                    accObj.put('pb_LtstGapLen_' +  tempFieldName + '__c',   temp_LatestGapLen);  
                                    accObj.put('pb_TotNumGaps_' +  tempFieldName + '__c',   temp_TotalGaps);   
                                    if ( temp_TotalGapLen > 0 && temp_TotalGaps > 0 ) { 
                                        tempGapDivValue = temp_TotalGapLen / temp_TotalGaps; }
                                    else { 
                                        tempGapDivValue = null; }
                                    accObj.put('pb_AvgGapLen_' +   tempFieldName + '__c',   tempGapDivValue );   // added 2012-12-10
            
                                }
                                
                            }
        
                        }  // ========= end of if (tempFieldName != null)
        
                    }  // ------------------ END get PiggyBack Product...
        
        
        // Updated on 2012-10-18          formerly:  update accObj;
                    PiggybackTriggerManager.PBOppFromAccountCheck = true;
        
                    if( !updateMap.containsKey((String)accObj.get('Id') ) ) { //check that Acc Id not already added
                        updateMap.put((String)accObj.get('Id'), (Account)accObj);
                        if(updateMap.size() >= 199) {
                            Database.update( updateMap.values() );
                        }
                    }
        
                } // -- end FOR currProd mapString --
        
            } //  END For loop of ACCOUNTS.......
        
        // catchall for any remaining...
            System.debug(LoggingLevel.ERROR,'@@@@ Updating account from piggyback...');
            Database.update( updateMap.values() );
            //}//End After Logic
        }  // END BYPASS
    }
}