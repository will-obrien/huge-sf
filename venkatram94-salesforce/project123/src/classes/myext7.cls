public class myext7 {
public Player__c pla{get; set;}
    public myext7(ApexPages.StandardController controller) {
pla=(Player__c)controller.getrecord();
    }
public static List<Player__c> search(string a)
       {
       List<Player__c> aa= new List<Player__c>();
       aa= [select name from Player__c where Team__c=:a];
       return aa;
       }
        public pagereference go(){
    
    pagereference refer= new pagereference ('');
    return refer;
}
}