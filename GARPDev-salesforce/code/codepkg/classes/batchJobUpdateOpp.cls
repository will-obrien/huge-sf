global class batchJobUpdateOpp implements Database.Batchable<sObject>,Database.StateFul{
    
    public String mode;  
    global batchJobUpdateOpp (String mode){
        this.mode = mode;
    }
     
   global Database.QueryLocator start(Database.BatchableContext BC){  
       String strId = '0064000000dRTyi';
           //return Database.getQueryLocator('select Id, Name, AccountId, Amount, Purchase_Date__c, Last_Batch_Update__c, FRM_1_Registration_Fee__c, FRM_2_Registration_Fee__c, ERP_Registration_Fee__c, EA_Id__c,  Undefred_EA_Id__c, FRM_I_Registration__c, FRM_II_Registration__c, ERP_Registration__c, Deferred_Exam_Registration__c, (SELECT Quantity, ListPrice, TotalPrice, PriceBookEntry.UnitPrice, PricebookEntry.Name, PricebookEntry.Product2.ProductCode, PricebookEntry.Product2.Product_ID__c FROM OpportunityLineItems) from Opportunity where Id = :strId order by Purchase_Date__c');
           //return Database.getQueryLocator('select Id, Name, AccountId, Amount, StageName, Purchase_Date__c, Last_Batch_Update__c, FRM_1_Registration_Fee__c, FRM_2_Registration_Fee__c, ERP_Registration_Fee__c, EA_Id__c,  Undefred_EA_Id__c, FRM_I_Registration__c, FRM_II_Registration__c, ERP_Registration__c, Deferred_Exam_Registration__c, (SELECT Quantity, ListPrice, TotalPrice, PriceBookEntry.UnitPrice, PricebookEntry.Name, PricebookEntry.Product2.ProductCode, PricebookEntry.Product2.Product_ID__c FROM OpportunityLineItems) from Opportunity where Purchase_Date__c > 2014-05-15 and Purchase_Date__c < 2014-12-31 and amount = 100 order by Purchase_Date__c');
       
       if(mode=='defer')
           return Database.getQueryLocator('select Id, Name, AccountId, Amount, StageName, Purchase_Date__c, Last_Batch_Update__c, FRM_1_Registration_Fee__c, FRM_2_Registration_Fee__c, ERP_Registration_Fee__c, EA_Id__c,  Undefred_EA_Id__c, FRM_I_Registration__c, FRM_II_Registration__c, ERP_Registration__c, Deferred_Exam_Registration__c, (SELECT Quantity, ListPrice, TotalPrice, PriceBookEntry.UnitPrice, PricebookEntry.Name, PricebookEntry.Product2.ProductCode, PricebookEntry.Product2.Product_ID__c FROM OpportunityLineItems) from Opportunity where Last_Batch_Update__c != today and amount = 100 order by Purchase_Date__c');
       else if(mode=='2014')
           return Database.getQueryLocator('select Id, Name, AccountId, Amount, StageName, Purchase_Date__c, Last_Batch_Update__c, FRM_1_Registration_Fee__c, FRM_2_Registration_Fee__c, ERP_Registration_Fee__c, EA_Id__c,  Undefred_EA_Id__c, FRM_I_Registration__c, FRM_II_Registration__c, ERP_Registration__c, Deferred_Exam_Registration__c, (SELECT Quantity, ListPrice, TotalPrice, PriceBookEntry.UnitPrice, PricebookEntry.Name, PricebookEntry.Product2.ProductCode, PricebookEntry.Product2.Product_ID__c FROM OpportunityLineItems) from Opportunity where Last_Batch_Update__c != today and amount = 100 and Purchase_Date__c >= 2014-01-01 and Purchase_Date__c <= 2014-12-31 order by Purchase_Date__c');
       else if(mode=='2013')
           return Database.getQueryLocator('select Id, Name, AccountId, Amount, StageName, Purchase_Date__c, Last_Batch_Update__c, FRM_1_Registration_Fee__c, FRM_2_Registration_Fee__c, ERP_Registration_Fee__c, EA_Id__c,  Undefred_EA_Id__c, FRM_I_Registration__c, FRM_II_Registration__c, ERP_Registration__c, Deferred_Exam_Registration__c, (SELECT Quantity, ListPrice, TotalPrice, PriceBookEntry.UnitPrice, PricebookEntry.Name, PricebookEntry.Product2.ProductCode, PricebookEntry.Product2.Product_ID__c FROM OpportunityLineItems) from Opportunity where Last_Batch_Update__c != today and amount = 100 and Purchase_Date__c >= 2013-01-01 and Purchase_Date__c <= 2013-12-31 order by Purchase_Date__c');
       else if(mode=='2012')
           return Database.getQueryLocator('select Id, Name, AccountId, Amount, StageName, Purchase_Date__c, Last_Batch_Update__c, FRM_1_Registration_Fee__c, FRM_2_Registration_Fee__c, ERP_Registration_Fee__c, EA_Id__c,  Undefred_EA_Id__c, FRM_I_Registration__c, FRM_II_Registration__c, ERP_Registration__c, Deferred_Exam_Registration__c, (SELECT Quantity, ListPrice, TotalPrice, PriceBookEntry.UnitPrice, PricebookEntry.Name, PricebookEntry.Product2.ProductCode, PricebookEntry.Product2.Product_ID__c FROM OpportunityLineItems) from Opportunity where Last_Batch_Update__c != today and amount = 100 and Purchase_Date__c >= 2012-01-01 and Purchase_Date__c <= 2012-12-31 order by Purchase_Date__c');
       else if(mode=='2011')
           return Database.getQueryLocator('select Id, Name, AccountId, Amount, StageName, Purchase_Date__c, Last_Batch_Update__c, FRM_1_Registration_Fee__c, FRM_2_Registration_Fee__c, ERP_Registration_Fee__c, EA_Id__c,  Undefred_EA_Id__c, FRM_I_Registration__c, FRM_II_Registration__c, ERP_Registration__c, Deferred_Exam_Registration__c, (SELECT Quantity, ListPrice, TotalPrice, PriceBookEntry.UnitPrice, PricebookEntry.Name, PricebookEntry.Product2.ProductCode, PricebookEntry.Product2.Product_ID__c FROM OpportunityLineItems) from Opportunity where Last_Batch_Update__c != today and amount = 100 and Purchase_Date__c >= 2011-01-01 and Purchase_Date__c <= 2011-12-31 order by Purchase_Date__c');
       else if(mode=='2010')
           return Database.getQueryLocator('select Id, Name, AccountId, Amount, StageName, Purchase_Date__c, Last_Batch_Update__c, FRM_1_Registration_Fee__c, FRM_2_Registration_Fee__c, ERP_Registration_Fee__c, EA_Id__c,  Undefred_EA_Id__c, FRM_I_Registration__c, FRM_II_Registration__c, ERP_Registration__c, Deferred_Exam_Registration__c, (SELECT Quantity, ListPrice, TotalPrice, PriceBookEntry.UnitPrice, PricebookEntry.Name, PricebookEntry.Product2.ProductCode, PricebookEntry.Product2.Product_ID__c FROM OpportunityLineItems) from Opportunity where Last_Batch_Update__c != today and amount = 100 and Purchase_Date__c >= 2010-01-01 and Purchase_Date__c <= 2010-12-31 order by Purchase_Date__c');
       else return Database.getQueryLocator('select Id, Name, AccountId, Amount, StageName, Purchase_Date__c, Last_Batch_Update__c, FRM_1_Registration_Fee__c, FRM_2_Registration_Fee__c, ERP_Registration_Fee__c, EA_Id__c,  Undefred_EA_Id__c, FRM_I_Registration__c, FRM_II_Registration__c, ERP_Registration__c, Deferred_Exam_Registration__c, (SELECT Quantity, ListPrice, TotalPrice, PriceBookEntry.UnitPrice, PricebookEntry.Name, PricebookEntry.Product2.ProductCode, PricebookEntry.Product2.Product_ID__c FROM OpportunityLineItems) from Opportunity where Last_Batch_Update__c != today order by Purchase_Date__c');
   }

   global void execute(Database.BatchableContext BC, List<Opportunity> scope){

        MAP<Id, Exam_Attempt__c> currEAMap = new MAP<Id, Exam_Attempt__c>();        
        MAP<Id, List<Exam_Attempt__c>> currContMap = new MAP<Id, List<Exam_Attempt__c>>();        
        MAP<Id, Integer> mapDefCount = new MAP<Id, Integer>();
       
        List<Exam_Attempt__c> lstExamAttempt = [SELECT Id, Name, Opportunity__c, Exam_Date__c, Defered__c, Member__c, Candidate_Commitment__r.AccountId from Exam_Attempt__c where Opportunity__c in :scope order by Exam_Date__c];
        for(Exam_Attempt__c ea: lstExamAttempt) {
            currEAMap.put(ea.Opportunity__c, ea);
        }

       List<Id> acctIds = new List<Id>();
       for(Opportunity opp :scope) {
           acctIds.add(opp.AccountId);
       }
        List<Exam_Attempt__c> lstAllExamAttempt = [SELECT Id, Name, Opportunity__c, Exam_Date__c, Defered__c, Member__c, Candidate_Commitment__r.AccountId from Exam_Attempt__c where Candidate_Commitment__r.AccountId in :acctIds order by Exam_Date__c];
        for(Exam_Attempt__c ea: lstAllExamAttempt) {
            List<Exam_Attempt__c> eal = currContMap.get(ea.Candidate_Commitment__r.AccountId);
            if(eal == null) {
                eal = new List<Exam_Attempt__c>();
                eal.add(ea);
                currContMap.put(ea.Candidate_Commitment__r.AccountId, eal);            
            } else {
                eal.add(ea);
                currContMap.put(ea.Candidate_Commitment__r.AccountId, eal);            
            }
        }
       
       List<Opportunity> lstUpdateOpp = new List<Opportunity>();
       for(Opportunity opp :scope) {
           
           system.debug('opp:' + opp);
           
           Exam_Attempt__c ea = currEAMap.get(opp.Id);
           Boolean found = false;
           if(opp.FRM_1_Registration_Fee__c != null && opp.FRM_1_Registration_Fee__c > 0) {
               opp.FRM_I_Registration__c = ea.Id;
               found=true;
           }
           if(opp.FRM_2_Registration_Fee__c != null && opp.FRM_2_Registration_Fee__c > 0) {
               opp.FRM_II_Registration__c = ea.Id;
               found=true;
           }
           if(opp.ERP_Registration_Fee__c != null && opp.ERP_Registration_Fee__c > 0) {
               opp.ERP_Registration__c = ea.Id;
               found=true;
           }
           if(opp.EA_Id__c != null) {
               opp.Deferred_Exam_Registration__c = Id.valueOf(opp.EA_Id__c);
               found=true;
           }
           if(opp.Undefred_EA_Id__c != null) {
               opp.Deferred_Exam_Registration__c = Id.valueOf(opp.Undefred_EA_Id__c);
               found=true;
           }
           if(found == false) {
               opp.Undefred_EA_Id__c = null;
               opp.EA_Id__c = null;
               opp.Deferred_Exam_Registration__c = null;
               
               List<Exam_Attempt__c> eal = currContMap.get(opp.AccountId);
               system.debug('eal:' + eal);
               if(eal != null) {
                   Boolean foundDefer = false;
                   for (OpportunityLineItem ol: opp.OpportunityLineItems) {
                       if (ol.PricebookEntry.Name.IndexOf('Defer') > -1) 
                           foundDefer=true;
                   }
                   system.debug('foundDefer:' + foundDefer);
                   Exam_Attempt__c foundEA = null;    
                   Exam_Attempt__c lastEA = null;    
                   for(Exam_Attempt__c ea1 :eal) {
                       lastEA = ea1;
                       if(opp.Purchase_Date__c < ea1.Exam_Date__c && foundDefer) {
                           foundEA = ea1;
                           break;
                       }
                   }
                   system.debug('lastEA:' + lastEA + ':' + foundEA);
                   if((foundEA != null || lastEA != null) && (opp.StageName == 'Closed' || opp.StageName == 'Closed Won')) {
                       if(foundEA == null)
                           foundEA = lastEA;
                       
                       Integer cnt = mapDefCount.get(foundEA.Id);
                       if(cnt == null) {
                           opp.EA_Id__c = String.valueOf(foundEA.Id);
                           opp.Deferred_Exam_Registration__c = foundEA.Id;
                           cnt=1;
                       } else if(math.mod(cnt, 2) == 0) {
                           opp.EA_Id__c = String.valueOf(foundEA.Id);
                           opp.Deferred_Exam_Registration__c = foundEA.Id; 
                           cnt++;
                       } else  if(math.mod(cnt, 2) != 0) {                       
                           opp.Undefred_EA_Id__c = String.valueOf(foundEA.Id);
                           opp.Deferred_Exam_Registration__c = foundEA.Id;    
                           cnt++;
                           system.debug('Undefred_EA_Id__c:' + opp.Undefred_EA_Id__c);
                       }
                       mapDefCount.put(foundEA.Id,cnt);
                   }
                }
           }
           opp.Last_Batch_Update__c = system.today();
           lstUpdateOpp.add(opp); 
       }

        system.debug('lstUpdateOpp: ' + lstUpdateOpp);
        update lstUpdateOpp;       
    }
    
    
   global void finish(Database.BatchableContext BC){
   
   }
}