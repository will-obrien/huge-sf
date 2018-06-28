@isTest
private class PreferencesToAddUpTest {
    static Id accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
    static Id contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
    static Id preferenceNationalTypeId = Schema.Sobjecttype.rC_Bios__Preference__c.getRecordTypeInfosByName().get('Club-wide').getRecordTypeId();
    static Account account1;
	static Contact contact1;
	static rC_Bios__Preference__c preference1;

    static testMethod void testInsert() {
		setup();        
        Test.setMock(HttpCalloutMock.class, new PreferencesToAddUpMockResponseGenerator('Good Response'));
        Test.startTest();
        insert preference1;
        Test.stopTest();
    }
    static testMethod void testUpdate() {
		setup();
		PreferencesToAddUp.sendToAddUp = false;
		insert preference1;
        PreferencesToAddUp.sendToAddUp = true;
        Test.setMock(HttpCalloutMock.class, new PreferencesToAddUpMockResponseGenerator('Good Response'));
        Test.startTest();
        preference1.rC_Bios__Subcategory__c = 'No AddUp Email';
        update preference1;
        Test.stopTest();
    }
    static testMethod void testBadResponse() {
		setup();        
        Test.setMock(HttpCalloutMock.class, new PreferencesToAddUpMockResponseGenerator('Invalid User'));
        Test.startTest();
        insert preference1;
        Test.stopTest();
    }
    static testMethod void testUnauthorized() {
		setup();        
        Test.setMock(HttpCalloutMock.class, new PreferencesToAddUpMockResponseGenerator('Unauthorized'));
        Test.startTest();
        insert preference1;
        Test.stopTest();
    }
    private static void setup() {
    	BSD_Auth_Token__c authToken = new BSD_Auth_Token__c();
		authToken.Name = 'AuthToken';
		authToken.Endpoint__c = 'xxxx';
		authToken.Token__c = 'yyyy';
		authToken.Email__c = 'abc@xyz.com';
		authToken.Password__c = 'testpass';
		authToken.Expires__c = System.now().addSeconds(-120);
		insert authToken;

        account1 = new Account(
            Name='Account1',
            RecordTypeId = accountHouseholdTypeId
        );
        insert account1;
        
        contact1 = new Contact(
            AccountId = account1.Id,
            FirstName = 'Test',
            LastName = 'Contact1',
            RecordTypeId = contactHouseholdTypeId,
            Website_System_Id__c = '123'
        );  
        insert contact1;

        preference1 = new rC_Bios__Preference__c (
            rC_Bios__Contact__c = contact1.Id,
            rC_Bios__Account__c = account1.Id,
            RecordTypeId = preferenceNationalTypeId,
            rC_Bios__Code_Value__c = 'NONATFRMAIL',
            rC_Bios__Category__c = 'Contact Preference',
            rC_Bios__Subcategory__c = 'No AddUP Campaign Updates'
        );
    }
}