public with sharing class x_AccountStructureHelper {
	//Improve code coverage
	public static void inactive(){
	}
	
      /**
     * Future call to update the accounts that have DUNS field values but did not fall under any hierarhcy.
     * This future call was required as this page is embedded into Account detail standard page, and we
     * cannot perform DML on the same account of the same detail page.
     *
     * @param accountIds, set of account Ids.
     */
    
    /*public static void updateNoMatchAccountForDnb(Set<Id> accountIds)
    {
        system.debug('Inside Future Call updateNoMatchAccountForDnb ===>'+accountIds);
        List<Account> accountList = [Select Id, No_DnB_Hierarchy_Match__c From Account Where Id IN:accountIds];
        system.debug('accountList.size() ===>'+accountList.size());
        for (Account account : accountList)
        {
            account.No_DnB_Hierarchy_Match__c = true;
        }
        if (!accountList.isEmpty())
        {
            update accountList;
        }
        system.debug('Exit Future Call ===>');
    }*/

}