trigger NotationTrigger on Notation__c (before insert) {
	if(trigger.isBefore) {
		if(trigger.isInsert) {
			List<Notation__c> notations = [SELECT Id FROM Notation__c LIMIT 100];
			if(notations.size() > 0) {
				for(Notation__c notation: trigger.new) {
					notation.addError(' You can not create new notation! ');
				}
			}
		}
	}
}
