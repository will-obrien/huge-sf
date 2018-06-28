public without sharing class SnapshotStats{

    public PageReference SnapshotStats() {
        List<Contact> clist = [select Id, Name,Membership_Type__c,KPI_Membership_Payment_Lapsed_Months__c,KPI_Membership_Payment_Status__c, AccountId,KPI_Membership_Source__c,KPI_Membership_Renewal_Type__c,KPI_Membership_Business_Type__c,KPI_Membership_Renewal_Count__c,KPI_FRM_Certified_Year__c,KPI_FRM_Certified__c,KPI_FRM_Candidate__c,KPI_FRM_Holder__c,KPI_FRM_Candidate_Payment_Lapsed_Months__c,KPI_FRM_Candidate_Payment_Status__c,KPI_FRM_Candidate_Business_Type__c,KPI_ERP_Certified__c,KPI_ERP_Candidate__c,KPI_ERP_Holder__c,KPI_ERP_Candidate_Payment_Lapsed_Months__c,KPI_ERP_Candidate_Payment_Status__c,KPI_ERP_Candidate_Business_Type__c,KPI_ICBRR_Participant__c,KPI_ICBRR_Result__c,KPI_FBR_Participant__c,KPI_CPE_Participation__c,KPI_CPE_Requirement_Status__c from Contact]; 
        
        List<KPI_History__c> KPIHistoryList = new List<KPI_History__c>();
        
        for(Contact con : clist) {
            KPI_History__c kpi = new KPI_History__c();
            
            kpi.KPI_h_Membership_Type__c = con.Membership_Type__c;        
            kpi.KPI_h_Membership_Payment_Lapsed_Months__c = con.KPI_Membership_Payment_Lapsed_Months__c;
            kpi.KPI_h_Membership_Payment_Status__c = con.KPI_Membership_Payment_Status__c;                         
            kpi.KPI_h_Membership_Source__c = con.KPI_Membership_Source__c;
            kpi.KPI_h_Membership_Renewal_Type__c = con.KPI_Membership_Renewal_Type__c;
            kpi.KPI_h_Membership_Business_Type__c = con.KPI_Membership_Business_Type__c;
            kpi.KPI_h_Membership_Renewal_Count__c = con.KPI_Membership_Renewal_Count__c;    
            
            kpi.KPI_h_FRM_Certified_Year__c = con.KPI_FRM_Certified_Year__c;
            kpi.KPI_h_FRM_Certified__c=con.KPI_FRM_Certified__c;
            kpi.KPI_h_FRM_Candidate__c=con.KPI_FRM_Candidate__c;
            kpi.KPI_h_FRM_Holder__c=con.KPI_FRM_Holder__c;   
            kpi.KPI_h_FRM_Cand_Payment_Lapsed_Months__c = con.KPI_FRM_Candidate_Payment_Lapsed_Months__c;
            kpi.KPI_h_FRM_Candidate_Payment_Status__c = con.KPI_FRM_Candidate_Payment_Status__c;         
            kpi.KPI_h_FRM_Candidate_Business_Type__c = con.KPI_FRM_Candidate_Business_Type__c;
            
            kpi.KPI_h_ERP_Certified__c=con.KPI_ERP_Certified__c;
            kpi.KPI_h_ERP_Candidate__c=con.KPI_ERP_Candidate__c;
            kpi.KPI_h_ERP_Holder__c=con.KPI_ERP_Holder__c;   
            kpi.KPI_h_ERP_Cand_Payment_Lapsed_Months__c = con.KPI_ERP_Candidate_Payment_Lapsed_Months__c;
            kpi.KPI_h_ERP_Candidate_Payment_Status__c = con.KPI_ERP_Candidate_Payment_Status__c;                                         
            kpi.KPI_h_ERP_Candidate_Business_Type__c = con.KPI_ERP_Candidate_Business_Type__c;
            
            kpi.KPI_h_ICBRR_Participant__c = con.KPI_ICBRR_Participant__c;
            kpi.KPI_h_ICBRR_Result__c = con.KPI_ICBRR_Result__c;
            kpi.KPI_h_FBR_Participant__c = con.KPI_FBR_Participant__c;    

            kpi.KPI_h_CPE_Participation__c = con.KPI_CPE_Participation__c;
            kpi.KPI_h_CPE_Requirement_Status__c = con.KPI_CPE_Requirement_Status__c;
            
            KPIHistoryList.add(kpi);            
        }
        
        return null;    
    }
    
}