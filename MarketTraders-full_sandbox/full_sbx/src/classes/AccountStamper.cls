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
*   Date Created:       2/21/2014
*   Author:             Jim Hutcherson
*   Last Modified:      7/22/2015
*   Last Modified By:   Sean Murphy
*
*   7/22/2015 - Added code to support addition of USC (Ultimate Stock Course)
*   
**********************************************************************************************************************/

/**
    The current process loops at the highest level (the executeStamp method and calls out to each stamp method, each method accepting a single stamp and the account)
    if we map a wrapper by account we can then sort (via wrapper) from earliest to latest to easily identify the first and last
    created Wrapper_AccountStamp (will wrap AccountStamp, WebinarAttendance, and Webinar)   Do we need all of this?
    
    we filter on stamp type which is in the Webinar Attendance and the stamp  (OnDemand, UOC, UTP)
    we filter on attendance date which is in the Webinar Attendance and the stamp
    we use the field "duration" which is on the Webinar Attendance and the stamp
    we filter on the field "status" which is on the Webinar, but NOT ON THE STAMP *******    add the webinar attendance status to the stamp AND THE ACCOUNT ID
    we filter on the field "attended" which in on the Webinar and the stamp
    
    we only process "Complete" (status) and "Attended" (attended) webinar attendances when doing "NON-MISSED" rollups
    we only process "Complete" (status) and "NOT Attended" (attended) webinar attendance when doing "MISSED" rollups
    
    !!!!! NOTE THE DIFFERENCE FOR ON DEMAND vs. NOT ONDEMAND (UOC, UTP) for number of sessions/number attended !!!!!
    stamp product "total" - record aggregate duration and aggregate ** number of sessions** for all COMPLETE ATTENDED ONDEMAND webinar attendance records
    stamp product "total" - record aggregate duration and aggregate number of records for all COMPLETE ATTENDED ONDEMAND webinar attendance records
    stamp product "first" - record date, src other, webinar Id, duration, and presenter of first COMPLETE ATTENDED webinar attendance
    stamp product "last" - record date, src other, webinar Id, duration, and presenter of last  COMPLETE ATTENDED webinar attendance
    stamp product "send" - record send Id of first and last COMPLETE ATTENDED webinar attendance (the field is )
     
*/

