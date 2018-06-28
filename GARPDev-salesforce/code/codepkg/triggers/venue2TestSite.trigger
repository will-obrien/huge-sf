trigger venue2TestSite on Venue__c (after insert,after update) {
 
    Map<id,id> mapVenueToTestSite = new Map<id,id>();
    Map<id,string> mapVenues = new Map<id,string>();
    for(Venue__c v : trigger.new)
    {
        mapVenueToTestSite.put(v.id, v.Site__c);
        mapVenues.put(v.Site__c,v.Building_Name__c+', '+v.Address1__c+', '+v.Address2__c+', '+v.City__c+', '+v.State__c+', '+v.Country__c);
        system.debug('Map of Testsite Ids and Venue address'+mapVenues);
    }

    List<Site__c> lstTestSites = [select ID,RPT_Venue_Address__c from Site__c where Id in: mapVenueToTestSite.values()];
    List<Site__c> lstTestSitesToUpdate = new List<Site__c>();
    for(Site__c testSite : lstTestSites)
    {
      /*  if(Trigger.isInsert && Trigger.isAfter)
        {
            		if(testSite.RPT_Venue_Address__c == NULL)
                    {
                        testSite.RPT_Venue_Address__c = mapVenues.get(testSite.ID);
                    }
                    else
                    {
                        testSite.RPT_Venue_Address__c+= '\n' + mapVenues.get(testSite.ID);    
                    }
        } */
        testSite.RPT_Venue_Address__c = mapVenues.get(testSite.ID);            
        lstTestSitesToUpdate.add(testSite);
        
    }
    update lstTestSitesToUpdate;

}