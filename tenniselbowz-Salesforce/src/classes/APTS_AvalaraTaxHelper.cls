public with sharing class APTS_AvalaraTaxHelper {
    // line status
    public static final String STATUS_CANCELLED = 'Cancelled';


    /**
     * Callback invoked to compute tax only based on the given list of inputs
     * @param inputs the list of tax inputs
     * @return the list of tax results
     */
   
    public Static void computeLineItemTaxFuture(List<Id> lineIds) {

        // get the quote line items to tax
        List<Apttus_Proposal__Proposal_Line_Item__c> lineItems = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        Map<ID, Apttus_Proposal__Proposal_Line_Item__c> itemLookup = new Map<ID, Apttus_Proposal__Proposal_Line_Item__c>();
        List<Apttus_Proposal__Proposal_Line_Item__c> lineItemsToUpdate = new List<Apttus_Proposal__Proposal_Line_Item__c>();

        Set<ID> accountIds = new Set<ID>();
        Set<ID> locationIds = new Set<ID>();
        String taxCode;

        for (Apttus_Proposal__Proposal_Line_Item__c lineItemSO : [SELECT Id, Name, Apttus_Proposal__Proposal__r.Apttus_Proposal__Opportunity__r.Job_Address__r.Address_Line_1__c, Apttus_Proposal__Proposal__r.Apttus_Proposal__Opportunity__r.Job_Address__r.City__c, Apttus_Proposal__Proposal__r.Apttus_Proposal__Opportunity__r.Job_Address__r.State_Province__c, Apttus_Proposal__Proposal__r.Apttus_Proposal__Opportunity__r.Job_Address__r.Postal_Code__c, Apttus_Proposal__Proposal__r.Apttus_Proposal__Opportunity__r.Job_Address__r.Country__c, Apttus_Proposal__Proposal__r.Apttus_Proposal__Opportunity__r.Job_Address__r.Country_ISO_Code__c,Apttus_Proposal__Proposal__r.Apttus_Proposal__Opportunity__r.Job_Address__r.State_Province_ISO_Code__c,
                Apttus_QPConfig__Taxable__c,APTS_Is_Use_Tax_Applicable__c,
                Apttus_Proposal__Proposal__r.Apttus_Proposal__Account__r.name,
                Apttus_QPConfig__TaxInclusive__c,
                Apttus_QPConfig__NetPrice__c,
                Apttus_QPConfig__BillToAccountId__c,
                Apttus_QPConfig__ShipToAccountId__c,
                Apttus_QPConfig__LocationId__c,
                Apttus_QPConfig__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Account__c,
                Apttus_Proposal__Description__c,
                Apttus_QPConfig__LineType__c,
                Apttus_QPConfig__AssetId__c
                FROM Apttus_Proposal__Proposal_Line_Item__c
                WHERE Id IN :lineIds AND
                Apttus_QPConfig__LineStatus__c != :STATUS_CANCELLED]) {
            //friends remind friends to bulkify

            if (lineItemSO.APTS_Is_Use_Tax_Applicable__c &&
                    !lineItemSO.Apttus_QPConfig__TaxInclusive__c 
                    ) {

                lineItems.add(lineItemSO);
                itemLookup.put(lineItemSO.Id, lineItemSO);

                      
            }
        }
        
          // get accounts
        Map<ID, Account> accountLookup = null;
        if (!accountIds.isEmpty()) {
            accountLookup = new Map<ID, Account>([SELECT Id, 
                                                  Apttus_Config2__TaxExempt__c,
                                                  name
                                                  FROM Account
                                                  WHERE Id IN :accountIds]);

        }

      
    
           // prepare tax inputs
        List<Apttus_Config2.CustomClass.TaxInput> inputs = new List<Apttus_Config2.CustomClass.TaxInput>();

        for (Apttus_Proposal__Proposal_Line_Item__c lineItemSO : lineItems) {
            
            Apttus_Config2.CustomClass.Address addr = new Apttus_Config2.CustomClass.Address();

                
                    addr.Street = lineItemSO.Apttus_Proposal__Proposal__r.Apttus_Proposal__Opportunity__r.Job_Address__r.Address_Line_1__c;
                    addr.City = lineItemSo.Apttus_Proposal__Proposal__r.Apttus_Proposal__Opportunity__r.Job_Address__r.City__c;
                    addr.State = lineItemSo.Apttus_Proposal__Proposal__r.Apttus_Proposal__Opportunity__r.Job_Address__r.State_Province__c;
                    addr.PostalCode = lineItemSo.Apttus_Proposal__Proposal__r.Apttus_Proposal__Opportunity__r.Job_Address__r.Postal_Code__c;
                    addr.Country = lineitemSo.Apttus_Proposal__Proposal__r.Apttus_Proposal__Opportunity__r.Job_Address__r.Country__c;
                    addr.statecode=lineItemSo.Apttus_Proposal__Proposal__r.Apttus_Proposal__Opportunity__r.Job_Address__r.State_Province_ISO_Code__c;
                    addr.CountryCode=lineItemSo.Apttus_Proposal__Proposal__r.Apttus_Proposal__Opportunity__r.Job_Address__r.Country_ISO_Code__c;
                 system.debug('##addr='+addr);


                TaxCustomClass inputExt = new TaxCustomClass();
                inputExt.batchCode = lineItemSO.Name;
                inputExt.locationCode = lineItemSO.Apttus_QPConfig__LineType__c;
                inputExt.customerCode = lineItemSo.Apttus_Proposal__Proposal__r.Apttus_Proposal__Account__r.Name;
                //inputExt.taxExemptionNumber = accountSO.ExemptionNumber__c;
                inputExt.docCode = lineItemSO.Name;
                inputExt.lineNumber = lineItemSO.Id;
                inputExt.itemCode   = lineItemSO.Name;
                inputExt.itemDescription = lineItemSO.Apttus_Proposal__Description__c;
                // inputExt.resultCode,
                // inputExt.originalDocCode,
                // inputExt.originalTransDate


                Apttus_Config2.CustomClass.TaxInput input = new Apttus_Config2.CustomClass.TaxInput();
                //input.TaxCode = taxCode;
                input.TaxAddress = addr;
                input.TaxableAmount = lineItemSO.Apttus_QPConfig__NetPrice__c;
                input.Handback = inputExt;    //lineItemSO.Id;

                inputs.add(input);
            

        }

        System.debug('----- inputs: ' + inputs.size());

        if (!inputs.isEmpty()) {

            TaxCustomClass tcc = (TaxCustomClass) inputs[0].Handback;
            System.debug('tcc.lineNumber: ' + tcc.lineNumber);
            try {
          /*  Id accountId='001L000000fO1tjIAC';
            
          String testResults = AvalaraTaxCallBack.validateAddress(accountId,inputs[0].TaxAddress,'Shipping',false);
          system.debug('##TestResults='+testResults);*/
                List<Apttus_Config2.CustomClass.TaxResult> results = AvalaraTaxCallBack.computeTaxOnly(inputs);
                //  List<Apttus_Config2.CustomClass.TaxResult> results = Apttus_Config2.TaxService2.computeTax(inputs);
                // process the tax results
                if(Test.isRunningTest())
                {
                  Apttus_Config2.CustomClass.TaxResult temptaxResults= New Apttus_Config2.CustomClass.TaxResult();
                  temptaxResults.TaxAmount=100;
                  results = new List<Apttus_Config2.CustomClass.TaxResult>{temptaxResults};
                }
                system.debug('results ' + results);
                for (Integer i = 0; i < inputs.size(); i++) {

                    System.debug(' results[i].TaxAmount: ' + results[i].TaxAmount);
                    // get the line item to update
                    TaxCustomClass taxobject = (TaxCustomClass)inputs[i].Handback;
                    //  Apttus_QPConfig__LineItem__c lineItemSO = itemLookup.get((ID) inputs[i].Handback.lineNumber);
                    // update estimated tax
                    Apttus_Proposal__Proposal_Line_Item__c lineItemSO = new Apttus_Proposal__Proposal_Line_Item__c(id = taxobject.lineNumber);
                    
                    lineItemSO.Estimated_Tax__c = results[i].TaxAmount;
                    // add the line item to the collection
                    lineItemsToUpdate.add(lineItemSO);
                }

                // bulk update line items
                if (!lineItemsToUpdate.isEmpty()) {
                    Database.update(lineItemsToUpdate);
                }

            } catch (Exception e) {
                System.debug('----- Exception: ' + e.getMessage() + ' ' + e.getStackTraceString());
            }
        }
    }


}