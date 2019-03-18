@isTest
global class RSSMockCallout implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/xml');
        res.setBody('<?xml version="1.0" encoding="UTF-8" ?><rss version="2.0"><channel><title>W3Schools Home Page</title><link>http://www.w3schools.com</link><description>Free web building tutorials</description><item><title>RSS Tutorial</title><link>http://www.w3schools.com/xml/xml_rss.asp</link><description>New RSS tutorial on W3Schools</description></item></channel></rss>');
        // 201 is success code.
        res.setStatusCode(201);
        return res;
    }

}