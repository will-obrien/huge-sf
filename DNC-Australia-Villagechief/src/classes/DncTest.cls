@IsTest
public class DncTest{
    private static Dnc.Credentials getCredentials(){
        Dnc.Credentials creds = new Dnc.Credentials();
        creds.telemarketerId = '1';
        creds.washOnlyUserId = '2';
        creds.telemarketerPassword = 'asdf';
        return creds;
    }
    
    private static testmethod void testErrorDescription(){
        for ( integer i=0;i<6;i++ ){
            system.assert(DNC.getErrorDescription(i) != null);
        }
    }
    
    
    @isTest 
    static void testCheckCountryPrefix() {
        system.assertEquals ( '+310255505555', Dnc.checkCountryPrefix('+31 02 5550 5555')); //not austarlia
        system.assertEquals ( '6102555055555', Dnc.checkCountryPrefix('61 02 5550 55555')); //not valid length
        system.assertEquals ( '612555055555', Dnc.checkCountryPrefix('61 2 5550 55555')); //not valid length
        
        system.assertEquals ( '0255505555', Dnc.checkCountryPrefix('+61 02 5550 5555')); //should convert
        system.assertEquals ( '0255505555', Dnc.checkCountryPrefix('+61 2 5550 5555')); //should convert
        
        system.assertEquals ( '0255505555', Dnc.checkCountryPrefix('61 02 5550 5555')); //should convert
        system.assertEquals ( '0255505555', Dnc.checkCountryPrefix('61 2 5550 5555')); //should convert
    }
    
    @isTest 
    static void testNumbers() {
        system.assertEquals ( '', Dnc.isValidNumber('02 5550 5555'));
        //'+' is an invalid character
        //phone number contains 11 digits
        //phone number begins with 1 (last 10 digits are counted)
        system.assertEquals ( '\'+\' is an invalid character', Dnc.isValidNumber('+61 2 5550 5555'));
        
        system.assertEquals ( '', Dnc.isValidNumber('02-7010 5555'));
        system.assertEquals ( 'phone number contains 8 digits', Dnc.isValidNumber('7010 5555'));    //Phone number is only 8 digits long.
        
        system.assertEquals ( '', Dnc.isValidNumber('(04) 91 570 156'));
        system.assertEquals ( 'Phone number begins with 1', Dnc.isValidNumber('1800 160 461')); //Phone number begins with 1.
        
        system.assertEquals ( '', Dnc.isValidNumber('(05) 5550 5556'));
        system.assertEquals ( '\'A\' is an invalid character', Dnc.isValidNumber('0A 5550 5555'));  //Phone number contains a non-digit character 'A'.
        
        system.assertEquals ( '', Dnc.isValidNumber('08-9990-9999'));
        system.assertEquals ( '\',\' is an invalid character', Dnc.isValidNumber('08,9990,9999'));  //Phone number contains commas.
        
        system.assertEquals ( '', Dnc.isValidNumber('0777777777'));
        system.assertEquals ( '\',\' is an invalid character', Dnc.isValidNumber('0777777777,'));   //The line ends with a comma.
    }
    
