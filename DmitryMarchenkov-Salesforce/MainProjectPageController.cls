public class MainProjectPageController {

    public String selectedValue { get;set; }
    public List<SelectOption> statusOptions { get;set; }
    public List<Material__c> materials { get;set; }
    public Map<Id, Attachment> materialsWithAttachment {get;set;}

    public Attachment attachment {get; set;}

    public Boolean mainButtonFlag {get; set;}
    public Boolean scheduleButtonFlag {get; set;}
    public Boolean scheduleShow {get; set;}
    public Boolean materialsButtonFlag {get; set;}
    public Boolean addAttachmentFlag {get; set;}
    public Boolean addMaterialsFlag {get; set;}
    public Date scheduleDate {get; set;}
    
    public Attachment attachedFile {
          get {
              if (attachedFile == null)
                attachedFile = new Attachment();
              return attachedFile;
            }
          set;
          }
    public Schedule__c schedule {get; set;}
    public Material__c material {get; set;}
    private List<Notation__c> notations;
    public Notation__c note {get; set;}

    public MainProjectPageController() {
        scheduleShow = false;
        mainButtonFlag = true;
        scheduleButtonFlag = false;
        materialsButtonFlag = false; 
        addAttachmentFlag = true;
        addMaterialsFlag = true;

        getAttachmentByDate(null);
    
        notations = [SELECT Note__c FROM Notation__c LIMIT 1];
        if(notations.size() > 0) {
            note = notations[0];
        }
        schedule = new Schedule__c();
        material = new Material__c();
        attachedFile = New Attachment();
        scheduleDate = Date.today();
        
    }

    public PageReference mainButtonAction() {  
        getAttachmentByDate(null); 
        changeFlags();        
        mainButtonFlag = true;
        scheduleButtonFlag = false;
        materialsButtonFlag = false;      
        return null;
    }

    public PageReference scheduleButtonAction() {  
        changeFlags();
        mainButtonFlag = false;
        scheduleButtonFlag = true;
        materialsButtonFlag = false;       
        return null;
    }

    public PageReference materialsButtonAction() {   
        changeFlags();
        getPicklistValues();
        showMaterials();      
        mainButtonFlag = false;
        scheduleButtonFlag = false;
        materialsButtonFlag = true;
        return null;
    }

    private void changeFlags(){
        addAttachmentFlag = true;
        addMaterialsFlag = true;
        scheduleShow = false;
    }
    
    public void showSchedule() {
        getAttachmentByDate(scheduleDate);
        addAttachmentFlag = true;
    }
    
    public PageReference addAttachment(){
        addAttachmentFlag = false;
        scheduleShow = false;

        if(addMaterialsFlag == true) {
            addMaterialsFlag = false;
        } else {
            addMaterialsFlag = true;
        }
        return null; 
    }  

    public void UploadFileAttachmentSchedule() {  
        if(attachedFile.Body == null) {
            addErrorMessage('You can\'t add schedule without attachment!');
        } else {
            List<Schedule__c> scheduleToDelete = [SELECT Id FROM Schedule__c WHERE ScheduleDate__c =: scheduleDate];
            delete scheduleToDelete;
            insert schedule; 
            attachedFile.ParentId = schedule.Id;
            insert attachedFile;  
            schedule = new Schedule__c();
            attachedFile = New Attachment();          
        } 
        addAttachmentFlag = true;
    }

    public void saveNotation() {
        update notations;
    }

    public void UploadFileAttachmentMaterial() {  
        if(attachedFile.Body == null) {
            addErrorMessage('You can\'t add schedule without attachment!');
        } else {
            insert material; 
            attachedFile.ParentId = material.Id;
            insert attachedFile;  
            attachedFile = New Attachment();          
        } 
        addAttachmentFlag = true;
    }

    public void deleteMaterial() {
        Id materrId = Apexpages.currentPage().getParameters().get('matId');
        List<Material__c> materialsToDelete = [SELECT Id FROM Material__c WHERE Id = :materrId];
        delete materialsToDelete;
    }

    private void getAttachmentByDate(Date scheduleDate) {
        List<Schedule__c> sched;
        if(scheduleDate == null) {
            sched = [SELECT Id FROM Schedule__c WHERE ScheduleDate__c = TODAY LIMIT 1];
        } else {
            sched = [SELECT Id FROM Schedule__c WHERE ScheduleDate__c = :scheduleDate LIMIT 1];
        }

        try {
            attachment = [SELECT Id, ParentId FROM Attachment WHERE ParentId = :sched[0].Id ];
            scheduleShow = true;            
        } catch(Exception e) {
            addErrorMessage('Schedule on this date doesn\'t exist!');
        }
    }

    public void getPicklistValues()
    {
        Schema.DescribeFieldResult statusFieldDescription = Material__c.Theme__c.getDescribe();
        statusOptions = new list<SelectOption>();
        
        for (Schema.Picklistentry picklistEntry : statusFieldDescription.getPicklistValues())
        {
            statusOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }
    }

    public void showMaterials()
    {
        materialsWithAttachment = new Map<Id, Attachment>();
        Set<Id> materialsIds = new Set<Id>();

        materials = [SELECT Id, Name FROM Material__c WHERE Theme__c = :selectedValue ORDER BY Name];
        for(Material__c material: materials) {
            materialsIds.add(material.Id);
        }

        for(Attachment attachment: [SELECT Id, ParentId, Name FROM Attachment WHERE ParentId IN :materialsIds]) {
            materialsWithAttachment.put(attachment.ParentId, attachment);
        }
    }

    private void addErrorMessage(String mess) {
        ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.FATAL, mess);
        ApexPages.addMessage(errorMessage);
    }
}
