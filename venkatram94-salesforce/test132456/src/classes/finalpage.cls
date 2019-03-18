public class finalpage {
 public Player__c finalpage {get;set;}
 public Player__c a;
public finalpage (ApexPages.StandardController controller) {
        a=(Player__c)Controller.getrecord();
    }
     public static List<Player__c> search(string a)
     {
       List<Player__c> aa= new List<Player__c>();
       aa= [select name from Player__c where Team__c=:a];
       return aa;
    }
    
    public pagereference go(){
    
        pagereference refer= new pagereference ('/a0U/o');
        return refer;
    }
}