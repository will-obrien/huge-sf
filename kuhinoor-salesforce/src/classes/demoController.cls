public class demoController{
    public list<contact> con{get;set;}
    public list<contact> contacts{get;set;}
    public demoController(){
        con = new list<contact>();
        contacts = new list<contact>();
        con.add(new contact());
    }
        public pageReference save(){
              
              for(contact c : con){
                   if(c.lastname == null){
                       contacts.add(c);
                       c.lastname.addError('field is reqiuered');
                   }   
                      
              }
              insert contacts;
             return null;   
        }
        public pageReference addrow(){
            con.add(new contact());
            return null;
        }
        public void removerow(){
            con.remove((con.size()-1));
        }
    }