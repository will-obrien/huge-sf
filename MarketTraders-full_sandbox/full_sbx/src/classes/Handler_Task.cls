/**********************************************************************************************************************
*   Market Traders Institute, Inc.    CONFIDENTIAL
* ---------------------------------------------------------------------------------------------------------------------
*   [2015] Market Traders Institute
*   All Rights Reserved
*
*   NOTICE:  All information contained herein is, and remains the property of Market Traders Institute, Inc. and its
*   suppliers, if any.  The intellectual and technical concepts contained herein are proprietary to Market Traders 
*   Institute, Inc. and its suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are 
*   protected by trade secret or copyright law.  Dissemination of this information or reproduction of this material
*   is strictly forbidden unless prior written permission is obtained from Market Traders Institute, Inc.
*
*   Date Created:       4/28/2014
*   Author:             Jim Hutcherson
*   Last Modified:      8/23/2015
*   Last Modified By:   Sean Murphy
*
*   8/23/2015 - Code cleanup and code to execute InsideSales dialer increment
*   
**********************************************************************************************************************/
   
public with sharing class Handler_Task extends Handler{
    
    private list<Task> newList;
    private map<Id,Task> newMap;
    private list<Task> oldList;
    private map<Id,Task> oldMap;
    
    public static boolean BYPASS = false;
    public static boolean BEFOREFIRED = false;
    public static boolean AFTERFIRED = false;

	/**
	 *	constructor
	 */
    public Handler_Task(){
        
    }
    
    
    /**
	 *	constructor
	 */
    public Handler_Task(String typeOfHandler) {
    	handlerType = typeOfHandler;
    }
    
    
    /**********************
     @method: mainEntry
     @description: 
     	- update call details on account
     	- increment dial count on opportunity if applicable
     
     @params: 
     	triggerObject - string value of the object type of the trigger that called method
     	isBefore - flag indicating context of execution: before trigger context
     	isAfter - flag indicating context of execution: after trigger context
     	isInsert - flag indicating context of execution: insert context
     	isUpdate - flag indicating context of execution: update context
     	isDelete - flag indicating context of execution: delete context
     	isUndelete - flag indicating context of execution: undelete context
     	isExecuting - flag indicating context of execution: executing context
     	newList - list of sObjects representing newList trigger context variable
     	newMap - map of sObjects representing newMap trigger context variable
     	oldList - list of sObjects representing oldList trigger context variable
     	oldMap - map of sObjects representing oldMap trigger context variable
        
    **********/
    public override void mainEntry(String triggerObject,
        Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate,
        Boolean isDelete, Boolean isUndelete, Boolean isExecuting, list<SObject> newList,
        map<Id,SObject> newMap, list<SObject> oldList, map<Id,SObject> oldMap)
    {
                        
		this.newList = (list<Task>)newList;
        this.newMap = (map<Id,Task>)newMap;
        this.oldList = (list<Task>)oldList;
        this.oldMap = (map<Id,Task>)oldMap;
            
        if (Handler_Task.BYPASS != true) {
        	if(isAfter && Handler_Task.AFTERFIRED != true) {
            	Handler_Task.AFTERFIRED = true;
                if (isInsert || isUpdate || isUndelete) {
                	Handler_Task.updateAccountCallDetails(this.newList);
                    if (isInsert) {
                    	TaskHandlerHelper.incrementDialCounter(this.newMap);
                    }
                }
                else {
                	Handler_Task.updateAccountCallDetails(this.oldList);
                }
        	}
        }

            TriggerDispatcher.activeHandler = null;
	}
    
    
    /**********************
     @method: inProgressEntry
     @description: 
     	- no current functionality
     
     @params: 
     	triggerObject - string value of the object type of the trigger that called method
     	isBefore - flag indicating context of execution: before trigger context
     	isAfter - flag indicating context of execution: after trigger context
     	isInsert - flag indicating context of execution: insert context
     	isUpdate - flag indicating context of execution: update context
     	isDelete - flag indicating context of execution: delete context
     	isUndelete - flag indicating context of execution: undelete context
     	isExecuting - flag indicating context of execution: executing context
     	newList - list of sObjects representing newList trigger context variable
     	newMap - map of sObjects representing newMap trigger context variable
     	oldList - list of sObjects representing oldList trigger context variable
     	oldMap - map of sObjects representing oldMap trigger context variable
        
    **********/
    public override void inProgressEntry(String triggerObject,
        Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate,
        Boolean isDelete, Boolean isUndelete, Boolean isExecuting, list<SObject> newList,
        map<Id,SObject> newMap, list<SObject> oldList, map<Id,SObject> oldMap)
    {
    	system.debug('In Progress Entry: ' + triggerObject);
    }
    
    
    /**********************
     @method: updateAccountCallDetails
     @description: 
     	- updates Last_PhoneCall_Attempt__c, Last_PhoneCall_Spoke_With__c, Last_PhoneCall_Attempt_Account_Owner__c fields on account if applicable 
     
     @params: 
     	tasks - list of tasks, typically the list of new tasks from the trigger
        
    **********/
    public static void updateAccountCallDetails(list<Task> tasks) {
        set<Id> accountIds = new set<Id>();
        for (Task task : tasks) {
            String subject = '';
            if (task.Subject != null) {
                subject = task.Subject.toUpperCase();
            }
            
            if ((task.WhatId != null) && (String.valueOf(task.WhatId).startsWith('001')) && (subject.indexOf('EMAIL:') < 0) && (task.Status == 'Complete') && (task.Activity_Type__c == 'Outbound Phone Call')) {
                accountIds.add(task.WhatId);
            }
        }

		// 2014-09-19 AMalena - Added Last PhoneCall Spoke With to query below        
        Map<Id,Account> accountMap = new map<Id,Account>([SELECT Id, OwnerId, Last_PhoneCall_Spoke_With__c, Last_PhoneCall_Attempt__c, Last_PhoneCall_Attempt_Account_Owner__c 
        													FROM Account 
        													WHERE Id IN :accountIds]);
        CallLogger.refreshAccountCallLogFields(accountMap);
        if (!accountMap.isEmpty()) {
            Database.update(accountMap.values());
        }
    } 
}



