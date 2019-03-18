public class getstrservice2
{
    public List<contact> conlist{get;set;} 
    public String myresponse{get;set;}
    Public String conname{get;set;}
    public Pagereference getResult()   
    
    {
        HttpRequest req = new HttpRequest();
        Http http = new Http();   
        req.setHeader('Authorization','Bearer '+UserInfo.getSessionId());          
        req.setMethod('GET');
        String url = 'https://developer-kuhinoor-developer-edition.ap1.force.com/services/apexrest/lightingprefix/Getjstrservice';
        req.setEndpoint(url);
        HTTPResponse resp = http.send(req);
        myresponse=resp.getBody();
        return null;   
    }
    Public Void display(){
              System.debug('********************');  
            conlist  = new List<Contact>(); 
            JSONParser parser = JSON.createParser(myresponse);
             System.debug('********************'+parser.nextToken()+'------>>'+ parser.getText());
             while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && parser.getText()=='LastName') {
                    //String fieldName = parser.getText();
                      parser.nextToken();                      
                      Contact c = new Contact();                    
                      c.lastname= parser.getText();  
                      conlist.add(c);  
                      System.debug('********************'+conlist.size());                 
                     }
            }
        if(conlist.size()>0){
            insert conlist;
        } else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'List has no record'));
        }
   }   
}