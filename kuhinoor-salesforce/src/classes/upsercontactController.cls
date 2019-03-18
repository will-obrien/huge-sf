public class upsercontactController
{
    public Contact con{get;set;}
    public upsercontactController()
    
    {
      con=new Contact();  
      String conid=Apexpages.currentPage().getParameters().get('id');
      if(conid!=null)
      con=[select firstname,lastname from Contact where id=:conid];
    }
    public pageReference save()
    {
        upsert con;
        return new pageReference ('/'+con.id);
    }
}