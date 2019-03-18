@isTest(SEEALLDATA = true)
Public Class TestTravellerUtility{
    
static testMethod void testUpdateTravellersValidPromotion(){
        TravellerUtility tu = new TravellerUtility();
        
        Map<String, Integer> mapTripStyle = new Map<String,Integer>() ;
                    
        mapTripStyle.put('Canada Goose' , 20);
        mapTripStyle.put('Guerba Walking' , 110);
        mapTripStyle.put('Expedia' , 400);
        mapTripStyle.put('Exploratory' , 30);
        mapTripStyle.put('On The Go' , 50);
        
        string theHighest = TravellerUtility.getHighestOccurences(mapTripStyle);  
        
        Account testAccount = [Select Id from Account where name = 'Esther Brown' and Referral__c=''];
        Set <Id> TravellerIds = new Set <Id>();
        TravellerIds.add(testAccount.Id);
        
        AccountHistoricalSummary__c ahs = new AccountHistoricalSummary__c();
        ahs.Account_id__c = testAccount.Id;
        insert ahs;
        
        Campaign campaign = [Select Id from Campaign where isActive = true Limit 1];
        Set <Id> CampaignIds = new Set <Id> ();
        CampaignIds.add(campaign.Id);
        
        TravellerUtility.updateTravellersValidPromotion(TravellerIds, CampaignIds);
        
        Set <Id> ServiceIds = new Set <Id>();
        Service__c service = [Select Id from Service__c where Name = 'Explore Livingstone' and Service_Status__c = 'Confirmed' and Service_Type__c = 'Tour' Limit 1];
        Service__c serviceAir = [Select Id from Service__c where Name = 'Vancouver --> Montevideo' and Service_Status__c = 'Confirmed' and Service_Type__c = 'Air' Limit 1];
        //Service__c service = new Service__c(Name = 'TestService', Booking__c = 'a0A3000000OQyax', Service_Status__c = 'Confirmed', Service_Type__c = 'tour');
        //insert service;
        
        ServiceIds.add(service.Id);
        ServiceIds.add(serviceAir.Id); 
        
        Test.startTest();
            TravellerUtility.updateTravellers_OnAfterServiceUpdate(TravellerIds, ServiceIds);
        Test.stopTest();
        
        TravellerUtility.updateTravellers_OnAfterTSDelete(TravellerIds);
        TravellerUtility.updateClientType(TravellerIds, ServiceIds);
    }
}