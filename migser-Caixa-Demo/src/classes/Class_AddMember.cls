public class Class_AddMember {
    
    public Campaign__c camp {get;set;}
    public Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
    public String fieldVal1 {get;set;}
    public String fieldVal2 {get;set;}
    public String operatorVal1 {get;set;}
    public String operatorVal2 {get;set;}
    public String value1 {get;set;}
    public String value2 {get;set;}
    public Boolean showTable {get;set;}
    public Boolean showError {get;set;}
    
    List<ContactWrapper> conList = new List<ContactWrapper>();
    List<Contact> selectedContacts = new List<Contact>();
    
    public Class_AddMember(ApexPages.StandardController controller) {
        camp = (Campaign__c)controller.getRecord();
        camp = [	select Id, Name from Campaign__c where Id = :camp.Id	];
        
        //camp = [	select Id, Name from Campaign__c where Id = 'a0837000001EWxaAAG'	];
        
        showTable = false;
        showError = false;        
    }
    
    public list<selectoption> getFields() {
        String type='Contact';
        List<SelectOption> options = new List<SelectOption>();
        
        //Creating sObject for dynamic selected object  
        Schema.SObjectType systemObjectType = gd.get(type);  
        
        //Fetching field results  
        Schema.DescribeSObjectResult r= systemObjectType.getDescribe();  
        
        Map<String, Schema.SObjectField> M = r.fields.getMap();  
        
        //Creating picklist of fields
        options.add(new SelectOption('','--None--'));
        for(Schema.SObjectField fieldAPI : M.values())  
        {  
            options.add(new SelectOption(fieldAPI.getDescribe().getName(), fieldAPI.getDescribe().getLabel()));  
        }  
        return options;        
    }
    
    public List<SelectOption> getOperators() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        options.add(new SelectOption('equals','equals'));
        options.add(new SelectOption('not equal to','not equal to'));
        options.add(new SelectOption('starts with','starts with'));
        options.add(new SelectOption('contains','contains'));
        return options;        
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
/*
            else {
                SOQLquery = 'select Id,Name,AccountId,Title,Phone,Email from Contact';
            }
*/ 
        }
        
        system.debug('--------query----'+SOQLquery);
                
        conList.clear();
        if (Database.query(SOQLquery).size() > 0) {
            for(Contact c : Database.query(SOQLquery))
                conList.add(new ContactWrapper(c, false));
            showError = false;
            showTable = true;
			return conList;
        }
        else {
            showTable = false;
            showError = true;
            return null;
        }            
    }
    
    public PageReference getSelected()
    {
        selectedContacts.clear();
        for(ContactWrapper conwrapper : conList)
            if(conwrapper.selected == true)
            selectedContacts.add(conwrapper.con);
        return null;
    }
    
    public List<Contact> GetSelectedContacts()
    {
        if(selectedContacts.size()>0)
            return selectedContacts;
        else
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
    
    public PageReference addNewMembers() {
        List<Campaign_Member__c> newMembers = new List<Campaign_Member__c>();
        for(Contact selectedContact : selectedContacts) {
            Campaign_Member__c newMember = new Campaign_Member__c(Campaigns__c = camp.Id, Contact__c = selectedContact.Id, Status__c='Nominated');
            newMembers.add(newMember);
        }
        upsert newMembers;
        
        PageReference nextPage = new PageReference('/' + camp.Id);
        nextPage.setRedirect(True);
        return nextPage;
    }
    
    public PageReference fetchContacts() {
        getContacts();
        return null;
    }
    
}