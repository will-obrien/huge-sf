/*********************************************************************
Name : SetAccountOwnerFromCompany 
Created On : dec 22, 2011  
Created By : Lalit Bohra
Description : Trigger on Company for updating the company account-owner id from company TESLA_SALESMANAGER_ID__c and add
new account team members to company-account 
Task :T-33093
**********************************************************************/
trigger SetAccountOwnerFromSalesPrimaryOwner on Account (before insert, before update) {
    Id PGIntegrationUserId;
    PGIAppStaticResources staticResources = PGIAppStaticResources.getInstance();
    if (staticResources.pgiIntegrationUser != null)
    {
    	PGIntegrationUserId = staticResources.pgiIntegrationUser.Id;
    } 
    if(test.isRunningTest() || PGIntegrationUserId != null && UserInfo.GetUserId() ==PGIntegrationUserId){  
        set<String> SalesPrimaryOwnerSet = new set<String>();
        map<String,Id> UserMap = new map<String,Id>();
        list<Account> AccountList= new list<Account>();
        for(Account acc:trigger.new){
            // creating a set of Sales primary owner for updating the account-owner id.
            if(acc.SalesPrimaryOwner__c != null && acc.SalesPrimaryOwner__c != ''&& acc.Exclude_from_Integration__c==False){
                SalesPrimaryOwnerSet.add(acc.SalesPrimaryOwner__c.toLowerCase());
                AccountList.add(acc);
            }
        }
        
        if(SalesPrimaryOwnerSet != null && SalesPrimaryOwnerSet.size()>0){
             Boolean isInActiveTrigger = false;
            // query form Custom setting
            for(Trigger_Settings__c ts : [Select InactivatSetAccountOwnerFromSalesPrimary__c From Trigger_Settings__c]){
                // Set settting into veriable
                isInActiveTrigger = ts.InactivatSetAccountOwnerFromSalesPrimary__c;
            }
           // system.debug('---------isInActiveTrigger----------------'+isInActiveTrigger);
            //  is trigger execute?
            
            if(isInActiveTrigger == false){
                List<User> UserList=[Select id,UserName from User where UserName in:SalesPrimaryOwnerSet and IsActive=true];
                if(UserList != null && UserList.size()>0){
                    for(User user:UserList){
                        // creating a map of user 
                        if(!UserMap.ContainsKey(user.UserName)){
                            UserMap.put(user.UserName,user.Id);
                        }
                    }
                    for(Account acc:AccountList){
                        // updating the account owner
                        if(UserMap.containsKey(acc.SalesPrimaryOwner__c.toLowerCase())){
                            acc.OwnerId=UserMap.get(acc.SalesPrimaryOwner__c.toLowerCase());
                        }           
                    }   
                }
            }
        }
    }   
}