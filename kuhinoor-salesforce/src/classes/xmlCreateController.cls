public class xmlCreateController{
    public list<contact> contacts{get;set;}
    
      public xmlCreateController(){
          contacts = [select firstname,lastname,email from contact];
      }
  
    
}