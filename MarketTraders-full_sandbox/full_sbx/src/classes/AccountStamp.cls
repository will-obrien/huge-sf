public with sharing class AccountStamp implements Comparable {
	public String webinarId {get; set;}
	public Date attendanceDate {get; set;}
	public Time attendanceTime {get; set;}
	public DateTime joinTime {get; set;}
	public String webinarSourceOther {get; set;}
	public Integer duration {get; set;}
	public Integer sessions {get; set;}
	public String presenter {get; set;}
	public Boolean isFirst {get; set;}
	public String creditName {get; set;}
	public String creditId {get; set;}
	public Boolean attended {get; set;}
	public String stampType {get; set;}
	public String status {get; set;}
	public String sendNumber {get; set;}
	
	
	/**
	*	constructor
	*/
	public AccountStamp() {}
	
	/**
	*	Comparable interface method(s) -- sorts ascending by webinar attendance date (earliest to latest)
	*/
	public Integer compareTo(Object compareTo) {
		AccountStamp compareToStamp = (AccountStamp)compareTo;
		if (attendanceDate == compareToStamp.attendanceDate) {
			if (attendanceTime == compareToStamp.attendanceTime) {
				return 0;
			}
			
			if (attendanceTime > compareToStamp.attendanceTime) {
				return 1;
			}
		}
		
		if (attendanceDate > compareToStamp.attendanceDate) {
			return 1;
		}
		
		return -1;
	}
}