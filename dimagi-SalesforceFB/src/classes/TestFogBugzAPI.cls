/**
 * Tests for the FogBugzAPI class
 *
 * @author  Antonio Grassi
 * @date    11/15/2012
 */

@isTest
public class TestFogBugzAPI {
    
    public final static String TEST_FB_ID = 'testFBId';
    
    public final static String TEST_SF_ID = 'testSFId';
    
    public final static String GET_CASES_RESPONSE = '<?xml version="1.0" encoding="UTF-8"?>' +
                                                    '<response>' +
                                                    '<cases count="1"><case ixBug="testFBId" operations="edit,assign,resolve,email,remind">' +
                                                    '<sTitle><![CDATA[Test title]]></sTitle>' +
                                                    '<sArea><![CDATA[Test area]]></sArea>' +
                                                    '<sPersonAssignedTo><![CDATA[Test assignee]]></sPersonAssignedTo>' +
                                                    '<sVersion><![CDATA[testSFId]]></sVersion>' +
                                                    '<dtLastUpdated>2012-1-1T00:00:00Z</dtLastUpdated>' +
                                                    '<tags><tag><![CDATA[[1/1]]]></tag></tags>' +
                                                    '<ixPersonOpenedBy>1</ixPersonOpenedBy>' +
                                                    '<hrsElapsed>41.7327995300293</hrsElapsed>' +
                                                    '</case></cases>' +
                                                    '</response>';

    public final static String SET_CURRENT_FILTER_RESPONSE = '<?xml version="1.0" encoding="UTF-8"?><response></response>';

    public final static String UPSERT_CASE_RESPONSE = '<?xml version="1.0" encoding="UTF-8"?><response>' +
                                                      '<case ixBug="testFBId" operations="edit,assign,resolve,email,remind"></response>';

    /**static testMethod void testSetCurrentFilter() {
        FogBugzHTTPMock fakeHTTP = new FogBugzHTTPMock(SET_CURRENT_FILTER_RESPONSE);
        Test.setMock(HttpCalloutMock.class, fakeHTTP);

        FogBugzAPI api = new FogBugzAPI();
        System.assertEquals(SET_CURRENT_FILTER_RESPONSE, api.setCurrentFilter(1), 'setCurrentFilter failed');
    }

    static testMethod void testListCases() {
        FogBugzHTTPMock fakeHTTP = new FogBugzHTTPMock(GET_CASES_RESPONSE);
        Test.setMock(HttpCalloutMock.class, fakeHTTP);

        FogBugzAPI api = new FogBugzAPI();
        Map<String, FogBugzCase> cases = api.listCases();

        System.assertEquals(1, cases.size(), 'Number of cases do not match');

        FogBugzCase fbCase = cases.values()[0];
        System.assertEquals(TEST_FB_ID, fbCase.caseId, 'FB case id does not match');
        System.assertEquals('1', fbCase.ixPersonOpenedBy, 'FB person opened by does not match');
    }

    static testMethod void testGetCase() {
        FogBugzHTTPMock fakeHTTP = new FogBugzHTTPMock(GET_CASES_RESPONSE);
        Test.setMock(HttpCalloutMock.class, fakeHTTP);

        FogBugzAPI api = new FogBugzAPI();
        FogBugzCase fbCase = api.getCase(TEST_FB_ID);

        System.assertNotEquals(null, fbCase, 'FB case was not retrieved');
        System.assertEquals(TEST_FB_ID, fbCase.caseId, 'FB case id does not match');
        System.assertEquals('Test title', fbCase.title, 'FB case title does not match');
        System.assertEquals('Test area', fbCase.area, 'FB case area does not match');
        System.assertEquals('Test assignee', fbCase.assignedTo, 'FB case assignee does not match');
        System.assertEquals(TEST_SF_ID, fbCase.externalBugID, 'FB case external bug id does not match');
        System.assertEquals(Datetime.newInstanceGMT(2012, 1, 1, 0, 0, 0), fbCase.lastModifiedDate, 'FB case last modified date does not match');
        System.assertEquals(1, fbCase.probability, 'FB case probability does not match');
        System.assertEquals(1, fbCase.dealSize, 'FB case deal size does not match');
        System.assertEquals('1', fbCase.ixPersonOpenedBy, 'FB person opened by does not match');
        
    }
    
    static testMethod void testCreateCase() {
        FogBugzHTTPMock fakeHTTP = new FogBugzHTTPMock(UPSERT_CASE_RESPONSE);
        Test.setMock(HttpCalloutMock.class, fakeHTTP);
        FogBugzAPI api = new FogBugzAPI();

        FogBugzCase fbCase = new FogBugzCase();
        fbCase.externalBugID = TEST_SF_ID;
        fbCase.project = 'Test project';
        fbCase.area = 'Test area';
        fbCase.assignedTo = 'Test assignee';
        fbCase.status = 'Test status';
        fbCase.priority = 1;
        fbCase.title = 'Test title';
        api.createCase(fbCase);
        System.assertEquals(TEST_FB_ID, fbCase.caseId, 'FB case id does not match');
    }

    static testMethod void testEditCase() {
        FogBugzHTTPMock fakeHTTP = new FogBugzHTTPMock(UPSERT_CASE_RESPONSE);
        Test.setMock(HttpCalloutMock.class, fakeHTTP);

        FogBugzAPI api = new FogBugzAPI();

        FogBugzCase fbCase = new FogBugzCase();
        fbCase.externalBugID = TEST_SF_ID;
        fbCase.caseId = TEST_FB_ID;

        System.assertEquals(TEST_FB_ID, api.updateCase(fbCase), 'FB case id does not match');
    }

    static testMethod void testAddNote() {
        FogBugzHTTPMock fakeHTTP = new FogBugzHTTPMock(UPSERT_CASE_RESPONSE);
        Test.setMock(HttpCalloutMock.class, fakeHTTP);

        FogBugzAPI api = new FogBugzAPI();
        System.assertEquals(TEST_FB_ID, api.addNote(TEST_FB_ID, 'Dummy text'), 'Something went wrong while adding notes');
    }*/

    static testMethod void testParseCases() {
        FogBugzAPI api = new FogBugzAPI();
        api.parseCases(GET_CASES_RESPONSE);
        api.parseCaseList(GET_CASES_RESPONSE);
    }
}