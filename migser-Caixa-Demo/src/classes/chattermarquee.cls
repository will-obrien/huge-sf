public class chattermarquee{
    public CollaborationGroup myalertgroup {get;set;}
    
    public chattermarquee(){
		myalertgroup=[SELECT Id,Name FROM CollaborationGroup where Name='Chatter Marquee Alerts' limit 1];
    }
}