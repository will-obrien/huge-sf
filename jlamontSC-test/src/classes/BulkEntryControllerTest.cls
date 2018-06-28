@isTest
private class BulkEntryControllerTest {

    static testMethod void myUnitTest() {
		OriginalCampaignName__c origCampName = new OriginalCampaignName__c();
		origCampName.Name = 'X04QGAIA';
		insert origCampName;
		
		Campaign origCamp = new Campaign(Name=origCampName.Name);
		insert origCamp;

    	BulkEntryController bec = new BulkEntryController();
		bec.processFileContents();
		bec.getRowList();
		bec.getHasFileBody();
    	String fileBodyString = 'Id,First Name,Last Name,Address,City,State,Zip,Email,Phone\r\n' +
			'41794448,Dave,Simon,2201 Webster St,Oakland,CA,94612,dave.simon@sierraclub.org,5105556666\r\n';
		bec.fileBodyString = 'test.csv';
		bec.setFileBody(Blob.valueOf(fileBodyString));
		bec.processFileContents();
		bec.processInputData();
		bec.getHasFileBody();
		bec.setNumRowsToAdd('1');
		bec.addRows();
		bec.getNumRowsToAdd();
		bec.setEntryMode('file');
		bec.getEntryMode();
		bec.getFileBody();
		bec.startNewBatch();
		bec.finalProcessing();
		bec.getRowsMatched();
		bec.getRowsNotMatched();
		bec.getNumRowsMatched();
		bec.getNumRowsNotMatched();

    	bec = new BulkEntryController();
    	fileBodyString = 'Id,First Name,Last Name,Address,City,State,Zip,Email,Phone\r\n' +
			',,,,,,,,\r\n' +
			'41794448,,,,,,,dave.simonsierraclub.org,510555666\r\n' +
			'41794448,Dave,Simon,,,,,,\r\n';
		bec.setFileBody(Blob.valueOf(fileBodyString));
		bec.processFileContents();
		bec.processInputData();
		bec.getSelectedTag();
		bec.setSelectedTag('manual');
		
		CampaignSearchController csc = bec.getCampSearchController();
		bec.setCampSearchController(csc);
		Campaign camp = new Campaign();
		bec.setSelectedCampaign(camp);
		
		EventTagController etc = bec.getEventTagController();
		bec.setEvTagController(etc);
        
		ListTagController ltc = bec.getListTagController();
		bec.setLiTagController(ltc);        
		
		ActionTagController atc = new ActionTagController();
		bec.setAcTagController(atc);
		bec.cancelActionTag();
		atc = bec.getActionTagController();
		
		bec.getThis();
		
		bec.selectedInterest = null;
		bec.selectedPreference = null;
		bec.selectedActionCampaign = null;
		bec.selectedAction = null;
		bec.selectedEvent = null;
		bec.selectedListCampaign = null;        
		bec.selectedEventRegistrationStatus = null;
		
		BulkEntryController.EntryRow row = new BulkEntryController.EntryRow();
		row.emailError = false;
		row.matchedContact = null;
		row.updateAddress = false;
		row.updateEmail = false;
		row.updatePhone = false;
		row.wrongMatch = false;
		
		bec.setActionTag();
		bec.setCampaignTag();
		bec.setEventTag();
        bec.setListTag();
		bec.setInterestTag();
		bec.setPreferenceTag();

		bec.deleteActionTag();
		bec.deleteCampaignTag();
		bec.deleteEventTag();
        bec.deleteListTag();
		bec.deleteInterestTag();
		bec.deletePreferenceTag();

		bec.setFileBody(Blob.valueOf(''));
		bec.processFileContents();
		bec.processInputData();
    }
}