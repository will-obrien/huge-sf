/**
*    Opportunity trigger logic for Before/After Insert/Update/Delete Events
*
*    Modification Log
*
*    Deepthi        PGI    11/06/2014      Opportunity trigger logic for Before/After Insert/Update/Delete 
**/
trigger OpportunityEvents on Opportunity (before insert, before update, before delete, after update) {
	if(Trigger.isBefore){
		if(Trigger.isInsert){
			OpportunityEventHandler.validateRampDates(null, trigger.new);
			//Case #51272
			/*OpportunityEventHandler.setOppStage(null, trigger.new);
			OpportunityEventHandler.setProbInput(null, trigger.new);*/
		}
		else if(Trigger.isUpdate){
			OpportunityEventHandler.validateRampDates(trigger.oldMap, trigger.new);
			//Case #51272
			/*OpportunityEventHandler.setOppStage(trigger.oldMap, trigger.new);
			OpportunityEventHandler.setProbInput(trigger.oldMap, trigger.new);*/
		}
	}
	else if (Trigger.isAfter){
		if(Trigger.isUpdate){
			OpportunityEventHandler.setOpportunityScorecardFields(trigger.oldMap, trigger.newMap);
		}
	}
   
    //if(UserInfo.getName() == 'eCommerce Customer'){
    if(Trigger.new != null){
    for(Opportunity Opptydata : trigger.new){
       if(Opptydata.Z_Source__c == 'eCommerce'){   
        if(!OpportunityEventHandler.skipExecution){
            /* logic to update Opportunity on Before Insert events */
            if(Trigger.isBefore && Trigger.isInsert){
                OpportunityEventHandler.updateOpportunity(Trigger.new);
            }
        /* logic for Opportunity on Before Delete events*/
        if(Trigger.isBefore && Trigger.isDelete){
            // Logic to delete License/Assets on opportunity deletion
            OpportunityEventHandler.deleteOpporLicenses(Trigger.old);
            
            // Logic to delete LicenseSets on opportunity deletion
            OpportunityEventHandler.deleteOpporLicenseSets(Trigger.old);
        }
        /* logic to createContracts on Opportunity updates */
        if(Trigger.isAfter && Trigger.isUpdate){
           OpportunityEventHandler.createContracts(trigger.newMap, trigger.oldMap);
           OpportunityEventHandler.mirrorOpportunityLineItemLicenseSet(trigger.oldMap, trigger.newMap);
        }
        /* logic to createContracts on Opportunity updates */
        OpportunityEventHandler.skipExecution = true;
       }
      }
    }
	}
}