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
*   Last Modified:      6/24/2015
*   Last Modified By:   Asha Calderon
*
*   
*   
**********************************************************************************************************************/
/********************************
OpportunityTrigger 
@description: 
directs any Opportunity trigger functionality to the TriggerDispatcher class 
**/
trigger OpportunityTrigger on Opportunity(after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
  
  try{
        
      TriggerDispatcher.callHandler('Opportunity', 
          trigger.isBefore, trigger.isAfter, trigger.isInsert, trigger.isUpdate, 
          trigger.isDelete, trigger.isUndelete, trigger.isExecuting, trigger.new, 
          trigger.newMap, trigger.old, trigger.oldMap);
        
  }catch(Exception ex){
    Logger logger = new Logger('Opportunity Trigger');
    logger.log(ex.getMessage());
    logger.log(ex.getStackTraceString());
    logger.emailDebugResults(new list<String>{'sfdev@markettraders.com'});
    system.debug(ex);
  }
}