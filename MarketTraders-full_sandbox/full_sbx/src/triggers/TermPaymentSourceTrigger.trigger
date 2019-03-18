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
*   Date Created:       4/1/2016
*   Author:             Parvez Bandeali
*   Last Modified:      4/5/2016
*   Last Modified By:   Sean Murphy
*
*   4/1/16   - pb: class created
*	4/4/16   - pb: initial development completed
*	4/5/16   - sm: code cleanup
*   
**********************************************************************************************************************/

trigger TermPaymentSourceTrigger on Term_Payment_Source__c (after delete, after insert, after undelete,
                                                                after update, before delete, before insert, before update) {
	if (trigger.isBefore) {
  		if (trigger.isInsert) {
        	TermPaymentSourceHelper.getLastFourDigit(trigger.New);         
        }
      
        if (trigger.isUpdate) {
      	  TermPaymentSourceHelper.managePrimaryPaymentSource(trigger.new, trigger.oldMap, trigger.isUpdate, trigger.isInsert, trigger.isAfter, trigger.isBefore);  
        }    
    }
  
  	if (trigger.isAfter) {
    	if (trigger.isInsert) {
        	TermPaymentSourceHelper.managePrimaryPaymentSource(trigger.new, trigger.oldMap, trigger.isUpdate, trigger.isInsert, trigger.isAfter, trigger.isBefore);               
        }
    }    
}