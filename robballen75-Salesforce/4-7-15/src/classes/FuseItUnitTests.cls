/**
 * Test the contactSitecorePasswordTrigger and accountSitecoreRoleTrigger
 */
@isTest
private class FuseItUnitTests {



    /**
     * This will test the Account Sitecore Role trigger that will loop through all the 
     * Contacts belonging to the Account and set a Sitecore UserName and password when SitecoreRole__c is set to true 
     */
    static testMethod void UpdateAccountSitecoreRoleOnTrigger() {
        
        System.debug('UpdateAccountSitecoreRoleOnTrigger Start');

        // Create 5 test accounts where the SitecoreRole is not enabled. 2 test contacts per account.  
        List<Account> createdAccounts = createTestAccounts(5, 2, false);
        System.assertEquals(5, createdAccounts.size(), 'Failed to create 5 test Accounts');
        
        // Find existing accounts where the SitecoreRole is not enabled
        List<Account> accounts = [Select a.Name, a.Id, a.SitecoreRole__c, (Select Id from Contacts) 
                                  from Account a 
                                  where a.SitecoreRole__c = false
                                  limit 10];
                                  
        System.assertNotEquals(0, accounts.size(), 'Failed to find a test Account with SitecoreRole__c = false');
        
        Integer i = 0;
        for(Account a : accounts) {
            System.debug('UpdateAccountSitecoreRoleOnTrigger Loop Account Name ' + a.Name);
            
            if(a.Contacts != null) {
                System.debug('UpdateAccountSitecoreRoleOnTrigger on Account Name ' + a.Name);
                
                a.SitecoreRole__c = true;
                Database.SaveResult SR = database.update(a);
                System.assert(SR.isSuccess());
                
                i++;
                if(i > 5) break;
            }
        }
        System.assert(i > 0);
        
        System.debug('UpdateAccountSitecoreRoleOnTrigger End : Integer i = ' + i);
    }
    
    /**
     * This will test the Account Sitecore Role trigger that will loop through all the 
     * Contacts belonging to the Account and set a Sitecore UserName and password when SitecoreRole__c is set to true 
     */
    static testMethod void UpdateAccountSitecoreRoleOnBulkTrigger() {
        
        System.debug('UpdateAccountSitecoreRoleOnBulkTrigger Start');

		SetDefaultSitecoreUsernameField('Name');

        // Create 5 test accounts where the SitecoreRole is not enabled. 10 test contacts per account.  
        List<Account> accounts = createTestAccounts(5, 10, false);
        System.assertEquals(5, accounts.size());
        
        List<Account> accountsToUpdate = new List<Account>();
        
        for(Account a : accounts) {
            System.debug('UpdateAccountSitecoreRoleOnBulkTrigger on Account Name ' + a.Name + ' ID:' + a.Id );
            
            Account accountToUpdate = new Account(Id=a.Id);
            accountToUpdate.SitecoreRole__c = true;
                    
            accountsToUpdate.add(accountToUpdate);      

        }
        System.assertEquals(accounts.size(), accountsToUpdate.size());
        
        update(accountsToUpdate);
        
        // Check that all the contacts under the account have been enabled
        for(Account updatedAccount : accountsToUpdate) {
            List<Contact> contacts = [Select Id, SitecoreUsername__c, SitecorePassword__c from Contact where AccountId = :updatedAccount.Id ];
            System.assertEquals(10, contacts.size());
            
            for(Contact updatedContact : contacts) {
                System.debug('UpdateAccountSitecoreRoleOnBulkTrigger Account Name ' + updatedAccount.Name + ' ID:' + updatedAccount.Id + ' Contact.Id: ' + updatedContact.Id + ' SitecoreUsername__c:' + updatedContact.SitecoreUsername__c + ' SitecorePassword__c:' + updatedContact.SitecorePassword__c );
                
                System.assert(updatedContact.SitecoreUsername__c != null, 'SitecoreUsername__c expected to be set for Account:' + updatedAccount.Id + ' Contact.Id: ' + updatedContact.Id);
                System.assert(updatedContact.SitecorePassword__c != null);
            }
        }
        
        System.debug('UpdateAccountSitecoreRoleOnBulkTrigger End');
    }
    
