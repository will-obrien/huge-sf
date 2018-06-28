public class myext9 {
public Player__c player {get;set;}
    public myext9(ApexPages.StandardController controller) {
    player=(Player__c)Controller.getrecord();

    }
    public pagereference Save(){
    insert player;
    pagereference refer= new pagereference ('/apex/view_players');
    return refer;
    }

}