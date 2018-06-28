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
*   Date Created:       11/13/2015
*   Author:             Sean Murphy
*   Last Modified:      11/13/2015
*   Last Modified By:   Sean Murphy
*
*   11/13/2015 - Trigger created
*   
**********************************************************************************************************************/

trigger PaymentActivityTrigger on Payment_Activity__c (before insert, before update, before delete, 
                                                        after insert, after update, after delete, after undelete) { 
                                                            
    if (trigger.isBefore) {
    }
    else {
        if (trigger.isInsert) {
            // calculate rollup values
            PaymentActivityHelper.calcStreaks(trigger.new);
            // calculate cash
            PaymentActivityHelper.aggTotal(trigger.new);
            PaymentActivityHelper.createCashReceipt(trigger.new);
        }
        else if (trigger.isUpdate) {
            // calculate rollup values
            PaymentActivityHelper.calcStreaks(trigger.new);
            // calculate cash
            PaymentActivityHelper.aggTotal(trigger.new);
        }
    }                                                    
}