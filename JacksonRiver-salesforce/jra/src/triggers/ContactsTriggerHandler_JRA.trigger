trigger ContactsTriggerHandler_JRA on Contact (before insert, before update, after insert, after update) {

/* With reference to Steve Andersen's post: http://gokubi.com/archives/two-interesting-ways-to-architect-apex-triggers */

jrsbd__JRA_Trigger_Settings__c jrasettings = jrsbd__JRA_Trigger_Settings__c.getInstance();

if (jrasettings.get('jrsbd__Disable_All_Triggers__c') == null || jrasettings.jrsbd__Disable_All_Triggers__c == false) {
 
    if(Trigger.isInsert && Trigger.isBefore){
        JRA_ManageContacts.beforeInsert(Trigger.new);
    }
    
    if(Trigger.isInsert && Trigger.isAfter){
        JRA_ManageContacts.AfterInsert(Trigger.new);
    }
 
    if(Trigger.isUpdate && Trigger.isBefore){
        JRA_ManageContacts.beforeUpdate(Trigger.new, Trigger.oldmap);
    }
    
    if(Trigger.isUpdate && Trigger.isAfter){
        JRA_ManageContacts.AfterUpdate(Trigger.new, Trigger.oldmap);
    }  

}
    
}