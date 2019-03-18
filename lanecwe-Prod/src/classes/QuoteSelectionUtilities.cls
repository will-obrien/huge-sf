/********************************************************************************
Name:  QuoteSelectionUtilities()
Copyright © 2012  PGI
======================================================
======================================================
Purpose:
-------
This utlities has all insert/update methods for configure service page
======================================================
======================================================
History
-------
VERSION  AUTHOR                DATE                 DETAIL              FEATURES/CSR/TTP
  1.0 – Capgemini India          25/09/2012        Added 
********************************************************************************/    

public with sharing class QuoteSelectionUtilities {
        
    public static list<PGIProduct> getConfigureServiceUsage(set<Id> setQuoteLineIds,Id quoteId){
        list <PGIProduct> serviceList = new list <PGIProduct>();
        list<QuoteLineItem> QuotelineItems =new list <QuoteLineItem>(); 
        set<Id> setServiceIds= new set<Id>();
        map<Id,list<QuoteLineItem>> mapQuoteLineByService = new map<Id,list<QuoteLineItem>>();
        list <ServiceCategory__c> serviceLst = new list<ServiceCategory__c>(); 
        list<PGIProduct.ProductList> pgiProductUsageLst = new list<PGIProduct.ProductList>();           
        list<SelectOption> addOnProducts= new list<SelectOption>(); 
        list<SelectOption> ancillaryProducts= new list<SelectOption>();     
        list<QuoteLineItem> quoteLines= new list<QuoteLineItem>();                      
        QuoteLineItem serviceQuoteLine= new QuoteLineItem();        
                            
        QuotelineItems=[Select QuoteId, Product__c,Line_Margin_Over_Term__c, Id,Quote_Line_Item__c, Service__c,Quantity,Quantity__c,BidPrice__c ,Contract_Term__c,BidPriceChange__c,ContractTermChange__c,QuantityChange__c
                                    From QuoteLineItem  where QuoteId=:quoteId and (Id in :setQuoteLineIds or Quote_Line_Item__c in : setQuoteLineIds) order by Id];
        
        for(QuoteLineItem lineItem:QuotelineItems){             
            setServiceIds.add(lineItem.Service__c);         
            quoteLines = new list<QuoteLineItem>();             
            if(lineItem.Quote_Line_Item__c==null){                  
                quoteLines= mapQuoteLineByService.get(lineItem.Id);
                if(quoteLines==null){
                    quoteLines = new list<QuoteLineItem>();
                }
                quoteLines.add(lineItem);
                mapQuoteLineByService.put(lineItem.Id,quoteLines);                  
            }else{
                quoteLines= mapQuoteLineByService.get(lineItem.Quote_Line_Item__c);
                if(quoteLines==null){
                    quoteLines = new list<QuoteLineItem>();
                }
                quoteLines.add(lineItem);
                mapQuoteLineByService.put(lineItem.Quote_Line_Item__c,quoteLines);
            }
        }
        
        serviceLst=[Select s.Service__r.name, s.Service__c, s.Product__r.Min_Commit__c, s.Product__r.Name,s.Product__r.Id,s.Product__r.List_Rate__c, s.Product__r.Quantity__c,
                        s.Product__r.Cost_Rate__c, s.Product__r.Unit_of_Measure__c,s.Default__c,s.Product__r.ProductType__c,s.service__r.Solution__c,
                        s.Product__r.Term_Length__c,s.Product__r.Minimum_Quantity__c,s.Product__r.Maximum_Quantity__c,s.Product__r.Billing_Frequency__c 
                        ,s.Product__r.Regions__c,s.Product__r.Channels__c,s.Product__r.isPGILicense__c, s.Product__r.ProductCode__c, s.Product__r.CreatedById, s.Product__r.CreatedDate, s.Product__r.CurrencyIsoCode
                        ,s.Product__r.Description__c,s.Product__r.MaxMeeting__c From ServiceCategory__c s where  s.Service__c=:setServiceIds  order by s.Product__r.Billing_Frequency__c desc];
     
         Decimal currentRowId=0;    
        for(list<QuoteLineItem> lstQuoteLine: mapQuoteLineByService.Values() ){             
            serviceQuoteLine= new QuoteLineItem();  
            pgiProductUsageLst =  new list<PGIProduct.ProductList>();
            addOnProducts= new list<SelectOption>();            
            ancillaryProducts = new list<SelectOption>();
            for(QuoteLineItem aQuoteLine:lstQuoteLine){
                    if(aQuoteLine.Quote_Line_Item__c ==null){ 
                        serviceQuoteLine = aQuoteline;
                        break;
                    }
            }               

            set<Id> uniqueProductIds= new set<Id>();
            string serName ;
            
            for(QuoteLineItem aQuoteLine:lstQuoteLine){
                for(ServiceCategory__c scItem:serviceLst){  
                    if(scItem.Service__c==aQuoteLine.Service__c && scItem.Product__c==aQuoteLine.Product__c){
                        PGIProduct.ProductList aProductlist= new PGIProduct.ProductList(scItem, aQuoteLine);
                        currentRowId = currentRowId+1;
                        aProductlist.customRowId=currentRowId;
                        pgiProductUsageLst.add(aProductlist);
                        uniqueProductIds.add(scItem.Product__r.Id);
                        serName =scItem.Service__r.Name;
                    }                       
                }
            }
            PGIProduct proddetails=new PGIProduct(serviceQuoteLine,serName);
            for( PGIProduct.ProductList aQuoteLine : pgiProductUsageLst){
                for(ServiceCategory__c scItem:serviceLst){  
                    if(scItem.Service__c==aQuoteLine.ServiceId && !uniqueProductIds.contains(scItem.Product__r.Id) ){
                            if(scItem.Product__r.ProductType__c=='Add-on'){
                                addOnProducts.add(new SelectOption(scItem.Product__r.Id,scItem.Product__r.Name));                   
                            } else if(scItem.Product__r.ProductType__c=='Ancillary'){
                                ancillaryProducts.add(new SelectOption(scItem.Product__r.Id,scItem.Product__r.Name));
                            }
                            uniqueProductIds.add(scItem.Product__r.Id);
                    }
                }                   
            }
            proddetails.latestRowId = currentRowId;
            proddetails.productOptions = addOnProducts;  
            proddetails.ancillaryOptions = ancillaryProducts;                
            proddetails.productLst = pgiProductUsageLst;    
            serviceList.add(proddetails);
        }
        return serviceList;
    }       
            
    /*****************************************************************************************
    Produsage for default products
    *******************************************************************************************/
    public static list<PGIProduct> getDefaultUsage(set<Id> ServcId){

        list <PGIProduct> pusagelsts = new list <PGIProduct>();
        list<PGIProduct.ProductList> pgiProductUsageLst = new list<PGIProduct.ProductList>();
        list<SelectOption> addOnProducts= new list<SelectOption>();         
        list<SelectOption> ancillaryProducts= new list<SelectOption>();         
        list <ServiceCategory__c> serviceLst = new list<ServiceCategory__c>();      
        
		serviceLst=[Select s.Service__r.name, s.Service__c, s.Product__r.Min_Commit__c, s.Product__r.Name,s.Product__r.Id,s.Product__r.List_Rate__c, s.service__r.Solution__c,
				s.Product__r.Cost_Rate__c, s.Product__r.Unit_of_Measure__c,s.Default__c,s.Product__r.ProductType__c,
				s.Product__r.Term_Length__c,s.Product__r.Minimum_Quantity__c,s.Product__r.Maximum_Quantity__c,s.Product__r.Billing_Frequency__c 
				,s.Product__r.Regions__c,s.Product__r.Channels__c,s.Product__r.isPGILicense__c,s.Product__r.ProductCode__c, s.Product__r.CreatedById, s.Product__r.CreatedDate, s.Product__r.CurrencyIsoCode
				,s.Product__r.Description__c,s.Product__r.MaxMeeting__c  From ServiceCategory__c s where  s.Service__c=:ServcId   and s.Product__r.is_Active__c=true order by s.Product__r.ProductType__c desc ,s.Product__r.Name];
       
         
        Decimal currentRowId=0;             
        set<Id> uniqueSetId= new set<Id>();
        for(ServiceCategory__c Sc:serviceLst){
            if(!uniqueSetId.contains(Sc.Service__c)){
                PGIProduct proddetails=new PGIProduct(Sc);                  
                for(ServiceCategory__c Pc: serviceLst){

                    if( Pc.Service__c ==Sc.Service__c){   
                         
                        if(pc.Default__c){
                            PGIProduct.ProductList aProductlist= new PGIProduct.ProductList(pc);
                            currentRowId = currentRowId+1;
                            aProductlist.customRowId=currentRowId;
                            pgiProductUsageLst.add(aProductlist);
                                
                        } else{
                            if(pc.Product__r.ProductType__c=='Add-on'){
                                addOnProducts.add(new SelectOption(pc.Product__r.Id,pc.Product__r.Name));
                            } else if(pc.Product__r.ProductType__c=='Ancillary'){
                                ancillaryProducts.add(new SelectOption(pc.Product__r.Id,pc.Product__r.Name));
                            }
                        }
                        
                    }
                }
               
                proddetails.productOptions = addOnProducts;   
                proddetails.ancillaryOptions = ancillaryProducts;                
                proddetails.productLst = pgiProductUsageLst;
                proddetails.latestRowId = currentRowId;
                uniqueSetId.add(Sc.Service__c);
                pgiProductUsageLst =  new list<PGIProduct.ProductList>();
                addOnProducts= new list<SelectOption>();
                ancillaryProducts = new list<SelectOption>();
                pusagelsts.add(proddetails);
            }
        }
        return pusagelsts;
    }
    
    /***************************************************************************
    Method to insert QuoteLineItem
    ****************************************************************************/ 
    public static boolean insertQuoteItems(string quoteId, list<PGIProduct>ProdUsageDetails){
        try{            
            
            list<QuoteLineItem> insertQuoteLineItems =new list <QuoteLineItem>();
            list<QuoteLineItem> insertServiceLineItems =new list <QuoteLineItem>();
            list<QuoteLineItem> UpdatableLineItems =new list <QuoteLineItem>();
            
            set<Id> ProductIds = new set<Id>();
            set<Id> serviceIds = new set<Id>();
            Map<Id, set<Id>> MapserviceProductIds= new Map<Id,set<Id>>();
            
            set<Id> defaultProductIds = new set<Id>();
            Map<Id, set<Id>> defaultMapSerProdIds= new Map<Id,set<Id>>();
            list<QuoteLineItem> serviceLineItems= new list<QuoteLineItem>();        
            Map<Id, Id> ServiceQuoteLineId = new Map<Id,Id>();
                        
            //Adding Validation function to verify the Default product has values...            
            for(PGIProduct Pr:ProdUsageDetails){
                serviceIds.add(Pr.serviceId);
                ProductIds = new set<Id>();
                for(PGIProduct.ProductList prod: Pr.productLst){
                    if(prod.productId!=null){
                        if(prod.Quantity !=null || prod.Bidprice!=null){                
                            ProductIds.add(prod.productId);                 
                        }
                    }
                }
                MapserviceProductIds.put(pr.serviceId,ProductIds);
            }           
            list <ServiceCategory__c> serviceCategorylist =[Select s.service__r.Solution__c, s.Service__c,s.Service__r.name,s.default__c, s.Product__r.Name ,s.Product__r.Id ,s.Product__r.Cost_Rate__c ,s.Product__c ,
                                                                s.Product__r.Auth_Rate6__c, s.Product__r.Auth_Rate5__c,s.Product__r.List_Rate__c,s.Product__r.Auth_Rate4__c, s.Product__r.Auth_Rate3__c, s.Product__r.Auth_Rate2__c, s.Product__r.Auth_Rate1__c,s.Product__r.MaxMeeting__c  From ServiceCategory__c s where s.Service__c=:serviceIds ];
           //to check whether the package default products and wraper list products are same 
            for(ServiceCategory__c Pr:serviceCategorylist){   
                        
                if(pr.default__c && !MapserviceProductIds.get(pr.service__c).contains(pr.Product__c)){
                    return false;
                }
            }           
            
            quote q=[Select Id, CurrencyIsoCode, IsCloned__c, Owner_Region__c, Pricebook2Id From Quote where id =:quoteId];
            boolean isQuoteCloned = false;
            if (q != null)
            {
            	isQuoteCloned = q.IsCloned__c;
            }
            
            List<PricebookEntry> PBE = [select id, name, CurrencyIsoCode ,Product2.name, Product2.Cost_Rate__c from PriceBookEntry where
                                                        Pricebook2id =:q.Pricebook2Id and Product2.Name=:PGIAppConstants.STANDARD_PRODUCT_NAME and
                                                        currencyisocode =: q.currencyisocode];
            if (PBE == null || PBE.isEmpty())
            {        
            	PGIProductHelper helper = new PGIProductHelper();
            	PBE.add(helper.createPbEntryForProduct(q.Pricebook2Id));
            }
            
           
            for(PGIProduct Pr:ProdUsageDetails){
                
                for(PGIProduct.ProductList aProdItem:pr.productLst){
                        if(aProdItem.productId!=null){
                            QuoteLineItem q1= new QuoteLineItem();
                            q1.QuoteId=q.Id;
                            q1.Quantity__c= aProdItem.Quantity;
                            q1.Quantity=1;
                            q1.BidPrice__c=aProdItem.Bidprice;               
                            q1.PricebookEntryId = PBE[0].Id;
                            q1.UnitPrice=aProdItem.ListRate;
                            q1.Product__c=aProdItem.productId;
                            q1.Service__c = aProdItem.serviceId;
                            q1.Contract_Term__c = aProdItem.termLength;
                            q1.Billing_Frequency__c = aProdItem.billingFrequency;
                            q1.Cost_Rate__c = aProdItem.costRate; 
                            q1.solution__c = aProdItem.solutionId;
                            q1.Min_Commit__c = aProdItem.minCommit;
                            if(isQuoteCloned){
                                q1.ChangeType__c='New Service';
                            }
                            if(aProdItem.isServiceProduct){
                                q1.IsServiceProduct__c =true;
                                insertServiceLineItems.add(q1);
                            }
                            else{
                                UpdatableLineItems.add(q1); 
                            }
                        }
                }
            }       
                    
            string LevelAuthority =[Select Level_Of_Authority__c from user where Id=:userinfo.getUserid()].Level_Of_Authority__c;
            
            QuoteStatusUtilities.QUOTE_OWNER_REGION = q.Owner_Region__c;
            list<QuoteLineItem> lstQuoteServiceLineWithStatus= QuoteStatusUtilities.updateQuoteLineItemApprovalStatus(insertServiceLineItems, serviceCategorylist,LevelAuthority);
            insert lstQuoteServiceLineWithStatus;       
            // to get the Master Quote Line Item Id
            serviceLineItems = [Select Id, Service__c From QuoteLineItem where Id=:lstQuoteServiceLineWithStatus];
            
            for(QuoteLineItem lineItem:serviceLineItems){
                ServiceQuoteLineId.put(lineItem.service__c,lineItem.Id);
            }
            
            for(QuoteLineItem lineItem: UpdatableLineItems){
                
                lineItem.Quote_Line_Item__c=ServiceQuoteLineId.get(lineItem.service__c);
                insertQuoteLineItems.add(lineItem);
            }       
            
            try{
                list<QuoteLineItem> lstQuoteLineWithStatus= QuoteStatusUtilities.updateQuoteLineItemApprovalStatus(insertQuoteLineItems, serviceCategorylist, LevelAuthority);
                insert lstQuoteLineWithStatus;      
            }catch(Exception ex){               
                delete [Select Id, Service__c From QuoteLineItem where Id=:lstQuoteServiceLineWithStatus];
                return false;
            }
            QuoteStatusUtilities.updateQuoteStatus(quoteId, QCStatusValues__c.getInstance(PGIQuoteStatusEnum.QuoteInProgress.name()).StatusValue__c, QuoteStatusUtilities.getApprovalRequiredStatus(QuoteId));
        }catch (Exception ex){
            PGIErrorUtilities.logPgiError('QuoteSelectionUtilities:insertQuoteItems()',ex.getMessage(),PGIErrorUtilities.LoggingLevel.DEBUG);
            system.debug(LoggingLevel.ERROR,'Error When inserting quote line item '+ex.getMessage());     
            return false;
        }
    return true;
    }   
    
    public static boolean configureQuoteLineItem(list<PGIProduct> productServices,Id quoteId){      
        try{
            list<QuoteLineItem> insertServiceLineItems =new list <QuoteLineItem>();
            list<QuoteLineItem> UpdatableLineItems =new list <QuoteLineItem>();
            set<Id> ProductIds = new set<Id>();
            set<Id> serviceIds = new set<Id>();
            Map<Id, set<Id>> MapserviceProductIds= new Map<Id,set<Id>>();
            set<Id> quoteLineItemIds = new set<id>();       
            Map<Id,QuoteLineItem> MapQuoteLines= new Map<Id,QuoteLineItem>();       
            
            //Adding Validation function to verify the Default product has values...            
            for(PGIProduct Pr:productServices){
                serviceIds.add(Pr.serviceId);
                ProductIds = new set<Id>();
                for(PGIProduct.ProductList prod: Pr.productLst){    
                    if(prod.Quantity !=null || prod.BidPrice!=null){                
                        ProductIds.add(prod.productId);                     
                        quoteLineItemIds.add(prod.quotelineItemId);                 
                    }
                    
                }
                MapserviceProductIds.put(pr.serviceId,ProductIds);
            }           
            
            list <ServiceCategory__c> serviceCategorylist =[Select  s.Service__c,s.Service__r.name,s.default__c, s.Product__r.Name ,s.service__r.Solution__c,s.Product__r.Id ,s.Product__r.Cost_Rate__c ,s.Product__c ,
                                                                s.Product__r.Auth_Rate6__c, s.Product__r.Auth_Rate5__c,s.Product__r.List_Rate__c,s.Product__r.Auth_Rate4__c, s.Product__r.Auth_Rate3__c, s.Product__r.Auth_Rate2__c, s.Product__r.Auth_Rate1__c,s.Product__r.MaxMeeting__c From ServiceCategory__c s where s.Service__c=:serviceIds ];
        
            for(ServiceCategory__c Pr:serviceCategorylist){     
                        
                if(pr.default__c && !MapserviceProductIds.get(pr.service__c).contains(pr.Product__c)){
                    //system.debug('enterMapservice');
                    return false;
                }
            }
            quote q=[Select Id, CurrencyIsoCode, IsCloned__c, Pricebook2Id, Owner_Region__c From Quote where id =:quoteId];
        
            List<PricebookEntry> PBE = [select id, name, CurrencyIsoCode ,Product2.name,Product2.Cost_Rate__c from PriceBookEntry where
                                        Pricebook2id =: q.Pricebook2Id and Product2.Name =:PGIAppConstants.STANDARD_PRODUCT_NAME and
                                        currencyisocode =: q.currencyisocode];  
            
            if (PBE == null || PBE.isEmpty())
            {        
            	PGIProductHelper helper = new PGIProductHelper();
            	PBE.add(helper.createPbEntryForProduct(q.Pricebook2Id));
            }         
            
            list<QuoteLineItem> allQuoteLineItems= [Select QuoteId,Line_Margin_Over_Term__c, Product__c, Id,Quote_Line_Item__c, Service__c,Quantity,BidPrice__c,QuantityChange__c,ContractTermChange__c,BidPriceChange__c 
                                                                                From QuoteLineItem  where QuoteId=:quoteId and id in : quoteLineItemIds];
            
            boolean isQuoteCloned=q.IsCloned__c;    
                                                                                  
            for(quoteLineItem aLineItem:allQuoteLineItems){
                MapQuoteLines.put(aLineItem.id,alineItem);
            }                                                                               
            for(PGIProduct Pr:productServices){
                
                for(PGIProduct.ProductList aProdItem:pr.productLst){
                    QuoteLineItem q1= new QuoteLineItem();
                        if(aProdItem.quoteLineItemId ==null){                           
                            q1.QuoteId=q.Id;
                            q1.Quantity__c= aProdItem.Quantity;
                            q1.Quantity=1;
                            q1.BidPrice__c=aProdItem.Bidprice;               
                            q1.PricebookEntryId = PBE[0].Id;
                            q1.UnitPrice=aProdItem.ListRate;
                            q1.Product__c=aProdItem.productId;
                            q1.Service__c = aProdItem.serviceId;
                            q1.solution__c = aProdItem.solutionId;
                            q1.Quote_Line_Item__c = aProdItem.masterServiceId;
                            q1.Contract_Term__c = aProdItem.termLength;
                            q1.Billing_Frequency__c = aProdItem.billingFrequency; 
                            if(isQuoteCloned){
                            q1.QuantityChange__c=aProdItem.oldQuantity;
                            q1.ContractTermChange__c=aProdItem.oldtermLength;
                            q1.BidPriceChange__c=aProdItem.oldbidPrice;
                            q1.ChangeType__c='New Addon';
                            q1.Min_Commit__c = aProdItem.minCommit;
                            }
                            
                            insertServiceLineItems.add(q1); 
                        } else{
                            q1 = MapQuoteLines.get(aProdItem.quoteLineItemId );
                            q1.Quantity__c= aProdItem.Quantity;
                            q1.Quantity=1;
                            q1.BidPrice__c=aProdItem.Bidprice;
                            q1.solution__c = aProdItem.solutionId;
                            q1.Billing_Frequency__c = aProdItem.billingFrequency;
                            q1.Min_Commit__c = aProdItem.minCommit;
                            q1.Contract_Term__c = aProdItem.termLength; 
                           
                           if(isQuoteCloned){
                                q1.QuantityChange__c=aProdItem.oldQuantity;
                                q1.ContractTermChange__c=aProdItem.oldtermLength;
                                q1.BidPriceChange__c=aProdItem.oldbidPrice;
                           }
                            
                            insertServiceLineItems.add(q1); 
                        }                   
                }
            }   
          QuoteStatusUtilities.QUOTE_OWNER_REGION = q.Owner_Region__c;
           string LevelAuthority =[Select Level_Of_Authority__c from user where Id=:userinfo.getUserid()].Level_Of_Authority__c;
        //    string LevelAuthority=[select LevelofAuthority__c from Quotelineitem where quoteid=:quoteId].levelofauthority__c ;
            list<QuoteLineItem> lstQuoteServiceLineWithStatus= QuoteStatusUtilities.updateQuoteLineItemApprovalStatus(insertServiceLineItems, serviceCategorylist,LevelAuthority);
            system.debug('lstQuoteServiceLineWithStatus $$$$$$$ '+lstQuoteServiceLineWithStatus);
            upsert lstQuoteServiceLineWithStatus;               
            QuoteStatusUtilities.updateQuoteStatus(quoteId, QCStatusValues__c.getInstance(PGIQuoteStatusEnum.QuoteInProgress.name()).StatusValue__c, QuoteStatusUtilities.getApprovalRequiredStatus(QuoteId));
        }catch (Exception ex){
            PGIErrorUtilities.logPgiError('QuoteSelectionUtilities:configureQuoteLineItem()',ex.getMessage(),PGIErrorUtilities.LoggingLevel.DEBUG);
            system.debug(LoggingLevel.ERROR,'Error When inserting quote '+ex.getMessage());    
            return false;
        }
    return true;
    }
    
    public static list<PGIProduct.ProductList> getProducts(set<Id>ServId){
        list<PGIProduct> prodLst = new list<PGIProduct>();
        list<ServiceCategory__c> Proddetails = new list<ServiceCategory__c>();      
        Proddetails=[Select s.Service__r.name, s.Product__r.Min_Commit__c, s.Product__r.name,s.Product__r.Id,s.Product__c,s.Service__c,s.Service__r.Solution__c,
                    s.product__r.productType__c,s.Default__c,s.Product__r.List_Rate__c, s.Product__r.Cost_Rate__c, s.Product__r.Unit_of_Measure__c,
                    s.Product__r.Term_Length__c,s.Product__r.Minimum_Quantity__c,s.Product__r.Maximum_Quantity__c,s.Product__r.Billing_Frequency__c 
                    ,s.Product__r.Regions__c,s.Product__r.isPGILicense__c,s.Product__r.Channels__c,s.Product__r.ProductCode__c, s.Product__r.CreatedById, s.Product__r.CreatedDate, s.Product__r.CurrencyIsoCode
                    ,s.Product__r.Description__c , s.Product__r.MaxMeeting__c From ServiceCategory__c s where s.Service__c=:ServId and s.Product__r.is_Active__c=true and s.Product__r.ProductType__c ='Service'order by s.service__r.Name asc];
       //system.debug('**Proddetails**'+Proddetails);
        set<Id> uniqueSetId= new set<Id>();
        list<PGIProduct.ProductList> pgiProductLst = new list<PGIProduct.ProductList>();
        for(ServiceCategory__c Sc:Proddetails){        
            if(!uniqueSetId.contains(Sc.Service__c)){
                                pgiProductLst.add( new PGIProduct.ProductList(Sc));
                uniqueSetId.add(Sc.Service__c);
            }
        }
        return pgiProductLst;
    }
        
    /*****************************************************************************************
    Produsage for Additional products
    *******************************************************************************************/        
    public static list<PGIProduct> getAdditionalUsage(set<Id> ServcId ,list<Id> productId, Decimal currentRowId){
        if(currentRowId==null){
            currentRowId=0;
        }
        list <PGIProduct> pusagelsts = new list <PGIProduct>();
        list <PGIProduct.ProductList> pgiProductUsageLst = new list<PGIProduct.ProductList>();
        list <ServiceCategory__c> Sclst = new list<ServiceCategory__c>(); 
        Sclst=[Select s.Service__r.name, s.Service__c, s.Product__r.Min_Commit__c, s.Product__r.List_Rate__c,s.product__r.productType__c, s.service__r.Solution__c,s.Product__r.Cost_Rate__c, s.Product__r.Unit_of_Measure__c,s.Product__r.Name ,s.Default__c,
                s.Product__r.Id,s.Product__r.Term_Length__c,s.Product__r.Minimum_Quantity__c,s.Product__r.Maximum_Quantity__c,s.Product__r.Billing_Frequency__c 
                ,s.Product__r.Regions__c,s.Product__r.isPGILicense__c,s.Product__r.Channels__c, s.Product__r.ProductCode__c, s.Product__r.CreatedById, s.Product__r.CreatedDate, s.Product__r.CurrencyIsoCode
                ,s.Product__r.Description__c,s.Product__r.MaxMeeting__c  From ServiceCategory__c s where  s.Product__r.Id in :productId and s.Product__r.is_Active__c=true and s.Service__c=:ServcId ];
        set<Id> uniqueSetId= new set<Id>();
        for(ServiceCategory__c Sc:Sclst){
            if(!uniqueSetId.contains(Sc.Service__c)){
                PGIProduct proddetails=new PGIProduct(Sc);
                    for(ServiceCategory__c Pc: Sclst){
                        if( Pc.Service__c ==Sc.Service__c){   
                            PGIProduct.ProductList aProductlist= new PGIProduct.ProductList(pc);
                            currentRowId = currentRowId+1;
                            aProductlist.customRowId=currentRowId;
                            pgiProductUsageLst.add(aProductlist);
                        }
                    }
                proddetails.productLst = pgiProductUsageLst;
                proddetails.latestRowId = currentRowId;
                uniqueSetId.add(Sc.Service__c);
                pusagelsts.add(proddetails);                
            }
        }
        return pusagelsts;
    }
    
    //to validate ServiceBillingFreuency
    public static boolean validateServiceBillingFrequency(list<PGIProduct>ProdUsageDetails){
        try{
            Set<string>servBillingFrequency= new Set<string>();
          for(PGIProduct Pr:ProdUsageDetails){
                for(PGIProduct.ProductList prod: Pr.productLst){
                    if(prod.isServiceProduct && prod.isPGILicense){
                            servBillingFrequency.add(prod.billingFrequency);
                    }
                }
            }
            
            if(servBillingFrequency.contains('Annually') && servBillingFrequency.contains('Monthly')){
                return true;
            }else{
                return false;
            }
         }
         catch (Exception ex){
            PGIErrorUtilities.logPgiError('QuoteSelectionUtilities:validateServiceBillingFrequency()',ex.getMessage(),PGIErrorUtilities.LoggingLevel.INFO);
            system.debug(LoggingLevel.ERROR,'Error When validating ServiceBillingFrequency  '+ex.getMessage()); 
            return false;
         }
    
    }
    
    public static Boolean hasNegativeMinCommitQuantity(List<PGIProduct> ProdUsageDetails, List<String> errorMessageInputs)
    {
    	Boolean hasNegativeMinCommitQuantity = false;
    	Set<Id> serviceProductIds = new Set<Id>();
    	if (ProdUsageDetails != null && !ProdUsageDetails.isEmpty())
    	{
	    	for (PGIProduct pgiProduct : ProdUsageDetails)
	    	{
	    		Integer quantity;
	    		PGIProduct.ProductList minAudioProd;
	    		PGIProduct.ProductList domDialProd;
	    		Boolean hasMinCommitProd = false;
	    		for(PGIProduct.ProductList prod : pgiProduct.productLst)
	    		{
	    			if (prod.isServiceProduct)
	    			{
	    				quantity = prod.quantity;
	    			}
	    			else if (prod.minCommit)
	    			{
	    				hasMinCommitProd = true;
	    			}
	    			if (hasMinCommitProd)
	    			{
		    			if (prod.productName != null && prod.productName.startsWith(PGIAppConstants.MIN_COMMIT_AUDIO_MIN_PRODNAME))
						{
							minAudioProd = prod;
						}
						else if (prod.productName != null && prod.productName.startsWith(PGIAppConstants.MIN_COMMIT_DOM_DIAL_PRODNAME))
						{
							domDialProd = prod;
						}
	    			}
	    			if (quantity != null && minAudioProd != null && domDialProd != null)
	    			{
	    				
	    				Integer minCommitQuantity = (Integer)(minAudioProd.Bidprice/domDialProd.BidPrice);
	    				if (quantity < minCommitQuantity)
	    				{
	    					errorMessageInputs.add(minAudioProd.productName);
	    					errorMessageInputs.add(String.valueOf(minAudioProd.Bidprice));
	    					errorMessageInputs.add(domDialProd.productName);
	    					errorMessageInputs.add(String.valueOf(domDialProd.Bidprice));
	    					errorMessageInputs.add(String.valueOf(minCommitQuantity));
	    					errorMessageInputs.add(String.valueOf(quantity));
	    					hasNegativeMinCommitQuantity = true;
	    					break;
	    				}
	    			}
	    		}
	    	}
    	}
    	return hasNegativeMinCommitQuantity;
    }

    /************************* TEST METHODS SECTION *********************************************/
    
    //Test Method for getConfigureServiceUsage
    @istest (seeAlldata=true) 
    public static void test_getConfigureServiceUsage() {
        //Testdata preparation-Users
        User testUser1=PGITestUtilities.getTestUser(PGITestUtilities.getAdminProfile());
        testUser1.firstName='TestUser1';
        testUser1.Level_Of_Authority__c='Level 1';
        insert testUser1;
        
        Account testAcc= PGITestUtilities.getAccountDetails();
        insert testAcc;
        Opportunity testOpp= PGITestUtilities.getOpportunityDetails();      
        insert testOpp;
        Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
        cont.email='hsoni@salesforce.com';
        cont.title='mr';
        insert cont;
        Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        insert testQuote;
        Region__c region = PGITestUtilities.getRegionDetails();
        insert region;
        list<Product__c> allProduct= new list<Product__c>();
        Product__c testprod1 = PGITestUtilities.getProductDetails('Add-on', 'TestAddon','10111111');
        insert testProd1;       
        Product__c testprod2 = PGITestUtilities.getProductDetails('Ancillary', 'TestAncillary','20111111');
        insert testProd2;
        Product__c testprod3= PGITestUtilities.getProductDetails('Service', 'testserv','30111111');
        insert testProd3;
        Solution__c testSoln = PGITestUtilities.getSolution();
        insert testSoln;
        Service__c testSer= PGITestUtilities.getService(testSoln.Id);
        insert testSer;
        ServiceCategory__c testSc1= PGITestUtilities.getSerCategory(testSer.Id, testProd3.Id, true);
        insert testSc1;
        ServiceCategory__c testSc2= PGITestUtilities.getSerCategory(testSer.Id, testProd2.Id, true);
        insert testSc2;
        ServiceCategory__c testSc3= PGITestUtilities.getSerCategory(testSer.Id, testProd1.Id, true);
        insert testSc3;
            
        PriceBook2 pb2Standard = [select Id from Pricebook2 where isStandard=true];
        string standardPriceBookId = pb2Standard.Id;
        
        Product2 testProd= PGITestUtilities.getStdProduct();        
        insert testProd;
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=standardPriceBookId, Product2Id=testProd.Id, UnitPrice=99, isActive=true);
        insert pbe;         
        list<ServiceCategory__c> lstSc=[Select s.Service__r.name, s.Product__r.Min_Commit__c, s.Product__r.name,s.Product__r.Id,s.Product__c,s.Service__c,s.Service__r.Solution__c,
                        s.product__r.productType__c,s.Default__c,s.Product__r.List_Rate__c, s.Product__r.Cost_Rate__c, s.Product__r.Unit_of_Measure__c,
                        s.Product__r.Term_Length__c,s.Product__r.Minimum_Quantity__c,s.Product__r.Maximum_Quantity__c,s.Product__r.Billing_Frequency__c 
                        ,s.Product__r.Regions__c,s.Product__r.Channels__c,s.Product__r.ProductCode__c,s.Product__r.isPGILicense__c,s.Product__r.CreatedById, s.Product__r.CreatedDate, s.Product__r.CurrencyIsoCode
                        ,s.Product__r.Description__c,s.Product__r.MaxMeeting__c From ServiceCategory__c s where Id=:testSc1.id or id=:testSc2.Id or id=:testSc3.Id];
                        
        list<QuoteLineItem> testLneItem= new list<QuoteLineItem>();     
        ServiceCategory__c aSerProdCate = new ServiceCategory__c();
        for(ServiceCategory__c aSerCate:lstSc){
            if(aSerCate.Id==testSc1.id){
                aSerProdCate = aSerCate;
            } else{
                PGIProduct.ProductList testPGIpro= new PGIProduct.ProductList(aSerCate);            
                //Insert the QuoteLineItem
                QuoteLineItem aLineItem = PGITestUtilities.getQuoteLineDetails(testQuote, testPGIpro,pbe.Id); 
                testLneItem.add(aLineItem);
            }
        }
        PGIProduct.ProductList testPGIpro= new PGIProduct.ProductList(aSerProdCate);            
        //Insert the QuoteLineItem
        QuoteLineItem testserLneItem = PGITestUtilities.getQuoteLineDetails(testQuote, testPGIpro,pbe.Id); 
       //Case 1:
        list<PGIProduct> testCase1ProductLst = new list<PGIProduct>();
        test.startTest();
        system.runAs(testUser1) {
            insert testserLneItem;
            list<QuoteLineItem> testQuotelne= new list<QuoteLineItem>();
            for(QuoteLineItem aLineItem : testLneItem){
                aLineItem.Quote_Line_Item__c=testserLneItem.id;
                aLineItem.service__c=testSer.Id;
                testQuotelne.add(aLineItem);
            }
            insert testQuotelne;
            testCase1ProductLst =  QuoteSelectionUtilities.getConfigureServiceUsage(new set<id> {testserLneItem.Id}, testQuote.Id);       
        }
        //case 1:
        system.assertEquals(testCase1ProductLst.size(),1);
       test.stopTest();
    }
    
    //Test Method for getDefaultUsage
    @istest (seeAlldata=false) 
    public static void test_getDefaultUsage() {
        //Testdata preparation-Users
        User testUser1=PGITestUtilities.getTestUser(PGITestUtilities.getAdminProfile());
        testUser1.firstName='TestUser1';
        testUser1.Level_Of_Authority__c='Level 1';
        insert testUser1;
        
        Account testAcc= PGITestUtilities.getAccountDetails();
        insert testAcc;
        Opportunity testOpp= PGITestUtilities.getOpportunityDetails();      
        insert testOpp;
        Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
        cont.email='hsoni@salesforce.com';
        cont.title='mr';
        insert cont;
        Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        insert testQuote;
        Region__c region = PGITestUtilities.getRegionDetails();
        insert region;
        list<Product__c> allProduct= new list<Product__c>();
        Product__c testprod1 = PGITestUtilities.getProductDetails('Add-on', 'TestAddon','10111111');
        insert testProd1;       
        Product__c testprod2 = PGITestUtilities.getProductDetails('Ancillary', 'TestAncillary','20111111');
        insert testProd2;
        Product__c testprod3= PGITestUtilities.getProductDetails('Service', 'testserv','30111111');
        insert testProd3;
        Solution__c testSoln = PGITestUtilities.getSolution();
        insert testSoln;
        Service__c testSer= PGITestUtilities.getService(testSoln.Id);
        insert testSer;
        ServiceCategory__c testSc1= PGITestUtilities.getSerCategory(testSer.Id, testProd3.Id, true);
        insert testSc1;
        ServiceCategory__c testSc2= PGITestUtilities.getSerCategory(testSer.Id, testProd2.Id, true);
        insert testSc2;
        ServiceCategory__c testSc3= PGITestUtilities.getSerCategory(testSer.Id, testProd1.Id, true);
        insert testSc3;
    
       //Case 1:
        list<PGIProduct> testCase1ProductLst = new list<PGIProduct>();
        test.startTest();
        system.runAs(testUser1) {   
            testCase1ProductLst =  QuoteSelectionUtilities.getDefaultUsage(new set<Id> {testSer.Id});         
        }
        //case 1:
        system.assertEquals(testCase1ProductLst.size(),1);
        system.assertEquals(testCase1Productlst[0].productLst.size(),3);
       test.stopTest();
    }
    
    //Test Method for insertQuoteLineItem
    @istest (seeAlldata=true) 
    public static void test_insertQuoteLineItem() {
        //Testdata preparation-Users
        User testUser1=PGITestUtilities.getTestUser(PGITestUtilities.getAdminProfile());
        testUser1.firstName='TestUser1';
        testUser1.Level_Of_Authority__c='Level 1';
        insert testUser1;
        
        Account testAcc= PGITestUtilities.getAccountDetails();
        insert testAcc;
        Opportunity testOpp= PGITestUtilities.getOpportunityDetails();      
        insert testOpp;
        Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
        cont.email='hsoni@salesforce.com';
        cont.title='mr';
        insert cont;
        Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        insert testQuote;
        Region__c region = PGITestUtilities.getRegionDetails();
        insert region;
        list<Product__c> allProduct= new list<Product__c>();
        Product__c testprod1 = PGITestUtilities.getProductDetails('Add-on', 'TestAddon','10111111');
        insert testProd1;       
        Product__c testprod2 = PGITestUtilities.getProductDetails('Ancillary', 'TestAncillary','20111111');
        insert testProd2;
        Product__c testprod3= PGITestUtilities.getProductDetails('Service', 'testserv','30111111');
        insert testProd3;
        Solution__c testSoln = PGITestUtilities.getSolution();
        insert testSoln;
        Service__c testSer= PGITestUtilities.getService(testSoln.Id);
        insert testSer;
        ServiceCategory__c testSc1= PGITestUtilities.getSerCategory(testSer.Id, testProd3.Id, true);
        insert testSc1;
        ServiceCategory__c testSc2= PGITestUtilities.getSerCategory(testSer.Id, testProd2.Id, false);
        insert testSc2;
        ServiceCategory__c testSc3= PGITestUtilities.getSerCategory(testSer.Id, testProd1.Id, false);
        insert testSc3;
        PriceBook2 pb2Standard = [select Id from Pricebook2 where isStandard=true];
        string standardPriceBookId = pb2Standard.Id;
        
        Product2 testProd= PGITestUtilities.getStdProduct();        
        insert testProd;
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=standardPriceBookId, Product2Id=testProd.Id, UnitPrice=99, isActive=true);
        insert pbe;    
        list<PGIProduct> testCaseProductLst = new list<PGIProduct>();
        testCaseProductLst =  QuoteSelectionUtilities.getDefaultUsage(new set<Id> {testSer.Id});
            
       //Case 1: -ve without correct values     
        boolean testCase1Status;
        test.startTest();
       // system.runAs(testUser1) {               
           // testCase1Status = QuoteSelectionUtilities.insertQuoteItems(testQuote.Id, testCaseProductLst);
       // }
        //case 1:
       // system.assertEquals(testCase1Status,false);   
        //Case 2; with correct values
         for(PGIProduct Pr:testCaseProductLst){ 
                for(PGIProduct.ProductList prod: Pr.productLst){    
                    prod.Quantity=10;
                    prod.BidPrice =10.0;                    
                }
         }  
        boolean testCase2Status;        
        system.runAs(testUser1) {               
            testCase2Status = QuoteSelectionUtilities.insertQuoteItems(testQuote.Id, testCaseProductLst);
        }         
        /*Changed*/
        //system.assertEquals(testCase2Status,true);      
        test.stopTest();
    }
    
      //Test Method for configureQuoteLineItem
    @istest (seeAlldata=true) 
    public static void test_configureQuoteLineItem() {
        //Testdata preparation-Users
        User testUser1=PGITestUtilities.getTestUser(PGITestUtilities.getAdminProfile());
        testUser1.firstName='TestUser1';
        testUser1.Level_Of_Authority__c='Level 1';
        insert testUser1;
        
        Account testAcc= PGITestUtilities.getAccountDetails();
        insert testAcc;
        Opportunity testOpp= PGITestUtilities.getOpportunityDetails();      
        insert testOpp;
        Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
        cont.email='hsoni@salesforce.com';
        cont.title='mr';
        insert cont;
        Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        insert testQuote;
        Region__c region = PGITestUtilities.getRegionDetails();
        insert region;
        list<Product__c> allProduct= new list<Product__c>();
        Product__c testprod1 = PGITestUtilities.getProductDetails('Add-on', 'TestAddon','10111111');
        insert testProd1;       
        Product__c testprod2 = PGITestUtilities.getProductDetails('Ancillary', 'TestAncillary','20111111');
        insert testProd2;
        Product__c testprod3= PGITestUtilities.getProductDetails('Service','testserv','30111111');
        insert testProd3;
        Solution__c testSoln = PGITestUtilities.getSolution();
        insert testSoln;
        Service__c testSer= PGITestUtilities.getService(testSoln.Id);
        insert testSer;
        ServiceCategory__c testSc1= PGITestUtilities.getSerCategory(testSer.Id, testProd3.Id, true);
        insert testSc1;
        ServiceCategory__c testSc2= PGITestUtilities.getSerCategory(testSer.Id, testProd2.Id, false);
        insert testSc2;
        ServiceCategory__c testSc3= PGITestUtilities.getSerCategory(testSer.Id, testProd1.Id, false);
        insert testSc3;
        PriceBook2 pb2Standard = [select Id from Pricebook2 where isStandard=true];
        string standardPriceBookId = pb2Standard.Id;
        
        Product2 testProd= PGITestUtilities.getStdProduct();        
        insert testProd;
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=standardPriceBookId, Product2Id=testProd.Id, UnitPrice=99, isActive=true);
        insert pbe;    
        list<PGIProduct> testCaseProductLst = new list<PGIProduct>();
        testCaseProductLst =  QuoteSelectionUtilities.getDefaultUsage(new set<Id> {testSer.Id});
         for(PGIProduct Pr:testCaseProductLst){ 
                for(PGIProduct.ProductList prod: Pr.productLst){    
                    prod.Quantity=10;
                    prod.BidPrice =10.0;                    
                }
         }  
        //Case 1: + ve
        boolean testCase1Status;
        test.startTest(); 
        system.runAs(testUser1) {   
            QuoteSelectionUtilities.insertQuoteItems(testQuote.Id, testCaseProductLst);
            list<quoteLineItem> lineItem= [select Id from quoteLineItem where quoteId=: testQuote.Id];
            set<id> testids= new set<id>();
            for(quoteLineItem alineItem: lineItem){
                testids.add(alineItem.Id);
            }
            testCaseProductLst = new list<PGIProduct>();
            testCaseProductLst =  QuoteSelectionUtilities.getConfigureServiceUsage(testids, testQuote.Id);  
            testCase1Status = QuoteSelectionUtilities.configureQuoteLineItem(testCaseProductLst,testQuote.Id);
        }         
        system.assertEquals(testCase1Status,true);  
        test.stopTest();
    }
    
    //Test Method for getProducts
    @istest (seeAlldata=false) 
    public static void test_getProducts() {
        Test.startTest();
        Region__c region = PGITestUtilities.getRegionDetails();
        insert region;
        Solution__c solution = PGITestUtilities.getSolution();
        insert solution;
        Service__c service = PGITestUtilities.getService(solution.Id);
        insert service;
        Product__c product = PGITestUtilities.getProductDetails('Service',  'testserv','30111111');
        insert product;
        ServiceCategory__c serviceCategory = PGITestUtilities.getSerCategory(product.Id, service.Id, true); 
        serviceCategory.Product__c=product.Id;
        serviceCategory.Service__c=service.Id;        
        insert serviceCategory;
        set<Id> ServcId = new set<Id>();
        ServcId.add(service.Id);
        list<Id> productId = new list<Id>();
        productId.add(product.Id);
        system.assert(QuoteSelectionUtilities.getProducts(ServcId)!=null);
        Test.stopTest();
    }

    //Test Method for getAdditionalUsage
    @istest (seeAlldata=false) 
    public static void test_getAdditionalUsage() {
        Test.startTest();
        Decimal currentRowId = null;
        Region__c region = PGITestUtilities.getRegionDetails();
        insert region;
        Solution__c solution = PGITestUtilities.getSolution();
        insert solution;
        Service__c service = PGITestUtilities.getService(solution.Id);
        insert service;
        Product__c product = PGITestUtilities.getProductDetails('Ancillary','testserv','30111111');
        insert product;
        ServiceCategory__c serviceCategory = PGITestUtilities.getSerCategory(product.Id, service.Id, true);
        serviceCategory.Product__c=product.Id;
        serviceCategory.Service__c=service.Id;        
        insert serviceCategory;
        set<Id> ServcId = new set<Id>();
        ServcId.add(service.Id);
        list<Id> productId = new list<Id>();
        productId.add(product.Id);
        system.assert(QuoteSelectionUtilities.getAdditionalUsage(ServcId,productId,currentRowId)!=null);
        Test.stopTest();
    }
    @istest (seeAlldata=false) 
    public static void test_validateServiceBillingFrequency() {
        //Testdata preparation-Users
        User testUser1=PGITestUtilities.getTestUser(PGITestUtilities.getAdminProfile());
        testUser1.firstName='TestUser1';
        testUser1.Level_Of_Authority__c='Level 1';
        insert testUser1;
        Account testAcc= PGITestUtilities.getAccountDetails();
        insert testAcc;
        Opportunity testOpp= PGITestUtilities.getOpportunityDetails();      
        insert testOpp;
        Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
        cont.email='hsoni@salesforce.com';
        cont.title='mr';
        insert cont;
        Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        insert testQuote;
        Region__c region = PGITestUtilities.getRegionDetails();
        insert region;
        list<Product__c> allProduct= new list<Product__c>();
        Product__c testprod1 = PGITestUtilities.getProductDetails('Add-on', 'TestAddon','10111111');
        insert testProd1;       
        Product__c testprod2 = PGITestUtilities.getProductDetails('Ancillary', 'TestAncillary','20111111');
        insert testProd2;
        Product__c testprod3= PGITestUtilities.getProductDetails('Service', 'testserv','30111111');
        insert testProd3;
        Solution__c testSoln = PGITestUtilities.getSolution();
        insert testSoln;
        Service__c testSer= PGITestUtilities.getService(testSoln.Id);
        insert testSer;
        ServiceCategory__c testSc1= PGITestUtilities.getSerCategory(testSer.Id, testProd3.Id, true);
        insert testSc1;
        ServiceCategory__c testSc2= PGITestUtilities.getSerCategory(testSer.Id, testProd2.Id, true);
        insert testSc2;
        ServiceCategory__c testSc3= PGITestUtilities.getSerCategory(testSer.Id, testProd1.Id, true);
        insert testSc3;
    
       //Case 1:
        list<PGIProduct> testCase1ProductLst = new list<PGIProduct>();
        boolean testServiceBillingFrequency;
        test.startTest();
        system.runAs(testUser1) {   
            testCase1ProductLst =  QuoteSelectionUtilities.getDefaultUsage(new set<Id> {testSer.Id});    
            testServiceBillingFrequency = QuoteSelectionUtilities.validateServiceBillingFrequency(testCase1ProductLst);
        }
        system.assertEquals(testServiceBillingFrequency,false);
       test.stopTest();
    }
    
}