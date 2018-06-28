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
global class Batch_Account_Balance_History_Weekly implements Database.Batchable<sObject>, Database.Stateful{    

    global Database.QueryLocator start(Database.BatchableContext BC){                            
        return Database.getQueryLocator([select id, name, Remaining_Balance__c, AccountId, Sub_Stage__c from opportunity where AccountId != null AND Remaining_Balance__c > 0 ]);
    }

    global void execute(Database.BatchableContext BC,List<opportunity> scope){
        
        if (!scope.isEmpty())
            {
                List<Account_Bal_History__c> accbalhist = new List<Account_Bal_History__c>(); 
                set<Id> oppidlist = new set<Id>();
       
        for(Opportunity opp : scope)
            {
                oppidlist.add(opp.id);
            }
               
                 list<Account_Bal_History__c> accbalhismap = new list<Account_Bal_History__c>([select Account__c, Current_total_remaining_balance__c, Opportunity__c from Account_Bal_History__c where Opportunity__c IN : oppidlist AND Recorded_time_period__c = 'Weekly' ORDER BY CreatedDate DESC limit 1]);
        
        for (Opportunity opp : scope){
                Account_Bal_History__c abh = new Account_Bal_History__c();        
                abh.Account__c = opp.AccountId;
                abh.Current_total_remaining_balance__c = opp.Remaining_Balance__c; 
                abh.Opportunity_Sub_Stage__c = opp.Sub_Stage__c;
                abh.Opportunity__c=opp.Id;
                    if (accbalhismap.size() == 1)
                        {
                            abh.Previous_total_remaining_balance__c = accbalhismap[0].Current_total_remaining_balance__c;
                        }
                    else
                        {
                            abh.Previous_total_remaining_balance__c = 0;
                        }
                abh.Recorded_Date__c = system.now();
                abh.Recorded_time_period__c = 'Weekly';
                accbalhist.add(abh);            
            }
                if(accbalhist.size() > 0)
                    {
                        insert accbalhist;
                    }
        system.debug('*****accbalhist.size()****'+accbalhist.size());
        } 
   }
        
    global void finish(Database.BatchableContext BC){

    }
  
}