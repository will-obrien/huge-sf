public with sharing class SprintTaskHandler implements ITrigger
{

    private Set<Id> m_inUseIds = new Set<Id>();


    //Constructor
    public SprintTaskHandler()
    {
    
    }

    public void bulkBefore()
    {
    }
    
    public void bulkAfter()
    {

        if (Trigger.isUpdate)
        {
            // post load all the in use products passed to this trigger
            m_inUseIds = SprintTaskGateway.findSprintTaskIdsInUse(Trigger.oldMap.keySet());
        }    
        if (Trigger.isInsert)
        {
            // post load all the in use products passed to this trigger
            m_inUseIds = SprintTaskGateway.findSprintTaskIdsInUse(Trigger.newMap.keySet());
        }    
    
    
    }
    
    public void beforeInsert(SObject so)
    {
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
    }
    
    
    public void beforeDelete(SObject so)
    {
    }
    
    public void afterInsert(SObject so)
    {
        /*
        Sprint__c myNewSprint = (Sprint__c)so;
        if (m_inUseIds.contains(myNewSprint.Id)){
        
            OpportunityContactRoleSet.SetOpptyConRole(myNewSprint.Id);    
        */
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    {
    }
    
    public void afterDelete(SObject so)
    {
    }
    
    public void andFinally()
    {
        /*
        SprintTaskBurndownAnalyticsController.SetSprintTaskBurndownData(m_inUseIds);   
		*/
    }                        

}