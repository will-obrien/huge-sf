public with sharing class EventCampaignExtension {
    private static Id eventsTypeId;
    static {
        eventsTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Events').getRecordTypeId();
    }
    private ApexPages.StandardController stdCtl;
    public List<EventLeader> leaderList;
    public Integer selectedRow;
    public List<Event_Leader__c> leadersToDelete;
    private Id clonedFromId;
    
	public EventCampaignExtension(ApexPages.StandardController stdCtl) {
		this.stdCtl = stdCtl;
		Campaign camp = (Campaign)stdCtl.getRecord();
		String clone = ApexPages.currentPage().getParameters().get('clone');
		if(clone == null) {
			clonedFromId = null;
		}
		else {
			clonedFromId = camp.Id;
			camp.Id = null;
			camp.Name = null;
			camp.Club_Event__c = null;
			camp.URL_to_Share__c = null;
			camp.Attended_Count__c = 0;
			camp.Cancelled_Count__c = 0;
			camp.Event_Registration_Count__c = 0;
			camp.NoShow_Count__c = 0;
		}
		
		if(camp.RecordTypeId == null) {
			camp.RecordTypeId = eventsTypeId;
		}
	}
	public Campaign getCamp() {
		return (Campaign)stdCtl.getRecord();
	}
    public String getDtBegin() {
    	Campaign camp = getCamp();
    	if(camp.Start_Date__c == null) {
    		return '';
    	}
    	String theDate = camp.Start_Date__c.format() + ' ' + camp.Start_Time__c;
    	return theDate;
    }
    public void setDtBegin(String input) {
    	Campaign camp = getCamp();
        if(String.isEmpty(input)) {
            camp.Start_Date__c = null;
        }
        else {
	        DateTime dt = DateTime.parse(input);
	        camp.Start_Date__c = dt.date();
	        camp.Start_Time__c = extractTime(dt);
        }
    }
    public String getDtEnd() {
    	Campaign camp = getCamp();
    	if(camp.End_Date__c == null) {
    		return '';
    	}
    	String theDate = camp.End_Date__c.format() + ' ' + camp.End_Time__c;
        return theDate; 
    }
    public void setDtEnd(String input) {
    	Campaign camp = getCamp();
        if(String.isEmpty(input)) {
            camp.End_Date__c = null;
        }
        else {
	        DateTime dt = DateTime.parse(input);
	        camp.End_Date__c = dt.date();
	        camp.End_Time__c = extractTime(dt);
        }    
    }
	private String extractTime(DateTime dt) {
	    String[] parts = dt.format().split(' ');
	    return parts[1] + ' ' + parts[2];
	}
	public PageReference saveAndReturn() {
		if(saveCampaign()) {
			//String retURL = ApexPages.currentPage().getParameters().get('retURL');
			//if(retURL == null) {
			//	retURL = '/' + getCamp().Id;
			//}
			String retURL = '/' + getCamp().Id;
			PageReference pageRef = new PageReference(retURL);
			pageRef.setRedirect(true);
			return pageRef;
		}
		return null;
	}
	public PageReference saveAndNew() {
		if(saveCampaign()) {
			PageReference pageRef = new PageReference('/apex/EventCampaignEntry');
			pageRef.getParameters().put('RecordType', ((String)eventsTypeId).substring(0,15));
			pageRef.setRedirect(true);
			return pageRef;
		}
		return null;
	}
	public PageReference cancel() {
		String retURL = ApexPages.currentPage().getParameters().get('retURL');
		if(retURL == null) {
			retURL = ApexPages.currentPage().getParameters().get('cancelURL');
		}
		if(retURL == null) {
			retURL = '/701/o';
		}
		return new PageReference(retURL);
	}
	
	public Boolean saveCampaign() {
		Boolean hasPrimaryLeader = false;
		Event_Leader__c primaryLeader = null;
		Boolean hasErrors = false;
		Id clubEventId;

        Campaign camp = getCamp();
		
		if(camp.Start_Date__c == null) {
			camp.addError('Start Date is Required');
			hasErrors = true;
		}
        for(EventLeader el : getLeaderList()) {
        	if(el.isPopulated()) {
	            Event_Leader__c ldr = el.Leader;
	            ldr.Leader_Name__c = el.displayName;
	            if(ldr.Is_Primary_Leader__c) {
	                primaryLeader = ldr;
	            }
	            if(String.isEmpty(ldr.Leader_Name__c)) {
	                ldr.addError('All Leaders Must have a Name');
	                hasErrors = true;
	            }
	            if(String.isEmpty(ldr.Phone_or_Other_Contact_Information__c) && String.isEmpty(ldr.Email__c)) {
	                ldr.addError('All Leaders must have Contact Information or Email Address');
	                hasErrors = true;
	            }
	            if( ! String.isEmpty(ldr.Email__c)) {
		            if( ! isValidEmail(ldr.Email__c)) {
		            	ldr.addError('Invalid email address: ' + ldr.Email__c);
		            	hasErrors = true;
		            }
	            }
        	}
        }
		if(camp.Status__c == 'Active') {
 			if( primaryLeader == null) {
				camp.addError('To be made Active, an Event must have a Primary Leader');
            	hasErrors = true;
			}
			else {
				if(camp.Send_RSVP_to_Leader__c) {
					if(String.isEmpty(primaryLeader.Email__c)) {
						camp.addError('To Send RSVP notifications, you must specify Email of Primary Leader');
		            	hasErrors = true;
					}
				}
			}
		}
		if(hasErrors) {
			return false;
		}
		if(camp.Events_Category__c == 'Outing') {
			camp.Waiver_Required__c = true;
		}
		if(String.isEmpty(camp.Sponsor_Description__c)) {
			camp.Sponsor_Description__c = 'Sierra Club';
		}
		EventsCampaignTriggerHandler.checkLeaders = false;
		try {
        	upsert camp;
        	clubEventId = [select Club_Event__c from Campaign where Id = :camp.Id].Club_Event__c;
		}
		catch(DmlException e) {
			ApexPages.addMessages(e);
			return false;
		}
		catch(Exception e) {
			String errorMessage = e.getMessage();
            ApexPages.addmessage(
            	new ApexPages.message(
            		ApexPages.severity.ERROR,errorMessage)
            	);
			return false;
		}

        List<Event_Leader__c> leadersToUpdate = new List<Event_Leader__c>();
        for(EventLeader ldr : leaderList) {
        	if(ldr.isPopulated()) {
	            if(ldr.leader.Club_Event__c == null || ldr.leader.Campaign__c == null) {
		            if(ldr.leader.Campaign__c == null) {
		            	ldr.leader.Campaign__c = camp.Id;
		            }
		            if(ldr.leader.Club_Event__c == null) {
		            	ldr.leader.Club_Event__c = clubEventId;
		            }
	            }
	            leadersToUpdate.add(ldr.leader);
        	}
        }
		try {
			EventLeaderTriggerHandler.leadersChecked = true;
	        upsert leadersToUpdate;
	        if(leadersToDelete != null) {
	            if(leadersToDelete.size() > 0) {
	                delete leadersToDelete;
	            }
	        }
		}
		catch(DmlException e) {
			ApexPages.addMessages(e);
			return false;
		}
		catch(Exception e) {
			String errorMessage = e.getMessage();
            ApexPages.addmessage(
            	new ApexPages.message(
            		ApexPages.severity.ERROR,errorMessage)
            	);
			return false;
		}
		return true;
	}
	public PageReference addLeader() {
        List<EventLeader> ldrList = getLeaderList();
        Event_Leader__c ldr = new Event_Leader__c();
        if(ldrList.isEmpty()) {
        	ldr.Is_Primary_Leader__c = true;
        }
        ldrList.add(new EventLeader(ldr, '', ldrList.size()));
        return null;
	}
    public List<EventLeader> getLeaderList() {
    	Id eventId;
    	if(clonedFromId == null) {
    		eventId = getCamp().Id;
    	}
    	else {
    		eventId = clonedFromId;
    	}
        if(leaderList == null) {
            if(eventId == null) {
                leaderList = new List<EventLeader>();
                EventLeader newLdr = new EventLeader(new Event_Leader__c(Is_Primary_Leader__c = true), '', 0);
                leaderList.add(newLdr);
            }
            else {
                leaderList = new List<EventLeader>();
                List<Event_Leader__c> ldrList = new List<Event_Leader__c>([
                    select 
                    	Contact__c, 
                    	Contact__r.Name, 
                    	Phone_or_Other_Contact_Information__c, 
                    	Email__c, 
                    	Leader_Name__c, 
                    	Club_Event__c,
                    	Campaign__c, 
                    	Is_Primary_Leader__c
                    from Event_Leader__c
                    where Campaign__c = :eventId
                    order by Is_Primary_Leader__c desc, Contact__r.Name
                ]);
                if(ldrList.size() > 0) {
	                Integer row = 0;
	                for(Event_Leader__c ldr : ldrList) {
	                	if(clonedFromId != null) {
	                		ldr.Id = null;
	                		ldr.Campaign__c = null;
	                		ldr.Club_Event__c = null;
	                	}
	                    leaderList.add(new EventLeader(ldr, ldr.Leader_Name__c, row));
	                    row++;
	                }
                }
                else {
	                EventLeader newLdr = new EventLeader(new Event_Leader__c(Is_Primary_Leader__c = true), '', 0);
	                leaderList.add(newLdr);
                }
            }
        }
        return leaderList;
    }
	public void setSelectedRow(Integer row) {
		selectedRow = row;
	}
	public Integer getSelectedRow() {
		return selectedRow;
	}
    public PageReference adjustPrimaryLeader() {
        Event_Leader__c selectedLeader = getLeaderList().get(selectedRow).leader;
        if(selectedLeader.Is_Primary_Leader__c) {
            for(EventLeader ldr : getLeaderList()) {
                if(ldr.row != selectedRow) {
                    ldr.leader.Is_Primary_Leader__c = false;
                }
            }
        }
        return null;
    }
    public PageReference deleteLeader() {
    	Event_Leader__c leaderToDelete = leaderList.get(selectedRow).leader;
    	if(leaderToDelete.Id != null) {
	        if(leadersToDelete == null) {
	            leadersToDelete = new List<Event_Leader__c>();
	        }
	        leadersToDelete.add(leaderToDelete);
    	}
        leaderList.remove(selectedRow);
        Integer row = 0;
        for(EventLeader leader : leaderList) {
            leader.row = row;
            row++;
        }
        return null;
    }
    public PageReference fillLeaderInfo() {
    	EventLeader ldr = getLeaderList().get(selectedRow);
    	Id ctctId = ldr.leader.Contact__c;
    	Contact ctct = [
    		select Name, Email, Phone
    		from Contact
    		where Id = :ctctId
    	];
    	if(ctct != null) {
    		ldr.leader.Leader_Name__c = ctct.Name;
    		ldr.displayName = ctct.Name;
    		ldr.leader.Email__c = ctct.Email;
    		ldr.leader.Phone_or_Other_Contact_Information__c = ctct.Phone;
    	}
    	return null;
    }
    public class EventLeader {
        public Event_Leader__c leader { get; set; }
        public Integer row { get; set; }
        public String displayName { get; set; }
        public EventLeader(Event_Leader__c leader, String displayName, Integer row) {
            this.leader = leader;
            this.displayName = displayName;
            this.row = row;
        }
        public Boolean isPopulated() {
        	if(leader == null) {
        		return false;
        	}
			else {
				if(
					String.isEmpty(leader.Contact__c) &&
					String.isEmpty(leader.Email__c) &&
					String.isEmpty(leader.Leader_Name__c) &&
					String.isEmpty(leader.Phone_or_Other_Contact_Information__c) 
				) {
					return false;						
				}
			}
			return true;        	
        }         
    }
    private static Boolean isValidEmail(String email) {
		String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
		Pattern MyPattern = Pattern.compile(emailRegex);
		Matcher MyMatcher = MyPattern.matcher(email);
		return MyMatcher.matches();
	}
}