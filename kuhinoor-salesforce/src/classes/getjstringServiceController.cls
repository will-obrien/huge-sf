Public Class getjstringServiceController{
    Public String myresponse{get;set;}
    Public PageReference getresult(){
        Http ht = new Http();
        HttpRequest req= new HttpRequest();
        String url='https://developer-kuhinoor-developer-edition.ap1.force.com/services/apexrest/lightingprefix/getjString';
        req.setHeader('Authorization','Bearer'+UserInfo.getSessionId());
        req.setEndPoint(url);
        req.setMethod('GET');
        HttpResponse res = ht.send(req);
        myresponse = res.getBody();
        return null;
    }
}