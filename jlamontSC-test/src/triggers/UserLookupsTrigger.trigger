trigger UserLookupsTrigger on User_Lookups__c (after insert, after update) {
	List<Id> contactIdList = new List<Id>();
	if(Trigger.isInsert) {
		for(User_Lookups__c lu : Trigger.new) {
			if(! String.isEmpty(lu.Contact__c)) {
				contactIdList.add(lu.Contact__c);
			}
		}
	}
	else if(Trigger.isUpdate) {
		for(User_Lookups__c lu : Trigger.new) {
			User_Lookups__c oldLu = Trigger.oldMap.get(lu.Id);
			if(oldLu != null) {
				if(lu.Contact__c != oldLu.Contact__c) {
					contactIdList.add(lu.Contact__c);
				}
			}
		}
	}
	if( ! contactIdList.isEmpty() ) {
		new AssignLeaderPermissions().assignPermissions(contactIdList);
	}
}