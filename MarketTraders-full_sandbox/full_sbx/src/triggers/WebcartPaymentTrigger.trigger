trigger WebcartPaymentTrigger on Webcart_Payment__c (before insert, before update, before delete,
														after insert, after update, after delete, after undelete) {

	if (trigger.isBefore) {
		if ((trigger.isInsert) || (trigger.isUpdate)) {
			System.debug('@@@@ in WebcartPaymentTrigger...');
			//WebcartHelper.xmlBodyToKeyValuePairs(trigger.New);
		}
	}
}