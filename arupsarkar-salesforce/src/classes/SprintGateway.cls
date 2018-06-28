public without sharing class SprintGateway

    /**
     * Returns a subset of id's where there are any records in use.
     *
     * Arguments:   Set<Id> SprintIds - Set of Sprint Id's to examine
     *
     * Returns:     Set<Id> - Set of Sprint Id's that are 'in use'
     */

{

    public static Set<Id> findSprintIdsInUse(Set<Id> SprintIds)
    {
        Set<Id> inUseIds = new Set<Id>();
        for (Sprint__c[] sprints : [Select s.Id From Sprint__c s where s.Id in : SprintIds])
        {   
            for (Sprint__c sprint : sprints )
            {
                inUseIds.add(sprint.id);
            }
        }
        return inUseIds;
    }


}