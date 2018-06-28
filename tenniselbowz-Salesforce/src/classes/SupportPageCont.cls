public with sharing class SupportPageCont {
        
    public string selectedID {get;set;}
    public string assetIdToRemove {get;set;}
    public string inputString {get;set;}
    public boolean multiSelectEnabled {get;set;}
    public Task newTask {get;set;}
    public Datetime durationStart {get;set;}
    
    public static Integer searchLimit {get{if(searchLimit == null) searchLimit = 20; return searchLimit;} set;}

    public CheckBoxWrapperList currentQueriedRecords {get; set;}
    public List<String> currentDisplayFields {get; set;}

    private boolean createdNewCase {get; set;}
    private final String DEFAULT_TASK_STATUS = 'In Progress';
    private final String INVALID_SELECTION_ERROR = 'Please select a case to continue';
    private final String MULTIPLE_SELECTION_ERROR = 'Please select only one record';
    private final String UNKNOWN_TYPE_ERROR = 'Type of Object selected is unrecognized';
    

    //--------------Proxy Objects ----------------//

    public Contact proxyContact {get;set;}

    public Asset proxyAsset {get;set;}
    public Case proxyCase {get;set;}
    
    public String proxyCasenumber {get;
        set{
            if(String.isBlank(value)) {
                proxyCasenumber = null;             
                return;
            }
            // Pads all case number inputs with zeros to get them 8 chars long
            String paddedStr = value;
            while(paddedStr.length() < 8){
                paddedStr = '0' + paddedStr;
            }
            proxyCasenumber = paddedStr;
        }
    }
    public string proxySONumber_Case {get;set;}
    
    
    public string proxySONumber_Asset {get;set;}
    public string proxyGONumber_Asset {get;set;}
    public string proxySerialNumber {get;set;}
    public string proxyFirstName {get;set{proxyFirstName = proxyContact.firstName = value;}}
    public string proxyLastName {get;set{proxyLastName = proxyContact.LastName = value;}}
    
    
    
    
    //--------------Field Sets ----------------//
    
    public List<Schema.FieldSetMember> contactFields { 
        get{
            if(contactFields == null) {
                contactFields = SObjectType.Contact.fieldsets.EditableSupportContactFields.getFields();
            } 
            return contactFields;
        } set;
    }
    
    public Set<String> contactFieldsToSearch { 
        get{
            if(contactFieldsToSearch == null) {
                contactFieldsToSearch = new Set<String>();
                if(contactFields != null) {
                    for(Schema.FieldSetMember member : contactFields){
                        contactFieldsToSearch.add(member.getFieldPath().toLowerCase());
                    }
                }
            }
            return contactFieldsToSearch;
        } set;
    }
    
    public List<Schema.FieldSetMember> contactDisplayFields { 
        get{
            if(contactDisplayFields == null) {
                contactDisplayFields = SObjectType.Contact.fieldsets.DisplaySupportContactFields.getFields();
            } 
            return contactDisplayFields;
        } set;
    }
    
    public List<String> contactFieldsToDisplay { 
        get{
            if(contactFieldsToDisplay == null) {
                contactFieldsToDisplay = new List<String>();
                if(contactDisplayFields != null) {
                    for(Schema.FieldSetMember member : contactDisplayFields){
                        contactFieldsToDisplay.add(member.getFieldPath().toLowerCase());
                    }
                }
            }
            return contactFieldsToDisplay;
        } set;
    }

    
    public List<Schema.FieldSetMember> contactUpsertFields { 
        get{
            if(contactUpsertFields == null) {
                contactUpsertFields = SObjectType.Contact.fieldsets.UpsertSupportContactFields.getFields();
            } 
            return contactUpsertFields;
        } set;
    }

    public Set<String> contactFieldsToUpsert {
        get{
            if(contactFieldsToUpsert == null) {
                contactFieldsToUpsert = new Set<String>();
                if(contactUpsertFields != null) {
                    for(Schema.FieldSetMember member : contactUpsertFields){
                        contactFieldsToUpsert.add(member.getFieldPath().toLowerCase());
                    }
                }
            }
            return contactFieldsToUpsert;
        } set;
    }
    
    
    public List<Schema.FieldSetMember> caseFields { 
        get{
            if(caseFields == null) {
                caseFields = SObjectType.Case.fieldsets.EditableSupportCaseFields.getFields();
            } 
            return caseFields;
        } set;
    }
    
    public Set<String> caseFieldsToSearch { 
        get{
            if(caseFieldsToSearch == null) {
                caseFieldsToSearch = new Set<String>{'casenumber'};
                if(caseFields != null) {
                    for(Schema.FieldSetMember member : caseFields){
                        caseFieldsToSearch.add(member.getFieldPath().toLowerCase());
                    }
                }
            }
            return caseFieldsToSearch;
        } set;
    }
    
    public List<Schema.FieldSetMember> caseDisplayFields { 
        get{
            if(caseDisplayFields == null) {
                caseDisplayFields = SObjectType.Case.fieldsets.DisplaySupportCaseFields.getFields();
            } 
            return caseDisplayFields;
        } set;
    }
    
    public List<String> caseFieldsToDisplay { 
        get{
            if(caseFieldsToDisplay == null) {
                caseFieldsToDisplay = new List<String>{'contactid'};
                if(caseDisplayFields != null) {
                    for(Schema.FieldSetMember member : caseDisplayFields){
                        caseFieldsToDisplay.add(member.getFieldPath().toLowerCase());
                    }
                }
            }
            return caseFieldsToDisplay;
        } set;
    }

    public List<Schema.FieldSetMember> caseUpsertFields { 
        get{
            if(caseUpsertFields == null) {
                caseUpsertFields = SObjectType.Case.fieldsets.UpsertSupportCaseFields.getFields();
            } 
            return caseUpsertFields;
        } set;
    }

    public Set<String> caseFieldsToUpsert {
        get{
            if(caseFieldsToUpsert == null) {
                caseFieldsToUpsert = new Set<String>();
                if(caseUpsertFields != null) {
                    for(Schema.FieldSetMember member : caseUpsertFields){
                        caseFieldsToUpsert.add(member.getFieldPath().toLowerCase());
                    }
                }
            }
            return caseFieldsToUpsert;
        } set;
    }
    
    public List<Schema.FieldSetMember> assetFields { 
        get{
            if(assetFields == null) {
                assetFields = SObjectType.Asset.fieldsets.EditableSupportAssetFields.getFields();
            } 
            return assetFields;
        } set;
    }
    
    public Set<String> assetFieldsToSearch { 
        get{
            if(assetFieldsToSearch == null) {
                assetFieldsToSearch = new Set<String>();
                if(assetFields != null) {
                    for(Schema.FieldSetMember member : assetFields){
                        assetFieldsToSearch.add(member.getFieldPath().toLowerCase());
                    }
                }
            }
            return assetFieldsToSearch;
        } set;
    }
    
    public List<Schema.FieldSetMember> assetDisplayFields { 
        get{
            if(assetDisplayFields == null) {
                assetDisplayFields = SObjectType.Asset.fieldsets.DisplaySupportAssetFields.getFields();
            } 
            return assetDisplayFields;
        } set;
    }
    
    public List<String> assetFieldsToDisplay { 
        get{
            if(assetFieldsToDisplay == null) {
                assetFieldsToDisplay = new List<String>{'id'};
                if(assetDisplayFields != null) {
                    for(Schema.FieldSetMember member : assetDisplayFields){
                        assetFieldsToDisplay.add(member.getFieldPath().toLowerCase());
                    }
                }
            }
            return assetFieldsToDisplay;
        } set;
    }
    
    public List<Schema.FieldSetMember> accountFields { 
        get{
            if(accountFields == null) {
                accountFields = SObjectType.Account.fieldsets.EditableSupportAccountFields.getFields();
            } 
            return accountFields;
        } set;
    }
    
    
    //--------------General Functions ----------------//

    public SupportPageCont(){
        durationStart = DateTime.now();
        newTask = new Task();
        proxyContact = new Contact();
        proxyAsset = new Asset();
        proxyCase = new Case();
        proxyFirstName ='';
        proxyLastName = '';
        editableAccount = new Account();
        selectedAssets = new List<Asset>();
        
        multiSelectEnabled = false;
        createdNewCase = false;
        clearEditableObjects();
        assetsQueried = new CheckboxWrapperList([Select id from Asset limit 1]);
    }
    
    public PageReference selectRecord(){
        if(((Id)selectedID).getSobjectType() == Schema.Case.SObjectType){
            selectedCase = Database.query('SELECT ' + String.join(caseFieldsToDisplay, ',') + ' FROM Case WHERE Id = :selectedID LIMIT 1');  
            createdNewCase = true;
        } else if (((Id)selectedID).getSobjectType() == Schema.Contact.SObjectType){
            selectedContact = Database.query('SELECT ' + String.join(contactFieldsToDisplay, ',') + ' FROM Contact WHERE Id = :selectedID LIMIT 1');
            proxyCase.ContactId = selectedContact.Id;
            if(selectedContact.AccountId != null) proxyCase.AccountId = selectedContact.AccountId;
        } else if (((Id)selectedId).getSObjectType() == Schema.Account.SObjectType){
            proxyContact.AccountId = (Id)selectedId;
            editableAccount = new Account();
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPAges.Severity.ERROR, UNKNOWN_TYPE_ERROR));
        }
        
        return null;
    }
    
    public PageReference selectRecords(){
        
        if(currentQueriedRecords == null) return null;

        List<Sobject> selected =  currentQueriedRecords.getCheckedWrappers();
        
        if(selected.isempty()) return null;
        
        if(selected.size() == 1 && Contact.SObjectType == selected[0].getSObjectType() ){
            selectedContact = (Contact) selected[0];
            proxyCase.ContactId = selectedContact.Id;
            if(selectedContact.AccountId != null) proxyCase.AccountId = selectedContact.AccountId;
        } else if(selected.size() == 1 && Case.SObjectType == selected[0].getSObjectType() ){
            selectedCase = (Case) selected[0];
        } else if( Asset.SObjectType == selected[0].getSObjectType() ) {
            Map<Id, Asset> assetMap = new Map<Id, Asset>(selectedAssets);
            for(Asset selectedAsset : (List<Asset>) selected) {
                if(!assetMap.containsKey(selectedAsset.id)){
                    selectedAssets.add(selectedAsset);
                }
            }
            
        } else {
            ApexPages.Message mess = new ApexPages.Message(ApexPages.Severity.ERROR, MULTIPLE_SELECTION_ERROR);
            ApexPAges.addMessage(mess);
        }
        
        return null;
    }
    
    public PageReference clearEditableObjects(){
        editableCase = proxyCase.clone();
        editableContact = proxyContact.clone();
        return null;
    }
    
    public PageReference saveSelectedRecords(){
        
        Datetime durationEnd = DateTime.now();
        Long secondsPassed = (durationEnd.getTime() - durationStart.getTime()) / 1000; 
        newTask.CallDurationInSeconds = (Integer)secondsPassed;
        
        System.Savepoint savePoint = Database.setSavepoint();
        
        // The only thing the user has to select is a case with a contact on it
        if(selectedCase != null && selectedCase.contactId != null){
            try {
                
                List<Case_Asset__c> caseAssetsToInsert = new List<Case_Asset__c>();
                newTask.Status = DEFAULT_TASK_STATUS;
                Task newTask2 = newTask.clone();
                newTask.WhoId = selectedContact != null? selectedContact.id : null;
                newTask2.WhatId = selectedCase.id;

                List<Case_Asset__c> caseAssets = [Select Asset__c from Case_Asset__c where Case__c =: selectedCase.ID ];
                Set<ID> preexistingCaseAssetIds = Pluck.ids('Asset__c', caseAssets);
                
                if(!selectedAssets.isEmpty()){
                    for(Asset selectedAsset : selectedAssets){
                        if( ! preexistingCaseAssetIds.contains(selectedAsset.id)){
                            caseAssetsToInsert.add(new Case_Asset__c(Asset__c= selectedAsset.id, Case__c = selectedCase.id));
                        }
                    }
                }
                
                
                if(selectedCase.ContactId == null && selectedContact != null) {
                    selectedCase.ContactId = selectedContact.id;
                    update selectedCase;
                }
                if(!caseAssetsToInsert.isEmpty()){
                    insert caseAssetsToInsert;
                }
                
                insert new List<Task>{newTask, newTask2};
                
                return new PageReference('/' + selectedCase.id);
            } catch (dmlException e) {
                ApexPages.addMessages(e);
                Database.rollback(savePoint);
                return null;
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPAges.Severity.ERROR, INVALID_SELECTION_ERROR));
            return null;
        }
        
    }
    
    
    
    
    //--------------Case Functions ----------------//

    public Case editableCase {get;set;}
    public Case selectedCase {get;set;}
    
    public PageReference searchCases(){
        Map<String, String> additionalFieldMap = new Map<String, String>{
                                                 'casenumber'=> proxyCasenumber};
        
        string additionalQueryString;                                         
        Set<ID> caseAssetMatchesBySO = Pluck.ids('Case__c', [Select Case__c from Case_Asset__C WHERE SO_Number__c =:proxySONumber_Case AND SO_Number__c != NULL ]);
        
        if(!caseAssetMatchesBySO.isEmpty()) {
            additionalQueryString = ' ID IN ' + BluewolfDevUtils.flattenListForQuery(new List<ID>(caseAssetMatchesBySO)); 
        }
        
        String query =  SupportPageHelper.buildSearchQuery(caseFieldsToDisplay, caseFieldsToSearch, proxyCase, additionalFieldMap, additionalQueryString);
        if(query == null) return null;

        List<Case> casesQueried = Database.query(query);

        Map<Id, Integer> additionalSearchMatches =  SupportPageHelper.findCaseAdditionalSearchMatches(caseAssetMatchesBySO, additionalFieldMap, casesQueried);
        
        currentQueriedRecords = SupportPageHelper.sortRecords(new List<String>(caseFieldsToSearch), casesQueried, proxyCase, additionalSearchMatches);
        multiSelectEnabled = false;
        currentDisplayFields = caseFieldsToDisplay;
        
        return null;
    }
    
    public PageReference removeSelectedCase(){
        this.selectedCase = null;
        return null;
    }
    
    public PageReference editCase(){
        if(((Id)selectedID).getSobjectType() == Schema.Case.SObjectType){
            editableCase = Database.query('SELECT ' + String.join(new List<String>(caseFieldsToUpsert), ',') + ' FROM Case WHERE Id = :selectedID LIMIT 1');        
        }
        
        return null;
    }
    
    
    
    
    //--------------Contact Functions ----------------//
    
    public Contact editableContact {get;set;}
    public Contact selectedContact {get;set;}
    public Account editableAccount {get;set;}

    public PageReference searchContacts(){
        
        
        Map<String, String> additionalFieldMap = new Map<String, String>(); 
        
        String firstName = proxyFirstName.replaceAll(';', '');
        String lastName = proxyLastName.replaceAll(';', '');
        if( (!String.isBlank(firstName)) && (!String.isBlank(lastName)) ){
            additionalFieldMap.put('firstName;lastName', firstName + ';' + lastName);
        }else{
            additionalFieldMap.put('firstName', firstName);
            additionalFieldMap.put('lastName', lastName);
        }
        
        
        String query = SupportPageHelper.buildSearchQuery(contactFieldsToDisplay, contactFieldsToSearch, proxyContact, additionalFieldMap, '');
        if(query == null) return null;
        List<Contact> contactsQueried = (List<Contact>) Database.query(query);
        
        Map<Id, Integer> contactToAdditionalMatches = new Map<Id, Integer>();
        additionalFieldMap = new Map<string, String>{'firstName'=> firstName, 'lastName' => lastName};
        
        SupportPageHelper.findObjectAdditionalFieldMatches(contactsQueried, additionalFieldMap, contactToAdditionalMatches);
        currentQueriedRecords = SupportPageHelper.sortRecords(new List<String>(contactFieldsToSearch), contactsQueried, proxyContact, contactToAdditionalMatches);
        currentDisplayFields = contactFieldsToDisplay;
        multiSelectEnabled = false;
        
        
        return null;
    }
    
    
    public PageReference removeSelectedContact(){
        if(proxyCase.ContactId == this.selectedContact.Id) proxyCase.ContactId = null;
        if(proxyCase.AccountId == this.selectedContact.AccountId) proxyCase.AccountId = null;
        this.selectedContact = null;
        return null;
    }
    
    
    public PageReference editContact(){
        editableContact = new Contact(Id = selectedId);
        return null;
        
    }
    
    public PageReference exportRecords(){
        return Page.SupportPageExport;
    }
    
    
    
    //--------------Asset Functions ----------------//
    
    public CheckBoxWrapperList assetsQueried {get;set;}
    public List<Asset> selectedAssets {get;set;}

    public PageReference searchAssets() {
         Map<String, String> additionalFieldMap = new Map<String, String>{
                                                 'SerialNumber'=> proxySerialNumber,
                                                 'SO_Number__c'=> proxySONumber_Asset,
                                                 'GO_Number__c'=> proxyGONumber_Asset
                                                 };

        String query =  SupportPageHelper.buildSearchQuery(assetFieldsToDisplay,assetFieldsToSearch, proxyAsset, additionalFieldMap, '');     
        if(query == null) return null;
        
        List<Asset> assetsQueried = Database.query(query);
        
        Map<Id, Integer> additionalSearchMatchesMap = new Map<Id, Integer>();
        
        SupportPageHelper.findObjectAdditionalFieldMatches(assetsQueried, additionalFieldMap, additionalSearchMatchesMap);

        currentQueriedRecords = SupportPageHelper.sortRecords(new List<String>(assetFieldsToSearch), assetsQueried, proxyAsset, additionalSearchMatchesMap);
        currentDisplayFields = assetFieldsToDisplay;
        
        multiSelectEnabled = true;
        return null;
    }

    
    public PageReference removeSelectedAsset(){
        Map<Id, Asset> idToAsset = new Map<Id,Asset>(selectedAssets);
        idToAsset.remove(assetIdToRemove);
        selectedAssets = idToAsset.values();
        return null;
    }
    
    
    
    
    //--------------Wrapper Class ----------------//
    
    public class checkboxWrapper {
        public sobject obj {get;set;}
        public boolean isChecked {get;set;}
        public checkBoxWrapper (Sobject ob){
            this.obj = ob;
            this.isChecked = false;
        }
    } 
    
    public class checkboxWrapperList {
        public List<CheckboxWrapper> wrappers {get;set;}
        public checkBoxWrapperList (){}
        public checkboxWrapperList (List<CheckboxWrapper> wrs){
            wrappers = wrs;
        }

        public checkboxWrapperList (List<sObject> objs){
            wrappers = new List<checkBoxWrapper>();
            for(sObject obj : objs){
                wrappers.add(new checkboxWrapper(obj));
            }
        }
        
        public List<Sobject> getCheckedWrappers() {
            List<Sobject> objectsToReturn = new List<Sobject>();
            for(CheckboxWrapper wrapper : wrappers) {
                if(wrapper.isChecked) {
                    objectsToReturn.add(wrapper.obj);
                }
            }
            return objectsToReturn;
        }

        public void reduce(Integer size){
            if(wrappers.size() <= size) return;
            List<CheckboxWrapper> reducedWrappers = new List<CheckboxWrapper>();
            for(Integer i = 0; i < size; i++){
                reducedWrappers.add(wrappers[i]);
            }
            wrappers = reducedWrappers;
        }
    }

}