public with sharing class MassReassignOpportunitiesController {
    
    public ApexPages.StandardSetController optySetController;
    public String filterId {get;set;}
    public String ErrorMsg {get;set;}
    public String optyQueryString;
    public List<cOpty> optyList {get;set;}
    public list<Opportunity> optyToUpdateList {get;set;}
    public Opportunity searchRecord {get;set;}
    public Reassign_Helper__c helperRecord{get;set;}
    public boolean isSuccess{get;set;}
    public boolean searchPerformed{get;set;}
    public boolean tooManyResults{get;set;}
    
    /**
    *   Round Robin Variables
    *   @author Jim Hutcherson
    *   @date June 10 2014
    **/
    private map<Id,String> userMap = new map<Id,String>();
    private map<Id,String> availableRoundRobinUserMap = new map<Id,String>();
    public list<String> availableRoundRobinUsers {get;set;} 
    private map<Id,String> selectedRoundRobinUserMap = new map<Id,String>();
    public list<String> selectedRoundRobinUsers {get;set;}
    
    public Integer optyListSize {get{return optylist.size();}}
    public list<SelectOption> listviewoptions {
        get{
            List<SelectOption> tempList = new List<SelectOption>();
            tempList.add(new selectOption('None',System.Label.NoViewSelection));
            if (optySetController<>null)tempList.addAll(optySetController.getListViewOptions());
            return tempList;
        }
    }

    public MassReassignOpportunitiesController() {
        //Variable Init
        optyQueryString = 'SELECT name, StageName, Ownerid, CloseDate, Account.Name, Account_Phone__c from Opportunity where isDeleted = false';
        optyList = new List<cOpty>();
        optySetController = new ApexPages.Standardsetcontroller(Database.getQueryLocator(optyQueryString+' limit 1000'));
        optySetController.setPageSize(100);
        filterId = listviewoptions[0].getValue();
        searchRecord = new Opportunity();
        helperRecord = new Reassign_Helper__c();
        isSuccess = false;
        searchPerformed = false;
        tooManyResults= false;
        
        //Apply the default filter
        //refreshOptyList();
        
        //Added June 9 2014
        this.selectedRoundRobinUsers = new list<String>();
        this.availableRoundRobinUsers = new list<String>();
        for(User user : [SELECT Id, Name FROM User WHERE IsActive = true AND (UserRole.Name = 'OPTIONS Closer Team Lead' OR UserRole.Name = 'OPTIONS Closer' OR UserRole.Name = 'Closer' OR UserRole.Name = 'Closer Team Lead') ORDER BY UserRoleId]) {
            this.userMap.put(user.Id,user.Name);
            this.availableRoundRobinUserMap.put(user.Id,user.Name);
        }
        
    }
    
    /*========================================
    Applies the View filter to the Opty List
    ==========================================*/ 
    public void refreshOptyList() {
        list<Opportunity> testList = new list<Opportunity>();
        
        optyList.clear();
        isSuccess = false;
        tooManyResults = false;
        if (filterId <> null && filterId<> 'None') {
             optySetController.setFilterId(filterId);
             optySetController.setPageSize(100);
             testList = (list<Opportunity>)optySetController.getRecords();
             searchPerformed = true;
        }
        else {
            searchPerformed = false;
        }
        
        System.debug('Filter used=>'+filterId);
        System.debug('Result #=>'+optySetController.getResultSize());
        Integer counter=0;
        for (Opportunity opty:testList) {
            optyList.add(new cOpty(Opty));
            counter++;
            if (counter == 999) {
                tooManyResults = true;
                break;
            }
        }   
    }
    
    public void refreshOptyListBySearch(){
        optyList.clear();
        isSuccess = false;
        
        //resultList = new List<cResult>();
        String userFilterQuery='';
        if (searchRecord.Name <> null) {
            userFilterQuery = ' and Name like \'%' + searchRecord.Name + '%\'';
        }
        
        if (searchRecord.Type <> null) {
            userFilterQuery += ' and Type = \'' + searchRecord.type + '\'';
        }
        
        if (searchRecord.StageName <> null) {
            userFilterQuery += ' and StageName = \'' + searchRecord.StageName + '\'';
        }
        
        if (helperRecord.From__c <> null) {
                DateTime startDate = DateTime.newInstance(helperRecord.From__c, Time.newInstance(0, 0, 0, 0));
                userFilterQuery += ' and CreatedDate >= ' + startDate.format('yyyy-MM-dd') + 'T00:00:00Z';
                
        }
        if (helperRecord.To__c <> null){
                DateTime endDate = DateTime.newInstance(helperRecord.to__c, Time.newInstance(0, 0, 0, 0));
                userFilterQuery += ' and CreatedDate <= ' + endDate.format('yyyy-MM-dd') + 'T00:00:00Z';
        
        }
        if (helperRecord.closedDate_From__c<>null){
                DateTime startDate = DateTime.newInstance(helperRecord.closedDate_From__c, Time.newInstance(0, 0, 0, 0));
                userFilterQuery += ' and CloseDate >= '+startDate.format('yyyy-MM-dd');
                
        }
        if (helperRecord.closedDate_To__c<>null){
                DateTime endDate = DateTime.newInstance(helperRecord.closedDate_to__c, Time.newInstance(0, 0, 0, 0));
                userFilterQuery += ' and CloseDate <= '+endDate.format('yyyy-MM-dd');
        }
        
        String optyQueryString = optyQueryString + userFilterQuery ;
        optyQueryString += ' order by Name limit 1000';
        
        List<Sobject> sortedResults = new List<SObject>();
        try {
            sortedResults = Database.query(optyQueryString);
            searchPerformed = true;
        }
        catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        System.debug('Request => ' + optyQueryString);

        for (SObject foundObject : sortedResults){
            Opportunity opty = (Opportunity)foundObject;
            optyList.add(new cOpty(opty));      
        }
    }
    
    
    /*===============================================
    Assign the selected opportunities to a new owner
    =================================================*/
    public void Assign() {     
        list<Opportunity> optyToUpdateList=new list<Opportunity>();
        
        integer indexCount = this.selectedRoundRobinUserMap.size() - 1;
        integer ownerIndex = 0;
        list<Id> ownerIds = new list<Id>();
        ownerIds.addAll(this.selectedRoundRobinUserMap.keySet());
        
        for (cOpty opty:optyList) {
            if (opty.selected){
                if(this.assignOption == 'User' && helperRecord.Assign_to__c != null){
                    optyToUpdateList.add(new Opportunity(id=opty.oOpty.id, OwnerId=helperRecord.Assign_to__c));
                }else if(this.assignOption == 'Round Robin' && this.selectedRoundRobinUserMap.isEmpty() != true){
                    optyToUpdateList.add(new Opportunity(id=opty.oOpty.id, OwnerId=ownerIds[ownerIndex]));
                    ownerIndex++;
                    if(ownerIndex > indexCount){
                        ownerIndex = 0;
                    }
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You must select User/Users to transfer to.'));
                }
            }
        }
        
        if(optyToUpdateList.size() >= 10000){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.TooManyRowsError));
        }else if (optyToUpdateList.size() > 0){
            try{
                update optyToUpdateList;
            }
            catch (Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            }
            
            if (optyToUpdateList.size()>0) isSuccess = true;
            
        }
        
        integer n=optyList.size();
        for (integer i=n-1;i>=0;i--){
            if (optyList[i].selected) optyList.remove(i);
        }
        
        this.availableRoundRobinUsers.clear();
        this.selectedRoundRobinUsers.clear();
        //this.refreshOptyList();
                
    }
    
    /*==================================================
    Inner class helping identify selected opportunities
    ====================================================*/
    public class cOpty{
        public Opportunity oOpty {get;set;}
        public Boolean selected {get;set;}
        
        public cOpty(Opportunity oOpty){
            this.oOpty = oOpty;
            selected=false;
        }
        
    }
    
    
    /**
    * Assign Option addon 
    * @author Jim Hutcherson
    * @date June 09 2014
    **/
    public String assignOption {
        get{
            if(this.assignOption == null)
                this.assignOption = 'User';
            return this.assignOption;
        }
        set;
    }
    
    public list<SelectOption> listAssignOptions {
        get{
            List<SelectOption> tempList = new List<SelectOption>();
            tempList.add(new selectOption('User','User'));
            tempList.add(new selectOption('Round Robin','Round Robin'));
                return tempList;
        }
    }
    
    /**
    * Round Robin Users addon 
    * @author Jim Hutcherson
    * @date June 09 2014
    **/
    public list<SelectOption> listAvaliableRoundRobinUsers {
        get{
            list<SelectOption> tempList = new list<SelectOption>();
            if(this.availableRoundRobinUserMap.isEmpty()){
                tempList.add(new selectOption('None',System.Label.NoViewSelection));
                
            }else{
                for(String userId : availableRoundRobinUserMap.keySet()){
                    tempList.add(new selectOption(userId,this.availableRoundRobinUserMap.get(userId)));
                }
            }
            return tempList;
        }
        set;
    }
    
    public list<SelectOption> listSelectedRoundRobinUsers {
        get{
            list<SelectOption> tempList = new list<SelectOption>();
            if(this.selectedRoundRobinUserMap.isEmpty()){
                tempList.add(new selectOption('None',System.Label.NoViewSelection));
                
            }else{
                for(String userId : selectedRoundRobinUserMap.keySet()){
                    tempList.add(new selectOption(userId,this.selectedRoundRobinUserMap.get(userId)));
                }
            }
            return tempList;
        }
        set;
    }
    
    public void addSelectedRoundRobinUser(){
        if(this.availableRoundRobinUsers != null && !this.availableRoundRobinUsers.isEmpty()){
            for(String userId : this.availableRoundRobinUsers){
                this.selectedRoundRobinUserMap.put(userId,this.userMap.get(userId));
                this.availableRoundRobinUserMap.remove(userId);
            }
        }
        this.availableRoundRobinUsers.clear();
        this.selectedRoundRobinUsers.clear();
    }
    
    public void removeSelectedRoundRobinUser(){
        if(this.selectedRoundRobinUsers != null && !this.selectedRoundRobinUsers.isEmpty()){
            for(String userId : this.selectedRoundRobinUsers){
                this.availableRoundRobinUserMap.put(userId,this.userMap.get(userId));
                this.selectedRoundRobinUserMap.remove(userId);
            }
        }
        this.availableRoundRobinUsers.clear();
        this.selectedRoundRobinUsers.clear();
    }
}