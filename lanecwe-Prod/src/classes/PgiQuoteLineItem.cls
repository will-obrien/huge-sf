public with sharing class PgiQuoteLineItem {
        
        public string ProductName{get;set;}
        public string QuoteName{get;set;}
        public double Bidprice {get;set;}
        public double Totalprice{get;set;}
        public double salesprice{get;set;}
        public double Quantity{get;set;}
               
        public pgiQuoteLineItem(QuoteLineItem quotel){
        this.ProductName=quotel.Product__r.Name;
        this.Bidprice=quotel.BidPrice__c;
        this.TotalPrice=quotel.TotalPrice;
        this.salesprice=quotel.UnitPrice;
        this.quantity=quotel.Quantity;
       }
}