public class getservice2
{
    public String myresponse{get;set;}
    public Pagereference getResult()
    {
        HttpRequest req = new HttpRequest();
        Http http = new Http();   
        req.setHeader('Authorization','Bearer '+UserInfo.getSessionId());          
        req.setMethod('GET');
        String url = 'https://developer-kuhinoor-developer-edition.ap1.force.com/services/apexrest/lightingprefix/Getservice';
        req.setEndpoint(url);
        HTTPResponse resp = http.send(req);
        myresponse=resp.getBody();
        return null;   
    }
}