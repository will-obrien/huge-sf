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
*   Date Created:       6/24/2015
*   Author:             Asha Calderon
*   Last Modified:      8/2/2015
*   Last Modified By:   Sean Murphy
*
*   8/2/2015 - Code cleanup (Sean Murphy)
*   
**********************************************************************************************************************/
/********************************
Handler_Opportunity 

@description: 
extends the abstract class Handler
handles the order of classes needed for updates/deletes/inserts to the Opportunity

**/
public with sharing class Handler_Opportunity extends Handler {
  
    public class HandlerOpportunityException extends Exception {}
  
    private List<Opportunity> newList;
    private Map<Id,Opportunity> newMap;
    private List<Opportunity> oldList;
    private Map<Id,Opportunity> oldMap;

  
    public static Boolean BYPASS = false;
    public static Boolean BEFOREFIRED = false;
    public static Boolean AFTERFIRED = false;
 
 
    public static List<Webinar_Attendance__c> webattndanceToUpdate = new List<Webinar_Attendance__c>();
    
    /********************************
        Handler_Opportunity 
    
        @description: 
        constructor
    
    **/  
  
    public Handler_Opportunity() {
    }
  
    /********************************
        Handler_Opportunity 
    
        @description: 
        overloaded constructor 
        passes through the object that was triggered
    
    **/  
    public Handler_Opportunity(String typeOfHandler) {
        handlerType = typeOfHandler;
        }
  
    /********************************
        mainEntry
    
        @description: 
        called from the TriggerDispatcher based on the parameters passed the different classes are fired 
        executed if the activeHandler is null when the triggerDispatcher is fired
    
        @param: triggerObject - passes through the current object that was triggered
        @param: isBefore - if the trigger is a before trigger
        @param: isAfter - if the trigger function is an after trigger
        @param: isInsert - if the trigger function is an insert trigger
        @param: isUpdate - if the trigger function is an update trigger
        @param: isDelete - if the trigger function is an delete trigger
        @param: isUndelete - if the trigger function is an undelete trigger
        @param: isExecuting - if current call is a trigger, not a Visualforce page, a Web service, or an executeanonymous() API call
        @param: newList -  A list of sObject to the new versions of the sObject records
        @param: newMap- A map of IDs to the new versions of the sObject records
        @param: oldList - A list of sObject to the old versions of the sObject records
        @param: oldMap - A map of IDs to the old versions of the sObject records    
                
    **/  
    public override void mainEntry(String triggerObject,
        Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate,
        Boolean isDelete, Boolean isUndelete, Boolean isExecuting, List<SObject> newList,
        Map<Id,SObject> newMap, List<SObject> oldList, Map<Id,SObject> oldMap)
    {
        system.debug('Main Entry: ' + triggerObject);
        try {
            this.newList = (List<Opportunity>)newList;
            this.newMap = (Map<Id,Opportunity>)newMap;
            this.oldList = (List<Opportunity>)oldList;
            this.oldMap = (Map<Id,Opportunity>)oldMap;
      
            if (!Handler_Opportunity.BYPASS) {
                System.debug('@asha:@debug:Handler_Opportunity:Primary Logic Firing: ' + triggerObject);
                if (isBefore && !Handler_Opportunity.BEFOREFIRED) {
                    if (isInsert) {

                    }
                    else if (isUpdate) {
                        //System.debug('@asha:@debug:Handler_Opportunity: Starting Opp Stamper - Update');
                        //OpportunityStamper.stampOpportunities(this.newMap);
                    }
                    Handler_Opportunity.BEFOREFIRED = true;                   
                }
                else if (isAfter && !Handler_Opportunity.AFTERFIRED) {
                    if (isUpdate) {
                        //@info: aac 6.23.15 pass the webinar attendance list to an overall list to update at the end of the trigger
                        webattndanceToUpdate.addAll(OpportunityStamper.stampOpportunities(newMap.values(), this.oldMap)); 
                    }
                    else if (isDelete) {
            
                    }
                    Handler_Opportunity.AFTERFIRED = true;                   
                }
            }

            TriggerDispatcher.activeHandler = null;
            //@info: this allows the webinar attendance trigger to fire since it is done after the active handler is set to null
            if(webattndanceToUpdate.size() >0){
                update webattndanceToUpdate;
            }
        }
        catch(Exception ex) {
            Logger logger = new Logger('Opportunity Handler');
            logger.log(ex.getMessage());
            logger.log(ex.getStackTraceString());
            logger.emailDebugResults(new List<String>{'sfdev@markettraders.com'});
        }
    }
 
 
    /********************************
    inProgressEntry
    
    @description: 
    called from the TriggerDispatcher based on the parameters passed the different classes are fired 
    called if a trigger function for an sobject is already in progress
    executed if the activeHandler is not null when the triggerDispatcher is fired
    
    @param: triggerObject - passes through the current object that was triggered
    @param: isBefore - if the trigger is a before trigger
    @param: isAfter - if the trigger function is an after trigger
    @param: isInsert - if the trigger function is an insert trigger
    @param: isUpdate - if the trigger function is an update trigger
    @param: isDelete - if the trigger function is an delete trigger
    @param: isUndelete - if the trigger function is an undelete trigger
    @param: isExecuting - if current call is a trigger, not a Visualforce page, a Web service, or an executeanonymous() API call
    @param: newList -  A list of sObject to the new versions of the sObject records
    @param: newMap- A map of IDs to the new versions of the sObject records
    @param: oldList - A list of sObject to the old versions of the sObject records
    @param: oldMap - A map of IDs to the old versions of the sObject records    
                 
    **/   
    public override void inProgressEntry(String triggerObject,
        Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate,
        Boolean isDelete, Boolean isUndelete, Boolean isExecuting, List<SObject> newList,
        Map<Id,SObject> newMap, List<SObject> oldList, Map<Id,SObject> oldMap)
    {
        system.debug('In Progress Entry: ' + triggerObject);
    }
}