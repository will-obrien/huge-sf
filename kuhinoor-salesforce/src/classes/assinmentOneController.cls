public class assinmentOneController{
    public list<contact> contacts{get;set;}
    public list<contact> insertcontacts{get;set;}
    public integer rowNum{get;set;}
    
    public assinmentOneController(){
    insertcontacts = new list<contact>();
        contacts= new list<contact>();
        contacts.add(new contact());
    }
    //adding row.........................
    public void addrow(){
        contacts.add(new contact());
    }
    
    //save record code here...............
    
    public PageReference save(){
    id urlid=apexpages.currentpage().getparameters().get('id');
    system.debug('urlid------------->'+urlid);
    
  
    
        for(contact c : contacts){
         c.accountid= urlid;
            if(c.lastname !=null){
                insertcontacts.add(c);
            }
         
        }
        insert insertcontacts;
       return new pageReference('/apex/assinmentOne');
    }
    
    //delete code here..................
    public void del(){
        rowNum = Integer.valueOf(ApexPages.currentPage().getParameters().get('index'));
       contacts.remove(rowNum);    
    }
}