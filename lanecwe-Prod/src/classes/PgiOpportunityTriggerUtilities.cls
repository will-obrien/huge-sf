public Class PgiOpportunityTriggerUtilities{

    public static void assignPbToOppourtunity(list<Opportunity> opplst){ 

        assignStandardPbToOpp(opplst);
        // TODO: uncomment this line when pricebook changes takes place.
        //assignRegionWisePbToOpp(opplst);
    }
    
    private static void assignStandardPbToOpp(list<Opportunity> opplst)
    {
        list<Opportunity> allOppDetails= opplst;
        Pricebook2 stdPb=new Pricebook2();
        try{
         stdPb = [select Id from Pricebook2 where isStandard=true limit 1];
         for(Opportunity Opp: allOppDetails){
             Opp.pricebook2id=stdPb.id;
          }
        }catch(Exception ex){
            PGIErrorUtilities.logPgiError('PGIQuoteTriggerUtilities:submitApprovalRequest()',ex.getMessage(),PGIErrorUtilities.LoggingLevel.INFO);
            system.debug(LoggingLevel.ERROR,'Error When Assigning region wise pricebook to opportunity '+ex.getMessage());
        }
    }
    
    /**
     * Assigns pricebook to opportunity on creation based on the region set on opportunity.
     * 
     * @param opportunityList, list of opportunity in the trigger context.
     */
    /*private static void assignRegionWisePbToOpp(List<Opportunity> opportunityList)
    {
        try
        {
            if (opportunityList != null && !opportunityList.isEmpty())
            {
                PGIAppStaticResources staticResources = PGIAppStaticResources.getInstance();
                for (Opportunity opportunity : opportunityList)
                {
                    if (opportunity != null && opportunity.Owner_Region_New__c != null)
                    {
                        Pricebook2 priceBook = staticResources.regionWisePricebooks.get(opportunity.Owner_Region_New__c);
                        if (priceBook != null)
                        {
                            opportunity.Pricebook2Id = priceBook.Id;
                        }
                    }
                }
            }
        }
        catch(Exception ex)
        {
            PGIErrorUtilities.logPgiError('PgiOpportunityTriggerUtilities:assignRegionWisePbToOpp()',ex.getMessage(),PGIErrorUtilities.LoggingLevel.INFO);
            system.debug(LoggingLevel.ERROR,'Error When Assigning standard pricebook to opportunity '+ex.getMessage());
        }
    }*/
    
    /**
     * Executes on after update opportunity trigger context.
     */
    public static void onAfterUpdate()
    {
        updateOpportunityPricebook();
    }
    
    /**
     * Collects the opportunity ids for which pricebook has been changed and then updates
     * the pricebook on the quotes created for the opportunity.
     */
    private static void updateOpportunityPricebook()
    {
        Map<Id, Opportunity> oldOpportunities = (Map<Id, Opportunity>)Trigger.oldMap;
        Set<Id> opportunityIds = new Set<Id>();
        for (Opportunity opportunity : (List<Opportunity>)Trigger.new)
        {
            Opportunity oldOpportunity = oldOpportunities.get(opportunity.Id);
            if (opportunity != null && oldOpportunity != null && opportunity.Pricebook2Id != oldOpportunity.Pricebook2Id)
            {
                opportunityIds.add(opportunity.Id);
            }
        }
        updatePricebookOnQuotes(opportunityIds);
    }
    
    /**
     * Retrieves the quotes for the given opportunity ids and then deletes the quote line items
     * for the quotes and updates the opportunity's pricebook on the quote.
     *
     * @param opportunityIds, set of opportunity ids.
     */
    private static void updatePricebookOnQuotes(Set<Id> opportunityIds)
    {
        if (!opportunityIds.isEmpty())
        {
            List<Quote> quoteList = [Select Id, Pricebook2Id, OpportunityId, 
                                    (Select Id From QuoteLineItems) 
                                     From Quote Where OpportunityId IN:opportunityIds];
            if (quoteList != null && !quoteList.isEmpty())
            {
                Map<Id, Opportunity> newOpportunityMap = (Map<Id, Opportunity>)Trigger.newMap;
                List<QuoteLineItem> qliList = new List<QuoteLineItem>();
                for (Quote quote : quoteList)
                {
                    quote.Pricebook2Id = newOpportunityMap.get(quote.OpportunityId).Pricebook2Id;
                    if (quote.QuoteLineItems != null && !quote.QuoteLineItems.isEmpty())
                    {
                        qliList.add(quote.QuoteLineItems);
                    }
                }
                if (!qliList.isEmpty())
                {
                    delete qliList;
                }
                update quoteList;
            }
        }
    }
    
    /*public static void updateQuoteAdminFlag(list<Opportunity> opplst){
        system.debug('### closed opportunityid='+opplst);
        set<Id> oppIds= new set<Id>();
        list<Quote>updateQuoteAdminList= new list<Quote>();
        for(Opportunity opp:opplst){
            if(opp.IsClosed){
                oppIds.add(opp.Id);
            }
        }
        if(!oppIds.isEmpty()){
                list<Quote>quotelst=new list<Quote>([select Id,Admin_Flag__c from Quote where OpportunityId=:oppIds]);
                    if(!quotelst.isEmpty()){
                        for(Quote q:quotelst){
                            q.Admin_Flag__c=true;
                            updateQuoteAdminList.add(q);
                        }
                    }
            
                if(!updateQuoteAdminList.isEmpty()){
                    try{
                        update updateQuoteAdminList;
                    }catch(Exception e){
                        system.debug('exception'+e);
                    }
                }
        }
    }*/
    
    /*public static void opportunityLineItems(list<QuoteLineItem>quoteLineItems ,Boolean isInsert,Boolean isUpdate,Boolean isDelete,list<QuoteLineItem>oldquoteLineItem){
        set<Id>quoteLineItemIdLst = new set<Id>();
        set<string>productFamilyName= new set<string>();
        Map<String,Id> pricebookMap=new Map<String,Id>();
        set<Id>OpportunityId= new set<Id>();
        list<OpportunityLineItem> insertOppLineLst=new list<OpportunityLineItem>();
        list<OpportunityLineItem> updateOppLineLst=new list<OpportunityLineItem>();
        list<OpportunityLineItem> updateOppLstManualCreatd= new list<OpportunityLineItem>();
        set<OpportunityLineItem> updateOppSetManualCreatd= new set <OpportunityLineItem>();
        set<Id> minCommitPackageIds = new set<Id>();
            if(isInsert || isUpdate ){
                for(QuoteLineItem qline:quoteLineItems){
                    if(qline.Id!=null && qline.IsServiceProduct__c){
                        quoteLineItemIdLst.add(qline.Id);
                  }*/
                  // TODO : remove this else condition once packages are splitted for min commit.
                  /*else if (qline.Min_Commit__c)
                  {
                    minCommitPackageIds.add(qline.Quote_Line_Item__c);
                  }*/
              /*}*/
              // TODO : remove this if condition once packages are splitted for min commit.
             /* if (!minCommitPackageIds.isEmpty())
              {
                for(QuoteLineItem qline:quoteLineItems){
                  if (minCommitPackageIds.contains(qline.Quote_Line_Item__c))
                  {
                    quoteLineItemIdLst.add(qline.Id);
                  }
                }
                quoteLineItemIdLst.addAll(minCommitPackageIds);
              }*/
        /*}
        Map<Id,QuoteLineItem>quoteLineItemMap= new Map<Id,QuoteLineItem>([select 
                                    id,IsServiceProduct__c,BidPrice__c,Quote.OpportunityId,
                                    Quantity,Quantity__c,QuoteId,UnitPrice,Product__c,Service__c,
                                    Product__r.name,Service__r.Name,Quote_Line_Item__c,
                                    Contract_Term__c,Solution__c,Solution__r.Name,Product__r.ProductType__c,
                                    Product__r.Unit_Of_Measure__c,Billing_Frequency__c,
                                    Min_Commit__c
                                    from QuoteLineItem  
                                    where Id In: quoteLineItemIdLst]);
      string QuoteId ='';
      for(QuotelineItem qItem:quoteLineItemMap.values()){
            productFamilyName.add(qItem.Solution__r.Name);
            OpportunityId.add(qItem.Quote.OpportunityId);
            QuoteId=qItem.QuoteId;
       }
        if(QuoteId!=''){
                    quote q=[Select Id,CurrencyIsoCode, Pricebook2Id From Quote where id =:QuoteId];
      
                    List<PricebookEntry> PBELst = [select id, name, CurrencyIsoCode ,Product2.name,Product2.Cost_Rate__c from PriceBookEntry where
                                                        Pricebook2id=:q.Pricebook2Id and Product2.Name IN:productFamilyName and
                                                        currencyisocode =: q.CurrencyIsoCode];  
                    if(!PBELst.isEmpty()){
                            for(PricebookEntry priceBoook:PBELst){
                                    pricebookMap.put(priceBoook.Product2.name,priceBoook.id);
                            }
                    }
     
                Map<Id,OpportunityLineItem>oppLineItemMap=new Map<Id,OpportunityLineItem>([Select Quote_Line_Item__c, Min_Commit__c, Quantity, New_Quantity__c, New_Sales_Price__c,Id,Unit_Type__c,Billing_Frequency__c,Contract_Term__c From OpportunityLineItem where OpportunityId =:OpportunityId]);
                
            if(isInsert){*/
              // TODO : remove this if condition once packages are splitted for min commit.
              /*if (!minCommitPackageIds.isEmpty())
              {
                for (Id serviceQliId : minCommitPackageIds)
                {
                QuoteLineItem minAudioQli = null;
                       QuoteLineItem domDialQli = null;
                       Map<String, QuoteLineItem> qliMap = new Map<String, QuoteLineItem>();
                       findMinCommitAddOnQlis(quoteLineItemMap.values(), qliMap, serviceQliId);
                       minAudioQli = qliMap.get(PGIAppConstants.MIN_COMMIT_AUDIO_MIN_PRODNAME);
                       domDialQli = qliMap.get(PGIAppConstants.MIN_COMMIT_DOM_DIAL_PRODNAME);
                       QuoteLineItem serviceQli = quoteLineItemMap.get(serviceQliId);
                       OpportunityLineItem serviceOpli = findServiceOpli(oppLineItemMap.values(), serviceQliId);
                       serviceOpli.isEditable__c = true;
                       serviceOpli.New_Quantity__c = serviceQli.Quantity__c - (minAudioQli.BidPrice__c/domDialQli.BidPrice__c);
                         serviceOpli.Unit_Price_Create_Only__c=domDialQli.BidPrice__c;
                         serviceOpli.New_Sales_Price__c=domDialQli.BidPrice__c;
                         serviceOpli.Min_Commit__c = serviceQli.Min_Commit__c;
                         insertOppLineLst.add(serviceOpli);
                         
                         OpportunityLineItem secondMinCommitOpli = new OpportunityLineItem();
                         secondMinCommitOpli.PricebookEntryId=pricebookMap.get(serviceQli.Solution__r.Name);
                        secondMinCommitOpli.New_Sales_Price__c=domDialQli.BidPrice__c;
                        secondMinCommitOpli.Unit_Type__c=serviceQli.Product__r.Unit_Of_Measure__c;
                        secondMinCommitOpli.Billing_Frequency__c=serviceQli.Billing_Frequency__c;
                        secondMinCommitOpli.Contract_Term__c=serviceQli.Contract_Term__c;
                        secondMinCommitOpli.Quote_Line_Item__c=serviceQli.Id;
                        secondMinCommitOpli.Quantity=1;
                        secondMinCommitOpli.OpportunityId=serviceQli.Quote.OpportunityId;
                        secondMinCommitOpli.Package__c=serviceQli.Service__c;
                        secondMinCommitOpli.Add_on_Feature__c=serviceQli.Product__c;
                        secondMinCommitOpli.isReportable_Text__c='Valid';
                        secondMinCommitOpli.isEditable__c = true;
                        secondMinCommitOpli.New_Quantity__c = minAudioQli.BidPrice__c/domDialQli.BidPrice__c;
                         secondMinCommitOpli.Unit_Price_Create_Only__c=domDialQli.BidPrice__c;
                         secondMinCommitOpli.Billing_Frequency__c = minAudioQli.Billing_Frequency__c;
                         secondMinCommitOpli.Contract_Term__c = minAudioQli.Contract_Term__c;
                         secondMinCommitOpli.Min_Commit__c = true;
                         insertOppLineLst.add(secondMinCommitOpli);
                }
              }
              else
              {*/
                /*List<String> productWithoutPbEntry = new List<String>();
                    for(QuoteLineItem quoteLines:quoteLineItemMap.values()){
                      String pricebookId = pricebookMap.get(quoteLines.Solution__r.Name);
                      if (pricebookId != null)
                      {
                          OpportunityLineItem oppLineItem= new OpportunityLineItem();
                          oppLineItem.PricebookEntryId=pricebookMap.get(quoteLines.Solution__r.Name);
                          oppLineItem.New_Sales_Price__c=quoteLines.BidPrice__c;
                          oppLineItem.Unit_Type__c=quoteLines.Product__r.Unit_Of_Measure__c;
                          oppLineItem.Billing_Frequency__c=quoteLines.Billing_Frequency__c;
                          oppLineItem.Contract_Term__c=quoteLines.Contract_Term__c;
                          oppLineItem.Quote_Line_Item__c=quoteLines.Id;
                          oppLineItem.Quantity=1;
                          oppLineItem.OpportunityId=quoteLines.Quote.OpportunityId;
                          oppLineItem.Package__c=quoteLines.Service__c;
                          oppLineItem.Add_on_Feature__c=quoteLines.Product__c;
                          oppLineItem.isReportable_Text__c='Valid';
                          oppLineItem.isEditable__c = true;
                          oppLineItem.New_Quantity__c=quoteLines.Quantity__c;
              oppLineItem.Unit_Price_Create_Only__c=quoteLines.BidPrice__c;
                          insertOppLineLst.add(oppLineItem);
                      }
                      else
                      {
                        productWithoutPbEntry.add(quoteLines.Solution__r.Name);
                      }
                    }
                    if (!productWithoutPbEntry.isEmpty())
                    {
                      PGIProductHelper helper = new PGIProductHelper();
                      if (helper.sendPbEntryEmail)
                      {
                        List<Product2> productList = helper.findProductByName(productWithoutPbEntry);
                        helper.sendPbEntryMissingEmail(productList);
                      }
                    }
              //}
                    if(!insertOppLineLst.isEmpty()){
                        try{
                            upsert insertOppLineLst;
                        }catch(Exception e){
                            system.debug('InsertException'+e);
                        }
                }  
            }
     
            if(isUpdate){
                for(QuoteLineItem quoteLines:quoteLineItemMap.values()){
                    for(OpportunityLineItem oppLitem:oppLineItemMap.values()){
                            OpportunityLineItem oppLineItem= oppLineItemMap.get(oppLitem.Id);
                                if(oppLineItem!=null && oppLineItem.Quote_Line_Item__c == quoteLines.Id){
                                    oppLineItem.New_Quantity__c=quoteLines.Quantity__c;
                                    oppLineItem.Unit_Price_Create_Only__c=quoteLines.BidPrice__c;
                                    oppLineItem.New_Sales_Price__c=quoteLines.BidPrice__c;
                                    oppLineItem.Unit_Type__c=quoteLines.Product__r.Unit_Of_Measure__c;
                                    oppLineItem.Billing_Frequency__c=quoteLines.Billing_Frequency__c;
                                    oppLineItem.Contract_Term__c=quoteLines.Contract_Term__c;
                                    oppLineItem.isReportable_Text__c='Valid';
                                    oppLineItem.isEditable__c = true;*/
                                    // TODO : remove this if condition once packages are splitted for min commit.
                                    /*if (minCommitPackageIds.contains(oppLineItem.Quote_Line_Item__c))
                                    {
                                      QuoteLineItem minAudioQli = null;
                               QuoteLineItem domDialQli = null;
                               Map<String, QuoteLineItem> qliMap = new Map<String, QuoteLineItem>();
                               findMinCommitAddOnQlis(quoteLineItemMap.values(), qliMap, oppLineItem.Quote_Line_Item__c);
                               minAudioQli = qliMap.get(PGIAppConstants.MIN_COMMIT_AUDIO_MIN_PRODNAME);
                               domDialQli = qliMap.get(PGIAppConstants.MIN_COMMIT_DOM_DIAL_PRODNAME);
                               if (oppLineItem.Min_Commit__c)
                               {
                                 oppLineItem.New_Quantity__c = minAudioQli.BidPrice__c/domDialQli.BidPrice__c;
                                 oppLineItem.Unit_Price_Create_Only__c=domDialQli.BidPrice__c;
                                 oppLineItem.Billing_Frequency__c = minAudioQli.Billing_Frequency__c;
                                   oppLineItem.Contract_Term__c = minAudioQli.Contract_Term__c;
                                   oppLineItem.New_Sales_Price__c=domDialQli.BidPrice__c;
                               }
                               else
                               {
                                 oppLineItem.New_Quantity__c = quoteLines.Quantity__c - (minAudioQli.BidPrice__c/domDialQli.BidPrice__c);
                                   oppLineItem.Unit_Price_Create_Only__c=domDialQli.BidPrice__c;
                                   oppLineItem.New_Sales_Price__c=domDialQli.BidPrice__c;
                               }
                            }*/
                                    /*updateOppLineLst.add(oppLineItem);
                                }
                    }
            }
            
                if(!updateOppLineLst.isEmpty()){
                    try{
                        update updateOppLineLst;
                    }catch(Exception e){
                        system.debug('exception'+e);
                    }
                }
         }
         
           if(isInsert ||isUpdate ){
        
        //system.debug('$$$triggerInsert');
        Map<Id,OpportunityLineItem>oppLineItemsUI=new Map<Id,OpportunityLineItem>([Select PricebookEntry.Name,Existing_Service__c,PricebookEntryId,OpportunityId From OpportunityLineItem  where OpportunityId=:OpportunityId and Quote_Line_Item__c='']);
         for(QuoteLineItem quotelines:quoteLineItemMap.values()){
                        for(OpportunityLineItem opplines:oppLineItemsUI.values()){
                            if(quotelines.Quote.OpportunityId== opplines.OpportunityId ){
                                opplines.Admin_Flag__c=true;
                                if(!opplines.Existing_Service__c){
                                    opplines.isReportable_Text__c='Invalid';
                                }
                                updateOppSetManualCreatd.add(opplines);
                            }
                        }
                    }
                    if(!updateOppSetManualCreatd.isEmpty()){
                        try{
                          updateOppLstManualCreatd.addAll(updateOppSetManualCreatd);
                            update updateOppLstManualCreatd;
                        }catch(exception e){
                            system.debug('updateoppexception'+e);
                        }
                        
                    }
      }
     
    }
    
     if(isDelete){
        //system.debug('enterDelete');
            set<Id> deletedlineItem = new set <Id>();
            set<Id> oppIdLst= new set<Id>();
            set<Id>quoteIdlst=new set<Id>();
            list<OpportunityLineItem> updateOppLstUI= new list<OpportunityLineItem>();
            for(QuoteLineItem deletQuoteL:oldquoteLineItem){
                    if(deletQuoteL.Id!=null && deletQuoteL.IsServiceProduct__c){
                    deletedlineItem.add(deletQuoteL.Id);
                    quoteIdlst.add(deletQuoteL.QuoteId);
                    }
                
        }*/
        
       /* list<Quote>QuoteLst= new list <Quote>([select OpportunityId,Id from Quote where Id In:quoteIdlst]);
        for(Quote q:QuoteLst){
            oppIdLst.add(q.OpportunityId);
        }*/
        
            //system.debug('oppIdLst'+oppIdLst);
            /*list<OpportunityLineItem> deleteOpplist=new list<OpportunityLineItem>([select Id,Quote_Line_Item__c from OpportunityLineItem where Quote_Line_Item__c In:deletedlineItem]);*/
             //list<OpportunityLineItem>oppProductThrQuotelst=new list<OpportunityLineItem>([Select OpportunityId From OpportunityLineItem  where OpportunityId=:oppIdLst and Quote_Line_Item__c!='']);
            // Map<Id,OpportunityLineItem>deleteOppLineItemsUI=new Map<Id,OpportunityLineItem>([Select OpportunityId From OpportunityLineItem  where OpportunityId=:oppIdLst and Quote_Line_Item__c='']);
                       /* if(oppProductThrQuotelst.isempty()){
                            for(OpportunityLineItem opplines:deleteOppLineItemsUI.values()){
                                    opplines.Admin_Flag__c=true;
                                    opplines.isReportable_Text__c='Valid';
                                    updateOppLstUI.add(opplines);
                                }
                        }*/
            
            /*if(!deleteOpplist.isEmpty()){
                try{
                    delete deleteOpplist;
                }
                catch(Exception e){
                    system.debug('DeleteException'+e);
            }
        }*/
            /*if(!updateOppLstUI.isEmpty()){
                try{
                     update updateOppLstUI;
             }catch(exception e){
                     system.debug('updateoppexception'+e);
                }
            }*/
        /*}
      
    
   }*/
   
   /*private static String createOPLISyncErrorMessage(Exception e, List <OpportunityLineItem> opportunityLineItems)
   {
        String errorMsg = (e != null)?e.getMessage():'Unknown Error Found';
        if(opportunityLineItems != null && !opportunityLineItems.isEmpty())
        {
            for(OpportunityLineItem oppLi : opportunityLineItems)
            {
                String qliUrl = System.URL.getSalesforceBaseUrl()+'/'+oppLi.Quote_Line_Item__c;
                errorMsg = errorMsg+'\n'+qliUrl;
            }
        }
        return errorMsg;
   }*/
   
   /*private static void findMinCommitAddOnQlis(List<QuoteLineItem> qliList, 
                                                Map<String, QuoteLineItem> qliMap,
                                                Id serviceQliId)
   {           
        for (QuoteLineItem qli : qliList)
        {
            if (qli.Product__r.name.startsWith(PGIAppConstants.MIN_COMMIT_AUDIO_MIN_PRODNAME)
                && qli.Quote_Line_Item__c == serviceQliId)
            {
                qliMap.put(PGIAppConstants.MIN_COMMIT_AUDIO_MIN_PRODNAME, qli);
            }
            else if (qli.Product__r.name.startsWith(PGIAppConstants.MIN_COMMIT_DOM_DIAL_PRODNAME)
                && qli.Quote_Line_Item__c == serviceQliId)
            {
                qliMap.put(PGIAppConstants.MIN_COMMIT_DOM_DIAL_PRODNAME, qli);
            }
            if (qliMap.size() == 2)
            {
                break;
            }
        }
        
        if(qliMap.size() < 2){
            List<String> productList = new List<String>();
            if(!qliMap.containsKey(PGIAppConstants.MIN_COMMIT_AUDIO_MIN_PRODNAME)){
                productList.add(PGIAppConstants.MIN_COMMIT_AUDIO_MIN_PRODNAME+'%');
            }
            if(!qliMap.containsKey(PGIAppConstants.MIN_COMMIT_DOM_DIAL_PRODNAME)){
                productList.add(PGIAppConstants.MIN_COMMIT_DOM_DIAL_PRODNAME+'%');
            }
            List<QuoteLineItem> qliMinCommitList = [Select Product__r.name, BidPrice__c, Billing_Frequency__c, Contract_Term__c From QuoteLineItem 
                                                    Where Quote_Line_Item__c = :serviceQliId and product__r.name like :productList];
            system.debug('qliMinCommitList ===>'+qliMinCommitList.size()+'======>'+qliMinCommitList);
            for(QuoteLineItem qli : qliMinCommitList){
                if(qli.Product__r.name.startsWith(PGIAppConstants.MIN_COMMIT_AUDIO_MIN_PRODNAME))
                    qliMap.put(PGIAppConstants.MIN_COMMIT_AUDIO_MIN_PRODNAME, qli);
                else if (qli.Product__r.name.startsWith(PGIAppConstants.MIN_COMMIT_DOM_DIAL_PRODNAME))
                    qliMap.put(PGIAppConstants.MIN_COMMIT_DOM_DIAL_PRODNAME, qli);
            }  
            system.debug('===>qliMap  ===>'+qliMap.size()+'====>'+qliMap);
        }
   }*/
   
   /*private static OpportunityLineItem findServiceOpli(List<OpportunityLineItem> opliList, Id qliId)
   {
    OpportunityLineItem serviceOpli;
    for (OpportunityLineItem opli : opliList)
    {
        if (opli.Quote_Line_Item__c == qliId)
        {
            serviceOpli = opli;
            break;
        }
    }
    return serviceOpli;
   }*/
    
   /*public static void updateOppLineStatus(list<OpportunityLineItem> oppLineItem){
    //system.debug('updateOppLineStatus+oppLineItem'+oppLineItem);
        set<Id>oppIdLst=new set<Id>();
        list<OpportunityLineItem> updateOppLineLst=new list<OpportunityLineItem>();
        set<Id>opportunityIdUpdateLst= new set<Id>();
        for(OpportunityLineItem opp:oppLineItem){
            oppIdLst.add(opp.OpportunityId);
        }
                  list<OpportunityLineItem>oppProductThrQuotelst=new list<OpportunityLineItem>([Select OpportunityId From OpportunityLineItem  where OpportunityId=:oppIdLst and Quote_Line_Item__c!='']);
                  Map<Id,OpportunityLineItem>deleteOppLineItemsUI=new Map<Id,OpportunityLineItem>([Select OpportunityId,isEditable__c, Existing_Service__c From OpportunityLineItem  where OpportunityId=:oppIdLst and Quote_Line_Item__c='']);
                  //Map<Id,OpportunityLineItem>deleteOppLineItemsUI=new Map<Id,OpportunityLineItem>([Select OpportunityId,Existing_Service__c From OpportunityLineItem  where OpportunityId=:oppIdLst and Quote_Line_Item__c='']);
                     if(oppProductThrQuotelst.isEmpty()){
                         for(OpportunityLineItem opplines:deleteOppLineItemsUI.values()){
                            if(!opplines.Existing_Service__c){
                                    opplines.isReportable_Text__c='Valid';
                                    opplines.isEditable__c = true;
                                }
                                
                                updateOppLineLst.add(opplines);
                        }
                        //system.debug('deleteupdateOppLineLst'+updateOppLineLst);
                        if(!updateOppLineLst.isempty()){
                            update updateOppLineLst;
                        }
                     }   
   }*/
    
    //   ************************* Test Methods *********************************
         @istest(seeAlldata=true) 
     private static void test_PgiOpportunityTriggerUtilities(){
     
     /*Boolean isInsert=true;
     Boolean isUpdate=false;
     Boolean isDelete=false;
      Boolean isInsert1=false;
     Boolean isUpdate1=true;
     Boolean isDelete1=false;
      Boolean isInsert2=false;
     Boolean isUpdate2=false;
     Boolean isDelete2=true;
     
     List<Opportunity>   opplist=new List<Opportunity>();
     List<QuoteLineItem >   quotelinelist=new List<QuoteLineItem >();
       
       Account testAcc= PGITestUtilities.getAccountDetails();
        insert testAcc;        
      Opportunity testOpp= PGITestUtilities.getOpportunityDetails();      
        opplist.add(testOpp);
         Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
        cont.firstname='test';
        cont.lastname='test';
        cont.email='himanshu.soni5@gmail.com';
        cont.title='Mr';
        insert cont;
        Opportunity testOpp1= PGITestUtilities.getOpportunityDetails();      
        opplist.add(testOpp1);
        Opportunity testOpp2= PGITestUtilities.getOpportunityDetails();     
        opplist.add(testOpp2);
        insert opplist;
		Product2 standardProduct = PGITestUtilities.getStdProduct();
        insert standardProduct;
        PricebookEntry standardPbe = PGITestUtilities.CreatePriceBookEntryForProduct(standardProduct);
        insert standardPbe;
        OpportunityLineItem oli = PGITestUtilities.getOpportunityLineItemDetails(testOpp.Id, standardPbe.Id);
        insert oli;
        OpportunityLineItem oli1 = PGITestUtilities.getOpportunityLineItemDetails(testOpp1.Id, standardPbe.Id);
        insert oli1; 
        OpportunityLineItem oli2 = PGITestUtilities.getOpportunityLineItemDetails(testOpp2.Id, standardPbe.Id);
        insert oli2;
        testOpp2.StageName='Closed Won';
        testOpp2.Opp_Stage__c = 'Closed Won';
        testOpp2.Primary_Won_Reason__c='test'; 
        testOpp2.CloseDate = System.today() + 7;
        testOpp2.Competitor_s__c = 'test';
        testOpp2.Incumbent__c = 'test';
        update testOpp2;  
        Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        insert testQuote;        
        Quote testQuote1= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp1.Id); 
        insert testQuote1;
        Quote testQuote2= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp2.Id); 
        insert testQuote2;
     
          
        Region__c region = PGITestUtilities.getRegionDetails();
        insert region;
        list<Product__c> allProduct= new list<Product__c>();
        Product__c testprod1 = PGITestUtilities.getProductDetails('Add-on', 'TestAddon','10111111') ;
        insert testProd1;       
        Product__c testprod2 = PGITestUtilities.getProductDetails('Ancillary','TestAncillary','20111111');
        insert testProd2;
        Product__c testprod3= PGITestUtilities.getProductDetails('Service','testserv','30111111');
        insert testProd3;
        Solution__c testSoln = PGITestUtilities.getSolution();
        insert testSoln;
        Service__c testSer= PGITestUtilities.getService(testSoln.Id);
        insert testSer;
        ServiceCategory__c testSc1= PGITestUtilities.getSerCategory(testSer.Id, testProd1.Id, true);
        insert testSc1;
        ServiceCategory__c testSc2= PGITestUtilities.getSerCategory(testSer.Id, testProd2.Id, false);
        insert testSc2;
        ServiceCategory__c testSc3= PGITestUtilities.getSerCategory(testSer.Id, testProd3.Id, false);
        insert testSc3;
        PriceBook2 pb2Standard = [select Id from Pricebook2 where isStandard=true];
                string standardPriceBookId = pb2Standard.Id;
                Product2 testProd= PGITestUtilities.getStdProduct();        
        insert testProd;
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=standardPriceBookId, Product2Id=testProd.Id, UnitPrice=99, isActive=true);
                insert pbe;    
                /*QuoteLineItem testquoteLineItem1=PGITestUtilities.getServiceQuoteLineItem(testprod1.Id,testSer.Id,testQuote.Id,pbe);
                insert testquoteLineItem1;
                QuoteLineItem testquoteLineItem2=PGITestUtilities.getTestQuoteLineItem(testprod2.Id,testSer.Id,testQuote.Id,pbe,testquoteLineItem1.Id);
                insert testquoteLineItem2;
                QuoteLineItem testquoteLineItem3=PGITestUtilities.getTestQuoteLineItem(testprod3.Id,testSer.Id,testQuote.Id,pbe,testquoteLineItem1.Id);
                insert testquoteLineItem3;
              
                QuoteLineItem testquoteLineItem4=PGITestUtilities.getServiceQuoteLineItem(testprod1.Id,testSer.Id,testQuote1.Id,pbe);
                insert testquoteLineItem4;
                
                QuoteLineItem testquoteLineItem5=PGITestUtilities.getTestQuoteLineItem(testprod2.Id,testSer.Id,testQuote1.Id,pbe,testquoteLineItem1.Id);
                insert testquoteLineItem5;*/
                /*
                QuoteLineItem testquoteLineItem6=PGITestUtilities.getTestQuoteLineItem(testprod3.Id,testSer.Id,testQuote1.Id,pbe,testquoteLineItem1.Id);
                insert testquoteLineItem6;
                */
                
                /*testquoteLineItem1.IsServiceProduct__c =true;
                 testquoteLineItem2.IsServiceProduct__c =true;
                 testquoteLineItem3.IsServiceProduct__c =true;
                 
                 testquoteLineItem4.IsServiceProduct__c =true;
                 
                 testquoteLineItem5.IsServiceProduct__c =true;*/
                 /*
                  testquoteLineItem6.IsServiceProduct__c =true;
                */
                /*quotelinelist.add(testquoteLineItem3);
                
                 quotelinelist.add(testquoteLineItem2);
                 
                  quotelinelist.add(testquoteLineItem1);
                   
                    quotelinelist.add(testquoteLineItem4);
                 
                 quotelinelist.add(testquoteLineItem5);*/
                 /*
                  quotelinelist.add(testquoteLineItem6);
                  */
                
                // List<opportunitylineitem> opppro = new opportunitylineitem[]{new opportunitylineitem(UnitPrice=10000.00, Quantity=10, opportunityid=testOpp.id, pricebookEntryId=pbe.id),new opportunitylineitem(UnitPrice=10000.00,  Quantity=10,  opportunityid=testOpp.id, pricebookEntryId=pbe.id),new opportunitylineitem(UnitPrice=10000.00,    Quantity=10,  opportunityid=testOpp1.id, pricebookEntryId=pbe.id),new opportunitylineitem(UnitPrice=10000.00,   Quantity=10, pricebookEntryId=pbe.id, opportunityid=testOpp1.id)};
               //List<opportunitylineitem> opppro = new opportunitylineitem[]{new opportunitylineitem(UnitPrice=10000.00, Quantity=10, opportunityid=testOpp.id, pricebookEntryId=pbe.id),new opportunitylineitem(UnitPrice=10000.00,     Quantity=10,  opportunityid=testOpp.id, pricebookEntryId=pbe.id),new opportunitylineitem(UnitPrice=10000.00,    Quantity=10,  Quote_Line_Item__c=testquoteLineItem2.id, opportunityid=testOpp1.id, pricebookEntryId=pbe.id),new opportunitylineitem(UnitPrice=10000.00,     Quantity=10, pricebookEntryId=pbe.id, Quote_Line_Item__c=testquoteLineItem3.id ,opportunityid=testOpp1.id)};
                // insert opppro ;
        test.starttest();
        /*PgiOpportunityTriggerUtilities test1=new PgiOpportunityTriggerUtilities();
        PgiOpportunityTriggerUtilities.assignPbToOppourtunity(opplist);
        PgiOpportunityTriggerUtilities.updateQuoteAdminFlag(opplist);*/
        /*PgiOpportunityTriggerUtilities.opportunityLineItems(quotelinelist ,isInsert,isUpdate,isDelete,quotelinelist);
        PgiOpportunityTriggerUtilities.opportunityLineItems(quotelinelist ,isInsert1,isUpdate1,isDelete1,quotelinelist);
        PgiOpportunityTriggerUtilities.opportunityLineItems(quotelinelist ,isInsert2,isUpdate2,isDelete2,quotelinelist);
        PgiOpportunityTriggerUtilities.updateOppLineStatus(opppro);*/
        test.stoptest();
     
     }     
     
     //@istest(seeAlldata=true) 
     /*private static void UnitTest_OpportunityPbChange()
     {
        Test.startTest();
        String USER_REGION = 'NA';
        String OPP_STAGE = 'Qualification';
        User testAdminUser = PGITestUtilities.getTestUser(PGITestUtilities.getAdminProfile());
        testAdminUser.Region__c = USER_REGION;
        insert testAdminUser;
        system.assertNotEquals(testAdminUser.Id, null);
        system.runAs(testAdminUser)
        {
            Account account = PGITestUtilities.getAccountDetails();
            insert account;
            system.assertNotEquals(account.Id, null);
            Opportunity opportunity = PGITestUtilities.getOpportunityDetails();
            opportunity.Owner_Copy__c = testAdminUser.Id;
            opportunity.Pricebook2Id = null;
            opportunity.AccountId = account.Id;
            // set the probability here to 10%, otherwise custom validation fails.
            opportunity.Prob_Input__c = '10';
            opportunity.StageName = OPP_STAGE;
            opportunity.Opp_Stage__c = OPP_STAGE;
            insert opportunity;
            system.assertNotEquals(opportunity.Id, null);
            Contact cont= PGITestUtilities.getContactDetails(account.Id); 
            cont.firstname='test';
            cont.lastname='test';
            cont.email='test@email.com';
            cont.title='Mr';
            insert cont;
            system.assertNotEquals(cont.Id, null);
            Quote quote = PGITestUtilities.getQuoteDetails(account.Id, cont.Id ,opportunity.Id);
            insert quote;
            system.assertNotEquals(quote.Id, null);
            
            // create pgi service product
            Product__c pgiProduct = PGITestUtilities.getProductDetails('Add-on', 'TestAddon','10111111') ;
            insert pgiProduct;
            system.assertNotEquals(pgiProduct.Id, null);
            Solution__c solution = PGITestUtilities.getSolution();
            insert solution;
            system.assertNotEquals(solution.Id, null);
            Service__c service= PGITestUtilities.getService(solution.Id);
            insert service;
            system.assertNotEquals(service.Id, null);
            ServiceCategory__c serviceCategory= PGITestUtilities.getSerCategory(service.Id, pgiProduct.Id, true);
            insert serviceCategory;
            system.assertNotEquals(serviceCategory.Id, null);
            
            // create standard SFDC product and do the pricebook entry.
            Product2 standardProduct = PGITestUtilities.getStdProduct();
            insert standardProduct;
            system.assertNotEquals(standardProduct.Id, null);
            PGIAppStaticResources staticResources = PGIAppStaticResources.getInstance();
            PricebookEntry standardPbe = PGITestUtilities.CreatePriceBookEntryForProduct(standardProduct);
            insert standardPbe;
            system.assertNotEquals(standardPbe.Id, null);
            PricebookEntry pbe = PGITestUtilities.CreatePriceBookEntryForProduct(standardProduct, staticResources.regionWisePricebooks.get(USER_REGION));
            insert pbe;
            system.assertNotEquals(pbe.Id, null);
            
            // create the quote line item for the quote.
            QuoteLineItem qli = PGITestUtilities.getServiceQuoteLineItem(pgiProduct.Id, service.Id, quote.Id, pbe);
            insert qli;
            system.assertNotEquals(qli.Id, null);
            
            // update the pricebook on the opportunity so that after update scenario executes.
            opportunity.Pricebook2Id = PGITestUtilities.standardPriceBook.Id;
            update opportunity;
            quote = [Select Id, Pricebook2Id, OpportunityId, 
                                    (Select Id From QuoteLineItems) 
                                     From Quote Where OpportunityId =:opportunity.Id];
            system.assertNotEquals(quote, null);
            system.assertEquals(quote.QuoteLineItems.isEmpty(), true);
            system.assertEquals(quote.Pricebook2Id, opportunity.Pricebook2Id);
            Test.stopTest();
        }
     }*/
     
     @isTest(seeAlldata=true)
     private static void Test_PGIAssignStandardPriceBooktoOpportunity(){
     	 Test.startTest();
     	 //Product2 prod = new Product2(Name='TestProd', Family = 'testFamily');
     	 //insert prod;  
     	 Id pricebookId = Test.getStandardPricebookId();
     	 //PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
     	 //insert standardPrice;
     	 Product2 standardProduct = PGITestUtilities.getStdProduct();
         insert standardProduct;
     	 PricebookEntry standardPbe = PGITestUtilities.CreatePriceBookEntryForProduct(standardProduct);
         insert standardPbe;
     	 Pricebook2 customPb = new Pricebook2(Name='Custom Pricebook', isActive = true);
     	 insert customPb;
     	 //PricebookEntry customPbe = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = standardProduct.Id, UnitPrice = 12000, IsActive = true);
     	 //insert customPbe;
     	 
     	 Opportunity testOpp= PGITestUtilities.getOpportunityDetails();  
     	 testOpp.Prob_Input__c='10';    
         insert testOpp;
         Opportunity retOpp = [SELECT Pricebook2Id FROM Opportunity where Id =:testOpp.Id];
         system.assertEquals(retOpp.Pricebook2Id, pricebookId);
         
         Account testAcc= PGITestUtilities.getAccountDetails();
         insert testAcc;  
         Contact cont= PGITestUtilities.getContactDetails(testAcc.Id);
         insert cont;
         Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id, testOpp.Id); 
         insert testQuote;
         Product__c testprod = PGITestUtilities.getProductDetails('Add-on', 'TestAddon','10111111') ;
         insert testProd;
         Solution__c testSoln = PGITestUtilities.getSolution();
         insert testSoln;
         Service__c testSer= PGITestUtilities.getService(testSoln.Id);
         insert testSer;
         QuoteLineItem testQli=PGITestUtilities.getServiceQuoteLineItem(testprod.Id,testSer.Id,testQuote.Id,standardPbe);
         insert testQli;
         testOpp.Prob_Input__c = '10';
         testOpp.Pricebook2Id = customPb.Id;
         update testOpp;
         Quote retQuote = [SELECT Pricebook2Id FROM Quote where Id =:testQuote.Id];
         system.assertEquals(retQuote.Pricebook2Id, testOpp.Pricebook2Id);
         Test.stopTest();
     }
}