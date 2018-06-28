public with sharing class SettingsController{
    public Config__c settings {get; set;}
    public String objectApiName { get; set; }
    public String[] fieldApiName { get; set; }
    public String cronTime { get; set; }
    public integer ageToRecheck { get; set; }
    private ID batchProcessId;
    public boolean FieldsDisabled {get;set;}
    public boolean isConfigured {get; set;}
    public String filter { get; set; }
   
    public void init(){
        FieldsDisabled = true;
        settings = Config__c.getOrgDefaults();
        if ( settings == null ){
            settings = new Config__c();
            isConfigured = false;
        }else{
            isConfigured = settings.TelemarketerId__c != null;
        }
        ageToRecheck = 30;
        filter = '';
    }
    
    public boolean getCanEditSettings(){
        return sObjectType.Config__c.isUpdateable();
    }
    public PageReference cancel(){
        if ( ApexPages.currentPage().getParameters().containsKey('retURL') )
            return new PageReference(ApexPages.currentPage().getParameters().get('retURL'));
        return null;
    }
    public PageReference save(){
        DNC.Credentials creds = new DNC.Credentials();
        creds.telemarketerId = settings.telemarketerId__c;
        creds.washOnlyUserId = settings.washOnlyUserId__c;
        creds.telemarketerPassword = settings.telemarketerPassword__c;
        integer accountBalance;
        try{
            accountBalance = DNC.getAccountBalance(creds);
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
        }
        
        upsert settings;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Settings updated... Your account balance is '+ accountBalance));
        isConfigured = true;
        return cancel();
    }
    
    public List<SelectOption> getObjects() {
        
        Map<String, SelectOption> m = new Map<String, SelectOption>();
        for ( Schema.SObjectType st: Schema.getGlobalDescribe().values() ){
            Schema.DescribeSObjectResult d = st.getDescribe();
            if ( !d.isUpdateable() )
                continue;
            m.put(d.getLabel(), new SelectOption(d.getName(),d.getLabel()));
        }
        
        List<SelectOption> ret = new List<SelectOption>();
        List<String> sorted = new List<String>();
        sorted.addAll( m.keySet() );
        sorted.sort();
        ret.add(new SelectOption('', '-- Select Object --'));
        
        //put lead, contact first.
        ret.add(m.get('Lead'));
        ret.add(m.get('Contact'));
        ret.add(m.get('Account'));
        ret.add(new SelectOption('', '-- Other Object --'));
        
        for ( String k : sorted ){
            ret.add(m.get(k));
        }
        return ret;
    }
    
    public List<SelectOption> getFields() {
        List<SelectOption> ret = new List<SelectOption>();
        FieldsDisabled = true;
        if ( objectApiName != null && objectApiName != '' ){
            for ( Schema.SObjectType st: Schema.getGlobalDescribe().values() ){
                Schema.DescribeSObjectResult d = st.getDescribe();
                if ( d.getName() == objectApiName ){
                    Map<String, Schema.SObjectField> fields = d.fields.getMap();
                    for ( String k : fields.keySet() ){
                        if ( k.endsWith('_dnc_status__c') ){
                            String fieldName = k.subString(0, k.length() - '_dnc_status__c'.length());

                            //check writable...
                            if ( !fields.get(k).getDescribe().isUpdateable() ){
                                ret.add(new SelectOption('', fieldName + ' (invalid - ' + k + ' is not updateable)'));
                                continue;
                            }
                            
                            //check checked field ...                    
                            if ( !fields.containsKey(fieldName + '_dnc_checked__c') ){
                                ret.add(new SelectOption('', fieldName + ' (invalid - no ' + fieldName + '_DNC_Checked__c field)'));
                                continue;
                            }
                            if ( !fields.get(fieldName + '_dnc_checked__c').getDescribe().isUpdateable() ){
                                ret.add(new SelectOption('', fieldName + ' (invalid - ' + fieldName + '_DNC_Checked__c is not updateable)'));
                                continue;
                            }
                            
                            //check base field...
                            if ( !fields.containsKey(fieldName) ){
                                if ( fields.containsKey(fieldName + '__c' ) ){
                                    fieldName += '__c';
                                }else{
                                    ret.add(new SelectOption('', fieldName + ' (invalid - no field called ' + fieldName + ' or ' + fieldName + '__c)'));
                                    continue;
                                }
                            }
                            if ( !fields.get(fieldName).getDescribe().isUpdateable() ){
                                ret.add(new SelectOption('', fieldName + ' (invalid - ' + fieldName + ' is not updateable)'));
                                continue;
                            }
                            
                            
                            Schema.SObjectField field = fields.get(fieldName);
                            Schema.DescribeFieldResult fd = field.getDescribe();
                            ret.add(new SelectOption(fd.getName(), fd.getLabel()));
                            FieldsDisabled = false;
                        //}else{
                        //    ret.add(new SelectOption('', '_____' + k));
                                
                        }
                    }
                }
            }
        }
        
        if ( ret.size() == 0 ){
            ret.add(new SelectOption('', 'This object does not contain any valid DNC phone fields'));
        }
        return ret;
    }
    public void objectChange(){
        
    }
    
    public List<SelectOption> getSchedules() {
        List<SelectOption> ret = new List<SelectOption>();
        ret.add(new SelectOption('', '-- Choose a schedule --'));
        ret.add(new SelectOption('0 0 0 * * ?  ', 'Daily'));
        ret.add(new SelectOption('0 0 *  * * ?  ', 'Hourly'));
        ret.add(new SelectOption('0 0 0 ? * SUN', 'Every Sunday'));
        ret.add(new SelectOption('0 0 0 ? * MON', 'Every Monday'));
        ret.add(new SelectOption('0 0 0 ? * TUE', 'Every Tueday'));
        ret.add(new SelectOption('0 0 0 ? * WED', 'Every Wednesday'));
        ret.add(new SelectOption('0 0 0 ? * THU', 'Every Thurday'));
        ret.add(new SelectOption('0 0 0 ? * FRI', 'Every Friday'));
        ret.add(new SelectOption('0 0 0 ? * SAT', 'Every Saturday'));
        
        return ret;
    }
    
    public void washNow(){
        if ( objectApiName == null || objectApiName == '' || fieldApiName == null || fieldApiName.isEmpty() ){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'You must specify a field to wash'));
            return;
        }
        Date recheckBefore = null;
        if ( ageToRecheck > 0 )
            recheckBefore = System.today() - ageToRecheck;
        DncBatchable b = new DncBatchable(objectApiName, fieldApiName, recheckBefore, filter);
        batchProcessId = Database.executeBatch(b, 100);  
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Batch job started. You can see the progress here on on the Apex Jobs page'));
    }
    
    public void schedule(){
        if ( objectApiName == null || objectApiName == '' || fieldApiName == null || fieldApiName.isEmpty() ){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'You must specify a field to wash'));
            return;
        }
        
        if ( cronTime == null || cronTime == '' ){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'You must specify a schedule'));
            return;
        }
        
        try{
            id id = System.schedule(objectApiName + ': ' + String.join(fieldApiName, ', ') + ' Wash Schedule', cronTime, 
                new DncSchedule(objectApiName, fieldApiName, ageToRecheck, filter));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Job scheduled as ' + id + '. You can manage your schedules from the Scheduled Jobs Page.'));
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
    }
    
    public boolean getIsBatchRunning(){
        return batchProcessId != null;
    }
    public AsyncApexJob getBatchStatus(){
        if ( batchProcessId != null ){
            AsyncApexJob ret = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE ID =:batchProcessId ];
            if ( ret.Status == 'Aborted' || ret.Status == 'Completed' || ret.Status == 'Failed'){
                batchProcessId = null;
            }
            return ret;
        }
        return null;
    }
}