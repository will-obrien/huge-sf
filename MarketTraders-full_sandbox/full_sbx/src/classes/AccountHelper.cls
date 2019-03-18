public without sharing class AccountHelper {
    
    public static final String BE_WEBINAR = 'Webinar_Client_Latest_Attd__c';
    public static final String ONLINE_UNIV = 'Last_Access_Date_Online_University__pc';
    public static final String CLASS_WEBINAR = 'Last_Access_Date_Classes__pc';
    public static final String CE_PURCHASE = 'ContEd_Prod_Purch_LATEST_date__c';
    public static final String UCS_ACCESS = 'Last_Access_Date_UCS__pc';
    public static final String AOD_VISIT = 'AODchat_Latest_Visit__c';
    public static final Integer TOUCH_PERIOD = -60;  // using negative for last N days
    
    
    public static void updateLatestTouch(Map<Id, Account> newAcctMap, Map<Id, Account> oldAcctMap) {
        System.debug('@@@@ updating latest touch (in method)...');
        for (Account newAcct : newAcctMap.values()) {
            //Account oldAcct = oldAcctMap.get(newAcct.Id);
            
            //if ((criteriaChanged(newAcct, oldAcct)) && ((newAcct.pb_Client_UTP_OnDemand__c) || (newAcct.PB_Client_Ultimate_Stock_Course__c) || (newAcct.PB_Client_Ultimate_Options_Course__c) || (newAcct.PB_Client_Ultimate_Stock_Options__c)) && (String.isBlank(newAcct.ContEd_Stage_Bad_Result__c))) {
            if (((newAcct.PB_UTP_Summary_Client__c == 'Purchased') || (newAcct.PB_Client_Ultimate_Stock_Course__c) || (newAcct.PB_Client_Ultimate_Options_Course__c) || (newAcct.PB_Client_Ultimate_Stock_Options__c)) && (String.isBlank(newAcct.ContEd_Stage_Bad_Result__c))) {
                TouchWrapper touch = latestTouchInPeriod(newAcct);
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
                
                    newAcct.Latest_Touch_method__pc = touchMethod;
                    newAcct.Latest_Touch_date__pc = touch.touchDate;
                }
            }
        }
    }
    
    
