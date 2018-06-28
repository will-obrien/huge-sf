trigger update_custom_name on Project_Task__c (before insert, before update) {
    for(Project_Task__c task : Trigger.New){
        task.Name__c = task.Name;
    }
}