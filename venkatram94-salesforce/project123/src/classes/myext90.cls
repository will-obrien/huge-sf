public class myext90 {
 public Player__c pla {get;set;}
    public myext90(ApexPages.StandardController controller) {
pla=(Player__c)Controller.getrecord();
    }
        public pagereference go(){
    
    pagereference refer= new pagereference ('/apex/player_list');
    return refer;
}
}