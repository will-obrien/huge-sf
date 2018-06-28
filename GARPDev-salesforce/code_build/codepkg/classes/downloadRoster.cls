public class downloadRoster {
    public transient String input { public get; private set; }
    public transient String fileName { public get; private set; }
    
    public downloadRoster() {
    }
    
    public PageReference test() {
        fileName = 'roster.zip';
        
        Map<String,String> params = ApexPages.currentPage().getParameters();
        String proctorApplicationId = params.get('proctorApplicationId');
        List<Proctor_Registration__c> lstProctorRegistration = [select Id, Name, Test_Site__c, Last_Roster_Download_Date__c from Proctor_Registration__c where Id = :proctorApplicationId];
        if( lstProctorRegistration != null && lstProctorRegistration.size() > 0 ) { 

            List<Exam_Sites__c> lstExamSites = [Select Id, Name from Exam_Sites__c where Site__c = :lstProctorRegistration[0].Test_Site__c];
            
            List<Exam_Attempt__c> lstExamAttempt = [SELECT Id, Name, Cancelled__c,Candidate_ID__c,Candidate_Commitment__c, Candidate_Commitment__r.Opportunity__c, hasViolation__c, Checked_In__c, Result__c, Defered__c, Exam_Site__r.Exam__r.Name, Exam_Site__r.Exam__r.Exam__c, Exam_Site__r.Exam_Date__c, Exam_Site__r.Exam__r.Exam_Date__c, Exam_Site__r.Exam__r.Exam_Group__c, Exam_Site__r.Exam__r.Exam_Group__r.Active__c, Session__c, Member__r.GARP_ID__c, Member__r.name, Exam_Site__r.Site__r.Site_Code__c, Exam_Site__r.Site__r.Display_Address__c, Room__r.name, Seat_No__c FROM Exam_Attempt__c where Exam_Site__c in :lstExamSites];
            if( lstExamAttempt != null && lstExamAttempt.size() > 0 ) { 
                String csvData='';
                
                for(Exam_Attempt__c ea :lstExamAttempt){
                    csvData = csvData + ea.Member__r.GARP_ID__c + ',' + ea.Member__r.name + '\n';
                }
                input = csvData;
                
                lstProctorRegistration[0].Last_Roster_Download_Date__c = Date.today();
                update lstProctorRegistration;
            }
        }             
        return null;
    }
    
}