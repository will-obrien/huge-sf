/**
 * Tests for the FogBugzAPI class
 *
 * @author  Virginia Fernández
 * @date    04/25/2012
 */
@isTest
private class TestFBApi {

    static testMethod void listCasesTest() {
        FogBugzAPI api = new FogBugzAPI();
        Test.startTest();

        Map<String, FogBugzCase> cases = api.listCases();
        System.assertEquals(cases.size(), 2);
        System.assert(cases.containsKey('testFBId'));
        System.assert(cases.containsKey('testFBId2'));
        FogBugzCase fbCase = cases.get('testFBId');
        FogBugzCase fbCase2 = cases.get('testFBId2');
        System.assertEquals(fbCase.caseId, 'testFBId');
        System.assertEquals(fbCase2.caseId, 'testFBId2');
        System.assertEquals(fbCase.ixPersonOpenedBy, 'salesforce');
        System.assertEquals(fbCase2.ixPersonOpenedBy, 'salesforce');
        System.assert(fbCase.lastModifiedDate != null);
        System.assertEquals(fbCase2.lastModifiedDate, null);

        Test.stopTest();
    }

    static testMethod void getCaseTest() {
        FogBugzAPI api = new FogBugzAPI();
        Test.startTest();

        FogBugzCase fbCase = api.getCase('testFBId');
        System.assert(fbCase != null);
        System.assertEquals(fbCase.title, 'Title');
        System.assertEquals(fbCase.area, 'area');
        System.assertEquals(fbCase.assignedTo, 'salesforce');
        System.assertEquals(fbCase.externalBugID, '1');
        System.assertEquals(fbCase.caseId, 'testFBId');
        System.assertEquals(fbCase.ixPersonOpenedBy, 'salesforce');
        System.assertEquals(fbCase.latestEvent, 'event');
        System.assertEquals(fbCase.hrsElapsed, 41.7327995300293);
        System.assertEquals(fbCase.lastModifiedDate, Datetime.valueOfGmt('2013-04-25T22:47:59Z'.replace('T', ' ').removeEnd('Z')));

        Test.stopTest();
    }

    static testMethod void setCurrentFilterTest() {
        FogBugzAPI api = new FogBugzAPI();
        Test.startTest();

        String res = api.setCurrentFilter(1);
        System.assertEquals(res, FogBugzHttpCalloutMock.RESPONSE_FILTER);

        Test.stopTest();
    }

    static testMethod void createCaseTest() {
        FogBugzAPI api = new FogBugzAPI();
        Test.startTest();

        FogBugzCase fbCase = new FogBugzCase();
        fbCase.externalBugID = 'testSFId';
        fbCase.project = 'Test project';
        fbCase.area = 'Test area';
        fbCase.assignedTo = 'Test assignee';
        fbCase.status = 'Test status';
        fbCase.priority = 1;
        fbCase.title = 'Test title';
        fbCase.probability = 10.0;
        String fbCaseId = api.createCase(fbCase, true);
        System.assertEquals(fbCaseId, 'testFBId');

        Test.stopTest();
    }

    static testMethod void resolveAndCloseCaseTest() {
        FogBugzAPI api = new FogBugzAPI();
        Test.startTest();

        FogBugzCase fbCase = new FogBugzCase();
        fbCase.externalBugID = 'testSFId';
        fbCase.project = 'Test project';
        fbCase.area = 'Test area';
        fbCase.assignedTo = 'Test assignee';
        fbCase.status = 'Test status';
        fbCase.priority = 1;
        fbCase.title = 'Test title';
        fbCase.caseId = 'testFBId';
        String fbCaseId = api.resolveCase(fbCase);
        System.assertEquals(fbCaseId, 'testFBId');
        fbCaseId = api.closeCase(fbCase);
        System.assertEquals(fbCaseId, 'testFBId');

        Test.stopTest();
    }

    static testMethod void reopenCaseTest() {
        FogBugzAPI api = new FogBugzAPI();
        Test.startTest();

        FogBugzCase fbCase = new FogBugzCase();
        fbCase.externalBugID = 'testSFId';
        fbCase.project = 'Test project';
        fbCase.area = 'Test area';
        fbCase.assignedTo = 'Test assignee';
        fbCase.status = 'Test status';
        fbCase.priority = 1;
        fbCase.title = 'Test title';
        fbCase.caseId = 'testFBId';
        String fbCaseId = api.reopenCase(fbCase);
        System.assertEquals(fbCaseId, 'testFBId');

        Test.stopTest();
    }

    static testMethod void updateCaseTest() {
        FogBugzAPI api = new FogBugzAPI();
        Test.startTest();

        FogBugzCase fbCase = new FogBugzCase();
        fbCase.externalBugID = 'testSFId';
        fbCase.project = 'Test project';
        fbCase.area = 'Test area';
        fbCase.assignedTo = 'Test assignee';
        fbCase.status = 'Test status';
        fbCase.priority = 1;
        fbCase.title = 'Test title';
        fbCase.caseId = 'testFBId';
        String fbCaseId = api.updateCase(fbCase);
        System.assertEquals(fbCaseId, 'testFBId');
        fbCase.dealSize = 1000;
        fbCase.probability = 10.0;
        fbCaseId = api.updateCaseTitleStageTag(fbCase, true, new Set<String>(), false, false);
        System.assertEquals(fbCaseId, 'testFBId');

        Test.stopTest();
    }

    static testMethod void updateTagsTest() {
        FogBugzAPI api = new FogBugzAPI();
        Test.startTest();

        FogBugzCase fbCase = new FogBugzCase();
        fbCase.externalBugID = 'testSFId';
        fbCase.project = 'Test project';
        fbCase.area = 'Test area';
        fbCase.assignedTo = 'Test assignee';
        fbCase.status = 'Test status';
        fbCase.priority = 1;
        fbCase.title = 'Test title';
        fbCase.caseId = 'testFBId';
        String fbCaseId = api.updateCaseTitleStageTag(fbCase, true, new Set<String>{'CommCare','CommConnect'}, false, true);
        System.assertEquals(fbCaseId, 'testFBId');

        Test.stopTest();
    }

    static testMethod void addNoteTest() {
        FogBugzAPI api = new FogBugzAPI();
        Test.startTest();

        String fbCaseId = api.addNote('testFBId', 'note');
        System.assertEquals(fbCaseId, 'testFBId');

        Test.stopTest();
    }

    static testMethod void getPersonEmailTest() {
        FogBugzAPI api = new FogBugzAPI();
        Test.startTest();

        String fbCaseId = api.getPersonEmail('salesforce');
        System.assertEquals(fbCaseId, 'salesforce');

        Test.stopTest();
    }
}