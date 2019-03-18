public class multipleAttachmentController{
    public Attachment att{get;set;}
    public list<Attachment> attList{get;set;}
    public integer size{get;set;}
    public integer attSize{get;set;}
    public multipleAttachmentController(){
            attList = new list<Attachment>();  
            att = new Attachment(); 
            attSize = 0 ;            
    }
    public void attach(){     
      if(attSize+att.body.size() < 135000){
           if(att.body != null && att.name !=''){
             attList.add(att);
             size=attList.size(); 
             attSize  = attSize + att.body.size();             
        }  
       
      }else{
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'you cannot upload above 135 kb file'));
      }      
      att = new Attachment();                      
    }
    public void done(){
        Account acc = new Account(name='multiattach');
        insert acc;
        for(Attachment att : attList){
            att.parentid = acc.id;           
        }
        insert attList;
        attList.clear();
        attSize = 0;
    }
}