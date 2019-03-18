public class checkEclipse {
	public list<contact> contacts{get;set;}
	public checkEclipse(){
	
		contacts = [select firstname from contact];
	}
}