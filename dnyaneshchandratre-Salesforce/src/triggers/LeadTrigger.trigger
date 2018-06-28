trigger LeadTrigger on Lead (after insert) 
{ 
    if(Trigger.isAfter)
    {
        if(Trigger.isInsert)
        {
            CloneTriggerHandler.cloneLead(Trigger.new);
        }
    }
}