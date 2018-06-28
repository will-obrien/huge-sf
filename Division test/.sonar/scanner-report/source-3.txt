/**
 * @author Xavier Fromageot
 * @date Feb 2018
 * @group Marketingforce Test Classes
 * @group-content ../ApexDocContent/TestClasses.html
 * @description Unit test class for ContentDocumentLinkTriggerHandler
 **/
@IsTest
private class ContentDocumentLinkTriggerHandlerUnit {

    /**
     * Method Tested: afterInsert
     * | Scenario: Linked entity is a "Prospect DM" Campaign_Channel
     * | Expected Result: CampaignChannelManager's sendEmailAlert method called to update Email_Alert field correctly
     **/
    static testMethod void afterInsert_LinkedEntityIsProspectDMCampaignChannel_SendEmailAlertCalledCorrectly() {

        //Create test data
        ContentDocumentLink docLink = new ContentDocumentLink();
        docLink.Id = fflib_IDGenerator.generate(ContentDocumentLink.SObjectType);

        Id campChanId = fflib_IDGenerator.generate(Campaign_Channel__c.SObjectType);

        //Note: Use setReadOnlyField method to set field values otherwise not allowed by Apex
        docLink = (ContentDocumentLink)MockFieldSetUtil.setReadOnlyField(docLink, ContentDocumentLink.class,
                ContentDocumentLink.LinkedEntityId, campChanId);

        //Campaign Channel
        Campaign_Channel__c campChan = new Campaign_Channel__c();
        campChan.Id = campChanId;

        //Channel Config
        Channel_Config__c chanConfig = new Channel_Config__c(
                Id=fflib_IDGenerator.generate(Channel_Config__c.SObjectType),
                Name='Prospect DM');

        campChan.Channel_Config__r = chanConfig;
        campChan.Channel_Config__c = chanConfig.Id;
        Map<Id, ContentDocumentLink> newMap = new Map<Id, ContentDocumentLink> {docLink.Id => docLink};

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        CampaignChannelManager mockCampaignChannelManager = (CampaignChannelManager)mocks.mock(CampaignChannelManager.class);

        //Stub the behavior of data access object call
        mocks.startStubbing();
        mocks.when(mockCampaignChannelManager.getCampaignChannelMapById(new Set<Id>{campChanId}))
            .thenReturn(new Map<Id, Campaign_Channel__c>{campChanId => campChan});
        mocks.when(mockCampaignChannelManager.hasSourceCodeAssigned(new Set<Id>{campChanId}))
                .thenReturn(new Map<Id, Boolean>{campChanId => true});

        mocks.stopStubbing();

        //Inject the data access object into the handler via property injection
        ContentDocumentLinkTriggerHandler handler = new ContentDocumentLinkTriggerHandler();
        handler.campaignChannelManager = mockCampaignChannelManager;

        Test.startTest();
        handler.afterInsert(newMap);
        Test.stopTest();

        //Verify sendEmailAlert method called once with expected map argument
        ((CampaignChannelManager)mocks.verify(mockCampaignChannelManager, 1)).sendEmailAlert(
                new Map<Id, String> {docLink.LinkedEntityId => 'Prospect DM Attachment Added'});

    }

    /**
     * Method Tested: afterInsert
     * | Scenario: Linked entity is a "Customer Phone" campaign channel
     * | Expected Result: CampaignChannelManager's sendEmailAlert method not called
     **/
    static testMethod void afterInsert_LinkedEntityCustomerPhoneCampaignChannel_SendEmailAlertNotCalled() {

        ContentDocumentLink docLink = new ContentDocumentLink();
        docLink.Id = fflib_IDGenerator.generate(ContentDocumentLink.SObjectType);

        Id campChanId = fflib_IDGenerator.generate(Campaign_Channel__c.SObjectType);
        docLink = (ContentDocumentLink)MockFieldSetUtil.setReadOnlyField(docLink, ContentDocumentLink.class,
                ContentDocumentLink.LinkedEntityId, campChanId);

        //Campaign Channel
        Campaign_Channel__c campChan = new Campaign_Channel__c();
        campChan.Id = campChanId;

        //Channel Config
        Channel_Config__c chanConfig = new Channel_Config__c(
                Id=fflib_IDGenerator.generate(Channel_Config__c.SObjectType),
                Name='Customer Phone');

        campChan.Channel_Config__r = chanConfig;
        campChan.Channel_Config__c = chanConfig.Id;

        Map<Id, ContentDocumentLink> newMap = new Map<Id, ContentDocumentLink> {docLink.Id => docLink};

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        CampaignChannelManager mockCampaignChannelManager = (CampaignChannelManager)mocks.mock(CampaignChannelManager.class);

        mocks.startStubbing();
        mocks.when(mockCampaignChannelManager.getCampaignChannelMapById(new Set<Id>{campChanId}))
                .thenReturn(new Map<Id, Campaign_Channel__c>{campChanId => campChan});
        mocks.when(mockCampaignChannelManager.hasSourceCodeAssigned(new Set<Id>{campChanId}))
                .thenReturn(new Map<Id, Boolean>{campChanId => true});

        mocks.stopStubbing();

        ContentDocumentLinkTriggerHandler handler = new ContentDocumentLinkTriggerHandler();
        handler.campaignChannelManager = mockCampaignChannelManager;

        Test.startTest();
        handler.afterInsert(newMap);
        Test.stopTest();

        //sendEmailAlert not called
        ((CampaignChannelManager)mocks.verify(mockCampaignChannelManager, 0)).sendEmailAlert(new Map<Id, String>());
    }
}