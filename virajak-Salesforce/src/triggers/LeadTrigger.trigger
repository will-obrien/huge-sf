trigger LeadTrigger on Lead (before insert, after insert) {
    if(Trigger.isBefore){
        
             LeadTriggerHandler.doCheckDuplicateLead(Trigger.new);
       
    }
    else {
            LeadTriggerHandler.doAddTaskOnLead(Trigger.new);
        	LeadTriggerHandler.doCloneLead(Trigger.new);
    }	
}