public with sharing class AccountStamper {
    
    public static final String BE_WEBINAR = 'Webinar_Client_Latest_Attd__c';
    public static final String ONLINE_UNIV = 'Last_Access_Date_Online_University__pc';
    public static final String CLASS_WEBINAR = 'Last_Access_Date_Classes__pc';
    public static final String CE_PURCHASE = 'ContEd_Prod_Purch_LATEST_date__c';
    public static final String UCS_ACCESS = 'Last_Access_Date_UCS__pc';
    public static final String AOD_VISIT = 'AODchat_Latest_Visit__c';
    public static final Integer TOUCH_PERIOD = -60;  // using negative for last N days
    
    public class StamperException extends Exception {}
    
    private static Map<Id, Account> myAccountMap {get; private set;}
    private static Map<Id, Webinar_Attendance__c> myWebinarAttendanceMap {get; private set;}
    private static Map<Id, Webinar__c> myWebinarMap {get; private set;}
    
    /**
    *   @method:
    *   stampWebinarData
    *
    *   @description: Accepts a map of Webinar_Attendance__c records, finds all related Accounts and Webinar_Attendance__c records
    *   and updates the related accounts webinar fields.
    *
    *   @param Map<Id, Webinar_Attendance__c> webinarAttendanceMap
    *
    */
    public static Map<Id, Account> stampWebinarData(Map<Id, Webinar_Attendance__c> webinarAttendanceMap) {
        getAccountMap(webinarAttendanceMap.values());   
        
        Set<Id> accountIds = new Set<Id>();
        for (Webinar_Attendance__c webinarAttendance : webinarAttendanceMap.values()) {
            accountIds.add(webinarAttendance.Account__c);
        }
        
        getFullWebinarAttendanceMap(accountIds);
        getWebinarMap(myWebinarAttendanceMap.values());
        
        AccountStamper.executeStamping();
        
        return myAccountMap;
    }
    
    
    /**
    *   @method:
    *   stampWebinarData
    *
    *   @description: 
    *   Accepts a map of Account records, and updates the related accounts webinar fields
    *   
    *   @param:
    *   Map<Id, Account> accountMap
    *
    */
    public static Map<Id, Account> stampWebinarData(Map<Id, Account> accountMap) {
        myAccountMap = accountMap;
        
        getFullWebinarAttendanceMap(myAccountMap.keySet());
        getWebinarMap(myWebinarAttendanceMap.values());
        AccountStamper.executeStamping();
        
        return myAccountMap;
    }
    
    
    /**
    *   @method:
    *   getAccountMap
    *
    *   @description: 
    *   Accepts a list of webinar attendance records, gets acct ids from list and then queries accounts
    *   
    *   @param:
    *   List<Webinar_Attendance__c> webAttends
    *
    */
    private static void getAccountMap(List<Webinar_Attendance__c> webAttends) {
        Set<Id> acctIds = new Set<Id>();
        for (Webinar_Attendance__c webAtt : webAttends) {
            if (webAtt.Account__c != null) {
                acctIds.add(webAtt.Account__c);
            }
        }
        
        getAccountMap(acctIds);
    }
    
    
    /**
    *   @method:
    *   getAccountMap
    *
    *   @description: 
    *   Accepts a list of acct ids and then queries accounts
    *   
    *   @param:
    *   List<Webinar_Attendance__c> webAttends
    *
    */
    private static void getAccountMap(Set<Id> acctIds) {
        myAccountMap = new Map<Id,Account>([SELECT
                Lead_Created_Date_pre_Account__c,
                PB_WonRegardless_Ultimate_Options_Course__c,
                PB_UTP_Summary_CWON_REGARDLESS__c,
                Last_Access_Date_Classes__pc,
                /*aac added fields for LMFS and Continued Ed Sales */
                Webinar_LMFS_First_Attd__pc,
                Webinar_LMFS_First_Attd_Time__pc,
                Webinar_LMFS_First_Attd_Presenter__pc,
                Webinar_LMFS_First_Attd_Src_Other__pc,
                Webinar_LMFS_First_Duration__pc,             
                Webinar_LMFS_Latest_Attd__pc,
                Webinar_LMFS_Latest_Attd_Time__pc,
                Webinar_LMFS_Latest_Attd_Presenter__pc,
                Webinar_LMFS_Latest_Attd_Src_Other__pc,
                Webinar_LMFS_Latest_Duration__pc,                
                Webinar_LMFS_NumAttended__pc,  
                Webinar_LMFS_First_Attd_Credit__pc,
                Webinar_LMFS_First_Attd_Credit_ID__pc,
                Webinar_LMFS_Latest_Attd_Credit__pc,
                Webinar_LMFS_Latest_Attd_Credit_ID__pc,
                
                Webinar_Client_First_Attd_Credit__c,
                Webinar_Client_First_Attd_Credit_ID__c,
                Webinar_Client_Latest_Attd_Credit__c,
                Webinar_Client_Latest_Attd_Credit_ID__c,
                Webinar_Client_First_Attd__c,
                Webinar_BE_First_Attd_Time__c,
                Webinar_Client_First_Attd_Presenter__c,
                Webinar_BE_First_Attd_Src_Other__c,
                Webinar_BE_First_Duration__c,  
                Webinar_Client_Latest_Attd__c,             
                Webinar_BE_Latest_Attd_Time__c,
                Webinar_Client_Latest_Attd_Presenter__c,
                Webinar_BE_Latest_Attd_Src_Other__c,
                Webinar_BE_Latest_Duration__c,
                Webinar_Client_NumAttended__c,
                /*aac added fields for LMFS and Continued Ed Sales */               
                WebinarOD_UTP_First_Attd_Credit__pc,
                WebinarOD_UTP_First_Attd_Credit_ID__pc,
                WebinarOD_UTP_First_Attd_Date__pc,
                WebinarOD_UTP_First_Attd_Duration__pc,
                WebinarOD_UTP_First_Attd_Presenter__pc,
                WebinarOD_UTP_First_Attd_Src_Other__pc,
                WebinarOD_UTP_First_Attd_Src_Oth_List__pc,
                WebinarOD_UTP_First_Attd_Src_Oth_Templ__pc,
                WebinarOD_UTP_First_Attd_Src_Oth_Type__pc, 
                WebinarOD_UTP_First_Attd_WebID__pc,
                WebinarOD_UTP_Latest_Att_Src_Oth_List__pc,
                WebinarOD_UTP_Latest_Attd_Date__pc,
                WebinarOD_UTP_Latest_Attd_Duration__pc,
                WebinarOD_UTP_Latest_Attd_Src_Other__pc,
                WebinarOD_UTP_Total_Duration__pc,
                WebinarOD_UTP_Total_Sessions__pc,
                
                Webinar_UOC_First_Attd__pc,
                Webinar_UOC_First_Attd_Credit__pc,
                Webinar_UOC_First_Attd_Presenter__pc,
                Webinar_UOC_First_Attd_Duration__pc,
                Webinar_UOC_First_Attd_Src_Other__pc,
                Webinar_UOC_First_Attd_Time__pc,
                Webinar_UOC_Second_Attd__pc,
                Webinar_UOC_Latest_Attd__pc,
                Webinar_UOC_Latest_Attd_Credit__pc,
                Webinar_UOC_Latest_Attd_Credit_ID__pc,
                Webinar_UOC_Latest_Attd_Presenter__pc,
                Webinar_UOC_Latest_Attd_Duration__pc,
                Webinar_UOC_Latest_Attd_Src_Other__pc,
                Webinar_UOC_Latest_Attd_Time__pc,
                Webinar_UOC_NumAttended__pc,
                Webinar_UOC_Total_Duration__pc,
                Webinar_UOC_Latest_Missed_Date__pc,
                Webinar_UOC_First_Attd_Credit_ID__pc,
                
                Webinar_USC_First_Attd__pc,
                Webinar_USC_First_Attd_Presenter__pc,
                Webinar_USC_First_Attd_Duration__pc,
                Webinar_USC_First_Attd_Src_Other__pc,
                Webinar_USC_First_Attd_Time__pc,
                Webinar_USC_Latest_Attd__pc,
                Webinar_USC_Latest_Attd_Presenter__pc,
                Webinar_USC_Latest_Attd_Duration__pc,
                Webinar_USC_Latest_Attd_Src_Other__pc,
                Webinar_USC_Latest_Attd_Time__pc,
                Webinar_USC_NumAttended__pc,
                Webinar_USC_Total_Duration__pc,
                Webinar_USC_Latest_Missed_Date__pc,
                
                Webinar_UOC_60min_Count__pc,
                Webinar_UOC_60min_Date__pc,
                Webinar_UOC_60min_from_First__pc,
                Webinar_UOC_60min_to_Purch__pc,
                Webinar_UOC_90min_Count__pc,
                Webinar_UOC_90min_Date__pc,
                Webinar_UOC_90min_from_First__pc,
                Webinar_UOC_90min_to_Purch__pc,
                Webinar_UOC_Last_At_Purch__pc,
                Webinar_UOC_Last_At_Purch_Credit__pc,
                Webinar_UOC_Last_At_Purch_Duration__pc,
                Webinar_UOC_Last_At_Purch_Presenter__pc,
                Webinar_UOC_Last_At_Purch_SrcOth__pc,
                Webinar_UOC_Last_At_Purch_Time__pc,
                Webinar_UOC_Last_At_Purch_vs_FirstAttd__pc,
                Webinar_UOC_Last_At_Purch_vs_LdCr__pc,
                Webinar_UOC_First_Attd_SendID__pc,
                
                Webinar_UTP_First_Attd_Duration__c,
                Webinar_UTP_First_Attd_Credit__c,
                Webinar_UTP_First_Attd_Credit_ID__c,
                Webinar_UTP_First_Attd__c,
                Webinar_UTP_First_Attd_Presenter__c,
                Webinar_UTP_First_Attd_Src_Other__c,
                Webinar_UTP_First_Attd_Time__c,
                Webinar_UTP_Latest_Attd_Credit__c,
                Webinar_UTP_Latest_Attd_Credit_ID__c,
                Webinar_UTP_Latest_Attd__c,
                Webinar_UTP_Latest_Attd_Duration__c,
                Webinar_UTP_Latest_Attd_Src_Other__c,
                Webinar_UTP_Latest_Attd_Time__c,
                Webinar_UTP_Latest_Missed_Date__c,
                Webinar_UTP_Latest_Missed_7Day__c,
                Webinar_UTP_NumAttended__c,
                Webinar_UTP_Total_Duration__c,
                Webinar_UTP_Second_Attd__c,
                
                Webinar_UTP_60min_Count__c,
                Webinar_UTP_60min_Date__c,
                Webinar_UTP_60min_from_First__c,
                Webinar_UTP_60min_to_Purch__c,
                Webinar_UTP_90min_Count__c,
                Webinar_UTP_90min_Date__c,
                Webinar_UTP_90min_from_First__c,
                Webinar_UTP_90min_to_Purch__c,
                Webinar_UTP_First_Attd_SendId__c,
                Webinar_UTP_Last_At_Purch__c,
                Webinar_UTP_Last_At_Purch_Credit__c,
                Webinar_UTP_Last_At_Purch_Duration__c,
                Webinar_UTP_Last_At_Purch_Presenter__c,
                Webinar_UTP_Last_At_Purch_SrcOth__c,
                Webinar_UTP_Last_At_Purch_Time__c,
                Webinar_UTP_Last_At_Purch_vs_FirstAttd__c,
                Webinar_UTP_Last_At_Purch_vs_LdCr__c,
                Webinar_UTP_Latest_Attd_SendId__c,
                                
                Webinar_Data_Last_Updated__c,
                // added for latest touch stamping
                PB_UTP_Summary_Client__c, 
                PB_Client_Ultimate_Stock_Course__c, 
                PB_Client_Ultimate_Options_Course__c, 
                PB_Client_Ultimate_Stock_Options__c,
                ContEd_Stage_Bad_Result__c,
                Latest_Touch_date__pc,
                Latest_Touch_method__pc,
                Last_Access_Date_UCS__pc,
                Last_Access_Date_Online_University__pc,
                ContEd_Prod_Purch_LATEST_date__c,
                AODchat_Latest_Visit__c,
                Opps_Count_latest_purchase__c
            FROM Account 
            WHERE Id in :acctIds 
        ]);
    }
    
    
    /**
    *
    */
    private static void getFullWebinarAttendanceMap(Set<Id> acctIds) {
        myWebinarAttendanceMap = new Map<Id, Webinar_Attendance__c>([SELECT Id, Name, Account__c, Adjusted_Duration__c, Attended__c, Credit_Name__c, Credit_User__c,
                                                                            Duration__c, Lead__c,Leave_Time__c, OnDemand_Attendance_Date__c, OnDemand_Views__c, Status__c,
                                                                            Raised_Hands__c, Registration_Date__c, Source_Other__c, Stamp_Type__c, Webinar__c,
                                                                            /*aac added new Stamp credential pulls from webinar based on webinar credential per ej */
                                                                            Webinar__r.StampType__c,
                                                                            /*end new fields*/
                                                                            Join_Time__c,
                                                                            IER_et4ae5_SendDefinition__c, IER_et4ae5_Send_Number__c
                                                                        FROM Webinar_Attendance__c 
                                                                        WHERE Account__c != null AND Account__c IN :acctIds
                                                                        ORDER BY Account__r.LastModifiedDate
                                                                        LIMIT 50000]);
    }
    
    
    /**
    *   @method:
    *   getWebinarMap
    *
    *   @description: 
    *   Accepts a list of webinar attendance records, gets webinar ids from web attnds records
    *   queries webinars from list 
    *   
    *   @param:
    *   List<Webinar_Attendance__c> webAttends
    *
    */
    private static void getWebinarMap(List<Webinar_Attendance__c> webAttends) {
        Set<Id> webinarIds = new Set<Id>();
        for (Webinar_Attendance__c wa : webAttends) {
            if (wa.Webinar__c != null) {
                webinarIds.add(wa.Webinar__c);
            }
        }
        
        myWebinarMap = new Map<Id, Webinar__c>([SELECT Id, Webinar_ID__c,  StampType__c, Event_Date_Time__c, PrimaryPresenter__c, SecondaryPresenter__c 
                                                    FROM Webinar__c 
                                                    WHERE id in :webinarIds]);
    }
    
    
    /**
    *   @method:
    *   executeStamping
    *
    *   @description: 
    *   Creates AccountStamp record,sends an error message to admins if issue with finding webinar for 
    *   webinar attnd records
    *   
    *   @param:
    *   none
    *
    */
    private static void executeStamping() {
        // reset the accounts and build the stamp wrapper map
        Map<Id, List<AccountStamp>> stampWrapperMap = new Map<Id, List<AccountStamp>>();
        for (Account account : myAccountMap.values()) {
            AccountStamper.resetAccountFields(account);
            stampWrapperMap.put(account.Id, new List<AccountStamp>());
        }
        
        AccountStamp stamp;
        String errmsg ='Missing related Webinar record:';
        Boolean webattnderr = false;
        for (Webinar_Attendance__c wa : myWebinarAttendanceMap.values()) {
            stamp = getStamp(myWebinarMap.get(wa.Webinar__c), wa);
            if (stamp != null) {
                stampWrapperMap.get(wa.Account__c).add(stamp);
            }
            else {
                webattnderr = true;
                errmsg +=' Webinar Attendance Record id: '+wa.id+'<br/>';
            }
        }
        
        if (webattnderr) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> emailstrs = new List<String>();
            List<LoggerEmailRecipients__c> emaillist = LoggerEmailRecipients__c.getAll().values();
            for (LoggerEmailRecipients__c e : emaillist) {
                if (e.Admin__c) {
                    emailstrs.add(e.Users_Email__c);    
                }
            }            
            String[] toAddresses = new String[] {'sfdev@markettraders.com',UserInfo.getUserEmail(),'processor-utp@markettraders.com'}; 
            toAddresses.addAll(emailstrs);
            mail.setToAddresses(toAddresses);
            mail.setReplyTo('sfdev@markettraders.com');
            mail.setSenderDisplayName('Account Stamper');
            mail.setSubject('Account Stamper Error: Webinar Attendance Records missing webinars');
            mail.setHtmlBody(errmsg);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        
        // at this point we need a Map of account stamp wrappers for each account
        for (Account acct : myAccountMap.values()) {
            stampWrapperMap.get(acct.Id).sort();
            // stamp total
            stampTotalData(acct.Id, stampWrapperMap.get(acct.Id));
            // stamp first last send 
            stampFirstAndLastData(acct.Id, stampWrapperMap.get(acct.Id));
            // stamp 6090 rollup
            stamp60And90MinuteData(acct.Id, stampWrapperMap.get(acct.Id));
            // stamp latest touch
            stampLatestTouch(acct.Id);
            // stamp update time
            acct.Webinar_Data_Last_Updated__c = DateTime.now();
        }
    }
    
    
    /**
    *   @method:
    *   getStamp
    *
    *   @description: 
    *   called from executestamping, fills in data for the Account stamper with the info from the 
    *   webinar and the webinar attendance record passed into the method
    *
    *   @param:
    *   Webinar__c webinar, Webinar_Attendance__c webinarAttendance
    *
    */
    private static AccountStamp getStamp(Webinar__c webinar, Webinar_Attendance__c webinarAttendance) {
        //mapping added aac 4.29.15 to address changes in webinar stamp types
        AccountStamp stamp = null;
        if (webinar != null) {
            stamp = new AccountStamp();
            Map<String,AccountStamperMapping__c> acctsToWebinarStampMap = AccountStamperMapping__c.getall();        
            stamp.webinarId = webinar.Webinar_ID__c;
            stamp.presenter = (webinar.PrimaryPresenter__c == null) ? 'Not Provided' : webinar.PrimaryPresenter__c;
            stamp.attended = webinarAttendance.Attended__c;
            String actualStamp = (acctsToWebinarStampMap.containskey(webinar.StampType__c)) ? acctsToWebinarStampMap.get(webinar.StampType__c).Corresponding_Stamp__c : webinar.StampType__c;
            /*if (webinarAttendance.Stamp_Type__c == 'OnDemand') { aac 3 19 15 changed to new stamp*/
            if (webinar.StampType__c != null && actualStamp.equals('OnDemand')) {
                stamp.attendanceDate = webinarAttendance.OnDemand_Attendance_Date__c;
            }
            else {
                if (webinar.Event_Date_Time__c != null) {
                    stamp.attendanceDate = webinar.Event_Date_Time__c.Date();
                    stamp.attendanceTime = webinar.Event_Date_Time__c.Time();
                }
            }
            
            /* stamp.stampType = webinarAttendance.Stamp_Type__c; aac changed to new field stamp type on webinar */
            
            if ((actualStamp == 'CE Classes') || (actualStamp == 'USOP Classes') || (actualStamp == 'WFEL')) {
				stamp.stampType = 'CE Classes';            	
            }
            else {
            	stamp.stampType = actualStamp;	
            }
            
            stamp.duration = (integer)webinarAttendance.Duration__c;
            stamp.sessions = (integer)webinarAttendance.OnDemand_Views__c;
            stamp.webinarSourceOther = webinarAttendance.Source_Other__c;
            stamp.joinTime = webinarAttendance.Join_Time__c;
        
            stamp.creditName = webinarAttendance.Credit_Name__c;
            String creditId = webinarAttendance.Credit_User__c;
            if (creditId != null && creditId.length() > 15) {
                stamp.creditId = creditId.substring(0,15);
            }
            else {
                stamp.creditId = creditId;
            }
            stamp.status = webinarAttendance.Status__c;
        
            System.debug('@@@ IER send number: ' + webinarAttendance.IER_et4ae5_Send_Number__c);
        
            stamp.sendNumber = webinarAttendance.IER_et4ae5_Send_Number__c;
        }    
       
         return stamp;
    }
    
    
    /**
    *   @method:
    *   resetAccountFields
    *
    *   @description: 
    *   Sets all stamper fields to null
    *   
    *   @param:
    *   Account account
    *
    */
    private static void resetAccountFields(Account account) {
        // lead created fields
        account.Lead_Created_Date_pre_Account__c = null;
        //WebinarOD UTP fields
        account.WebinarOD_UTP_First_Attd_Credit__pc = null;
        account.WebinarOD_UTP_First_Attd_Credit_ID__pc = null;
        account.WebinarOD_UTP_First_Attd_Date__pc = null;
        account.WebinarOD_UTP_First_Attd_Duration__pc = null;
        account.WebinarOD_UTP_First_Attd_Presenter__pc = null;
        account.WebinarOD_UTP_First_Attd_Src_Other__pc = null;
        account.WebinarOD_UTP_First_Attd_WebID__pc = null;
        account.WebinarOD_UTP_Latest_Attd_Date__pc = null;
        account.WebinarOD_UTP_Latest_Attd_Duration__pc = null;
        account.WebinarOD_UTP_Latest_Attd_Src_Other__pc = null;
        account.WebinarOD_UTP_Total_Duration__pc = null;
        account.WebinarOD_UTP_Total_Sessions__pc = null;
        
        //UOC Webinar Fields
        account.Webinar_UOC_First_Attd__pc = null;
        account.Webinar_UOC_First_Attd_Credit__pc = null;
        account.Webinar_UOC_First_Attd_Credit_ID__pc = null;
        account.Webinar_UOC_First_Attd_Presenter__pc = null;
        account.Webinar_UOC_First_Attd_Duration__pc = null;
        account.Webinar_UOC_First_Attd_Src_Other__pc = null;
        account.Webinar_UOC_First_Attd_Time__pc = null;
        
        account.Webinar_UOC_Second_Attd__pc = null;
        
        account.Webinar_UOC_Latest_Attd__pc = null;
        account.Webinar_UOC_Latest_Attd_Credit__pc = null;
        account.Webinar_UOC_Latest_Attd_Credit_ID__pc = null;
        account.Webinar_UOC_Latest_Attd_Presenter__pc = null;
        account.Webinar_UOC_Latest_Attd_Duration__pc = null;
        account.Webinar_UOC_Latest_Attd_Src_Other__pc = null;
        account.Webinar_UOC_Latest_Attd_Time__pc = null;
        
        // now used for USOP data (repurposed 10/5/2015)
        account.Webinar_USC_First_Attd__pc = null;
        account.Webinar_USC_First_Attd_Presenter__pc = null;
        account.Webinar_USC_First_Attd_Duration__pc = null;
        account.Webinar_USC_First_Attd_Src_Other__pc = null;
        account.Webinar_USC_First_Attd_Time__pc = null;
        account.Webinar_USC_Latest_Attd__pc = null;
        account.Webinar_USC_Latest_Attd_Presenter__pc = null;
        account.Webinar_USC_Latest_Attd_Duration__pc = null;
        account.Webinar_USC_Latest_Attd_Src_Other__pc = null;
        account.Webinar_USC_Latest_Attd_Time__pc = null;
        account.Webinar_USC_NumAttended__pc = null;
        account.Webinar_USC_Total_Duration__pc = null;
        account.Webinar_USC_Latest_Missed_Date__pc = null;

        account.Webinar_UOC_60min_Count__pc = null;
        account.Webinar_UOC_60min_Date__pc = null;
        account.Webinar_UOC_60min_from_First__pc = null;
        account.Webinar_UOC_60min_to_Purch__pc = null;
        account.Webinar_UOC_90min_Count__pc = null;
        account.Webinar_UOC_90min_Date__pc = null;
        account.Webinar_UOC_90min_from_First__pc = null;
        account.Webinar_UOC_90min_to_Purch__pc = null;
        account.Webinar_UOC_First_Attd_SendID__pc = null;
        account.Webinar_UOC_Last_At_Purch__pc = null;
        account.Webinar_UOC_Last_At_Purch_Credit__pc = null;
        account.Webinar_UOC_Last_At_Purch_Duration__pc = null;
        account.Webinar_UOC_Last_At_Purch_Presenter__pc = null;
        account.Webinar_UOC_Last_At_Purch_SrcOth__pc = null;
        account.Webinar_UOC_Last_At_Purch_Time__pc = null;
        account.Webinar_UOC_Last_At_Purch_vs_FirstAttd__pc = null;
        account.Webinar_UOC_Last_At_Purch_vs_LdCr__pc = null;
        account.Webinar_UOC_Latest_Attd_SendId__pc = null;
        
        account.Webinar_UOC_NumAttended__pc = null;
        account.Webinar_UOC_Total_Duration__pc = null;
        
        //UTP Webinar Fields
        account.Webinar_UTP_First_Attd_Credit__c = null;
        account.Webinar_UTP_First_Attd_Credit_ID__c = null;
        account.Webinar_UTP_First_Attd__c = null;
        account.Webinar_UTP_First_Attd_Presenter__c = null;
        account.Webinar_UTP_First_Attd_Duration__c = null;
        account.Webinar_UTP_First_Attd_Src_Other__c = null;
        account.Webinar_UTP_First_Attd_Time__c = null;
        
        account.Webinar_UTP_Second_Attd__c = null;
        
        account.Webinar_UTP_Latest_Attd_Credit__c = null;
        account.Webinar_UTP_Latest_Attd_Credit_ID__c = null;
        account.Webinar_UTP_Latest_Attd__c = null;
        account.Webinar_UTP_Latest_Attd_Presenter__c = null;
        account.Webinar_UTP_Latest_Attd_Duration__c = null;
        account.Webinar_UTP_Latest_Attd_Src_Other__c = null;
        account.Webinar_UTP_Latest_Attd_Time__c = null;
        
        account.Webinar_UTP_Latest_Missed_Date__c = null;
        account.Webinar_UTP_Latest_Missed_7Day__c = null;
        
        account.Webinar_UTP_NumAttended__c = null;
        account.Webinar_UTP_Total_Duration__c = null;
        
        account.Webinar_UTP_60min_Count__c = null;
        account.Webinar_UTP_60min_Date__c = null;
        account.Webinar_UTP_60min_from_First__c = null;
        account.Webinar_UTP_60min_to_Purch__c = null;
        account.Webinar_UTP_90min_Count__c = null;
        account.Webinar_UTP_90min_Date__c = null;
        account.Webinar_UTP_90min_from_First__c = null;
        account.Webinar_UTP_90min_to_Purch__c = null;
        account.Webinar_UTP_First_Attd_SendId__c = null;
        account.Webinar_UTP_Last_At_Purch__c = null;
        account.Webinar_UTP_Last_At_Purch_Credit__c = null;
        account.Webinar_UTP_Last_At_Purch_Duration__c = null;
        account.Webinar_UTP_Last_At_Purch_Presenter__c = null;
        account.Webinar_UTP_Last_At_Purch_SrcOth__c = null;
        account.Webinar_UTP_Last_At_Purch_Time__c = null;
        account.Webinar_UTP_Last_At_Purch_vs_FirstAttd__c = null;
        account.Webinar_UTP_Last_At_Purch_vs_LdCr__c = null;
        account.Webinar_UTP_Latest_Attd_SendId__c = null;
        
        /*aac 3 19 15 added fields for LMFS and Continued Ed Sales */
        account.Webinar_LMFS_First_Attd__pc   = null;                
        account.Webinar_LMFS_First_Attd_Time__pc  = null;
        account.Webinar_LMFS_First_Attd_Presenter__pc  = null;
        account.Webinar_LMFS_First_Attd_Src_Other__pc  = null;
        account.Webinar_LMFS_First_Duration__pc  = null;         
        account.Webinar_LMFS_Latest_Attd__pc  = null;
        account.Webinar_LMFS_Latest_Attd_Time__pc  = null;
        account.Webinar_LMFS_Latest_Attd_Presenter__pc  = null;
        account.Webinar_LMFS_Latest_Attd_Src_Other__pc  = null;
        account.Webinar_LMFS_Latest_Duration__pc  = null ;           
        account.Webinar_LMFS_NumAttended__pc = null;           
        account.Webinar_LMFS_First_Attd_Credit__pc = null;
        account.Webinar_LMFS_First_Attd_Credit_ID__pc = null;
        account.Webinar_LMFS_Latest_Attd_Credit__pc = null;
        account.Webinar_LMFS_Latest_Attd_Credit_ID__pc = null;    
        account.Webinar_Client_First_Attd__c  = null;
        account.Webinar_BE_First_Attd_Time__c  = null;
        account.Webinar_Client_First_Attd_Credit__c = null;
        account.Webinar_Client_First_Attd_Credit_ID__c = null;
        account.Webinar_Client_Latest_Attd_Credit__c = null;
        account.Webinar_Client_Latest_Attd_Credit_ID__c = null;
        account.Webinar_Client_First_Attd_Presenter__c  = null;
        account.Webinar_BE_First_Attd_Src_Other__c  = null;
        account.Webinar_BE_First_Duration__c  = null;               
        account.Webinar_Client_Latest_Attd__c  = null;
        account.Webinar_BE_Latest_Attd_Time__c = null;
        account.Webinar_Client_Latest_Attd_Presenter__c = null;
        account.Webinar_BE_Latest_Attd_Src_Other__c = null;
        account.Webinar_BE_Latest_Duration__c = null;
        account.Webinar_Client_NumAttended__c  = null;    
        /*aac added fields for LMFS and Continued Ed Sales */
        
        account.Last_Access_Date_Classes__pc = null;	// added for online university class processing
    }
    
    
    /* Talkpoint Stamps */
    
    /**
     *
     */
/*  private static void updateTalkpointTotalStamps(Account account, AccountStamp stamp) {
        //Update Duration
        if (account.WebinarOD_UTP_Total_Duration__pc == null) {
            account.WebinarOD_UTP_Total_Duration__pc = stamp.duration;
        }
        else {
            account.WebinarOD_UTP_Total_Duration__pc += stamp.duration;
        }
        //Update Number of attended
        if (account.WebinarOD_UTP_Total_Sessions__pc == null) {
            account.WebinarOD_UTP_Total_Sessions__pc = 1;
        }
        else {
            account.WebinarOD_UTP_Total_Sessions__pc += stamp.sessions;
        }
    }*/


    /**
     *
     */
/*    private static boolean updateTalkpointFirstStamps(Account account, AccountStamp stamp) {
        if (account.WebinarOD_UTP_First_Attd_Date__pc == null || 
            account.WebinarOD_UTP_First_Attd_Date__pc >  stamp.attendanceDate)
        {
            account.WebinarOD_UTP_First_Attd_Date__pc = stamp.attendanceDate;
            account.WebinarOD_UTP_First_Attd_Src_Other__pc = stamp.webinarSourceOther;
            account.WebinarOD_UTP_First_Attd_WebID__pc = stamp.webinarId;
            account.WebinarOD_UTP_First_Attd_Duration__pc = stamp.duration;
            account.WebinarOD_UTP_First_Attd_Presenter__pc = stamp.presenter;
            return true;
        }
        else {
            return false;
        }
    }*/
    
    
    /**
     *
     */
/*    private static boolean updateTalkpointLastStamps(Account account, AccountStamp stamp) {
        if (account.WebinarOD_UTP_Latest_Attd_Date__pc == null || 
            account.WebinarOD_UTP_Latest_Attd_Date__pc <=  stamp.attendanceDate)
        {
            account.WebinarOD_UTP_Latest_Attd_Date__pc = stamp.attendanceDate;
            account.WebinarOD_UTP_Latest_Attd_Src_Other__pc = stamp.webinarSourceOther;
            account.WebinarOD_UTP_Latest_Attd_WebID__pc = stamp.webinarId;
            account.WebinarOD_UTP_Latest_Attd_Duration__pc = stamp.duration;
            account.WebinarOD_UTP_Latest_Attd_Presenter__pc = stamp.presenter;
            return true;
        }
        else {
            return false; 
        }
    }*/
    
    
    /* UOC Stamps */
    
    /**
     *
     */
/*    private static void updateUOCTotalStamps(Account account, AccountStamp stamp) {
        //Update Duration
        if (account.Webinar_UOC_Total_Duration__pc == null) {
            account.Webinar_UOC_Total_Duration__pc = stamp.duration;
        }
        else {
            account.Webinar_UOC_Total_Duration__pc += stamp.duration;
        }
        //Update Number of attended
        if (account.Webinar_UOC_NumAttended__pc == null) {
            account.Webinar_UOC_NumAttended__pc = 1;
        }
        else {
            account.Webinar_UOC_NumAttended__pc++;
        }
    }*/


    /**
     *
     */
/*    private static boolean updateUOCFirstStamps(Account account, AccountStamp stamp) {
        if (account.Webinar_UOC_First_Attd__pc == null || 
            account.Webinar_UOC_First_Attd__pc >  stamp.attendanceDate ||
            (account.Webinar_UOC_First_Attd__pc == stamp.attendanceDate && account.Webinar_UOC_First_Attd_Time__pc > String.valueOf(stamp.attendanceTime).substring(0,5)))
        {
            if (stamp.duration == null) {
                stamp.duration = 0;
            }
            account.Webinar_UOC_First_Attd__pc = stamp.attendanceDate;
            account.Webinar_UOC_First_Attd_Credit__pc = stamp.creditName;
            account.Webinar_UOC_First_Attd_Credit_ID__pc = stamp.creditId;
            account.Webinar_UOC_First_Attd_Presenter__pc = stamp.presenter;
            account.Webinar_UOC_First_Attd_Duration__pc = stamp.duration;
            account.Webinar_UOC_First_Attd_Src_Other__pc = stamp.webinarSourceOther;
            if (stamp.attendanceTime != null) {
                account.Webinar_UOC_First_Attd_Time__pc = String.valueOf(stamp.attendanceTime).substring(0,5);
            }
            else {
                account.Webinar_UOC_First_Attd_Time__pc = null;
            }
            return true;
        }
        else {
            return false;
        }
    }*/
    
    
    /**
     *
     */
/*    private static boolean updateUOCSecondStamps(Account account, AccountStamp stamp) {
        if (account.Webinar_UOC_Second_Attd__pc == null || 
            account.Webinar_UOC_Second_Attd__pc >=  stamp.attendanceDate)
        {
            account.Webinar_UOC_Second_Attd__pc = stamp.attendanceDate;
            return true;
        }
        else {
            return false;
        }
    }*/
    
    
    /**
     *
     */
/*    private static boolean updateUOCLastMissedStamps(Account account, AccountStamp stamp) {
        system.debug('Update UOC Last Missed Stamps ' + string.valueOf(stamp.attendanceDate));
        if (account.Webinar_UOC_Latest_Missed_Date__pc == null || 
            account.Webinar_UOC_Latest_Missed_Date__pc <=  stamp.attendanceDate)
        {
            account.Webinar_UOC_Latest_Missed_Date__pc = stamp.attendanceDate;
            return true;
        }
        else {
            return false;
        }
    }*/
    
    
    /**
     *
     */
/*    private static boolean updateUOCLastStamps(Account account, AccountStamp stamp) {
        if (account.Webinar_UOC_Latest_Attd__pc == null || 
            account.Webinar_UOC_Latest_Attd__pc <=  stamp.attendanceDate ||
            (account.Webinar_UOC_Latest_Attd__pc == stamp.attendanceDate && account.Webinar_UOC_Latest_Attd_Time__pc > String.valueOf(stamp.attendanceTime).substring(0,5)))
        {
            if (stamp.duration == null) {
                stamp.duration = 0;
            }
            account.Webinar_UOC_Latest_Attd__pc = stamp.attendanceDate;
            account.Webinar_UOC_Latest_Attd_Credit__pc = stamp.creditName; 
            account.Webinar_UOC_Latest_Attd_Credit_ID__pc = stamp.creditId;
            account.Webinar_UOC_Latest_Attd_Presenter__pc = stamp.presenter;
            account.Webinar_UOC_Latest_Attd_Duration__pc = stamp.duration;
            account.Webinar_UOC_Latest_Attd_Src_Other__pc = stamp.webinarSourceOther;
            if (stamp.attendanceTime != null) {
                account.Webinar_UOC_Latest_Attd_Time__pc = String.valueOf(stamp.attendanceTime).substring(0,5);
            }
            else {
                account.Webinar_UOC_Latest_Attd_Time__pc = null;
            }
            return true;
        }
        else {
            return false;
        }
    }*/
    
    
    /* UTP Stamps */
    
    /**
     *
     */
/*    private static void updateUTPTotalStamps(Account account, AccountStamp stamp) {
        //Update Duration
        if (stamp.duration == null) {
            stamp.duration = 0;
        }
        
        if (account.Webinar_UTP_Total_Duration__c == null) {
            account.Webinar_UTP_Total_Duration__c = stamp.duration;
        }
        else {
            account.Webinar_UTP_Total_Duration__c += stamp.duration;
        }
        //Update Number of attended
        if (account.Webinar_UTP_NumAttended__c == null) {
            account.Webinar_UTP_NumAttended__c = 1;
        }
        else {
            account.Webinar_UTP_NumAttended__c++;
        }
    }*/


    /**
     *
     */
/*    private static boolean updateUTPFirstStamps(Account account, AccountStamp stamp) {
        system.debug('Update UTP First Stamps ' + string.valueOf(stamp.attendanceDate));
        if (account.Webinar_UTP_First_Attd__c == null || 
            account.Webinar_UTP_First_Attd__c >=  stamp.attendanceDate)
        {
            if (stamp.duration == null) {
                stamp.duration = 0;
            }
            account.Webinar_UTP_First_Attd__c = stamp.attendanceDate;
            account.Webinar_UTP_First_Attd_Credit__c = stamp.creditName;
            account.Webinar_UTP_First_Attd_Credit_ID__c = stamp.creditId;
            account.Webinar_UTP_First_Attd_Presenter__c = stamp.presenter;
            account.Webinar_UTP_First_Attd_Duration__c = stamp.duration;
            account.Webinar_UTP_First_Attd_Src_Other__c = stamp.webinarSourceOther;
            if (stamp.attendanceTime != null) {
                account.Webinar_UTP_First_Attd_Time__c = String.valueOf(stamp.attendanceTime).substring(0,5);
            }
            else {
                account.Webinar_UTP_First_Attd_Time__c = null;
            }
            return true;
        }
        else {
            return false;
        }
    }*/
    
    
    /**
     *
     */
/*    private static boolean updateUTPSecondStamps(Account account, AccountStamp stamp) {
        if (account.Webinar_UTP_Second_Attd__c == null || 
            account.Webinar_UTP_Second_Attd__c >=  stamp.attendanceDate)
        {
            account.Webinar_UTP_Second_Attd__c = stamp.attendanceDate;
            return true;
        }
        else {
            return false;
        }
    }*/
    
    
    /**
     *
     */
/*    private static boolean updateUTPLastMissedStamps(Account account, AccountStamp stamp) {
        if (account.Webinar_UTP_Latest_Missed_Date__c == null || 
            account.Webinar_UTP_Latest_Missed_Date__c <=  stamp.attendanceDate)
        {
            account.Webinar_UTP_Latest_Missed_Date__c = stamp.attendanceDate;
            return true;
        }
        else {
            return false;
        }
    }*/
    
    
    /**
     *
     */
/*    private static boolean updateUTPLastStamps(Account account, AccountStamp stamp) {
        if (account.Webinar_UTP_Latest_Attd__c == null || 
            account.Webinar_UTP_Latest_Attd__c <=  stamp.attendanceDate)
        {
            if (stamp.duration == null) {
                stamp.duration = 0;
            }
            account.Webinar_UTP_Latest_Attd__c = stamp.attendanceDate;
            account.Webinar_UTP_Latest_Attd_Credit__c = stamp.creditName; 
            account.Webinar_UTP_Latest_Attd_Credit_ID__c = stamp.creditId;
            account.Webinar_UTP_Latest_Attd_Presenter__c = stamp.presenter;
            account.Webinar_UTP_Latest_Attd_Duration__c = stamp.duration;
            account.Webinar_UTP_Latest_Attd_Src_Other__c = stamp.webinarSourceOther;
            if (stamp.attendanceTime != null) {
                account.Webinar_UTP_Latest_Attd_Time__c = String.valueOf(stamp.attendanceTime).substring(0,5);
            }
            else {
                account.Webinar_UTP_Latest_Attd_Time__c = null;
            }
            return true;
        }
        else {
            return false;
        }
    }*/
    
    
    /* Total Stamps */  
        
    /**
    *   @method:
    *   stampTotalData
    *
    *   @description: 
    *   Sets all fields for total durations and total attendances
    *   
    *   @param:
    *   String acctId, List<AccountStamp> stampList
    *
    */
    private static void stampTotalData(String acctId, List<AccountStamp> stampList) {
        // receives a list of wrapped account stamps for an individual account, NOT YET FILTERED COMPLETE AND ATTENDED
        List<AccountStamp> filteredList = new List<AccountStamp>();
        for (AccountStamp stmp : stampList) {
            if ((stmp.status != null) && (stmp.status.equals('Complete')) && (stmp.attended)) {
                filteredList.add(stmp);
            }
        }
        
        Account acct = myAccountMap.get(acctId);
        Integer totalOnDDemandDuration = 0;
        Integer totalOnDemandSessions = 0;
        Integer totalUOCDuration = 0;
        Integer totalUOCAttends = 0;
        Integer totalUSCDuration = 0;       // now used for USOP data (repurposed 10/5/2015)
        Integer totalUSCAttends  = 0;       // now used for USOP data (repurposed 10/5/2015)
        Integer totalUTPDuration = 0;
        Integer totalUTPAttends = 0;
        Integer totalLMFSAttends = 0;
        Integer totalBEAttends = 0;
        for (AccountStamp stamp : filteredList) {
            if (!String.isblank(stamp.stampType)) {
                if (stamp.duration != null) {
                    if (stamp.stampType.equals('OnDemand')) {
                        totalOnDDemandDuration += stamp.duration;
                    }
                    else if (stamp.stampType.equals('Ultimate Options Course')) {
                        totalUOCDuration += stamp.duration;
                    }
                    else if ((stamp.stampType.equals('Ultimate Stock Course')) || (stamp.stampType.equals('Ultimate Stock and Options Package'))) {
                        totalUSCDuration += stamp.duration;
                    }
                    else if (stamp.stampType.equals('UTP OnDemand')) {
                        totalUTPDuration += stamp.duration;
                    }
                }
            
                if (stamp.stampType.equals('OnDemand')) {
                    if (stamp.sessions != null) {
                        totalOnDemandSessions += stamp.sessions;
                    }
                }
                else if (stamp.stampType.equals('Ultimate Options Course')) {
                    totalUOCAttends += 1;
                }
                else if ((stamp.stampType.equals('Ultimate Stock Course')) || (stamp.stampType.equals('Ultimate Stock and Options Package'))) {
                    totalUSCAttends += 1;
                }
                else if (stamp.stampType.equals('UTP OnDemand')) {
                    totalUTPAttends += 1;
                }                
                else if (stamp.stampType.equals('Live Market Forex Session')) {
                        totalLMFSAttends += 1;          
                }
                else if (stamp.stampType.equals('Continued Education')) {
                    totalBEAttends += 1; //back end 
                }
            }
        }
        
        // stamp the totals on the account
        // OnDemand
        acct.WebinarOD_UTP_Total_Duration__pc = totalOnDDemandDuration;
        acct.WebinarOD_UTP_Total_Sessions__pc = totalOnDemandSessions;
        // UOC
        acct.Webinar_UOC_Total_Duration__pc = totalUOCDuration;
        acct.Webinar_UOC_NumAttended__pc = totalUOCAttends;
        // USC
        acct.Webinar_USC_Total_Duration__pc = totalUSCDuration;     // now used for USOP data (repurposed 10/5/2015)
        acct.Webinar_USC_NumAttended__pc = totalUSCAttends;         // now used for USOP data (repurposed 10/5/2015)
        // UTP
        acct.Webinar_UTP_Total_Duration__c = totalUTPDuration;
        acct.Webinar_UTP_NumAttended__c = totalUTPAttends;
        //lmfs added aac 3 19 15
        acct.Webinar_LMFS_NumAttended__pc= totalLMFSAttends;
        //be added aac 3 19 15
        acct.Webinar_Client_NumAttended__c = totalBEAttends;
    }
    
    
    /**
    *   @method:
    *   stampFirstAndLastData
    *
    *   @description: 
    *   Sets all fields for first and latest attended information
    *   
    *   @param:
    *   String acctId, List<AccountStamp> stampList
    *
    */
    private static void stampFirstAndLastData(String acctId, List<AccountStamp> stampList) {
        // receives a list of wrapped account stamps, NOT YET FILTERED COMPLETE AND ATTENDED
        List<AccountStamp> filteredOnDemandAttendedList = new List<AccountStamp>();
        List<AccountStamp> filteredUOCAttendedList = new List<AccountStamp>();
        List<AccountStamp> filteredUSCAttendedList = new List<AccountStamp>();      // now used for USOP data (repurposed 10/5/2015)
        List<AccountStamp> filteredUOCMissedList = new List<AccountStamp>();
        List<AccountStamp> filteredUSCMissedList = new List<AccountStamp>();        // now used for USOP data (repurposed 10/5/2015)
        List<AccountStamp> filteredUTPAttendedList = new List<AccountStamp>();
        List<AccountStamp> filteredUTPMissedList = new List<AccountStamp>();
        List<AccountStamp> filteredLMFSAttendedList = new List<AccountStamp>();
        List<AccountStamp> filteredBEAttendedList = new List<AccountStamp>();
        List<AccountStamp> filteredCEAttendedList = new List<AccountStamp>();
        for (AccountStamp stamp : stampList) {
          System.debug(LoggingLevel.ERROR, '@@@ Considering stamp. Webinar Id: ' + stamp.webinarId + ' Stamp type: ' + stamp.stampType);
            if ((stamp.status != null) && (stamp.status.equals('Complete')) && (!String.isblank(stamp.stampType))) {
                if (stamp.attended)  {
                    if (stamp.stampType.equals('OnDemand')) { //talkpoint
                        filteredOnDemandAttendedList.add(stamp);
                    }
                    else if (stamp.stampType.equals('Ultimate Options Course')) {
                        filteredUOCAttendedList.add(stamp);
                    }
                    else if ((stamp.stampType.equals('Ultimate Stock Course')) || (stamp.stampType.equals('Ultimate Stock and Options Package'))) {
                      System.debug(LoggingLevel.ERROR, '@@@ Adding stamp to filtered USC Attended list. Webinar Id: ' + stamp.webinarId + ' Stamp type: ' + stamp.stampType);
                        filteredUSCAttendedList.add(stamp);
                    }
                    else if (stamp.stampType.equals('UTP OnDemand')) {
                        filteredUTPAttendedList.add(stamp);
                    }/*added aac 3 19 15 */                    
                    else if (stamp.stampType.equals('Live Market Forex Session')) {
                        filteredLMFSAttendedList.add(stamp);
                    }
                     else if (stamp.stampType.equals('Continued Education')) {
                        filteredBEAttendedList.add(stamp);
                    }
                    else if (stamp.stampType.equals('CE Classes')) {
                    	filteredCEAttendedList.add(stamp);
                    }   
                    /* end updated section - only attendance needed */                                    
                }
                else {
                    if (stamp.stampType.equals('Ultimate Options Course')) {
                        filteredUOCMissedList.add(stamp);
                    }
                    else if ((stamp.stampType.equals('Ultimate Stock Course')) || (stamp.stampType.equals('Ultimate Stock and Options Package'))) {
                      System.debug(LoggingLevel.ERROR, '@@@ Adding stamp to filtered USC/USOP Missed list. Webinar Id: ' + stamp.webinarId + ' Stamp type: ' + stamp.stampType);
                        filteredUSCMissedList.add(stamp);
                    }
                    else if (stamp.stampType.equals('UTP OnDemand')) {
                        filteredUTPMissedList.add(stamp);
                    }
                }
            }
        }
        
        Account acct = myAccountMap.get(acctId);
        AccountStamp firstOnDemandStamp = null;
        AccountStamp lastOnDemandStamp = null;
        AccountStamp firstUOCStamp = null;
        AccountStamp secondUOCStamp = null;
        AccountStamp lastUOCStamp = null;
        AccountStamp firstUSCStamp = null;
        AccountStamp lastUSCStamp = null;
        AccountStamp firstUTPStamp = null;
        AccountStamp secondUTPStamp = null;
        AccountStamp lastUTPStamp = null;
        AccountStamp firstLMFSStamp = null;
        AccountStamp lastLMFSStamp = null;
        AccountStamp firstBEStamp = null;
        AccountStamp lastBEStamp = null;
        
        if (filteredOnDemandAttendedList.size() > 0) {
            // list of wrappers is now sorted earliest to latest
            firstOnDemandStamp = filteredOnDemandAttendedList[0];
            lastOnDemandStamp = filteredOnDemandAttendedList[filteredOnDemandAttendedList.size()-1];            
        }
        
        if (firstOnDemandStamp != null) {
            acct.WebinarOD_UTP_First_Attd_Date__pc = firstOnDemandStamp.attendanceDate;
            acct.WebinarOD_UTP_First_Attd_Src_Other__pc = firstOnDemandStamp.webinarSourceOther;
            acct.WebinarOD_UTP_First_Attd_WebID__pc = firstOnDemandStamp.webinarId;
            acct.WebinarOD_UTP_First_Attd_Duration__pc = (firstOnDemandStamp.duration == null)? 0 :  firstOnDemandStamp.duration;
            acct.WebinarOD_UTP_First_Attd_Presenter__pc = firstOnDemandStamp.presenter;
        }
        
        if (lastOnDemandStamp != null) {
            acct.WebinarOD_UTP_Latest_Attd_Date__pc = lastOnDemandStamp.attendanceDate;
            acct.WebinarOD_UTP_Latest_Attd_Src_Other__pc = lastOnDemandStamp.webinarSourceOther;
            acct.WebinarOD_UTP_Latest_Attd_Duration__pc = (lastOnDemandStamp.duration == null) ? 0 : lastOnDemandStamp.duration;
        }
        
        if (filteredUOCAttendedList.size() > 0) {
            // list of wrappers is now sorted earliest to latest
            firstUOCStamp = filteredUOCAttendedList[0];
                for (Integer i = 0; i < filteredUOCAttendedList.size(); i++) {
                    if (filteredUOCAttendedList[i].attendanceDate > firstUOCStamp.attendanceDate) {
                        secondUOCStamp = filteredUOCAttendedList[i];
                        continue;
                    }
                }       
            
            lastUOCStamp = filteredUOCAttendedList[filteredUOCAttendedList.size()-1];            
        }
        
        if (firstUOCStamp != null) {
            acct.Webinar_UOC_First_Attd__pc = firstUOCStamp.attendanceDate;
            acct.Webinar_UOC_First_Attd_Credit__pc = firstUOCStamp.creditName;
            acct.Webinar_UOC_First_Attd_Credit_ID__pc = firstUOCStamp.creditId;
            acct.Webinar_UOC_First_Attd_Presenter__pc = firstUOCStamp.presenter;
            acct.Webinar_UOC_First_Attd_SendId__pc = firstUOCStamp.sendNumber;
            acct.Webinar_UOC_First_Attd_Duration__pc = (firstUOCStamp.duration == null)? 0: firstUOCStamp.duration;
            acct.Webinar_UOC_First_Attd_Src_Other__pc = firstUOCStamp.webinarSourceOther;
            acct.Webinar_UOC_First_Attd_Time__pc = (firstUOCStamp.attendanceTime != null)? String.valueOf(firstUOCStamp.attendanceTime).substring(0,5): null;
        }
        
        if (lastUOCStamp != null) {
            acct.Webinar_UOC_Latest_Attd__pc = lastUOCStamp.attendanceDate;
            acct.Webinar_UOC_Latest_Attd_Credit__pc = lastUOCStamp.creditName; 
            acct.Webinar_UOC_Latest_Attd_Credit_ID__pc = lastUOCStamp.creditId;
            acct.Webinar_UOC_Latest_Attd_Presenter__pc = lastUOCStamp.presenter;
            acct.Webinar_UOC_Latest_Attd_SendId__pc = lastUOCStamp.sendNumber;
            acct.Webinar_UOC_Latest_Attd_Duration__pc = (lastUOCStamp.duration == null)? 0: lastUOCStamp.duration;
            acct.Webinar_UOC_Latest_Attd_Src_Other__pc = lastUOCStamp.webinarSourceOther;
            acct.Webinar_UOC_Latest_Attd_Time__pc = (lastUOCStamp.attendanceTime != null)? String.valueOf(lastUOCStamp.attendanceTime).substring(0,5) : null;
        }
        
        if (secondUOCStamp != null) {
            acct.Webinar_UOC_Second_Attd__pc = secondUOCStamp.attendanceDate;
        }
        

        if (filteredUSCAttendedList.size() > 0) {
            // list of wrappers is now sorted earliest to latest
            firstUSCStamp = filteredUSCAttendedList[0];
            lastUSCStamp = filteredUSCAttendedList[filteredUSCAttendedList.size()-1];            
        }

        if (firstUSCStamp != null) {
            acct.Webinar_USC_First_Attd__pc = firstUSCStamp.attendanceDate;
            //acct.Webinar_USC_First_Attd_Credit__pc = firstUSCStamp.creditName;
            //acct.Webinar_USC_First_Attd_Credit_ID__pc = firstUSCStamp.creditId;
            acct.Webinar_USC_First_Attd_Presenter__pc = firstUSCStamp.presenter;
            //acct.Webinar_USC_First_Attd_SendId__pc = firstUSCStamp.sendNumber;
            acct.Webinar_USC_First_Attd_Duration__pc = (firstUSCStamp.duration == null)? 0: firstUSCStamp.duration;
            acct.Webinar_USC_First_Attd_Src_Other__pc = firstUSCStamp.webinarSourceOther;
            acct.Webinar_USC_First_Attd_Time__pc = (firstUSCStamp.attendanceTime != null)? String.valueOf(firstUSCStamp.attendanceTime).substring(0,5): null;
        }
        
        if (lastUSCStamp != null) {
            acct.Webinar_USC_Latest_Attd__pc = lastUSCStamp.attendanceDate;
            //acct.Webinar_USC_Latest_Attd_Credit__pc = lastUSCStamp.creditName; 
            //acct.Webinar_USC_Latest_Attd_Credit_ID__pc = lastUSCStamp.creditId;
            acct.Webinar_USC_Latest_Attd_Presenter__pc = lastUSCStamp.presenter;
            //acct.Webinar_USC_Latest_Attd_SendId__pc = lastUSCStamp.sendNumber;
            acct.Webinar_USC_Latest_Attd_Duration__pc = (lastUSCStamp.duration == null)? 0: lastUSCStamp.duration;
            acct.Webinar_USC_Latest_Attd_Src_Other__pc = lastUSCStamp.webinarSourceOther;
            acct.Webinar_USC_Latest_Attd_Time__pc = (lastUSCStamp.attendanceTime != null)? String.valueOf(lastUSCStamp.attendanceTime).substring(0,5) : null;
        }
        
        if (filteredUTPAttendedList.size() > 0) {
            // list of wrappers is now sorted earliest to latest
            firstUTPStamp = filteredUTPAttendedList[0];
            for (Integer i = 0; i < filteredUTPAttendedList.size(); i++) {
                if (filteredUTPAttendedList[i].attendanceDate > firstUTPStamp.attendanceDate) {
                    secondUTPStamp = filteredUTPAttendedList[i];
                    continue;
                }
            }                
            lastUTPStamp = filteredUTPAttendedList[filteredUTPAttendedList.size()-1];
        }
        
        if (firstUTPStamp != null) {
            acct.Webinar_UTP_First_Attd__c = firstUTPStamp.attendanceDate;
            acct.Webinar_UTP_First_Attd_Credit__c = firstUTPStamp.creditName;
            acct.Webinar_UTP_First_Attd_Credit_ID__c = firstUTPStamp.creditId;
            acct.Webinar_UTP_First_Attd_Presenter__c = firstUTPStamp.presenter;
            acct.Webinar_UTP_First_Attd_SendId__c = firstUTPStamp.sendNumber;
            acct.Webinar_UTP_First_Attd_Duration__c = (firstUTPStamp.duration == null) ? 0 :firstUTPStamp.duration;
            acct.Webinar_UTP_First_Attd_Src_Other__c = firstUTPStamp.webinarSourceOther;
            acct.Webinar_UTP_First_Attd_Time__c = (firstUTPStamp.attendanceTime != null)? String.valueOf(firstUTPStamp.attendanceTime).substring(0,5): null;

        }
        
        if (lastUTPStamp != null) {
            acct.Webinar_UTP_Latest_Attd__c = lastUTPStamp.attendanceDate;
            acct.Webinar_UTP_Latest_Attd_Credit__c = lastUTPStamp.creditName; 
            acct.Webinar_UTP_Latest_Attd_Credit_ID__c = lastUTPStamp.creditId;
            acct.Webinar_UTP_Latest_Attd_Presenter__c = lastUTPStamp.presenter;
            acct.Webinar_UTP_Latest_Attd_SendId__c = lastUTPStamp.sendNumber;
            acct.Webinar_UTP_Latest_Attd_Duration__c = (lastUTPStamp.duration == null)? 0: lastUTPStamp.duration;
            acct.Webinar_UTP_Latest_Attd_Src_Other__c = lastUTPStamp.webinarSourceOther;
            acct.Webinar_UTP_Latest_Attd_Time__c = (lastUTPStamp.attendanceTime != null)? String.valueOf(lastUTPStamp.attendanceTime).substring(0,5): null;

        }
        
        if (secondUTPStamp != null) {
            acct.Webinar_UTP_Second_Attd__c = secondUTPStamp.attendanceDate;
        }
        
        if (filteredUOCMissedList.size() > 0) {
            acct.Webinar_UOC_Latest_Missed_Date__pc = filteredUOCMissedList[filteredUOCMissedList.size()-1].attendanceDate;
        }
        
        if (filteredUSCMissedList.size() > 0) {
            acct.Webinar_USC_Latest_Missed_Date__pc = filteredUSCMissedList[filteredUSCMissedList.size()-1].attendanceDate;
        }
        
        if (filteredUTPMissedList.size() > 0) {
            acct.Webinar_UTP_Latest_Missed_Date__c = filteredUTPMissedList[filteredUTPMissedList.size()-1].attendanceDate;
        }
        
        //added aac 3 19 15
        //lmfs
        if (filteredLMFSAttendedList.size() > 0) {
            // list of wrappers is now sorted earliest to latest
            firstLMFSStamp = filteredLMFSAttendedList[0];
            lastLMFSStamp = filteredLMFSAttendedList[filteredLMFSAttendedList.size()-1];            
        }
        
        if (firstLMFSStamp != null) {
            acct.Webinar_LMFS_First_Attd__pc = firstLMFSStamp.attendanceDate;
            acct.Webinar_LMFS_First_Attd_Time__pc = (firstLMFSStamp.attendanceTime != null )? String.valueOf(firstLMFSStamp.attendanceTime).substring(0,5): null;
            acct.Webinar_LMFS_First_Attd_Src_Other__pc = firstLMFSStamp.webinarSourceOther;
            acct.Webinar_LMFS_First_Duration__pc = (firstLMFSStamp.duration == null)? 0 : firstLMFSStamp.duration;
            acct.Webinar_LMFS_First_Attd_Presenter__pc = firstLMFSStamp.presenter;
            acct.Webinar_LMFS_First_Attd_Credit__pc = firstLMFSStamp.creditName; 
            acct.Webinar_LMFS_First_Attd_Credit_ID__pc = firstLMFSStamp.creditId;
        }
        
        if (lastLMFSStamp != null) {
            acct.Webinar_LMFS_Latest_Attd__pc = lastLMFSStamp.attendanceDate;
            acct.Webinar_LMFS_Latest_Attd_Time__pc = (lastLMFSStamp.attendanceTime != null)? String.valueOf(lastLMFSStamp.attendanceTime).substring(0,5): null;
            acct.Webinar_LMFS_Latest_Attd_Src_Other__pc = lastLMFSStamp.webinarSourceOther;
            acct.Webinar_LMFS_Latest_Duration__pc = (lastLMFSStamp.duration == null)? 0:  lastLMFSStamp.duration;
            acct.Webinar_LMFS_Latest_Attd_Presenter__pc = lastLMFSStamp.presenter;
            acct.Webinar_LMFS_Latest_Attd_Credit__pc = lastLMFSStamp.creditName; 
            acct.Webinar_LMFS_Latest_Attd_Credit_ID__pc = lastLMFSStamp.creditId;
        }
        
        //Continued Education
       if (filteredBEAttendedList.size() > 0) {
            // list of wrappers is now sorted earliest to latest
            firstBEStamp = filteredBEAttendedList[0];
            lastBEStamp = filteredBEAttendedList[filteredBEAttendedList.size()-1];            
        }
        
        if (firstBEStamp != null) {
            acct.Webinar_Client_First_Attd__c = firstBEStamp.attendanceDate;
            acct.Webinar_BE_First_Attd_Time__c = (firstBEStamp.attendanceTime !=  null)? String.valueOf(firstBEStamp.attendanceTime).substring(0,5): null;
            acct.Webinar_BE_First_Attd_Src_Other__c = firstBEStamp.webinarSourceOther;
            acct.Webinar_BE_First_Duration__c = (firstBEStamp.duration == null)? 0 : firstBEStamp.duration;
            acct.Webinar_Client_First_Attd_Presenter__c = firstBEStamp.presenter;
            acct.Webinar_Client_First_Attd_Credit__c= firstBEStamp.creditName; 
            acct.Webinar_Client_First_Attd_Credit_ID__c= firstBEStamp.creditId;            
        }
        
         if (lastBEStamp != null) {
            acct.Webinar_Client_Latest_Attd__c = lastBEStamp.attendanceDate;
            acct.Webinar_BE_Latest_Attd_Time__c = (lastBEStamp.attendanceTime != null)? String.valueOf(lastBEStamp.attendanceTime).substring(0,5): null;
            acct.Webinar_BE_Latest_Attd_Src_Other__c = lastBEStamp.webinarSourceOther;
            acct.Webinar_BE_Latest_Duration__c = (lastBEStamp.duration == null) ? 0: lastBEStamp.duration;
            acct.Webinar_Client_Latest_Attd_Presenter__c = lastBEStamp.presenter;
            acct.Webinar_Client_Latest_Attd_Credit__c = lastBEStamp.creditName; 
            acct.Webinar_Client_Latest_Attd_Credit_ID__c = lastBEStamp.creditId;              
        }
        //end updated section
        
        if (filteredCEAttendedList.size() > 0) {
        	acct.Last_Access_Date_Classes__pc = filteredCEAttendedList[filteredCEAttendedList.size()-1].attendanceDate;
        } 
    }
    
    
    /**
    *   @method:
    *   stamp60And90MinuteData
    *
    *   @description: 
    *   Sets all fields for 60 and 90 mins attendend
    *   
    *   @param:
    *   String acctId, List<AccountStamp> stampList
    *
    */
    private static void stamp60And90MinuteData(String acctId, List<AccountStamp> stampList) {
        // receives a list of wrapped account stamps, NOT YET FILTERED COMPLETE AND ATTENDED
        List<AccountStamp> filteredUOCList = new List<AccountStamp>();
        List<AccountStamp> filteredUTPList = new List<AccountStamp>();
        
        for (AccountStamp stamp : stampList) {
            if ((stamp.status != null) && (stamp.status.equals('Complete')) && (stamp.attended)) { 
                if (!String.isblank(stamp.stampType)) {  
                    if (stamp.stampType.equals('Ultimate Options Course')) {
                        filteredUOCList.add(stamp);
                    }
                    else if (stamp.stampType.equals('UTP OnDemand')) {
                        filteredUTPList.add(stamp);
                    }
                }  
            }
        }
        
        Account acct = myAccountMap.get(acctId);
        
        AccountStamp stampFirst = null;
        AccountStamp stamp60 = null;
        Integer stamp60Count = 0;
        AccountStamp stamp90 = null;
        Integer stamp90Count = 0;
        AccountStamp stampLastAtPurch = null;
        Integer stampCount;
        Integer aggregateDuration;
        
        // UOC
        if (filteredUOCList.size() > 0) {
            stampFirst = filteredUOCList[0];
            stampCount = 0;
            aggregateDuration = 0;
            for (AccountStamp uocStamp : filteredUOCList) {
                stampCount++;
                if (uocStamp.duration != null) {
                    aggregateDuration += uocStamp.duration;
                }
                
                if ((aggregateDuration >= 60) && (stamp60 == null)) {
                    stamp60 = uocStamp;
                    stamp60Count = stampCount;
                }
                
                if ((aggregateDuration >= 90) && (stamp90 == null)) {
                    stamp90 = uocStamp;
                    stamp90Count = stampCount;
                }
                
                if ((acct.PB_WonRegardless_Ultimate_Options_Course__c != null) && (uocStamp.attendanceDate < acct.PB_WonRegardless_Ultimate_Options_Course__c)) {
                    stampLastAtPurch = uocStamp;
                }
            }
            
            // stamp some fields
            if (stamp60 != null) {
                acct.Webinar_UOC_60min_Date__pc = stamp60.attendanceDate;
                acct.Webinar_UOC_60min_Count__pc = stamp60Count;
                if ((stampFirst != null) && (stampFirst.attendanceDate != null) && (stamp60.attendanceDate != null)) {
                    acct.Webinar_UOC_60min_from_First__pc = stampFirst.attendanceDate.daysBetween(stamp60.attendanceDate);  // # of days between first attend date and 60 min date
                }
                
                if ((stamp60.attendanceDate != null) && (acct.PB_WonRegardless_Ultimate_Options_Course__c != null)) {
                    acct.Webinar_UOC_60min_to_Purch__pc = stamp60.attendanceDate.daysBetween(acct.PB_WonRegardless_Ultimate_Options_Course__c);    // # of days between purchase date and 60 min date
                }
            }
            
            if (stamp90 != null) {
                acct.Webinar_UOC_90min_Date__pc = stamp90.attendanceDate;
                acct.Webinar_UOC_90min_Count__pc = stamp90Count;
                if ((stampFirst != null) && (stampFirst.attendanceDate != null) && (stamp90.attendanceDate != null)) {
                    acct.Webinar_UOC_90min_from_First__pc = stampFirst.attendanceDate.daysBetween(stamp90.attendanceDate);  // # of days between first attend date and 90 min date
                }
                
                if ((stamp90.attendanceDate != null) && (acct.PB_WonRegardless_Ultimate_Options_Course__c != null)) {
                    acct.Webinar_UOC_90min_to_Purch__pc = stamp90.attendanceDate.daysBetween(acct.PB_WonRegardless_Ultimate_Options_Course__c); // # of days between purchase date and 90 min date
                }
            }
            
            if (stampLastAtPurch != null) {
                acct.Webinar_UOC_Last_At_Purch__pc = stampLastAtPurch.attendanceDate;
                
                if ((acct.Lead_Created_Date_pre_Account__c != null) && (stampLastAtPurch.attendanceDate != null)) {
                    acct.Webinar_UOC_Last_At_Purch_vs_LdCr__pc = acct.Lead_Created_Date_pre_Account__c.daysBetween(stampLastAtPurch.attendanceDate);
                }
                
                if ((stampFirst.attendanceDate != null) && (stampLastAtPurch.attendanceDate != null)) {
                    acct.Webinar_UOC_Last_At_Purch_vs_FirstAttd__pc = stampFirst.attendanceDate.daysBetween(stampLastAtPurch.attendanceDate);
                }
                
                if (stampLastAtPurch.attendanceTime != null) {
                    acct.Webinar_UOC_Last_At_Purch_Time__pc = String.valueOf(stampLastAtPurch.attendanceTime).substring(0,5);
                }
                
                acct.Webinar_UOC_Last_At_Purch_Presenter__pc = stampLastAtPurch.presenter;
                acct.Webinar_UOC_Last_At_Purch_Credit__pc = stampLastAtPurch.creditId;
                acct.Webinar_UOC_Last_At_Purch_SrcOth__pc = stampLastAtPurch.webinarSourceOther;
                
                if (stampLastAtPurch.duration == null) {
                    stampLastAtPurch.duration = 0;
                }
                acct.Webinar_UOC_Last_At_Purch_Duration__pc = stampLastAtPurch.duration;
            }
        }
        
        // reset for UTP
        stamp60 = null;
        stamp60Count = 0;
        stamp90 = null;
        stamp90Count = 0;
        stampLastAtPurch = null;
        
        // UTP
        if (filteredUTPList.size() > 0) {
            stampFirst = filteredUTPList[0];
            stampCount = 0;
            aggregateDuration = 0;
            for (AccountStamp utpStamp : filteredUTPList) {
                stampCount++;
                if (utpStamp.duration != null) {
                    aggregateDuration += utpStamp.duration;
                }
                
                
                if ((aggregateDuration >= 60) && (stamp60 == null)) {
                    stamp60 = utpStamp;
                    stamp60Count = stampCount;
                }
                
                if ((aggregateDuration >= 90) && (stamp90 == null)) {
                    stamp90 = utpStamp;
                    stamp90Count = stampCount;
                }
                
                if ((acct.PB_UTP_Summary_CWON_REGARDLESS__c != null) && (utpStamp.attendanceDate < acct.PB_UTP_Summary_CWON_REGARDLESS__c)) {
                    stampLastAtPurch = utpStamp;
                }
            }
            
            // stamp some fields
            if (stamp60 != null) {
                acct.Webinar_UTP_60min_Date__c = stamp60.attendanceDate;
                acct.Webinar_UTP_60min_Count__c = stamp60Count;
                if ((stampFirst != null) && (stampFirst.attendanceDate != null) && (stamp60.attendanceDate != null)) {
                    acct.Webinar_UTP_60min_from_First__c = stampFirst.attendanceDate.daysBetween(stamp60.attendanceDate);  // # of days between first attend date and 60 min date
                }
                
                if ((stamp60.attendanceDate != null) && (acct.PB_UTP_Summary_CWON_REGARDLESS__c != null)) {
                    acct.Webinar_UTP_60min_to_Purch__c = stamp60.attendanceDate.daysBetween(acct.PB_UTP_Summary_CWON_REGARDLESS__c);    // # of days between purchase date and 60 min date
                }
            }
            
            if (stamp90 != null) {
                acct.Webinar_UTP_90min_Date__c = stamp90.attendanceDate;
                acct.Webinar_UTP_90min_Count__c = stamp90Count;
                if ((stampFirst != null) && (stampFirst.attendanceDate != null) && (stamp90.attendanceDate != null)) {
                    acct.Webinar_UTP_90min_from_First__c = stampFirst.attendanceDate.daysBetween(stamp90.attendanceDate);  // # of days between first attend date and 90 min date
                }
                
                if ((stamp90.attendanceDate != null) && (acct.PB_UTP_Summary_CWON_REGARDLESS__c != null)) {
                    acct.Webinar_UTP_90min_to_Purch__c = stamp90.attendanceDate.daysBetween(acct.PB_UTP_Summary_CWON_REGARDLESS__c);    // # of days between purchase date and 90 min date
                }
            }
            
            if (stampLastAtPurch != null) {
                acct.Webinar_UTP_Last_At_Purch__c = stampLastAtPurch.attendanceDate;
                if ((acct.Lead_Created_Date_pre_Account__c != null) && (stampLastAtPurch.attendanceDate != null)) {
                    acct.Webinar_UTP_Last_At_Purch_vs_LdCr__c = acct.Lead_Created_Date_pre_Account__c.daysBetween(stampLastAtPurch.attendanceDate);
                }
                
                if ((stampFirst.attendanceDate != null) && (stampLastAtPurch.attendanceDate != null)) {
                    acct.Webinar_UTP_Last_At_Purch_vs_FirstAttd__c = stampFirst.attendanceDate.daysBetween(stampLastAtPurch.attendanceDate);
                }
                
                if (stampLastAtPurch.attendanceTime != null) {
                    acct.Webinar_UTP_Last_At_Purch_Time__c = String.valueOf(stampLastAtPurch.attendanceTime).substring(0,5);
                }
                
                acct.Webinar_UTP_Last_At_Purch_Presenter__c = stampLastAtPurch.presenter;
                acct.Webinar_UTP_Last_At_Purch_Credit__c = stampLastAtPurch.creditId;
                acct.Webinar_UTP_Last_At_Purch_SrcOth__c = stampLastAtPurch.webinarSourceOther;
                
                if (stampLastAtPurch.duration == null) {
                    stampLastAtPurch.duration = 0;
                }               
                
                acct.Webinar_UTP_Last_At_Purch_Duration__c = stampLastAtPurch.duration;
            }
        }
    }
    
    private static void stampLatestTouch(String acctId) {
    	Account acct = myAccountMap.get(acctId);
    	
    	if (((acct.PB_UTP_Summary_Client__c == 'Purchased') || (acct.PB_Client_Ultimate_Stock_Course__c) || (acct.PB_Client_Ultimate_Options_Course__c) || (acct.PB_Client_Ultimate_Stock_Options__c)) && (String.isBlank(acct.ContEd_Stage_Bad_Result__c))) {
            TouchWrapper touch = latestTouchInPeriod(acct);
            String touchMethod = '';
            Date touchDate = null;
            if ((touch != null) && (touch.touchDate != null) && (touch.touchField != null)) {
                if (touch.touchField.equals(BE_WEBINAR)) {
                    touchMethod = 'Back End Webinar Attendance';
                }
                else if (touch.touchField.equals(ONLINE_UNIV)) {
                    touchMethod = 'Online University Access';
                }
                else if (touch.touchField.equals(CLASS_WEBINAR)) {
                    touchMethod = 'Webinar Class Attendance';
                }
                else if (touch.touchField.equals(CE_PURCHASE)) {
                    touchMethod = 'Continuing Education Product Purchase';                      
                }
                else if (touch.touchField.equals(UCS_ACCESS)) {
                    touchMethod = 'UCS Access';
                }
                else if (touch.touchField.equals(AOD_VISIT)) {
                  touchMethod = 'AOD Visit';
                }
            
                acct.Latest_Touch_method__pc = touchMethod;
                acct.Latest_Touch_date__pc = touch.touchDate;
            }
        }
    }
    
    
    private static TouchWrapper latestTouchInPeriod(Account acct) {
        List<TouchWrapper> touchWraps = new List<TouchWrapper>();
        
        System.debug('@@@@ last UCS access date: ' + acct.Last_Access_Date_UCS__pc);
        if ((acct.Last_Access_Date_UCS__pc != null) && (acct.Last_Access_Date_UCS__pc > Date.today().addDays(TOUCH_PERIOD))) {
            touchWraps.add(new TouchWrapper(UCS_ACCESS, acct.Last_Access_Date_UCS__pc));
        }
        
        System.debug('@@@@ webinar client latest attended date: ' + acct.Webinar_Client_Latest_Attd__c);
        if ((acct.Webinar_Client_Latest_Attd__c != null) && (acct.Webinar_Client_Latest_Attd__c > Date.today().addDays(TOUCH_PERIOD))) {
            touchWraps.add(new TouchWrapper(BE_WEBINAR, acct.Webinar_Client_Latest_Attd__c));
        }
        
        System.debug('@@@@ online university last access date: ' + acct.Last_Access_Date_Online_University__pc);
        if ((acct.Last_Access_Date_Online_University__pc != null) && (acct.Last_Access_Date_Online_University__pc > Date.today().addDays(TOUCH_PERIOD))) {
            touchWraps.add(new TouchWrapper(ONLINE_UNIV, acct.Last_Access_Date_Online_University__pc));
        }
        
        System.debug('@@@@ classes last access date: ' + acct.Last_Access_Date_Classes__pc);
        if ((acct.Last_Access_Date_Classes__pc != null) && (acct.Last_Access_Date_Classes__pc > Date.today().addDays(TOUCH_PERIOD))) {
            touchWraps.add(new TouchWrapper(CLASS_WEBINAR, acct.Last_Access_Date_Classes__pc));
        }
        
        System.debug('@@@@ opps count latest conted purchase latest date: ' + acct.ContEd_Prod_Purch_LATEST_date__c);
        if ((acct.Opps_Count_latest_purchase__c != null) && (acct.Opps_Count_latest_purchase__c > Date.today().addDays(TOUCH_PERIOD))) {
            touchWraps.add(new TouchWrapper(CE_PURCHASE, acct.Opps_Count_latest_purchase__c));
        }
        
        System.debug('@@@@ opps count latest AOD visit date: ' + acct.AODchat_Latest_Visit__c);
        if ((acct.AODchat_Latest_Visit__c != null) && (acct.AODchat_Latest_Visit__c > Date.today().addDays(TOUCH_PERIOD))) {
            touchWraps.add(new TouchWrapper(AOD_VISIT, acct.AODchat_Latest_Visit__c.date())); 
        }
        
        touchWraps.sort();
        
        for (TouchWrapper tw : touchWraps) {
            System.debug('@@@@ touch field: ' + tw.touchField);
            System.debug('@@@@ touch date: ' + tw.touchDate);
        }
        
        if (touchWraps.size() > 0) {
            return (touchWraps[0]);
        }
        else {
            return null;
        }
    }
    
    
    
    
    
    public class TouchWrapper implements Comparable {
        
        public String touchField {get; set;}
        public Date touchDate {get; set;}
        
        public TouchWrapper() {
        }
        
        
        public TouchWrapper(String tchField, Date tchDate) {
            touchField = tchField;
            touchDate = tchDate;
        }
        
        
        public Integer compareTo(Object compareTo) {
            TouchWrapper compareToWrap = (TouchWrapper) compareTo;
            if (touchDate == compareToWrap.touchDate) {
                return 0;
            }
            
            if (touchDate < compareToWrap.touchDate) {
                return 1;
            }
            
            return -1;
        }
    }
}