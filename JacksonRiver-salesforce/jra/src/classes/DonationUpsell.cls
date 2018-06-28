/**
* @author Phillip Cave
* @date 1/2014
* @description Implementation class for all Donation_Upsell__c features.
*/
public class DonationUpsell {
    
    /**
    * @author Phillip Cave
    * @date 1/2014
    * @description Sets the original donation the upsell recurring donation and
    *              all opportunties in the series.
    */
    public static void setOriginalDonationIds(List<Donation_Upsell__c> donationUpsells) {
        // Use a list to hold all the recurring donations that need to be updated.
        List<npe03__Recurring_Donation__c> recurringDonationsToUpdate = new List<npe03__Recurring_Donation__c>();
        // Create a map for relating recurring donation Id to opportunity Id 
        Map<ID, Donation_Upsell__c> upsellIds = new Map<ID, Donation_Upsell__c>();
        Map<ID, Donation_Upsell__c> offsiteUpsells = new Map<ID, Donation_Upsell__c>();
    
        for(Donation_Upsell__c upsell: donationUpsells) {
            // We need to separate out onsite and offiste recurring donations.
            // Onsite uses the Upsell_Recurring_Donation__c property and offsite
            // uses the Upsell_Donation__c property.
            if (upsell.Upsell_Recurring_Donation__c != NULL) {
                // Add to our map for later use.
                upsellIds.put(upsell.Upsell_Recurring_Donation__c, upsell);
                
                // Create a recurring donation object and add the original donation id.
                npe03__Recurring_Donation__c recurringDonationToUpdate = new npe03__Recurring_Donation__c();
                recurringDonationToUpdate.Id = upsell.Upsell_Recurring_Donation__c;
                recurringDonationToUpdate.Original_Donation__c = upsell.Original_Donation__c;
                recurringDonationToUpdate.Original_Order_Id__c = upsell.Original_Order_Id__c;
                recurringDonationsToUpdate.add(recurringDonationToUpdate);
            }
            else if (upsell.Upsell_Donation__c != NULL) {
                offsiteUpsells.put(upsell.Upsell_Donation__c, upsell);
            }
        }
        
        // Update the recurring donations and their child opportunities. This logic
        // only happens for onsite recurring.
        if (recurringDonationsToUpdate.size() > 0) {
            update recurringDonationsToUpdate;
        
    
            // Get all the opportunities in every recurring donation that was updated.
            List<Opportunity> opportunities = [SELECT Id, npe03__Recurring_Donation__c FROM Opportunity WHERE npe03__Recurring_Donation__c IN :upsellIds.keySet()];
        
            // Add the original opportunity id to each upsell opportunity.
            for (Opportunity opportunity : opportunities) {
                opportunity.Original_Donation__c = upsellIds.get(opportunity.npe03__Recurring_Donation__c).Original_Donation__c;
                opportunity.Original_Order_Id__c = upsellIds.get(opportunity.npe03__Recurring_Donation__c).Original_Order_Id__c;
            }   
            
            // Update the opportunities.
            update opportunities;
        }
        
        // Update the opportunities. This only happens for offsite recurring.
        if (offsiteUpsells.size() > 0) {
            List<Opportunity> upsellOpportunities = new List<Opportunity>();
            for (ID upsellDonationId : offsiteUpsells.keySet()) {
                upsellOpportunities.add(new Opportunity(
                    Id = upsellDonationId,
                    Original_Donation__c = offsiteUpsells.get(upsellDonationId).Original_Donation__c,
                    Original_Order_Id__c = offsiteUpsells.get(upsellDonationId).Original_Order_Id__c
                ));
            }
            
            update upsellOpportunities;
        }
    }
    
}