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
*   Date Created:       ???
*   Author:             ???
*   Last Modified:      9/9/2015
*   Last Modified By:   Asha Calderon
*
*   
*   
**********************************************************************************************************************/

public with sharing class Handler_WebinarAttendance extends Handler{
    
    private list<Webinar_Attendance__c> newList;
    private map<Id,Webinar_Attendance__c> newMap;
    private list<Webinar_Attendance__c> oldList;
    private map<Id,Webinar_Attendance__c> oldMap;
    
    private map<Id,Account> relatedAccountMap;
    private map<Id,AccountStamp> accountStampMap;
    private map<Id,Webinar__c> relatedWebinarMap;
    public static Boolean BEFOREFIRED = false;
    public static Boolean AFTERFIRED = false;
    
    public Handler_WebinarAttendance() {
        
    }
    
    public Handler_WebinarAttendance(String typeOfHandler) {
        handlerType = typeOfHandler;
    }
    
    /****************************
    @method:
    mainEntry
    
    @description:
    calls the necessary classes when web attendance records are touched
    
    @param:
    trigger functions
    ******************************/
    public override void mainEntry(String triggerObject,
        Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate,
        Boolean isDelete, Boolean isUndelete, Boolean isExecuting, list<SObject> newList,
        map<Id,SObject> newMap, list<SObject> oldList, map<Id,SObject> oldMap)
    {
        
        this.newList = (list<Webinar_Attendance__c>)newList;
        this.newMap = (map<Id,Webinar_Attendance__c>)newMap;
        this.oldList = (list<Webinar_Attendance__c>)oldList;
        this.oldMap = (map<Id,Webinar_Attendance__c>)oldMap;

        system.debug('Main Entry: ' + triggerObject);
        if (isBefore  && !Handler_WebinarAttendance.BEFOREFIRED) {
             Handler_WebinarAttendance.BEFOREFIRED = true;
        }
        else if (isAfter && !Handler_WebinarAttendance.AFTERFIRED ) {
            if (isDelete) {
                Map<Id,Account> accountMap = AccountStamper.stampWebinarData(this.oldMap);
                Database.update(accountMap.values(),false);
                //@info: added aac to handle stamping to opps when del to update stamp with current data
                OpportunityStamper.getRelatedOpportunities(this.oldMap);
            }
            else {
                Map<Id,Account> accountMap = AccountStamper.stampWebinarData(this.newMap);
                Database.update(accountMap.values(),false);
                //@info: added aac to handle stamping to opps when del to update stamp with current data
                OpportunityStamper.getRelatedOpportunities(this.newMap);
            }
            Handler_WebinarAttendance.AFTERFIRED = true; //aac 9.9.15 moved to within brackets was causing issues with stampers not running
        }   
        
        TriggerDispatcher.activeHandler = null;
    }
    
    public override void inProgressEntry(String triggerObject,
        Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate,
        Boolean isDelete, Boolean isUndelete, Boolean isExecuting, list<SObject> newList,
        map<Id,SObject> newMap, list<SObject> oldList, map<Id,SObject> oldMap){
            system.debug('In Progress Entry: ' + triggerObject);
    }
    
    private static map<Id,map<String,Webinar_Attendance__c>> getRelatedWebinarAttendanceMap(set<Id> accountIds) {
        list<Webinar_Attendance__c> webinarAttendances = [
            SELECT 
            Id,Name,Account__c,Adjusted_Duration__c,Attended__c,Credit_Name__c,Credit_User__c,Status__c,Join_Time_From_Task__c,
            Duration__c,Lead__c,Leave_Time__c,OnDemand_Attendance_Date__c,OnDemand_Views__c,Join_Time__c,Created_From_Task__c,Citrix_Join_URL__c,
            Raised_Hands__c,Registration_Date__c,Source_Other__c,Stamp_Type__c,Webinar__c,Webinar__r.Name,Webinar__r.Event_Date_Time__c 
            FROM Webinar_Attendance__c 
            WHERE Account__c IN :accountIds
        ];
        
        map<Id,map<String,Webinar_Attendance__c>> relatedWebinarAttendanceMap = new map<Id,map<String,Webinar_Attendance__c>>();
        
        for(Webinar_Attendance__c webinarAttendance : webinarAttendances){
            if(webinarAttendance.Account__c != null){
                if(relatedWebinarAttendanceMap.get(webinarAttendance.Account__c) == null){
                    relatedWebinarAttendanceMap.put(webinarAttendance.Account__c,new map<String,Webinar_Attendance__c>());
                }
                relatedWebinarAttendanceMap.get(webinarAttendance.Account__c).put(String.valueOf(webinarAttendance.Webinar__r.Event_Date_Time__c) + webinarAttendance.Webinar__r.Name ,webinarAttendance);
            }
        }
        return relatedWebinarAttendanceMap;
    }
        
}