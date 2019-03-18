@isTest
private class DaikinToolsOpptyInOutServiceTest
{
    static testMethod void testPost_NoErrors()
    {
        final Set<String> APPKEY_VALUES = new Set<String>{ 'SOMEKEY', 'AnoTHer KeY', 'something_else' };
        final Set<String> TYPES_PER_APPKEY = new Set<String>{ 'some component', 'another component', 'yetanother componENT' };

        List<Input_and_Output_Values__c> testSettings = new List<Input_and_Output_Values__c>();
        for( String anAppkey : APPKEY_VALUES )
        {
            for( String aComponent : TYPES_PER_APPKEY )
            {
                Input_and_Output_Values__c newSetting = new Input_and_Output_Values__c();
                newSetting.Name = anAppkey + aComponent;
                newSetting.AppKey__c = anAppKey;
                newSetting.Input_Output_Value_Name__c = aComponent;
                testSettings.add( newSetting );
            }
        }
        System.runAs( TestingUtils.ADMIN_USER )
        {
            insert testSettings;
        }

        DaikinToolsOpptyInOutService.OpportunityInOutRequest testRequest = new DaikinToolsOpptyInOutService.OpportunityInOutRequest();
        testRequest.OpportunityItems = new List<DaikinToolsOpptyInOutService.Request_OpportunityItem>();
        for( String anAppkey : APPKEY_VALUES )
        {
            DaikinToolsOpptyInOutService.Request_OpportunityItem newOpptyItem = new DaikinToolsOpptyInOutService.Request_OpportunityItem();
            newOpptyItem.ItemGuid = anAppkey + System.now().getTime();
            newOpptyItem.AppKey = anAppKey;
            testRequest.OpportunityItems.add( newOpptyItem );
        }

        RestContext.request = new System.RestRequest();
        RestContext.request.requestBody = Blob.valueOf( JSON.serialize(testRequest) );

        Test.startTest();

            RestContext.response = new System.RestResponse();
            DaikinToolsOpptyInOutService.doPost();

        Test.stopTest();

        DaikinToolsOpptyInOutService.OpportunityInOutResponse theResponse = (DaikinToolsOpptyInOutService.OpportunityInOutResponse)JSON.deserialize( RestContext.response.responseBody.toString(), DaikinToolsOpptyInOutService.OpportunityInOutResponse.class );
        System.assertEquals( testRequest.OpportunityItems.size(), theResponse.OpportunityItems.size(), 'There should be as many Opportunity Items returned as were sent through the request' );

        Map<String, DaikinToolsOpptyInOutService.Response_OpportunityItem> responseItemsByGUID = new Map<String, DaikinToolsOpptyInOutService.Response_OpportunityItem>();
        for( DaikinToolsOpptyInOutService.Response_OpportunityItem anItem : theResponse.OpportunityItems )
        {
            responseItemsByGUID.put( anItem.ItemGuid, anItem );
        }
        System.assertEquals( APPKEY_VALUES.size(), responseItemsByGUID.size(), 'There should be as many guids as there are appkeys' );

        for( DaikinToolsOpptyInOutService.Request_OpportunityItem aRequestItem : testRequest.OpportunityItems )
        {
            System.assert( responseItemsByGUID.containsKey( aRequestItem.ItemGuid ), 'Every request Item should have been returned' );
            System.assertEquals( TYPES_PER_APPKEY.size(), responseItemsByGUID.get( aRequestItem.ItemGuid ).InputsAndOutputs.size(), 'For each appkey, all applicable types shoudl have been retrieved' );
        }
    }
}