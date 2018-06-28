public class XmlCallApiController{
    private xmldom theXMLDom;
    public list<contactModel> contactModels{get;set;}
    //Constructor
    public XmlCallApiController(){
        contactModels = new List<contactModel>();
        HttpRequest req = new HttpRequest();
       // req.setEndpoint('http://developer-kuhinoor-developer-edition.ap1.force.com');
       req.setEndpoint('http://developer-ajaysikhwal-developer-edition.ap1.force.com/xmlLink');
        req.setMethod('GET');
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        String xml = res.getBody();
        theXMLDom = new  xmldom(xml);
        parse();
    }
    public void parse(){
        List<xmldom.Element> elementStructList = theXMLDom.getElementsByTagName('contact');
        for(xmldom.Element element : elementStructList){
            ContactModel cm = new ContactModel();
            for(xmldom.Element elmInnerChild: element.childNodes){
                if(elmInnerChild.nodeName.toLowerCase() =='firstname'){
                    cm.firstname= elmInnerChild.nodeValue;
                }else if(elmInnerChild.nodeName.toLowerCase() =='lastname'){
                    cm.lastname= elmInnerChild.nodeValue;
                }else if(elmInnerChild.nodeName.toLowerCase() =='website'){
                    cm.website= elmInnerChild.nodeValue;
                }
            }
            contactModels.add(cm);
        }
    }
    public class ContactModel{
        public String firstname{get;set;}
          public String lastname{get;set;}
        public String phone{get;set;}
        public String website{get;set;}
        /*public ContactModel(String name , String phone , String email){
            this.name = name ;
            this.phone = phone ;
            this.email = email;
        }*/
    }
}