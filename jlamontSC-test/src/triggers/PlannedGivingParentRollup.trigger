/*
//*************************************************************************************************
//
// Name              : PlannedGivingParentRollup
// By                : Vernon Baas
// Description       : Keep the total fields of Parent PG records updated:
//                           Calculated_Giving_Amount__c
//                           Calculated_Estimated_Giving_Amount__c
// ChangeLog        : VB: 5/6/2016 - Minor comment clean-up, no functional changes
//*************************************************************************************************
*/
trigger PlannedGivingParentRollup on rC_Giving__Planned_Giving__c (after insert,after update,after delete) {

    // 
    Set<Id> parentPGsToUpdate = new Set<Id>();
    Map<Id, rC_Giving__Planned_Giving__c> PGMap = new Map<Id, rC_Giving__Planned_Giving__c>();

    // For inserts,updates and undeletes, save the NEW Parent PGs
    if(Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
        
        // Step through the NEW updated records
        for(rC_Giving__Planned_Giving__c thePG:Trigger.new) {
            
            // If the PG record has a Parent PG defined
            if(thePG.Parent_Planned_Giving__c != NULL) {
                
            	// Save it to the List
            	parentPGsToUpdate.add(thePG.Parent_Planned_Giving__c);
            }
        }
    }

    // For updates and deletes, save the OLD Parent PGs
    if(Trigger.isUpdate || Trigger.isDelete) {
        
        // Step through the OLD updated records
        for(rC_Giving__Planned_Giving__c thePG:Trigger.old) {
            
            // If the PG record has a Parent PG defined
            if(thePG.Parent_Planned_Giving__c != NULL) {
                
            	// Save it to the List
            	parentPGsToUpdate.add(thePG.Parent_Planned_Giving__c);
            }
        }
    }
    
    // Do I need to remove the Nulls? ( Don't think I should need to do this b/c of the check in the loop)

	//     
    for(Id pgID:parentPGsToUpdate) {
        
        // Create a new PG Record, with only the values we will be updating
        // 		default the sums to zero, as we'll be recalculating them.
        PGMap.put(pgId, new rC_Giving__Planned_Giving__c(
            	Id=pgId,
            	Calculated_Giving_Amount__c = 0,
        		Calculated_Estimated_Giving_Amount__c = 0)
			);
    }

	// Query all PG records who have Parents we need to recalculate
	// 		note: the query looks for PG records where the PARENT is in the set.
    for(rC_Giving__Planned_Giving__c theCurrentPG:[SELECT Id,
                                                   Parent_Planned_Giving__c,
                                                   //Calculated_Giving_Amount__c,
                                                   //Calculated_Estimated_Giving_Amount__c,
                                                   rC_Giving__Giving_Amount__c,
                                                   rC_Giving__Estimated_Giving_Amount__c
                                                  FROM rC_Giving__Planned_Giving__c
                                                  WHERE Parent_Planned_Giving__c IN :parentPGsToUpdate]) {

		// Update the Map, totalling the Giving Amount & Estimated Giving Amount sums.                                                      
		// 
        if (PGMap.get(theCurrentPG.Parent_Planned_Giving__c).Calculated_Giving_Amount__c != NULL) {

			// Check to make sure the record has a Giving Amount ( != null )
        	Decimal childAmount = (theCurrentPG.rC_Giving__Giving_Amount__c != null ? theCurrentPG.rC_Giving__Giving_Amount__c :0);
	        PGMap.get(theCurrentPG.Parent_Planned_Giving__c).Calculated_Giving_Amount__c += childAmount;
        }
                                                      
        if (PGMap.get(theCurrentPG.Parent_Planned_Giving__c).Calculated_Estimated_Giving_Amount__c != NULL) {

            // Check to make sure the record has an Estimated Giving Amount ( != null )
        	Decimal childAmount = (theCurrentPG.rC_Giving__Estimated_Giving_Amount__c != null ? theCurrentPG.rC_Giving__Estimated_Giving_Amount__c :0);
        	PGMap.get(theCurrentPG.Parent_Planned_Giving__c).Calculated_Estimated_Giving_Amount__c += theCurrentPG.rC_Giving__Estimated_Giving_Amount__c;
        }
	}
    // Update the Parent PG records with the newly calculated totals
    update(PGMap.values());
    
}