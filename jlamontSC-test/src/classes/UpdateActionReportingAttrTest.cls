@isTest
private class UpdateActionReportingAttrTest {
	static Id offLineCampaignTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Offline Action').getRecordTypeId();
	static Id offLineActionTypeId = Schema.SObjectType.kweos__EOCS_Data__c.getRecordTypeInfosByName().get('Offline').getRecordTypeId();

    static testMethod void myUnitTest() {
		Campaign camp = new Campaign(
			RecordTypeId = offlineCampaignTypeId,
			Name='TestCamp'
		);

		camp.Marketing_Tags_Global__c = '100 percent clean energy';
		camp.Tactic_Owner_Category_Global__c = 'Volunteer or Local Entity';
		camp.Tactic_Owner_Global__c = 'Chapter';
		camp.State_Global__c = 'UT';
		camp.National_Campaign_Global__c = 'Ready for 100';
		camp.Campaign_Strategy_Global__c = '100% Cities';
        camp.Local_Campaign_Global__c = 'Oakland';
        
        insert camp;
        
        kweos__EOCS_Data__c action = new kweos__EOCS_Data__c(
        	RecordTypeId = offLineActionTypeId,
        	kwac__Related_Action__c = camp.Id
        );
        
        insert action;
        
        kweos__EOCS_Data__c savedAction = [
        	select
        		//Marketing_Tags_Global__c,
        		Tactic_Owner_Category_Global__c,
        		Tactic_Owner_Global__c,
        		State_Global__c,
        		National_Campaign_Global__c,
        		Campaign_Strategy_Global__c
        	from kweos__EOCS_Data__c
        	where Id = :action.Id
        ];

        //System.assertEquals(camp.Marketing_Tags_Global__c, savedAction.Marketing_Tags_Global__c);
        System.assertEquals(camp.Tactic_Owner_Category_Global__c, savedAction.Tactic_Owner_Category_Global__c);
        System.assertEquals(camp.Tactic_Owner_Global__c, savedAction.Tactic_Owner_Global__c);
        System.assertEquals(camp.State_Global__c, savedAction.State_Global__c);
        System.assertEquals(camp.National_Campaign_Global__c, savedAction.National_Campaign_Global__c);
        
		Campaign changedCamp = new Campaign(
			Id = camp.Id,
			Marketing_Tags_Global__c = 'economic justice',
			Tactic_Owner_Global__c = 'Group',
			State_Global__c = 'CA',
			National_Campaign_Global__c = 'Our Wild America',
			Campaign_Strategy_Global__c = 'Beyond Dirty Fuels',
        	Local_Campaign_Global__c = 'Crude by Rail'
        );
        update changedCamp;
        
        changedCamp = [
        	select 
        		Marketing_Tags_Global__c,
        		Tactic_Owner_Category_Global__c,
        		Tactic_Owner_Global__c,
        		State_Global__c,
        		National_Campaign_Global__c,
        		Campaign_Strategy_Global__c
			from Campaign
			where Id = :camp.Id        	
        ];
        
        CampaignChange__c campChg = [
        	select Campaign__c
        	from CampaignChange__c
        ];
        System.assertEquals(camp.Id, campChg.Campaign__c);

		List<Campaign> campList = new List<Campaign>();
        Campaign camp2 = camp.clone(false, true);
        camp2.Name = 'TestCamp2';
        campList.add(camp2);
        
        Campaign camp3 = camp.clone(false, true);
        camp3.Name = 'TestCamp3';
        campList.add(camp3);
        
        insert campList;
        
        List<CampaignChange__c> campChgList = new List<CampaignChange__c>();
		CampaignChange__c campChg1 = new CampaignChange__c(Campaign__c = camp2.Id);
		campChgList.add(campChg1);

		CampaignChange__c campChg2 = new CampaignChange__c(Campaign__c = camp3.Id);
		campChgList.add(campChg2);
		
		insert campChgList;
		
		Test.setCreatedDate(campChg2.Id, System.today() + 1);
        
		Test.startTest();
		Database.executeBatch(new UpdateActionReportingAttr());
		Test.stopTest();
		
        kweos__EOCS_Data__c updatedAction = [
        	select
        		//Marketing_Tags_Global__c,
        		Tactic_Owner_Category_Global__c,
        		Tactic_Owner_Global__c,
        		State_Global__c,
        		National_Campaign_Global__c,
        		Campaign_Strategy_Global__c
        	from kweos__EOCS_Data__c
        	where Id = :action.Id
        ];

        //System.assertEquals(changedCamp.Marketing_Tags_Global__c, updatedAction.Marketing_Tags_Global__c);
        System.assertEquals(changedCamp.Tactic_Owner_Category_Global__c, updatedAction.Tactic_Owner_Category_Global__c);
        System.assertEquals(changedCamp.Tactic_Owner_Global__c, updatedAction.Tactic_Owner_Global__c);
        System.assertEquals(changedCamp.State_Global__c, updatedAction.State_Global__c);
        System.assertEquals(changedCamp.National_Campaign_Global__c, updatedAction.National_Campaign_Global__c);
        
        List<CampaignChange__c> changeList = [
        	select Id, Campaign__c
        	from CampaignChange__c
        ];
        System.assert(changeList.isEmpty());
    }
}