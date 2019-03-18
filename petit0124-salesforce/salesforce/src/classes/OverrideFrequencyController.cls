global class OverrideFrequencyController implements zqu.ZQuoteRulesEngine.QuoteRulesEnginePlugin {
    
    public static Boolean runValidationRules(zqu__Quote__c quote, List < zqu.ZChargeGroup > zcgs, List < zqu.ZQuoteRulesEngine.ChangeLog > logs) {
        //get the product rate plan charge data
        List<ID> productRatePlanChargeIds = new List<ID>();
        Map<Id,zqu__ProductRatePlanCharge__c> productRatePlanChargeMap = new Map<Id, zqu__ProductRatePlanCharge__c>();
        if(quote.Id != null){
            for(zqu.ZChargeGroup zcg : zcgs){
                if (zcg.groupType == zqu.zChargeGroup.TYPE_PRODUCT_NEW || zcg.groupType == zqu.zChargeGroup.TYPE_SUBSCRIPTION_ADDED || zcg.groupType == zqu.zChargeGroup.TYPE_AMENDMENT_NEWPRODUCT || zcg.groupType == zqu.zChargeGroup.TYPE_RENEWAL_NEWPRODUCT){
                    for (zqu.zCharge zc : zcg.zCharges) {
                        if (zc.isEffectivePriceEditable) {
                            productRatePlanChargeIds.add(zc.PRODUCT_RATE_PLAN_CHARGE_SFDC_ID);
                        }
                    }
                }
            }
            if (productRatePlanChargeIds.size()>0) {
                for(zqu__ProductRatePlanCharge__c prpc : [SELECT id,name,Sales_Edit_Price__c FROM zqu__ProductRatePlanCharge__c 
                                                           WHERE id IN :productRatePlanChargeIds]) { 
                    productRatePlanChargeMap.put(prpc.id,prpc);
                }
            }

            for(zqu.ZChargeGroup zcg : zcgs){
                if (zcg.groupType == zqu.zChargeGroup.TYPE_PRODUCT_NEW || zcg.groupType == zqu.zChargeGroup.TYPE_SUBSCRIPTION_ADDED || zcg.groupType == zqu.zChargeGroup.TYPE_AMENDMENT_NEWPRODUCT || zcg.groupType == zqu.zChargeGroup.TYPE_RENEWAL_NEWPRODUCT){
                    for (zqu.zCharge zc : zcg.zCharges) {
                        if (zc.isEffectivePriceEditable) {
                            //to check whether sales team can edit the product rate plan charge
                            if(!productRatePlanChargeMap.get(zc.PRODUCT_RATE_PLAN_CHARGE_SFDC_ID).Sales_Edit_Price__c){
                                if (zc.EFFECTIVE_PRICE != zc.LIST_PRICE) {
                                    zqu.ZQuoteRulesEngine.ChangeLog log = new zqu.ZQuoteRulesEngine.ChangeLog();
                                    log.description = 'The product rate plan charge '+ productRatePlanChargeMap.get(zc.PRODUCT_RATE_PLAN_CHARGE_SFDC_ID).Name + ' cannot change the price.';
                                    logs.add(log);
                                    return false;
                                }
                            }
                        }
                    }
                }
            }
        }
        return true;
    }

    public static void runPriceRules(List < zqu.ZChargeGroup > zcgs, List < zqu.ZQuoteRulesEngine.ChangeLog > logs) {
        //Loops through all ChargeGroups on the Quote
        for (zqu.ZChargeGroup zcg: zcgs) {
            if (zcg.groupType == zqu.zChargeGroup.TYPE_PRODUCT_NEW || zcg.groupType == zqu.zChargeGroup.TYPE_SUBSCRIPTION_ADDED || zcg.groupType == zqu.zChargeGroup.TYPE_AMENDMENT_NEWPRODUCT || zcg.groupType == zqu.zChargeGroup.TYPE_RENEWAL_NEWPRODUCT) {
                List < SObject > chargeObjectList = new List < SObject > ();
                List < zqu.zCharge > zChargeList = new List < zqu.zCharge > ();
                //Loops through each Charge in the ChargeGroup
                for (zqu.zCharge zc1: zcg.zCharges) {
                    SObject qc = new zqu__QuoteCharge__c();
                    qc.put('ID', zc1.Id);
                    qc.put('zqu__ProductRatePlanCharge__c', zc1.PRODUCT_RATE_PLAN_CHARGE_SFDC_ID);
                    qc.put('zqu__Discount__c', 20);
                    qc.put('My_Statement_For_charge__c','test program'+ System.now());
                    chargeObjectList.add(qc);
                    zChargeList.add(zc1);
                }

                /*** Run rules engine logic here using chargeObjectList - start  ***/
                // Put all changed field names into map : Map<charge.ProductRatePlanCharge__c, List<ChangedFieldNames>>
                Map < String, List < String >> changedFieldMap = new Map < String, List < String >> ();
                for (Integer index = 0; index < chargeObjectList.size(); index++) {
                    SObject charge = chargeObjectList.get(index);
                    zqu.zCharge zc = zChargeList.get(index);
                    String productRatePlanChargeId = String.valueOf(charge.get('zqu__ProductRatePlanCharge__c'));
                    if (changedFieldMap.get(productRatePlanChargeId) == null) {
                        changedFieldMap.put(productRatePlanChargeId, new List < String > ());
                    }
                    //Add all fields that will be set
                    changedFieldMap.get(productRatePlanChargeId).add('zqu__Discount__c');
                    changedFieldMap.get(productRatePlanChargeId).add('zqu__Period__c');
                    changedFieldMap.get(productRatePlanChargeId).add('My_Statement_For_charge__c');
                }
                /*** Run rules engine logic here using chargeObjectList - complete  ***/
                // Update zChargeGroup from charge object list
                if (!Test.isRunningTest()) {
                    zqu.zQuoteUtil.updateZChargeGroupFromSObject(zcg, chargeObjectList, changedFieldMap, '');
                }
            }
        }
    }

  public static Map < String, List < String >> runProductRules(zqu__Quote__c quote, List < String > ratePlanIds, List < zqu.ZQuoteRulesEngine.ChangeLog > logs) {
    Map < String, List < String >> relatedRatePlanIdMap = new Map < String, List < String >> ();
    relatedRatePlanIdMap.put(zqu.ZQuoteRulesEngine.PRODUCT_RULE_TYPE_ADDED_ENABLED, new List < String > ());
    relatedRatePlanIdMap.put(zqu.ZQuoteRulesEngine.PRODUCT_RULE_TYPE_ADDED_DISABLED, new List < String > ());
    relatedRatePlanIdMap.put(zqu.ZQuoteRulesEngine.PRODUCT_RULE_TYPE_REMOVED_ENABLED, new List < String > ());
    Set < String > existingRatePlans = new Set < String > ();
    if (ratePlanIds != null) {
      existingRatePlans.addAll(ratePlanIds);
    }
    // Change log
    zqu.ZQuoteRulesEngine.ChangeLog log;
    return relatedRatePlanIdMap;
  }
}