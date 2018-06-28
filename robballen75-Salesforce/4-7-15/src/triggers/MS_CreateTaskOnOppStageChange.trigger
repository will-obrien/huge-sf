trigger MS_CreateTaskOnOppStageChange on Opportunity (after insert, after update) {


 
string accountName = '';
string contactId = '';
string accountId = '';

//Create a list of all opportunitycontactroles that are impacted by the opportunities in this trigger operation
List<OpportunityContactRole> ocr = [Select ContactId, opportunityId, opportunity.ownerId, opportunity.StageName from OpportunityContactRole where OpportunityId in :Trigger.New];

        Map<Id, String> stageList = new Map<Id, String>();
       // Stores all old stage values in a map
       system.debug('checking to see if we are in an udpate trigger');
    if (system.trigger.isupdate) {
        system.debug('we are in an update trigger');
        for (opportunity record:Trigger.old){
        stageList.put(record.id, record.stageName);
            }
    
    }

// INSERT THE ACTIVITY

//Create a new list which we will add tasks to for insertion later.
List<Task> taskList = new List<Task>();

for (opportunityContactRole ocr2: ocr){
    system.debug('contactid=' + ocr2.ContactId);
system.debug('oppid=' + ocr2.opportunityId);
  Task opptask   = new Task();
    contactId = ocr2.ContactId;
    opptask.WhatId = ocr2.opportunityId;
    opptask.WhoId = contactId;
    opptask.description = 'Opportunity stage set to Discovery - reminder to follow-up will be sent on ' + String.valueOf(Date.today()+14);
    opptask.IsReminderSet = true;
    opptask.ReminderDateTime = Date.today() + 14;
    opptask.Subject = 'Discovery Followup';
    opptask.OwnerId = ocr2.opportunity.OwnerId;
    opptask.Type = 'Marketing Event';
    opptask.Status = 'Not Started';
    
    
    //Check to see if we should add this task to the list for insertion, based on if the opp status is Qualified Lead.
//  if (system.trigger.isupdate) {
//      if (stagelist.get(ocr2.opportunity.id) != 'Qualified Lead' && ocr2.Opportunity.StageName == 'Qualified Lead') {
//           taskList.add(opptask);
//      }
//  }
//  if (system.trigger.isInsert && ocr2.Opportunity.StageName == 'Qualified Lead') {
//       taskList.add(opptask);
//  }
    if ((system.trigger.isUpdate && stagelist.get(ocr2.opportunity.id) != '2-Discovery'  && ocr2.Opportunity.StageName  == '2-Discovery')||
 (system.trigger.isInsert && ocr2.Opportunity.StageName  == '2-Discovery')) {
             taskList.add(opptask);
 
} //end checking to see if we should add this task to the list for insertion


 } //end loop of all opportunity contact roles for opportunity  
    
    Database.DMLOptions dmlo = new Database.DMLOptions();
    dmlo.EmailHeader.triggerUserEmail = true;
    
    database.insert (tasklist,dmlo);    
    
     
}//end trigger