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
*   Date Created:       2/5/2014
*   Author:             Jim Hutcherson
*   Last Modified:      12/18/2015
*   Last Modified By:   Asha Calderon
*
*   11/28/15 - msm: code cleanup
*   12.18.15 - aac: added fields to account map return for processor 
*   
**********************************************************************************************************************/

public with sharing class ProccessorHelperMethods {
    
    /*************************************
    *
    *   @method: getLeadMap
    *   @description: queries and returns a list of leads using a set of email address as the matching criteria (returned list sorted by Created date oldest to newest)
    *
    **/
    public static Map<String, Lead> getLeadMap(Set<String> emails, String recordTypeId) {
        //List<Lead> leads = [SELECT id,CreatedDate,Email,Alternate_Email__c,FirstName,LastName FROM Lead WHERE (Email in :emails OR Alternate_Email__c in :emails) AND IsConverted = false AND RecordTypeId = :recordTypeId ORDER BY CreatedDate ASC];
        List<Lead> leads = [SELECT id, CreatedDate, Email, Alternate_Email__c, FirstName, LastName 
                                FROM Lead 
                                WHERE (Email in :emails OR Alternate_Email__c in :emails) 
                                AND IsConverted = false 
                                ORDER BY CreatedDate ASC];
                                
        Map<String, Lead> leadMap = new Map<String, Lead>();
        for (Lead lead : leads) {
            if (leadMap.get(lead.Email) == null) {
                leadMap.put(lead.Email, lead);
            }
            
            if (leadMap.get(lead.Alternate_Email__c) == null) {
                leadMap.put(lead.Alternate_Email__c, lead);
            }   
        }
        return leadMap;
    }
    
    
    /*************************************
    *
    *   @method: getAccountMap
    *   @description: queries and returns a list of accounts using a set of email address as the matching criteria (returned list sorted by Created date oldest to newest)
    *
    **/
    public static Map<String, Account> getAccountMap(Set<String> emails, String product) {
        List<Account> accounts = [SELECT Id, Phone, Phone_Num_Exists_date_entered__c, ContEd_Sub_Stage__c, CreatedDate, PersonEmail,
                                        Alternate_Email__c, PersonContactId, PersonLeadSource, FirstName, LastName, 
                                        WebinarOD_UTP_Total_Duration__pc,Webinar_UTP_First_Attd__c,Webinar_Client_First_Attd__c,
                                        Webinar_UOC_First_Attd__pc,Webinar_USC_First_Attd__pc,Webinar_LMFS_First_Attd__pc,
                                        (SELECT Id, CloseDate, CreatedDate, AccountId, StageName, RecordTypeId, OwnerId, Product__c,
                                                Account_Email__c, Account_Phone__c, Account_First_Name__c, Account_Last_Name__c,
                                                Owner_Name__c, x3Clogic_Stage_Score__c, Country_List__c 
                                            FROM Opportunities 
                                            WHERE Product__c = :product 
                                            ORDER BY CreatedDate ASC) 
                                    FROM Account 
                                    WHERE (PersonEmail in :emails OR Alternate_Email__c in :emails) 
                                    ORDER BY CreatedDate ASC];
                                    
        Map<String, Account> accountMap = new Map<String, Account>();
        for (Account account : accounts) {
            if (accountMap.get(account.PersonEmail) == null) {
                accountMap.put(account.PersonEmail, account);
            }
            
            if (accountMap.get(account.Alternate_Email__c) == null) {
                accountMap.put(account.Alternate_Email__c, account);
            }
        }
        return accountMap;
    }
    
    
    /*************************************
    *
    *   @method: getTaskMap
    *   @description: queries and returns a list of tasks using a set of sObject Ids as the matching criteria (returned list sorted by Created date oldest to newest)
    *
    **/
    public static Map<Id, List<Task>> getTaskMap(Set<Id> whoIds, String webinarId) {
        List<Task> tasks = [SELECT Id, WhoId, AccountId, Webinar_Source_Other__c, WebinarOD_Attendance_Count__c, Duration__c,
                                    Subject__c, Webinar_Id__c, Status, Webinar_Source_User_ID__c, Webinar_Source_User_ID_NAME__c 
                                FROM Task 
                                WHERE Webinar_Id__c = :webinarId 
                                AND WhoId in :whoIds 
                                ORDER BY CreatedDate ASC];
                                
        Map<Id, List<Task>> taskMap = new Map<Id, List<Task>>();
        for (Task task : tasks) {
            if (taskMap.get(task.WhoId) == null) {
                taskMap.put(task.WhoId, new List<Task>());
            }
            taskMap.get(task.WhoId).add(task);
        }
        return taskMap;
    }

    
    /*************************************
    *
    *   @method: getWebinarAttendanceMap
    *   @description: queries and returns a map of webinar attendances using a set of email address as the matching criteria (returned list sorted by Created date oldest to newest) 
    *
    **/
    public static Map<String, Webinar_Attendance__c> getWebinarAttendanceMap(Set<String> emails, String webinarId, DateTime eventDateTime) {
        Date attendedDate = Date.valueOf(eventDateTime);
        List<Webinar_Attendance__c> webinarAttendance = [SELECT Id, Email__c, Alternate_Email__c, Raised_Hands__c, Lead__c, Account__c,
                                                                Citrix_Join_URL__c, Duration__c, Attended__c 
                                                            FROM Webinar_Attendance__c 
                                                            WHERE (Email__c in :emails OR Alternate_Email__c in :emails) 
                                                            AND Webinar__c = :webinarId];
                                                            
        Map<String,Webinar_Attendance__c> webinarAttendanceMap = new Map<String,Webinar_Attendance__c>();
        for (Webinar_Attendance__c attendance : webinarAttendance) {
            if (webinarAttendanceMap.get(attendance.Email__c) == null) {
                webinarAttendanceMap.put(attendance.Email__c, attendance);
            }
            
            if (webinarAttendanceMap.get(attendance.Alternate_Email__c) == null) {
                webinarAttendanceMap.put(attendance.Alternate_Email__c, attendance);
            }
        }
        return webinarAttendanceMap;
    }
    
    
    /*************************************
    *
    *   @method: getOrphanWebinarAttendanceMap
    *   @description: queries and returns a map of webinar attendances related to a webinar that have no related lead or account 
    *
    **/
    public static Map<String, Webinar_Attendance__c> getOrphanWebinarAttendanceMap(String webinarId) {
    	List<Webinar_Attendance__c> orphanList = [SELECT Id, Email__c, Alternate_Email__c, Raised_Hands__c, Lead__c, Account__c,
                                                                Citrix_Join_URL__c, Duration__c, Attended__c, Orphan_Attendance_Info__c 
                                                            FROM Webinar_Attendance__c 
                                                            WHERE Account__c = null 
                                                            AND Lead__c = null 
                                                            AND Webinar__c = :webinarId];
                                                            
        Map<String, Webinar_Attendance__c> orphanMap = new Map<String, Webinar_Attendance__c>();
        for (Webinar_Attendance__c wa : orphanList) {
        	if (orphanMap.get(wa.Orphan_Attendance_Info__c) == null) {
        		orphanMap.put(wa.Orphan_Attendance_Info__c, wa);
        	}
        }
        
        return orphanMap;
    }
    
    
    /*************************************
    *
    *   @method: createTask
    *   @description:  
    *
    *   @param:
    **/
    public static Task createTask(Webinar__c webinar, String whoId, String activityType, String webinarType) {
        Task task = new Task();
        task.Event_Name__c = webinar.Name;
        task.ActivityDate = Date.valueOf(webinar.Event_Date_Time__c);
        task.Webinar_ID__c = webinar.Webinar_Id__c;
        task.Subject = 'Webinar';
        task.Subject__c = 'Webinar';
        task.Activity_Type__c = activityType;
        task.Webinar_Type__c = webinarType;
        task.Registered__c = true;
        task.Priority = 'Normal';
        task.OwnerId = '00560000000mIAO';
        task.Webinar_Join_URL__c = 'NA Did not come through the form';
        task.Webinar_Source_Other__c = 'Did not come through api form';
        task.Webinar_Source_User_ID__c = '00560000000mIAO';
        task.Webinar_Source_User_ID_Name__c = 'Next Step Financial Holdings';
        task.Event_Date_Time__c = webinar.Event_Date_Time__c;
        task.WhoId = whoId;
        return task;    
    }
    
    
    /*************************************
    *
    *   @method: createWebinarAttendance
    *   @description:  
    *
    **/
    public static Webinar_Attendance__c createWebinarAttendance(Boolean isAccount, String sfid, Boolean attended, Decimal sessionDuration, Id webinarID, DateTime eventDateTime, String stampType) {
        Webinar_Attendance__c webinarAttendance = new Webinar_Attendance__c();
        if (isAccount) {
            webinarAttendance.Account__c = sfid;
        }
        webinarAttendance.Attended__c = attended;
        webinarAttendance.Stamp_Type__c = stampType;
        if (stampType == 'OnDemand') {
            webinarAttendance.OnDemand_Attendance_Date__c = Date.valueOf(eventDateTime);
        }
        webinarAttendance.Duration__c = sessionDuration;
        webinarAttendance.Registration_Date__c = Date.today();
        webinarAttendance.Webinar__c = webinarID;
        return webinarAttendance;
    }
    
    
    /*************************************
    *
    *   @method: createOpportunity
    *   @description:  
    *
    **/
    public static Opportunity createOpportunity(String oppName, String oppRecordType, Date oppCloseDate, String oppStageName, String oppSubStage, String paymentPlan, String oppProduct, Id accountId) {
        Opportunity opp = new Opportunity();
        opp.Name = oppName + ' (' + String.valueOf(Date.today()) + ')';
        opp.RecordTypeId = oppRecordType;
        opp.AccountId = accountId;
        opp.CloseDate = oppCloseDate;
        opp.StageName = oppStageName;
        opp.Sub_Stage__c = oppSubStage;
        opp.Payment_Plan__c = paymentPlan;
        opp.Product__c = oppProduct;
        return opp;
    }   

    
    /*************************************
    *
    *   @method: getEndOfQuarterDate
    *   @description: returns the end date of the current quarter based on a standard calendar year
    *
    *   @param: currentDate - the date to use for evaluation
    **/
    public static Date getEndOfQuarterDate(Date currentDate) {
        Integer month = currentDate.month();
        Integer year = currentDate.year();
        if (month < 4) {
            return Date.newInstance(year, 4, 1).addDays(-1);
        }
        else if (month < 7) {
            return Date.newInstance(year, 7, 1).addDays(-1);
        }
        else if (month < 10) {
            return Date.newInstance(year, 10, 1).addDays(-1);
        }
        else {
            return Date.newInstance(year+1, 1, 1).addDays(-1);
        }
    }

}