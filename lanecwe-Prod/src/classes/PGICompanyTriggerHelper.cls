/**
 * This is helper class for PGICompanyTrigger. It contains the helper methods to implement the business requirement
 * on the Company object on trigger execution.
 *
 * @author Amit M.
 * @version 1.0
 */
public without sharing class PGICompanyTriggerHelper {
	
	/* Stores counter value to be decreased by one. */
	private static final Integer DECREASE_BY_ONE = -1;
	
	/* Stores counter value to be increased by one. */
	private static final Integer INCREASE_BY_ONE = 1;
	
	private static final Integer NONE = 0;
	private static final Integer TESLA_INACTIVEDATE = 1;
	private static final Integer DATE_CREATED_WITHIN_N_DAYS = 90;
	private static final Integer N_DAYS = 90;
	
	/* Stores map of accounts for the given account ids. */
	private Map<Id, Account> accountMap;
	
	/**
	 * Executes in the after delete context of the trigger. Performs below operations,
	 *	1. (Removed) Decreases the count of company on the account object if company without TESLA_InactiveDate__c is deleted.
	 *  2. Decreases the count of company on the account object if company created within last N days.
	 *	3. Decreases the count of all companies on the account object.
	 */
	public void onAfterDelete()
	{
		Map<Id, Integer> accountToCompanyCountMap = populateCompanyCountMap((List<Company__c>)Trigger.old, DECREASE_BY_ONE, DATE_CREATED_WITHIN_N_DAYS);
		this.updateCompanyCountOnAccount(accountToCompanyCountMap);
		
		Map<Id, Integer> accountToAllCompanyCountMap = populateCompanyCountMap((List<Company__c>)Trigger.old, DECREASE_BY_ONE, NONE);
	    this.updateAllCompanyCountOnAccount(accountToAllCompanyCountMap);
	}
	
	/**
	 * Executes in the after insert context of the trigger. Performs below operations,
	 *	1. (Removed) Increases the count of company on the account object if company without TESLA_InactiveDate__c is inserted.
	 *  2. Increases the count of company on the account object if company created within last N days.
	 *  3. Increases the count of all companies on the account object.
	 */
	public void onAfterInsert()
	{
		Map<Id, Integer> accountToCompanyCountMap = populateCompanyCountMap((List<Company__c>)Trigger.new, INCREASE_BY_ONE, DATE_CREATED_WITHIN_N_DAYS);
		this.updateCompanyCountOnAccount(accountToCompanyCountMap);
		
		Map<Id, Integer> accountToAllCompanyCountMap = populateCompanyCountMap((List<Company__c>)Trigger.new, INCREASE_BY_ONE, NONE);
		this.updateAllCompanyCountOnAccount(accountToAllCompanyCountMap);
	}
	
	/**
	 * Executes in the after update context of the trigger. Performs below operations,
	 *	1. (Removed) Updates the count of company on account object if account is changed on company or TESLA_InactiveDate__c is updated.
	 *  2. Updates the count of company on account object if account is changed on company created within last N days.
	 *	3. Updates the count of all companies on account object if account is changed on company.
	 *  4. (Removed) Updates the account on Company Revenue object for a company if company account is changed.
	 */
	public void onAfterUpdate()
	{
		Map<Id, Integer> accountToCompanyCountMap = populateCompanyCountMap((List<Company__c>)Trigger.new, (Map<Id, Company__c>)Trigger.oldMap, DATE_CREATED_WITHIN_N_DAYS);
		this.updateCompanyCountOnAccount(accountToCompanyCountMap);
		
		Map<Id, Integer> accountToAllCompanyCountMap = populateCompanyCountMap((List<Company__c>)Trigger.new, (Map<Id, Company__c>)Trigger.oldMap, NONE);
		this.updateAllCompanyCountOnAccount(accountToAllCompanyCountMap);
		
		// TODO : Commenting Company Revenue related code as per Andy's instructions.
		/*Set<Id> accountIds = new Set<Id>();
		Set<Id> companyIds = this.getCompanyListWithUpdatedAccount((Map<Id, Company__c>)Trigger.newMap, 
																   (Map<Id, Company__c>)Trigger.oldMap,
																   accountIds);
		this.populateAccountMap(accountIds);
		this.updateAccountOnCompanyRevenue(companyIds, (Map<Id, Company__c>)Trigger.newMap);
		this.updateRevenueForAccounts(accountIds);*/
	}
	
	/**
	 * Executes in the before update context of the trigger. Performs below operations,
	 *	1. Sets the owner of the company object same as updated account.
	 */
	public void onBeforeUpdate()
	{
		// TODO : Commenting Company Revenue related code as per Andy's instructions.
		/*Set<Id> accountIds = new Set<Id>();
		Set<Id> companyIds = this.getCompanyListWithUpdatedAccount((Map<Id, Company__c>)Trigger.newMap, 
																   (Map<Id, Company__c>)Trigger.oldMap,
																   accountIds);
		this.populateAccountMap(accountIds);
		this.updateCompanyOwner((Map<Id, Company__c>)Trigger.newMap, companyIds);*/
	}
	
	/**
	 * Sets the owner same as the owner of account that is set on the company object.
	 *
	 * @param newCompanyMap, map of company objects.
	 * @param companyIds, Id of company objects for which account is updated.
	 */
	/*private void updateCompanyOwner(Map<Id, Company__c> newCompanyMap, Set<Id> companyIds)
	{
		if (accountMap != null && !accountMap.isEmpty())
		{
			for (Id companyId : companyIds)
			{
				Company__c company = newCompanyMap.get(companyId);
				company.OwnerId = accountMap.get(company.Account__c).OwnerId;
			}
		}
	}*/
	
	/**
	 * Retrieves the account object for the given account ids.
	 *
	 * @param accountIds, set of ids of account object.
	 */
	/*private void populateAccountMap(Set<Id> accountIds)
	{
		if (accountIds != null && !accountIds.isEmpty())
		{
			accountMap = new Map<Id, Account>([Select Id, Billed_Rev_Prev_13_Months__c, OwnerId From Account Where Id IN:accountIds]);
		}
	}*/
	
	/**
	 * Populates the map with account id and count of companies for the account. 
	 * This method is used in PGICompanyRevenueTriggerHelper class as well.
	 *
	 * @param companyList, list of company objects.
	 * @param counterValue, to increase/decrease the company count.
	 */
	/*public void updateRevenueForAccounts(Set<Id> accountIds)
	{
		if (accountIds != null && !accountIds.isEmpty())
		{
			if (this.accountMap == null)
			{
				this.populateAccountMap(accountIds);
			}
			// reset the total revenue value for all accounts, so that account for which there are no company revenues now,
			// will set to zero.
			for (Account account : accountMap.values())
			{
				account.Billed_Rev_Prev_13_Months__c = 0;
			}
			List<AggregateResult> aggregateResultList = [Select SUM(Revenue__c) revenueTotal, Related_Account__c accountId
														from Company_Revenue__c 
														Where Related_Account__c IN:accountIds And Revenue__c != NULL 
														And Revenue__c != 0.0 Group By Related_Account__c Having SUM(Revenue__c) > 0.0];
			
			if (aggregateResultList != null)
			{
				for (AggregateResult arrgregateResult : aggregateResultList)
				{
					if (arrgregateResult != null)
					{
						Id accountId = (Id)arrgregateResult.get('accountId');
						if (accountId != null)
						{
							Account account = accountMap.get(accountId);
							if (account != null)
							{
								account.Billed_Rev_Prev_13_Months__c = (Double)arrgregateResult.get('revenueTotal');
							}
						}
					}
				}
			}
			update accountMap.values();
		}
	}*/
	
	/**
	 * Populates the map with account id and count of companies for the account.
	 *
	 * @param companyList, list of company objects.
	 * @param counterValue, to increase/decrease the company count.
	 */
	/*private void updateAccountOnCompanyRevenue(Set<Id> companyIds, Map<Id, Company__c> newCompanyMap)
	{
		if (companyIds != null && !companyIds.isEmpty())
		{
			List<Company_Revenue__c> companyRevenueToUpdateList = new List<Company_Revenue__c>();
			for (List<Company_Revenue__c> companyRevenueList : [Select Id, Related_Account__c, Company_Name__c 
																From Company_Revenue__c 
																Where Company_Name__c IN:companyIds])
			{
				for (Company_Revenue__c companyRevenue : companyRevenueList)
				{
					Company__c company = newCompanyMap.get(companyRevenue.Company_Name__c);
					Account account = accountMap.get(company.Account__c);
					if (account != null)
					{
						companyRevenue.OwnerId = account.OwnerId;
					}
					companyRevenue.Related_Account__c = company.Account__c;
					companyRevenueToUpdateList.add(companyRevenue);
				}
				if (!companyRevenueToUpdateList.isEmpty())
				{
					update companyRevenueToUpdateList;
					companyRevenueToUpdateList.clear();
				}
			}
		}
	}*/
	
	/**
	 * Populates the map with account id and count of companies for the account.
	 *
	 * @param companyList, list of company objects.
	 * @param counterValue, to increase/decrease the company count.
	 */
	/*private Set<Id> getCompanyListWithUpdatedAccount(Map<Id, Company__c> newCompanyMap, Map<Id, Company__c> oldCompanyMap, Set<Id> accountIds)
	{
		Set<Id> companyIds = new Set<Id>();
		for (Company__c newCompany : newCompanyMap.values())
		{
			if (newCompany != null)
			{
				Company__c oldCompany = oldCompanyMap.get(newCompany.Id);
				if (oldCompany != null && oldCompany.Account__c != newCompany.Account__c)
				{
					companyIds.add(newCompany.Id);
					accountIds.add(oldCompany.Account__c);
					accountIds.add(newCompany.Account__c);
				}
			}
		}
		return companyIds;
	}*/
	
	/**
	 * Populates the map with account id and count of companies for the account.
	 *
	 * @param companyList, list of company objects.
	 * @param counterValue, to increase/decrease the company count.
	 * @param filterCondition
	 */
	private Map<Id, Integer> populateCompanyCountMap(List<Company__c> companyList, Integer counterValue, Integer filterCondition)
	{
		Map<Id, Integer> accountToCompanyCountMap = new Map<Id, Integer>();
		for (Company__c company : companyList)
		{
			if (company != null)
			{
				if(filterCondition == NONE || 
				(filterCondition == TESLA_INACTIVEDATE && company.TESLA_InactiveDate__c == null) ||
				(filterCondition == DATE_CREATED_WITHIN_N_DAYS && company.CreatedDate >= System.Today() - N_DAYS))
					this.updateCountInMap(accountToCompanyCountMap, company.Account__c, counterValue);
			}
		}
		return accountToCompanyCountMap;
	}
	
	/**
	 * Populates the map with account id and count of companies for the account in after update trigger context.
	 *
	 * @param newCompanyList, list of company objects.
	 * @param oldCompanyMap, map of old company objects in the trigger context.
	 * @param filterCondition
	 * @returns map of account id and count of companies.
	 */
	private Map<Id, Integer> populateCompanyCountMap(List<Company__c> newCompanyList, Map<Id, Company__c> oldCompanyMap, Integer filterCondition)
	{
		Map<Id, Integer> accountToCompanyCountMap = new Map<Id, Integer>();
		for (Company__c company : newCompanyList)
		{
			Company__c oldCompany = oldCompanyMap.get(company.Id);
			// check if account is updated on the company object
			if (company != null && oldCompany != null && company.Account__c != oldCompany.Account__c)
			{
				if(filterCondition == NONE){
					this.updateCountInMap(accountToCompanyCountMap, company.Account__c, INCREASE_BY_ONE);
					this.updateCountInMap(accountToCompanyCountMap, oldCompany.Account__c, DECREASE_BY_ONE);
				}
				else if(filterCondition == DATE_CREATED_WITHIN_N_DAYS){
					if (company.CreatedDate >= System.Today() - N_DAYS){
						this.updateCountInMap(accountToCompanyCountMap, company.Account__c, INCREASE_BY_ONE);
					}
					if (oldCompany.CreatedDate >= System.Today() - N_DAYS){
						this.updateCountInMap(accountToCompanyCountMap, oldCompany.Account__c, DECREASE_BY_ONE);
					}
				}
				/*else if(filterCondition == TESLA_INACTIVEDATE) {
					// if TESLA_InactiveDate__c is not added or removed, then decrease the count in old account
					// by one and increase the count in new account by one.
					if (company.TESLA_InactiveDate__c == null && oldCompany.TESLA_InactiveDate__c == null)
					{
						this.updateCountInMap(accountToCompanyCountMap, company.Account__c, INCREASE_BY_ONE);
						this.updateCountInMap(accountToCompanyCountMap, oldCompany.Account__c, DECREASE_BY_ONE);
					}
					// if TESLA_InactiveDate__c is removed, then increase the count in new account by one.
					else if (company.TESLA_InactiveDate__c == null && oldCompany.TESLA_InactiveDate__c != null)
					{
						this.updateCountInMap(accountToCompanyCountMap, company.Account__c, INCREASE_BY_ONE);
					}
					// if TESLA_InactiveDate__c is added, the decrease the count in old account by one.
					else if (company.TESLA_InactiveDate__c != null && oldCompany.TESLA_InactiveDate__c == null)
					{
						this.updateCountInMap(accountToCompanyCountMap, oldCompany.Account__c, DECREASE_BY_ONE);
					}
				}*/
			}
			/*// if TESLA_InactiveDate__c is removed, the increase the count on the account by one.
			else if (filterCondition == TESLA_INACTIVEDATE && company.TESLA_InactiveDate__c == null && oldCompany.TESLA_InactiveDate__c != null)
			{
				this.updateCountInMap(accountToCompanyCountMap, company.Account__c, INCREASE_BY_ONE);
			}
			// if TESLA_InactiveDate__c is added, the decrease the count on the account by one.
			else if (filterCondition == TESLA_INACTIVEDATE && company.TESLA_InactiveDate__c != null && oldCompany.TESLA_InactiveDate__c == null)
			{
				this.updateCountInMap(accountToCompanyCountMap, company.Account__c, DECREASE_BY_ONE);
			}*/
		}
		return accountToCompanyCountMap;
	}
	
	/**
	 * Updates the count of companies in the map for the given account ids.
	 *
	 * @param accountToCompanyCountMap, map of account id to company count.
	 * @param accountId, account Id.
	 * @param counterValue, to increase/decrease the company count.
	 */
	private void updateCountInMap(Map<Id, Integer> accountToCompanyCountMap, Id accountId, Integer counterValue)
	{
		if(accountId != null)
		{
			if (accountToCompanyCountMap.containsKey(accountId))
			{
				accountToCompanyCountMap.put(accountId, accountToCompanyCountMap.get(accountId) + counterValue);
			}
			else
			{
				accountToCompanyCountMap.put(accountId, counterValue);
			}
		}
	}
	
	/**
	 * Retrieves the account object for the given account ids and updates the count of comapies.
	 *
	 * @param accountToCompanyCountMap, map of account id to company count.
	 */
	private void updateCompanyCountOnAccount(Map<Id, Integer> accountToCompanyCountMap)
	{
		if (!accountToCompanyCountMap.isEmpty())
		{
			List<Account> accountList = [Select Id, Count_of_Companies__c From Account Where Id IN:accountToCompanyCountMap.keySet()];
			if (accountList != null && !accountList.isEmpty())
			{
				try {
					for (Account account : accountList)
					{
						if (account != null)
						{
							if (account.Count_of_Companies__c == null)
							{
								account.Count_of_Companies__c = accountToCompanyCountMap.get(account.Id);
							}
							else
							{
								account.Count_of_Companies__c = account.Count_of_Companies__c + accountToCompanyCountMap.get(account.Id);
							}
							if (account.Count_of_Companies__c < 0){
								String errorMessage = 'Count_Of_Companies__c is negative value';
								errorMessage += ' Account=' + account + ' Count='+ accountToCompanyCountMap.get(account.Id);
								PGIErrorUtilities.logPgiError('PGICompanyTriggerHelper:updateCompanyCountOnAccount()', errorMessage, PGIErrorUtilities.LoggingLevel.DEBUG);
								
								account.Count_of_Companies__c = 0;
							}
						}
					}
					update accountList;
				}
				catch(Exception ex){
					PGIErrorUtilities.logPgiError('PGICompanyTriggerHelper:updateCompanyCountOnAccount()', ex.getMessage(), PGIErrorUtilities.LoggingLevel.DEBUG);
				}
			}
		}
	}
	
	/**
	 * Retrieves the account object for the given account ids and updates the count of all companies
	 *
	 * @param accountToCompanyCountMap, map of account id to company count.
	 */
	private void updateAllCompanyCountOnAccount(Map<Id, Integer> accountToCompanyCountMap)
	{
		if (!accountToCompanyCountMap.isEmpty())
		{
			List<Account> accountList = [Select Id, Count_of_all_Companies__c From Account Where Id IN:accountToCompanyCountMap.keySet()];
			if (accountList != null && !accountList.isEmpty())
			{
				try{
					for (Account account : accountList)
					{
						if (account != null)
						{
							if (account.Count_of_all_Companies__c == null)
							{
								account.Count_of_all_Companies__c = accountToCompanyCountMap.get(account.Id);
							}
							else
							{
								account.Count_of_all_Companies__c = account.Count_of_all_Companies__c + accountToCompanyCountMap.get(account.Id);
							}
							if (account.Count_of_all_Companies__c < 0){
								String errorMessage = 'Count_of_all_Companies__c is negative value';
								errorMessage += ' Account=' + account + ' Count='+ accountToCompanyCountMap.get(account.Id);
								PGIErrorUtilities.logPgiError('PGICompanyTriggerHelper:updateAllCompanyCountOnAccount()', errorMessage, PGIErrorUtilities.LoggingLevel.DEBUG);
								
								account.Count_of_all_Companies__c = 0;
							}
						}
					}
					update accountList;
				}
				catch(Exception ex){
					PGIErrorUtilities.logPgiError('PGICompanyTriggerHelper:updateAllCompanyCountOnAccount()', ex.getMessage(), PGIErrorUtilities.LoggingLevel.DEBUG);
				}
			}
		}
	}
}