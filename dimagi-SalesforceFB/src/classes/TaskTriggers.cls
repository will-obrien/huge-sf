/**
 * Logic for the different triggers defined on Tasks
 *
 * @author  Antonio Grassi
 * @date    11/16/2012
 */
public with sharing class TaskTriggers {

    @future(callout=true)
    public static void addNoteInFogBugz(Id taskId) {
    	
    	
    	Task[] tasks = [select Id,
    	                       WhatId,
    	                       Description
    	                from Task
    	                where Id = :taskId];
    	
    	if (!tasks.isEmpty()) {
    		Task t = tasks[0];
    		Opportunity o = FogBugzUtils.fetchOpportunity(t.WhatId);
    		
    		if (o != null) {
    			
    			if (o.Fogbugz_Ticket_Number__c != null) {
    				FogBugzAPI api = new FogBugzAPI();
    				
    				String res = Test.isRunningTest() ?
    				             TestFogBugzAPI.TEST_FB_ID :
    				             api.addNote(o.Fogbugz_Ticket_Number__c, t.Description == null ? '' : t.Description);
    				
    				if (res == null) {
    					System.debug(LoggingLevel.ERROR, 'TaskTriggers::addNoteInFogBugz() - Error while adding note to case');
    				}
    			}
    			else {
    				System.debug(LoggingLevel.WARN, 'TaskTriggers::addNoteInFogBugz() - Opportunity is not a FB case');
    			}
    		}
    		else {
    			System.debug(LoggingLevel.WARN, 'TaskTriggers::addNoteInFogBugz() - Opportunity not found');
    		}
    	}
    	else {
    		System.debug(LoggingLevel.WARN, 'TaskTriggers::addNoteInFogBugz() - Task not found');
    	}
    }
}