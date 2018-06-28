public class DatabseMethodController {
    
    public DatabseMethodController(){
       
    }
    
    public void insertUsingDatabaseinsertMethod(){
        Account acc = new Account();
        acc.name = 'testAccount';
        insert acc;
        
        
        List<contact> conlist = new List<Contact>();
        
        Contact con = new Contact();
        con.Lastname ='conlastname';
        con.Accountid = acc.id;
        conlist.add(con);
        
        Contact con1 = new Contact();
        con1.Lastname ='';
        con1.Accountid = acc.id;
        conlist.add(con1);
        
        Database.SaveResult[] sr = Database.insert(conlist,false); // Database methode insert record in list
        
        for(Database.SaveResult obj : sr){   
        
            //this condition executed when  record are successfully inserted  
            if(obj.isSuccess()){
                system.debug('successfully inserted'+obj.getId());
            }
            else{
            
                // this condition executed for failed record 
                for(Database.Error objerr : obj.getErrors()){
                    system.debug('Failed'+objerr.getMessage());                       
                }        
            }
        }        
    }  
    
    public void updateUsingDatabaseUpdateMethod(){
     List<Contact> conlist =  [SELECT id,lastname FROM contact WHERE lastName= 'conlastname'];
        system.debug('*************'+conlist.size());
        List<Contact> conUpdateLiactst = new   List<Contact>();
        for(Contact con : conlist ){
            system.debug('*********'+con.lastname);
            Contact conobj = new Contact();
            conobj.id =con.id;
            conobj.firstname = 'Suraj';
            conobj.lastname = con.lastname; 
            
            conUpdateLiactst.add(conobj);
        }
        
        Database.SaveResult[] srlist = Database.update(conUpdateLiactst,false); 
        for(Database.SaveResult sr : srlist){
            if(sr.isSuccess()){
                System.debug('Successfully insertes : '+ sr.getId());
            }
            else{
                for(Database.Error errobj : sr.getErrors()){
                    System.debug('Failed :'+ errobj.getMessage());
                }
            }
        }
        
    } 
}