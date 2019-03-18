public class Latency {

	@RemoteAction
	public static Decimal pingRemoteURL(String url){

		//Instantiate http object
		Http h = new Http();

		//Construct a basic GET request to the provided URL
		HttpRequest req = new HttpRequest();
		req.setEndpoint(url);
		req.setMethod('GET');

		//Create store the time
		Decimal startTime = system.now().getTime();

		// Send the request, and return a response
		HttpResponse res = h.send(req);

		//Log time after http get is complete
		Decimal stopTime = system.now().getTime();

		//Return the duration of the Http request
		return stopTime - startTime;
	}

}