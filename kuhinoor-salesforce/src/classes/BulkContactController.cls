public class BulkContactController
{
    public list<Contact> con{get;set;}
    public list<Contact> newcon{get;set;}
    
   public BulkContactController()
    {      
       newcon =new list<Contact>();
        con=new list<Contact>();
        con.add(new contact()); 
        //addrow();  
        
    }
    public PageReference save()
    {
        for(contact c : con){
            if(c.lastname != null)
            {
              newcon.add(c);  
            }
        }
        insert newcon;
       PageReference p = new PageReference('/apex/BulkContactpage');
       p.setRedirect(true);
       return p; 
    }
    public void addrow()
    {
    
       con.add(new contact());
       
    }
    
}