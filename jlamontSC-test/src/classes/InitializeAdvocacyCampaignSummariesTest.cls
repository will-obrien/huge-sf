@isTest
private class InitializeAdvocacyCampaignSummariesTest {
    static Id advocacyId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Advocacy Form').getRecordTypeId();
    static Campaign camp1, camp2;
    static kweos__EOCS_Data__c action1, action2, action3, action4;

    static testMethod void myUnitTest() {
        List<Campaign> campList = new List<Campaign>();
        camp1 = new Campaign(
            Name = 'Test Campaign 1',
            External_Id__c = 'Test Campaign 1',
            RecordTypeId = advocacyId
        );
        campList.add(camp1);
        camp2 = new Campaign(
            Name = 'Test Campaign 2',
            External_Id__c = 'Test Campaign 2',
            RecordTypeId = advocacyId
        );
        campList.add(camp2);
        
        insert campList;
        
        List<kweos__EOCS_Data__c> actionList = new List<kweos__EOCS_Data__c>();
        action1 = new kweos__EOCS_Data__c(
        	Action_Date__c = System.today() - 5,
        	kwac__Related_Action__c = camp1.Id
        );
        actionList.add(action1);

        action2 = new kweos__EOCS_Data__c(
        	Action_Date__c = System.today(),
        	kwac__Related_Action__c = camp1.Id
        );
        actionList.add(action2);
        
        action3 = new kweos__EOCS_Data__c(
        	Action_Date__c = System.today(),
        	kwac__Related_Action__c = camp2.Id
        );
        actionList.add(action3);
        
        action4 = new kweos__EOCS_Data__c(
        	Action_Date__c = System.today() - 7,
        	kwac__Related_Action__c = camp2.Id
        );
        actionList.add(action4);
        
        insert actionList;
        
        Test.startTest();
        Database.executeBatch(new InitializeAdvocacyCampaignSummaries());
        Test.stopTest();
        
        camp1 = [
        	SELECT
        		First_Advocacy_Action_Date__c,
        		Last_Advocacy_Action_Date__c,
        		Advocacy_Action_Count__c
        	FROM Campaign
        	WHERE Id = :camp1.Id
        ];
        
        System.assertEquals(System.today() - 5, camp1.First_Advocacy_Action_Date__c);
        System.assertEquals(System.today(), camp1.Last_Advocacy_Action_Date__c);
        System.assertEquals(2, camp1.Advocacy_Action_Count__c);

        camp2 = [
        	SELECT
        		First_Advocacy_Action_Date__c,
        		Last_Advocacy_Action_Date__c,
        		Advocacy_Action_Count__c
        	FROM Campaign
        	WHERE Id = :camp2.Id
        ];

        System.assertEquals(System.today() - 7, camp2.First_Advocacy_Action_Date__c);
        System.assertEquals(System.today(), camp2.Last_Advocacy_Action_Date__c);
        System.assertEquals(2, camp2.Advocacy_Action_Count__c);
    }
}