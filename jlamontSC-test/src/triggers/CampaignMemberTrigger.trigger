trigger CampaignMemberTrigger on CampaignMember (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        CampaignMemberTriggerHandler.phonebankProcessing(Trigger.oldMap, Trigger.new);
    }

}