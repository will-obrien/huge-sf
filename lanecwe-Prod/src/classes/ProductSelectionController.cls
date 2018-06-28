/********************************************************************************
Name:  ProductSelectionController()
Copyright © 2012  PGI
======================================================
======================================================
Purpose:
-------
This is controller for Configure Service Page
======================================================
======================================================
History
-------
VERSION  AUTHOR                DATE                 DETAIL              FEATURES/CSR/TTP
  1.0 – Capgemini India          25/09/2012        Added 
********************************************************************************/    
public with sharing class ProductSelectionController {
    public Boolean noSearch { get; set; }
    public String TermLength { get; set; }
    public String MinmaxLicenses { get; set; }
    public Boolean prodFilterPage { get; set; }
    public Boolean FilterPage { get; set; }
    public Boolean usagePage { get; set; }
    public list<Id> Addproducts {get;set; }
    public set<Id> addedProducts {get; set;}
    public set<Id> ancillaryProductIds {get; set;}
    public list<String> Solutions {get;set;}
    public list<String> unitType {get;set;}
    public list<String> billingFrequency {get;set;}
    public String interestedSolution {get;set;}
    public list<String> Currencies {get;set;}
    public string userChannel{get;set;}
    public string regionName{get;set;}
    public String ProductFilter { get; set; }
    public list<PGIProduct.ProductList>ServProdDetails{get;set;}
    public list<PGIProduct>ProdUsageDetails{get;set;}
    Set<Id>SelectdServ= new set<Id>();
    Set<Id>ProductIds = new set<Id>();
    public string quoteId{get;set;}
    public Boolean isCancelled{get;set;}
    public string selectedServiceId {get; set;}
    public decimal selectedRowId {get; set;}   
    public decimal latestRowId {get; set;}  
    set<Id>PackageIds=new set<Id>();    
    public string  opportunityId {get;set;}
    public Boolean isSelected=false;
    public List<Selectoption> solutionList
    {
    	get
    	{
    		if (solutionList == null)
    		{
    			solutionList = this.getSolnlst();
    		}
    		return solutionList;
    	}
    	set;
    }
    
    /**
     * This method moves the selected product family values on the top.
     */
    private List<Selectoption> moveSelectedSolutionToTop()
    {
    	List<Selectoption> newSolutionList = new List<Selectoption>();
    	if (!this.SolutionList.isEmpty() && this.Solutions != null && !this.Solutions.isEmpty())
    	{
    		Set<String> solutionSet = new Set<String>(this.Solutions);
    		// remove the none values and add it to new list.
    		newSolutionList.add(this.SolutionList.remove(0));
    		for (Integer i=0; i<this.SolutionList.size(); i++)
    		{
    			Selectoption option = this.SolutionList.get(i);
    			if (option != null && option.getValue() != null && solutionSet.contains(option.getValue()))
    			{
    				newSolutionList.add(this.SolutionList.remove(i--));
    			}
    		}
    	}
    	newSolutionList.addAll(this.SolutionList);
    	
    	return newSolutionList;
    }
    
    public ProductSelectionController (){        
        try{
            quoteId = apexPages.currentpage().getParameters().get('QuoteId');  
            regionName=[Select Region__c  From User where Id =:userinfo.getuserId()].Region__c;
            string levelOfAuthorithy=[Select Level_Of_Authority__c From User where Id =:userinfo.getuserId()].Level_Of_Authority__c;
            userChannel=[Select Channel__c From User where Id =:userinfo.getuserId()].Channel__c;
            if(quoteId==null ||quoteId ==''){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Invalid QuoteId');
                    myMsg.getComponentLabel();
                    Apexpages.addMessage(myMsg); 
            }else if(levelOfAuthorithy==null || levelOfAuthorithy==''){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'You are not associated with any Level Of Authority. Please contact your support team.');
                myMsg.getComponentLabel();
                Apexpages.addMessage(myMsg);
            }
            else if(regionName=='None'){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'You are not associated with Region. Please contact your support team.');
                myMsg.getComponentLabel();
                Apexpages.addMessage(myMsg);
            }else{
                string UserCurrency=[select DefaultCurrencyIsoCode from User where Id=:userinfo.getuserId()].DefaultCurrencyIsoCode;
                Currencies= new list<string>();
                Currencies.add(UserCurrency);   
                if(quoteId==null ||quoteId =='' ||regionName=='None' ||levelOfAuthorithy==null || levelOfAuthorithy==''){
                        FilterPage=false;
                        prodFilterPage=false;
                 }else{
                     FilterPage=true;
                    usagePage=false;
                }
            }
            
            if(QuoteId!=null){
                                opportunityId=[Select OpportunityId From Quote where Id=:quoteId].OpportunityId;
                        }
            for(PackageChannel__c packageChannel:[Select Package__c, Channel__c From PackageChannel__c  where Channel__r.name=:userChannel or Channel__r.name=:'ALL']){
                PackageIds.add(packageChannel.Package__c);
            }
            //system.debug('$$$PackageIds'+PackageIds);
            
        }catch(Exception E){
            system.debug('Exception'+e);
        }
    }
 
    /*public   List<SelectOption> getSolnlst() {
          Set<Id> SolnId=new Set<Id>();
          String Producttype='Service'; 
          String SelectSolution = 'Select Service__r.Id,Service__c,Service__r.Solution__c, Product__r.Billing_Frequency__c,Product__r.Regions__c,Product__r.Channels__c,Product__r.Unit_Of_Measure__c,Product__r.Minimum_Quantity__c,Product__r.Maximum_Quantity__c, Product__r.Name,Product__c,Id From ServiceCategory__c where Product__r.Regions__c=:regionName  and Product__r.CurrencyIsoCode  = : Currencies and Default__c=true and  Service__c=:PackageIds and Product__r.ProductType__c=\''+Producttype+'\' Order by Product__r.Name';
            list<ServiceCategory__c> solutionlst=(Database.query(SelectSolution));
            //system.debug('***solutionlst'+solutionlst);
            for(ServiceCategory__c sc:solutionlst){
                if(sc.Service__r.Solution__c!=null){
                    SolnId.add(sc.Service__r.Solution__c);
                }
            }
            
             List<SelectOption> finaloptions = new List<SelectOption>();
          
            //system.debug('***JP Solution IDs '+ SolnId );   
          //system.debug('***JP Solutions '+ Solutions ); 
               //system.debug('***JP I am 1 ');              
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','- None -'));
            list<Solution__c > Solns =new list <Solution__c>();
            if(!SolnId.isEmpty()){
                Solns=[Select Name, Id From Solution__c where Id=:SolnId order by Name];
                for(Solution__c  sol:Solns){
                    options.add(new SelectOption( sol.Id,sol.Name));
                }  finaloptions.addall(options);
            }
           
          //system.debug('***JP Solns Original '+ Solns );  
 
            if(isSelected==true)
            {  //system.debug('***JP I am 2 '); 
            
            // List<SelectOption> options = new List<SelectOption>();
             //list<Solution__c > Solns =new list <Solution__c>();
             options.clear();
             options.add(new SelectOption('','- None -'));
            
                if(!SolnId.isEmpty()){
                Solns=[Select Name, Id From Solution__c where Id in:Solutions ];
                for(Solution__c  sol:Solns){
                    options.add(new SelectOption( sol.Id,sol.Name));
                    //system.debug('***JP Options 1  '+ options );  
                }  
                   //system.debug('***JP Solns On Select '+ Solns );  
                Solns.clear();
                //system.debug('***JP Solns After Clear '+ Solns );  
                 Solns=[Select Name, Id From Solution__c where Id not in:Solutions  and id in:SolnId];
                 
                 //system.debug('***JP Solns Ignoring Selected  '+ Solns );  
                 for(Solution__c  sol:Solns){
                    options.add(new SelectOption( sol.Id,sol.Name));
                    system.debug('***JP Options 2  '+ options ); 
                } 
                 finaloptions.clear();
                 finaloptions.addall(options);
            }
            //system.debug('***JP options size'+ options.size() ); 
            
            } 
             //system.debug('***JP finaloptions '+ finaloptions ); 
             //system.debug('***JP finaloptions size'+ finaloptions.size() ); 

            return finaloptions;
    }*/
    
    private List<SelectOption> getSolnlst() {
		List<SelectOption> finaloptions = new List<SelectOption>();
		String Producttype='Service'; 
		String SelectSolution = 'Select Service__r.Solution__c solutionId, Service__r.Solution__r.Name solutionName, '+
							'Count(Product__r.Term_Length__c) termCount, Count(Product__r.Minimum_Quantity__c) minQuantityCount, '+
							'Count(Product__r.Maximum_Quantity__c) maxQuantityCount From ServiceCategory__c '+
							'where Product__r.Regions__c=:regionName  and Product__r.CurrencyIsoCode  = : Currencies '+
							'and Default__c=true and  Service__c=:PackageIds and Product__r.ProductType__c=\''+Producttype+'\' '+
							'Group By Service__r.Solution__r.Name, Service__r.Solution__c Order by Service__r.Solution__r.Name';
		List<AggregateResult> aggregateResultList = (Database.query(SelectSolution));
		finaloptions.add(new SelectOption('','- None -'));
		if (aggregateResultList != null && !aggregateResultList.isEmpty())
		{
			for (AggregateResult aggResult : aggregateResultList)
			{
				if (aggResult != null)
				{
					String solutionId = (String)aggResult.get('solutionId');
					String solutionName = (String)aggResult.get('solutionName');
					Integer termCount = (Integer)aggResult.get('termCount');
					Integer minQuantityCount = (Integer)aggResult.get('minQuantityCount');
					Integer maxQuantityCount = (Integer)aggResult.get('maxQuantityCount');
					Boolean hasTerm = termCount > 0?true:false;
					Boolean hasQuantity = (minQuantityCount > 0 || maxQuantityCount > 0)?true:false;
					String valueString = solutionId + ';' + hasTerm + ';' + hasQuantity;
					finaloptions.add(new SelectOption(valueString, solutionName));
				}
			}
		}
		return finaloptions;
	}
    
     public List<SelectOption> getinterstdSolLst() 
     {
        Map <String,Id> productFamilyMap=new Map<String,Id>();
        list<Solution__c>solLst= new list<Solution__c>([Select Name, Id From Solution__c]);
        if(!solLst.isEmpty()){
            for(Solution__c so:solLst){
                    productFamilyMap.put(so.Name,so.Id);
            }
        }
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '- None -'));
        if(OpportunityId!=null){
        list<OpportunityLineItem> oppLineItemLst= new list<OpportunityLineItem>(
        										 [Select PricebookEntry.Name, PricebookEntryId,Package__r.Solution__c,
        										  Package__c, OpportunityId,New_Quantity__c,Contract_Term__c,Billing_Frequency__c,
        										  Unit_Type__c 
        										  From OpportunityLineItem 
        										  Where OpportunityId=:opportunityId 
        										  		And Quote_Line_Item__c=:null 
        										  		And Existing_Service__c=:false
        										  		And PricebookEntry.Product2.Exclude_from_Package_Search__c=:false]);
		    if(!oppLineItemLst.isEmpty())
		    {
		        for(OpportunityLineItem oppLine:oppLineItemLst)
		        {
		        	options.add(new SelectOption(productFamilyMap.get(oppLine.PricebookEntry.Name)+'&'+oppLine.New_Quantity__c+'&'+oppLine.Contract_Term__c+'&'+oppLine.Unit_Type__c+'&'+oppLine.Billing_Frequency__c,oppLine.PricebookEntry.Name));
		        }
			}
        }
        return options;
    }
    
   
      public List<selectoption> getunitTypeLst(){
   /*
               List<SelectOption> typeoption;
             
               Schema.DescribeSObjectResult r =Product__c.sObjectType.getDescribe();
               Schema.DescribeFieldResult fieldResult = Schema.sObjectType.Product__c.fields.Unit_Of_Measure__c;
               List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
               typeoption = new List<SelectOption>();
               typeoption.add(new SelectOption('','- None -'));
               for( Schema.PicklistEntry unitType : ple)
               {
                  unitType.getLabel();  
                   unitType.getValue();    
                   typeoption.add(new SelectOption(unitType.getValue(), unitType.getLabel()));
                }   
               
          return typeoption;         
          */
         
           List<SelectOption> typeoption = new list<SelectOption>();
	       typeoption.add(new SelectOption('','- None -'));
           typeoption.add(new SelectOption('Licenses','Licenses'));
           typeoption.add(new SelectOption('Minute','Minute'));
           typeoption.add(new SelectOption('Month','Month'));
          	return typeoption; 
         }
        
    
    
        public List<selectoption> getbillingFrequencyLst(){
           List<SelectOption> typeoption;
           Schema.DescribeSObjectResult r =Product__c.sObjectType.getDescribe();
           Schema.DescribeFieldResult fieldResult = Schema.sObjectType.Product__c.fields.Billing_Frequency__c;
           List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
           typeoption = new List<SelectOption>();
           typeoption.add(new SelectOption('','- None -'));
       	   for( Schema.PicklistEntry bilingfrequency : ple)
           {
              bilingfrequency.getLabel();  
               bilingfrequency.getValue();    
               typeoption.add(new SelectOption(bilingfrequency.getValue(), bilingfrequency.getLabel()));
           }
            return typeoption;
         }   
         
    
   /*********************************************************************
    Filter Methods
    *********************************************************************/
    
    public PageReference FilterProduct() {
        isSelected=true;
        Set<Id>ServId= new Set<Id>();
        List<String> beforeHypensol = new List<String>();   
        FilterPage=true;                
        String Producttype='Service'; 
        String SelectString = 'Select Service__r.Id,Service__c,Product__r.Billing_Frequency__c,Product__r.Regions__c,Product__r.Channels__c,Product__r.Unit_Of_Measure__c,Product__r.Minimum_Quantity__c,Product__r.Maximum_Quantity__c, Product__r.Name,Product__c,Id From ServiceCategory__c where Product__r.Regions__c=:regionName  and Product__r.CurrencyIsoCode  = : Currencies and Default__c=true and Service__c=:PackageIds and Product__r.ProductType__c=\''+Producttype+'\'';
        String Filter ='';
        String ProductFilter='';
        try{
           Set<String> SolutionIds = new Set<String>();
            for(String SolId : Solutions){
                if(SolId != null && SolId != ''){
                    SolutionIds.add(SolId.split(';')[0]);                                         
                }
            }       
            if(interestedSolution != null && interestedSolution != ''){
                beforeHypensol= interestedSolution.split('&'); 
            }   
          
            if(!beforeHypensol.isEmpty() && beforeHypensol!=null && beforeHypensol[0]!=null){                   
                SolutionIds.add(beforeHypensol[0]);
            }   
    
            if(!SolutionIds.isEmpty() ){
                Filter +=' AND Service__r.Solution__c =: SolutionIds ';
            } 
            list<String> unitTypeLst = new list<String>();
            for(String unitOfMeasure : unitType){
                if(unitOfMeasure != null && unitOfMeasure != ''){
                    unitTypeLst.add(unitOfMeasure);                                         
                }
            }
            if(!unitTypeLst.isEmpty()){
                Filter+=' AND Product__r.Unit_Of_Measure__c=: unitTypeLst';
            }
    
            list<String> billingFrequencylst=new list<String>();
            for(String billingFreq:billingFrequency){
                if(billingFreq!=null && billingFreq !=''){
                    billingFrequencylst.add(billingFreq);
                }
            }
            if(!billingFrequencylst.isEmpty()){
                Filter+= ' AND Product__r.Billing_Frequency__c=: billingFrequencylst';
            }
            if(TermLength!=null && TermLength !=''){
                double tLength=0;
                tLength=Double.valueof(TermLength);
                Filter +=' AND Product__r.Term_Length__c  = '+ tLength ;
            }
            ProductFilter = SelectString + Filter+'  Order by Product__r.Name' ;
            list<ServiceCategory__c> Proddetails = new list<ServiceCategory__c>();
            set<Id> uniqueServIds = new set<Id>();
            if(ProductFilter!='' && ProductFilter!=null){
                Proddetails= Database.query(ProductFilter);
                set<Id> uniqueMinIds = new set<Id>();
                set<Id> uniqueMaxIds = new set<Id>();   
                if(MinmaxLicenses!=null && MinmaxLicenses !=''){
                    for(ServiceCategory__c sc :Proddetails){
                        if(sc.Product__r.Minimum_Quantity__c <= Double.valueOf(MinmaxLicenses)){
                            uniqueMinIds.add(sc.Service__c);
                        }               
                        if(sc.Product__r.Maximum_Quantity__c >= Double.valueOf(MinmaxLicenses)){
                            uniqueMaxIds.add(sc.Service__c);
                        }   
                    }
                    for(Id aId:uniqueMinIds){
                        if(uniqueMaxIds.contains(aId)){
                            uniqueServIds.add(aId);
                        }
                    }
                } else{
                    for(ServiceCategory__c sc :Proddetails){
                        if(sc.Service__c!=null){                            
                                uniqueServIds.add(sc.Service__c);
                        }
                    }
                }
                ServProdDetails=QuoteSelectionUtilities.getProducts(uniqueServIds); 
            }
            
            if(Proddetails.isEmpty() ||uniqueServIds.isEmpty()){
                noSearch=true;
                prodFilterPage=false;
            }else{
                noSearch=false;
                prodFilterPage=true;
            }
            this.solutionList = this.moveSelectedSolutionToTop();
        } catch (Exception ex){
            PGIErrorUtilities.logPgiError('ProductSelectionController:FilterProduct()',ex.getMessage(),PGIErrorUtilities.LoggingLevel.INFO);
                system.debug(LoggingLevel.ERROR,'Error When filtering product '+ex.getMessage());
        }          
        return null;      
    }
    
    public PageReference EnterUsage() {
        for(PGIProduct.ProductList pi:ServProdDetails){
                        if(pi.selectedproduct){
                            SelectdServ.add(pi.serviceId);
                             FilterPage=false;
                             prodFilterPage=false;
                             usagePage=true;
                        }
        } 
        ProdUsageDetails=QuoteSelectionUtilities.getDefaultUsage(SelectdServ);
        for(PGIProduct aProduct:ProdUsageDetails)  {
            latestRowId= aProduct.latestRowId;
        }
        return null;
    } 
        
    public PageReference AddAditionalProducts() {
        set<Id> ServiceIds = new set<Id>();
        ServiceIds.add(selectedServiceId);
        list<PGIProduct.ProductList> addNewProd= new list<PGIProduct.ProductList> ();
        list<selectOption> newProductOptions= new list<SelectOption>();
        set<id> addedProductLst = new set<id>();
        
        for(PGIProduct addProduct: ProdUsageDetails){
            if( addProduct.serviceId == selectedServiceId){
                Addproducts= addProduct.addedProducts;
            }
        }
        for(Id aproductOption:Addproducts){                     
            addedProductLst.add(aproductOption);
        }
        for(PGIProduct addProduct: ProdUsageDetails){
            if( addProduct.serviceId == selectedServiceId){                      
                for( selectOption aProduct :addProduct.productOptions){
                    if(!addedProductLst.contains(aProduct.getValue())){
                        newProductOptions.add(aProduct);
                    }
                }                       
                addProduct.productOptions=newProductOptions;                            
            }
        }
              
      
        list<PGIProduct> newproddetails=QuoteSelectionUtilities.getAdditionalUsage(ServiceIds, Addproducts,latestRowId);
        for(PGIProduct newP: newproddetails){                  
            latestRowId= newP.latestRowId;
            addNewProd  =newP.productLst;
        }  
    
        for(PGIProduct newProdAdd: ProdUsageDetails){
            for(PGIProduct.ProductList finalProd: addNewProd  ){
                if(newProdAdd.serviceName== finalProd.Sname){
                    finalProd.isDefaultProduct = false;
                    newProdAdd.productLst.add(finalProd);
                }
            }       
        }
  
            
        if( addProducts!=null && addProducts.size()>0) {            
            for(id productId: addProducts){
                if(addedProducts==null) addedProducts = new set<Id>();
                addedProducts.add(productId);
            } 
        }
       return null;
    }
   
   
    public PageReference AddAncillaryProducts() {
        set<Id> ServiceIds = new set<Id>();
        ServiceIds.add(selectedServiceId);
        list<PGIProduct.ProductList> addNewProd= new list<PGIProduct.ProductList> ();
        list<selectOption> newAncillaryOptions= new list<SelectOption>();
        set<id> setAncillaryProductIds= new set<id>();
        
        for(PGIProduct addProduct: ProdUsageDetails){
            
            if( addProduct.serviceId == selectedServiceId){
                Addproducts= addProduct.ancillaryProducts;
            }
        }
        for(Id aproductOption:Addproducts){                     
            setAncillaryProductIds.add(aproductOption);
        }
        for(PGIProduct addProduct: ProdUsageDetails){
            if( addProduct.serviceId == selectedServiceId){                      
                for( selectOption aProduct :addProduct.ancillaryOptions){
                    if(!setAncillaryProductIds.contains(aProduct.getValue())){
                        newAncillaryOptions.add(aProduct);
                    }
                }                       
                addProduct.ancillaryOptions=newAncillaryOptions;                            
            }
        }
              
      
        list<PGIProduct> newproddetails=QuoteSelectionUtilities.getAdditionalUsage(ServiceIds, Addproducts,latestRowId);
        for(PGIProduct newP: newproddetails){
            addNewProd  =newP.productLst;
            latestRowId= newP.latestRowId;
        }  
    
        for(PGIProduct newProdAdd: ProdUsageDetails){
            for(PGIProduct.ProductList finalProd: addNewProd  ){
                if(newProdAdd.serviceName== finalProd.Sname){
                    finalProd.isDefaultProduct = false;
                    newProdAdd.productLst.add(finalProd);
                }
            }       
        }
  
            
        if( addProducts!=null && addProducts.size()>0) {            
            for(id productId: addProducts){
                if(ancillaryProductIds==null) {
                ancillaryProductIds = new set<Id>(); }
                ancillaryProductIds.add(productId);
                
            } 
        }
       return null;
    }
        
    public PageReference deletelineItem()
     {
        list<PGIProduct> updatedLst= new list<PGIProduct>();
        if(selectedRowId!=null){        
            string selectedSerId; 
            for(PGIProduct aProdlst: ProdUsageDetails){                
                for(PGIProduct.ProductList finalProd: aProdlst.productLst){
                    if(finalProd.customRowId == selectedRowId && finalProd.isServiceProduct){
                        selectedSerId = finalProd.serviceId;
                        break;
                    }
             }
            }
            for(PGIProduct aProdlst: ProdUsageDetails){ 
                if(aProdlst.serviceId  !=selectedSerId){
                list<PGIProduct.ProductList > lstProds= new list<PGIProduct.ProductList>();
                for(PGIProduct.ProductList finalProd: aProdlst.productLst){
                    //if(finalProd.serviceId !=selectedSerId){ 
                        //system.debug('####'+finalProd.serviceId+'$$$'+selectedSerId);
                        if(selectedRowId != finalProd.customRowId && finalProd.serviceId !=selectedSerId){                 
                            lstProds.add(finalProd);
                        }else{
                            if(ancillaryProductIds!=null&& ancillaryProductIds.contains(finalProd.productId)){ 
                                aProdlst.ancillaryOptions.add( new selectOption(finalProd.productId,finalProd.ProductName));
                                ancillaryProductIds.remove(finalProd.productId);
                            } else if(addedProducts!=null&& addedProducts.contains(finalProd.productId)){
                                aProdlst.productOptions.add( new selectOption(finalProd.productId,finalProd.ProductName));
                                addedProducts.remove(finalProd.productId);                          
                            }
                        }
                    }               
                                 
                aProdlst.productlst= new list<PGIPRoduct.ProductList>();
                aProdlst.productlst =   lstProds;
                updatedLst.add(aProdlst);
            }
            }  
        }
        ProdUsageDetails = new list<PGIProduct>();
        ProdUsageDetails = updatedlst;
        return null;
    }   
        
    /**********************************************************************
    SaveOffer to insert QuoteLineItem
    *********************************************************************/
                
    public PageReference saveOffers() {
    	List<String> quantities = new List<String>();
        Boolean validateServBillingFreq =QuoteSelectionUtilities.validateServiceBillingFrequency(ProdUsageDetails);
            if(validateServBillingFreq){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please ensure you have a consistent Billing Frequency for each of you PGi License Packages .');
                    myMsg.getComponentLabel();
                    Apexpages.addMessage(myMsg); 
                    isCancelled=false; 
            }
            else if(QuoteSelectionUtilities.hasNegativeMinCommitQuantity(ProdUsageDetails, quantities))
            {
            	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, String.format(system.label.Min_Commit_Quantity_Error, quantities));
            	ApexPages.Message myMsg2 = new ApexPages.Message(ApexPages.Severity.FATAL, String.format(system.label.Min_Commit_Quantity_Error_2, quantities));
                Apexpages.addMessage(myMsg); 
                Apexpages.addMessage(myMsg2); 
                isCancelled=false;
            }
            else{
                    Boolean status = QuoteSelectionUtilities.insertQuoteItems(quoteId, ProdUsageDetails);
                     if(!status){
                                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Enter valid input data');
                                myMsg.getComponentLabel();
                                Apexpages.addMessage(myMsg); 
                                isCancelled=false; 
                                }else{
                                    isCancelled=true; 
                                }
                }
        return null;
        
    }
    /************************************************************************************
    Method to clear from the list
    **************************************************************************************/
    public void ClearFromList() {
        Solutions.clear();
        MinmaxLicenses='';
        TermLength='';
                
    }
    public PageReference cancel(){
        isCancelled=true; 
        return null;
    }
    
    public PageReference back(){ 
        try{
            PageReference pageRef = new PageReference('/apex/ProductSelection?quoteId='+quoteId);
            pageRef.setRedirect(true);
            return pageRef;
    }catch(exception e){
         system.debug('TEST'+e);
    }
    return null;
    }
    
    /*************************************** TEST METHOD **********************************************************/
    
    @istest(seeAlldata=true)
   private static void test_FilterProduct(){
             //Case1:
            ProductSelectionController case1TestCons=new ProductSelectioncontroller();
            case1TestCons.filterProduct();
            //Case2:
        //Testdata preparation-Users
        User testUser1=PGITestUtilities.getTestUser(PGITestUtilities.getAdminProfile());
        testUser1.firstName='TestUser1';
        testUser1.Level_Of_Authority__c='Level 1';
        testUser1.Region__c='NA';
        testUser1.KeyForContract__c='2';
        insert testUser1;
                Account testAcc= PGITestUtilities.getAccountDetails();
        insert testAcc;
        Opportunity testOpp= PGITestUtilities.getOpportunityDetails();      
        insert testOpp;
        Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
        insert cont;
        Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        insert testQuote;
        Region__c region = PGITestUtilities.getRegionDetails();
        insert region;
        list<Product__c> allProduct= new list<Product__c>();
        Product__c testprod1 = PGITestUtilities.getProductDetails('Add-on', 'TestAddon','10111111');
        testprod1.Minimum_Quantity__c=0.0;
        testprod1.Maximum_Quantity__c=100.0;
        insert testProd1;       
        Product__c testprod2 = PGITestUtilities.getProductDetails('Ancillary', 'TestAncillary','20111111');
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
        //case 1:
        system.runAs(testUser1){
         case1TestCons=new ProductSelectioncontroller();
        case1TestCons.regionName=region.Id;
        list<string> currlst=new list<string>();  
        currlst.add('USD');
        case1TestCons.Currencies=currlst;
        list<string> billlst=new list<String>();
        billlst.add('Monthly');
        case1TestCons.billingFrequency=billlst;
        case1TestCons.userChannel='Eco';
        case1TestCons.regionName='NA';
        list<String> sollst=new list<String>();
        sollst.add(testSoln.Id);
        case1TestCons.solutions=sollst;
        case1TestCons.interestedSolution=testSoln.Id; 
        case1TestCons.TermLength='1';  
        list<String> Unittype=new list<String>();
        UnitType.add('Ancillary');
        case1TestCons.unitType=UnitType;
        case1TestCons.filterProduct();
        case1TestCons.MinmaxLicenses='35';
        PGITestUtilities.setTestParameter('quoteId', testQuote.Id);             
        case1TestCons.filterProduct();
        //Case3:
        case1TestCons.userChannel='testEco';   
        case1TestCons.filterProduct();
        }  
             
        //system.debug('@@@@'+case2TestCons.solutions);
        //system.assertEquals(case2TestCons.ServProdDetails.size(),1);
        
        
   }
    
  
    @istest(seeAlldata=false)
    private static void test_productSelectionController(){
        //Testdata preparation-Users
        User testUser1=PGITestUtilities.getTestUser(PGITestUtilities.getAdminProfile());
        testUser1.firstName='TestUser1';
        testUser1.Level_Of_Authority__c='Level 1';
        testUser1.Region__c='None';
        insert testUser1;
        //User 2
        User testUser2=PGITestUtilities.getTestUser2(PGITestUtilities.getAdminProfile());     
        testUser2.Region__c='NA';
         testUser2.Level_Of_Authority__c='Level 1';        
        testUser2.KeyForContract__c='2';
        insert testUser2;
        Account testAcc= PGITestUtilities.getAccountDetails();
        insert testAcc;
        Opportunity testOpp= PGITestUtilities.getOpportunityDetails();      
        insert testOpp;
        Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
        insert cont;
        Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        insert testQuote;
        Region__c region = PGITestUtilities.getRegionDetails(); 
        insert region;
        
        //case 1:
        ProductSelectionController case1TestCons;
        //case 2:
        ProductSelectionController case2TestCons;
        
        system.runAs(testUser1){
                PGITestUtilities.setTestParameter('quoteId', testQuote.Id);
                case1TestCons= new ProductSelectionController();
                PGITestUtilities.setTestParameter('quoteId', null);     
                case2TestCons= new ProductSelectionController();
        }       
        //Assert 
        system.assertEquals(case1TestCons.quoteId,testQuote.Id);        
        system.assertEquals(case2TestCons.quoteId,null);
        
        //case 3:
        ProductSelectionController case3TestCons;
        //case 4: with Authority level
        ProductSelectionController case4TestCons;
        system.runAs(testUser2){
                PGITestUtilities.setTestParameter('quoteId', testQuote.Id);
                case3TestCons= new ProductSelectionController();    
                testUser2.Level_Of_Authority__c='Level 1';
                update testUser2;
                case4TestCons= new ProductSelectionController();
        }       
        //Assert 
        system.assertEquals(case4TestCons.quoteId,testQuote.Id);        
    }
   @istest(seeAlldata=false)
   private static void test_getSolutions(){
        //Testdata preparation-Users
        User testUser1=PGITestUtilities.getTestUser(PGITestUtilities.getAdminProfile());
        testUser1.firstName='TestUser1';
        testUser1.Level_Of_Authority__c='Level 1';
        testUser1.Region__c='NA';
        testUser1.KeyForContract__c='2';
        insert testUser1;
        Region__c region = PGITestUtilities.getRegionDetails();
        insert region;
        Account testAcc= PGITestUtilities.getAccountDetails();
        insert testAcc;
        Opportunity testOpp= PGITestUtilities.getOpportunityDetails();      
        insert testOpp;
        Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
        insert cont;
        Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        insert testQuote;
        Product__c testprod1= PGITestUtilities.getProductDetails('Service', 'testserv','30111111');
        insert testProd1;
        PGITestUtilities.setTestParameter('quoteId', testQuote.Id); 
        ProductSelectionController testCase1Cons;
        ProductSelectionController testCase2Cons;
        system.runas(testUser1){
            //case 1: without Solution          
            testCase1Cons= new ProductSelectionController();            
          //  system.assertEquals(testCase1Cons.getSolnlst().size(),2);
         
            //case 2: with soln
            Solution__c testSoln = PGITestUtilities.getSolution();
            insert testSoln;
            Service__c testSer= PGITestUtilities.getService(testSoln.Id);
            insert testSer;
            ServiceCategory__c testSc1= PGITestUtilities.getSerCategory(testSer.Id, testProd1.Id, true);
            insert testSc1;
            testCase2Cons= new ProductSelectionController();
            testCase2Cons.regionName='NA';
            testCase2Cons.userChannel='Eco';
            list<String> curlst=new list<String>();
            curlst.add('USD');
            testCase2Cons.Currencies=curlst;
         //   system.assertEquals(testCase2Cons.getSolnlst().size(),2);
    
        }           
   }
   @istest(seeAlldata=false)
   private static void test_getUnitTypeLst(){
   		ProductSelectionController testProdSelecCase = new ProductSelectionController();
         system.assert(testProdSelecCase.getunitTYpeLst()!=null);
   }
   @istest(seeAlldata=false)
   private static void test_getinsertedSoln(){
        Account testAcc= PGITestUtilities.getAccountDetails();
        insert testAcc;
        Opportunity testOpp= PGITestUtilities.getOpportunityDetails();      
        insert testOpp;
        Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
        insert cont;
        Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        insert testQuote;
        Solution__c testSoln = PGITestUtilities.getSolution();
        insert testSoln;
        
        //OpportunitySolution__c testOppsoln= PGITestUtilities.getOpportunitySolution(testOpp.Id, testQuote.Id, testSoln.Id);
        
      //  insert testOppsoln;
        PGITestUtilities.setTestParameter('quoteId', testQuote.Id); 
        ProductSelectionController testProdSelecCase = new ProductSelectionController();
        system.assert(testProdSelecCase.getinterstdSolLst()!=null);
        system.assert(testProdSelecCase.solutionList!=null);
   }
   @istest(seeAlldata=false)
   private static void test_getBillingFrequencyLst(){
   		ProductSelectionController testProdSelecCase = new ProductSelectionController();
         system.assert(testProdSelecCase.getbillingFrequencyLst()!=null);
   } 
   
   
   
     @istest(seeAlldata=true) 
   private static void test_AddAditionalProducts(){
   
        test.startTest();
        Test.setCurrentPage(Page.PGIQuoteApprovalAction);
        //Testdata 
        User testUser1=PGITestUtilities.getTestUser(PGITestUtilities.getAdminProfile());
        testUser1.firstName='TestUser1';
        testUser1.Level_Of_Authority__c='Level 1';
          testUser1.Region__c='NA';
        testUser1.KeyForContract__c='2';
        insert testUser1;
                Account testAcc= PGITestUtilities.getAccountDetails();
                insert testAcc;
                Opportunity testOpp= PGITestUtilities.getOpportunityDetails();          
                insert testOpp;
                Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
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
                OpportunityLineItem oli = PGITestUtilities.getOpportunityLineItemDetails(testOpp.Id, pbe.Id);
        		insert oli;     
                QuoteLineItem testquoteLineItem1=PGITestUtilities.getServiceQuoteLineItem(testprod1.Id,testSer.Id,testQuote.Id,pbe);
                insert testquoteLineItem1;
                QuoteLineItem testquoteLineItem2=PGITestUtilities.getTestQuoteLineItem(testprod2.Id,testSer.Id,testQuote.Id,pbe,testquoteLineItem1.Id);
                insert testquoteLineItem2;
                QuoteLineItem testquoteLineItem3=PGITestUtilities.getTestQuoteLineItem(testprod3.Id,testSer.Id,testQuote.Id,pbe,testquoteLineItem1.Id);
                insert testquoteLineItem3;   
                list<QuoteLineItem> quotelst=[Select q.UnitPrice, q.Service__c, q.QuoteId, q.Quantity, q.Product__c, q.PricebookEntry.Name, q.PricebookEntryId, q.Approval_Status__c From QuoteLineItem q limit 1000];
             set<Id> quoItemid=new set<Id>();
            for(quoteLineItem quoItem:quotelst)
              quoItemid.add(quoItem.Id);
            list<PGIProduct> prolst=getConfigureServiceUsage(quoItemid,testQuote.Id);
            //system.assertNotEquals(prolst.size(),0);  
        PGITestUtilities.setTestParameter('quoteId', testQuote.Id); 
        ProductSelectionController proSelcon=new ProductSelectionController();
            proSelcon.ProdUsageDetails=prolst;
        list<Id> Addproducts=new list<Id>();
                Addproducts.add(testprod2.Id);
        proSelcon.Addproducts=Addproducts;
        proSelcon.AddAditionalProducts();
   }
    @istest(seeAlldata=true)
   private static void test_AddAncillaryProducts(){
   
       test.startTest();
        Test.setCurrentPage(Page.PGIQuoteApprovalAction);
        //Testdata 
        User testUser1=PGITestUtilities.getTestUser(PGITestUtilities.getAdminProfile());
        testUser1.firstName='TestUser1';
       testUser1.Level_Of_Authority__c='Level 1';
        testUser1.Region__c='NA';
        testUser1.KeyForContract__c='2';
        insert testUser1;
                Account testAcc= PGITestUtilities.getAccountDetails();
                insert testAcc;
                Opportunity testOpp= PGITestUtilities.getOpportunityDetails();          
                insert testOpp;
                Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
        insert cont;
                Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
                insert testQuote;
                Region__c region = PGITestUtilities.getRegionDetails();
        insert region;
                list<Product__c> allProduct= new list<Product__c>();
                Product__c testprod1 = PGITestUtilities.getProductDetails('Service', 'TestAddon','10111111');
                
                insert testProd1;               
                Product__c testprod2 = PGITestUtilities.getProductDetails('Ancillary', 'TestAncillary','20111111');
                insert testProd2;
                Product__c testprod3= PGITestUtilities.getProductDetails('Add-on', 'testserv','30111111');
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
                OpportunityLineItem oli = PGITestUtilities.getOpportunityLineItemDetails(testOpp.Id, pbe.Id);
        		insert oli;     
                QuoteLineItem testquoteLineItem1=PGITestUtilities.getServiceQuoteLineItem(testprod1.Id,testSer.Id,testQuote.Id,pbe);
                insert testquoteLineItem1;
                QuoteLineItem testquoteLineItem2=PGITestUtilities.getTestQuoteLineItem(testprod2.Id,testSer.Id,testQuote.Id,pbe,testquoteLineItem1.Id);
                insert testquoteLineItem2;
                QuoteLineItem testquoteLineItem3=PGITestUtilities.getTestQuoteLineItem(testprod3.Id,testSer.Id,testQuote.Id,pbe,testquoteLineItem1.Id);
                insert testquoteLineItem3;   
                list<QuoteLineItem> quotelst=[Select q.UnitPrice, q.Service__c, q.QuoteId, q.Quantity, q.Product__c, q.PricebookEntry.Name, q.PricebookEntryId, q.Approval_Status__c From QuoteLineItem q limit 1000];
            set<Id> quoItemid=new set<Id>();
            
            for(quoteLineItem quoItem:quotelst) 
              quoItemid.add(quoItem.Id);
            list<PGIProduct> prolst=getConfigureServiceUsage(quoItemid,testQuote.Id);
          //  system.assertNotEquals(prolst.size(),0);
        PGITestUtilities.setTestParameter('quoteId', testQuote.Id); 
      ProductSelectionController proSelcon=new ProductSelectionController();
      proSelcon.ProdUsageDetails=prolst;
      list<Id> Addproducts=new list<Id>();
      Addproducts.add(testprod3.Id);
      proSelcon.Addproducts=Addproducts;
     proSelcon.AddAncillaryProducts(); 
   }
   
     
   @istest(seeAlldata=true)
   private static void test_deletelineItem(){
     
        Account testAcc= PGITestUtilities.getAccountDetails();
        insert testAcc;
        Opportunity testOpp= PGITestUtilities.getOpportunityDetails();      
        insert testOpp;
        Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
        insert cont;
        Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        insert testQuote;
        Region__c region = PGITestUtilities.getRegionDetails();
        insert region;
        list<Product__c> allProduct= new list<Product__c>();
        Product__c testprod1 = PGITestUtilities.getProductDetails('Add-on', 'TestAddon','10111111'); 
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
        OpportunityLineItem oli = PGITestUtilities.getOpportunityLineItemDetails(testOpp.Id, pbe.Id);
        insert oli;    
        QuoteLineItem testquoteLineItem1=PGITestUtilities.getServiceQuoteLineItem(testprod1.Id,testSer.Id,testQuote.Id,pbe);
        insert testquoteLineItem1;
        QuoteLineItem testquoteLineItem2=PGITestUtilities.getTestQuoteLineItem(testprod2.Id,testSer.Id,testQuote.Id,pbe,testquoteLineItem1.Id);
        insert testquoteLineItem2;
        QuoteLineItem testquoteLineItem3=PGITestUtilities.getTestQuoteLineItem(testprod3.Id,testSer.Id,testQuote.Id,pbe,testquoteLineItem1.Id);
        insert testquoteLineItem3;    
        list<QuoteLineItem> quotelst=[Select q.UnitPrice, q.Service__c, q.QuoteId, q.Quantity, q.Product__c, q.PricebookEntry.Name, q.PricebookEntryId, q.Approval_Status__c, q.Line_Margin_Over_Term__c From QuoteLineItem q limit 1000 ];
             set<Id> quoItemid=new set<Id>();
            for(quoteLineItem quoItem:quotelst)
              quoItemid.add(quoItem.Id);
            list<PGIProduct> prolst=getConfigureServiceUsage(quoItemid,testQuote.Id);
             //system.debug('#prolst'+testquoteLineItem1);  
            //system.debug('#prolst'+prolst);  
            PGITestUtilities.setTestParameter('quoteId', testQuote.Id); 
        ProductSelectionController proSelcon=new ProductSelectionController();
        proSelcon.ProdUsageDetails=prolst;
        
        for(PGIProduct pro: proSelcon.ProdUsageDetails){
                
          for(PGIProduct.ProductList prlst:pro.productLst){
                if(prlst.customRowId!=null)
                proSelcon.selectedRowId=prlst.customRowId ;
          }
        }
        decimal selectedRowId ;
        proSelcon.deletelineItem();
        selectedRowId=47.0;
        ProductSelectionController controller = new ProductSelectionController() ;
        string levelOfAuthorithy=null ;
      delete testQuote;
      // 
   }
   
   @istest(seeAlldata=false)
    private static void test_Cancel(){
        ProductSelectionController proSelcon=new ProductSelectionController();
          proSelcon.Cancel();
      }
      @istest(seeAlldata=false)
    private static void test_back(){
        //Case1:
         ProductSelectionController proSelcon=new ProductSelectionController();
         proSelcon.back();
         
      } 
      @istest(seeAlldata=false)
    private static void test_ClearFromList(){ 
        ProductSelectionController proSelcon=new ProductSelectionController();
        proSelcon.Solutions=new list<String>();
        proSelcon.solutions.add('test123');
        proSelcon.ClearFromList();
        system.assertEquals(proSelcon.Solutions.size(),0); 
      }
  /*    @istest(seeAlldata=true)
private static void test_EnterUsage(){
        //Case1:
        test.starttest();
          Account testAcc= PGITestUtilities.getAccountDetails();
        insert testAcc;
        Opportunity testOpp= PGITestUtilities.getOpportunityDetails();      
        insert testOpp;
        Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
        insert cont;
        Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        insert testQuote;
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
                QuoteLineItem testquoteLineItem1=PGITestUtilities.getServiceQuoteLineItem(testprod1.Id,testSer.Id,testQuote.Id,pbe);
                insert testquoteLineItem1;
                QuoteLineItem testquoteLineItem2=PGITestUtilities.getTestQuoteLineItem(testprod2.Id,testSer.Id,testQuote.Id,pbe,testquoteLineItem1.Id);
                insert testquoteLineItem2;
                QuoteLineItem testquoteLineItem3=PGITestUtilities.getTestQuoteLineItem(testprod3.Id,testSer.Id,testQuote.Id,pbe,testquoteLineItem1.Id);
                insert testquoteLineItem3;    
        list<QuoteLineItem> quotelst=[Select q.UnitPrice, q.Service__c, q.QuoteId, q.Quantity, q.Product__c, q.PricebookEntry.Name, q.PricebookEntryId, q.Approval_Status__c From QuoteLineItem q  where id=:testquoteLineItem1.Id];
              set<Id> quoItemid=new set<Id>();
            
            for(quoteLineItem quoItem:quotelst)
             
              quoItemid.add(quoItem.Id);
             
            list<PGIProduct> prolst=getConfigureServiceUsage(quoItemid,testQuote.Id);
        ProductSelectionController proSelcon=new ProductSelectionController();
        list<PGIProduct.ProductList> ServProdDetails=new list<PGIProduct.ProductList>();
     
      
       proSelcon.ServProdDetails=prolst[1].productLst;
       for(PGIProduct.ProductList pi:proSelcon.ServProdDetails)
       pi.selectedproduct=true; 
       
        proSelcon.EnterUsage();
    
        ProductSelectionController temp = new ProductSelectionController();
       temp.EnterUsage();
        
        test.stoptest();
        
      }   */
  
       
        @istest(seeAlldata=true) 
     private static void test_Save(){
        //Case1:
            Account testAcc= PGITestUtilities.getAccountDetails();
        insert testAcc;
        Opportunity testOpp= PGITestUtilities.getOpportunityDetails();      
        insert testOpp;
        Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
        insert cont;
        Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        insert testQuote;
        Region__c region = PGITestUtilities.getRegionDetails();
        insert region;
        list<Product__c> allProduct= new list<Product__c>();
        Product__c testprod1 = PGITestUtilities.getProductDetails('Add-on', 'TestAddon','10111111');
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
        list<QuoteLineItem> quotelst=[Select q.UnitPrice, q.Service__c, q.QuoteId, q.Quantity, q.Product__c, q.PricebookEntry.Name, q.PricebookEntryId, q.Approval_Status__c From QuoteLineItem q limit 10];
             set<Id> quoItemid=new set<Id>();
            for(quoteLineItem quoItem:quotelst)
              quoItemid.add(quoItem.Id);
            list<PGIProduct> prolst=getConfigureServiceUsage(quoItemid,testQuote.Id);
            PGITestUtilities.setTestParameter('quoteId', testQuote.Id); 
        ProductSelectionController proSelcon=new ProductSelectionController();
        proSelcon.ProdUsageDetails=prolst;
        proSelcon.saveOffers();
        
       
       
        //Case2:
        PGITestUtilities.setTestParameter('quoteId', '123'); 
        proSelcon=new ProductSelectionController();
        
        proSelcon.saveOffers();
     boolean validateServBillingFreq=true; 
    }
   
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
                            
        QuotelineItems=[Select QuoteId,Contract_Term__c,QuantityChange__c,BidPriceChange__c,ContractTermChange__c, Product__c, Id,Quote_Line_Item__c, Service__c,Quantity,Quantity__c,BidPrice__c  ,Line_Margin_Over_Term__c
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
               /* quoteLines= mapQuoteLineByService.get(lineItem.Quote_Line_Item__c);
                if(quoteLines==null){
                    quoteLines = new list<QuoteLineItem>();
                }
                quoteLines.add(lineItem);
                mapQuoteLineByService.put(lineItem.Quote_Line_Item__c,quoteLines);
               */
          }
        }
        
        serviceLst=[Select s.Service__r.name, s.Service__c, s.Product__r.Min_Commit__c, s.Product__r.Name,s.Product__r.Id,s.Product__r.List_Rate__c, 
                        s.Product__r.Cost_Rate__c, s.Product__r.Unit_of_Measure__c,s.Default__c,s.Product__r.ProductType__c,s.service__r.Solution__c,
                        s.Product__r.Term_Length__c,s.Product__r.Minimum_Quantity__c,s.Product__r.Maximum_Quantity__c,s.Product__r.Billing_Frequency__c 
                        ,s.Product__r.Regions__c,s.Product__r.Channels__c, s.Product__r.ProductCode__c, s.Product__r.CreatedById, s.Product__r.CreatedDate
                        ,s.Product__r.CurrencyIsoCode,s.Product__r.Description__c
                        From ServiceCategory__c s where  s.Service__c=:setServiceIds  order by s.Product__r.Billing_Frequency__c desc];
     
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
}