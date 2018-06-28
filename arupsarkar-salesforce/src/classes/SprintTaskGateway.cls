public without sharing class SprintTaskGateway

    /**
     * Returns a subset of id's where there are any records in use.
     *
     * Arguments:   Set<Id> SprintIds - Set of Sprint Id's to examine
     *
     * Returns:     Set<Id> - Set of Sprint Id's that are 'in use'
     */

{

    public static Set<Id> findSprintTaskIdsInUse(Set<Id> SprintTaskIds)
    {
        Set<Id> inUseIds = new Set<Id>();
        for (Sprint_Task__c[] sprintTasks : [Select s.Id From Sprint_Task__c s where s.Id in : SprintTaskIds])
        {   
            for (Sprint_Task__c sprintTask : sprintTasks )
            {
                inUseIds.add(sprintTask.id);
            }
        }
        return inUseIds;
    }


}