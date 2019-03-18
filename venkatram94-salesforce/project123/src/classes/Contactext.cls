public class Contactext {
public Contact con{get;set;}
    public Contactext(ApexPages.StandardController controller) {
     con=(Contact)controller.getRecord();
     
    }
    public PageReference saveandnew(){
    insert con;
    PageReference pref=new PageReference('/apex/ContactVF');
    return pref;
    }
    }