// from https://developer.salesforce.com/forums/?id=906F00000008zIxIAI

trigger triggerFromTaskToLead on Task (after insert, after update, after delete, after undelete) {
  // Memory allocations for this trigger.
  List<Task> TaskRecords = new List<Task>();
  Set<Id> setLeadID = new Set<Id>();

  // Combine old and new trigger records into a single list.
  if(Trigger.new!=null)
    TaskRecords.addAll(Trigger.new);
  if(Trigger.old!=null)
    TaskRecords.addAll(Trigger.old);

  // Collect all Related To (WhoId) values.
  for(Task aTask:TaskRecords)
    setLeadID.add(aTask.WhoId);

  // Query for all Lead__c records. This trick is magic,
  // as salesforce.com will ignore any ID value that is not a
  // Lead ID. Bundled into batches of 200, so it's
  // efficient, too.
  for(Lead[] ld:[select id from Lead where ID in :setLeadId]) {
    update ld;
  } 
}