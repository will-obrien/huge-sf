global with sharing class FindNearbyExt {

    public FindNearbyExt(ApexPages.StandardController controller) { }

    @RemoteAction
    // Find warehouses nearest a geolocation
    global static List<Warehouse__c> getNearby(String lat, String lon) {

        // If geolocation isn't set, use San Francisco
        if(lat == null || lon == null || lat.equals('') || lon.equals('')) {
            lat = '37.77493';
            lon = '-122.419416';
        }

        // SOQL query to get the nearest warehouses
        String queryString =
            'SELECT Id, Name, Location__Longitude__s, Location__Latitude__s, ' +
                'Street_Address__c, Phone__c, City__c ' +
            'FROM Warehouse__c ' +
            'WHERE DISTANCE(Location__c, GEOLOCATION('+lat+','+lon+'), \'mi\') < 20 ' +
            'ORDER BY DISTANCE(Location__c, GEOLOCATION('+lat+','+lon+'), \'mi\') ' +
            'LIMIT 10';

        // Run and return the query results
        return(database.Query(queryString));
    }
}