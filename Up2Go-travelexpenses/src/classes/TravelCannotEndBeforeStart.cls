public with sharing class TravelCannotEndBeforeStart implements SaveTravelRule {
	
	
	public void validate(List<SObject> records) {
		for(Travel__c travel : (List<Travel__c>)records) {
			DateTime start = travel.dtm_Start__c;
			DateTime stop = travel.dtm_End__c;
			
	        if ( stop < start ) {
				travel.dtm_End__c.addError(System.Label.TravelCannotEndBeforeStart);     
	        }
		}
    }
}