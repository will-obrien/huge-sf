/**********************************************************************************************************************
*   Market Traders Institute, Inc.    CONFIDENTIAL
* ---------------------------------------------------------------------------------------------------------------------
*   [2016] Market Traders Institute
*   All Rights Reserved
*
*   NOTICE:  All information contained herein is, and remains the property of Market Traders Institute, Inc. and its
*   suppliers, if any.  The intellectual and technical concepts contained herein are proprietary to Market Traders 
*   Institute, Inc. and its suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are 
*   protected by trade secret or copyright law.  Dissemination of this information or reproduction of this material
*   is strictly forbidden unless prior written permission is obtained from Market Traders Institute, Inc.
*
*   Date Created:       04/11/2016
*   Author:             Parvez
*   Last Modified:      
*   Last Modified By:   
*
*   
*   
**********************************************************************************************************************/
global class Schedulable_AccountBalanceHistory implements Schedulable {
      global void execute(SchedulableContext SC) {
         Database.executeBatch(new Batch_Account_Balance_History_Weekly(),1);
  }
}