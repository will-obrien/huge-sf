public class SendEventEmailController {
    
	//variables to select statuses
    public Set<String> statuses = new Set<String>();
    public boolean registeredBox {get; set;}
    public boolean attendedBox {get; set;}
    public boolean cancelledBox {get; set;}
    public boolean noshowBox {get; set;}
    
    public List<Wrapper> memberList;
    Id eventid = System.currentPageReference().getParameters().get('eventid');
    Id clubEventId = System.currentPageReference().getParameters().get('clubEventId');
    
    //get running user information for email's From section
    Id userId = UserInfo.getUserId();
	User runningUser = [SELECT Id, Name, Email FROM User WHERE Id = :userId];
    
    //get Event Name to set the email source
    Campaign cmp = [SELECT Id, Event_Name__c FROM Campaign WHERE Id = :eventid];
    String source = 'you are registered for ' + cmp.Event_Name__c;
    
    //variables for page input fields
    public String subjLine {get; set;}
    public String image {get; set;}
    public String text1 {get; set;}
    public String text2 {get; set;}
    public String text3 {get; set;}
    public String close {get; set;}
    public String closeName {get; set;}
 
    //retrieve and display event registrants for id passed through url parameter
    public List<Wrapper> getMemberList() {
		if(memberList == null) {
	        List<Event_Registration__c> memList = [
	        	select
	        		Id,
                	First_Name__c,
                	Last_Name__c,
                	Email__c,
	        		Contact__c,
	        		Status__c
	        	from Event_Registration__c
	        	where 
	        		Campaign__c = :eventid
	        		and Email__c != null
                	and Status__c IN :statuses
	        		
	        	order by Status__c, Last_Name__c, First_Name__c
	        ];
	        memberList = new List<Wrapper>();
	        for(Event_Registration__c mem : memList) {
	        	Wrapper wrap = new Wrapper();
	        	wrap.id = mem.Id;
	        	wrap.firstName = mem.First_Name__c;
	        	wrap.lastName = mem.Last_Name__c;
                wrap.email = mem.Email__c;
                if (mem.Contact__c != null) {
                    wrap.contactId = mem.Contact__c;
                }
	        	wrap.status = mem.Status__c;
	        	wrap.isSelected = true;
	        	memberList.add(wrap);
	        }
		}

        if (memberList.size() > 0 && memberList.size() < 1001) {
            return memberList;
        }
        else if (memberList.size() > 1000) {
            addError('You cannot send email to more than 1,000 contacts at a time.');
            return null;
        }
        else {
            addError('No emailable contacts found.');
            return null;
        }        
    }

    private void setStatuses() {
        if (registeredBox == true) {
            statuses.add('Registered');
        }
        if (attendedBox == true) {
            statuses.add('Attended');
        }
        if (cancelledBox == true) {
            statuses.add('Cancelled');
        }
        if (noshowBox == true) {
            statuses.add('No Show');
        }
    }
    
    private void processList() {
		List<Contact> contactList = new List<Contact>();
		for(Wrapper wrap : memberList) {
			if(wrap.isSelected) {
                Contact ct = new Contact(
                    Id = wrap.contactId,
                    FirstName = wrap.firstName,
                    LastName = wrap.lastName,
                    Email = wrap.email
                );              
				contactList.add(ct);
				wrap.isSelected = false;				
			}
	}
		if(!contactList.isEmpty()) {
            SendTriggeredEmail.sendemail(contactList, subjLine, image, text1, text2, text3, close, closeName, runningUser, source, 'event-comm');
            Email_Sent__c es = new Email_Sent__c(
            	Events_Campaign__c = cmp.Id,
                Subject_Line__c = subjLine,
                Image_Link__c = image,
                Paragraph_1__c = text1,
                Paragraph_2__c = text2,
                Paragraph_3__c = text3,
                Closing_Phrase__c = close,
                Closing_Name__c = closeName,
                Emails_Sent__c = contactList.size()
            );
            insert es;
		}

	}
     
    public PageReference next() {
        setStatuses();
        PageReference pageRef= new PageReference('/apex/SendEventEmail');
        pageRef.setRedirect(false); 
        return pageRef;
    }

    public PageReference preview() {
        PageReference pageRef= new PageReference('/apex/EventEmailPreview');
        if(clubEventId != null) {
	        pageRef.getParameters().put('clubEventId', clubEventId);
        }
        pageRef.setRedirect(false); 
        return pageRef;
    }
    
    public PageReference back() {
        PageReference pageRef= new PageReference('/apex/SendEventEmail');
        pageRef.setRedirect(false); 
        return pageRef;
    }
    
	public PageReference sendemail() {
		processList();
		String baseURL = System.URL.getSalesforceBaseUrl().toExternalForm();
		PageReference pageRef = new PageReference(baseURL + '/apex/SendEmailConfirmation' + '?id=' + eventid);
        if(clubEventId != null) {
	        pageRef.getParameters().put('clubEventId', clubEventId);
        }
		return pageRef;
	}

    public PageReference cancel() {
		String baseURL = System.URL.getSalesforceBaseUrl().toExternalForm();
		return new PageReference(baseURL + '/' + eventid);
	}
    
    	public Class Wrapper {
			public Id id {get; set;}
			public String firstName {get; set;}
			public String lastName {get; set;}
			public Id contactId {get; set;}
			public String status {get; set;}
        	public String email {get; set;}
			public Boolean isSelected {get; set;}
	}
    
    	private static void addError(String message) {
        ApexPages.addmessage(
        	new ApexPages.message(
        		ApexPages.severity.ERROR, message)
        	);
	}

}