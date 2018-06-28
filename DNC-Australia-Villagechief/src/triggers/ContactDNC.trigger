trigger ContactDNC on Contact (before update) {
    Dnc.handleTriggerUpdate(Trigger.oldMap, Trigger.newMap, new String[]{'Fax', 'HomePhone', 'MobilePhone', 'OtherPhone', 'Phone'});
}