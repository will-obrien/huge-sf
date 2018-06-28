trigger ReservationTrigger on Reservation__c (after insert)  {
	if (Trigger.isAfter && Trigger.isInsert) {
		ReservationTriggerHandler.addExplorerPreference(Trigger.new);
	}
}