    @isTest 
    static void testGetAccountBalance() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new DncMockHttpResponseGenerator());
        DncMockHttpResponseGenerator.testName = 'getAccountBalance';
        
        system.assertEquals(123, Dnc.getAccountBalance(getCredentials()));
    }
    
    
    
    @isTest 
    static void testWashNumbers() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new DncMockHttpResponseGenerator());
        DncMockHttpResponseGenerator.testName = 'washNumbers';
        DncMockHttpResponseGenerator.washNumbersResults.put('0733003300', true);
        DncMockHttpResponseGenerator.washNumbersResults.put('1234', false);
        
        Dnc.WashNumbersResult res = Dnc.washNumbers(getCredentials(), new String[]{ '0733003300', '1234' }, 'mycode1');
        system.assertEquals(0, res.errorCode);
        system.assertEquals(500, res.accountBalance);
        system.assertEquals(2, res.results.size());
    }
    
    
    
    @isTest 
    static void testWashNumbersError() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new DncMockHttpResponseGenerator());
        DncMockHttpResponseGenerator.testName = 'washNumbersError';
        
        Dnc.WashNumbersResult res = Dnc.washNumbers(getCredentials(), new String[]{ '0733003300', '1234' }, 'mycode1');
        system.assertEquals(1, res.errorCode);
    }
    
    
    
    @isTest 
    static void testLeadWashing() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new DncMockHttpResponseGenerator());
        DncMockHttpResponseGenerator.testName = 'washNumbers';
        DncMockHttpResponseGenerator.washNumbersResults.put('0733440001', true);
        DncMockHttpResponseGenerator.washNumbersResults.put('0733440002', false);
        
        Config__c settings = new Config__c();
        settings.name = 'Default';
        settings.telemarketerId__c = '1';
        settings.washOnlyUserId__c = '2';
        settings.telemarketerPassword__c = 'asdf';
        insert settings;
            
        List<Lead> leads = new List<Lead>();
        leads.add(new Lead(Phone='0733440001', LastName='test1', Company='company'));
        leads.add(new Lead(Phone='invalid', LastName='test2', Company='company'));
        leads.add(new Lead(Phone='0733440001', LastName='testY', Company='company'));
        leads.add(new Lead(Phone='0733440002', LastName='testN', Company='company'));
        insert leads;
        
        Test.startTest();
            DNC.MetadataLookup mdl = DNC.getMetadataLookup('Lead', new String[]{'Phone'});
        
            Dnc.recalculate(leads, mdl, mdl.fieldList, false, null);
            update leads;
        Test.stopTest();
        leads = [ select LastName, Phone_DNC_Status__c, Phone_DNC_Checked__c From Lead Where Id in :leads ];
        for ( Lead lead : leads ){
            system.assert(lead.Phone_DNC_Checked__c != null);
            
            if ( lead.LastName == 'test1' ){
                system.assertEquals('Do not call', lead.Phone_DNC_Status__c);
                
            }else if ( lead.LastName == 'test2' ){
                system.assertEquals('Invalid Number', lead.Phone_DNC_Status__c);
            
            }else if ( lead.LastName == 'testY' ){
                system.assertEquals('Do not call', lead.Phone_DNC_Status__c);
            
            }else if ( lead.LastName == 'testN' ){
                system.assertEquals('Can call', lead.Phone_DNC_Status__c);
            
            }else{
                system.assert(false, lead + ' unexpected');
            }
        }
    }
    
    
    
    @isTest 
    static void testContactWashing() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new DncMockHttpResponseGenerator());
        DncMockHttpResponseGenerator.testName = 'washNumbers';
        DncMockHttpResponseGenerator.washNumbersResults.put('0733440001', true);
        DncMockHttpResponseGenerator.washNumbersResults.put('0733440002', false);
        DncMockHttpResponseGenerator.washNumbersResults.put('0434000001', true);
        DncMockHttpResponseGenerator.washNumbersResults.put('0434000002', false);
        
        Config__c settings = new Config__c();
        settings.name = 'Default';
        settings.telemarketerId__c = '1';
        settings.washOnlyUserId__c = '2';
        settings.telemarketerPassword__c = 'asdf';
        insert settings;
            
        List<Contact> contacts = new List<Contact>();
        contacts.add(new Contact(Phone='0733440001', MobilePhone='0434000001', LastName='test1'));
        contacts.add(new Contact(Phone='invalid', MobilePhone='0434000001', LastName='test2'));
        contacts.add(new Contact(Phone='0733440001', MobilePhone='0434000002', LastName='testY'));
        contacts.add(new Contact(Phone='0733440002', MobilePhone='invalid', HomePhone='invalid', LastName='testN'));
        insert contacts;
        
        Test.startTest();
            DNC.MetadataLookup mdl = DNC.getMetadataLookup('Contact', new String[]{'Phone', 'MobilePhone', 'HomePhone'});
        
            Dnc.recalculate(contacts, mdl, mdl.fieldList, false, Date.today() - 30);
            update contacts;
        Test.stopTest();
        contacts = [ select LastName, 
        Phone_DNC_Status__c, Phone_DNC_Checked__c, 
        MobilePhone_DNC_Status__c, MobilePhone_DNC_Checked__c, 
        HomePhone_DNC_Status__c, HomePhone_DNC_Checked__c
        From Contact Where Id in :contacts ];
        for ( Contact contact : contacts ){
            system.assert(contact.Phone_DNC_Checked__c != null);
            system.assert(contact.MobilePhone_DNC_Checked__c != null);
            
            if ( contact.LastName == 'test1' ){
                system.assertEquals('Do not call', contact.Phone_DNC_Status__c);
                system.assertEquals('Do not call', contact.MobilePhone_DNC_Status__c);
                
            }else if ( contact.LastName == 'test2' ){
                system.assertEquals('Invalid Number', contact.Phone_DNC_Status__c);
                system.assertEquals('Do not call', contact.MobilePhone_DNC_Status__c);
            
            }else if ( contact.LastName == 'testY' ){
                system.assertEquals('Do not call', contact.Phone_DNC_Status__c);
                system.assertEquals('Can call', contact.MobilePhone_DNC_Status__c);
            
            }else if ( contact.LastName == 'testN' ){
                system.assertEquals('Can call', contact.Phone_DNC_Status__c);
                system.assertEquals('Invalid Number', contact.MobilePhone_DNC_Status__c);
                system.assert(contact.HomePhone_DNC_Checked__c != null);
                system.assertEquals('Invalid Number', contact.HomePhone_DNC_Status__c);
            
            }else{
                system.assert(false, contact + ' unexpected');
            }
        }
    }
    
    private static testmethod void testSchedule(){
        DncSchedule s = new DncSchedule('Lead', 'Phone', null, null);
        system.assert(s!=null);
    }
    
    
    private static testmethod void testBatchable(){
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new DncMockHttpResponseGenerator());
        DncMockHttpResponseGenerator.testName = 'washNumbers';
        DncMockHttpResponseGenerator.washNumbersResults.put('0733440001', true);
        DncMockHttpResponseGenerator.washNumbersResults.put('0733440002', false);
        DncMockHttpResponseGenerator.washNumbersResults.put('0434000001', true);
        DncMockHttpResponseGenerator.washNumbersResults.put('0434000002', false);
        
        Config__c settings = new Config__c();
        settings.name = 'Default';
        settings.telemarketerId__c = '1';
        settings.washOnlyUserId__c = '2';
        settings.telemarketerPassword__c = 'asdf';
        insert settings;
            
        List<Lead> leads = new List<Lead>();
        leads.add(new Lead(Phone='0733440001', MobilePhone='0434000001', LastName='test1', Company='company'));
        leads.add(new Lead(Phone='invalid', MobilePhone='0434000001', LastName='test2', Company='company'));
        leads.add(new Lead(Phone='0733440001', MobilePhone='invalid', LastName='testY', Company='company'));
        leads.add(new Lead(Phone='0733440002', MobilePhone='0434000002', LastName='testN', Company='company'));
        insert leads;
        
        Test.startTest();
            DncBatchable b = new DncBatchable('Lead', new String[]{'Phone', 'MobilePhone'}, null, null);
            b.start(null);
            b.execute(null, leads);
            b.finish(null);
        Test.stopTest();
        leads = [ select LastName, 
            Phone, Phone_DNC_Status__c, Phone_DNC_Checked__c ,
            MobilePhone, MobilePhone_DNC_Status__c, MobilePhone_DNC_Checked__c
            From Lead Where Id in :leads ];
        for ( Lead lead : leads ){
            system.assert(lead.Phone_DNC_Checked__c != null);
            system.assert(lead.MobilePhone_DNC_Checked__c != null);
            
            if ( lead.LastName == 'test1' ){
                system.assertEquals('Do not call', lead.Phone_DNC_Status__c);
                system.assertEquals('Do not call', lead.MobilePhone_DNC_Status__c);
                
            }else if ( lead.LastName == 'test2' ){
                system.assertEquals('Invalid Number', lead.Phone_DNC_Status__c);
                system.assertEquals('Do not call', lead.MobilePhone_DNC_Status__c);
            
            }else if ( lead.LastName == 'testY' ){
                system.assertEquals('Do not call', lead.Phone_DNC_Status__c);
                system.assertEquals('Invalid Number', lead.MobilePhone_DNC_Status__c);
            
            }else if ( lead.LastName == 'testN' ){
                system.assertEquals('Can call', lead.Phone_DNC_Status__c);
                system.assertEquals('Can call', lead.MobilePhone_DNC_Status__c, lead.MobilePhone);
            
            }else{
                system.assert(false, lead + ' unexpected');
            }
        }
    }
    
    
    
    @isTest 
    static void testWashingErrors() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new DncMockHttpResponseGenerator());
        DncMockHttpResponseGenerator.testName = 'washNumbersError';
        DncMockHttpResponseGenerator.washNumbersResults.put('0733440001', true);
        DncMockHttpResponseGenerator.washNumbersResults.put('0733440002', false);
        
        
        Config__c settings = new Config__c();
        settings.name = 'Default';
        settings.telemarketerId__c = '1';
        settings.washOnlyUserId__c = '2';
        settings.telemarketerPassword__c = 'asdf';
        insert settings;
            
        List<Lead> leads = new List<Lead>();
        leads.add(new Lead(Phone='0733440001', LastName='test1', Company='company'));
        leads.add(new Lead(Phone='invalid', LastName='test2', Company='company'));
        leads.add(new Lead(Phone='0733440001', LastName='testY', Company='company'));
        leads.add(new Lead(Phone='0733440002', LastName='testN', Company='company'));
        insert leads;
        
        Test.startTest();
            DNC.MetadataLookup mdl = DNC.getMetadataLookup('Lead', new String[]{'Phone'});
            Dnc.recalculate(leads, mdl, mdl.fieldList, false, Date.today() - 30);
            update leads;
        Test.stopTest();
        leads = [ select LastName, Phone_DNC_Status__c, Phone_DNC_Checked__c From Lead Where Id in :leads ];
        for ( Lead lead : leads ){
            if ( lead.LastName == 'test2' ){
                system.assertEquals('Invalid Number', lead.Phone_DNC_Status__c);
            }else{
                system.assertEquals('Retryable Error', lead.Phone_DNC_Status__c);
            }
        }
    }
    
    @isTest 
    static void testContact() {
        Contact c = new Contact(LastName='ln', Phone='12345', Phone_DNC_Status__c='Can call');
        insert c;
        c.Phone = '123456';
        update c;
        c = [ select Phone_DNC_Status__c From Contact Where Id=:c.id ];
        system.assertEquals(null, c.Phone_DNC_Status__c);
    }
}