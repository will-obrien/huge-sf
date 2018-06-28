public without sharing class DigitalBadge{
    
    public Contact userCont { get; set; }
    
        
    public DigitalBadge() {
        List<Contact> lstCont = [select  Id, Name, GARP_ID__c, Fax, KPI_ERP_Certified_Year__c, KPI_FRM_Certified_Year__c, KPI_CPE_Current_Cycle__c, KPI_CPE_Last_Completed_Cycle__c from Contact 
                 where id = :ApexPages.currentPage().getParameters().get('id')]; 
        if(lstCont != null && lstCont.size() > 0) {
            userCont = lstCont[0];
        } else {
            lstCont = [select  Id, Name, GARP_ID__c, Fax, KPI_ERP_Certified_Year__c, KPI_FRM_Certified_Year__c, KPI_CPE_Current_Cycle__c, KPI_CPE_Last_Completed_Cycle__c from Contact 
                         where GARP_Member_ID__c = :ApexPages.currentPage().getParameters().get('id')]; 
            if(lstCont != null && lstCont.size() > 0) {
                userCont = lstCont[0];
            }                         
        }
    }
}