    /**
     * This will test the Account Sitecore Role trigger that will loop through all the 
     * Contacts belonging to the Account and set a Sitecore UserName and password back to blank
     */
    static testMethod void UpdateAccountSitecoreRoleOffTrigger() {
                
        System.debug('UpdateAccountSitecoreRoleOffTrigger Start');
        
        // Create 5 test Accounts where the SitecoreRole is enabled. 2 test contacts per account.  
        List<Account> createdAccounts = createTestAccounts(5, 2, true);
        System.assertEquals(5, createdAccounts.size(), 'Failed to create 5 test Accounts');
        
        List<Account> accounts = [Select a.Name, a.Id, a.SitecoreRole__c, (Select Id from Contacts) 
                                  from Account a 
                                  where a.SitecoreRole__c = true 
                                  limit 20];
                                  
        System.assertNotEquals(0, accounts.size(), 'Failed to find existing Accounts with SitecoreRole__c = true');
                                
        Integer i = 0;                                
        for(Account a : accounts) {
            System.debug('UpdateAccountSitecoreRoleOffTrigger Loop Account Name ' + a.Name);
            
            if(a.Contacts != null) {
                System.debug('UpdateAccountSitecoreRoleOffTrigger on Account Name ' + a.Name);
                
                a.SitecoreRole__c = false;
                Database.SaveResult SR = database.update(a);
                System.assert(SR.isSuccess());
                
                i++;
                if(i > 10) break;
            }
        }
        System.assert(i > 0, 'Failed to set SitecoreRole__c = false on target Accounts');
        
        System.debug('UpdateAccountSitecoreRoleOffTrigger End : Integer i = ' + i);
    }
    
    /**
     * This will test the Account Sitecore Role trigger that will loop through all the 
     * Contacts belonging to the Account and set a Sitecore UserName and password when SitecoreRole__c is set to true 
     */
    static testMethod void UpdateAccountSitecoreRoleOffBulkTrigger() {
        
        
        System.debug('UpdateAccountSitecoreRoleOffBulkTrigger Start');

        // Create 5 test accounts where the SitecoreRole is not enabled. 10 test contacts per account.  
        List<Account> accounts = createTestAccounts(5, 10, true);
        System.assertEquals(5, accounts.size());
        
        List<Account> accountsToUpdate = new List<Account>();
        
        for(Account a : accounts) {
            System.debug('UpdateAccountSitecoreRoleOffBulkTrigger on Account Name ' + a.Name + ' ID:' + a.Id );
            
            Account accountToUpdate = new Account(Id=a.Id);
            accountToUpdate.SitecoreRole__c = false;
                    
            accountsToUpdate.add(accountToUpdate);      

        }
        System.assertEquals(accounts.size(), accountsToUpdate.size());
        
        List<Database.SaveResult> saveResults = database.update(accountsToUpdate);
        for(Database.SaveResult saveResult : saveResults) {
            System.assert(saveResult.isSuccess());
        }
        
        // Check that all the contacts under the account have been disabled
        for(Account updatedAccount : accountsToUpdate) {
            List<Contact> contacts = [Select Id, SitecoreUsername__c, SitecorePassword__c from Contact where AccountId = :updatedAccount.Id ];
            System.assertEquals(10, contacts.size());
            
            for(Contact updatedContact : contacts) {
                System.debug('UpdateAccountSitecoreRoleOffBulkTrigger Account Name ' + updatedAccount.Name + ' ID:' + updatedAccount.Id + ' Contacts: ' + updatedContact.Id + ' ' + updatedContact.SitecoreUsername__c );
                
                System.assert(updatedContact.SitecoreUsername__c == null, 'SitecoreUsername__c expected to be set for Account:' + updatedAccount.Id + ' Contact: ' + updatedContact.Id);
                System.assert(updatedContact.SitecorePassword__c == null);
            }
        }
        
        System.debug('UpdateAccountSitecoreRoleOffBulkTrigger End');
    }
    
