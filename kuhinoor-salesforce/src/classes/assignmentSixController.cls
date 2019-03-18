public class assignmentSixController{
    private xmldom theXMLDom;
    public list<contactModel> contactModels{get;set;}
    public map<String,contactmodel> xmlcontacts{get;set;}
    public list<contact> addcontact{get;set;}
    public map<String,contact> conmail{get;set;}
    //Constructor
    public assignmentSixController(){
        xmlcontacts = new map<String,contactmodel>();
        conmail = new map<String,contact>();
        addcontact = new list<contact>();
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
                }else if(elmInnerChild.nodeName.toLowerCase() =='phone'){
                    cm.phone= elmInnerChild.nodeValue;
                }
                else if(elmInnerChild.nodeName.toLowerCase() =='email'){
                    cm.email= elmInnerChild.nodeValue;
                }
                else if(elmInnerChild.nodeName.toLowerCase() =='account'){
                    cm.account= elmInnerChild.nodeValue;
                }
            }
            
            
            
            
            contactModels.add(cm);
            xmlcontacts.put(cm.email,cm);
          for(contact c : [select email from contact]){
              conmail.put(c.email,c);
          }
               for(String s : xmlcontacts.keyset()){
                   if(s != null){
                       if(conmail.get(s) == null){
                           contact obj = new contact();
                           contactmodel cmod = xmlcontacts.get(s); 
                           obj.firstname = cmod.firstname;
                           obj.lastname = cmod.lastname;
                           obj.email = cmod.email;
                           addcontact.add(obj);
                     }  
                  }
                  else{
                      contact cc = conmail.get(s);
                      contactmodel cmod = xmlcontacts.get(s);
                      cc.firstname = cmod.firstname;
                      cc.lastname = cmod.lastname;
                      cc.email = cmod.email;
                      addcontact.add(cc);
                  }    
               }
              
               
   }
 }   
    public void upsertcon(){
    
         upsert addcontact;
        
    }
    
    public class ContactModel{
        public String firstname{get;set;}
          public String lastname{get;set;}
        public String phone{get;set;}
        public String website{get;set;}
        public String email{get;set;}
        public String account{get;set;}
        /*public ContactModel(String name , String phone , String email){
            this.name = name ;
            this.phone = phone ;
            this.email = email;
        }*/
    }
}