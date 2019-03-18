global class Batch_AttendanceEmailSync implements database.Batchable<SObject>,Database.Stateful{
    
    global final String Query;
    global list<Webinar_Attendance__c> Allattendances;
    global list<et4ae5__IndividualEmailResult__c> AllemailResults;
    global DateTime twoDaysAgo;
    
	global Batch_AttendanceEmailSync(){
    	this.twoDaysAgo = DateTime.now().addDays(-2);    
        this.Query = 'Select id,CreatedDate, ET_Job_ID__c,IER_et4ae5_SendDefinition__c, Lead_Contact_ID__c,Individual_Email_Result_Linked__c,Individual_Email_Result_Link_Attempt__c FROM Webinar_Attendance__c Where ET_Job_ID__c != NULL AND Lead_Contact_ID__c != NULL AND Individual_Email_Result_Link_Attempt__c = NULL AND CreatedDate >= :twoDaysAgo ORDER BY CreatedDate DESC';
        this.Allattendances = new list<Webinar_Attendance__c>();
        this.AllemailResults = new list<et4ae5__IndividualEmailResult__c>();
   	}

   	global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   	}

   	global void execute(Database.BatchableContext BC,List<Webinar_Attendance__c> attendances){
        set<String> jobIds = new set<String>();
        set<String> leadContactIds = new set<String>();
        map<String,Webinar_Attendance__c> attendanceMap = new map<String,Webinar_Attendance__c>();
        for(Webinar_Attendance__c attendance : attendances){
            String jobId = String.valueOf(Integer.valueOf(attendance.ET_Job_ID__c));
            jobIds.add(jobId);
            leadContactIds.add(attendance.Lead_Contact_ID__c);
            String uniqueId = attendance.Lead_Contact_ID__c + ':' + jobId;
            system.debug('WA: ' + uniqueId);
            attendanceMap.put(uniqueId,attendance);
        }
        
        List <et4ae5__IndividualEmailResult__c> IER = 
            [SELECT et4ae5__Clicked__c, et4ae5__Contact__c, CreatedById, CreatedDate,
             CurrencyIsoCode, et4ae5__DateBounced__c, LEAD_CONTACT_ID__c, et4ae5__Lead__c,
             et4ae5__MergeId__c,et4ae5__NumberOfTotalClicks__c, et4ae5__NumberOfUniqueClicks__c,
             et4ae5__Opened__c, OwnerId, Id, Webinar_Attendance_linked__c,et4ae5__SendDefinition__r.et4ae5__JobId__c,et4ae5__SendDefinition__C
             FROM et4ae5__IndividualEmailResult__c Where LEAD_CONTACT_ID__c IN :leadContactIds AND et4ae5__SendDefinition__r.et4ae5__JobId__c IN :jobIds];

        for(et4ae5__IndividualEmailResult__c emailResult : IER){
            String uniqueId = emailResult.LEAD_CONTACT_ID__c + ':' + emailResult.et4ae5__SendDefinition__r.et4ae5__JobId__c;
            system.debug('ER: ' + uniqueId);
            Webinar_Attendance__c relatedAttendance = attendanceMap.get(uniqueId);
            if(relatedAttendance != null){
            	relatedAttendance.Individual_Email_Result_Link_Attempt__c = System.now();
            	relatedAttendance.Individual_Email_Result_Linked__c = emailResult.id;
                relatedAttendance.IER_et4ae5_SendDefinition__c = emailResult.et4ae5__SendDefinition__C;
            	emailResult.Webinar_Attendance_linked__c = relatedAttendance.id;
            }
        }
        
        for(Webinar_Attendance__c attendance : attendances){
            if(attendance.Individual_Email_Result_Linked__c == null && DateTime.Now() > attendance.CreatedDate.addHours(24)){
                attendance.Individual_Email_Result_Link_Attempt__c = System.now();
            }
        }
    	Database.update(attendances);
        Database.update(IER);
    }

   	global void finish(Database.BatchableContext BC){

   	}

}