/*
    On insert and update of employee record
    map fields of contact to employee
*/
trigger EmployeeInsertUpdateTrigger on SFDC_Employee__c (before insert,after insert, before update,after update ) {
    
    // When we insert a new employee, it should copy contact information from Contact to Employee record
    if(Trigger.isInsert && Trigger.isBefore){
        EmployeeInsertUpdateTriggerHelper.mapContactToEmployee(Trigger.New);
    }
    
    // When we create a new employee and it's associated contact is a manager of some other contact
    // Then direct manager should be populated on the old employee record under that contact
    if(Trigger.isInsert && Trigger.isafter){
        EmployeeInsertUpdateTriggerHelper.mapContactToEmployeeAfter(Trigger.New);
    }
    else if(Trigger.isUpdate && Trigger.isBefore){
        EmployeeInsertUpdateTriggerHelper.updateContact(Trigger.New,Trigger.OldMap);
    }
    
    if(Trigger.isUpdate && Trigger.isafter){
        EmployeeInsertUpdateTriggerHelper.RemoveInactiveEmployeeFromEmailList(Trigger.New,Trigger.OldMap);
    }
    
    //For triggering newly developed trigger logic for updating Employee Business Unit on User record
    TriggerFactory.createHandler(SFDC_Employee__c.sObjectType);
}