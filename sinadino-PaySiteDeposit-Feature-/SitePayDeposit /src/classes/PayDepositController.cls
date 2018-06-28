public with sharing class PayDepositController {


        public boolean disableSubmit{get; set;}
        public String fName{get;set;}
        public Opportunity currentRecord{get;set;}
        private OpportunityLineItem[] lineItems;
        private Id contactId;

    
        
    
        public PayDepositController (){

            this.disableSubmit = false;
            currentRecord = [SELECT Id, Name, Email_ID__c, Phone_Number__c, First_Name__c, Amount, 
            Deposit__c, Event_Date__c, Event_Location__c, Event_START_Time__c, StageName, Type, 
            HasOpportunityLineItem, Opportunity.Account.Name,
            (SELECT Id, ContactId, IsPrimary FROM OpportunityContactRoles WHERE IsPrimary = true)
            FROM Opportunity WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
            if ( currentRecord.OpportunityContactRoles.size() > 0) {
                this.contactId = currentRecord.OpportunityContactRoles[0].contactId; 
             } else {
                  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Could not find primary opportunity contact'));
                  this.disableSubmit = true;
             }
             System.debug('The value is: ' + currentRecord.Phone_Number__c);
 
      } 
       
       public Opportunity getOpportunity(){
       return currentRecord;
           }
    
       public PageReference submitPayment() {
            PageReference nextPage;

            string BaseURL = ApexPages.currentPage().getHeaders().get('Host');
            pageReference cView = Page.SitePayDeposit;
            cView.getparameters().put('id',currentRecord.Id);
            string fullURL = 'https://'+BaseURL + cView.getUrl();
            
            pymt__PaymentX__c payment = new pymt__PaymentX__c(
                Name = ('Deposit: ' + currentRecord.Name).left(80),
                pymt__Status__c = 'In Process',
                pymt__Amount__c = currentRecord.Deposit__c,
                pymt__Currency_ISO_Code__c = 'USD',
                pymt__Contact__c =  this.contactId,
                pymt__Transaction_Type__c = 'Payment',
                pymt__Opportunity__c = currentRecord.id  
                );   
                
             insert payment;    
             nextPage= Page.pymt__SiteCheckout;
             nextPage.getParameters().put('pid',payment.Id);
             nextPage.getParameters().put('cancel_url',fullURL);   
             return nextPage;
       }

       //this is where we pull all the Product line items
         public OpportunityLineItem[] getLineItems() {
          if (this.lineItems == null && currentRecord.Id <> null && currentRecord.HasOpportunityLineItem ) {
              this.lineItems = [Select UnitPrice, TotalPrice, SystemModstamp, SortOrder, ServiceDate, Quantity, PricebookEntryId, PricebookEntry.Name,
                  pricebookentry.product2.pymt__on_Payment_Completed__c, pricebookentry.productcode,
                  pricebookentry.product2.pymt__Taxable__c,
                  pricebookentry.product2.pymt__Tangible__c,
                  OpportunityId, ListPrice, LastModifiedDate, LastModifiedById, IsDeleted, Id, Description, CreatedDate, CreatedById 
              From OpportunityLineItem 
              where OpportunityId = :currentRecord.Id];       
          }
        return this.lineItems;
        
       }

   }