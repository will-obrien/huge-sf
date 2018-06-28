//*********************************************************************
//
// (c) 2015 Sierra Club
//  Trigger for Advocacy Action object, aka:  kweos__EOCS_Data__c
//
//  2015/06/24      Vernon          Original
//
//  2015/06/24      VB      Updated
//  2015/09/08      VB      Added 'after' clauses on update & delete, 
//                              so totals could be calculated correctly.
//  2015/11/06      VB      Disabled processCountAfter() call per DS 
//                              request due to lockout concerns.
//  2015/11/09      VB      Re-enabled processCountAfter() call per DS 
//  2016/11/09		VB		Disabling processCountAfter() req per DS
//  2017/1          MM      Add call to AdvocacyActionMCTriggerHandler 
//  2017/04			TL		Add before and after delete to AdvocacyActionDelete
//  2017/04			TL		Add call to AddToListsCampaign
//  2017/06			TL		Add before insert update of Source Campaign	
//  2017/06         MM      Add call to AAUpdateReportingAttr to add reporting attributes from Campaign                    
//**********************************************************************/

trigger AdvocacyActionTrigger on kweos__EOCS_Data__c (after insert, before insert, before update, after update, before delete, after delete, after undelete) {
    
    if (Trigger.isBefore && Trigger.isInsert) {
    	for (kweos__EOCS_Data__c a : Trigger.new) {
    		if (a.kwac__Source_Campaign__c == null && a.kwac__Related_Action__c != null) {
    			a.kwac__Source_Campaign__c = a.kwac__Related_Action__c;
    		}
    	}
    }
    
    // Call the thing
    // Before/After delete/undelete?  - reprocess
    // After insert - looking at all AA
    // After update - looking at both old & new Contacts
    AdvocacyActionTriggerHandler aaTriggerHandler = new AdvocacyActionTriggerHandler();
    //
    // We need the maps since on updates we need to compare values.
    aaTriggerHandler.process(trigger.new,trigger.old,
                                trigger.newMap,trigger.oldMap,
                                trigger.isBefore,trigger.isAfter,
                                trigger.isInsert,trigger.isUpdate,trigger.isDelete,trigger.isUnDelete);

    if (trigger.isAfter) {
        //aaTriggerHandler.processCountAfter(trigger.new,trigger.old,
        //                            trigger.newMap,trigger.oldMap,
        //                            trigger.isInsert,trigger.isUpdate,trigger.isDelete,trigger.isUnDelete);
        aaTriggerHandler.processMarkDirtyAfter(trigger.new,trigger.old,
                                    trigger.newMap,trigger.oldMap,
                                    trigger.isInsert,trigger.isUpdate,trigger.isDelete,trigger.isUnDelete);
    }

	if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate) ) {
		AdvocacyActionMCTriggerHandler.handleChange();
        AddToListsCampaign.fromAdvocacyAction(trigger.new);
	}
    
	if(Trigger.isDelete ) {
        if (Trigger.isBefore) {
			AdvocacyActionDelete.checkUser(Trigger.old);
            }
        else if (Trigger.isAfter) {
            AdvocacyActionDelete.deleteBatchUpload(Trigger.old);
            
        }
	}
	if(Trigger.isInsert && Trigger.isBefore) {
		AAUpdateReportingAttr.updateReportingAttr(Trigger.new);
	}    
}