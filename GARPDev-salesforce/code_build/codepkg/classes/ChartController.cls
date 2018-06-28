public class ChartController {

    public String FRMOneAndTwoData {get; set;}
    public String FRMTwoData {get;set;}
    public String FRMOneData {get;set;}
    public String ERPData {get;set;}
    public String ERPRegStatusData {get;set;}
    public String FRMOneRegStatusData {get;set;}
    public String FRMTwoRegStatusData {get;set;}
    public String CandidateByCountryData {get;set;}

 

    public List<AggregateResult> FRMOneAndTwoData() {

        return 
        
         [SELECT 
            
            COUNT(KPI_Current_Exam_Registration__c) FRMOneAndTwo,

            CALENDAR_MONTH (KPI_Current_Exam_Registration_Date__c) FRMOneAndTwoMonth
                  
             FROM Contact

             WHERE KPI_Current_Exam_Registration__c = 'FRM Part 1 & FRM Part 2'

             GROUP BY CALENDAR_MONTH(KPI_Current_Exam_Registration_Date__c)

             ORDER BY CALENDAR_MONTH(KPI_Current_Exam_Registration_Date__c)];
             
           
    }
    
    public List<AggregateResult> FRMTwoData() {

        return

            [SELECT COUNT(KPI_Current_Exam_Registration__c) FRMTwo,

                  CALENDAR_MONTH(KPI_Current_Exam_Registration_Date__c) FRMTwoMonth

             FROM Contact

             WHERE KPI_Current_Exam_Registration__c = 'FRM Part 2' 

             GROUP BY CALENDAR_MONTH(KPI_Current_Exam_Registration_Date__c)

             ORDER BY CALENDAR_MONTH(KPI_Current_Exam_Registration_Date__c)];

    }
    
     public List<AggregateResult> FRMOneData() {

        return

            [SELECT COUNT(KPI_Current_Exam_Registration__c) FRMOne,

                  CALENDAR_MONTH(KPI_Current_Exam_Registration_Date__c) FRMOneMonth

             FROM Contact

             WHERE KPI_Current_Exam_Registration__c = 'FRM Part 1' 

             GROUP BY CALENDAR_MONTH(KPI_Current_Exam_Registration_Date__c)

             ORDER BY CALENDAR_MONTH(KPI_Current_Exam_Registration_Date__c)];

    }
    
     public List<AggregateResult> ERPData() {

        return

            [SELECT COUNT(KPI_Current_Exam_Registration__c) ERP,

                  CALENDAR_MONTH(KPI_Current_Exam_Registration_Date__c) ERPMonth

             FROM Contact

             WHERE KPI_Current_Exam_Registration__c = 'ERP' 

             GROUP BY CALENDAR_MONTH(KPI_Current_Exam_Registration_Date__c)

             ORDER BY CALENDAR_MONTH(KPI_Current_Exam_Registration_Date__c)];

    }
    
     public List<AggregateResult> ERPRegStatusData() {

        return

            [SELECT COUNT(KPI_Current_Exam_Registration__c) ERPRegStatus,
                    COUNT(KPI_Current_Exam_Registration_Type__c) ERPStat1,
                    CALENDAR_MONTH(KPI_Current_Exam_Registration_Date__c) ERPMonth

             FROM Contact

             WHERE KPI_Current_Exam_Registration__c = 'ERP' AND ( KPI_Current_Exam_Registration_Type__c = 'Early' OR
             
             KPI_Current_Exam_Registration_Type__c = 'Standard' OR KPI_Current_Exam_Registration_Type__c = 'Late' )

             GROUP BY CALENDAR_MONTH(KPI_Current_Exam_Registration_Date__c)

             ORDER BY CALENDAR_MONTH(KPI_Current_Exam_Registration_Date__c)];

    } 
    
	public List<AggregateResult> FRMOneRegStatusData() {

        return

            [SELECT COUNT(KPI_Current_Exam_Registration__c) FRMOneRegStatus,
                    COUNT(KPI_Current_Exam_Registration_Type__c) FRMOneStat1,
                    CALENDAR_MONTH(KPI_Current_Exam_Registration_Date__c) FRMOneMonth

             FROM Contact

             WHERE KPI_Current_Exam_Registration__c = 'FRM Part 1' AND ( KPI_Current_Exam_Registration_Type__c = 'Early' OR
             
             KPI_Current_Exam_Registration_Type__c = 'Standard' OR KPI_Current_Exam_Registration_Type__c = 'Late' )
             
             GROUP BY CALENDAR_MONTH(KPI_Current_Exam_Registration_Date__c)

             ORDER BY CALENDAR_MONTH(KPI_Current_Exam_Registration_Date__c)];

    }
    
    public List<AggregateResult> FRMTwoRegStatusData() {

        return

            [SELECT COUNT(KPI_Current_Exam_Registration__c) FRMTwoRegStatus,
                    COUNT(KPI_Current_Exam_Registration_Type__c) FRMTwoStat1,
                    CALENDAR_MONTH(KPI_Current_Exam_Registration_Date__c) FRMTwoMonth

             FROM Contact

             WHERE KPI_Current_Exam_Registration__c = 'FRM Part 2' AND ( KPI_Current_Exam_Registration_Type__c = 'Early' OR
             
             KPI_Current_Exam_Registration_Type__c = 'Standard' OR KPI_Current_Exam_Registration_Type__c = 'Late' )

             GROUP BY CALENDAR_MONTH(KPI_Current_Exam_Registration_Date__c)

             ORDER BY CALENDAR_MONTH(KPI_Current_Exam_Registration_Date__c)];

    }
    
    public List<AggregateResult> CandidateByCountryData() {

        return

             
             [SELECT COUNT(MailingCountry) Country,
                     COUNT(KPI_Current_Exam_Registration_Type__c) ExamName,
                     CALENDAR_YEAR(KPI_Current_Exam_Registration_Date__c) ExamYear

             FROM Contact

             WHERE (KPI_Current_Exam_Registration__c = 'FRM Part 1' OR KPI_Current_Exam_Registration__c = 'FRM Part 2' 
             
             OR KPI_Current_Exam_Registration__c = 'ERP')
             
             GROUP BY CALENDAR_YEAR(KPI_Current_Exam_Registration_Date__c)

             ORDER BY CALENDAR_YEAR(KPI_Current_Exam_Registration_Date__c)];

    } 
    
   
    
     }