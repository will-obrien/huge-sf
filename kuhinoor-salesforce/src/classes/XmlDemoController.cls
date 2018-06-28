public class XmlDemoController{
    String xml = '<contacts>' +
                    '<contact>' +
                        '<firstname>kuhinoor</firstname>' +
                        '<lastname>alam</lastname>' +
                        '<email>akuhinoor@yahoo.com.com</email>' +
                    '</contact>' +
                    '<contact>' +
                        '<firstname>Rohan</firstname>' +
                        '<lastname>singh</lastname>' +
                        '<email>singh.rohan@xml.com</email>' +
                    '</contact>' +
                '</contacts>';
    private xmldom theXMLDom;
    public list<contactModel> contactModels{get;set;}
    //Constructor
    public XmlDemoController(){
        contactModels = new List<contactModel>();
        
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
                }else if(elmInnerChild.nodeName.toLowerCase() =='email'){
                    cm.email = elmInnerChild.nodeValue;
                }
            }
            contactModels.add(cm);
        }
    }
    public class ContactModel{
        public String firstname{get;set;}
        public String lastname{get;set;}
        public String email {get;set;}
        /*public ContactModel(String name , String phone , String email){
            this.name = name ;
            this.phone = phone ;
            this.email = email;
        }*/
    }
}