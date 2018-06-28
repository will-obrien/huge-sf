public class Handler_IndividualEmailResult Extends Handler{
	
	private list<et4ae5__IndividualEmailResult__c> newList;
	private map<Id,et4ae5__IndividualEmailResult__c> newMap;
	private list<et4ae5__IndividualEmailResult__c> oldList;
	private map<Id,et4ae5__IndividualEmailResult__c> oldMap;
	
	public static boolean BEFOREFIRED = false;
	public static boolean AFTERFIRED = false;
	
	public Handler_IndividualEmailResult(){
		
	}
	
	public Handler_IndividualEmailResult(String typeOfHandler) {
    	handlerType = typeOfHandler;
    }
	
	public override void mainEntry(String triggerObject,
		Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate,
		Boolean isDelete, Boolean isUndelete, Boolean isExecuting, list<SObject> newList,
		map<Id,SObject> newMap, list<SObject> oldList, map<Id,SObject> oldMap) {
			system.debug('In Progress Entry: ' + triggerObject);
			try{
				this.newList = (list<et4ae5__IndividualEmailResult__c>)newList;
				this.newMap = (map<Id,et4ae5__IndividualEmailResult__c>)newMap;
				this.oldList = (list<et4ae5__IndividualEmailResult__c>)oldList;
				this.oldMap = (map<Id,et4ae5__IndividualEmailResult__c>)oldMap;
				
				if(isBefore && Handler_IndividualEmailResult.BEFOREFIRED != true){
					Handler_IndividualEmailResult.BEFOREFIRED = true;
				}else if(isAfter && Handler_IndividualEmailResult.AFTERFIRED != true){
					if(isInsert || isUpdate){
						this.updateLeadOrAccount((list<et4ae5__IndividualEmailResult__c>)newList,(map<Id,et4ae5__IndividualEmailResult__c>)oldMap, isInsert);
					}
                    
                    /**
                     * The following code updates the Linked Webinar Attendance. In place to fire off a Webinar Attendance Workflow.
                     */
					if(isUpdate){
                        set<Id> linkedAttendanceIds = new set<Id>();
                        for(et4ae5__IndividualEmailResult__c emailResult : this.newList){
                            if(emailResult.Webinar_Attendance_linked__c != null)
                                linkedAttendanceIds.add(emailResult.Webinar_Attendance_linked__c);
                        }
                        if(!linkedAttendanceIds.isEmpty()){
                            list<Webinar_Attendance__c> linkedAttendance = [SELECT Id FROM Webinar_Attendance__c WHERE Id IN :linkedAttendanceIds];
                        	Database.update(linkedAttendance);
                        }
                    }
					Handler_IndividualEmailResult.AFTERFIRED = true;
				}
				
			}catch(Exception ex){
				Logger logger = new Logger('Individual Email Result Handler');
				logger.log(ex.getMessage());
				logger.log(ex.getStackTraceString());
				logger.emailDebugResults(new list<String>{'sfdev@markettraders.com'});
			}
            
            TriggerDispatcher.activeHandler = null;
            
	}
	
	public override void inProgressEntry(String triggerObject,
		Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate,
		Boolean isDelete, Boolean isUndelete, Boolean isExecuting, list<SObject> newList,
		map<Id,SObject> newMap, list<SObject> oldList, map<Id,SObject> oldMap){
			
	}
	
	private void updateLeadOrAccount(list<et4ae5__IndividualEmailResult__c> newList,map<Id,et4ae5__IndividualEmailResult__c> oldMap,boolean isInsert){
		try{
			map<Id,et4ae5__IndividualEmailResult__c> contactResultMap = new map<Id,et4ae5__IndividualEmailResult__c>();
			map<Id,et4ae5__IndividualEmailResult__c> leadResultMap = new map<Id,et4ae5__IndividualEmailResult__c>();
			
			for(et4ae5__IndividualEmailResult__c result : newList){
				if(result.et4ae5__Contact__c != null){
					contactResultMap.put(result.et4ae5__Contact__c,result);
				}
				if(result.et4ae5__Lead__c != null){
					leadResultMap.put(result.et4ae5__Lead__c,result);
				}
			}
			
			map<Id,Lead> leadMap = new map<Id,Lead>([SELECT id,Email_Marketing_Open_Date_Most_Recent__c,Email_Marketing_Click_Date_Most_Recent__c FROM Lead WHERE Id IN :leadResultMap.keySet() AND isConverted = false FOR UPDATE]);
			map<Id,Contact> contactMap = new map<Id,Contact>([SELECT id,Email_Marketing_Open_Date_Most_Recent__c,Email_Marketing_Click_Date_Most_Recent__c FROM Contact WHERE Id IN :contactResultMap.keySet() FOR UPDATE]);
		
			for(et4ae5__IndividualEmailResult__c result : newList){
				if(result.et4ae5__Contact__c != null){
					system.debug('Has Contact');
					Contact con = contactMap.get(result.et4ae5__Contact__c);
					if(result.et4ae5__DateOpened__c != null && (con.Email_Marketing_Open_Date_Most_Recent__c == null || con.Email_Marketing_Open_Date_Most_Recent__c < result.et4ae5__DateOpened__c.Date())){
						system.debug('Updating Contact Open Date');
						con.Email_Marketing_Open_Date_Most_Recent__c = result.et4ae5__DateOpened__c.Date();
					}
					if(isInsert && result.et4ae5__Clicked__c){
						con.Email_Marketing_Click_Date_Most_Recent__c = Date.today();
					}else{
						if(result.et4ae5__Clicked__c && !oldMap.get(result.Id).et4ae5__Clicked__c){
							con.Email_Marketing_Click_Date_Most_Recent__c = Date.today();
						}
					}
				}
				if(result.et4ae5__Lead__c != null){
					system.debug('Has Lead');
					Lead lead = leadMap.get(result.et4ae5__Lead__c);
					if(lead != null){
						if(result.et4ae5__DateOpened__c != null &&  (lead.Email_Marketing_Open_Date_Most_Recent__c == null || lead.Email_Marketing_Open_Date_Most_Recent__c < result.et4ae5__DateOpened__c.Date())){
							system.debug('Updating Lead Open Date');
							lead.Email_Marketing_Open_Date_Most_Recent__c = result.et4ae5__DateOpened__c.Date();
						}
						if(isInsert && result.et4ae5__Clicked__c){
							lead.Email_Marketing_Click_Date_Most_Recent__c = Date.today();
						}else{
							if(result.et4ae5__Clicked__c && !oldMap.get(result.Id).et4ae5__Clicked__c){
								lead.Email_Marketing_Click_Date_Most_Recent__c = Date.today();
							}
						}
					}
				}
			}
			
			if(!leadMap.isEmpty())
				Database.update(leadMap.values());
			
			if(!contactMap.isEmpty())
				Database.update(contactMap.values());
		}catch(Exception ex){
			Logger logger = new Logger('UpdateAccountOrLead');
			logger.log(ex.getMessage());
			logger.log(ex.getStackTraceString());
			logger.emailDebugResults(new list<String>{'sfdev@markettraders.com'});
		}
	}

}