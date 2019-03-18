public class aggregateQueryController{
    public list<modelClass> contacts{get;set;}
    public aggregateQueryController(){
    contacts =new  list<modelClass> ();
      list<aggregateresult> aggre = [ select count(id) conCount from contact];
      for(aggregateresult a : aggre)
      {
          modelClass obj=new modelclass();
          obj.contactCount=(integer)a.get('conCount');
         contacts.add(obj);
      }  
    }
    public class modelClass{
      public integer contactCount{get;set;}
    }
}