public class fetchContactsController{
    public list<contact> contacts{get;set;}
        public fetchContactsController(){
          contacts=[select firstname,lastname from contact]; 
        }
}