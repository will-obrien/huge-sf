public with sharing class TransientController {
   
      private final Id accountId ;
      transient public final String accountName {get; set; }
      public Account account {get; set;}
 
      public TransientController() {
          account = [select Id, Name from Account where id = :ApexPages.currentPage().getParameters().get('id')];
          accountId = account.Id ;
          accountName = account.Name ;
      }
       
      public PageReference save() {
          Account myAccount = [select name from Account where id = :accountId];
          myAccount.name = accountName ;
          update myAccount;
          
          update account;
          return null;
      }
      
      public PageReference refresh() {
          account = [select Id, Name from Account where id = :ApexPages.currentPage().getParameters().get('id')];
          
          return null;
      }
   
  }