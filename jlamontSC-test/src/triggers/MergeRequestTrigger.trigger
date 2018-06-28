trigger MergeRequestTrigger on Merge_Request__c (before insert, after insert) {
	if(Trigger.isBefore) {
		for(Merge_Request__c request : Trigger.new) {
			request.Previous_Account_Lookup__c = request.Previous_Account__c;
			request.Retained_Account_Lookup__c = request.Retained_Account__c;
			request.Previous_Contact_Lookup__c = request.Previous_Contact__c;
			request.Retained_Contact_Lookup__c = request.Retained_Contact__c;
		}
	}
	else { 
    	MergeRequestPopulateSurvivor.populateSurvivor(Trigger.new);
	}
}