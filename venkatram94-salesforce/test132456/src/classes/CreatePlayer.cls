public class CreatePlayer {

    public Player__c CreatePlayer {get;set;}
    public Player__c pt;
    
    public CreatePlayer(ApexPages.StandardController controller) {
        pt=(Player__c)Controller.getrecord();
    }
    
    public pagereference Save(){
        insert pt;
        pagereference refer= new pagereference ('/apex/detailVF');
        return refer;
    }
    
    public pagereference Cancel(){
        return null;
    }
}