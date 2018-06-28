/**
 * This is helper class for PGIAccountTrigger. It contains the helper methods to implement the business requirement
 * on the Account object on trigger execution.
 *
 * @author Amit M.
 * @version 1.0
 */
public with sharing class PGIAccountTriggerHelper {
	
	/* Stores the list of Ids for the masted rocords. */
	private static Set<Id> mergedAccountIds = new Set<Id>();
	
	/* Store static boolean variable to avoid the multiple execution of the after update scenario. */
	private static Boolean firstTriggerExecution = true;
	
	/**
	 * Executes in the before update context of the trigger. Performs below operations,
	 *	1. Updates the count of companies on the account object, required in merge account scenario.
	 *	2. Updates the count of all companies on the account object, company trigger is not run (any child objects that reparented as a result of merge operation do not fire triggers).
	 */
	public void onBeforeUpdate()
	{
		Map<Id,Account> accountMap = this.collectMasterMergedAccounts((List<Account>)Trigger.new);
		this.updateCompanyCount(accountMap);
		this.updateAllCompanyCount(accountMap);
		//UpdateDataComFields();
	}
	
	/**
	 * Executes in the before insert context of the trigger. Performs below operations,
	 */
	public void onBeforeInsert()
	{
		//if(ValidateDataComFields()){
        //    UpdateDataComFields();
        //}
	}
	
	/**
	 * Executes in the after delete context of the trigger. Performs below operations,
	 * 1. Collects the id of Master records for the merged accounts.
	 */
	public void onAfterDelete()
	{
		this.collectMergedAccounts((List<Account>)Trigger.old);
	}
	
	/**
	 * Executes in the after update context of the trigger. Performs below operations,
	 *	1. Updates the owner of the related company object (and company revenue object related to company) for an account if owner is changed.
	 */
	public void onAfterUpdate()
	{
		//SetEmailOptOutToFalse();
		/*if (firstTriggerExecution || Test.isRunningTest())
		{
			//this.updateRelatedCompanyOwner((Map<Id, Account>)Trigger.newMap, (Map<Id, Account>)Trigger.oldMap);
			firstTriggerExecution = false;
		}*/
	}
	
	/**
	 * Collects the Ids of the master accounts
	 *
	 * @param list of old account in the trigger context.
	 */
	private void collectMergedAccounts(List<Account> oldAccountList)
	{
		for (Account account : oldAccountList)
		{
			if (account.MasterRecordId != null)
			{
				mergedAccountIds.add(account.MasterRecordId);
			}
		}
	}
	
	/**
	 * Collects the account for which update is fired based on merge operation.
	 *
	 * @param list of new account in the trigger context.
	 */
	private Map<Id, Account> collectMasterMergedAccounts(List<Account> newAccountList)
	{
		Map<Id, Account> masterMergedAccountMap = new Map<Id, Account>();
		for (Account account : newAccountList)
		{
			if (mergedAccountIds.contains(account.Id))
			{
				masterMergedAccountMap.put(account.Id, account);
			}
		}
		return masterMergedAccountMap;
	}
	
	/**
	 * Executes the aggregate query to get the count of companies for the account and updates the company count field on account.
	 *
	 * @param map of old account in the trigger context.
	 */
	public void updateCompanyCount(Map<Id, Account> accountMap)
	{
		if (accountMap != null && !accountMap.isEmpty())
		{
			/*List<AggregateResult> aggregateResultList = [Select count(Id) companyCount, Account__c accountId
														from Company__c 
														Where TESLA_InactiveDate__c=:NULL And Account__c IN:accountMap.keySet() 
														Group By Account__c];*/
			List<AggregateResult> aggregateResultList = [Select count(Id) companyCount, Account__c accountId
														from Company__c 
														Where CreatedDate = LAST_N_DAYS:90 And Account__c IN:accountMap.keySet() 
														Group By Account__c];
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
								account.Count_of_Companies__c = (Double)arrgregateResult.get('companyCount');
							}
						}
					}
				}
			}
		}
	}
	
	/**
	 * Executes the aggregate query to get the count of all companies for the account and updates the count of all companies field on account.
	 *
	 * @param map of old account in the trigger context.
	 */
	public void updateAllCompanyCount(Map<Id, Account> accountMap)
	{
		if (accountMap != null && !accountMap.isEmpty())
		{
			List<AggregateResult> aggregateResultList = [Select count(Id) companyCount, Account__c accountId
														from Company__c 
														Where Account__c IN:accountMap.keySet() 
														Group By Account__c];
			if (aggregateResultList != null)
			{
				for (AggregateResult aggregateResult : aggregateResultList)
				{
					if (aggregateResult != null)
					{
						Id accountId = (Id)aggregateResult.get('accountId');
						if (accountId != null)
						{
							Account account = accountMap.get(accountId);
							if (account != null)
							{
								account.Count_of_all_Companies__c = (Double)aggregateResult.get('companyCount');
							}
						}
					}
				}
			}
		}
	}
	
	/**
	 * Checks if owner is changed for an account then updates the owner for related company and company revenue objects.
	 *
	 * @param list of new account in the trigger context.
	 * @param map of old account in the trigger context.
	 */
	/*public void updateRelatedCompanyOwner(Map<Id, Account> newAccountsMap, Map<Id, Account> oldAccountsMap)
	{
		List<Account> updatedOwnerAccountList = new List<Account>();
		if (newAccountsMap != null && !newAccountsMap.isEmpty() && oldAccountsMap != null && !oldAccountsMap.isEmpty())
		{
			for (Account newAccount : newAccountsMap.values())
			{
				if (newAccount != null)
				{
					Account oldAccount = oldAccountsMap.get(newAccount.Id);
					if (oldAccount != null && newAccount.OwnerId != oldAccount.OwnerId)
					{
						updatedOwnerAccountList.add(newAccount);
					}
				}
			}
			if (!updatedOwnerAccountList.isEmpty())
			{
				this.updateRelatedCompanyOwner(updatedOwnerAccountList, newAccountsMap);
			}
		}
	}*/
	
	/**
	 * Checks if owner is changed for an account then updates the owner for related company and company revenue objects.
	 *
	 * @param list of accounts for which owner is changed.
	 * @param map of new account in the trigger context.
	 */
	/*private void updateRelatedCompanyOwner(List<Account> accountList, Map<Id, Account> newAccountsMap)
	{
		List<Company_Revenue__c> companyRevenueList = new List<Company_Revenue__c>();
		List<Company__c> companiesToUpdate = new List<Company__c>();
		for (List<Company__c> companyList : [Select Id, OwnerId, Account__c, 
											(Select Id, OwnerId From Company_Revenue__r) 
											From Company__c Where Account__c IN:accountList Order By Account__c])
		{
			for (Company__c company : companyList)
			{
				Account account = newAccountsMap.get(company.Account__c);
				if (account != null)
				{
					company.OwnerId = account.OwnerId;
					for (Company_Revenue__c companyRevenue : company.Company_Revenue__r)
					{
						companyRevenue.OwnerId = account.OwnerId;
						companyRevenueList.add(companyRevenue);
					}
					companiesToUpdate.add(company);
				}
			}
		}
		if (!companiesToUpdate.isEmpty())
		{
			update companiesToUpdate;
		}
		if (!companyRevenueList.isEmpty())
		{
			update companyRevenueList;
		}
	}*/
	
	/**
     * Validate Data.Com fields before insert account. 
     */
    /*private boolean ValidateDataComFields(){
    	//Skip validation if Override_Validation_Rules__c = true
    	User currentUser = [SELECT Override_Validation_Rules__c FROM User WHERE Id =: UserInfo.GetUserId() LIMIT 1];
    	if (currentUser.Override_Validation_Rules__c){
    		return true;	
    	}
    	
        Boolean isSuccess = true;
        Set<String> dunsNumbers = new Set<String>();
        
        //Get information for processing
        for (Account account : (List<Account>) Trigger.New){
            if(account.Global_Ultimate_Duns__c != null && account.Global_Ultimate_Duns__c != ''){
                dunsNumbers.add(account.Global_Ultimate_Duns__c);
            }
        }
        
        List<Account> accountList = [SELECT Id, Duns_Number__c, OwnerId FROM Account WHERE Duns_Number__c IN :dunsNumbers];
        Map<String, Account> accountMap = new Map<String, Account>();
        for (Account accountDunsNumber : accountList){
            accountMap.put(accountDunsNumber.Duns_Number__c, accountDunsNumber);
        }
        
        //Check fields
        for (Account account : (List<Account>) Trigger.New){
            if(account.Duns_Number__c != account.Global_Ultimate_Duns__c && accountMap.containsKey(account.Global_Ultimate_Duns__c) 
            && account.OwnerId != accountMap.get(account.Global_Ultimate_Duns__c).OwnerId){
                account.addError('This account is a child record. Please add the ultimate owner instead.');
                isSuccess = false;
            }
        }
        
        return isSuccess;
    }*/
    
    /**
     * Update Data.Com fields before insert & before update account. 
     */
    /*private void UpdateDataComFields(){
        Set<String> dunsNumbers = new Set<String>();    
        Map<Id, Account> oldMap = (Map<Id, Account>) Trigger.oldMap;
        Map<Id, Account> newMap = (Map<Id, Account>) Trigger.newMap;
        
        //Get information for processing
        for (Account account : (List<Account>) Trigger.New){
            if (account.Global_Ultimate_Duns__c != null && account.Global_Ultimate_Duns__c != ''){
                dunsNumbers.add(account.Global_Ultimate_Duns__c);
            } 
            if (account.Parent_Duns_Number__c != null && account.Parent_Duns_Number__c != ''){
                dunsNumbers.add(account.Parent_Duns_Number__c);
            }
        }
        
        List<Account> accountList = [Select Id, Duns_Number__c, Type, BillingCountry, Duns_Annual_Revenue__c FROM Account WHERE Duns_Number__c IN :dunsNumbers];
        Map<String, Account> accountMap = new Map<String, Account>();
        for (Account accountDunsNumber : accountList){
            accountMap.put(accountDunsNumber.Duns_Number__c, accountDunsNumber);
        }
        
        //Update fields
        for (Account account : (List<Account>) Trigger.New){
        	if (accountMap.containsKey(account.Global_Ultimate_Duns__c)){
        		Account globalUltimateDunsAccount = accountMap.get(account.Global_Ultimate_Duns__c);
        		account.Type = globalUltimateDunsAccount.Type;
        		account.Global_Ultimate_Country__c = globalUltimateDunsAccount.BillingCountry;
        		account.Global_Ultimate_Annual_Revenue__c = globalUltimateDunsAccount.Duns_Annual_Revenue__c;
        	}
            else {
            	account.Global_Ultimate_Country__c = '';
            	account.Global_Ultimate_Annual_Revenue__c = null;
            }
            
            if (accountMap.containsKey(account.Parent_Duns_Number__c)){
            	account.Duns_Parent_Country__c = accountMap.get(account.Parent_Duns_Number__c).BillingCountry;
            }
            else {
            	account.Duns_Parent_Country__c = '';
            }    
        }
    }*/
    
    /*private void SetEmailOptOutToFalse(){
    	Map<Id, Account> oldMap = (Map<Id, Account>) Trigger.oldMap;
    	Set<Id> accountIds = new Set<Id>();   		
    	for(Account account : (List<Account>)Trigger.New){
    		if(account.Status__c == 'Customer' && oldMap.get(account.Id).Status__c == 'Prospect'){
    			accountIds.add(account.Id);
    		}
    	}
    	
    	List<Contact> contactList = [SELECT Id, HasOptedOutOfEmail FROM Contact WHERE HasOptedOutOfEmail = true AND accountId =: accountIds];
    	for (Contact con : contactList){
    		con.HasOptedOutOfEmail = false;
    	}
    	update contactList;
    }*/
}