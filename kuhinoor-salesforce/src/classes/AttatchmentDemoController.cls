public class AttatchmentDemoController{
    public contact con{get;set;}
    public Attachment att{get;set;}
        public AttatchmentDemoController(){
            con=new Contact();
            att = new Attachment();
        }
        public pageReference save(){
            insert con;
            att.parentId=con.id;
            insert att;
            return new pageReference('/'+con.id);
        }
}