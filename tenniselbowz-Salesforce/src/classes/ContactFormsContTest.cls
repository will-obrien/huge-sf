@isTest
public class ContactFormsContTest {
	static Account acct;
	static Contact ctc;
	static Address__c addy;
	static Contact_Address__c cAddy;
	static ContactFormsCont cont;

	static void setupData(){
		acct = TestingUtils.createAccounts(1, 'TestAccount', true)[0];
        ctc = TestingUtils.createContacts(1, acct.Id, false)[0];
        addy = TestingUtils.createAddresses(1, true)[0];
        cont = new ContactFormsCont();
	}

    static testMethod void constructorTest(){
    	setupData();

        ctc.LastName = 'ContactFormsContTest';
        insert ctc;

        cAddy = TestingUtils.createContactAddresses(1, ctc.Id, addy.Id, true)[0];

        Test.startTest();
        cont.mainContact = new Contact(Id=ctc.Id);
        Test.stopTest();

        System.assertEquals('ContactFormsContTest', cont.mainContact.LastName);
    }

    static testMethod void saveTest_pass(){
    	setupData();
    	cont.redirectPage = true;

    	ctc.LastName = 'saveTest';
    	cont.mainContact = ctc;
    	cont.address = addy;

    	Test.startTest();
    	PageReference pg = cont.save();
    	Test.stopTest();

    	System.assertNotEquals(null, pg, 'Should have returned an actual pagereference');

    	Contact dbCtc = [SELECT LastName FROM Contact WHERE Id = :ctc.Id];

    	System.assertEquals('saveTest', dbCtc.LastName);
    }

    static testMethod void saveTest_fail(){
    	setupData();
    	cont.redirectPage = true;

    	ctc.LastName = null;
    	cont.mainContact = ctc;

    	Test.startTest();
    	PageReference pg = cont.save();
    	Test.stopTest();

    	System.assertEquals(null, pg);

    	try{
    		Contact dbCtc = [SELECT Id FROM Contact LIMIT 1];
    		System.assert(false, 'There should be no contacts in the database due to failed save');
    	} catch (QueryException e) {}
    }
}