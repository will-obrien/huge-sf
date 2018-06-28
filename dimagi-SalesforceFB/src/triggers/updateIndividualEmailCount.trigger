// From https://developer.salesforce.com/forums/?id=906F00000008zIxIAI

trigger updateIndividualEmailCount on Lead (before update) {
  // Query for all Lead records, plus any tasks with the type of 'Email'
  for(Lead ld:[select id,(select id from tasks where type = 'Email' and subject LIKE '%Email:%') from Lead where id in :Trigger.new]) {
    // Simply assign the list of the query to the correct field.
    Trigger.newMap.get(ld.id).Individual_Email_Count__c = ld.Tasks.size();
  }
}