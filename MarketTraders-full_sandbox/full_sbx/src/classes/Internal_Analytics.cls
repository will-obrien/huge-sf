public class Internal_Analytics{
    
    public Wrapper_Webinar selectedWebinarWrapper {get;set;}
	    
    /**
     * Constructor
     */
    public Internal_Analytics() {

    }
    
    public list<Wrapper_Webinar> getWebinarList(){
        list<Webinar__c> webinars = [
            SELECT
            	Id,
            	Name
            FROM
            	Webinar__c
            WHERE 
            	Number_of_Attendance_Records__c > 0 AND 
            	Webinar_Type__c = 'UTP OnDemand' AND 
				Platform__c = 'Citrix' 
        ];
        map<Id,Wrapper_Webinar> webinarWrapperMap = new map<Id,Wrapper_Webinar>();
        for(Webinar__c webinar :  webinars){
            webinarWrapperMap.put(webinar.Id,new Wrapper_Webinar(webinar));
        }

        list<Webinar_Attendance__c> relatedWebinarAttendance = [
        	SELECT
            	Id,
            	Webinar__c,
            	Attended__c
           	FROM
            	Webinar_Attendance__c
            WHERE
            	Webinar__c IN :webinarWrapperMap.keySet()
        ];
        
        for(Webinar_Attendance__c attendance : relatedWebinarAttendance){
            Wrapper_Webinar wrapper = webinarWrapperMap.get(attendance.Webinar__c);
            if(attendance.Attended__c){
                wrapper.attended++;
            }else{
                wrapper.notAttended++;
            }
        }
        return webinarWrapperMap.values();
    }

}