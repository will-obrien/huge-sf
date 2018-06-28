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
*   Date Created:       4/4/2016
*   Author:             Parvez Bandeali
*   Last Modified:      4/5/2016
*   Last Modified By:   Sean Murphy
*
*   4/4/16   - pb: created class
*   4/5/16   - sm: code cleanup and comments
*   
**********************************************************************************************************************/

public without sharing class RecursionManager {
    private static Boolean run = true;
    
    
    /**************************************
    *
    *   @description:
    *   runOnce - flip flag to control recursion
    *  
    **/
    public static Boolean runOnce() {
    
        if (run) {
             run = false;
             return true;
        }
        else {
            return run;
        }
    }
}