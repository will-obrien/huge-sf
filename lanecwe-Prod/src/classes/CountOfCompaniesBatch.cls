/**
 * Updates Count_of_Companies__c value in Account object with count of companies created within the last 90 days.
 * 1. The count for the most recent companies added/deleted/updated are covered in PGICompanyTrigger. 
 * 2. This class covers scenario for accounts when companies are not updated or expired (companies created longer than 90 days ago during the time this class is run).
 *
 * @author Carmen Wong
 * @version 1.0
 */
global class CountOfCompaniesBatch implements Database.Batchable<sObject>{
	global String query;
	
	global database.querylocator start(Database.BatchableContext BC){
		return Database.getQueryLocator(query);
	}
	
	global void execute(Database.BatchableContext BC, List<Account> accList){
		try{
			Map<Id, Integer> accountToCompanyCountMap = new Map<Id, Integer>();
			List<Account> updateAccountList = new List<Account>();
			List<AggregateResult> aggregateResultList = [SELECT count(Id) companyCount, Account__c accountId
														FROM Company__c 
														WHERE CreatedDate = LAST_N_DAYS:90 And Account__c IN: accList 
														GROUP BY Account__c];
			
			for (AggregateResult aggregateResult : aggregateResultList){
				accountToCompanyCountMap.put((Id)aggregateResult.get('accountId'),(Integer)aggregateResult.get('companyCount'));			
			}
			for (Account account : accList){
				if(accountToCompanyCountMap.containsKey(account.Id)){
					Integer companyCount = accountToCompanyCountMap.get(account.Id);
					if(account.Count_of_Companies__c != companyCount)
						updateAccountList.add(new Account(Id = account.Id, Count_Of_Companies__c = companyCount));
				}
				else {
					//When count=0, account is not in aggregateResultList
					if (account.Count_of_Companies__c != 0){
						updateAccountList.add(new Account(Id = account.Id, Count_Of_Companies__c = 0));
					}
				}
			}
			update updateAccountList;
		}
		catch(Exception ex){
			PGIErrorUtilities.logPgiError('CountOfCompaniesBatch:update()', ex.getMessage(), PGIErrorUtilities.LoggingLevel.DEBUG);
		}
	}
	 
	global void finish(Database.BatchableContext BC){       
    }
    
}