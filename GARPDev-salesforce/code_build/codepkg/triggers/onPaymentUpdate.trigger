trigger onPaymentUpdate on pymt__PaymentX__c (after update,before insert,after insert) {

    Set<Id> setIds = new Set<Id>();
    Set<Id> paymentid = new Set<Id>();
    list<pymt__PaymentX__c> lstCreateOpportunities = new list<pymt__PaymentX__c>();
    List<Id> lstHasRecurringPayments = new List<Id>();
 
    for(pymt__PaymentX__c  obj : trigger.new)
    {
      if(obj.pymt__Status__c == 'Completed' && Trigger.isAfter)
      {
           setIds.add(obj.pymt__Opportunity__c); 
           lstCreateOpportunities.add(obj);
      }
      
      if(obj.pymt__Amount__c == 0 && Trigger.isbefore  && Trigger.isinsert){
        obj.pymt__Status__c = 'pending';
       paymentid.add(obj.id);
 
       }
       
       if(obj.pymt__Payment_Profile__c != null)
       {
            lstHasRecurringPayments.add(obj.Id);
            
       }}
    
    if(!paymentid.isEmpty())
    {
    list<pymt__PaymentX__c> lstpyt = new list<pymt__PaymentX__c>();
    
    for(pymt__PaymentX__c pyt : [select id,pymt__Status__c from pymt__PaymentX__c where id in: paymentid])
        {
            pyt.pymt__Status__c = 'Completed';
            lstpyt.add(pyt);
        }
     if(lstpyt.size() > 0)
            update lstpyt;
    }
        
    if(!setIds.isEmpty())
    {
        List<Opportunity> lstOpps = new List<Opportunity>();
        for(opportunity opp : [select id,StageName from opportunity where id in: setIds])
        {
            opp.StageName = 'Closed';
            lstOpps.add(opp);
        }
        
        if(lstOpps.size() > 0)
            update lstOpps;
    }
    
    if(lstCreateOpportunities.size() > 0)
    {
        Opportunity opp = null;
        OpportunityLineItem oppLineItem = null;
        list<Opportunity> lstOpps = new list<Opportunity>();
        list<OpportunityLineItem> lstOppLineItems = new list<OpportunityLineItem>();
        map<String,PriceBookEntry> mapProductCodes = new map<String,PriceBookEntry>();
        for(PriceBookEntry PricebookEntryId : [select unitprice,productcode from PriceBookEntry where Pricebook2.IsActive = true and (productcode =: 'GL002' or productcode =: 'GL001') and isActive = true])
        {
                mapProductCodes.put(PricebookEntryId.productcode,PricebookEntryId);
        
        }}
    if(!lstHasRecurringPayments.isEmpty() && trigger.isInsert)
    {
        List<Id> lstRecurringPaymentsIds = new List<Id>();
       Map<String,PriceBookEntry> mapPriceBooks = new Map<String,PriceBookEntry>();
        for(PriceBookEntry PricebookEntryId : [select unitprice,productcode from PriceBookEntry where Pricebook2.IsActive = true and (productcode =: 'MEMS' or productcode =: 'MEMI')  and isActive = true])
        {
            mapPriceBooks.put(PricebookEntryId.productcode,PricebookEntryId);
        }
        List<Opportunity> lstOpps = new List<opportunity>();
        List<OpportunityLineItem> lstOppLineItems = new List<OpportunityLineItem>();
        for(pymt__PaymentX__c objPayment :  [select id,pymt__Account__c,pymt__Payment_Method__c,pymt__Payment_Profile__c,pymt__Payment_Profile__r.Bought_Student__c,pymt__Payment_Profile__r.Bought_Individual__c,pymt__Payment_Profile__r.Is_From_Sites__c from pymt__PaymentX__c where id in: lstHasRecurringPayments])
        {   
            if(objPayment.pymt__Payment_Profile__r.Is_From_Sites__c)
            {
                lstRecurringPaymentsIds.add(objPayment.pymt__Payment_Profile__c);
            }
            else
            {
                Opportunity opp = new Opportunity();
                opp.Name = 'memberShip extension';
                opp.Accountid = objPayment.pymt__Account__c;
                opp.StageName = 'New Lead';
                opp.CloseDate = system.today();
                opp.Renew_Membership__c = true;
                lstOpps.add(opp);
                OpportunityLineItem oppLineItem = new OpportunityLineItem();
                String strProdCode =  'MEMI'; 
                if(objPayment.pymt__Payment_Profile__r.Bought_Student__c)
                {
                    strProdCode = 'MEMS';
                }
                oppLineItem.OpportunityId = opp.Id;
                oppLineItem.PricebookEntryId = mapPriceBooks.get(strProdCode).Id;
                oppLineItem.UnitPrice = mapPriceBooks.get(strProdCode).unitprice;
                oppLineItem.Quantity = 1;
                lstOppLineItems.add(oppLineItem);
            }}
        
        if(lstOpps.size() > 0)
        {
            insert lstOpps;
            insert lstOppLineItems;
        }
        if(lstRecurringPaymentsIds.size() > 0)
        {
            List<pymt__Payment_Profile__c> lstRecPayments = new List<pymt__Payment_Profile__c>();
            
            for(pymt__Payment_Profile__c objRecPayments  : [select id,Is_From_Sites__c from pymt__Payment_Profile__c where id in: lstRecurringPaymentsIds])
            {
                objRecPayments.Is_From_Sites__c = false;
                lstRecPayments.add(objRecPayments);
            }
            update lstRecPayments;
            }}}