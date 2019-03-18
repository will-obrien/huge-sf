public class assignmentThiredController{
    public list<Contact> contacts{get;set;}
    public list<ModelClass> conlist{get;set;}
    public String imageid{get;set;}
    public String uid{get;set;}
    public String firstname{get;set;}
    public String lastname{get;set;}
    public String phone{get;set;}
    public String email{get;set;}
    public Attachment att{get;set;}
    public list<String> aatid{get;set;}
     public list<Attachment> newidea{get;set;}
    public  String aat{get;set;}
    public String image{get;set;}
    public assignmentThiredController(){
       att= new Attachment();
       conlist = new list<ModelClass>();
        contacts = [select firstname,lastname,phone,email,(select id from Attachments) from contact ];
         for(contact c :contacts){
             for(Attachment a : c.Attachments){
                 ModelClass md = new ModelClass();
                 md.con= c;
                 md.att=a;
                 conlist.add(md);
             }
         
         }
    }
    public pageReference save(){
        
        contact c = new contact();
        System.debug('############################'+uid);
        c.id=uid;
        c.firstname = firstname;
        c.lastname = lastname;
        c.phone = phone;
        c.email = email;
        upsert c;
         
      
        
     /*  contacts.add(c);
         upsert contacts;*/
          if( att.name!=null){
        att.parentId = c.id;
      
           insert att;
       }
          
        
        return new pageReference ('/apex/assignmentThired');
    }
        public class ModelClass{
            public contact con{get;set;}
            public Attachment att{get;set;}
        
        }
}