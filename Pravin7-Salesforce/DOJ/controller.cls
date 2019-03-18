public class ApplicationSearchController {
    public List<AppFormWrapper> appFormWrapList {get; set;}
    public Application__c appForm {get; set;}     
    public String selectedStatusA {get;set;}
    public String selectedStatusB {get;set;}
    public String selectedReviewType {get; set;}    
    public String appFormNumber {get; set;}     
    
    public applicationSearchController() { 
        appFormWrapList = new List<AppFormWrapper>();        
        appForm = new Application__c();
        appForm.Application_Valid_Date__c = null;
    }
    
    public class AppFormWrapper {
        public Application__c appFormRec {get; set;}
        public Boolean isChecked {get; set;}
        
        public AppFormWrapper(Application__c appFormRec, Boolean isChecked) {
            this.appFormRec = appFormRec;
            this.isChecked = isChecked;
        }
    }
    
    public List<SelectOption> getStatusA() {
        List<SelectOption> tempList = new List<SelectOption>();
		tempList.add(new SelectOption('ALL', 'ALL'));        
        tempList.add(new SelectOption('VALID', 'VALID')); 
        tempList.add(new SelectOption('INVALID', 'INVALID'));
        tempList.add(new SelectOption('PENDING', 'PENDING'));
        return tempList;
    }
    
    public List<SelectOption> getStatusB() {
        List<SelectOption> tempList = new List<SelectOption>();
		tempList.add(new SelectOption('ALL', 'ALL'));        
        tempList.add(new SelectOption('CLOSED', 'CLOSED')); 
        tempList.add(new SelectOption('IN REVIEW', 'IN REVIEW'));
        tempList.add(new SelectOption('LOCKED', 'LOCKED'));
        tempList.add(new SelectOption('OPEN', 'OPEN'));
        tempList.add(new SelectOption('OUTCOME', 'OUTCOME'));
        tempList.add(new SelectOption('TRANSFERRED', 'TRANSFERRED'));
        return tempList;
    }

    public List<SelectOption> getReviewType() {
        List<SelectOption> tempList = new List<SelectOption>();
        tempList.add(new SelectOption('ALL', 'ALL')); 
        tempList.add(new SelectOption('ADT', 'ADT'));
        tempList.add(new SelectOption('Internal Review', 'INTERNAL REVIEW'));
        tempList.add(new SelectOption('OIC Review', 'OIC REVIEW'));
        tempList.add(new SelectOption('S.93 Internal Review', 'S.93 INTERNAL REVIEW'));
        return tempList;
    }    
        
    public PageReference searchAppForm() {
        try {
			String query = getAppFormSearchQuery();
			appFormWrapList = wrapAppForms(database.query(query));            
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info, e.getMessage()));
        }        
        return null;
    }
    
    public PageReference clearFilters() {
		appForm = new Application__c();
        appForm.Application_Valid_Date__c = null;
        appFormNumber = null;
        return null;
    }
    
	public PageReference deleteAppForm() {
        List<Application__c> appList = new List<Application__c>();
        List<AppFormWrapper> tempList = new List<AppFormWrapper>();
        for (AppFormWrapper a :appFormWrapList) {
            if (a.isChecked) {
            	System.debug('Row is checked and will be deleted :' + a);
                appList.add(a.appFormRec);
            } else tempList.add(a);
        }        
        if (!appList.isEmpty())
            Database.delete(appList, false);
		appFormWrapList.clear();
		appFormWrapList.addAll(tempList);
        return null;
    }    

    
                
    private String getAppFormSearchQuery() {        
        String query = 'SELECT id, Dept_File_No__c, Name, Organisation__c, Officer__c, Officer__r.name, Firstname__c,'
													+' Surname__c, Status__c, Application_Valid_Date__c, Due_Date__c'
													+' FROM Application__c WHERE';
        
        System.debug('appForm :' + appForm);
        System.debug('appFormNumber :' + appFormNumber);
                    
        if (!String.isBlank(appFormNumber)) {
           query += getAppFormNumberString(String.escapeSingleQuotes(appFormNumber)) + '\' AND';     
        } 
        if (!String.isBlank(appForm.Dept_File_No__c)) {
            query += getDeptFileNoString(String.escapeSingleQuotes(appForm.Dept_File_No__c)) + '\' AND'; 
        }
        if (appForm.Officer_Dummy__c != null) { 
        	System.debug('appForm.Officer_Dummy__c :' +appForm.Officer_Dummy__c);
            query += ' Officer__c = \''+appForm.Officer_Dummy__c +'\' AND';    
        }
        if (!String.isBlank(appForm.Surname_Dummy__c)) {
            query += ' Surname__c = \''+appForm.Surname_Dummy__c + '\' AND'; 
        }		
        if (!String.isBlank(appForm.Organisation__c)) {
            query += ' Organisation__c = \''+appForm.Organisation__c + '\' AND'; 
        }
        if (!String.isBlank(appForm.Status__c)) {
            query += ' Status__c = \''+appForm.Status__c + '\' AND'; 
        }				
		if (appForm.application_Valid_Date__c != null) {
		    System.debug('appForm.Application_Valid_Date__c:' +appForm.Application_Valid_Date__c);
            DateTime refDate1 = DateTime.newInstance(appForm.application_Valid_Date__c.year(),
                                            appForm.application_Valid_Date__c.month(), 
                                            appForm.application_Valid_Date__c.day(), 0, 0, 0);
            String formattedDt = refDate1.format('yyyy-MM-dd');
            query += ' Application_Valid_Date__c >= '+ formattedDt + ' AND'; 
        }
		if (appForm.Due_Date__c != null) {
		    System.debug('appForm.Due_Date__c:' +appForm.Due_Date__c);
            DateTime refDate1 = DateTime.newInstance(appForm.due_Date__c.year(), 
                                                     appForm.due_Date__c.month(),
                                                     appForm.due_Date__c.day(), 0, 0, 0);
            String formattedDt = refDate1.format('yyyy-MM-dd');            
            query += ' Due_Date__c <= '+ formattedDt + ' AND'; 
        }
        if (null != selectedReviewType && selectedReviewType != 'ALL') {
           query += ' Id in (SELECT Application__c FROM Review__c WHERE Review_Type__c = \'' + selectedReviewType + '\')'  + ' AND';                														
        }
        if (null != selectedStatusA && null != selectedStatusB) {
           if (selectedStatusA == 'ALL' && selectedStatusB != 'ALL')
           		query += ' Status__c LIKE \'%' + selectedStatusB + '\'' + ' AND';
           else if (selectedStatusA != 'ALL' && selectedStatusB == 'ALL')
                query += ' Status__c LIKE \'' + selectedStatusA + '%\''  + ' AND';
           else if (selectedStatusA != 'ALL' && selectedStatusB != 'ALL')
               	query += ' Status__c = \'' + selectedStatusA + ' - ' + selectedStatusB + '\'' + ' AND';             
        }

        query = query.removeEnd(' AND');
        query = query.removeEndIgnoreCase(' WHERE');
        
 		System.debug('Final Query :' + query);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info, query));
        return query;
    }
            
	private List<AppFormWrapper> wrapAppForms(List<Application__c> appList) {
		List<AppFormWrapper> wrapList = new List<AppFormWrapper>();
		if (null != appList) {
			for (Application__c a : appList) {
				wrapList.add(new AppFormWrapper(a, false));
			}		
		}		
		return wrapList;
	}
    
	private String getAppFormNumberString(String appFormNumber) {
        return ' Name = \''+appFormNumber;
    }
	private String getDeptFileNoString(String DeptFileNo) {
        return ' Dept_File_No__c = \''+DeptFileNo;
    }    
    
}