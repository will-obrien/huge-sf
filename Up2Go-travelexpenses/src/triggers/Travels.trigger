trigger Travels on Travel__c (before insert, before update, before delete, after insert, after update, after delete) {
	new TravelsTriggerHandler().delegate();
}