/*   was in DemoDev, but not deployed to Production...
public with sharing class Handler_Task extends Handler{
    
    private list<Task> newList;
    private map<Id,Task> newMap;
    private list<Task> oldList;
    private map<Id,Task> oldMap;

    public Handler_Task(){
        
    }
    
    public override void mainEntry(String triggerObject,
        Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate,
        Boolean isDelete, Boolean isUndelete, Boolean isExecuting, list<SObject> newList,
        map<Id,SObject> newMap, list<SObject> oldList, map<Id,SObject> oldMap) {
            this.newList = (list<Task>)newList;
            this.newMap = (map<Id,Task>)newMap;
            this.oldList = (list<Task>)oldList;
            this.oldMap = (map<Id,Task>)oldMap;
            
            if(isAfter){

                if(isInsert || isUpdate || isUndelete){
                    set<Id> accountIds = new set<Id>();
                    for(Task task : this.newList){
                        String subject = '';
                        if(task.Subject != null)
                            subject = task.Subject.toUpperCase();
                        if(task.WhatId != null && String.valueOf(task.WhatId).startsWith('001') && 
                            subject.indexOf('EMAIL:') < 0 && 
                            task.Status == 'Complete' && 
                            task.Activity_Type__c == 'Phone Call'
                        ){
                            accountIds.add(task.WhatId);
                        }
                        map<Id,Account> accountMap = new map<Id,Account>([SELECT id,OwnerId,Last_PhoneCall_Attempt__c,Last_PhoneCall_Attempt_Account_Owner__c FROM Account WHERE Id IN :accountIds]);
                        CallLogger.refreshAccountCallLogFields(accountMap);
                        if(!accountMap.isEmpty())
                            Database.update(accountMap.values());
                    }
                }else{
                    set<Id> accountIds = new set<Id>();
                    for(Task task : this.oldList){
                        String subject = '';
                        if(task.Subject != null)
                            subject = task.Subject.toUpperCase();
                        if(task.WhatId != null && String.valueOf(task.WhatId).startsWith('001') && 
                            subject.indexOf('EMAIL:') < 0 && 
                            task.Status == 'Complete' && 
                            task.Activity_Type__c == 'Phone Call'
                        ){
                            accountIds.add(task.WhatId);
                        }

                        map<Id,Account> accountMap = new map<Id,Account>([SELECT id,OwnerId,Last_PhoneCall_Spoke_With__c,Last_PhoneCall_Attempt__c,Last_PhoneCall_Attempt_Account_Owner__c FROM Account WHERE Id IN :accountIds]);
                        CallLogger.refreshAccountCallLogFields(accountMap);
                        if(!accountMap.isEmpty())
                            Database.update(accountMap.values());
                    }
                
                }
            
            }

            TriggerDispatcher.activeHandler = null;

    }
    
    public override void inProgressEntry(String triggerObject,
        Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate,
        Boolean isDelete, Boolean isUndelete, Boolean isExecuting, list<SObject> newList,
        map<Id,SObject> newMap, list<SObject> oldList, map<Id,SObject> oldMap){
            system.debug('In Progress Entry: ' + triggerObject);
    }

}
*/