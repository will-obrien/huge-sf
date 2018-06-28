@isTest
    private class testFindNearby {
    static testMethod void testFindNearby() {
       Warehouse__c w = new Warehouse__c(Name='Test Warehouse', Location__Latitude__s=37.783900,Location__Longitude__s=-122.389332);
       insert w;

       FindNearby.getNearby('37.794428', '-122.394782');
    }
}