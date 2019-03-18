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
*   Date Created:       9/23/2015
*   Author:             Sean Murphy
*   Last Modified:      1/13/2016
*   Last Modified By:   Sean Murphy
*
*   9/23/15 - Class created
*	1/13/16 - msm: modified to use Payment Tracking System objects instead of Opportunity Line Item Schedules
*   
**********************************************************************************************************************/

public without sharing class Batch_EPO_Update implements Database.Batchable<sObject> {  

    public final String query {get; set;}
    
    public class BatchEPOUpdateException extends Exception {}
    
    
    /********************************
    *
    *   constructor
    *
    *   @description: creates instance of the class and sets up query for batch execution
    * 
    **/
    public Batch_EPO_Update() {
      	if (Test.isRunningTest())
      	{
        	query = 'SELECT Id, AccountId, Total_Amount_Paid__c, Remaining_Balance__c, Number_of_Payments_Remaining__c FROM Opportunity WHERE Sub_Stage__c = \'Payment Plan\' LIMIT 5';
      	}
      	else {
          	query = 'SELECT Id, AccountId, Total_Amount_Paid__c, Remaining_Balance__c, Number_of_Payments_Remaining__c FROM Opportunity WHERE Sub_Stage__c = \'Payment Plan\'';
      	}
    }


    // batchable interface methods
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    
    public void execute(Database.BatchableContext BC, List<Opportunity> scope) {
        Set<Id> oppIds = new Set<Id>();
        Set<Id> acctIds = new Set<Id>();
        Set<Id> caseIds = new Set<Id>();
        
        try {
            for (Opportunity opp : scope) {
                oppIds.add(opp.Id);
            }

			// get the terms for the opps
			Map<Id, Payment_Terms__c> termsList = new Map<Id, Payment_Terms__c>([SELECT Id, Name, Active__c, Amount_of_Next_Payment__c, Next_Due__c, Discount__c, Opportunity__c, 
																							Payment_Terms_Type__c, Sales_Price__c, Total_Scheduled_Payments__c
																					FROM Payment_Terms__c
																					WHERE Opportunity__c in :oppIds]);
													
			Map<Id, Payment_Activity__c> pmtActivityMap = new Map<Id, Payment_Activity__c>([SELECT Id, Name, Amount__c, Date__c 
																								FROM Payment_Activity__c 
																								WHERE Payment_Status__c = 'Paid' 
																								AND Outcome__c = 'Approved'
																								AND Payment_Terms__c in :termsList.keySet()
																								ORDER BY Date__c DESC LIMIT 1]);
													
			// map all terms and active terms to opp
			Map<Id, Payment_Terms__c> activeTermToOppMap = new Map<Id, Payment_Terms__c>();
			Map<Id, List<Payment_Terms__c>> termToOppMap = new Map<Id, List<Payment_Terms__c>>();
			Map<Id, Payment_Activity__c> pmtActToOppMap = new Map<Id, Payment_Activity__c>(); 
													
			Set<Id> termIds = new Set<Id>();
			List<Payment_Terms__c> newTerms;
			for (Payment_Terms__c pt : termsList.values()) {
				termIds.add(pt.Id);
				if (termToOppMap.containsKey(pt.Opportunity__c)) {
					termToOppMap.get(pt.Opportunity__c).add(pt);
				}
				else {
					newTerms = new List<Payment_Terms__c>();
					newTerms.add(pt);
					termToOppMap.put(pt.Opportunity__c, newTerms);
				}
				
				if ((!activeTermToOppMap.containsKey(pt.Opportunity__c)) && (pt.Active__c)) {
					activeTermToOppMap.put(pt.Opportunity__c, pt);
				}
				
				for (Payment_Activity__c pa : pmtActivityMap.values()) {
					if (!pmtActToOppMap.containsKey(pt.Opportunity__c)) {
						pmtActToOppMap.put(pt.Opportunity__c, pa);
					}
				}
			}
			
			List<RecordType> receivableRecordType = [SELECT Id, Name FROM RecordType WHERE Name = 'Receivable' LIMIT 1];
			Map<Id, Case> caseMap = new Map<Id, Case>();
			
			if (receivableRecordType.size() > 0) {
	            // query the cases
    	        caseMap = new Map<Id, Case>([SELECT Id, Opportunity_Link__c, Opportunity_Amount_Paid_calc_2__c, Discount_Amount_Scheduled__c,
        	    	           						Last_Payment_Amount__c, Last_Payment_Date__c, Next_Payment_Date__c, Number_of_Payments_Remaining__c,
            	               						Liability_Balance_Remaining__c, Opportunity_Amount_Sale_Price__c
                       							FROM Case 
                       							WHERE Opportunity_Link__c IN :oppIds
                       							AND Type = 'EPO'
                      							AND RecordTypeId IN :receivableRecordType]);
			}
			else {
				throw new BatchEPOUpdateException('No Receivable record type.  Contact the MTI Salesforce development team.');
			}
                              								
            // map the case by Opportunity_Link__c
            Map<String, Case> oppCaseMap = new Map<String, Case>();
            for (Case c : caseMap.values()) {
              	if (!oppCaseMap.containsKey(c.Opportunity_Link__c)) {
                	oppCaseMap.put(c.Opportunity_Link__c, c);
              	}
            }
            
            // process the schedules
      		List<Payment_Terms__c> terms;
      		Case epoCase;
      		List<Case> updateCases = new List<Case>();
            
            for (Opportunity op : scope) {
              	// get the terms
              	terms = null;
              	// get the payments
              	
              	// get the case
              	epoCase = null;
              	if (oppCaseMap.containsKey(op.Id)) {
              		epoCase = oppCaseMap.get(op.Id);
              	}
              	
              	// do calcs for amount paid
              	if ((epoCase != null) && (activeTermToOppMap.size() > 0) && (pmtActToOppMap.size() > 0)) {
              		System.debug('@@@ processing a case...');
              		if (termToOppMap.containsKey(op.Id)) {
                		epoCase = EPO_Helper.rollUpEPOValues(op, epoCase, termToOppMap.get(op.Id), activeTermToOppMap, pmtActToOppMap);
              		}
              		
                	// add case to update list
                	updateCases.add(epoCase);
              	}
            }
            
            if (updateCases.size() > 0) {
              	update updateCases;
            }
        }
        catch (Exception ex) {
            throw new BatchEPOUpdateException(ex.getMessage() + ' Stack: ' + ex.getStackTraceString());
        }
    }

    
    public void finish(Database.BatchableContext BC) {
    }
}