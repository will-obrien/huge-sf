public without sharing class WaiverController {

public Event_Registration__c registration;

	public Event_Registration__c getRegistration() {
		if(registration == null) {
			Id id = System.currentPageReference().getParameters().get('id');
			if(id != null) {
				List<Event_Registration__c> regList = [
					select 
						Id, 
						Full_Name__c, 
						First_Name__c,
						Last_Name__c,
						Image_Authorization_Declined__c,
						Is_Minor__c,
						Guardian_First_Name__c,
						Guardian_Last_Name__c
					from Event_Registration__c
					where Id = :id
				];
				if( ! regList.isEmpty() ) {
					registration = regList.get(0);
				}
			}
		}
		return registration;
	}
}