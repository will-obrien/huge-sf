/**

Test Case for the following Controller Extensions:
- CreateIntermediateCertController
- X509CertificateCheckerUtility

**/

@isTest 
public class CreateIntermediateCertControllerTest{

    static testmethod void testInterMediateCert2(){
        
        Account accountSo = New Account(name='testAccount');
        insert accountSo;
        
        // create a standard controller instance 
         ApexPages.StandardController standardcontroller = new ApexPages.StandardController(accountSo);
         
         CreateIntermediateCertController createInterCertController= new CreateIntermediateCertController(standardController);
        
         PageReference pageRef = Page.CreateIntermediateCert;
         pageRef.getParameters().put('id', String.valueOf(accountSo.Id));
         Test.setCurrentPage(pageRef);
         createInterCertController.pemInfoStr  = 'testPEM';
         createInterCertController.submit();
         createInterCertController.parentAccountId = accountSo.id;
         createInterCertController.skip();
         createInterCertController.createIntermediateCert();
         Account parentAccount2 = getParentAccount();
         insert parentAccount2;
         createInterCertController.parentAccountId=   parentAccount2.id; 
         createInterCertController.updateIntermediateCert();
         createInterCertController.cancel(); 
         createInterCertController.cloneIntermediateCert();    
    }
    
