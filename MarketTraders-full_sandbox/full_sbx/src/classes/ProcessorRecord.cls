global with sharing class ProcessorRecord {
	
	public String firstName {get;set;}
	public String lastName {get;set;}
	public String email {get;set;}
	public String phone {get;set;}
	public String attended {get;set;}
	public integer interestRating {get;set;}
	public DateTime registrationDate {get;set;}
	public DateTime joinTime {get;set;}
	public DateTime leaveTime {get;set;}
	public integer numberOfSessions {get;set;}
	public decimal inSessionDuration {get;set;}
	public String unsubscribed {get;set;}
		
	public ProcessorRecord(){
		
	}

}