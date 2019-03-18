public class UpdateMultipleContactController{
    public list<model> modelLst{get;set;}
    public list<contact> conlst;
    public Integer value{get;set;}
    private Integer no;
    
    //CONSTRUCTOR
    public UpdateMultipleContactController(){   
    no = 0;
    modelLst = new list<model>();
       for(contact c :  [SELECT id,lastname,firstName, Email FROM contact LIMIT 500 ]){
           no++;           
           model md = new Model();
           md.sno = no;
           md.ischeck = false;
           md.id = c.id;
           md.lastname = c.lastname;
           md.firstname = c.firstname;
           md.email = c.email;   
           modelLst.add(md);        
       }
    }
    
    //EDIT MULTIPLE  ROW
    public void edit(){
       for(model md : modelLst){
           if(value == md.sno ){
               md.isCheck = true;
           }
       }
    }
    
    //UPDATE MULTIPLE CONATCT 
    public void upadte(){           
      conlst = new list<contact>();   
        for(model  md : modelLst){         
            if(md.isCheck){     
                md.isCheck = false;       
                contact con  = new contact();
                con.id = md.id;
                con.lastname = md.lastname;
                con.firstname = md.firstname;
                con.email = md.email;
                conlst.add(con);
            }    
        }
         UPDATE  conlst;  
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Successfully updated.'));
    }
    
    //WRAPPER CLASS
    public class model{
        public Integer sno{get;set;}
        public Boolean isCheck{get;set;}
        public String lastname{get;set;}
        public String firstname{get;set;}
        public String email{get;set;}
        public String id{get;set;}
    }
}