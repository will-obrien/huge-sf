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
*   Date Created:       6/11/2015
*   Author:             Sean Murphy
*   Last Modified:      7/3/2015
*   Last Modified By:   Sean Murphy
*
*   7/3/2015 - modified to make the number of records configurable using custom setting   
*   
**********************************************************************************************************************/

/********************************
*
* @description: used to schedule the cron job to manage deletion of IER records.
* 
**/
global without sharing class Scheduled_IER_Management implements Schedulable {
    
    // inner class for exception handling
    global class ScheduledIERMgmtException extends Exception{}
    
    
    /**************************************
    *
    * @description:
    * execute - Schedulable interface method
    *  
    * @params: 
    * ctx - SchedulableContext (provided by Salesforce system)
    *
    **/
    global void execute(SchedulableContext ctx) {
        Decimal days = 30.0;
        Decimal period = 180.0;
        Decimal recordCount = 100000;
        
        Map<String, IERMgmtConfig__c> ierConfigMap = IERMgmtConfig__c.getAll();
        List<IERMgmtConfig__c> ierConfigs = ierConfigMap.values();
        if (ierConfigs.size() == 1) {
            // get the values necessary (days to keep, period interval, and record count)
            days = ierConfigs[0].Days_To_Keep__c;
            period = ierConfigs[0].Period_in_minutes__c;
            recordCount = ierConfigs[0].Record_Count__c;    
        }
        else {
            // handle exception
            throw new ScheduledIERMgmtException('Error occurred. ' + ierConfigs.size() + ' instances of the IER Management Configuration exist.  There should only be a single instance.  Please notify the MTI Salesforce Dev Team.');
        }
        
        Date cutoffDate = Date.today();
        cutoffDate = cutoffDate.addDays(-30);
        String queryDate = String.valueOf(cutoffDate); 
        queryDate = queryDate.substringBefore(' ');
        queryDate = queryDate + 'T00:00:00Z';
        String userQuery ='SELECT Id FROM et4ae5__IndividualEmailResult__c WHERE CreatedDate < ' + queryDate;
        userQuery += ' ORDER BY CreatedDate ASC';
        if (Test.isRunningTest())
        {
            userQuery += ' LIMIT 1';
        }
        else {
            userQuery += (' LIMIT ' + String.valueOf(Integer.valueOf(recordCount)));
        }            
        System.debug('@@@ userQuery -> ' + userQuery);

        Database.executebatch(new Batch_IER_Management(userQuery), 2000);
        
        Datetime nextDateTime = System.now();
        nextDateTime = nextDateTime.addMinutes(Integer.valueOf(period));
        String chron_exp = '' + nextDateTime.second() + ' ' + nextDateTime.minute() + ' ' + nextDateTime.hour() + ' ' + nextDateTime.day() + ' ' + nextDateTime.month() + ' ? ' + nextDateTime.year();
        System.debug(chron_exp);
        Scheduled_IER_Management IERScheduler = new Scheduled_IER_Management();
        System.schedule('IER Management Scheduler' + System.now(), chron_exp, IERScheduler);

        Id cronTrigId = ctx.getTriggerId();
        System.abortJob(cronTrigId);
    }
}