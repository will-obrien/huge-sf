public without sharing class CaseTriggerHelper{

    public void updateTasks(List<Case> cases) {
            //List<Case> cases = (List<Case>) obj;
            List<Task> tasks= new List<Task>();
            
            for (Case c : cases) {
                system.debug('>>>>> Case ID'+c.id);
                for (Task t : [select id,status from Task where WhatId = :c.id]) {
                    t.status = 'Completed';
                    tasks.add(t);
                    system.debug('>>>>> Task '+c.id +' ' +t.status);
                }
            }
            system.debug('>>>>>'+tasks);
            update tasks;
    }
}