/*    private static Boolean criteriaChanged(Account newAcct, Account oldAcct) {
        
        System.debug('@@@@ Latest_Touch_date__pc NEW: ' + newAcct.Latest_Touch_date__pc);
        System.debug('@@@@ Latest_Touch_method__pc NEW: ' + newAcct.Latest_Touch_method__pc);
        System.debug('@@@@ ContEd_Stage_Bad_Result__c OLD: ' + oldAcct.ContEd_Stage_Bad_Result__c);
        System.debug('@@@@ ContEd_Stage_Bad_Result__c NEW: ' + newAcct.ContEd_Stage_Bad_Result__c);
        System.debug('@@@@ pb_SubCurrent_Charting__c OLD: ' + oldAcct.pb_SubCurrent_Charting__c);
        System.debug('@@@@ pb_SubCurrent_Charting__c NEW: ' + newAcct.pb_SubCurrent_Charting__c);
        System.debug('@@@@ PB_SubEnd_UCSForex__c OLD: ' + oldAcct.PB_SubEnd_UCSForex__c);
        System.debug('@@@@ PB_SubEnd_UCSForex__c NEW: ' + newAcct.PB_SubEnd_UCSForex__c);
        System.debug('@@@@ PB_SubEnd_UCSStocks__c OLD: ' + oldAcct.PB_SubEnd_UCSStocks__c);
        System.debug('@@@@ PB_SubEnd_UCSStocks__c NEW: ' + newAcct.PB_SubEnd_UCSStocks__c);
        System.debug('@@@@ PB_Client_Ultimate_Options_Course__c OLD: ' + oldAcct.PB_Client_Ultimate_Options_Course__c);
        System.debug('@@@@ PB_Client_Ultimate_Options_Course__c NEW: ' + newAcct.PB_Client_Ultimate_Options_Course__c);
        System.debug('@@@@ PB_Client_Ultimate_Stock_Course__c OLD: ' + oldAcct.PB_Client_Ultimate_Stock_Course__c);
        System.debug('@@@@ PB_Client_Ultimate_Stock_Course__c NEW: ' + newAcct.PB_Client_Ultimate_Stock_Course__c);
        System.debug('@@@@ PB_Client_Ultimate_Stock_Options__c OLD: ' + oldAcct.PB_Client_Ultimate_Stock_Options__c);
        System.debug('@@@@ PB_Client_Ultimate_Stock_Options__c NEW: ' + newAcct.PB_Client_Ultimate_Stock_Options__c);
        System.debug('@@@@ pb_Client_UTP_OnDemand__c OLD: ' + oldAcct.pb_Client_UTP_OnDemand__c);
        System.debug('@@@@ pb_Client_UTP_OnDemand__c NEW: ' + newAcct.pb_Client_UTP_OnDemand__c);
        System.debug('@@@@ Webinar_Client_Latest_Attd__c OLD: ' + oldAcct.Webinar_Client_Latest_Attd__c);
        System.debug('@@@@ Webinar_Client_Latest_Attd__c NEW: ' + newAcct.Webinar_Client_Latest_Attd__c);
        System.debug('@@@@ Last_Access_Date_Online_University__pc OLD: ' + oldAcct.Last_Access_Date_Online_University__pc);
        System.debug('@@@@ Last_Access_Date_Online_University__pc NEW: ' + newAcct.Last_Access_Date_Online_University__pc);
        System.debug('@@@@ Last_Access_Date_Classes__pc OLD: ' + oldAcct.Last_Access_Date_Classes__pc);
        System.debug('@@@@ Last_Access_Date_Classes__pc NEW: ' + newAcct.Last_Access_Date_Classes__pc);
        System.debug('@@@@ Last_Access_Date_UCS__pc OLD: ' + oldAcct.Last_Access_Date_UCS__pc);
        System.debug('@@@@ Last_Access_Date_UCS__pc NEW: ' + newAcct.Last_Access_Date_UCS__pc);
        System.debug('@@@@ Opps_Count_latest_purchase__c OLD: ' + oldAcct.Opps_Count_latest_purchase__c);
        System.debug('@@@@ Opps_Count_latest_purchase__c NEW: ' + newAcct.Opps_Count_latest_purchase__c);
        System.debug('@@@@ AODchat_Latest_Visit__c OLD: ' + oldAcct.AODchat_Latest_Visit__c);
        System.debug('@@@@ AODchat_Latest_Visit__c NEW: ' + newAcct.AODchat_Latest_Visit__c);
        
        if ((newAcct.Latest_Touch_date__pc == null && newAcct.Latest_Touch_method__pc == null) ||
            (newAcct.ContEd_Stage_Bad_Result__c != oldAcct.ContEd_Stage_Bad_Result__c) ||
            (newAcct.pb_SubCurrent_Charting__c != oldAcct.pb_SubCurrent_Charting__c) ||
            (newAcct.PB_SubEnd_UCSForex__c != oldAcct.PB_SubEnd_UCSForex__c) ||
            (newAcct.PB_SubEnd_UCSStocks__c != oldAcct.PB_SubEnd_UCSStocks__c) ||
            (newAcct.PB_Client_Ultimate_Options_Course__c != oldAcct.PB_Client_Ultimate_Options_Course__c) ||
            (newAcct.PB_Client_Ultimate_Stock_Course__c != oldAcct.PB_Client_Ultimate_Stock_Course__c) ||
            (newAcct.PB_Client_Ultimate_Stock_Options__c != oldAcct.PB_Client_Ultimate_Stock_Options__c) ||
            (newAcct.pb_Client_UTP_OnDemand__c != oldAcct.pb_Client_UTP_OnDemand__c) ||
            (newAcct.Webinar_Client_Latest_Attd__c != oldAcct.Webinar_Client_Latest_Attd__c) ||
            (newAcct.Last_Access_Date_Online_University__pc != oldAcct.Last_Access_Date_Online_University__pc) ||
            (newAcct.Last_Access_Date_Classes__pc != oldAcct.Last_Access_Date_Classes__pc) ||
            (newAcct.Last_Access_Date_UCS__pc != oldAcct.Last_Access_Date_UCS__pc) ||
            (newAcct.Opps_Count_latest_purchase__c != oldAcct.Opps_Count_latest_purchase__c) || 
            (newAcct.AODchat_Latest_Visit__c != oldAcct.AODchat_Latest_Visit__c))
        {
            return true;
        }
        else {
            return false;
        }
    }
*/
    
    private static Boolean isActiveUCS(Account acct) {
        if (((acct.pb_SubCurrent_Charting__c == 'Yes') ||
            (acct.PB_SubEnd_UCSForex__c > Date.today()) ||
            (acct.PB_SubEnd_UCSStocks__c > Date.today())) &&
            ((acct.PB_Client_Ultimate_Options_Course__c) ||
            (acct.PB_Client_Ultimate_Stock_Course__c) ||
            (acct.PB_Client_Ultimate_Stock_Options__c) ||
            (acct.pb_Client_UTP_OnDemand__c)))
        {
            return true;
        }
        else {
            return false;
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