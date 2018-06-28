trigger LeadershipTrigger on Leadership__c (after delete, after insert, after update) {
	List<Leadership__c> ldrList;
	if(Trigger.isDelete) {
		ldrList = Trigger.old;
	}
	else {
		ldrList = Trigger.new;
	}

	List<Id> contactIdList = new List<Id>();
	for(Leadership__c ldr : ldrList) {
		contactIdList.add(ldr.Contact__c);
	}
	
	new AssignLeaderPermissions().assignPermissions(contactIdList);
    AssignAddUpUserType.setUserType(contactIdList);
}