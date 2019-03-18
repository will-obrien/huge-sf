public class modelDemoController
{
    public List<contactmodelclass> models{get;set;}
    public String lastname{get;set;}
    public String email{get;set;}
    public void name()
    {
    }
    public modelDemoController()
    {
        
        models = new  list<contactmodelclass>();
        integer i=1;
        for(contact con : [select firstname,lastname,email from contact])
        {
            contactmodelclass md = new contactmodelclass();
            md.sno = i;
            md.contacts = con;
            i++;
            models.add(md);
            
            
        }
    }
    public class contactmodelclass
    {
        public integer sno{get;set;}
        public contact contacts{get;set;}
    }
}