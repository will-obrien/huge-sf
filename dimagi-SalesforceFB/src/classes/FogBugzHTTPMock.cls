global class FogBugzHTTPMock implements HTTPCalloutMock {

    private String responseBody;

    public FogBugzHTTPMock(String responseBody) {
        this.responseBody = responseBody;
    }

    global HTTPResponse respond(HTTPRequest request) {
        HTTPResponse res = new HTTPResponse();
        res.setBody(responseBody);
        return res;
    }
}