public class Product_ProgramController {
@AuraEnabled
    public static List<Contact> getContacts() {
    return [Select Id, 
                   Name, 
                   Email, 
                   Title, 
                   Phone 
                   From Contact LIMIT 5];
 }
    
     
    private static Decimal GetPrice(String productCode) {
        String url = 'http://www.grupolanka.com/Salesforce/ErpApiService/api/Product?id=' + productCode;
 
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        HttpResponse res = h.send(req);
         
        return Decimal.valueOf(res.getBody());
    }
}