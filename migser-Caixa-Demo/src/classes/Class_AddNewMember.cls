public class Class_AddNewMember {
    
    public Campaign__c camp {get;set;}
    public Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
    public String MemberType {get;set;}
    public String MemberStatus {get;set;}
    public String fieldVal1 {get;set;}
    public String fieldVal2 {get;set;}
    public String operatorVal1 {get;set;}
    public String operatorVal2 {get;set;}
    public String value1 {get;set;}
    public String value2 {get;set;}
    public Boolean showContactTable {get;set;}
    public Boolean showLeadTable {get;set;}
    public Boolean showError {get;set;}
    public List<SelectOption> options {get;set;}
    public List<ContactWrapper> conList = new List<ContactWrapper>();
    public List<LeadWrapper> leadList = new List<LeadWrapper>();
    public List<Contact> selectedContacts = new List<Contact>();
    public List<Lead> selectedLeads = new List<Lead>();
    
    public Class_AddNewMember(ApexPages.StandardController controller) {
        camp = (Campaign__c)controller.getRecord();
        camp = [	select Id, Name from Campaign__c where Id = :camp.Id	];
        
        showContactTable = false;
        showLeadTable = false;
        showError = false;  
        MemberType = 'Lead';
        fetchFields();
    }
    
    
    
    //  public List<SelectOption> getFields() {
    public void fetchFields() {
        system.debug('---inside fields--');
        system.debug('--member type--'+MemberType);   
        
        //String type = 'Contact';
        options = new List<SelectOption>();
        
        //Creating sObject for dynamic selected object  
        
        Schema.SObjectType systemObjectType = gd.get(MemberType);  
        
        //Fetching field results  
        Schema.DescribeSObjectResult r= systemObjectType.getDescribe();  
        
        Map<String, Schema.SObjectField> M = r.fields.getMap();  
        
        //Creating picklist of fields
        options.add(new SelectOption('','--None--'));
        for(Schema.SObjectField fieldAPI : M.values())  
        {  
            options.add(new SelectOption(fieldAPI.getDescribe().getName(), fieldAPI.getDescribe().getLabel()));  
        }  
        // return options;    
    }
    
    public List<ContactWrapper> getContacts() {
        
        String SOQLquery = 'select Id,Name,AccountId,Title,Phone,Email from	Contact where ';
        
        if(operatorVal1 == 'equals'){
            SOQLquery += fieldVal1 + ' = \'' + value1 + '\'';
            if(operatorVal2 != null)
                SOQLquery += ' AND ';
        }
        else if(operatorVal1 == 'not equal to')  {
            SOQLquery += fieldVal1 + ' != \'' + value1 + '\'';
            if(operatorVal2 != null)
                SOQLquery += ' AND ';
        }
        else if(operatorVal1 == 'starts with') {
            SOQLquery += fieldVal1 + ' like \'' + value1 + '%\'';
            if(operatorVal2 != null)
                SOQLquery += ' AND '; 
        }
        else if(operatorVal1 == 'contains') {
            SOQLquery += fieldVal1 + ' like \'%' + value1 + '%\'';
            if(operatorVal2 != null)
                SOQLquery += ' AND ';
        }
        else {
            SOQLquery = 'select Id,Name,AccountId,Title,Phone,Email from Contact where ';
        }
        
        if(operatorVal2 != null) {
            
            if(operatorVal2 == 'equals')
                SOQLquery += fieldVal2 + ' = \'' + value2 + '\'';
            else if(operatorVal2 == 'not equal to')  
                SOQLquery += fieldVal2 + ' != \'' + value2 + '\'';
            else if(operatorVal2 == 'starts with') 
                SOQLquery += fieldVal2 + ' like \'' + value2 + '%\'';
            else if(operatorVal2 == 'contains') 
                SOQLquery += fieldVal2 + ' like \'%' + value2 + '%\'';
        }
        
        system.debug('--------query----'+SOQLquery);
        
        conList.clear();
        
        if (Database.query(SOQLquery).size() > 0 && MemberType == 'Contact') {
            for(Contact c : Database.query(SOQLquery))
                conList.add(new ContactWrapper(c, false));
            showError = false;
            showContactTable = true;
            return conList;
        }
        
        else {
            showContactTable = false;
            showError = true;
            return null;
        } 
    }
    
    public List<Contact> getSelectedContacts()
    {
        if(selectedContacts.size()>0)
            return selectedContacts;
        else
            return null;
    }    
    
    
    public List<LeadWrapper> getLeads() {
        
        String SOQLquery = 'select Id,Name,Company,Title,Phone,Email from Lead where ';
        
        if(operatorVal1 == 'equals'){
            SOQLquery += fieldVal1 + ' = \'' + value1 + '\'';
            if(operatorVal2 != null)
                SOQLquery += ' AND ';
        }
        else if(operatorVal1 == 'not equal to')  {
            SOQLquery += fieldVal1 + ' != \'' + value1 + '\'';
            if(operatorVal2 != null)
                SOQLquery += ' AND ';
        }
        else if(operatorVal1 == 'starts with') {
            SOQLquery += fieldVal1 + ' like \'' + value1 + '%\'';
            if(operatorVal2 != null)
                SOQLquery += ' AND '; 
        }
        else if(operatorVal1 == 'contains') {
            SOQLquery += fieldVal1 + ' like \'%' + value1 + '%\'';
            if(operatorVal2 != null)
                SOQLquery += ' AND ';
        }
        else {
            SOQLquery = 'select Id,Name,Company,Title,Phone,Email from Lead where ';
        }
        
        if(operatorVal2 != null) {
            
            if(operatorVal2 == 'equals')
                SOQLquery += fieldVal2 + ' = \'' + value2 + '\'';
            else if(operatorVal2 == 'not equal to')  
                SOQLquery += fieldVal2 + ' != \'' + value2 + '\'';
            else if(operatorVal2 == 'starts with') 
                SOQLquery += fieldVal2 + ' like \'' + value2 + '%\'';
            else if(operatorVal2 == 'contains') 
                SOQLquery += fieldVal2 + ' like \'%' + value2 + '%\'';
        }
        
        system.debug('--------query----'+SOQLquery);
        
        leadList.clear();    
        
        if (Database.query(SOQLquery).size() > 0 && MemberType == 'Lead') {
            for(Lead l : Database.query(SOQLquery))
                leadList.add(new LeadWrapper(l, false));
            showError = false;
            showLeadTable = true;
            return leadList;
        }
        
        else {
            showLeadTable = false;
            showError = true;
            return null;
        } 
    }
    
    public List<Lead> getSelectedLeads()
    {
        if(selectedLeads.size()>0)
            return selectedLeads;
        else
            return null;
    }    
    
    
    public PageReference getSelected()
    {
        selectedContacts.clear();
        for(ContactWrapper conwrapper : conList)
            if(conwrapper.selected == true)
            selectedContacts.add(conwrapper.con);
        
        selectedLeads.clear();
        for(LeadWrapper leawrapper : leadList)
            if(leawrapper.selected == true)
            selectedLeads.add(leawrapper.lea);
        
        return null;
    }
    
    
    public class ContactWrapper
    {
        public Contact con {get; set;}
        public Boolean selected {get; set;}
        public ContactWrapper(Contact c, Boolean flag)
        {
            con = c;
            selected = flag;
        }
    }
    
    public class LeadWrapper
    {
        public Lead lea {get; set;}
        public Boolean selected {get; set;}
        public LeadWrapper(Lead l, Boolean flag)
        {
            lea = l;
            selected = flag;
        }
    }
    
    public PageReference addNewMembers() {
        if(MemberType == 'Contact') {
            List<Campaign_Member__c> newMembers = new List<Campaign_Member__c>();
            for(Contact selectedContact : selectedContacts) {
                Campaign_Member__c newMember = new Campaign_Member__c(Campaigns__c = camp.Id,
                                                                      Contact__c = selectedContact.Id,
                                                                      Member_Name__c = selectedContact.Name,
                                                                      Phone__c = selectedContact.Phone,
                                                                      Email__c = selectedContact.Email,
                                                                      Title__c = selectedContact.Title,
                                                                      Status__c = MemberStatus,
                                                                      Type__c = 'Contact');
                newMembers.add(newMember);
            }
            upsert newMembers;
        }
        
        if(MemberType == 'Lead') {
            List<Campaign_Member__c> newMembers = new List<Campaign_Member__c>();
            for(Lead selectedLead : selectedLeads) {
                Campaign_Member__c newMember = new Campaign_Member__c(Campaigns__c = camp.Id,
                                                                      Lead__c = selectedLead.Id,
                                                                      Member_Name__c = selectedLead.Name,
                                                                      Phone__c = selectedLead.Phone,
                                                                      Email__c = selectedLead.Email,
                                                                      Title__c = selectedLead.Title,
                                                                      Status__c = MemberStatus,
                                                                      Type__c = 'Lead');
                newMembers.add(newMember);
            }
            upsert newMembers;
        }
        
        PageReference nextPage = new PageReference('/' + camp.Id);
        nextPage.setRedirect(True);
        return nextPage;
    }
    
    public PageReference fetchMembers() {
        if(MemberType == 'Contact')
            getContacts();
        if(MemberType == 'Lead')
            getLeads();
        return null;
    } 
}

/*
*/