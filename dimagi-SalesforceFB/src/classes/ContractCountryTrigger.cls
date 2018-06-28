/**
 * Updates the Country_Text__c field in Contract with the names of the Contract Countries
 *
 * @author  Virginia Fernández
 * @date    04/12/2013
 */
public with sharing class ContractCountryTrigger {
	
    public static void onUpdate(Contract_Country__c[] newContrCountries) {
        Set<Id> contrIds = new Set<Id>();
        
        for (Contract_Country__c cci : newContrCountries) {
            contrIds.add(cci.Contract__c);
        }
        
        Map<Id, DContract__c> mapContracts = new Map<Id, DContract__c>();
        Set<Id> countriesIds = new Set<Id>();
        
        List<DContract__c> contracts = [select Id, Country_Text__c, 
                                               (select Country__c from Contract_Countries__r)
                                  from DContract__c 
                                  where id in :contrIds];
                                  
        for (DContract__c contract : contracts) {
            mapContracts.put(contract.Id, contract);
            for (Contract_Country__c contrCountry : contract.Contract_Countries__r) {
                countriesIds.add(contrCountry.Country__c);
            }
                                                        
        }
                  
        Map<Id, String> countryNames = new Map<Id, String>();       
        for (Country__c country: [select Id, Name from Country__c where Id in :countriesIds]) {
            countryNames.put(country.Id, country.Name);
        }       
        
        for (DContract__c contract : contracts) {
            contract.Country_Text__c = '';
            for (Contract_Country__c contractCountry : contract.Contract_Countries__r) {
                
                if ((contract.Country_Text__c != '') && (!contract.Country_Text__c.endsWith('; '))) {
                    contract.Country_Text__c += '; ';
                }
                contract.Country_Text__c += countryNames.get(contractCountry.Country__c);
            }
        }
        
        update contracts;
    }
}