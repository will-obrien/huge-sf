@isTest
private class Test_CitrixWebinar {

	private static testMethod void unitTest(){
		
		CitrixWebinarJSONHandler handler = new CitrixWebinarJSONHandler();
		
		
		list<CitrixWebinarTimes> webinarTimes = new list<CitrixWebinarTimes>();
		CitrixWebinarTimes webinarTime = new CitrixWebinarTimes();
		webinarTime.startTime = '2011-04-26T17:00:00Z';
		webinarTime.endTime = '2011-04-26T18:00:00Z';
		webinarTimes.add(webinarTime);
		
		list<CitrixWebinar> webinars = new list<CitrixWebinar>();
		for(integer x = 0; x < 200; x++){
			CitrixWebinar webinar = new CitrixWebinar();
			webinar.subject = 'Test Webinar';
			webinar.description = 'This is a test webinar';
			webinar.timeZone = 'America/New_York';
			webinar.webinarKey = String.valueOf(x);
			webinar.organizerKey = '12345';
			webinar.times = webinarTimes;
			webinars.add(webinar);
		}
		
		handler.webinars = webinars;
		
	}

}