public class mobileconfig_manager {

    public List<Mobileconfig__c> mobileconfigs {get; set;}
    public Map<String, String> email_addresses {get; set;}
    public boolean displayPopup {get; set;}
    public Mobileconfig__c current_mobileconfig {get; set;}
    public Document app_icon {
        get {
            if (app_icon == null)
                app_icon = new Document();
            return app_icon;
        }
        set;
    }
    public mobileconfig_manager(){
        init_mobileconfigs_list();
        displayPopup = false;
        current_mobileconfig = new Mobileconfig__c();
    }
    public void init_mobileconfigs_list(){
        mobileconfigs = [select Id, Name, Display_Name__c, User__c, Username__c, Password__c, Start_URL__c, Base64_App_Icon__c from Mobileconfig__c];
        List<String> mobileconfigs_id = new List<String>();
        email_addresses = new Map<String, String>();
        for(Mobileconfig__c m : mobileconfigs){
            mobileconfigs_id.add(m.Id);
            email_addresses.put(m.Id, '');
        }
        email_addresses.put('all', '');
    }
    
    public PageReference send_mobileconfig(){
        String current_mobileconfig_id = apexpages.currentpage().getparameters().get('mobileconfig_id');
        current_mobileconfig = [select Id, Name from Mobileconfig__c where Id = :current_mobileconfig_id];
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        PageReference mobileconfig_installer = Page.mobileconfig_installer;
        mobileconfig_installer.getParameters().put('id',(String)current_mobileconfig.id);
        mobileconfig_installer.setRedirect(true);
        Blob b;
        if (Test.isRunningTest()) {
           b = Blob.valueOf('Test Blob String');
        } else {
           b = mobileconfig_installer.getContent();
        }
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName(current_mobileconfig.Name + '.mobileconfig');
        efa.setBody(b);
        email.setSubject('Your mobile app: ' + current_mobileconfig.Name);
        email.setToAddresses(new List<String>{email_addresses.get(current_mobileconfig.Id)});
        email.setPlainTextBody('');
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
        
        email_addresses.put(current_mobileconfig.Id, '');
        current_mobileconfig = new Mobileconfig__c();
        return null;
    }
     
    public void closePopup() {
        displayPopup = false;
        app_icon = null;
        current_mobileconfig = new Mobileconfig__c();
    }
 
    public void showPopup() {
        displayPopup = true;
        String current_mobileconfig_id = apexpages.currentpage().getparameters().get('mobileconfig_id');
        for(Mobileconfig__c m : mobileconfigs){
            if(m.Id == current_mobileconfig_id){
                current_mobileconfig = m;
                return;
            }
        }
    }
    
    public PageReference save_mobileconfig(){
        if(app_icon.Body != null){
            current_mobileconfig.Base64_App_Icon__c = EncodingUtil.base64Encode(app_icon.Body);
            app_icon.Body = null;
            app_icon = null;
        }
        upsert current_mobileconfig;
        displayPopup = false;
        
        current_mobileconfig = new Mobileconfig__c();
        
        init_mobileconfigs_list();
        return null;
    }
    public PageReference remove_mobileconfig(){
        delete current_mobileconfig;
        displayPopup = false;
        current_mobileconfig = new Mobileconfig__c();
        
        init_mobileconfigs_list();
        return null;
    }
    
    public PageReference send_all_mobileconfigs(){
        List<Mobileconfig__c> mobileconfigs = [select Id, Name from Mobileconfig__c];
        List<Messaging.EmailFileAttachment> efas = new List<Messaging.EmailFileAttachment>();
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        
        for(Mobileconfig__c m : mobileconfigs){
            PageReference mobileconfig_installer = Page.mobileconfig_installer;
            mobileconfig_installer.getParameters().put('id',(String)m.id);
            mobileconfig_installer.setRedirect(true);
            Blob b;
            if (Test.isRunningTest()) {
               b = Blob.valueOf('Test Blob String');
            } else {
               b = mobileconfig_installer.getContent();
            }
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(m.Name + '.mobileconfig');
            efa.setBody(b);
            efas.add(efa);
        }
        
        email.setSubject('Your mobile apps');
        email.setToAddresses(new List<String>{email_addresses.get('all')});
        email.setPlainTextBody('');
        email.setFileAttachments(efas);
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
        
        email_addresses.put('all', '');
        return null;
    }
}