public with sharing class FRMOneTwoRegCountMonthController {

    public Summary[] Summaries {get;set;}
   
    
    public FRMOneTwoRegCountMonthController () {
        AggregateResult[] results = [
           SELECT COUNT(KPI_Current_Exam_Registration__c) Exam,

                 Calendar_Month(KPI_Current_Exam_Registration_Date__c) Month

             FROM Contact

             WHERE (KPI_Current_Exam_Registration__c= 'FRM Part 1 & FRM Part 2') 

            GROUP BY Calendar_Month(KPI_Current_Exam_Registration_Date__c)

            ORDER BY Calendar_Month(KPI_Current_Exam_Registration_Date__c)
        ];
        
        Summaries = new List<Summary>();
        for (AggregateResult ar : results ) {
            Summaries .add(new Summary(ar));
        }
        
   }

    // wrapper class to hold aggregate data
    public class Summary {
        public Integer Exam{get; set; }
        public Integer Month{ get; set; }
       

        public Summary(AggregateResult ar) {
            Exam= (Integer) ar.get('Exam');
            Month= (Integer) ar.get('Month');
        }
        
       
    }

}