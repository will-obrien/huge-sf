public class autocompleteContrller{
    public list<contact> contacts{get;set;}
    public list<contact> contacts2{get;set;}
    public String json{get;set;}
    public autocompleteContrller(){
    contacts2 = new list<contact>();
    contacts2.add(new contact());
        json='';
        json+='[';
        String coma='';
        for(contact obj : [select lastname from contact limit 10]){
        if(obj.lastname !=null){
        json+=coma+'\''+obj.lastname+'\'';
        coma=',';
        }
       }
       json+=']'; 
    } 
   
}