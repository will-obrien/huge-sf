public without sharing class LeaderNewUserController {
    Static Id campfirePermissionId { get; }
    Static Id addUpProfileId { get; }
    Static {
     campfirePermissionId = [SELECT Id FROM PermissionSet WHERE Name = 'Campfire'].Id;
     addUpProfileId = [SELECT Id FROM profile WHERE name='AddUp User'].Id;
    }
    public String emailAddr { get; set; }
    public Id chosenContactId { get; set; }
    public boolean userCreated { get; set; }
    public boolean userAlreadyCreated { get; set; }
    public boolean standardUserAlreadyCreated { get; set; }
    public String errorMessage { get; set; }
    public List<Constituent> constituentList { get; set; }
    public Map<Id, Constituent> constituentMap { get; set; }
    public Integer constituentListSize { get; set; }
    
    public LeaderNewUserController() {
        constituentListSize = 0;
    }
    
    public PageReference getContactsWithEmail() {
        constituentList = null;
        chosenContactId = null;
        userAlreadyCreated = false;
        standardUserAlreadyCreated = false;
        constituentList = null;
        constituentListSize = 0;

        User usr;
        User[] usrs = [select Id, ProfileId, ContactId, UserType, LastLoginDate from User where Username = :emailAddr];
        if(usrs.size() > 0) {
            usr = usrs[0];
        }
        if(usr != null) {
            if(usr.ProfileId == addUpProfileId) {
            	if(hasCampfirePermissionSet(usr)) {
	                userAlreadyCreated = true;
	                return null;
            	}
            	else {
		            PermissionSetAssignment psa = new PermissionSetAssignment(
		            	PermissionSetId = campfirePermissionId,
		            	AssigneeId = usr.Id
		            );
		            insert psa;
            	}
            }
            else {
                if(usr.UserType == 'Standard') {
                    standardUserAlreadyCreated = true;
                    return null;                    
                }
            }
            if(usr.LastLoginDate == null) {
		        return new PageReference( '/CampfireNewUserWelcome');
            }
            return new PageReference( '/CampfireWelcome');
        }       
        List<Contact>contactList = new List<Contact>([
            select Id, FirstName, MailingPostalCode from Contact where Email = :emailAddr
        ]);
        
        constituentList = new List<Constituent>();
        constituentMap = new Map<Id, Constituent>();
        List<Id>contactIdList = new List<Id>();
        Integer sequenceNo = 0;
        for(Contact cntct : contactList) {
            Constituent con = new Constituent(++sequenceNo, cntct.Id, cntct.FirstName, cntct.MailingPostalCode);
            constituentList.add(con);
            constituentMap.put(con.Id, con);
            contactIdList.add(con.Id);
        }
        constituentListSize = constituentList.size();
        
        if(constituentListSize == 1) {
        	Id ctId = contactIdList.get(0);
        	Constituent chosenConstituent = constituentMap.get(ctId);
        	chosenContactId = chosenConstituent.Id;
        	chosenConstituent.sequenceNo = null;
        	return null; 
        }
        
        List<Leadership__c> ldrList = new List<Leadership__c>([
            select Contact__c from Leadership__c
            where Contact__c in :contactIdList
        ]);
        List<Constituent>consLeaderList = new List<Constituent>();
        for(Leadership__c ldr : ldrList) {
            Constituent cons = constituentMap.get(ldr.Contact__c);
            if(cons != null) {
                if( ! cons.isLeader) {
                    cons.isLeader = true;
                    consLeaderList.add(cons);
                }
            }
        }
        if(consLeaderList.size() == 1) {
            constituentList.clear();
            constituentListSize = 1;
            Constituent chosenConstituent = consLeaderList.get(0);
            chosenContactId = chosenConstituent.Id;
            chosenConstituent.sequenceNo = null;
            return null;
        }
        else if(consLeaderList.size() > 1) {
            constituentList = consLeaderList;
            Integer seq = 0;
            for(Constituent cons : constituentList) {
                cons.sequenceNo = ++seq;
            }
            constituentListSize = consLeaderList.size();
        } 
        
        return null;
    }
    public PageReference createNewLeaderUser() {
        User usr = insertNewUser();
        return new PageReference( '/CampfireNewUserWelcome');
    }
    public PageReference chooseContact() {
        return null;
    }
    public Constituent getChosenConstituent() {
        if(chosenContactId == null) {
            return null;
        }
        return constituentMap.get(chosenContactId);
    }
    private Boolean hasCampfirePermissionSet(User usr) {
    	List<PermissionSetAssignment> permsList = [
    		select Id from PermissionSetAssignment
    		where PermissionSetId = :campfirePermissionId
    		and AssigneeId = :usr.Id 
    	];
    	return permsList.size() > 0;
    }
    private User insertNewUser() {
        Contact chosenContact = 
            [select Id, FirstName, LastName, Email from Contact where Id = :chosenContactId];
        String FirstName = chosenContact.FirstName;
        String LastName = chosenContact.LastName;
        String Email = chosenContact.Email;
        
        string aliasText = '';
            if(FirstName != null && FirstName != '' && Lastname.length()>1){
                    aliasText = FirstName.substring(0,1);
            }
            if(Lastname != null && Lastname != '' && Lastname.length()>2){
                aliasText += Lastname.substring(0,3);
            }
            else{
                aliasText +=Lastname;
            }
        String myNickName = '';
        If (Email.length() > 40) {
          myNickName = Email.substring(0, 40);
        } else {
          myNickName = Email;
        }
        User usr = new User(firstName = FirstName,
                                    lastName = LastName,
                                    Email = Email,
                                    CommunityNickname = myNickName,
                                    languagelocalekey = 'en_US',
                                    localesidkey = UserInfo.getLocale(),
                                    emailEncodingKey = 'UTF-8',
                                    timeZoneSidKey = 'America/Los_Angeles', 
                                    profileId = addUpProfileId,
                                    userName = Email,
                                    ContactId = chosenContact.Id,
                                    alias = aliasText );
            Savepoint spUsr = Database.setSavepoint();
            try {            
              insert usr;
              userCreated = true;
            }catch(Exception ex){
              errorMessage = ex.getMessage();
              userCreated = false;
              if (ex.getMessage().contains('DUPLICATE_USERNAME') ){
                errorMessage='Error Creating user: User name already used';
              }
            }
            system.debug('NewUser>>> '+ usr);
            
            PermissionSetAssignment psa = new PermissionSetAssignment(
            	PermissionSetId = campfirePermissionId,
            	AssigneeId = usr.Id
            );
            insert psa;
            
            new AssignLeaderPermissions().assignPermissions(new List<Id>{chosenContact.id});
            
            return usr;
    }
    public Class Constituent {
        public Integer sequenceNo { get; set; }
        public Id id { get; set; }
        public String firstName { get; set; }
        public String postalCode { get; set; }
        public boolean isLeader { get; set; }
        public Constituent(Integer sequenceNo, Id id, String firstName, String postalCode) {
            this.sequenceNo = sequenceNo;
            this.id = id;
            this.firstName = firstName;
            this.postalCode = postalCode;
            this.isLeader = false;
        }
    }
}