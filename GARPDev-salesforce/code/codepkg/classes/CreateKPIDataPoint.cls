global class CreateKPIDataPoint implements Database.Batchable<sObject>{

   global final String Query;
   global final String snapshotId;
   global CreateKPIDataPoint(String q,String sId){

      Query=q;
      snapshotId = sId;
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
    List<KPIDataPoint__c> lstToInsert = new List<KPIDataPoint__c>();
    
    for(sObject s :scope ){
            Contact c = (Contact)s;
            KPIDataPoint__c kpi = new KPIDataPoint__c();
                
                 kpi.KPI_Chapter_Associate_Director__c = c.KPI_Chapter_Associate_Director__c;
                 kpi.KPI_Chapter_Committee_Member__c = c.KPI_Chapter_Committee_Member__c;
                 kpi.KPI_Chapter_Director__c = c.KPI_Chapter_Director__c;
                 kpi.KPI_Chapter_Meeting_Speaker__c = c.KPI_Chapter_Meeting_Speaker__c;
                 kpi.KPI_CPE_Credits__c = c.KPI_CPE_Credits__c;
                 kpi.KPI_CPE_Current_Cycle__c = c.KPI_CPE_Current_Cycle__c;
                 kpi.KPI_CPE_Last_Completed_Cycle__c = c.KPI_CPE_Last_Completed_Cycle__c;
                 kpi.KPI_CPE_Participation__c = c.KPI_CPE_Participation__c;
                 kpi.KPI_CPE_Requirement_Status__c = c.KPI_CPE_Requirement_Status__c;
                 kpi.KPI_Current_Exam_Date__c = c.KPI_Current_Exam_Date__c;
                 kpi.KPI_Current_Exam_Location__c = c.KPI_Current_Exam_Location__c;
                 kpi.KPI_Current_Exam_Registration__c = c.KPI_Current_Exam_Registration__c;
                 kpi.KPI_Current_Exam_Registration_ADA__c = c.KPI_Current_Exam_Registration_ADA__c;
                 kpi.KPI_Current_Exam_Reg_Business_Type__c = c.KPI_Current_Exam_Reg_Business_Type__c;
                 kpi.KPI_Current_Exam_Registration_RA__c = c.KPI_Current_Exam_Registration_RA__c;
                 kpi.KPI_Current_Exam_Reg_Scholarship__c = c.KPI_Current_Exam_Reg_Scholarship__c;
                 kpi.KPI_Current_Exam_Registration_Type__c = c.KPI_Current_Exam_Registration_Type__c;
                 kpi.KPI_ERP_Candidate__c = c.KPI_ERP_Candidate__c;
                 kpi.KPI_ERP_Candidate_Business_Type__c = c.KPI_ERP_Candidate_Business_Type__c;
                 kpi.KPI_ERP_Candidate_Payment_Lapsed_Months__c = c.KPI_ERP_Candidate_Payment_Lapsed_Months__c;
                 kpi.KPI_ERP_Candidate_Payment_Status__c = c.KPI_ERP_Candidate_Payment_Status__c;
                 kpi.KPI_ERP_Certified__c = c.KPI_ERP_Certified__c;
                 kpi.KPI_ERP_Certified_Date__c = c.KPI_ERP_Certified_Date__c;
                 kpi.KPI_ERP_Certified_Year__c = c.KPI_ERP_Certified_Year__c;
                 kpi.KPI_ERP_Enrollment_Date__c = c.KPI_ERP_Enrollment_Date__c;
                 kpi.KPI_FRM_Holder__c = c.KPI_FRM_Holder__c;
                 kpi.KPI_GARP_Board_Member__c= c.KPI_GARP_Board_Member__c;
                 kpi.KPI_GARP_Committee_Member__c = c.KPI_GARP_Committee_Member__c;
                 kpi.KPI_ICBRR_Participant__c = c.KPI_ICBRR_Participant__c;
                 kpi.KPI_ICBRR_Result__c = c.KPI_ICBRR_Result__c;
                 kpi.KPI_Item_Writer__c = c.KPI_Item_Writer__c;
                 kpi.KPI_J_Wiley__c = c.KPI_J_Wiley__c;
                 kpi.KPI_Last_Exam_Check_In__c  = c.KPI_Last_Exam_Check_In__c;
                 kpi.KPI_Last_Exam_Date__c  = c.KPI_Last_Exam_Date__c;
                 kpi.KPI_Last_Exam_Location__c = c.KPI_Last_Exam_Location__c;
                 kpi.KPI_Last_Exam_Registration__c = c.KPI_Last_Exam_Registration__c;
                 kpi.KPI_Last_Exam_Registration_ADA__c  = c.KPI_Last_Exam_Registration_ADA__c;
                 kpi.KPI_Last_Exam_Registration_RA__c = c.KPI_Last_Exam_Registration_RA__c;
                 kpi.KPI_Last_Exam_Registration_Scholarship__c = c.KPI_Last_Exam_Registration_Scholarship__c;
                 kpi.KPI_Last_Exam_Registration_Type__c = c.KPI_Last_Exam_Registration_Type__c;
                 kpi.KPI_Last_Exam_Result__c= c.KPI_Last_Exam_Result__c;
                 kpi.KPI_Last_Exam_Violation__c= c.KPI_Last_Exam_Violation__c;
                 kpi.KPI_Member__c= c.KPI_Member__c;
                 kpi.KPI_Membership_Auto_Renew_Orig_Status__c= c.KPI_Membership_Auto_Renew_Orig_Status__c;
                 kpi.KPI_Membership_Auto_Renew_Status__c= c.KPI_Membership_Auto_Renew_Status__c;
                 kpi.KPI_Membership_Business_Type__c= c.KPI_Membership_Business_Type__c;
                 kpi.KPI_Membership_Expiration_Date__c= c.KPI_Membership_Expiration_Date__c;
                 kpi.KPI_Membership_Original_Business_Type__c = c.KPI_Membership_Original_Business_Type__c;
                 kpi.KPI_Membership_Original_Source__c= c.KPI_Membership_Original_Source__c;
                 kpi.KPI_Membership_Original_Type__c= c.KPI_Membership_Original_Type__c;
                 kpi.KPI_Membership_Payment_Lapsed_Months__c= c.KPI_Membership_Payment_Lapsed_Months__c;
                 kpi.KPI_Membership_Payment_Status__c= c.KPI_Membership_Payment_Status__c;
                 kpi.KPI_Membership_Renewal_Count__c = c.KPI_Membership_Renewal_Count__c;
                 kpi.KPI_Membership_Renewal_Type__c = c.KPI_Membership_Renewal_Type__c;
                 kpi.KPI_Membership_Since__c= c.KPI_Membership_Since__c;
                 kpi.KPI_Membership_Source__c= c.KPI_Membership_Source__c;
                 kpi.KPI_Proctor__c = c.KPI_Proctor__c;
                 kpi.KPI_Proctor_Supervisor__c= c.KPI_Proctor_Supervisor__c;
                 kpi.KPI_ERP_Holder__c = c.KPI_ERP_Holder__c;
                 kpi.KPI_Event_Speaker__c = c.KPI_Event_Speaker__c;
                 kpi.KPI_FBR_Participant__c = c.KPI_FBR_Participant__c;
                 kpi.KPI_FRM_Candidate__c = c.KPI_FRM_Candidate__c;
                 kpi.KPI_FRM_Candidate_Business_Type__c = c.KPI_FRM_Candidate_Business_Type__c;
                 kpi.KPI_FRM_Candidate_Payment_Lapsed_Months__c = c.KPI_FRM_Candidate_Payment_Lapsed_Months__c;
                 kpi.KPI_FRM_Candidate_Payment_Status__c = c.KPI_FRM_Candidate_Payment_Status__c; 
                 kpi.KPI_FRM_Certified__c = c.KPI_FRM_Certified__c;
                 kpi.KPI_FRM_Certified_Date__c = c.KPI_FRM_Certified_Date__c; 
                 kpi.KPI_FRM_Certified_Year__c = c.KPI_FRM_Certified_Year__c;
                 kpi.KPI_FRM_Enrollment_Date__c = c.KPI_FRM_Enrollment_Date__c;
                 kpi.Name__c =c.id;
                 kpi.Snapshot__c = snapshotId;
                 
            lstToInsert.add(kpi);
    }
    
        insert lstToInsert;
     
    }

   global void finish(Database.BatchableContext BC){
   }
}