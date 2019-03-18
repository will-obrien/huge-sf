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
*   Date Created:       10/28/2015
*   Author:             Sean Murphy
*   Last Modified:      11/11/2015
*   Last Modified By:   Sean Murphy
*
*   11/11/15 sm - add comments
*   
**********************************************************************************************************************/

/*=====================================================================================================================
*
*	To launch this scheduled class enter the following into the execute anonymous window of the salesforce developer
*	console:
*		DateTime startTime = DateTime.newInstance(Date.today(), Time.newInstance(hr, min, sec, millisec);
*		String chron_exp = 'sec min hr dy mo ? yr';  // where sec = second, min = minutes, dy = day of month, etc. THIS SHOULD MATCH THE START TIME IN THE PREVIOUS LINE
*		Schedule_EPO_Update epoScheduler = new Schedule_EPO_Update__c();
*		System.schedule('EPO Data Updater - ' + startTime, chron_exp, epoScheduler);
*
*		Example:
*		This is the code to start the scheduler at 12 noon on November 20, 2015 (this being today)
*
*		DateTime startTime = DateTime.newInstance(Date.today(), Time.newInstance(12, 0, 0, 0);
*		String chron_exp = '0 0 12 20 11 ? 2015';
*		Schedule_EPO_Update epoScheduler = new Schedule_EPO_Update();
*		System.schedule('EPO Data Updater - ' + startTime, chron_exp, epoScheduler);
*
=====================================================================================================================*/


public without sharing class Schedule_EPO_Update implements Schedulable {
	 
	// schedulabe interface method(s)
	public void execute(SchedulableContext sc) {
		// schedule initial batch
		Database.executebatch(new Batch_EPO_Update());
		
		// schedule another
		Date currentDate = Date.today();
    	Time startTime = Time.newInstance(8, 0, 0, 0);
    	Time endTime = Time.newInstance(17, 0, 0, 0);
    	DateTime startPeriod = DateTime.newInstance(currentDate, startTime);
    	DateTime endPeriod = DateTime.newInstance(currentDate, endTime);
    	
		Datetime sysTime = DateTime.now();
        if ((DateTime.now() >= startPeriod) && (DateTime.now() <= endPeriod)) {
        	sysTime = sysTime.addHours(2);
        }
        else {
        	Date nextDay;
        	if (Test.isRunningTest()) {
        		nextDay = Date.today().addDays(2);
        	}
        	else {
        		nextDay = Date.today().addDays(1);
        	}
        	Time nextStart = Time.newInstance(8, 0, 0, 0);
        	sysTime = DateTime.newInstance(nextDay, nextStart);
        }
        
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        Schedule_EPO_Update epoScheduler = new Schedule_EPO_Update();
        System.schedule('EPO Data Updater - ' + sysTime, chron_exp, epoScheduler);

        Id cronTrigId = sc.getTriggerId();
        System.abortJob(cronTrigId);
	}
}