    /**
     * This will test the insert of a new Account and check that the 
     * AccountSitecoreRoleOffTrigger works
     */
    static testMethod void InsertAccountSitecoreRoleOnTrigger() {
        
        System.debug('InsertAccountSitecoreRoleOnTrigger Start');

        // adding an account with false set on Sitecore
                Account A1 = new Account (
                    Name = 'Disney 1',
                    SitecoreRole__c = false,
                    BillingStreet = '123 Water',
                    BillingCity = 'Excelsior',
                    BillingState = 'MN',
                    BillingPostalCode = '12345',
                    BillingCountry = 'US');
                insert A1;  
        
        // inserting new contact on that account
                Contact C1 = new Contact(
                    AccountID = A1.Id,
                    FirstName = 'Donald',
                    LastName = 'Duck',
                    MailingStreet = '123 Water',
                    MailingCity = 'Excelsior',
                    MailingState = 'MN',
                    MailingPostalCode = '12345',
                    MailingCountry = 'US');      
                insert C1;
                
        // set the account sitecore value to true;
                    A1.SitecoreRole__c = true;
                    update A1;
        // Apr 18 2011 - end add
        System.debug('InsertAccountSitecoreRoleOnTrigger End');
    }
    
    
    /**
     * This will test the insert of a new Account and check that the 
     * AccountSitecoreRoleOffTrigger works
     */
    static testMethod void InsertAccountSitecoreRoleOffTrigger() {
        
        System.debug('InsertAccountSitecoreRoleOffTrigger Start');
        
        Account account = new Account();
        account.Name = 'Test Account';
        account.BillingStreet = 'street';
        account.BillingCity = 'city';
        account.BillingState = 'state';
        account.BillingCountry = 'New Zealand';
        account.Phone = '000000';
        Database.SaveResult SR = database.insert(account);
        System.assert(SR.isSuccess());
        
        System.debug('InsertAccountSitecoreRoleOffTrigger End');
    }

    /**
     * This will test the Contact Sitecore Password trigger that will encrypt the updated password if it 
     * is different from the existing one.
     */
    static testMethod void UpdateUserContactSitecorePasswordTrigger() {
        
        System.debug('UpdateUserContactSitecorePasswordTrigger Start');
        
        List<Contact> contacts = [Select c.Name, c.Id, c.SitecoreUsername__c, c.SitecorePassword__c from Contact c limit 20];
        for(Contact c : contacts) {
            System.debug('UpdateUserContactSitecorePasswordTrigger Loop on ContactID ' + c.Id);
            
            if(c.Name != null && c.Name != '') {
                c.SitecorePassword__c = 'FooBar';
                c.SitecoreUsername__c = c.Name.replaceAll('\\W', '');
                Database.SaveResult SR = database.update(c);
                System.assert(SR.isSuccess());
                break;
            }
            
        }
        
        System.debug('UpdateUserContactSitecorePasswordTrigger End');
    }

    /**
     * This will test the Contact Sitecore password trigger that will encrypt the new Contacts password 
     * on insert.
     */
    static testMethod void NewUserContactSitecorePasswordTrigger() {
        
        System.debug('NewUserContactSitecorePasswordTrigger Start');
        
        Contact c = new Contact();
        c.FirstName = 'FTest';
        c.LastName = 'LTest';
        c.SitecorePassword__c = 'FooBar';
        c.SitecoreUsername__c = 'FTestLTest';
        c.MailingCountry = 'New Zealand';
        Database.SaveResult SR = database.insert(c);
        System.assert(SR.isSuccess());
        
        //Check for the expected encryption
        
        Contact insertedContact = [Select Id, SitecorePassword__c, SitecorePasswordEncrypted__c From Contact where Id = :c.Id];
        System.assert(insertedContact.SitecorePasswordEncrypted__c, 'The Contacts Sitecore password should be flagged as encrypted after insertion');
                
        // Password has been encrypted
        System.assertNotEquals(c.SitecoreUsername__c, insertedContact.SitecorePassword__c, 'The Contacts Sitecore password should have changed after insertion');
        // Encrypted as expected
        System.assertEquals('64/EH52a5YVcTYATVQdeTM+yKAg=', insertedContact.SitecorePassword__c, 'Expected Sitecore password encryption');
        
        System.debug('NewUserContactSitecorePasswordTrigger End');
    }
    
