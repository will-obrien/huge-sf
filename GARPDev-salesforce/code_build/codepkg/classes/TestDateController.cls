public with sharing class TestDateController {
      
    public class DateWrapper {
        public Date examDate { get; set; }
        public DateTime examDateTime { get; set; }
        
        public DateWrapper(Date examDat, DateTime examDateTim) {
        	this.examDate = examDat;
            this.examDateTime = examDateTim;
        }
       
    }
        
    @RemoteAction
    public static DateWrapper getTestDates() {
        Date examDate = [SELECT Exam_Date__c  from Exam_Group__c 
            where id='a0Bf00000029Kys'].Exam_Date__c;
        System.debug('Date is ' + examDate);
        DateTime examDateTime = DateTime.newInstance(examDate.year(), 
                                                     examDate.month(),
                                                     examDate.day());
        System.debug('DateTime is ' + examDateTime);
        System.debug('epoch is ' + examDateTime.getTime());
        return new DateWrapper(examDate, examDateTime); 
        
    }
    
    
	
}