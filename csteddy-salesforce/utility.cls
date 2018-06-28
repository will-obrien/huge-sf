public class utility {

public HttpResponse Callout(String endPoint,String body,String method,String urlparams){
/*
This low level method will callout to the specified endpoint with either 
parameters appended to the endpoint URL or the specified body.
*/
String url;
HttpRequest req = new HttpRequest();
req.setMethod(method);
req.setHeader('Content-Length','0');
if (urlparams != null) {
        url=endPoint+'?'+urlparams;   
    }
if (body!='') {
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setBody(body);
    }
        
req.setEndpoint(url);
req.setTimeout(20000);
Http http = new Http();
HTTPResponse res = http.send(req);

return res;
}
}
