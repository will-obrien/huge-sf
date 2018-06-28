trigger LeadDNC on Lead (before update) {
    Dnc.handleTriggerUpdate(Trigger.oldMap, Trigger.newMap, new String[]{'Fax', 'MobilePhone', 'Phone'});
}