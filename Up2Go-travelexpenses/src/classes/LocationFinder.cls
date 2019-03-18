global with sharing class LocationFinder {
        
        
        // CONSTRUCTOR
        
        public LocationFinder(ApexPages.StandardController standardController) {
                // Note: empty Constructor for CtrlExtensions
        }
        
        
        // REMOTE METHODS
        
        @RemoteAction
        global static Id findLocation(String city, String countryCode) {
                Id result;
                
                CompensationRate__c location = getLocation(city, countryCode);
                
                if(location != null) {
                        result = location.Id;
                }
                
                return result;
        }
        
        
        // PRIVATE METHODS
        
        private static CompensationRate__c getLocation(String city, String countryCode) {
                List<CompensationRate__c> result;
                
                Id location = CompensationRateType.getLocationId();
                
                result = [SELECT Id
                          FROM CompensationRate__c
                          WHERE RecordTypeId = :location
                          AND txt_CountryCode__c = :countryCode
                          AND txt_CityName__c = NULL LIMIT 1];
                                  
                if(result.isEmpty()) {
                        result = [SELECT Id
                                  FROM CompensationRate__c 
                                  WHERE RecordTypeId = :location
                                  AND txt_CountryCode__c = :countryCode 
                                  AND txt_CityName__c = :city LIMIT 1];
                }
                
                if(result.isEmpty()) {
                        result = [SELECT Id
                                  FROM CompensationRate__c 
                                  WHERE RecordTypeId = :location
                                  AND txt_CountryCode__c = :countryCode 
                                  AND txt_CityName__c = 'Other' LIMIT 1];
                }
                
                return result.isEmpty() ? null : result[0];
        }
}