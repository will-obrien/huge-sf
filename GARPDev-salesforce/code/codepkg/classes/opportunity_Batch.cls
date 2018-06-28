global class opportunity_Batch implements Database.Batchable<sObject>,Database.StateFul{
    
   global Map<String,Registration.wrapperProductInfo> mapProdCodes = new Map<String,Registration.wrapperProductInfo>();
   Set<String> setProdCodes = new Set<String>();
   Set<String> setGLCodes = new Set<String>();
   global Map<String,PriceBookEntry> mapPriceBookEntry = new Map<String,PriceBookEntry>();
   global Database.QueryLocator start(Database.BatchableContext BC){
      String strStageName = 'Closed';
      Set<String> setClosedStages = new Set<String>{'Closed Lost','Closed'};
      Map<String,Registration.wrapperProductInfo> lstErpProdCodes = ContactRemoter.getExamProducts('ERP');
      system.debug('lstErpProdCodes == '+lstErpProdCodes);
      for(String str : lstErpProdCodes.keySet())
      {
        Registration.wrapperProductInfo objWrapper = lstErpProdCodes.get('ERP');
        mapProdCodes.put('ERP',objWrapper);
        setProdCodes.add(objWrapper.strProductCode);
        setGLCodes.add(objWrapper.strGLCode);
      }
      Map<String,Registration.wrapperProductInfo> lstFrmProdCodes = ContactRemoter.getExamProducts('FRM');
      system.debug('lstFrmProdCodes == '+lstFrmProdCodes);
      for(String str : lstFrmProdCodes.keySet())
      {
        if(str == 'FRMPartOne')
        {
            Registration.wrapperProductInfo objWrapper = lstFrmProdCodes.get(str);
            mapProdCodes.put('FRM1',objWrapper);
            setProdCodes.add(objWrapper.strProductCode);
            setGLCodes.add(objWrapper.strGLCode);
        }
        else if(str == 'FRMPartTwo')
        {
            Registration.wrapperProductInfo objWrapper = lstFrmProdCodes.get(str); 
            mapProdCodes.put('FRM2',objWrapper);
            setProdCodes.add(objWrapper.strProductCode);
            setGLCodes.add(objWrapper.strGLCode);
        }
        
      }
      for(PriceBookEntry objPriceBook : [select unitprice,productcode,product2.Gl_Code__c from PriceBookEntry where Pricebook2.IsActive = true and Pricebook2.IsActive = true and productcode in: setProdCodes and product2.Gl_Code__c in: setGLCodes and isActive = true])
      {
        mapPriceBookEntry.put(objPriceBook.productcode,objPriceBook);
      }
      system.debug(' mapProdCodes == '+ mapProdCodes);
      setProdCodes = new Set<String>{'FRM1L','FRM1S','FRM1E','FRM2L','FRM2S','FRM2E','ENCS','ENCL','ENCE'};
      Set<String> strOppId = new Set<String>{'006f0000006BpdF','006f0000006BpgJ'};
      
      system.debug('>>>'+[select id,ProductCode,PricebookEntryId,OpportunityId,Opportunity.stageName,Opportunity.createdDate,Quantity,UnitPrice from OpportunityLineItem ]);
      system.debug('>>>'+[select id,ProductCode,PricebookEntryId,OpportunityId,Opportunity.stageName,Opportunity.createdDate,Quantity,UnitPrice from OpportunityLineItem where Opportunity.StageName not in:  setClosedStages and Opportunity.createdDate != LAST_N_DAYS:5 and ProductCode in: setProdCodes]);
      return Database.getQueryLocator('select id,ProductCode,PricebookEntryId,OpportunityId,Quantity,UnitPrice from OpportunityLineItem where Opportunity.StageName not in:  setClosedStages and Opportunity.createdDate != LAST_N_DAYS:5 and ProductCode in: setProdCodes');
      
      
   }

   global void execute(Database.BatchableContext BC, List<OpportunityLineItem> scope){
   List<OpportunityLineItem> lstInsertOppLineItems = new List<OpportunityLineItem>();
   List<OpportunityLineItem> lstDeleteOppLineItems = new List<OpportunityLineItem>();
   system.debug(' scope == '+ scope);
   system.debug(' mapPriceBookEntry == '+ mapPriceBookEntry);
        for(OpportunityLineItem opp : scope)
        {
            if(opp.ProductCode != null && opp.ProductCode.indexOf('FRM1') >= 0)
            {
                Registration.wrapperProductInfo objWrapper = mapProdCodes.get('FRM1');
                PriceBookEntry objPriceBookEntry;
                if( objWrapper != null &&  objWrapper.strProductCode != null && mapPriceBookEntry.get(objWrapper.strProductCode) != null   )
                    objPriceBookEntry = mapPriceBookEntry.get(objWrapper.strProductCode);
                if(objPriceBookEntry != null && opp.PricebookEntryId !=  objPriceBookEntry.Id)
                {
                    lstDeleteOppLineItems.add(opp);
                    lstInsertOppLineItems.add(createOppLineItem(opp,objPriceBookEntry));
                }
                
            }
            else if(opp.ProductCode != null && opp.ProductCode.indexOf('FRM2') >= 0)
            {
                Registration.wrapperProductInfo objWrapper = mapProdCodes.get('FRM2');
                PriceBookEntry objPriceBookEntry;
                if(objWrapper != null &&  objWrapper.strProductCode != null && mapPriceBookEntry.get(objWrapper.strProductCode) != null   )
                    objPriceBookEntry = mapPriceBookEntry.get(objWrapper.strProductCode);
                if(objPriceBookEntry != null && opp.PricebookEntryId !=  objPriceBookEntry.Id)
                {
                    lstDeleteOppLineItems.add(opp);
                    lstInsertOppLineItems.add(createOppLineItem(opp,objPriceBookEntry));
                }
            }
            else if(opp.ProductCode != null && opp.ProductCode.indexOf('ENC') >= 0)
            {
                Registration.wrapperProductInfo objWrapper = mapProdCodes.get('ERP');
                PriceBookEntry objPriceBookEntry;
                if( objWrapper != null &&  objWrapper.strProductCode != null && mapPriceBookEntry.get(objWrapper.strProductCode) != null   )
                objPriceBookEntry = mapPriceBookEntry.get(objWrapper.strProductCode);
                if(objPriceBookEntry != null && opp.PricebookEntryId !=  objPriceBookEntry.Id)
                {
                    lstDeleteOppLineItems.add(opp);
                    lstInsertOppLineItems.add(createOppLineItem(opp,objPriceBookEntry));
                }
            }
            
        }
        system.debug(' lstOppLineItems == '+ lstInsertOppLineItems);
        system.debug(' lstDeleteOppLineItems == '+ lstDeleteOppLineItems);
        if(!lstDeleteOppLineItems.isEmpty())
            delete lstDeleteOppLineItems;
         try{
         if(!lstInsertOppLineItems.isEmpty())
            insert lstInsertOppLineItems;
         }catch (exception ex) {
        
          }
    
        
    }
    
    global OpportunityLineItem createOppLineItem(OpportunityLineItem oldOppLine,PriceBookEntry priceBook)
    {
        OpportunityLineItem newOppLine = oldOppLine.clone();
        // newOppLine.OpportunityId = oldOppLine.OpportunityId;
        // newOppLine.Quantity = 1;
        // newOppLine.UnitPrice = oldOppLine.UnitPrice;
        newOppLine.PricebookEntryId = priceBook.Id;
        return newOppLine;
    }

   global void finish(Database.BatchableContext BC){
   
   }
}