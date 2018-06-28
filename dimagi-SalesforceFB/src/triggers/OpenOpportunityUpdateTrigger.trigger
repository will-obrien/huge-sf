trigger OpenOpportunityUpdateTrigger on Opportunity (before insert, before update) {

    if (trigger.isInsert) {
    	OpenOpportunityUtils.updateStageName(trigger.new);
    }
    else if (trigger.isUpdate) {    	  	
    	OpenOpportunityUtils.updateStageName(trigger.new, trigger.oldMap);    	
    }
}