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
*   Date Created:       8/23/2015
*   Author:             Sean Murphy
*   Last Modified:      8/23/2015
*   Last Modified By:   Sean Murphy
*
*   8/23/2015 - Create class to support counting dials following the InsideSales installation
*   
**********************************************************************************************************************/

public without sharing class TaskHandlerHelper {
    
    public static final Decimal CALL_COUNT_LIMIT = 25.0;


    /**
     *  constructor
     */
    public TaskHandlerHelper() {
    }
    
    
    /**********************
     @method: incrementDialCounter
     @description: 
      - for any inside sales dialer tasks, increment the dial counter on the related opportunity up to a set limit
     
     @params: 
     newTasks = map of new tasks being inserted, typically the newMap from the calling trigger
        
    **********/
    public static void incrementDialCounter(Map<Id, Task> newTasks) {
        
        Set<Task> oppTaskSet = new Set<Task>();
        Set<Id> oppIds = new Set<Id>();
        // collect tasks that are related to Opportunities only
        for (Task tsk : newTasks.values()) {
            if ((tsk.WhatId != null) && (String.valueOf(tsk.WhatId).startsWith('006')) && (tsk.CallType != null) && (tsk.CallType.toLowerCase().equals('outbound'))) {
                oppTaskSet.add(tsk);
                oppIds.add(tsk.WhatId);
            }
        }
        
        // collect opps
        Map<Id, Opportunity> taskOppsMap = new Map<Id, Opportunity>([SELECT Id, Dial_Counter__c FROM Opportunity WHERE Id in :oppIds AND isClosed = false]);
        for (Task t : oppTaskSet) {
            if (taskOppsMap.containsKey(t.WhatId)) {
                Opportunity opp = taskOppsMap.get(t.WhatId);
                if ((opp.Dial_Counter__c == null) || (opp.Dial_Counter__c < 0)) {
                    opp.Dial_Counter__c = 0;
                }
                
                if (opp.Dial_Counter__c < CALL_COUNT_LIMIT) {
                    opp.Dial_Counter__c = opp.Dial_Counter__c + 1;
                } 
            }
        }
        
        if (taskOppsMap.size() > 0) {
            update taskOppsMap.values();
        }
    }
}