trigger createTaskTrigger on Account (after insert) 
{
    if(Trigger.isAfter)
        if(Trigger.isInsert)
            createTaskHandler.createTask(Trigger.new);

}