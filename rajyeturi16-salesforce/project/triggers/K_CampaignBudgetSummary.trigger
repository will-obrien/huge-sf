/* Developer   : Keerthi Chandra
 * DateTime    : 05-11-16
 * Description : Roll Up Summary caluculation on the campaign for budget cost of child CampaignLink records.
 * Status      : Developed
 */
trigger K_CampaignBudgetSummary on CampaignLink__c (after delete, after insert, after update, after undelete) 
{
    // Everytime campaignlink after update or insert or undelete calculate the actual campaign budget cost.
    if((trigger.isInsert || trigger.isUpdate || trigger.isUnDelete) && (trigger.isAfter))
    {
       list<K_RollUpSummary_CampgnBudget.fieldDefinition> lstFieldDefinitionsActl =
         new list<K_RollUpSummary_CampgnBudget.fieldDefinition> 
         {
             new K_RollUpSummary_CampgnBudget.fieldDefinition('SUM', 'Actual_Cost__c',
             'ActualCost')
         };
         
        K_RollUpSummary_CampgnBudget.rollUpTrigger(lstFieldDefinitionsActl,trigger.new,
        'CampaignLink__c', 'CampaignId__c', 'Campaign','');
        
        if(trigger.isUpdate && trigger.isAfter)
        {
             K_RollUpSummary_CampgnBudget.rollUpOldCmpg(lstFieldDefinitionsActl,trigger.old,
            'CampaignLink__c', 'CampaignId__c', 'Campaign','');
        }
    }
    
    // Everytime campaignlink after delete calculate the actual campaign budget cost.
    if(trigger.isDelete && trigger.isAfter)
    {
         list<K_RollUpSummary_CampgnBudget.fieldDefinition> lstFieldDefinitionsActl =
         new list<K_RollUpSummary_CampgnBudget.fieldDefinition> 
         {
             new K_RollUpSummary_CampgnBudget.fieldDefinition('SUM', 'Actual_Cost__c','ActualCost')
         };
         K_RollUpSummary_CampgnBudget.rollUpTrigger(lstFieldDefinitionsActl,trigger.old,
         'CampaignLink__c', 'CampaignId__c', 'Campaign', '');
    }
}