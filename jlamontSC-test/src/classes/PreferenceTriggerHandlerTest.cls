/*********************************************************************************************************
Name			: PreferenceTriggerHandler
Created by		: Dipika Gupta (Appirio)
Created Date	: Feb 10, 2014
Description		: test class for PreferenceTriggerHandler
Real Desc.		: I am a crap test that doesn't reallly test anything.  I need to be re-written.
Update			: 2014/08/27 VB: Minor fix for Summit Circle Preference
***********************************************************************************************************/
@isTest
private class PreferenceTriggerHandlerTest {
    private static String HouseHoleAccountRecordType;
    private static String HouseHoleContactRecordType;

    //fetch Account and Contact record type with name 'Houshold'
    private static void recordTypes(){
        for(RecordType RT: [SELECT ID,SobjectType FROM RecordType WHERE NAME ='Household']){
            if(RT.SobjectType == 'Account' ){
                HouseHoleAccountRecordType = RT.ID;
            }
            if(RT.SobjectType == 'Contact'){
                HouseHoleContactRecordType = RT.ID;
            }
        }
    }

    //method to test Preference creation
    private static testMethod void PreferenceCreation(){

        recordTypes();
        Contact testContact = new Contact(LastName='Sierra');
        if(HouseHoleContactRecordType != null){
            testContact.RecordTypeId = HouseHoleContactRecordType;
        }
        insert testContact;
        Account testAccount = new Account(Name='Sierra');
        if(HouseHoleAccountRecordType != null){
            testAccount.RecordTypeId = HouseHoleAccountRecordType;
        }
        insert testAccount;
        rC_Bios__Preference__c Preference = new rC_Bios__Preference__c(rC_Bios__Contact__c = testContact.Id,
                                                                       rC_Bios__Account__c = testAccount.Id,
                                                                       rC_Bios__Subcategory__c = 'Major Gift Donor',
                                                                       rC_Bios__Active__c = true);
        insert Preference;
        testAccount = [SELECT Major_Donor__c,Major_Donor_Prospect__c FROM Account WHERE ID =: testAccount.Id];
        system.assert(testAccount.Major_Donor__c);

    }

    //method to test Preference update
    private static testMethod void PreferenceModification(){
        recordTypes();

        Contact testContact1 = new Contact(LastName='Sierra1');
        Contact testContact2 = new Contact(LastName='Sierra2');
        if(HouseHoleContactRecordType != null){
            testContact1.RecordTypeId = HouseHoleContactRecordType;
            testContact2.RecordTypeId = HouseHoleContactRecordType;
        }
        insert new list<Contact>{testContact1,testContact2};
        Account testAccount1 = new Account(Name='Sierra');
        Account testAccount2 = new Account(Name='Sierra');
        if(HouseHoleAccountRecordType != null){
            testAccount1.RecordTypeId = HouseHoleAccountRecordType;
            testAccount2.RecordTypeId = HouseHoleAccountRecordType;
        }
        insert new list<Account>{testAccount1,testAccount2};
        rC_Bios__Preference__c Preference1 = createPreference(testContact1.Id,testAccount1.Id,'Major Gift Donor');
        rC_Bios__Preference__c Preference2 = createPreference(testContact1.Id,testAccount1.Id,'Major Gift Donor Prospect');
        rC_Bios__Preference__c Preference3 = createPreference(testContact1.Id,testAccount1.Id,'Summit Circle Member');	// Changed Donor to Member
        rC_Bios__Preference__c Preference4 = createPreference(testContact1.Id,testAccount1.Id,'Planned Gift Donor');
        rC_Bios__Preference__c Preference5 = createPreference(testContact1.Id,testAccount1.Id,'Planned Gift Major Prospect');
        rC_Bios__Preference__c Preference6 = createPreference(testContact1.Id,testAccount1.Id,'John Muir Society');		// WARNING: This is wrong.
        insert new list<rC_Bios__Preference__c>{Preference1,Preference2,Preference3,Preference4,Preference5,Preference6};
        Preference1.rC_Bios__Contact__c= testContact2.Id;
        Preference1.rC_Bios__Account__c= testAccount2.Id;
        Preference1.rC_Bios__Active__c = false;
        update Preference1;
        testAccount1 = [SELECT Major_Donor__c,Major_Donor_Prospect__c FROM Account WHERE ID =: testAccount1.Id];
        testAccount2 = [SELECT Major_Donor__c,Major_Donor_Prospect__c FROM Account WHERE ID =: testAccount2.Id];
        system.assert(!testAccount1.Major_Donor__c);
        system.assert(!testAccount2.Major_Donor__c);
        
        testAccount2.Major_Donor__c = true;
        update testAccount2;
        
        testContact2.Major_Donor__c = true;
        update testContact2;

        delete Preference1;
        undelete Preference1;
    }

    private static rC_Bios__Preference__c createPreference(ID contactId,Id accountId, String subcategory){
        rC_Bios__Preference__c Preference = new rC_Bios__Preference__c(rC_Bios__Contact__c = contactId,
                                                                       rC_Bios__Account__c = accountId,
                                                                       rC_Bios__Subcategory__c = subcategory);
        return Preference;
    }

}