    /**
     * Check the bulkification of the contactSitecorePasswordTrigger
     * When updating multiple Contacts where the Sitecore password has not changed don't encrypt the password again.
     */
    static testMethod void UpdateMultipleContacts() {
        
        System.debug('UpdateMultipleContacts Start');
        
        Account a = testAccount('1', true);
        /*new Account (
                    Name = 'Disney 1',
                    SitecoreRole__c = true,
                    BillingStreet = '123 Water',
                    BillingCity = 'Excelsior',
                    BillingState = 'MN',
                    BillingPostalCode = '12345',
                    BillingCountry = 'US');*/
        insert a;  
        
        List<Contact> contacts = new List<Contact>();
        
        Contact c1 = new Contact(
                    AccountID = a.Id,
                    FirstName = 'Donald',
                    LastName = 'Duck',
                    MailingStreet = '123 Water',
                    MailingCity = 'Excelsior',
                    MailingState = 'MN',
                    MailingPostalCode = '12345',
                    MailingCountry = 'US',
                    Phone = '1',
                    SitecoreUsername__c = 'DonaldDuck',
                    SitecorePassword__c = 'RubberDuck'); 
                    
        contacts.add(c1);     
                
        Contact c2 = new Contact(
                    AccountID = a.Id,
                    FirstName = 'Daisy',
                    LastName = 'Duck',
                    MailingStreet = '123 Water',
                    MailingCity = 'Excelsior',
                    MailingState = 'MN',
                    MailingPostalCode = '12345',
                    MailingCountry = 'US',
                    Phone = '2',
                    SitecoreUsername__c = 'DaisyDuck',
                    SitecorePassword__c = 'DuckRubber');
                    
        contacts.add(c2);
        
        System.assertNotEquals(c1.SitecorePassword__c, c2.SitecorePassword__c, 'Passwords for each Contact should differ');
        
        insert(contacts);
        
        // Get the current encrypted passwords
        string c1PasswordEncrypted = [select SitecorePassword__c from Contact where id = :c1.Id ].SitecorePassword__c;
        string c2PasswordEncrypted = [select SitecorePassword__c from Contact where id = :c2.Id ].SitecorePassword__c; 
        
        // Password have been encrypted
        System.assertNotEquals(c1.SitecorePassword__c, c1PasswordEncrypted);
        System.assertNotEquals(c2.SitecorePassword__c, c2PasswordEncrypted);
        // Encryption differs per password
        System.assertNotEquals(c1PasswordEncrypted, c2PasswordEncrypted);
        
        List<Contact> toUpdate = new List<Contact>();
        // Update just the phone numbers, the Sitecode passwords should not be affected
        Contact toUpdate1 = new Contact(Id = c1.Id);
        toUpdate1.Phone = '10';
        toUpdate.Add(toUpdate1);
        
        Contact toUpdate2 = new Contact(Id = c2.Id);
        toUpdate2.Phone = '20';
        toUpdate.Add(toUpdate2);
        
        update(toUpdate);
        
        Contact c1After = [select ID, Phone, SitecorePassword__c from Contact where Id = :c1.Id];
        Contact c2After = [select ID, Phone, SitecorePassword__c from Contact where Id = :c2.Id];
        
        System.assertEquals('10', c1After.Phone);
        System.assertEquals('20', c2After.Phone);
        
        System.debug('c1PasswordEncrypted: ' + c1PasswordEncrypted);
        System.debug('c1PasswordEncrypted(After): ' + c1After.SitecorePassword__c);
        
        System.debug('c2PasswordEncrypted: ' + c2PasswordEncrypted);
        System.debug('c2PasswordEncrypted(After): ' + c2After.SitecorePassword__c);
        
        // Ensure that the password encryption hasn't changed as a result of updating just the phone number.
        System.assertEquals(c1PasswordEncrypted, c1After.SitecorePassword__c);
        System.assertEquals(c2PasswordEncrypted, c2After.SitecorePassword__c);
        
        System.debug('UpdateMultipleContacts End');
    }
    
