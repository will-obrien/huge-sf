trigger MealInvitations on MealInvitation__c (before insert, before update, before delete, after insert, after update, after delete) {
	new MealInvitationsTriggerHandler().delegate();
}