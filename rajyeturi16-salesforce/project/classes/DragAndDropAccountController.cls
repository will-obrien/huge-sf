/* Developed by : Subrat Poudyal
Client: Cognizant
Application: Drag and Drop Functionality
*/


public class DragAndDropAccountController {
    public String ContactName{get;set;}
     public   String AccountName{get;set;}
    
    public  static contact c{get;set;}
    public  static account a{get;set;}
    public List<account> acc{get{   acc=[select id,name from account];
                                return acc;}set;
    }
    public List<contact> con{get{ con=[select id,name,accountid,account.name from contact where name=:ContactName limit 1]
        ;
                                return con;}set;
                                
                           }
      public List<contact> contact1{get{ contact1=[select id,name from contact ]
        ;
                                return contact1;}set;
                                
                           }
    
    public  List<account> account1{get;set;}
     

       public  void ContactSearch(){
     //  AccountName=inputval;
        String accn='%'+AccountName+'%';
        system.debug('account'+accn);
         account1=[select id,name from account where name like :accn];
      
    }
    
    
    @RemoteAction
    public static string UpdateCOntact(String accName){
       
       system.debug('-->details'+accName);
        
        string s =  accName.trim();
       string []details=s.split(',');
        
        system.debug('-->details'+details);
        for(integer i=0;i<details.size();i++){
             string AccID =  details[1].trim();
             Id det=id.valueof(AccID);
             a =[select id from account where id=:det ];
             c = [select id,accountid, name from contact where name=:details[2] limit 1];   
               c.Accountid=a.id;
              
        }
       
            system.debug('-->aa'+a);
          
        update c;
        
        return 'successfully changed accountid of'+c.Name;
        
    }
    
     
}