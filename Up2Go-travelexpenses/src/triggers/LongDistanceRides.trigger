trigger LongDistanceRides on LongDistanceRide__c (before insert, before update, before delete, after insert, after update, after delete) {
	new LongDistanceRidesTriggerHandler().delegate();
}