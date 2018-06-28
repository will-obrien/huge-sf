public class ExactTargetSOAP {
    public static List<String> testLogin(){
        String xml = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:api="http://api.zuora.com/"><soapenv:Header><api:SessionHeader><api:session>GSQtBifPVspFabAr3aYXCj8BzzXTDoozIBosThC53M_jPeKhsBHcDBj_DZ9NM-NZA2mO1anhyT3vjG7UfGO8IRBD16xh3xVgLawk_oHQCFvIl5B9axr_rsomjdkoqG8ukV39IzzkV5tzP8aYmRUcQVVZk5Fe3sLyh1KYK4qLbQGOO1zETRmdaeIPse2JrzC6</api:session></api:SessionHeader><api:QueryOptions><api:caseSensitive>?</api:caseSensitive></api:QueryOptions></soapenv:Header><soapenv:Body><api:query><api:queryString>select StartingUnit, EndingUnit,Price from ProductRatePlanChargeTier where price =1.11</api:queryString></api:query></soapenv:Body>';
        makeRequestNow(xml);
        return null;
    }
 

 
 
    private static void makeRequestNow(String xml){
        Http h = new Http();
        Integer ContentLength = 0;
        ContentLength = xml.length();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndPoint('https://apisandbox.zuora.com/apps/services/a/48.0');
        req.setHeader('Content-type', 'text/xml');
        req.setHeader('Content-Length', ContentLength.format());
        req.setHeader('Connection', 'close');
        req.setBody(xml);
        req.setTimeout(120000);
        string bodyRes = '';
 

            HttpResponse res = h.send(req);
            bodyRes = res.getBody();

        System.debug('Soap request:' + xml);
        System.debug('Soap response:' + bodyRes);
 }

  }