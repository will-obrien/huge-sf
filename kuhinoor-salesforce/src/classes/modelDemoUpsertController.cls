public class modelDemoUpsertController
{
    public List<contact> tempcontact; 
    public list<modelDemo> models{get;set;}
    public boolean ischeck{get;set;}
    public String uid{get;set;}
   
  public  modelDemoUpsertController()
  {
      tempcontact = new List<contact>();
      models=new list<modelDemo>();
      
      for(Contact  con :[select id,firstname,lastname,email from Contact])
      {
          modelDemo md = new modelDemo();
          md.contacts=con;
          md.isCheck=false;
          models.add(md);
          
      }
  }
  public void extra()
  {
  }
  public pagereference change() 
  {
      for(modeldemo m : models){
          if(m.isCheck == true){
              tempcontact.add(m.contacts);
          }
      }
      update tempcontact;
 // if(isCheck=true)
     /* if()
      {
         for(Contact c : models)
         {
             c.id();
             c.firstname();
             con.add(c);
         }
       }*/
       //String conId=apexpages.currentpage().getParameters().get('uid');
     // list<Contact> con=[select id,firstname,lastname from contact where id=:uid];
     // update con;
    return new pagereference('/apex/modeldemoupsert').setRedirect(true);
  }
        public class modelDemo
        {
            public Contact contacts{get;set;}
            public Boolean isCheck{get;set;}
        }
}