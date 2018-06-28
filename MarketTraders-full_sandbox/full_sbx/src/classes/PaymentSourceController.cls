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
*   Date Created:       3/29/2015
*   Author:             Sean Murphy
*   Last Modified:      4/3/2015
*   Last Modified By:   Sean Murphy
*
*   3/29/16 - sm: class created
*   3/30/16 - sm: development completed
*   4/3/16  - sm: code cleanup and comments
*   
**********************************************************************************************************************/

/*****************************************************************
*
*	This class is used to display payment sources in a visual force page that is embedded in the opp detail page
*
*****************************************************************/
public without sharing class PaymentSourceController {
	
	// inner exception class
	public class PaymentSourceControllerException extends Exception {}
	
	private ApexPages.StandardController stdCont {get; set;}
    private Opportunity opp {get; private set;}
	private List<Payment_Source__c> pmtSources;
	public List<PmtSourceWrapper> pmtSourceWraps {get; private set;}
	public PmtSourceWrapper primarySourceWrap {get; private set;}
	
	
	/********************************
    *
    *   constructor
    *
    *   @description: creates instance of the class
    * 
    **/
	public PaymentSourceController(ApexPages.StandardController sc) {
		this.stdCont = sc;
		if (!Test.isRunningTest()) {
			List<String> fieldNames = new List<String> {'AccountId'};
			this.stdCont.addFields(fieldNames);
        	this.opp = (Opportunity)stdCont.getRecord();
		}
		else {
			Id oppId = ((Opportunity)stdCont.getRecord()).Id;
			this.opp = [SELECT Id, AccountId FROM Opportunity WHERE Id = :oppId];
		}
        
        pmtSourceWraps = new List<PmtSourceWrapper>();
        PmtSourceWrapper newWrap;
        if (opp.AccountId != null) {
            for (Payment_Source__c ps : [SELECT Id, Credit_Card_Number__c, Credit_Card_Type__c, Credit_Card_Exp_Date__c, Primary__c FROM Payment_Source__c WHERE Account__c = :opp.AccountId]) {
                newWrap = new PmtSourceWrapper(ps);
                pmtSourceWraps.add(newWrap);
                if (ps.Primary__c) {
                    primarySourceWrap = newWrap;
                }
            }
        }
	}
	
	
	/**************************************
    *
    *   @description:
    *   getSourceWraps - return list of wrapped payment sources
    *  
    **/
	public List<PmtSourceWrapper> getSourceWraps() {
		List<PmtSourceWrapper> theList = new List<PmtSourceWrapper>();
		if (primarySourceWrap != null) {
			theList.add(primarySourceWrap);
		}
		
		for (PmtSourceWrapper psw : pmtSourceWraps) {
			if (!psw.isPrimary) {
				theList.add(psw);
			}
		}
		
		return theList;
	}
	
	
	//============================================================================================================================
    //      WRAPPER CLASS
    //============================================================================================================================
    
    
	/******************************************
    *
    *   @description: wrapper class for payment sources
    *
    ******************************************/
    public class PmtSourceWrapper {
		public Payment_Source__c paymentSource {get; private set;}
		public Boolean isPrimary {get; private set;}
		public String name {get; private set;}
		
		public PmtSourceWrapper(Payment_Source__c pmtSrc) {
			paymentSource = pmtSrc;
			isPrimary = pmtSrc.Primary__c;
			name = paymentSource.Credit_Card_Type__c + ' - ' + getLast4();
        	if (isPrimary) {
        		name += ' (primary)';
        	}
		}
		
		public String getLast4() {
            if (!String.isBlank(paymentSource.Credit_Card_Number__c)) {
                String last4 = paymentSource.Credit_Card_Number__c.right(4);
                return last4;
            }
            else {
                return 'none';
            }
        }
        
        public String getName() {
        	String retVal = '';
        	retVal = paymentSource.Credit_Card_Type__c + ' - ' + getLast4();
        	if (isPrimary) {
        		retVal += ' (primary)';
        	}
        	
        	return retVal;
        }
	}
}