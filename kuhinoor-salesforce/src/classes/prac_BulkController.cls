public class prac_BulkController{
    public list<Contact> con{get;set;}
    public list<contact> newcon{get;set;}
    public prac_BulkController(){
        con = new list<Contact>();
        newcon = new list<Contact>();
        con.add(new contact());
    
    }
    public pageReference save(){
        for(Contact val : con)
        {    
            if(val.lastname!=null)
            {
                newcon.add(val);
            }
        }
        
        insert newcon;
        return new pageReference ('/apex/prac_Bulkpage');
    }
     public void addrow(){
       con.add(new contact());
       
    }
    
}