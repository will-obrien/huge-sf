/**
* @author Phillip Cave
* @date 1/2014
* @description Test class for Donation_Upsell__c object.
*/
@isTest
private class DonationUpsellTest {
    
    static testMethod void testOriginalOpportunityAssignmentToUpsellOpportunitiesOffsite() {
        // Create a contact.
        Contact contact = new Contact();
        contact.LastName = 'Doe';
        contact.FirstName = 'John';
        contact.Email = 'john.doe@company.com';
        insert contact;
        
        contact = [SELECT Id, Name, AccountId FROM Contact WHERE Id =: contact.Id];
        
        // Create the orignal donation.
        Opportunity originalDonation = new Opportunity();
        originalDonation.Name = 'Original Donation';
        originalDonation.Amount = 10;
        originalDonation.AccountId = contact.AccountId;
        originalDonation.CloseDate = date.today();
        originalDonation.StageName = 'Posted';
        originalDonation.Order_Id__c = '25';
        insert originalDonation;
        
        // Create the donation to represent the upsell recurring donation.
        Opportunity upsellDonation = new Opportunity();
        upsellDonation.Name = 'Upsell Donation';
        upsellDonation.Amount = 5;
        upsellDonation.AccountId = contact.AccountId;
        upsellDonation.CloseDate = date.today();
        upsellDonation.StageName = 'Posted';
        upsellDonation.Order_Id__c = '26';
        upsellDonation.Is_Recurring_Donation__c = TRUE;
        insert upsellDonation;
        
        Donation_Upsell__c donationUpsell = new Donation_Upsell__c();
        donationUpsell.Name = 'Donation Upsell';
        donationUpsell.Original_Donation__c = originalDonation.Id;
        donationUpsell.Original_Order_Id__c = originalDonation.Order_Id__c;
        donationUpsell.Upsell_Donation__c = upsellDonation.Id;
        donationUpsell.Upsell_Order_Id__c = upsellDonation.Order_ID__c;
        insert donationUpsell;
        
        upsellDonation = [SELECT Original_Donation__c, Original_Order_Id__c FROM Opportunity WHERE Id =: upsellDonation.Id];
        
        System.assertEquals(originalDonation.Id, upsellDonation.Original_Donation__c);
        System.assertEquals(originalDonation.Order_Id__c, upsellDonation.Original_Order_Id__c);
    }

    static testMethod void testOriginalOpportunityAssignmentToUpsellOpportunitiesOnsite() {
        // Create a contact.
        Contact contact = new Contact();
        contact.LastName = 'Doe';
        contact.FirstName = 'John';
        contact.Email = 'john.doe@company.com';
        insert contact;
        
        contact = [SELECT Id, Name, AccountId FROM Contact WHERE Id =: contact.Id];
        
        // Create the upsell recurring donation. Doing this first cause that's how SB does it.  
        npe03__Recurring_Donation__c upsellRecurringDonation = new npe03__Recurring_Donation__c();
        upsellRecurringDonation.Name = 'Upsell Recurring Donation';
        upsellRecurringDonation.npe03__Amount__c = 5;
        upsellRecurringDonation.npe03__Installment_Period__c = 'Monthly';
        upsellRecurringDonation.npe03__Installments__c = 10;
        upsellRecurringDonation.npe03__Contact__c = contact.Id;
        upsellRecurringDonation.npe03__Schedule_Type__c = 'Multiply By';
        upsellRecurringDonation.npe03__Date_Established__c = date.today();
        upsellRecurringDonation.npe03__Open_Ended_Status__c = 'None';
        insert upsellRecurringDonation;
       
        // Create the orignal donation.
        Opportunity originalDonation = new Opportunity();
        originalDonation.Name = 'Original Donation';
        originalDonation.Amount = 10;
        originalDonation.AccountId = contact.AccountId;
        originalDonation.CloseDate = date.today();
        originalDonation.StageName = 'Posted';
        originalDonation.Order_Id__c = '25';
        insert originalDonation;

        // Create a donation upsell object, which happens after everything else
        // has been created.
        Donation_Upsell__c donationUpsell = new Donation_Upsell__c();
        donationUpsell.Name = 'Donation Upsell';
        donationUpsell.Original_Donation__c = originalDonation.Id;
        donationUpsell.Original_Order_Id__c = originalDonation.Order_Id__c;
        donationUpsell.Upsell_Recurring_Donation__c = upsellRecurringDonation.Id;
        insert donationUpsell;
        
        // Assert relationships were established correctly.
        upsellRecurringDonation = [SELECT Original_Donation__c, Original_Order_Id__c FROM
            npe03__Recurring_Donation__c WHERE Id =: upsellRecurringDonation.Id];
            
        System.assertEquals(originalDonation.Id, upsellRecurringDonation.Original_Donation__c);
        System.assertEquals(originalDonation.Order_Id__c, upsellRecurringDonation.Original_Order_Id__c);
        
        List<Opportunity> upsellOpportunities = [SELECT Name, Amount, Original_Donation__c, Original_Order_Id__c FROM Opportunity WHERE
            npe03__Recurring_Donation__c =: upsellRecurringDonation.Id];
        
        // Assert that each opportunity attached to the recurring donation has the correct
        // original upsell opportunity id.
        for (Opportunity upsellOpportunity: upsellOpportunities) {
            System.assertEquals(originalDonation.Id, upsellOpportunity.Original_Donation__c);
            System.assertEquals(originalDonation.Order_Id__c, upsellOpportunity.Original_Order_Id__c);
        }
    }
}