/**************************************************
Class Name: OpportunityContractController
Class Description: Class for Contract creating from an Opportunity
Author: Virginia Fernández (vfernandez@adooxen.com)
Update Date: 2013-04-10
Additional Comments: 
**************************************************/
public with sharing class OpportunityContractController {

    private Opportunity o;

    public OpportunityContractController(ApexPages.StandardController sc) {
        o = fetchOpportunityById(sc.getId());
    }

    private Opportunity fetchOpportunityById(Id opportunityId) {
        Opportunity[] ops = [SELECT Id,
                                    Name,
                                    AccountId,
                                    Area__c,
                                    Sub_Area__c,
                                    Proposal_Dropbox_Location__c,
                                    Funder_Account__c,
                                    Implementing_Business_Unit__c,
                                    Channel_Response__c,
                                    of_Execution_budget_for_GS__c,
                                    Expected_Buffer__c,
                                    Implementation_Type__c,
                                    X7_Long_term_partnership_or_one_off__c,
                                    X10_Major_component_risks__c,
                                    (SELECT Country__c FROM OpportunityCountries__r),
                                    (SELECT PricebookEntryId FROM OpportunityLineItems)
                             FROM Opportunity
                             WHERE Id = :opportunityId];

        return !ops.isEmpty() ? ops[0] : null;
    }

    public PageReference createContract() {
        DContract__c contract = new DContract__c();
        contract.Account__c = o.AccountId;
        contract.Name = o.Name;
        contract.Funder_Account__c = o.Funder_Account__c;
        contract.Prime_Contracting_Business_Unit__c = o.Implementing_Business_Unit__c;
        contract.Efficiency_Owner_BU__c = o.Implementing_Business_Unit__c;
        contract.Area__c = o.Area__c;
        contract.Sub_Area__c = o.Sub_Area__c;
        contract.Proposal_Dropbox_Location__c = o.Proposal_Dropbox_Location__c;
        contract.Long_term_partnership_or_one_off__c = o.X7_Long_term_partnership_or_one_off__c;
        contract.Major_Component_Risks__c = o.X10_Major_component_risks__c;
        contract.Channel__c = o.Channel_Response__c;
        contract.Implementation_Type__c = o.Implementation_Type__c;
        contract.Expected_Buffer__c = o.Expected_Buffer__c;
        contract.of_Services_budget_for_GS__c = o.of_Execution_budget_for_GS__c;
        insert contract;

        List<Contract_Country__c> contractCountries = new List<Contract_Country__c>();
        for (OpportunityCountry__c country : o.OpportunityCountries__r) {
            Contract_Country__c contractCountry = new Contract_Country__c();
            contractCountry.Contract__c = contract.id;
            contractCountry.Country__c = country.Country__c;
            contractCountries.add(contractCountry);
        }
        insert contractCountries;

        List<Id> priceBookEntries = new List<Id>();
        for (OpportunityLineItem lineItem: o.OpportunityLineItems) {
            priceBookEntries.add(lineItem.PricebookEntryId);
        }

        List<PricebookEntry> products = [select Product2Id from PricebookEntry where id in :priceBookEntries];
        List<Contract_Product__c> contractProducts = new List<Contract_Product__c>();
        for (PricebookEntry product: products) {
            Contract_Product__c contractProduct = new Contract_Product__c();
            contractProduct.Contract__c = contract.id;
            contractProduct.Product__c = product.Product2Id;
            contractProducts.add(contractProduct);
        }
        insert contractProducts;

        Contract_Opportunity__c oppContract = new Contract_Opportunity__c();
        oppContract.Opportunity__c = o.Id;
        oppContract.Contract__c = contract.Id;
        insert oppContract;

        PageReference contrPage = new ApexPages.StandardController(contract).view();
        contrPage.setRedirect(true);
        return contrPage;
    }
}