@isTest
private class LocationFinder_Test {
	
	private static CompensationRate__c location1 = insertLocation('Deutschland(Stuttgart)', 'Deutschland','Stuttgart', 'DE');
	private static CompensationRate__c location2 = insertLocation('Deutschland(München)', 'Deutschland', 'München', 'DE');
	private static CompensationRate__c location3 = insertLocation('Deutschland(Other)', 'Deutschland', 'Other', 'DE');
	private static CompensationRate__c location4 = insertLocation('Frankreich', 'Frankreich', null, 'FA');
	private static CompensationRate__c location5 = insertLocation('Afghanistan', 'Afghanistan', null, 'AF');
		
	static {
		CustomSettings.addDefault();
	}


	@isTest
	private static void findsLocationWithCountryCodeAndIrrelevantCity() {
		
		// Setup
		String city = 'Kabul';
		String country = 'AF';
		
		
		// Exercise
		Id result = LocationFinder.findLocation(city, country);

		
		// Verify
		System.assertEquals(location5.id, result);
	}
	
	
	@isTest
	private static void findsLocationWithCountryCodeAndRelevantCity() {
		
		// Setup
		String city = 'Stuttgart';
		String country = 'DE';
		
		
		// Exercise
		Id result = LocationFinder.findLocation(city, country);
		
		
		
		// Verify
		System.assertEquals(location1.id, result);
	}
	
	
	@isTest
	private static void doesNotFindLocationIfNotInDatabase() {
		
		// Setup
		String city = 'Rom';
		String country = 'IT';
		
		
		// Exercise
		Id result = LocationFinder.findLocation(city, country);
		
		
		// Verify
		System.assertEquals(null, result);
	}
	
	
	// TEST HELPER
	private static CompensationRate__c insertLocation(String name, String country, String city,  String countryCode) {
		CompensationRate__c result = new CompensationRate__c(Name = name,
                                                             txt_CountryName__c = country,	
                                                             txt_CityName__c = city,
															 txt_CountryCode__c = countryCode,
															 cur_FullDailyRate__c =50,
															 cur_PartialDailyRate__c =25,
															 cur_OvernightStayRate__c =60);
		insert result;
		
		return result;
	}  
}