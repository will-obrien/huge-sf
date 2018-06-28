public class SendListEmailController {
    
    public List<Wrapper> memberList;
    Id listid = System.currentPageReference().getParameters().get('listid');
    //get running user information for email's From section
    Id userId = UserInfo.getUserId();
	User runningUser = [SELECT Id, Name, Email FROM User WHERE Id = :userId];
    Campaign cmp = [SELECT Id, Name FROM Campaign WHERE Id = :listid];
    String source = cmp.Name;
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
        Id listid = System.currentPageReference().getParameters().get('listid');
        Id hhTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
		if(memberList == null) {
	        List<CampaignMember> memList = [
	        	select
	        		Id,
	        		Contact.FirstName,
	        		Contact.LastName,
                	Contact.Email,
	        		ContactId
	        	from CampaignMember
	        	where 
	        		CampaignId = :listid
	        		and Contact.Email != null
                	and Contact.rC_Bios__Deceased__c = false
                	and Contact.RecordTypeId = :hhTypeId
                	and ContactId NOT IN 
                	(SELECT rC_Bios__Contact__c FROM rC_Bios__Preference__c WHERE (rC_Bios__Subcategory__c = 'No Email' OR rC_Bios__Subcategory__c = 'No Lists Campaign Email') AND rC_Bios__Active__c = true)
	        		
	        	order by Contact.LastName, Contact.FirstName
	        ];
	        memberList = new List<Wrapper>();
	        for(CampaignMember mem : memList) {
	        	Wrapper wrap = new Wrapper();
	        	wrap.id = mem.Id;
	        	wrap.firstName = mem.Contact.FirstName;
	        	wrap.lastName = mem.Contact.LastName;
                wrap.email = mem.Contact.Email;
	        	wrap.contactId = mem.ContactId;
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
            SendTriggeredEmail.sendemail(contactList, subjLine, image, text1, text2, text3, close, closeName, runningUser, source, 'list-email');
            Email_Sent__c es = new Email_Sent__c(
            	Lists_Campaign__c = cmp.id,
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
        PageReference pageRef= new PageReference('/apex/ListEmailPreview');
        pageRef.setRedirect(false); 
        return pageRef;
    }
    
    public PageReference back() {
        PageReference pageRef= new PageReference('/apex/SendListEmail');
        pageRef.setRedirect(false); 
        return pageRef;
    }  
    
	public PageReference sendemail() {
		processList();
		String baseURL = System.URL.getSalesforceBaseUrl().toExternalForm();
		return new PageReference(baseURL + '/apex/SendEmailConfirmation' + '?id=' + listid);
	}

    public PageReference cancel() {
		String baseURL = System.URL.getSalesforceBaseUrl().toExternalForm();
		return new PageReference(baseURL + '/' + listid);

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