    /**
     * Verify the creation of two Contacts under one Account with the same first and last names. Email addresses will be unique
     */
    static testMethod void TwoContactsWithMatchingFirstAndLastNames() {
        
        System.debug('TwoContactsWithMatchingFirstAndLastNames Start');
        
        SetDefaultSitecoreUsernameField('Name');
        
        // New Account with initially disabled Sitecore Role
        Account a = testAccount('1', false);
        insert a;  
        
        List<Contact> contacts = new List<Contact>();
        
        Contact c1 = new Contact(
                    AccountID = a.Id,
                    FirstName = 'Donald',
                    LastName = 'Duck',
                    MailingStreet = '123 Water',
                    MailingCity = 'Excelsior',
                    MailingState = 'MN',
                    MailingPostalCode = '12345',
                    MailingCountry = 'US',
                    Phone = '1',
                    Email = 'donaldDuck1@example.com'); 
                    
        contacts.add(c1);     
                
        Contact c2 = new Contact(
                    AccountID = a.Id,
                    FirstName = c1.FirstName,
                    LastName = c1.LastName,
                    MailingStreet = '123 Water',
                    MailingCity = 'Excelsior',
                    MailingState = 'MN',
                    MailingPostalCode = '12345',
                    MailingCountry = 'US',
                    Phone = '2',
                    Email = 'donaldDuck2@example.com');
                    
        contacts.add(c2);
        
        System.assertEquals(c1.FirstName, c2.FirstName, 'Contact First names should be equal');
        System.assertEquals(c1.LastName, c2.LastName, 'Contact Last names should be equal');
        
        insert(contacts);
        
        // Get the current user names
        string c1SitecoreUsername = [select SitecoreUsername__c from Contact where id = :c1.Id ].SitecoreUsername__c;
        string c2SitecoreUsername = [select SitecoreUsername__c from Contact where id = :c2.Id ].SitecoreUsername__c; 
        
        // Sitecore usernames have not been set
        //System.assertEquals('donaldduck1@example.com', c1SitecoreUsername);
        //System.assertEquals('donaldduck2@example.com', c2SitecoreUsername);
                
        a.SitecoreRole__c = true;
        
        Database.update(a);
                       
        Contact c1After = [select ID, SitecoreUsername__c, SitecorePassword__c from Contact where Id = :c1.Id];
        Contact c2After = [select ID, SitecoreUsername__c, SitecorePassword__c from Contact where Id = :c2.Id];
        
     //   System.assertEquals('donaldduck1@example.com', c1After.SitecoreUsername__c);
     //   System.assertEquals('donaldduck2@example.com', c2After.SitecoreUsername__c);
                              
        System.debug('TwoContactsWithMatchingFirstAndLastNames End');
    }
    
    /**
     * Verify the creation of two Contacts under one Account with the same first and last names. Email addresses will be unique
     */
    static testMethod void TwoContactsWithMatchingFirstAndLastNamesUseEmail() {
        
        SetDefaultSitecoreUsernameField('Email');
        
        System.debug('TwoContactsWithMatchingFirstAndLastNames Start');
               
        // New Account with initially disabled Sitecore Role
        Account a = testAccount('1', false);
        insert a;  
        
        List<Contact> contacts = new List<Contact>();
        
        Contact c1 = testContact(a.Id, a.Name, 1); 
        c1.FirstName = 'Donald';
        c1.LastName = 'Duck';
        c1.Email = 'donaldDuck1@example.com'; 
                    
        contacts.add(c1);     
                
        Contact c2 = testContact(a.Id, a.Name, 2); 
        c2.FirstName = c1.FirstName;
        c2.LastName = c1.LastName;
        c2.Email = 'donaldDuck2@example.com'; 
                    
        contacts.add(c2);
        
        System.assertEquals(c1.FirstName, c2.FirstName, 'Contact First names should be equal');
        System.assertEquals(c1.LastName, c2.LastName, 'Contact Last names should be equal');
        
        insert(contacts);
        
        // Get the current user names
        string c1SitecoreUsername = [select SitecoreUsername__c from Contact where id = :c1.Id ].SitecoreUsername__c;
        string c2SitecoreUsername = [select SitecoreUsername__c from Contact where id = :c2.Id ].SitecoreUsername__c; 
        
        // Sitecore usernames have not been set
      //  System.assertEquals('donaldduck1@example.com', c1SitecoreUsername);
    //    System.assertEquals('donaldduck2@example.com', c2SitecoreUsername);
                
        a.SitecoreRole__c = true;
        
        Database.update(a);
                       
        Contact c1After = [select ID, SitecoreUsername__c, SitecorePassword__c from Contact where Id = :c1.Id];
        Contact c2After = [select ID, SitecoreUsername__c, SitecorePassword__c from Contact where Id = :c2.Id];
        
        System.assertEquals(c1.Email.toLowerCase(), c1After.SitecoreUsername__c);
        System.assertEquals(c2.Email.toLowerCase(), c2After.SitecoreUsername__c);
                              
        System.debug('TwoContactsWithMatchingFirstAndLastNames End');
    }
    
    
    
