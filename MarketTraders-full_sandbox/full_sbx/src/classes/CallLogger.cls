/* NOTE:  2014-09-19 AMalena used the actual code IN PRODUCTION to do an updated commented below -
   The code that was here in DemoDev is BELOW commented out */
   
public with sharing class CallLogger {

    public static void refreshAccountCallLogFields(map<Id,Account> accountMap){
        map<Id,list<Task>> relatedTaskMap = CallLogger.getRelatedTaskMap(accountMap.keySet());
        for(Account account : accountMap.values()){
            account.Last_PhoneCall_Attempt__c = null;
            account.Last_PhoneCall_Attempt_Account_Owner__c = null;
            list<Task> relatedTasks = relatedTaskMap.get(account.Id);

            if(relatedTasks != null){
                Task latestCall = relatedTasks.remove(0);
                account.Last_PhoneCall_Attempt__c = latestCall.CreatedDate.Date();

// 2014-09-19 AMalena added to support "last time spoke with" needs.. will need to be
//    replicated to Opp related Tasks later (which currently doesn't happen at all for even
//    regular calls
                if( latestCall.Call_Disposition__c == 'Spoke With' ){
                    account.Last_PhoneCall_Spoke_With__c = latestCall.CreatedDate.Date();
                }

                if(latestCall.OwnerId == account.OwnerId){
                    account.Last_PhoneCall_Attempt_Account_Owner__c = latestCall.CreatedDate.Date();    
                }else{
                    for(Task task : relatedTasks){
                        if(task.OwnerId == account.OwnerId){
                            account.Last_PhoneCall_Attempt_Account_Owner__c = task.CreatedDate.Date();
                            break;
                        }
                    }
                }       

            }

        }
    }
    
    private static map<Id,list<Task>> getRelatedTaskMap(set<Id> accountIds){
        list<Task> relatedTasks = [
            SELECT 
                id,
                WhatId,
                OwnerId,
                Call_Disposition__c,
                CreatedDate
            FROM Task 
            WHERE 
                (NOT Subject LIKE '%EMAIL:%') AND
                Activity_Type__c = 'Outbound Phone Call' AND 
                Status = 'Complete' AND 
                WhatId IN :accountIds
            ORDER BY CreatedDate DESC
        ];
        map<Id,list<Task>> relatedTaskMap = new map<Id,list<Task>>();
        for(Task task : relatedTasks){
            if(relatedTaskMap.get(task.WhatId) == null){
                relatedTaskMap.put(task.WhatId,new list<Task>());
            }
            relatedTaskMap.get(task.WhatId).add(task);
        }
        return relatedTaskMap;
    }
    
}



/* originally found in DemoDev

public with sharing class CallLogger {

    public static void refreshAccountCallLogFields(map<Id,Account> accountMap){
        map<Id,list<Task>> relatedTaskMap = CallLogger.getRelatedTaskMap(accountMap.keySet());
        for(Account account : accountMap.values()){
            account.Last_PhoneCall_Attempt__c = null;
            account.Last_PhoneCall_Attempt_Account_Owner__c = null;
            list<Task> relatedTasks = relatedTaskMap.get(account.Id);
            if(relatedTasks != null){
                Task latestCall = relatedTasks.remove(0);
                account.Last_PhoneCall_Attempt__c = latestCall.CreatedDate.Date();
                if(latestCall.OwnerId == account.OwnerId){
                    account.Last_PhoneCall_Attempt_Account_Owner__c = latestCall.CreatedDate.Date();    
                }else{
                    for(Task task : relatedTasks){
                        if(task.OwnerId == account.OwnerId){
                            account.Last_PhoneCall_Attempt_Account_Owner__c = task.CreatedDate.Date();
                            break;
                        }
                    }
                }       
            }
        }
    }
    
    private static map<Id,list<Task>> getRelatedTaskMap(set<Id> accountIds){
        list<Task> relatedTasks = [
            SELECT 
                id,
                WhatId,
                OwnerId,
                CreatedDate,
                Call_Disposition__c
            FROM Task 
            WHERE 
                (NOT Subject LIKE '%EMAIL:%') AND
                Activity_Type__c = 'Phone Call' AND 
                Status = 'Complete' AND 
                WhatId IN :accountIds
            ORDER BY CreatedDate DESC
        ];
        map<Id,list<Task>> relatedTaskMap = new map<Id,list<Task>>();
        for(Task task : relatedTasks){
            if(relatedTaskMap.get(task.WhatId) == null){
                relatedTaskMap.put(task.WhatId,new list<Task>());
            }
            relatedTaskMap.get(task.WhatId).add(task);
        }
        return relatedTaskMap;
    }
    
}

*/