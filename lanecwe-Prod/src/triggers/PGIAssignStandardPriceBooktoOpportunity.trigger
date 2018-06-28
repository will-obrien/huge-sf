/********************************************************************************
Name:  PGIAssignStandardPriceBooktoOpportunity ()
Copyright © 2012  PGI
======================================================
======================================================
Purpose:
-------
Trigger to assign Standard pricebook to Quote
======================================================
======================================================
History
-------
VERSION  AUTHOR                DATE           DETAIL              
1.0    - Nagendra          3/28/2013         Initial Development 
********************************************************************************/ 
trigger PGIAssignStandardPriceBooktoOpportunity on Opportunity (before insert, after update) {
    /*if(!(Test.isRunningTest())){
    Bypassrules__c profileCustomSetting = Bypassrules__c.getInstance(UserInfo.getUserId());
    if(!(profileCustomSetting.Trigger_Objects__c.contains('Opportunity')
       && profileCustomSetting.Disable_Triggers__c)){*/
    if (Trigger.isBefore && Trigger.isInsert)
    {
        PgiOpportunityTriggerUtilities.assignPbToOppourtunity (trigger.new);
    }
    else if (Trigger.isAfter && Trigger.isUpdate)
    {
        PgiOpportunityTriggerUtilities.onAfterUpdate();
    }
    //}
 //}
}