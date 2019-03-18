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
*   Last Modified:      6/23/2015
*   Last Modified By:   Sean Murphy
*
*   
*   
**********************************************************************************************************************/

/********************************
*
* @description: used to batch execute the deletion of IER records.
* 
**/
global without sharing class Batch_IER_Management implements Database.Batchable<sObject> {

	global final string query;

	/**************************************
    *
    * @description:
    * constructor
    *  
    * @params: 
    * q - batch query string for individual email response object records
    *
    **/	
	global Batch_IER_Management (String q) {
        query = q;
    }
    
    
    /**************************************
    *
    * @description:
    * start - Batchable interface method
    *  
    * @params: 
    * BC - BatchableContext (provided by Salesforce system)
    *
    **/
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }
    
    
    /**************************************
    *
    * @description:
    * execute - Batchable interface method
    *  
    * @params: 
    * BC - BatchableContext (provided by Salesforce system)
    * scope - sObject records returned from batch query (batch size applied)
    *
    **/
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
    	// use the records returned to delete the IER records
    	List<et4ae5__IndividualEmailResult__c> delRecords = new List<et4ae5__IndividualEmailResult__c>();
    	for (sObject ier : scope) {
    		et4ae5__IndividualEmailResult__c delRec = (et4ae5__IndividualEmailResult__c)ier;
    		delRecords.Add(delRec);
    	}
    	delete delRecords;
    }
    
    
    /**************************************
    *
    * @description:
    * finish - Batchable interface method
    *  
    **/
    global void finish(Database.BatchableContext BC) {
    	
    }
}