    static testMethod void testInterMediateCert1() {
    
    User loggedInUser = [SELECT Id from User WHERE Id = :UserInfo.getUserId()];
      
      System.runAs(loggedInUser){
          
          Account acc = new Account(Name='Test Account Name223223##');
          insert acc;
         
          Contact con = new Contact(LastName = 'Contact Last Name', AccountId = acc.id);
          insert con;
      
          UserRole urole = [Select PortalType, PortalAccountId From UserRole where PortalType = 'CustomerPortal' limit 1];
          
          User user = new User();
          //user.UserRoleId = urole.Id;
          //user.ProfileID = [Select Id From Profile Where UserType = 'PowerCustomerSuccess' LIMIT 1].id;
          user.EmailEncodingKey = 'ISO-8859-1';
          user.LanguageLocaleKey = 'en_US';
          user.TimeZoneSidKey = 'America/New_York';
          user.LocaleSidKey = 'en_US';
          user.FirstName = 'first';
          user.LastName = 'last';
          user.Username = 'test@test1234098.com';   
          user.CommunityNickname = 'testUser09887123';
          user.Alias = 't1';
          user.Email = 'no@email.com';
          user.IsActive = true;
          user.ContactId = con.Id;
          
          user.ProfileID = [SELECT Id FROM Profile WHERE Name = 'Customer Community Plus User - CAs' AND UserType = 'PowerCustomerSuccess' LIMIT 1].id;
          user.PortalRole = 'Manager';
          insert user;
            
        AccountShare aShare = new AccountShare();
        aShare.AccountAccessLevel = 'Edit';
        aShare.ContactAccessLevel = 'Edit';
        aShare.OpportunityAccessLevel = 'Edit';
        aShare.RowCause = 'Manual';
        aShare.AccountId = acc.Id;
        aShare.UserOrGroupId = user.Id;
        insert aShare;
        
          System.RunAs(user) {
              
                // do all of my tests
                Account acc1 = new Account(Name='Test Account123$$ CA Owner', recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CA Owner').getRecordTypeId());
                insert acc1;
              
                // create a ROOT CA
                Account rootCA = New Account();
                rootCA.recordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Root Certificate').getRecordTypeId(); 
                rootCa.name = 'testRoot';
                rootCa.parentId = acc.id;
                rootCa.X_509_Certificate_PEM__c = 'abc';
                insert rootCa;
         
                 // create intermediate CA
                 Account testAccount = New Account();
                 testAccount.name = 'Hello-';
                 testAccount.recordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Intermediate Certificate').getRecordTypeId();
                 testAccount.Status__c='Removed';
                 testAccount.parentId = rootca.id;
                 testAccount.X_509_Certificate_PEM__c = 'abc';
                
                 insert testAccount;
             
             test.startTest();
             
                 ApexPages.StandardController standardcontroller = new ApexPages.StandardController(testAccount);
                 
                 CreateIntermediateCertController createInterCertController= new CreateIntermediateCertController(standardController);
                
                 PageReference pageRef = Page.CreateIntermediateCert;
                 pageRef.getParameters().put('id', String.valueOf(testAccount.Id));
                 Test.setCurrentPage(pageRef);
                 createInterCertController.pemInfoStr  = 'testPEM';
                 createInterCertController.submit();
                 createInterCertController.parentAccountId = testAccount.id;
                 createInterCertController.skip();
                 createInterCertController.createIntermediateCert();
                 Account parentAccount2 = getParentAccount();
                 insert parentAccount2;
                 createInterCertController.parentAccountId=   parentAccount2.id; 
                 createInterCertController.updateIntermediateCert();
                 createInterCertController.cancel(); 
                 createInterCertController.cloneIntermediateCert(); 
                 
                 Test.stoptest();
          }
      }
    
    
    }
    /*
    static testMethod void validateCreateInterCert() {
    test.startTest(); 
    
     Set<String> customerUserTypes = new Set<String> {'CSPLiteUser', 'PowerPartner', 'PowerCustomerSuccess',   'CustomerSuccess'};
        // create owner account
        Account acc1 = new Account (
        Name = 'newAcc1',  X_509_Certificate_PEM__c = 'abc',
        recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CA Owner').getRecordTypeId()
        );  
        insert acc1;
        
        //create dummy contact
        Contact conCase = new Contact (
        AccountId = acc1.id,
        LastName = 'portalTestUserv1'
        );
        insert conCase;

        // get profile 
        Profile prfile = [select Id,name from Profile where UserType in :customerUserTypes limit 1];
        
        // create portal user, note that it has a contact which is associated with an owner account
        User newUser1 = new User(
        profileId = prfile.id,
        username = 'newUser@mozilla.com',
        email = 'pb@f.com',
        emailencodingkey = 'UTF-8',
        localesidkey = 'en_US',
        languagelocalekey = 'en_US',
        timezonesidkey = 'America/Los_Angeles',
        alias='nuser',
        lastname='lastname',
        contactId = conCase.id
        );
        insert newUser1;
        
      // execute the scenario as a portal user
       System.runAs(newUser1) {
        
        // create a ROOT CA
        Account rootCA = New Account();
        rootCA.recordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Root Certificate').getRecordTypeId(); 
        rootCa.name = 'testRoot';
        rootCa.parentId = acc1.id;
        rootCa.X_509_Certificate_PEM__c = 'abc';
        insert rootCa;
     
     // create intermediate CA
     Account testAccount = New Account();
     testAccount.name = 'Hello';
     testAccount.recordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Intermediate Certificate').getRecordTypeId();
     testAccount.Status__c='Removed';
     testAccount.parentId = rootca.id;
     testAccount.X_509_Certificate_PEM__c = 'abc';
    
     insert testAccount;
     
          ApexPages.StandardController standardcontroller = new ApexPages.StandardController(testAccount);
    
        

     CreateIntermediateCertController createInterCertController= new CreateIntermediateCertController(standardController);
    
     PageReference pageRef = Page.CreateIntermediateCert;
     pageRef.getParameters().put('id', String.valueOf(testAccount.Id));
     Test.setCurrentPage(pageRef);
     createInterCertController.pemInfoStr  = 'testPEM';
     createInterCertController.submit();
     createInterCertController.parentAccountId = testAccount.id;
     createInterCertController.skip();
     createInterCertController.createIntermediateCert();
     Account parentAccount2 = getParentAccount();
     insert parentAccount2;
     createInterCertController.parentAccountId=   parentAccount2.id; 
     createInterCertController.updateIntermediateCert();
     createInterCertController.cancel(); 
     createInterCertController.cloneIntermediateCert();

     
     }
 test.stoptest();

     Account accountSo = New Account(name='testAccount' );
     insert accountSo;
    
     // create the parent account  - record type = Owner
//     Account parentAccount = getParentAccount();
 //    insert parentAccount;
    
    // create a standard controller instance 
     ApexPages.StandardController standardcontroller = new ApexPages.StandardController(accountSo);
    
        

     CreateIntermediateCertController createInterCertController= new CreateIntermediateCertController(standardController);
    
     PageReference pageRef = Page.CreateIntermediateCert;
     pageRef.getParameters().put('id', String.valueOf(accountSo.Id));
     Test.setCurrentPage(pageRef);
     createInterCertController.pemInfoStr  = 'testPEM';
     createInterCertController.submit();
     createInterCertController.parentAccountId = accountSo.id;
     createInterCertController.skip();
     createInterCertController.createIntermediateCert();
     Account parentAccount2 = getParentAccount();
     insert parentAccount2;
     createInterCertController.parentAccountId=   parentAccount2.id; 
     createInterCertController.updateIntermediateCert();
     createInterCertController.cancel(); 
     createInterCertController.cloneIntermediateCert();
    
    }*/
    
      // additional test method to handle the scenario
      // when pem info is not provided by the user
      static testMethod void validateCreateInterCert2() {
    
     // create the parent account  - record type = Owner
     Account parentAccount = getParentAccount();
     insert parentAccount;
    
    // create a standard controller instance 
     ApexPages.StandardController standardcontroller = new ApexPages.StandardController(parentAccount);
    
        

     CreateIntermediateCertController createInterCertController= new CreateIntermediateCertController(standardController);
    
     PageReference pageRef = Page.CreateIntermediateCert;
     pageRef.getParameters().put('id', String.valueOf(parentAccount.Id));
     Test.setCurrentPage(pageRef);
     createInterCertController.pemInfoStr  = null;
     createInterCertController.submit();
      createInterCertController.copyParentAuditData();
      
    Account childAccount = getChildAccount();
    childAccount.parentId = parentAccount.id;
     insert childAccount ;
     
     standardcontroller = new ApexPages.StandardController(childAccount);
    
        

     createInterCertController= new CreateIntermediateCertController(standardController);
    
     pageRef = Page.CreateIntermediateCert;
     pageRef.getParameters().put('id', String.valueOf(childAccount.Id));
     Test.setCurrentPage(pageRef);
     createInterCertController.copyParentAuditData();
    
    }
    
     public static Account getParentAccount()
    {
        Account parentAccount = new Account();
        parentAccount.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CA Owner').getRecordTypeID();
        parentAccount.name = 'ParentAccount';
        parentAccount.type = 'Owner';
        parentAccount.phone='2128425500';
        parentAccount.website  = 'https//www.test.com';
        parentAccount.valid_From_GMT__c= date.today()+1;
        parentAccount.valid_to_GMT__c= date.today()+10;
        parentAccount.company_website__c=  'https//www.test.com';
        parentAccount.organizational_type__c=  'Organizational Type';
        parentAccount.geographic_focus__c=  'Geographic focus';
        parentAccount.primary_market_customer_base__c = 'Primary Market';
        
        return parentAccount;
    }
    
     public static Account getChildAccount()
    {
        Account parentAccount = new Account();
        parentAccount.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Intermediate Certificate').getRecordTypeID();
        parentAccount.name = 'ChildAccount';
        parentAccount.type = 'Owner';
        parentAccount.phone='2128425500';
        parentAccount.website  = 'https//www.test.com';
        parentAccount.valid_From_GMT__c= date.today()+1;
        parentAccount.valid_to_GMT__c= date.today()+10;
        parentAccount.company_website__c=  'https//www.test.com';
        parentAccount.organizational_type__c=  'Organizational Type';
        parentAccount.geographic_focus__c=  'Geographic focus';
        parentAccount.primary_market_customer_base__c = 'Primary Market';
        
        return parentAccount;
    }
    
    
}