trigger CaseClose on Case (after update) {
    if (Trigger.isAfter) {
        if (Trigger.isUpdate) {
        
         //    CaseTriggerHelper cth= new CaseTriggerHelper();
         //   cth.updateTasks(Trigger.new);
        
        /*
            List<Task> tasks= new List<Task>();
            
            for (Case c : Trigger.new) {
                system.debug('>>>>> Case ID'+c.id);
                for (Task t : [select id,status from Task where WhatId = :c.id]) {
                    t.status = 'Completed';
                    tasks.add(t);
                    system.debug('>>>>> Task '+c.id +' ' +t.status);
                }
            }
            system.debug('>>>>>'+tasks);
            update tasks;
        */
       }
   }
}