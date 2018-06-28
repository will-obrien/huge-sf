global class DefaultValues extends zqu.CreateQuoteController.PopulateDefaultFieldValuePlugin{ 
   global override void populateDefaultFieldValue
      (SObject record, zqu.PropertyComponentController.ParentController pcc)
   {   
      super.populateDefaultFieldValue(record, pcc);
      //String oppId = ApexPages.currentPage().getParameters().get('oppId');
      //Opportunity opp = [select CloseDate from Opportunity where id = :oppId];
      String crmAccountId = ApexPages.currentPage().getParameters().get('crmAccountId');
      Account acc = [select Name from Account where id = :crmAccountId];
      record.put('name',Date.today().format() + ' ' + acc.name);
      record.put('zqu__InitialTerm__c', 15);
      record.put('zqu__RenewalTerm__c', 12);
      
      RecordType rt = [SELECT Name FROM RecordType WHERE Id = :(ID) record.get('RecordTypeId')];    
      if (rt.name <> 'Renewal') {
        record.put('zqu__StartDate__c', Date.today());
      }
      
      List<Contact> contacts = [SELECT Id, Name FROM Contact WHERE Account.Id = :crmAccountId];        
       
      // Assuming the contacts are present set the billTo and soldTo to the first contact        
      if  (contacts.size() > 0) {            
         // System.debug('mp: about to add ' + contacts[0].Id + ' as a contact ID');            
         record.put('zqu__BillToContact__c', contacts[0].Id);            
         record.put('zqu__SoldToContact__c', contacts[0].Id);
         super.setLookupOptions(pcc);            
       
         // Now retrieve the lookup component options            
         zqu.LookupComponentOptions billToOptions = super.getLookupOption('zqu__BillToContact__c');            
         billToOptions.targetId = contacts[0].Id;            
         billToOptions.targetName = contacts[0].Name;            
         zqu.LookupComponentOptions soldToOptions  = super.getLookupOption('zqu__SoldToContact__c');            
         soldToOptions.targetId = contacts[0].Id;            
         soldToOptions.targetName = contacts[0].Name; 
      }          
      zqu__Quote_Template__c template= (zqu__Quote_Template__c)[SELECT Id,Name FROM zqu__Quote_Template__c WHERE id ='a0YF0000003OWdeMAG'];
      record.put('zqu__QuoteTemplate__c', template.Id);
      super.setLookupOptions(pcc);            
       
      // Now retrieve the lookup component options            
      zqu.LookupComponentOptions quoteTemplate = super.getLookupOption('zqu__QuoteTemplate__c');            
      quoteTemplate.targetId = template.Id;            
      quoteTemplate.targetName = template.Name;   

      //record.put('zqu__ValidUntil__c', opp.CloseDate);
      //record.put('zqu__PaymentMethod__c', 'other'); 
      //record.put('zqu__PaymentMethod__c', 'Check'); 
      //record.put('zqu__InvoiceProcessingOption__c', 'Subscription');   
      //record.put('zqu__ValidUntil__c', Date.today().addDays(30));   
      //record.put('zqu__StartDate__c', Date.today());   
      //record.put('zqu__PaymentMethod__c', 'Check'); 
   }
}