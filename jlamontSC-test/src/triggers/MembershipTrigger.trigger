/*
MembershipTrigger

After creating a new membership, set lookup field on Account

Created by:	Mark Maslow
Created on: August 20, 2014

Modified by: Mark Maslow - December, 2015

Handle updates - Account may change on a membership record.
*/
trigger MembershipTrigger on Membership__c (after insert, after update) {
	if(Trigger.isAfter) {
		if(Trigger.isInsert) {
			new MembershipSummaryCreator().afterInsert(Trigger.new);
		}
		else if(Trigger.isUpdate) {
			new MembershipSummaryCreator().afterUpdate(Trigger.new, Trigger.oldMap);
		}
	}
}