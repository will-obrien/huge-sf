public class SampleClass{

    public String data { get; set; }

    public List<AggregateResult> Sample() {

        return 

            [SELECT COUNT(KPI_Membership_Business_Type__c) ConMem,

                  CALENDAR_MONTH(KPI_Membership_Since__c) MemStartMonth
                  
             FROM Contact

             WHERE KPI_Membership_Business_Type__c= 'Individual' 

             GROUP BY CALENDAR_MONTH(KPI_Membership_Since__c)

             ORDER BY CALENDAR_MONTH(KPI_Membership_Since__c)];

    }
    }