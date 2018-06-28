/**
 * Mock for testing callouts for FogBugzAPI
 *
 * @author  Virginia Fernández
 * @date    04/25/2012
 */
global class FogBugzHttpCalloutMock implements HttpCalloutMock {

    private String responseBody;

    public static final String RESPONSE_TAGS = '<?xml version="1.0" encoding="UTF-8"?><response><cases count="1">' +
                                                 '<case ixBug="testFBId" operations="edit,assign,resolve,email,remind">' +
                                                 '<tags><tag><![CDATA[[0/20]]]></tag><tag><![CDATA[Test]]></tag><tag><![CDATA[CommCare]]></tag></case>' +
                                                 '</cases></response>';
    public static final String RESPONSE_UPDATE = '<?xml version="1.0" encoding="UTF-8"?><response>' +
                                                 '<case ixBug="testFBId" operations="edit,assign,resolve,email,remind">' +
                                                 '</case></response>';
    public static final String RESPONSE_SEARCH = '<?xml version="1.0" encoding="UTF-8"?><response><cases count="1">' +
                                                 '<case ixBug="testFBId"><ixBug>testFBId</ixBug><sTitle>Title</sTitle><sArea>area</sArea><sPersonAssignedTo>salesforce</sPersonAssignedTo><sVersion>1</sVersion><ixPersonOpenedBy>salesforce</ixPersonOpenedBy><dtLastUpdated>2013-04-25T22:47:59Z</dtLastUpdated><hrsElapsed>41.7327995300293</hrsElapsed>' +
                                                 '<event><s>event</s></event></case></cases></response>';
    public static final String RESPONSE_LIST_CASES = '<?xml version="1.0" encoding="UTF-8"?><response><cases count="2">' +
                                                     '<case ixBug="testFBId"><ixBug>testFBId</ixBug><sTitle>Title</sTitle><sArea>area</sArea><sPersonAssignedTo>salesforce</sPersonAssignedTo><sVersion>1</sVersion><ixPersonOpenedBy>salesforce</ixPersonOpenedBy><dtLastUpdated>2007-05-06T22:47:59Z</dtLastUpdated></case>' +
                                                     '<case ixBug="testFBId2"><ixBug>testFBId2</ixBug><sTitle>Title</sTitle><sArea>area</sArea><sPersonAssignedTo>salesforce</sPersonAssignedTo><sVersion>1</sVersion><ixPersonOpenedBy>salesforce</ixPersonOpenedBy><dtLastUpdated></dtLastUpdated></case>' +
                                                     '</cases></response>';
    public static final String RESPONSE_VIEW_PERSON = '<?xml version="1.0" encoding="UTF-8"?><response>' +
                                                      '<person><sEmail>salesforce</sEmail></person></response>';
    public static final String RESPONSE_FILTER = '<response></response>';

    public FogBugzHttpCalloutMock() {
    }

    global HTTPResponse respond(HTTPRequest req) {
        HTTPResponse res = new HTTPResponse();
        String reqBody = req.getBody();

        String[] parameters = reqBody.split('&');
        Map<String, String> params = new Map<String, String>();

        for (String param : parameters) {
            String[] p = param.split('=');
            params.put(p[0],p[1]);
        }

        if (params.get('cmd') == 'search') {
            if (params.containsKey('q')) {
                if (params.get('cols') == 'tags') {
                    res.setBody(RESPONSE_TAGS);
                } else {
                    res.setBody(RESPONSE_SEARCH);
                }
            } else {
                res.setBody(RESPONSE_LIST_CASES);
            }
        } else if (params.get('cmd') == 'setCurrentFilter') {
            res.setBody(RESPONSE_FILTER);
        } else if ((params.get('cmd') == 'new') || (params.get('cmd') == 'resolve') || (params.get('cmd') == 'close') || (params.get('cmd') == 'edit') || (params.get('cmd') == 'reopen')) {
            res.setBody(RESPONSE_UPDATE);
        } else if (params.get('cmd') == 'viewPerson') {
            res.setBody(RESPONSE_VIEW_PERSON);
        }
        res.setStatusCode(200);

        return res;
    }
}