@isTest
private class DaikinToolsOpptyValidationServiceTest
{
    final static String USER_DEPARTMENT = 'Some Department';
    final static String MATCHING_REP_NUMBER = '23823';

    static testMethod void testOpportunityNotFound()
    {
        Id dummyOpptyId = Opportunity.SObjectType.getDescribe().getKeyPrefix() + '000000000111';

        DaikinToolsOpptyValidationService.OpportunityValidationRequest testRequest = new DaikinToolsOpptyValidationService.OpportunityValidationRequest();
        testRequest.SFDCID = dummyOpptyId;

        RestContext.request = new System.RestRequest();
        RestContext.request.requestBody = Blob.valueOf( JSON.serialize(testRequest) );

        Test.startTest();

            RestContext.response = new System.RestResponse();
            DaikinToolsOpptyValidationService.doPost();

        Test.stopTest();

        DaikinToolsOpptyValidationService.OpportunityValidationResponse theResponse = (DaikinToolsOpptyValidationService.OpportunityValidationResponse)JSON.deserialize( RestContext.response.responseBody.toString(), DaikinToolsOpptyValidationService.OpportunityValidationResponse.class );
        System.assertEquals( 1, theResponse.Errors.size(), 'There should be an Error returned if an invalid Opportunity Id is given' );
    }

    static testMethod void testPost_NoErrors()
    {
        User_Departments__c departmentSetting = new User_Departments__c();
        departmentSetting.Name = USER_DEPARTMENT;
        departmentSetting.Region__c = USER_DEPARTMENT;
        departmentSetting.Rep_Number__c = MATCHING_REP_NUMBER;
        System.runAs( TestingUtils.ADMIN_USER )
        {
            insert departmentSetting;
        }

        User testUser = TestingUtils.createTestUser( 'TUser', 'Latin America Sales User' );
        testUser.User_Department__c = USER_DEPARTMENT;
        testUser.Margin_Approver__c = TestingUtils.ADMIN_USER.Id;
        System.runAs( TestingUtils.ADMIN_USER )
        {
            insert testUser;
        }

        Account testAccount = TestingUtils.createAccounts( 1, 'Test Account', true )[0];

        RecordType latinAmericaOpptyType = [ SELECT Id FROM RecordType WHERE SObjectType = 'Opportunity'
                                                AND DeveloperName IN :DaikinToolsOpptyValidationService.LATIN_AM_RECORD_TYPE
                                                AND IsActive = TRUE Limit 1];
        Opportunity testOpportunity = TestingUtils.createOpportunities( 1, testAccount.Id, false )[0];
        testOpportunity.OwnerId = testUser.Id;
        testOpportunity.StageName = 'Order-Won-Crdt Release, Submittal signed';
        testOpportunity.RecordTypeId = latinAmericaOpptyType.Id;
        testOpportunity.Bypass__c = true;
        insert testOpportunity;

        DaikinToolsOpptyValidationService.OpportunityValidationRequest testRequest = new DaikinToolsOpptyValidationService.OpportunityValidationRequest();
        testRequest.SFDCID = testOpportunity.Id;
        testRequest.UserId = testUser.Id;
        testRequest.RepOfficeNumber = MATCHING_REP_NUMBER;

        RestContext.request = new System.RestRequest();
        RestContext.request.requestBody = Blob.valueOf( JSON.serialize(testRequest) );

        Test.startTest();

            RestContext.response = new System.RestResponse();
            DaikinToolsOpptyValidationService.doPost();

        Test.stopTest();

        DaikinToolsOpptyValidationService.OpportunityValidationResponse theResponse = (DaikinToolsOpptyValidationService.OpportunityValidationResponse)JSON.deserialize( RestContext.response.responseBody.toString(), DaikinToolsOpptyValidationService.OpportunityValidationResponse.class );
        System.assert( theResponse.Errors.isEmpty(), 'No errors should have been returned from the callout' );

        testOpportunity = [Select id, Is_Valid__c from Opportunity where id =: testOpportunity.id limit 1][0];
        System.Assert ( testOpportunity.Is_Valid__c, 'The opportunity should be validated.');
    }

    static testMethod void updateOpportunityTest(){
        Opportunity opp = new Opportunity();

        Test.startTest();
            List<DaikinToolsOpptyValidationService.Response_Error> errors =  DaikinToolsOpptyValidationService.updateOpportunity(Opp);
        Test.stopTest();

        System.AssertEquals(0, ApexPages.getMessages().size(), 'No page messages should be fired.');
        System.AssertEquals(1, errors.size(), 'A response error should be returned because the opportunity is not in the database for the update.');

    }

}