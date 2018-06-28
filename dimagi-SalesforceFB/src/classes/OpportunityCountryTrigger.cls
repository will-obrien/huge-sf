/**
 * Updates the Country_Text__c field in Opportunity with the names of the Opportunity Countries
 *
 * @author  Virginia Fernández
 * @date    04/12/2013
 */
public with sharing class OpportunityCountryTrigger {
	
    public static void onUpdate(OpportunityCountry__c[] newOppCountries) {
        Set<Id> oppIds = new Set<Id>();
        
        for (OpportunityCountry__c oci : newOppCountries) {
            oppIds.add(oci.Opportunity__c);
        }
        
        Map<Id, Opportunity> mapOpps = new Map<Id, Opportunity>();
        Set<Id> countriesIds = new Set<Id>();
        
        List<Opportunity> opps = [select Id, Country_Text__c, 
                                         (select Country__c from OpportunityCountries__r) 
                                  from Opportunity 
                                  where id in :oppIds];
                                  
        for (Opportunity opp : opps) {
            mapOpps.put(opp.Id, opp);
            for (OpportunityCountry__c oppCountry : opp.OpportunityCountries__r) {
                countriesIds.add(oppCountry.Country__c);
            }
                                                        
        }
                  
        Map<Id, String> countryNames = new Map<Id, String>();       
        for (Country__c country: [select Id, Name from Country__c where Id in :countriesIds]) {
            countryNames.put(country.Id, country.Name);
        }       
        
        for (Opportunity opp : opps) {
            opp.Country_Text__c = '';
            for (OpportunityCountry__c oppCountry : opp.OpportunityCountries__r) {
                if ((opp.Country_Text__c != '') && (!opp.Country_Text__c.endsWith('; '))) {
                    opp.Country_Text__c += '; ';
                }
                opp.Country_Text__c += countryNames.get(oppCountry.Country__c);
            }
        }
        
        if (!opps.isEmpty() && TriggerContext.runTrigger) {
        	TriggerContext.runTrigger = false;
            update opps;
        }
    }
}