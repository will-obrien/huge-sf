public class CalloutClass  {
	
	public static HttpResponse getInfoFromExternalService()
	{
		Http h = new Http();
		
		HttpRequest req = new HttpRequest();
		req.setEndPoint('http://api.salesforce.com/foo/bar');
		req.setMethod('GET');
		
		HttpResponse res = h.send(req);
		
		return res;
	}

}