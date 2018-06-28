public class ViewPortalMemberExtension {
    
    public Contact contact {get; set;}   
    public PageData data {get;set;}
    public List<Exam_Attempt__c> examAttempts {get; set;} 
    
    private Map<Id, Contract> contractIdToContractsMap; 
    private List<OpportunityLineItem> secondCertLineItems;
          
    public ViewPortalMemberExtension(ApexPages.StandardController controller) {        
        if (!Test.isRunningTest()) {
            controller.addFields(new List<String> {'AccountId', 'KPI_FRM_Certified__c', 'KPI_FRM_Certified_Date__c', 'KPI_ERP_Certified__c', 'KPI_ERP_Certified_Date__c', 'KPI_ICBRR_Result__c'});
        } 
        contact = (Contact)controller.getRecord();       
        contractIdToContractsMap = new Map<Id, Contract>([SELECT Id, StartDate, EndDate, RecordType.DeveloperName, Certificate_Sent_Date__c,
                        (SELECT Id, Exam__c, Date_of_Completion__c, Status__c, Date_No_Two_Years__c, RecordType.DeveloperName FROM Contract.Candidate_Requirements__r) 
                        FROM Contract WHERE Status LIKE '%Activated%' AND AccountId = :contact.AccountId]);
        secondCertLineItems = [SELECT Id, Opportunity.CloseDate, Opportunity.ContractId, Opportunity.Contract.RecordType.DeveloperName, Opportunity.Tracking_Number__c
                                FROM OpportunityLineItem WHERE Product2.ProductCode='MISC' AND Description LIKE '%Certificate Replacement%' AND Opportunity.ContractId IN :contractIdToContractsMap.keySet()];
        examAttempts = [SELECT Id, Exam_Date__c, Exam_Site__r.Exam__c, Result__c, Exam_Site__r.Site__c, Opportunity__c, Opportunity__r.Display_Invoice_Number__c, Opportunity__r.StageName, 
                            Exam_Site__r.Exam__r.Exam__c, Scholarship_Status__c, ADA_Status__c, RAD_Status__c, hasViolation__c, Exam_Violation_Type__c FROM Exam_Attempt__c WHERE Member__c = :contact.id order by Exam_Date__c DESC];        
        
        data = new PageData();
        setPageData();
    }
    
    
    public void setPageData() {       
        setKPIFields();
        setContractInfo();
        setExamInfo();
        setCertReplacementInfo();
    }
    
    public void setKPIFields() {
        data.certifiedFRMStatus = contact.KPI_FRM_Certified__c ? 'yes' : '';
        data.certifiedFRMDate = formatmmddyyyy(contact.KPI_FRM_Certified_Date__c);
        data.certifiedERPStatus = contact.KPI_ERP_Certified__c ? 'yes' : '';
        data.certifiedERPDate = formatmmddyyyy(contact.KPI_ERP_Certified_Date__c);
    }
    
    public void setContractInfo() {
        for(Contract contract : contractIdToContractsMap.values()) {
            if (contract.RecordType.DeveloperName.containsIgnoreCase('FRM')){
                data.frmStartEnd = formatStartEndDate(contract.StartDate, contract.EndDate);
                data.frmOrigCertSentDate = formatmmddyyyy(contract.Certificate_Sent_Date__c); 
            } else if (contract.RecordType.DeveloperName.containsIgnoreCase('ERP')){
                data.frmStartEnd = formatStartEndDate(contract.StartDate, contract.EndDate);
                data.erpOrigCertSentDate = formatmmddyyyy(contract.Certificate_Sent_Date__c);
            } else if (contract.RecordType.DeveloperName.containsIgnoreCase('ICBRR')){
                data.icbrrStart = formatmmddyyyy(contract.StartDate);
                data.icbrrEnd = formatmmddyyyy(contract.EndDate);
                data.icbrrOrigCertSentDate = formatmmddyyyy(contract.Certificate_Sent_Date__c);
            } else if (contract.RecordType.DeveloperName.containsIgnoreCase('FBR')){
                data.fbrStart = formatmmddyyyy(contract.StartDate);
                data.fbrEnd = formatmmddyyyy(contract.EndDate);
            }
            for (Candidate_Requirement__c requirement : contract.Candidate_Requirements__r) {
                if (requirement.recordType.DeveloperName == 'Job_Experience') {
                    if (contract.RecordType.DeveloperName.containsIgnoreCase('FRM')){
                        data.frmCVReviewStatus = cleanseRequirementStatus(requirement.Status__c);
                        data.frmCVReviewDate = formatmmddyyyy(requirement.Date_Of_Completion__c);
                        data.frmLetterSent2years = formatmmddyyyy(requirement.Date_No_Two_Years__c);
                    } else if (contract.RecordType.DeveloperName.containsIgnoreCase('ERP')){
                        data.erpCVReviewStatus = cleanseRequirementStatus(requirement.Status__c);
                        data.erpCVReviewDate = formatmmddyyyy(requirement.Date_Of_Completion__c);
                        data.erpLetterSent2years = formatmmddyyyy(requirement.Date_No_Two_Years__c);
                    }
                }                                                  
            }
        }
    }
    
    public void setExamInfo() {             
        for (Exam_Attempt__c exam : examAttempts) {
            if (exam.Exam_Site__r.Exam__r.Exam__c == 'FRM Part 1') {
                data.frm1ExamStatus = cleanseExamResult(exam.Result__c);
                data.frm1ExamDate = formatmmddyyyy(exam.Exam_Date__c);
                data.isFRMScholarshipRecipient |= isApproved(exam.Scholarship_Status__c);
                data.isFRMADACandidate |= isApproved(exam.ADA_Status__c);
                data.isFRMRADCandidate |= isApproved(exam.RAD_Status__c);
                data.hasFRMExamViolation |= exam.hasViolation__c;
                data.frmExamViolationType = nvl(data.frmExamViolationType, exam.Exam_Violation_Type__c);
            } else if (exam.Exam_Site__r.Exam__r.Exam__c == 'FRM Part 2') {
                data.frm2ExamStatus = cleanseExamResult(exam.Result__c);
                data.frm2ExamDate = formatmmddyyyy(exam.Exam_Date__c);
                data.isFRMScholarshipRecipient |= isApproved(exam.Scholarship_Status__c);
                data.isFRMADACandidate |= isApproved(exam.ADA_Status__c);
                data.isFRMRADCandidate |= isApproved(exam.RAD_Status__c);
                data.hasFRMExamViolation |= exam.hasViolation__c;
                data.frmExamViolationType = nvl(data.frmExamViolationType, exam.Exam_Violation_Type__c);
            } else if (exam.Exam_Site__r.Exam__r.Exam__c == 'ERP') {
                data.erpExamStatus = cleanseExamResult(exam.Result__c);
                data.erpExamDate = formatmmddyyyy(exam.Exam_Date__c);
                data.isERPScholarshipRecipient |= isApproved(exam.Scholarship_Status__c);
                data.isERPADACandidate |= isApproved(exam.ADA_Status__c);
                data.isERPRADCandidate |= isApproved(exam.RAD_Status__c);
                data.hasERPExamViolation |= exam.hasViolation__c;
                data.erpExamViolationType = exam.Exam_Violation_Type__c;
            } else if (exam.Exam_Site__r.Exam__r.Exam__c == 'ICBRR') {
                data.certifiedICBRRStatus = cleanseExamResult(exam.Result__c);
                if (data.certifiedICBRRStatus == 'passed') {
                    data.certifiedICBRRDate = formatmmddyyyy(exam.Exam_Date__c);
                }
            }
        }
    }
    
    public void setCertReplacementInfo() {
        for (OpportunityLineItem oli : secondCertLineItems) {
            if (oli.opportunity.contract.RecordType.DeveloperName.containsIgnoreCase('FRM')){
                data.frmSecondCertSentUPSTrackNbr = oli.Opportunity.Tracking_Number__c;
                data.frmSecondCertSentUPSDate = formatmmddyyyy(oli.Opportunity.CloseDate); 
            } else if (oli.opportunity.contract.RecordType.DeveloperName.containsIgnoreCase('ERP')){
                data.erpSecondCertSentUPSTrackNbr = oli.Opportunity.Tracking_Number__c;
                data.erpSecondCertSentUPSDate = formatmmddyyyy(oli.Opportunity.CloseDate); 
            } else if (oli.opportunity.contract.RecordType.DeveloperName.containsIgnoreCase('ICBRR')){
                data.icbrrSecondCertSentUPSTrackNbr = oli.Opportunity.Tracking_Number__c;
                data.icbrrSecondCertSentUPSDate = formatmmddyyyy(oli.Opportunity.CloseDate); 
            }         
        }
    }
    
    public class PageData {
        public String certifiedFRMStatus {get;set;}
        public String certifiedFRMDate {get;set;}
        public String frm1ExamStatus {get;set;}
        public String frm1ExamDate {get;set;}
        public String frm2ExamStatus {get;set;}
        public String frm2ExamDate {get;set;}
        public String frmCVReviewStatus {get;set;}
        public String frmCVReviewDate {get;set;}
        public String frmOrigCertSentTrackNbr {get;set;}
        public String frmOrigCertSentDate {get;set;}
        public String frmSecondCertSentUPSTrackNbr {get;set;}
        public String frmSecondCertSentUPSDate {get;set;}
        public String frmLetterSent2years {get;set;}
        public String frmStartEnd {get;set;}
        public Boolean isFRMScholarshipRecipient {get;set;}
        public Boolean isFRMADACandidate {get;set;}
        public Boolean isFRMRADCandidate {get;set;}
        public Boolean hasFRMExamViolation {get;set;}
        public String frmExamViolationType {get;set;}
        
        public String certifiedERPStatus {get;set;}
        public String certifiedERPDate {get;set;}
        public String erpExamStatus {get;set;}
        public String erpExamDate {get;set;}
        public String erpCVReviewStatus {get;set;}
        public String erpCVReviewDate {get;set;}
        public String erpOrigCertSentTrackNbr {get;set;}
        public String erpOrigCertSentDate {get;set;}
        public String erpSecondCertSentUPSTrackNbr {get;set;}
        public String erpSecondCertSentUPSDate {get;set;}
        public String erpLetterSent2years {get;set;}
        public String erpStartEnd {get;set;}
        public Boolean isERPScholarshipRecipient {get;set;}
        public Boolean isERPADACandidate {get;set;}
        public Boolean isERPRADCandidate {get;set;}
        public Boolean hasERPExamViolation {get;set;}
        public String erpExamViolationType {get;set;}
        
        public String certifiedICBRRStatus {get;set;}
        public String certifiedICBRRDate {get;set;}
        public String icbrrStart {get;set;}
        public String icbrrEnd {get;set;}
        public String icbrrOrigCertSentTrackNbr {get;set;}
        public String icbrrOrigCertSentDate {get;set;}
        public String icbrrSecondCertSentUPSTrackNbr {get;set;}
        public String icbrrSecondCertSentUPSDate {get;set;}
        
        public String fbrStart {get;set;}
        public String fbrEnd {get;set;}
        
        public PageData() {
            isFRMScholarshipRecipient = false;
            isFRMADACandidate = false;
            isFRMRADCandidate = false;
            hasFRMExamViolation = false;
            isERPScholarshipRecipient = false;
            isERPADACandidate = false;
            isERPRADCandidate = false;
            hasERPExamViolation = false;
        }
    }
    
    public static String formatStartEndDate(Date startDate, Date endDate) {
         return formatmmddyyyy(startDate) + '  ' + formatmmddyyyy(endDate); 
    }
    
    public static String formatmmddyyyy(Date d) {
        if (d != null) {
            return datetime.newInstance(d.year(), d.month(), d.day()).format('MM/dd/YYYY');
        } else return '';       
    }
    
    public static String cleanseExamResult(String result) {
        if (result != null) {
            return result.containsIgnoreCase('pass') ? 'passed' : 'failed';
        } else return '';
        
    }
    
    public static String nvl(String s1, String s2) {
        if (s1 != null) return s1;
        return s2;
    }
    
    public static Boolean isApproved(String status) {
        return status == 'Approved';
    }
    
    public static String cleanseRequirementStatus(String status) {
        return status == 'Completed' ? 'passed' : '';
    }

}