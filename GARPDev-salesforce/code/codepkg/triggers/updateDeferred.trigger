trigger updateDeferred on Opportunity(after update, before update) {
    /*
      
       This is most important trigger which drives the business logic of when the payment is done weather to upgrate or to extend the contract
    */

    // Defining all the variables that will used and assigning the values.

    Set < ID > setExamAttempts = new Set < Id > ();
    Set < ID > setUnDeferredExamAttempts = new Set < Id > ();
    Set < Id > setaccIdsforContracts = new Set < Id > ();
    Map < Id, Opportunity > mapOppForContracts = new Map < Id, Opportunity > ();
    Map < Id, Set < String >> mapProdCodesWithAccount = new Map < Id, Set < String >> ();
    Map < Id, Set < String >> mapProductCodes = new Map < Id, Set < String >> ();
    opportunity oppForContract = new opportunity();
    opportunity oppForRenewContract = new opportunity();
    Set < Id > setAcctoUpdateContracts = new Set < Id > ();
    Set < ID > setERPAccounts = new Set < ID > ();
    Set < ID > setFRMAccounts = new Set < ID > ();
    Set < ID > setAllAccounts = new Set < ID > ();
    Set < Id > setAutoRenewAccounts = new Set < Id > ();
    Set < Opportunity > setOpps = new Set < Opportunity > ();
    Set < Id > setRenewOpps = new Set < Id > ();
    Set < Id > setAccountIds = new Set < Id > ();
    Set < Id > setAccts = new Set < Id > ();
    Map < Id, Opportunity > mapUpdateShipServieOpps = new Map < Id, Opportunity > ();
	Map < Id, Opportunity > eBookFRM1ProvisionOpps = new Map < Id, Opportunity > ();    
    Map < Id, Opportunity > eBookFRM2ProvisionOpps = new Map < Id, Opportunity > ();    
	Map < Id, Opportunity > eBookERP1ProvisionOpps = new Map < Id, Opportunity > ();    
    Map < Id, Opportunity > eBookERP2ProvisionOpps = new Map < Id, Opportunity > ();    
    
    Map < Id, Opportunity > wileyOpps = new Map < Id, Opportunity > ();

    Set < ID > setRegisterExamAttempts = new Set < Id > ();
    
    Boolean bIsClosed = false;
    for (Opportunity opp: trigger.new) {
        if ((opp.stagename == 'Closed' || opp.stagename == 'Recurring Intent') && trigger.oldMap.get(opp.Id).StageName != opp.StageName)
            bIsClosed = true;

    }



    if (!bIsClosed) return;

    Map < Id, Id > mapLineItems = new Map < Id, Id > ();
    Map < Id, Boolean > maphasFRM1EBook = new Map < Id, Boolean > ();
    Map < Id, Boolean > maphasFRM2EBook = new Map < Id, Boolean > ();
    Map < Id, Boolean > maphasERP1EBook = new Map < Id, Boolean > ();
    Map < Id, Boolean > maphasERP2EBook = new Map < Id, Boolean > ();
    Map < Id, OpportunityLineItem > maphasWiley = new Map < Id, OpportunityLineItem > ();


    for (OpportunityLineItem oppLine: [select id, Name, ProductCode, OpportunityId, UnitPrice, Quantity, Opportunity.accountID from OpportunityLineItem where OpportunityId in : trigger.new]) {
        if (oppLine.ProductCode == 'FRM1' && oppLine.UnitPrice == 150) {
            Id frmRecordType = RecordTypeHelper.GetRecordTypeId('Contract', 'FRM Program');
            mapLineItems.put(oppLine.Opportunity.accountID, frmRecordType);
        } else if (oppLine.ProductCode == 'ENC' && oppLine.UnitPrice == 150) {
            Id erpRecordType = RecordTypeHelper.GetRecordTypeId('Contract', 'ERP Program');
            mapLineItems.put(oppLine.Opportunity.accountID, erpRecordType);
        } else if (oppLine.ProductCode == 'FRM1X') {
            maphasFRM1EBook.put(oppLine.OpportunityId, true);
        } else if (oppLine.ProductCode == 'FRM2X') {
            maphasFRM2EBook.put(oppLine.OpportunityId, true);
        } else if (oppLine.ProductCode == 'ENC1X') {
            maphasERP1EBook.put(oppLine.OpportunityId, true);
        } else if (oppLine.ProductCode == 'ENC2X') {
            maphasERP2EBook.put(oppLine.OpportunityId, true);
        } else if (oppLine.ProductCode == 'MEMW') {
            maphasWiley.put(oppLine.OpportunityId, oppLine);
        }


        if (mapProductCodes.containsKey(oppLine.OpportunityId))
            mapProductCodes.get(oppLine.OpportunityId).add(oppLine.ProductCode);
        else
            mapProductCodes.put(oppLine.OpportunityId, new Set < String > {
                oppLine.ProductCode
            });

        if (mapProdCodesWithAccount.containsKey(oppLine.Opportunity.accountID))
            mapProdCodesWithAccount.get(oppLine.Opportunity.accountID).add(oppLine.ProductCode);
        else
            mapProdCodesWithAccount.put(oppLine.Opportunity.accountID, new Set < String > {
                oppLine.ProductCode
            });

    }

    system.debug('maphasFRME1Book:' + maphasFRM1EBook);
    system.debug('maphasFRME2Book:' + maphasFRM2EBook);
    system.debug('maphasERPE1Book:' + maphasERP1EBook);
    system.debug('maphasERPE2Book:' + maphasERP2EBook);

    for (Opportunity opp: trigger.new) {

        if (!(trigger.isBefore && trigger.isInsert)) {

            if (mapProductCodes.get(opp.Id) != null) {

                // This is logic for the when the user defers the exam and the values in the correspondign fields are placed from the web.         
                if (opp.stagename == 'Closed' && trigger.oldMap.get(opp.Id).StageName != opp.StageName && opp.EA_Id__c != null && (mapProductCodes.get(opp.Id).Contains('ENC') || mapProductCodes.get(opp.Id).Contains('FRM1'))) {
                    setExamAttempts.add(opp.EA_Id__c);
                }
                // This is logic for the when the user un-defers the exam and the values in the correspondign fields are placed from the web.       

                if (opp.stagename == 'Closed' && trigger.oldMap.get(opp.Id).StageName != opp.StageName && opp.Undefred_EA_Id__c != null && (mapProductCodes.get(opp.Id).Contains('ENC') || mapProductCodes.get(opp.Id).Contains('FRM1'))) {
                    setUnDeferredExamAttempts.add(opp.Undefred_EA_Id__c);
                }

                if (opp.stagename == 'Closed' && trigger.oldMap.get(opp.Id).StageName != opp.StageName) {

                    Set < String > rprods = mapProductCodes.get(opp.Id);
                    if((rprods.Contains('ENC1E') || rprods.Contains('ENC1S') || rprods.Contains('ENC1L')) ||
                      (rprods.Contains('ENC2E') || rprods.Contains('ENC2S') || rprods.Contains('ENC2L')) ||
                      (rprods.Contains('FRM1E') || rprods.Contains('FRM1S') || rprods.Contains('FRM1L')) ||
                      (rprods.Contains('FRM1E') || rprods.Contains('FRM1S') || rprods.Contains('FRM1L')))
                    		setRegisterExamAttempts.add(opp.Deferred_Exam_Registration__c);
                    
                }

            }

            // This is the logic for the switching programs.         
            if (opp.stagename == 'Closed' && trigger.oldMap.get(opp.Id).StageName != opp.StageName) {

                if (opp.Has_Books__c && trigger.isBefore) {

                    if (opp.Shipping_Street__c != null) {
                        String[] strAddress = opp.Shipping_Street__c.split('\n');
                        system.debug('strAddress :' + strAddress);
                        system.debug('Size :' + strAddress.size());
                        if (strAddress != null) {
                            try {
                                opp.Shipping_Address1__c = strAddress[0];
                                opp.Shipping_Address2__c = strAddress[1];
                                opp.Shipping_Address3__c = strAddress[2];
                            } catch (exception ex) {

                            }
                        }


                    }
                    CountryCodes__c countryCodes = CountryCodes__c.getValues(opp.Shipping_Country__c);
                    opp.Country_Code_for_UPS__c = countryCodes != null ? countryCodes.Country_Code__c : '';


                    mapUpdateShipServieOpps.put(opp.Id, opp);

                }

                // Switching to ERP.            
                if (opp.Switch_to_erp__c) {

                    setERPAccounts.add(opp.accountID);
                    setOpps.add(opp);
                }
                // Switching to frm.
                else if (opp.Switch_to_frm__c) {

                    setFRMAccounts.add(opp.accountID);
                    setOpps.add(opp);
                }
            }
            // A blank opportunity is created when the user chooses to do the recurring for the future and his contract end date is greater so we have to use the token,logic for what we do with that opportuntiy.   

            if ((opp.stagename == 'Recurring Intent') && trigger.oldMap.get(opp.Id).StageName != opp.StageName && opp.Auto_Renew__c && trigger.isafter) {

                setAccts.add(opp.accountId);
            }

            Boolean hasEBook = maphasFRM1EBook.get(opp.Id);
            if (opp.StageName == 'Closed' && trigger.oldMap.get(opp.Id).StageName != opp.StageName && hasEBook == True) {
                eBookFRM1ProvisionOpps.put(opp.Id, opp);
                system.debug('eBookFRM1ProvisionOpps:' + opp);
            }

            hasEBook = maphasFRM2EBook.get(opp.Id);
            if (opp.StageName == 'Closed' && trigger.oldMap.get(opp.Id).StageName != opp.StageName && hasEBook == True) {
                eBookFRM2ProvisionOpps.put(opp.Id, opp);
                system.debug('eBookFRM2ProvisionOpps:' + opp);
            }

            hasEBook = maphasERP1EBook.get(opp.Id);
            if (opp.StageName == 'Closed' && trigger.oldMap.get(opp.Id).StageName != opp.StageName && hasEBook == True) {
                eBookERP1ProvisionOpps.put(opp.Id, opp);
                system.debug('eBookERP1ProvisionOpps:' + opp);
            }

            hasEBook = maphasERP2EBook.get(opp.Id);
            if (opp.StageName == 'Closed' && trigger.oldMap.get(opp.Id).StageName != opp.StageName && hasEBook == True) {
                eBookERP2ProvisionOpps.put(opp.Id, opp);
                system.debug('eBookERP2ProvisionOpps:' + opp);
            }

            
            OpportunityLineItem hasWiley = maphasWiley.get(opp.Id);
            if (opp.StageName == 'Closed' && trigger.oldMap.get(opp.Id).StageName != opp.StageName && hasWiley != NULL && trigger.isafter) {
                wileyOpps.put(opp.Id, opp);
                system.debug('wileyOpps:' + opp);
            }


        }

        if (opp.StageName == 'Closed' && trigger.oldMap.get(opp.Id).StageName != opp.StageName && (opp.Renew_Membership__c || opp.Eligible_for_Membership_Extension__c || opp.Auto_Renew__c || opp.Wiley__c)) {
            setRenewOpps.add(opp.Id);
            setAccountIds.add(opp.accountId);
            oppForRenewContract = opp;

        }

    }


    if (!opportunityTriggerUtils.bUpdateEA)
        opportunityTriggerUtils.updateExamAttempts(setExamAttempts, setUnDeferredExamAttempts);

    if(setRegisterExamAttempts.size() > 0)
        opportunityTriggerUtils.updateRegisterExamAttempts(setRegisterExamAttempts);
    
    // passing the above lists to the corresponding methods
    if (setOpps.size() > 0 && Trigger.isAfter && !SwitchExamCreation.bIsRecursiveForOpps) {
        SwitchExamCreation.checkExamAttempts(setERPAccounts, setFRMAccounts, setOpps);

    }
    if (mapLineItems.size() > 0) {
        Id frmRecType = RecordTypeHelper.GetRecordTypeId('Contract', 'FRM Program');
        Id erpRecType = RecordTypeHelper.GetRecordTypeId('Contract', 'ERP Program');

        List < Contract > lstCons = new List < Contract > ();
        for (Contract objCon: [select id, name, Enrollment_paid_for_2009__c, accountId, RecordType.Name from Contract where accountId in : mapLineItems.keySet() and(Status = : 'Activated'
                or Status = : 'Activated ( Auto-Renew )') and(recordTypeId = : frmRecType or recordTypeId = : erpRecType)]) {
            Id idVal = mapLineItems.get(objCon.accountId);
            if (objCon.RecordTypeId == idVal)
                objCon.Enrollment_paid_for_2009__c = true;

            lstCons.add(objCon);
        }

        if (lstCons.size() > 0)
            update lstCons;

    }
    // passing the above lists to the corresponding methods
    if (setRenewOpps.size() > 0 && Trigger.isAfter && !opportunityTriggerUtils.bIsRecursiveForRenewOpps) {
        opportunityTriggerUtils.updteRenewContracts(setRenewOpps, setAccountIds, mapProdCodesWithAccount, oppForRenewContract);
    }
    // passing the above lists to the corresponding methods
    if (mapUpdateShipServieOpps.size() > 0 && !opportunityTriggerUtils.bIsRecursiveForOpps) {
        opportunityTriggerUtils.updateShipService(mapUpdateShipServieOpps);
    }
    // passing the above lists to the corresponding methods
    if (setAccts.size() > 0 && !opportunityTriggerUtils.bAutoRenew) {
        opportunityTriggerUtils.updateautorenew(setAccts);
    }

    system.debug('eBookFRM1ProvisionOpps:' + eBookFRM1ProvisionOpps);
    if (eBookFRM1ProvisionOpps.size() > 0) {
        opportunityTriggerUtils.provisionEBook(eBookFRM1ProvisionOpps,'FRM Exam Part I');
    }

    system.debug('eBookFRM2ProvisionOpps:' + eBookFRM2ProvisionOpps);
    if (eBookFRM2ProvisionOpps.size() > 0) {
        opportunityTriggerUtils.provisionEBook(eBookFRM2ProvisionOpps,'FRM Exam Part II');
    }
    
    system.debug('eBookERP1ProvisionOpps:' + eBookERP1ProvisionOpps);
    if (eBookERP1ProvisionOpps.size() > 0) {
        opportunityTriggerUtils.provisionEBook(eBookERP1ProvisionOpps,'ERP Exam Part I');
    }

    system.debug('eBookERP2ProvisionOpps:' + eBookERP2ProvisionOpps);
    if (eBookERP2ProvisionOpps.size() > 0) {
        opportunityTriggerUtils.provisionEBook(eBookERP2ProvisionOpps,'ERP Exam Part II');
    }

    system.debug('wileyOpps:' + wileyOpps);

    if (wileyOpps.size() > 0) {
        opportunityTriggerUtils.extendWiley(wileyOpps,maphasWiley);
    }
    
}