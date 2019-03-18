@isTest
public class LatencyTest {
	
	@isTest static void pingRemoteURLTest() {
		//Set the mock response class for testing, defined below
		Test.setMock(HttpCalloutMock.class, new LatencyHttpCalloutMock());

		//Execute the method
		Test.startTest();
		Latency.pingRemoteURL('http://forcelatencytester.herokuapp.com/');
		Test.stopTest();
	}

	//Class that creates a fake response for callouts during a test
	public class LatencyHttpCalloutMock implements HttpCalloutMock {
		public HTTPResponse respond(HTTPRequest req) {
			HttpResponse res = new HttpResponse();
			res.setBody('hi');
			return res;
		}
	}

}
