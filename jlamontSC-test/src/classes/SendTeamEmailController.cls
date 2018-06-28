public class SendTeamEmailController {
    
    public List<Wrapper> memberList;
    Id entid = System.currentPageReference().getParameters().get('entityid');
    //get running user information for email's From section
    Id userId = UserInfo.getUserId();
	User runningUser = [SELECT Id, Name, Email FROM User WHERE Id = :userId];
    //get Entity/Team name to set the email source
    Club_Entity__c ent = [SELECT Id, Name FROM Club_Entity__c WHERE Id = :entid];
    String source = 'of your involvement with ' + ent.Name;
    //variables for page input fields
    public String subjLine {get; set;}
    public String image {get; set;}
    public String text1 {get; set;}
    public String text2 {get; set;}
    public String text3 {get; set;}
    public String close {get; set;}
    public String closeName {get; set;}
    
    //retrieve and display leadership/team members for club_entity__c id passed through url parameter
    public List<Wrapper> getMemberList() {
        Id entid = System.currentPageReference().getParameters().get('entityid');
		if(memberList == null) {
	        List<Leadership__c> memList = [
	        	select
	        		Id,
	        		Contact__r.FirstName,
	        		Contact__r.LastName,
                	Contact__r.Email,
	        		Contact__c,
	        		Position_Status__c
	        	from Leadership__c
	        	where 
	        		Club_Entity__c = :entid
                	and Position_Status__c not in ('Inactive', 'Declined')
	        		and Contact__r.Email != null
                	and Contact__r.rC_Bios__Deceased__c = false
	        		
	        	order by Position_Status__c, Contact__r.LastName, Contact__r.FirstName
	        ];
	        memberList = new List<Wrapper>();
	        for(Leadership__c mem : memList) {
	        	Wrapper wrap = new Wrapper();
	        	wrap.id = mem.Id;
	        	wrap.firstName = mem.Contact__r.FirstName;
	        	wrap.lastName = mem.Contact__r.LastName;
                wrap.email = mem.Contact__r.Email;
	        	wrap.contactId = mem.Contact__c;
	        	wrap.status = mem.Position_Status__c;
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
    
    	private void processList() {
		List<Contact> contactList = new List<Contact>();
		for(Wrapper wrap : memberList) {
			if(wrap.isSelected) {
                Id ctId = wrap.contactId;
                Contact ct = [SELECT Id, FirstName, Email FROM Contact Where Id = :ctId];
				contactList.add(ct);
				wrap.isSelected = false;				
			}
		}
		if(!contactList.isEmpty()) {
            SendTriggeredEmail.sendemail(contactList, subjLine, image, text1, text2, text3, close, closeName, runningUser, source, 'team-comm');
            Email_Sent__c es = new Email_Sent__c(
            	Club_Entity_Team__c = ent.Id,
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

    public PageReference preview() {
        PageReference pageRef= new PageReference('/apex/TeamEmailPreview');
        pageRef.setRedirect(false); 
        return pageRef;
    }
  
    public PageReference back() {
        PageReference pageRef= new PageReference('/apex/SendTeamEmail');
        pageRef.setRedirect(false); 
        return pageRef;
    } 
    
	public PageReference sendemail() {
		processList();
		String baseURL = System.URL.getSalesforceBaseUrl().toExternalForm();
		//return new PageReference(baseURL + '/' + entid);
		return new PageReference(baseURL + '/apex/SendEmailConfirmation' + '?id=' + entid);
	}

    public PageReference cancel() {
		String baseURL = System.URL.getSalesforceBaseUrl().toExternalForm();
		return new PageReference(baseURL + '/' + entid);

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