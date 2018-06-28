@isTest
public class AccountFormsContTest {
	static Account acct;
	static Address__c addy;
	static Account_Address__c aAddy;
	static AccountFormsCont cont;

	static void setupData(){
		acct = TestingUtils.createAccounts(1, 'TestAccount', false)[0];
        addy = TestingUtils.createAddresses(1, true)[0];
        cont = new AccountFormsCont();
	}

    static testMethod void constructorTest(){
    	setupData();

        acct.Type = 'AccountFormsTest';
        insert acct;

        Test.startTest();
        cont.mainAccount = new Account(Id=acct.Id);
        Test.stopTest();

        System.assertEquals('AccountFormsTest', cont.mainAccount.Type);
    }

    static testMethod void saveTest_pass(){
    	setupData();
    	cont.redirectPage = true;

    	acct.Type = 'saveTest';
    	cont.mainAccount = acct;
    	cont.address = addy;

    	Test.startTest();
    	PageReference pg = cont.save();
    	Test.stopTest();

    	System.assertNotEquals(null, pg, 'Should have returned an actual pagereference');

    	Account dbAcct = [SELECT Type FROM Account WHERE Id = :acct.Id];

    	System.assertEquals('saveTest', dbAcct.Type);
    }

    static testMethod void saveTest_fail(){
    	setupData();
    	cont.redirectPage = true;

    	acct.Name = null;
    	cont.mainAccount = acct;

    	Test.startTest();
    	PageReference pg = cont.save();
    	Test.stopTest();

    	System.assertEquals(null, pg);

    	try{
    		Account dbAcct = [SELECT Id FROM Account LIMIT 1];
    		System.assert(false, 'There should be no contacts in the database due to failed save');
    	} catch (QueryException e) {}
    }
}