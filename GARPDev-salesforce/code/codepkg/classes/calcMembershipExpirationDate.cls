global class calcMembershipExpirationDate implements Database.Batchable<sObject>,Database.StateFul{
    
    public String mode;  
    global calcMembershipExpirationDate (String mode){
        this.mode = mode;
    }
     
   global Database.QueryLocator start(Database.BatchableContext BC){
      
      Date dtToday = system.today();
      String mode = this.mode;
      if(mode == 'null')
          return Database.getQueryLocator('select Id, Name, Calculated_Expire_Date__c from Account where Last_Contract_Exp_Calc__c != null ');
      else if(mode=='date')
          return Database.getQueryLocator('select Id, Name, Calculated_Expire_Date__c from Account where Last_Contract_Exp_Calc__c !=: dtToday ');
      else  
          return Database.getQueryLocator('select Id, Name, Calculated_Expire_Date__c from Account where Id = :mode');
   }

   global void execute(Database.BatchableContext BC, List<Account> scope){

        // Calc Exp Date
        List<Opportunity> lstOpp = [select Id, Name, AccountId, Amount, CloseDate, LEGACY_Purchase_Date__c,
                                    (SELECT Quantity, ListPrice, PriceBookEntry.UnitPrice, PricebookEntry.Name, PricebookEntry.Product2.ProductCode, PricebookEntry.Product2.Product_ID__c  
                                    FROM OpportunityLineItems) from Opportunity where StageName = 'Closed' and
                                    //(Membership_Individual__c = TRUE or Membership_Student__c = TRUE) and 
                                    AccountId in :scope and CloseDate != null order by CloseDate];

        system.debug(lstOpp);
        
        MAP<ID,List<Opportunity>> mapOpp = new MAP<ID,List<Opportunity>>();
        for(Opportunity opp :lstOpp) {
 
            
            Boolean found = false;
            for(OpportunityLineItem ol :opp.OpportunityLineItems){
                if(ol.PricebookEntry.Product2.ProductCode == '208' ||
                    ol.PricebookEntry.Product2.ProductCode == '7' ||
                    ol.PricebookEntry.Product2.ProductCode == '207' ||
                    ol.PricebookEntry.Product2.ProductCode == '1129' ||
                    ol.PricebookEntry.Product2.ProductCode == '4' ||
                    ol.PricebookEntry.Product2.ProductCode == '944' ||
                    ol.PricebookEntry.Product2.ProductCode == 'MEMS' ||
                    ol.PricebookEntry.Product2.ProductCode == 'MEMI' ||
                    ol.PricebookEntry.Product2.ProductCode == 'MEMC' ||
                    ol.PricebookEntry.Product2.ProductCode == '395' ||
                    ol.PricebookEntry.Product2.ProductCode == 'MEMF' ||
                    ol.PricebookEntry.Product2.Product_ID__c== '181' ||                    
                    ol.PricebookEntry.Product2.Product_ID__c== '209' ||                    
                    ol.PricebookEntry.Product2.Product_ID__c== '5' ||                                        
                    ol.PricebookEntry.Product2.Product_ID__c== '6') {
                    found = True;
                }
            }            
            if(found == True) {
            
                List<Opportunity> lst = mapOpp.get(opp.AccountId);
                if(lst==null) {
                    List<Opportunity> newlst = new List<Opportunity>();
                    newlst.add(opp);
                    mapOpp.put(opp.AccountId, newlst);
                } else {
                    lst.add(opp);
                    mapOpp.put(opp.AccountId, lst);
                }
    
            
            }
        }
        
        
        
        List<Product_Refunds__c> lstPr = [select Id, Refund_amount__c, Opportunity__c, Opportunity__r.AccountId, 
                                          Product__r.ProductCode, Product__r.Product_ID__c from Product_Refunds__c where
                                            Status__c = 'Completed' and Opportunity__c in :lstOpp];
       
        MAP<ID,List<Product_Refunds__c>> mapPR = new MAP<ID,List<Product_Refunds__c>>();
        for(Product_Refunds__c pr :lstPr) {
			
			if(pr.Product__r.ProductCode == '208' ||
               pr.Product__r.ProductCode == '7' ||
               pr.Product__r.ProductCode == '207' ||
               pr.Product__r.ProductCode == '1129' ||
               pr.Product__r.ProductCode == '4' ||
               pr.Product__r.ProductCode == '944' ||
               pr.Product__r.ProductCode == 'MEMS' ||
               pr.Product__r.ProductCode == 'MEMI' ||
               pr.Product__r.ProductCode == 'MEMC' ||
               pr.Product__r.ProductCode == '395' ||
               pr.Product__r.ProductCode == 'MEMF' ||
               pr.Product__r.Product_ID__c== '181' ||                    
               pr.Product__r.Product_ID__c== '209' ||                    
               pr.Product__r.Product_ID__c== '5' ||                                        
               pr.Product__r.Product_ID__c== '6') {
                   
                List<Product_Refunds__c> lst = mapPR.get(pr.Opportunity__c);
                if(lst==null) {
                    List<Product_Refunds__c> newlst = new List<Product_Refunds__c>();
                    newlst.add(pr);
                    mapPR.put(pr.Opportunity__c, newlst);
                } else {
                    lst.add(pr);
                    mapPR.put(pr.Opportunity__c, lst);
                }
            }
        }

        List<Account> lstAcct = [select Id, Name, Calculated_Expire_Date__c, Last_Contract_Exp_Calc__c from Account where id in :mapOpp.keySet()];
        for(Account acct :lstAcct) {
            List<Opportunity> lOpp = mapOpp.get(acct.Id);
            
            if(lOpp != null) {
                Date lastExpDate = null;
                for(Opportunity opp :lOpp) {
                    List<Product_Refunds__c> lPR = mapPR.get(opp.Id);
                    system.debug('Fix: ' + opp + ':' + lPR);
                    
                    Boolean refund = false;
                    Decimal totalAmount = 0.0;
                    if(lPR != null) {
                        for(Product_Refunds__c pr :lPR) {
                            totalAmount+=pr.Refund_amount__c;
                        }
                    }
                    if(totalAmount >= opp.Amount && lPR != null) {
                        refund = true;
                    }
                    
                    system.debug('refund: ' + refund + ':' + totalAmount);
                    
                    if(lastExpDate == null && refund == false) {
                        lastExpDate = opp.CloseDate.addDays(365);
                        system.debug('lastExpDate1: ' + lastExpDate);
                        
                    } else if(lastExpDate != null && refund == false && opp.CloseDate > lastExpDate) {
                        lastExpDate = opp.CloseDate.addDays(365);
                        system.debug('lastExpDate2: ' + lastExpDate);
                        
                    } else if(lastExpDate != null && refund == false && opp.CloseDate <= lastExpDate) {
                        lastExpDate = lastExpDate.addDays(365);
                        system.debug('lastExpDate3: ' + lastExpDate);
                    }
                }
                acct.Calculated_Expire_Date__c = lastExpDate;
                system.debug('Calculated_Expire_Date__c:' + lastExpDate);        
            }
            if(this.mode == 'null')
                acct.Last_Contract_Exp_Calc__c = null;
            else if(this.mode=='date')
                acct.Last_Contract_Exp_Calc__c = Date.today();
        }
       
       update lstAcct;
    }
    
    
   global void finish(Database.BatchableContext BC){
   
   }
}