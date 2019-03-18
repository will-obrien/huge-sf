public class contactcomponent{
list<contact> condeatils{get;set;}
public list<contact> searchcon{get;set;}
    public String name{get;set;}
    public contact con{get;set;}
        public contactcomponent(){
            con=new contact();
        }
        public pagereference save(){
            insert con;
            
            return new pagereference('/apex/ContactComponent');
        }
        public list<contact> getcontacts(){
         
        if(name==null)
         condeatils  =[select firstname,lastname from contact];
          
            return condeatils;
        }
        public void search(){
        String query = 'select firstname,lastname from contact where firstname=:name';
        condeatils=database.query(query);
          
        }
}