@istest
public class ExamReports_test {
	
	static Contract contract;
    static Contract frmContract;
    static Contract mberContract;
    static Contract mberContract1;
    static Account account ;
    static Opportunity opportunity; 
    static Contact contact;
    static ChargentBase__Gateway__c chrgGtway;
    static Candidate_Requirement__c reqt;
    static Candidate_Requirement__c reqt1;
    static Candidate_Requirement__c reqt2;
    
    static void testData_1(){ 
            
        
        
    }
	
	static testMethod void unitTest_1(){
		
		testData_1();
		test.startTest();
        
        ExamReportsController erc = new ExamReportsController();

		List<SelectOption> lso = erc.ReportTypeList;
		lso = erc.ExamTypeList;
		lso = erc.ExamMonthList;
        lso = erc.ExamYearList;
    
        erc.reportTypeId = 'Exam Regitrations By Day Of Year';
        erc.selectType();

        erc.reportTypeId = 'ERP Exam Regitrations By Year';
        erc.selectType();
        
        erc.reportTypeId = '';
        erc.selectType();


        erc.reportTypeId = 'Exam Regitrations By Country';
		erc.goReport();        

        erc.reportTypeId = 'Exam Attendance By Country';
		erc.goReport();        

        erc.reportTypeId = 'Exam Regitrations By Day Of Year';
		erc.goReport();        
        
        erc.reportTypeId = 'Exam Regitrations By Type By Year';
		erc.goReport();        
        
        erc.reportTypeId = 'ERP Exam Regitrations By Year';
		erc.goReport();        
        
        erc.reportTypeId = 'FRM Exam Regitrations By Year';
		erc.goReport();        
       
        erc.includeUnPaid = false;
        erc.goReport();        
        
		test.stopTest();
		
	}

}