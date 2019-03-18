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
*   Date Created:       12/29/2015
*   Author:             Coastal Cloud (outsourced)
*   Last Modified:      4/4/2016
*   Last Modified By:   Sean Murphy
*
*   12/29/15 - coastal cloud: class created
*   4/3/16   - sm: merchant integration development completed
*   4/4/16   - sm: code cleanup
*   
**********************************************************************************************************************/

public without sharing class TermPaymentSourceHelper {
    
    
    /**************************************
    *
    *   @description:
    *   getLastFourDigit - set last 4 digits of credit card from payment source on term payment source
    *  
    **/
    public static void getLastFourDigit(List<Term_Payment_Source__c> tpsRecords) {
        if (!tpsRecords.isEmpty()) {
            Set<Id> psid = new Set<Id>();
                            
            for(Term_Payment_Source__c tps : tpsrecords) {
                psid.add(tps.Payment_Source__c);     
            }
    
            Map<Id, Payment_Source__c> psMap = new Map<Id, Payment_Source__c>([SELECT Id, Credit_Card_Number__c FROM Payment_Source__c WHERE Id IN :psid]);
            
            for(Term_Payment_Source__c tps : tpsRecords) {
                tps.CC_Last_4_Digits__c = psMap.get(tps.Payment_Source__c).Credit_Card_Number__c.right(4);
            }    
        }        
    }
    
    
    /**************************************
    *
    *   @description:
    *   managePrimaryPaymentSource - ensure only 1 term payment source can be primary for a given payment term record
    *  
    **/ 
    public static void managePrimaryPaymentSource(List<Term_Payment_Source__c> tpsNewList, Map<Id, Term_Payment_Source__c> tpsOldMap, Boolean isUpdate, Boolean isInsert, Boolean isAfter, Boolean isBefore ) {
                
        if (isAfter && isInsert) {
            Map<Id, Term_Payment_Source__c> tpsUpd = new Map<Id, Term_Payment_Source__c>();
            Set<Id> termIds = new Set<Id>(); 
                
            for (Term_Payment_Source__c t : tpsNewList) {
                termIds.add(t.Terms__c);
            }
            
            System.debug('@@@: all Terms ids' + termIds + termIds.size());
        
            List<Term_Payment_Source__c> tpsList = new List<Term_Payment_Source__c>([SELECT Id, Name, Primary__c, Terms__c FROM Term_Payment_Source__c WHERE Terms__c IN :termIds]);
        
            system.debug('@@@: all Term Payment Soures' + tpsList + tpsList.size());
        
            for (Term_Payment_Source__c tps1 : tpsNewList) {   
                if (tps1.Primary__c == true) {
                    for (Term_Payment_Source__c tps2 : tpsList) {
                        if ((tps1.Id != tps2.Id) && (tps1.Terms__c == tps2.Terms__c)) {
                            if (!tpsUpd.containsKey(tps1.Id)) {
                                tps2.Primary__c = false;
                                tpsUpd.put(tps2.Id, tps2);     
                            }
                        }
                    }
                    
                    update tpsUpd.values(); 
                }
            }
        }
        
        if (isBefore && isUpdate) {
            if(RecursionManager.runOnce()) {
                Set<Id> termIds = new Set<Id>(); 
                Map<Id, Term_Payment_Source__c> tpsUpdMap = new Map<Id, Term_Payment_Source__c>();
                
                for (Term_Payment_Source__c t : tpsNewList) {
                    termIds.add(t.Terms__c);
                }

                System.debug('@@@: set of Terms ids' + termIds + termIds.size());           
                List<Term_Payment_Source__c> tpsList = new List<Term_Payment_Source__c>([SELECT Id, Name, Primary__c, Terms__c FROM Term_Payment_Source__c WHERE Terms__c IN :termids]);
                System.debug('@@@: list of all the Terms'+ tpslist + tpslist.size());
                
                for (Term_Payment_Source__c tps3 : tpsNewList) {
                    if ((tps3.Primary__c == false) && (tpsOldMap.get(tps3.Id).Primary__c == true)) {
                        Boolean flag = false;

                        for (Term_Payment_Source__c tps4 : tpsList) {
                            if ((tps3.Id != tps4.id) && (tps4.Primary__c == true)) {
                                System.debug('@@@: inside inner loop');
                                flag = true;
                            }
                        }

                        if (flag == false) {
                            System.debug('@@@: about to throw an error');
                            tps3.addError('There must be at least one Term Payment Source as Primary');
                        }   
                    }
                    
                    if ((tps3.Primary__c == true) && (tpsOldMap.get(tps3.Id).Primary__c == false)) {
                        for (Term_Payment_Source__c tps5 : tpsList) {
                            system.debug('@@@ tpslist values@' + tpsList );

                            if ((tps3.Id != tps5.Id) && (tps3.Terms__c == tps5.Terms__c)) {
                                if (!tpsUpdMap.containsKey(tps5.Id)) {
                                    tps5.Primary__c = false;
                                    tpsUpdMap.put(tps5.Id, tps5);     
                                }
                            }
                        }
                                 
                        update tpsUpdMap.values(); 
                    } 
                } 
            }  
        }        
    }
}