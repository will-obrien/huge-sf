public with sharing class CitrixWebinar {
	
	public String webinarKey {get;set;}
	public String subject {get;set;}
	public String description {get;set;}
	public String organizerKey {get;set;}
	public list<CitrixWebinarTimes> times {get;set;}
	public String timeZone {get;set;}
	
	public CitrixWebinar(){
		
	}

}