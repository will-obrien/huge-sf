public with sharing class SprintHandler implements ITrigger
{

    private Set<Id> m_inUseIds = new Set<Id>();


    //Constructor
    public SprintHandler()
    {
    
    }

    public void bulkBefore()
    {
    }
    
    public void bulkAfter()
    {

        if (Trigger.isUpdate)
        {
            // post load all the in use sprints passed to this trigger
            m_inUseIds = SprintGateway.findSprintIdsInUse(Trigger.oldMap.keySet());
        }    
        if (Trigger.isInsert)
        {
            // post load all the in use sprints passed to this trigger
            m_inUseIds = SprintGateway.findSprintIdsInUse(Trigger.newMap.keySet());
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
        SprintBurndownAnalyticsController.SetSprintBurndownData(m_inUseIds);   
        ReleaseBurndownChartController.SetReleaseBurndownData(m_inUseIds);
		*/
    }                        

}