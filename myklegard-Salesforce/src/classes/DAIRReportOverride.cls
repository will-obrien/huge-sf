public class DAIRReportOverride{
    ApexPages.StandardController c;
    public DAIRReportOverride(ApexPages.StandardController controller) {
        c = controller;
    }    
    
    public PageReference onLoad() {
       PageReference pr;
        if(c.getId()==null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO,'This page only works with existing records.'));
        } else {
            DAIR_Report__c record = (DAIR_Report__c)c.getRecord();
            if(record.DAIR_Status__c=='draft') {
                record.DAIR_Status__c='Submitted';
                pr = c.save();
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.WARNING, 'Record is already Submitted'));
            }
        }
        return pr;
    }
}