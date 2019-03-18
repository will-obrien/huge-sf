trigger OnContact1 on Contact (before update, before insert) {
	PersonAccountSupport.processContactTrigger1(trigger.isBefore, trigger.new, trigger.oldmap);
}