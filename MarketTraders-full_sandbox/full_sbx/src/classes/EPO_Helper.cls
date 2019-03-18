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
*   9/30/15 - Coding completed
*	1/13/16 - msm: modified to use Payment Tracking System objects instead of Opportunity Line Item Schedules 
*   
**********************************************************************************************************************/

public without sharing class EPO_Helper {
  	
  	public static Case rollUpEPOValues(Opportunity opp, Case epoCase, List<Payment_Terms__c> oppTerms, Map<Id, Payment_Terms__c> activeTermsMap, Map<Id, Payment_Activity__c> pmtActToOppMap) {
        // fields from opp
        epoCase.Opportunity_Amount_Paid_calc_2__c = opp.Total_Amount_Paid__c;
        
        epoCase.Number_of_Payments_Remaining__c = opp.Number_of_Payments_Remaining__c;
    
    	// fiels from terms
    	Payment_Terms__c activeTerms = null;
		if (activeTermsMap.containsKey(opp.Id)) {
			activeTerms = activeTermsMap.get(opp.Id);
		}
		
		if (activeTerms != null) {
			epoCase.Next_Payment_Date__c = activeTerms.Next_Due__c;
			epoCase.Discount_Amount_Scheduled__c = activeTerms.Discount__c;
			if ((activeTerms.Total_Scheduled_Payments__c != null) && (activeTerms.Discount__c != null)) {
				epoCase.Liability_Balance_Remaining__c = activeTerms.Total_Scheduled_Payments__c + activeTerms.Discount__c;
			}
			else {
				epoCase.Liability_Balance_Remaining__c = null;
			}
        }
        else {
        	epoCase.Next_Payment_Date__c = null;
        	epoCase.Discount_Amount_Scheduled__c = null;
        	epoCase.Liability_Balance_Remaining__c = null;
        }
        
        // fields from payment activities
       	epoCase.Last_Payment_Amount__c = pmtActToOppMap.containsKey(opp.Id) ? pmtActToOppMap.get(opp.Id).Amount__c : null;
        epoCase.Last_Payment_Date__c = pmtActToOppMap.containsKey(opp.Id) ? pmtActToOppMap.get(opp.Id).Date__c.date() : null;
    
    	return epoCase;
  	}
}