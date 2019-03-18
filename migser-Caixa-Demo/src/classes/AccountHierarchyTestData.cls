public class AccountHierarchyTestData {

	public static void createTestHierarchy() {
		// Create Accounts with Hierarchy
	
		// Create Top Level Accounts
	
	
		Account[] subAccounts = new Account[]{};
		Account[] accountList = new Account[]{};
		Account[] subAccountsSideTree = new Account[]{};
		Account[] subAccountsList = new Account[]{};
		
		
		String accountName = 'HierarchyTest';
		
		Account parentAccount = new Account(name=accountName+'0');
		Account subTreeParent  = new Account();
		Account subTreeSideParent  = new Account();


		insert parentAccount;
		parentAccount = [select id, name from account where name='HierarchyTest0'];
		Id parentID = parentAccount.id;
		System.Assert(parentID != null, 'Parent Id not found');
		
		// Create sub accounts
	
		for (Integer i=0;i<10;i++){
			subAccounts.add(new Account(name=accountName+i));	
		}
		
		insert subAccounts;
		
		accountList = [Select id, parentID, name from account where name like 'HierarchyTest%' ORDER BY Name];
				
		for (Integer x=0;x<accountList.size();x++){
			if (accountList[x].name != 'HierarchyTest0'){
				accountList[x].parentID = parentID;
				parentID=accountList[x].Id;	
			}
		}
		
		update accountList;
		
		subTreeParent = [Select id, parentID, name from account where name = 'HierarchyTest4'];
		parentID=subTreeParent.Id;

		for (Integer y=0;y<10;y++){
			subAccountsSideTree.add(new Account(name=accountName+'4.'+y));	
		}

		insert subAccountsSideTree;
		
		subAccountsList = [Select id, parentID, name from account where name like 'HierarchyTest4%'];

		for (Integer z=1;z<subAccountsList.size();z++){
			subAccountsList[z].parentID = parentID;
			parentID=accountList[z].Id;	
		}
		
		update subAccountsList;
		
	}


}