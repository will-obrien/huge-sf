public with sharing class FRMOneCountByYearController {

    public Summary[] Summaries {get;set;}
   
    
    public FRMOneCountByYearController() {
        AggregateResult[] results = [
           SELECT Sum(No_of_Exam_Attempts__c) Exam,

           CALENDAR_YEAR(Exam_Date__c) Year

             FROM Exam_Sites__c

             WHERE (Exam__r.Exam__c= 'FRM Part 1') 

            GROUP BY CALENDAR_YEAR(Exam_Date__c)

            ORDER BY CALENDAR_YEAR(Exam_Date__c)
        ];
        
         Summaries = new List<Summary>();
        for (AggregateResult ar : results ) {
            System.debug('Average amount' + ar.get('Exam'));
            Summary sum = new Summary();
            sum.Exam = integer.valueof(ar.get('Exam'));
            sum.Year = integer.valueof(ar.get('Year'));
            Summaries.add(sum);
        }
        
   }

    // wrapper class to hold aggregate data
    public class Summary {
        public Integer Exam{get; set; }
        public Integer Year{ get; set; }
       

       
        
       
    }

}