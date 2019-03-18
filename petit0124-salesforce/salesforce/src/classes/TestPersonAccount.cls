// Note - this sample code uses variable Level2__c instead of Level__c to avoid
// conflict when installing an unmanaged package
@isTest (seealldata=false)
private class TestPersonAccount {

    static testMethod void TestWithContacts() {
        List<Contact> contacts = TestDiagnostics2.CreateContacts('patst', 3);
        contacts[0].LeadSource='Web';
        contacts[1].LeadSource='Phone Inquiry';
        contacts[2].LeadSource='Other';
        Test.StartTest();
        insert contacts;
        Test.StopTest();
        // Seealldata is false, so we'll get the same 3 contacts
        Map<ID, Contact> contactmap = new Map<ID, Contact>([Select ID, Level2__c from Contact Limit 3]);
       	system.assertEquals(contactmap.get(contacts[0].id).Level2__c,'Primary');
       	system.assertEquals(contactmap.get(contacts[1].id).Level2__c,'Primary');
       	system.assertEquals(contactmap.get(contacts[2].id).Level2__c,'Secondary');
    }
    
    static testMethod void TestWithAccounts() {
        List<Contact> contacts = TestDiagnostics2.CreateContacts('patst', 3);
        List<Account> accounts = TestDiagnostics2.CreateAccounts('patest', 3);
        contacts[0].LeadSource='Web';
        contacts[1].LeadSource='Phone Inquiry';
        contacts[2].LeadSource='Other';
        PersonAccountSupport.FakePersonContactIDs = new List<ID>();
        PersonAccountSupport.FakePersonAccountDuringTest = true;
        insert contacts;
        for(Contact ct: contacts) PersonAccountSupport.FakePersonContactIDs.add(ct.id);
        Test.StartTest();
        insert accounts;
        Test.StopTest();
        // Seealldata is false, so we'll get the same 3 contacts
        Map<ID, Contact> contactmap = new Map<ID, Contact>([Select ID, Level2__c from Contact Limit 3]);
       	system.assertEquals(contactmap.get(contacts[0].id).Level2__c,'Primary');
       	system.assertEquals(contactmap.get(contacts[1].id).Level2__c,'Primary');
       	system.assertEquals(contactmap.get(contacts[2].id).Level2__c,'Secondary');
    }    
    
}