    /**
     * Create a number of Accounts with a number of Contacts per Account. Either enable or disable the role.
     */
    private static List<Account> createTestAccounts(Integer accountQuantity, Integer contactsPerAccount, Boolean enableSitecoreRole) {
        List<Account> accounts = new List<Account>();
        
        for(Integer i = 0; i < accountQuantity; i++) {
            Account newAccount = testAccount('-' + i, enableSitecoreRole);
            insert(newAccount);
            
            accounts.add(newAccount);
            
            List<Contact> contacts = testContacts(newAccount.Id, contactsPerAccount, newAccount.Name);
            System.assertEquals(contactsPerAccount, contacts.size());
            
            insert(contacts);
        }
        System.assertEquals(accountQuantity, accounts.size());
        
        return accounts;
    }
    
    /**
     * Creates a new Test Account that can be inserted for testing
     */
    private static Account testAccount(String suffix, Boolean enableSitecoreRole) {
        Account a = new Account (
                    Name = 'Disney ' + suffix,
                    SitecoreRole__c = enableSitecoreRole,
                    BillingStreet = '123 Water',
                    BillingCity = 'Excelsior',
                    BillingState = 'MN',
                    BillingPostalCode = '12345',
                    BillingCountry = 'US');
        
        return a;
    }
    
    /**
     * Creates a collection of new Contacts for an Account
     */
    private static List<Contact> testContacts(Id accountId, Integer quantity, string uniqueAccount) {
        List<Contact> contacts = new List<Contact>();
        
        for(Integer i = 0; i<quantity; i++) {
            Contact contact = testContact(accountId, uniqueAccount, i);
                    
            contacts.add(contact);
        }
                    
        return contacts;
    }
    
    /**
     * Creates a new Contact for an Account
     */
    private static Contact testContact(Id accountId, string uniqueAccount, Integer i) {
		Contact contact = new Contact(
                    AccountID = accountId,
                    FirstName = 'Donald_' + uniqueAccount, //Names in Contact must be unique between accounts unless another field is configured
                    LastName = 'Duck ' + i,
                    MailingStreet = '123 Water',
                    MailingCity = 'Excelsior',
                    MailingState = 'MN',
                    MailingPostalCode = '12345',
                    MailingCountry = 'US');
                    //Email = 'DonaldDuck' + i + '@example.com');
               //        System.debug('TESTCONTACT:' + i + ' - ' + contact.email);
		return contact;
    }
    
    private static void SetDefaultSitecoreUsernameField(string value) {
		User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
		System.runAs ( thisUser ) {
			S4SSettings__c[] configEntries = [Select Id, TextValue__c From S4SSettings__c Where Name = 'DefaultSitecoreUsernameField' limit 1];
	        if(configEntries.size() > 0) {
	        	S4SSettings__c configEntry = configEntries[0]; 
	        	configEntry.TextValue__c = value;  
				update configEntry;
	        } else {
	        	S4SSettings__c configEntry = new S4SSettings__c();
	        	configEntry.Name = 'DefaultSitecoreUsernameField';
	        	configEntry.TextValue__c = value;  
				insert configEntry;
	        }    
		}    	
    }
}