/**
 * This is helper class for PGICompanyRevenueTrigger. It contains the helper methods to implement the business requirement
 * on the Company_Revenue__c object on trigger execution.
 *
 * @author Amit M.
 * @version 1.0
 */
public with sharing class x_PGICompanyRevenueTriggerHelper {
	//Improve code coverage
	public static void inactive(){
	}

    /**
     * Executes in the after Insert context of the trigger. Performs below operations,
     * 1. Updates the sum of Revenue for the accounts.
     */
    /*public void onAfterInsert()
    {*/
        // TODO : Commenting Company Revenue related code as per Andy's instructions.
        /*Set<Id> accountIds = this.collectAccountIdForCompanyRevenues((List<Company_Revenue__c>)Trigger.new);
        PGICompanyTriggerHelper companyTriggerHelper = new PGICompanyTriggerHelper();
        companyTriggerHelper.updateRevenueForAccounts(accountIds);*/
    /*}*/
    
    /**
     * Executes in the after update context of the trigger. Performs below operations,
     * 1. Updates the sum of Revenue for the accounts.
     */
    /*public void onAfterUpdate()
    {*/
        // TODO : Commenting Company Revenue related code as per Andy's instructions.
        /*Set<Id> accountIds = this.collectAccountIdForCompanyRevenues((List<Company_Revenue__c>)Trigger.new, 
                                                                     (Map<Id, Company_Revenue__c>)Trigger.oldMap);
        PGICompanyTriggerHelper companyTriggerHelper = new PGICompanyTriggerHelper();
        companyTriggerHelper.updateRevenueForAccounts(accountIds);*/
    /*}*/
    
    /**
     * Executes in the after delete context of the trigger. Performs below operations,
     * 1. Updates the sum of Revenue for the accounts.
     */
    /*public void onAfterDelete()
    {*/
        // TODO : Commenting Company Revenue related code as per Andy's instructions.
        /*Set<Id> accountIds = this.collectAccountIdForCompanyRevenues((List<Company_Revenue__c>)Trigger.old);
        this.updateRevenueForAccounts(accountIds, (List<Company_Revenue__c>)Trigger.old);*/
    /*}*/
    
    /**
     * Populates the account id set from the company revenue object that is being inserted, deleted.
     *
     * @param companyRevenueList, list of company revenue objects.
     */
    /*private Set<Id> collectAccountIdForCompanyRevenues(List<Company_Revenue__c> companyRevenueList)
    {
        Set<Id> accountIds = new Set<Id>();
        for (Company_Revenue__c companyRevenue : companyRevenueList)
        {
            if (companyRevenue != null && companyRevenue.Related_Account__c != null 
                && companyRevenue.Revenue__c != null && companyRevenue.Revenue__c != 0)
            {
                accountIds.add(companyRevenue.Related_Account__c);
            }
        }
        return accountIds;
    }*/
    
    /**
     * Populates the account id set from the company revenue object that is being updated.
     *
     * @param companyRevenueList, list of company revenue objects.
     * @param oldCompanyRevenueMap, map of old company revenue objects.
     */
    /*private Set<Id> collectAccountIdForCompanyRevenues(List<Company_Revenue__c> companyRevenueList, 
                                                        Map<Id, Company_Revenue__c> oldCompanyRevenueMap)
    {
        Set<Id> accountIds = new Set<Id>();
        for (Company_Revenue__c companyRevenue : companyRevenueList)
        {
            if (companyRevenue != null)
            {
                Company_Revenue__c oldCompanyRevenue = oldCompanyRevenueMap.get(companyRevenue.Id);
                if (companyRevenue.Related_Account__c != null 
                    && companyRevenue.Revenue__c != oldCompanyRevenue.Revenue__c)
                {
                    accountIds.add(companyRevenue.Related_Account__c);
                }
            }
        }
        return accountIds;
    }*/
    
    /**
     * Removes the revenue value of deleted company revenue object from the total revenue of related account.
     *
     * @param accountIds, set of account ids.
     * @param oldCompanyRevenueList old company revenue object list.
     */
    /*private void updateRevenueForAccounts(Set<Id> accountIds, List<Company_Revenue__c> oldCompanyRevenueList)
    {
        if (accountIds != null && !accountIds.isEmpty())
        {
            Map<Id, Account> accountMap = new Map<Id, Account>([Select Id, Billed_Rev_Prev_13_Months__c From Account Where Id IN:accountIds]);
            if (oldCompanyRevenueList != null)
            {
                for (Company_Revenue__c companyRevenue : oldCompanyRevenueList)
                {
                    if (companyRevenue != null)
                    {
                        Account account = accountMap.get(companyRevenue.Related_Account__c);
                        if (account != null)
                        {
                            account.Billed_Rev_Prev_13_Months__c = account.Billed_Rev_Prev_13_Months__c - companyRevenue.Revenue__c;
                        }
                    }
                }
            }
            update accountMap.values();
        }
    }*/
}