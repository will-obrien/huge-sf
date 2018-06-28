public class PGIProduct {   
    public string serviceName {get; set;}
    public Id serviceId {get; set;}
    public boolean selectedServ{get; set;}
    public list<ProductList>productLst {get; set;}
    public list<selectOption> productOptions {get; set;}
    public list<selectOption> ancillaryOptions {get; set;}
    public list<Id> addedProducts {get; set;}
    public list<Id> ancillaryProducts {get; set;}
    public Id quoteLineItemId {get; set;}
    public decimal latestRowId {get; set;}
    
    public PGIProduct(ServiceCategory__c  prod){                           
       this.serviceName = prod.Service__r.Name;    
       this.serviceId=prod.Service__c;  
       this.selectedServ=false;     
    }
   
    public PGIProduct(QuoteLineItem  quoteLine, string serName){                           
       this.quoteLineItemId = quoteLine.Id;
       this.serviceId=quoteLine.Service__c;  
       this.selectedServ=false;  
       this.serviceName = serName;  
    }
        
    public class ProductList implements Comparable {
        public decimal customRowId {get; set;}
        public Id productId{get; set;}
        public String productName {get; set;}
        public String productName1 {get; set;}
        public string productType {get; set;}
        public String unit {get; set;}
        public decimal MaxMeeting {get; set;}
        public Integer quantity {get; set;}
        public double listPrice {get; set;}
        public String targetPrice {get; set;}      
        public double InstallmentPayment{get;set;} 
        public String meetAuthority {get; set;}     
        public decimal authorityRate1 {get; set;}
        public decimal authorityRate2 {get; set;}
        public decimal authorityRate3 {get; set;}
        public decimal authorityRate4 {get; set;}
        public decimal authorityRate5 {get; set;}
        public decimal authorityRate6 {get; set;}
        public string audiominutes {get;set;}
        public String quoteLineItemId {get; set;}
        public Boolean isEditChecked  {get; set;}
        public double SubscriptionTerms {get;set;} 
        public boolean isPGILicense  {get;set;}
        public decimal listrate{get;set;}
        public boolean selectedproduct  {get; set;}
        public string Sname  {get; set;}        
        public double CostRate {get; set;}
        public decimal Bidprice {get; set;} 
        public string levelofauthority {get; set;} 
        public string minutes{get;set;}
        public boolean isDefaultProduct  {get; set;}
        public boolean isServiceProduct  {get; set;}
        public boolean isAudioProduct {get; set;}
        public string serviceName {get; set;}       
        public string serviceId {get; set;}
        public string masterServiceId {get; set; }
        public double totalPrice {get; set;}        
        public Integer termLength{get;set;}
        public Integer minQuantity{get;set;}
        public Integer maxQuantity{get;set;}
        public boolean isPGILicense1 {get;set;}
        public String billingFrequency{get;set;}
        public String Region{get;set;}
        public String Channel{get;set;}
        public String ProductCode{get;set;}
        public string contractgroup{get;set;}
        public String prodCurrency{get;set;}
        public Datetime CreatedDate{get;set;}
        public String CreatedBy{get;set;}
        public string approvalStatus {get; set;}
        public string approvalLevel{get;set;}
        public string solutionId {get; set;}
        public Double lineMarginOverTerm {get; set;}
        public Double MRR {get;set;}
        public Double contractValue {get;set;}
        public Double annualValue {get;set;}
        public Double costRtae {get; set;}
        public string Description{get;set;}
        public string ContractDocumentGroup{get;set;}
        public double sellPricePDF{get;set;}
        public double valueoverTermPdf{get;set;}
        public double termlengthPdf{get;set;}
        public Integer quantityPdf{get;set;}
        public string changeType {get;set;}
        public decimal oldQuantity{get;set;}
        public double  oldbidPrice{get;set;}
        public Integer oldtermLength{get;set;}
        public String nonLicensedContractDocumentGroup{get;set;}
        public Boolean minCommit{get;set;}
        
        public Integer compareTo(Object compareTo) {
	        PGIProduct.ProductList compareToObj = (PGIProduct.ProductList)compareTo;
	        return this.productName.compareTo(compareToObj.productName);
    	}
        
        public ProductList(ServiceCategory__c  prod){
           //system.debug('I am A');
            this.productName=prod.Product__r.Name;
            this.MaxMeeting=prod.Product__r.MaxMeeting__c ;
            this.productId=prod.Product__r.Id;
            this.selectedproduct=false; 
            this.Sname=prod.Service__r.name;
            this.isDefaultProduct=prod.Default__c;
            this.unit=prod.Product__r.Unit_of_Measure__c;
            this.CostRate=prod.Product__r.Cost_Rate__c;        
            this.serviceId = prod.service__r.Id;
            this.productId=prod.Product__r.Id;
            this.listrate=prod.Product__r.List_Rate__c;
            this.productType= prod.Product__r.ProductType__C;
            this.termLength=Integer.valueof(prod.Product__r.Term_Length__c);
            this.minQuantity=Integer.valueof(prod.Product__r.Minimum_Quantity__c);
            this.maxQuantity=Integer.valueof(prod.Product__r.Maximum_Quantity__c);
            this.billingFrequency=prod.Product__r.Billing_Frequency__c;
            this.Region=prod.Product__r.Regions__c;
            this.Channel=prod.Product__r.Channels__c;
            this.ProductCode=prod.Product__r.ProductCode__c;
            this.prodCurrency=prod.Product__r.CurrencyIsoCode;
            this.CreatedDate=prod.Product__r.CreatedDate;
            this.CreatedBy=prod.Product__r.CreatedById;
            this.solutionId = prod.Service__r.Solution__c;
            this.Description=prod.Product__r.Description__c;
            this.Bidprice=(prod.Product__r.List_Rate__c != null)?prod.Product__r.List_Rate__c.setScale(3):prod.Product__r.List_Rate__c ;
            this.isPGILicense=prod.Product__r.isPGILicense__c;
            if(string.valueof(prod.Service__r.name).equalsIgnoreCase(string.valueof(prod.Product__r.Name)) ){
                this.isServiceProduct = true;
            }else{
                this.isServiceProduct = false;
            }
            if(isServiceProduct){
                this.quantity =Integer.valueof(prod.Product__r.Minimum_Quantity__c);
            }else{
                this.quantity=this.quantity;
            }
            this.minCommit = prod.Product__r.Min_Commit__c;
        }
       //used in QuoteSelectionUtilities.getConfigureServiceUsage
        public ProductList(ServiceCategory__c  prod,QuoteLineItem quoteLineInfo){
          //system.debug('I am B');
            this.productName=prod.Product__r.Name;
            this.productId=prod.Product__r.Id;
            this.selectedproduct=false; 
            this.Sname=prod.Service__r.name;
            this.isDefaultProduct=prod.Default__c;
            this.quoteLineItemId = quoteLineInfo.Id;  
            this.serviceId = prod.service__r.Id;
            this.productId=prod.Product__r.Id;
            this.unit=prod.Product__r.Unit_of_Measure__c;
            this.ListRate=prod.Product__r.List_Rate__c;
            this.quantity  =Integer.valueof( quoteLineInfo.Quantity__c);
            this.BidPrice  = (quoteLineInfo.BidPrice__c != null)?quoteLineInfo.BidPrice__c.setScale(3):quoteLineInfo.BidPrice__c ;
            this.productType= prod.Product__r.ProductType__c;
            this.termLength=Integer.valueof(quoteLineInfo.Contract_Term__c);
            this.minQuantity=Integer.valueof(prod.Product__r.Minimum_Quantity__c);
            this.maxQuantity=Integer.valueof(prod.Product__r.Maximum_Quantity__c);
            this.billingFrequency=prod.Product__r.Billing_Frequency__c;
            this.solutionId = prod.Service__r.Solution__c;
            this.masterServiceId = (quotelineInfo.Quote_Line_Item__c==null?quoteLineInfo.Id:quotelineInfo.Quote_Line_Item__c);
            this.lineMarginOverTerm = quoteLineInfo.Line_Margin_Over_Term__c;
            this.Description=prod.Product__r.Description__c;
            this.oldQuantity=quoteLineInfo.QuantityChange__c;
            this.oldbidPrice=quoteLineInfo.BidPriceChange__c;
            this.oldtermLength=Integer.valueof(quoteLineInfo.ContractTermChange__c);
            
            if(oldQuantity==null ){
                this.oldQuantity=quoteLineInfo.Quantity__c;
            }
            if(oldbidPrice==null ){
                this.oldbidPrice=quoteLineInfo.BidPrice__c;
            }
           if(oldtermLength==null){
                this.oldtermLength=Integer.valueof(quoteLineInfo.Contract_Term__c);
           }
            if(string.valueof(prod.Service__r.name).equalsIgnoreCase(string.valueof(prod.Product__r.Name))){
                this.isServiceProduct = true;
            }else{
                this.isServiceProduct = false;
            }
            this.minCommit = prod.Product__r.Min_Commit__c;
        }
        
        //QuoteLineItemUtil
        public ProductList(Product__c  productDetails, QuoteLineItem quoteLineInfo,string LevelAuthority, ServiceCategory__c serviceProduct){
        
          //system.debug('I am C');
            this.serviceName= serviceProduct.service__r.Name;
            this.serviceId = serviceProduct.service__r.Id;
            this.productId=serviceProduct.Product__r.Id;
            this.minQuantity=Integer.valueof(productDetails.Minimum_Quantity__c);
            this.productName =  productDetails.Name;
            this.unit    = productDetails.Unit_Of_Measure__c;
            this.productName1=productDetails.Addon_Feature_Name_External__c;
            this.quantity  = Integer.valueof(quoteLineInfo.Quantity__c);
            this.MaxMeeting=productDetails.MaxMeeting__c ;
            this.listPrice = productDetails.List_Rate__c;
            this.audiominutes=string.valueof(productDetails.add__c); 
            this.targetPrice = productDetails.Target_Price__c;
            this.BidPrice = (quoteLineInfo.BidPrice__c != null)?quoteLineInfo.BidPrice__c.setScale(3):quoteLineInfo.BidPrice__c ;         
            this.levelofauthority=productDetails.Authority_Level__c ;
            this.authorityRate1= productDetails.Auth_Rate1__c;
            this.authorityRate2= productDetails.Auth_Rate2__c;
            this.authorityRate3= productDetails.Auth_Rate3__c;
            this.authorityRate4= productDetails.Auth_Rate4__c;
            this.SubscriptionTerms  =double.valueof(productDetails.SubscriptionTerms__c);
            this.authorityRate5= productDetails.Auth_Rate5__c;
            this.authorityRate6= productDetails.Auth_Rate6__c;
            this.authorityRate6= productDetails.Auth_Rate6__c;
            
            this.billingFrequency=productDetails.Billing_Frequency__c;
            this.termLength=Integer.valueof(quoteLineInfo.Contract_Term__c);
            this.costRate = productDetails.Cost_Rate__c;
            this.quoteLineItemId = quoteLineInfo.Id;    
            this.isPGILicense =productDetails.isPGILicense__c;
            this.productType= productDetails.ProductType__c;
            this.masterServiceId = quotelineInfo.Quote_Line_Item__c;
            this.totalPrice = quotelineInfo.TotalPrice__c;
            this.isDefaultProduct = serviceProduct.Default__c;
            this.approvalStatus = quotelineInfo.Approval_Status__c;
            this.approvalLevel=quotelineInfo.Approval_Level__c;
            this.solutionId = serviceProduct.Service__r.Solution__c;
            this.lineMarginOverTerm = quoteLineInfo.Line_Margin_Over_Term__c;
            this.Description=productDetails.Description__c;
            this.ContractDocumentGroup=productDetails.ContractDocumentGroup__c;
            this.sellPricePDF=double.valueof(quoteLineInfo.BidPrice__c);
            this.valueoverTermPdf=double.valueof(quotelineInfo.TotalPrice__c);
            this.termlengthPdf=double.valueof(productDetails.Term_Length__c);
            this.quantityPdf=integer.valueof(quoteLineInfo.Quantity__c);
            this.contractValue=quoteLineInfo.Contract_Value__c;
            this.annualValue=quoteLineInfo.Annual_value__c;
            this.MRR=quoteLineInfo.MRR__c;
            this.changeType =quoteLineInfo.ChangeType__c;
            this.oldQuantity=quoteLineInfo.QuantityChange__c;
            this.oldbidPrice=quoteLineInfo.BidPriceChange__c;
            this.oldtermLength=Integer.valueof(quoteLineInfo.ContractTermChange__c);
            this.nonLicensedContractDocumentGroup = productDetails.Non_License_ContractDocumentGroup__c;
            
            if(oldQuantity==null ){
                this.oldQuantity=quoteLineInfo.Quantity__c;
            }
            if(oldbidPrice==null ){
                this.oldbidPrice=quoteLineInfo.BidPrice__c;
            }
           if(oldtermLength==null){
                this.oldtermLength=Integer.valueof(quoteLineInfo.Contract_Term__c);
           }
            if(approvalStatus != null && approvalStatus =='Pending for Approval' || approvalStatus =='Approval Required'){
                this.meetAuthority='No';
            } else{
                this.meetAuthority='Yes';
            }           
            if(serviceProduct.Service__r.name!=null && productDetails.Name!=null  && string.valueof(serviceProduct.Service__r.name).equalsIgnoreCase

                (string.valueof(productDetails.Name))){
                isServiceProduct = true;
            }else{
                isServiceProduct = false;
            }
            LevelAuthority= (LevelAuthority==null?'':levelAuthority);
            if(string.valueof(productDetails.Name).containsIgnoreCase('Audio')){
                this.isAudioProduct= true;
            }else{
                this.isAudioProduct= false;
            }
            this.minCommit = serviceProduct.Product__r.Min_Commit__c;
        }
    }
}