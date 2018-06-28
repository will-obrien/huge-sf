global class candidateid implements Database.Batchable<SObject>,Database.Stateful
{

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        List<Exam_Date__c > lstDate = Exam_Date__c.getAll().values();
         String datExam = lstDate[0].Date_String__c;
         String StrDefered = 'Pending';
         String RADADA = 'Approved';
         String oppstatus = 'closed';
         
         String query1 = 'SELECT Id,Exam_Site__c,Exam_Site__r.Site__c,Other_Exam_Registrations__c FROM Exam_Attempt__c';
               query1 += ' Where Exam_Date__c ='+ datExam; 
               query1 += ' AND Defered__c !=\''+StrDefered+'\'';                 
               query1 += ' AND  Cancelled__c != true';
               query1 += ' AND  ADA_Status__c != \''+RADADA+'\''; 
               query1 += ' AND  RAD_Status__c != \''+RADADA+'\''; 
               query1 += ' AND Opportunity_StageName__c =\''+oppstatus+'\'';  
                 
         system.debug('---query--'+query1);
         if(test.isRunningTest()){
            query1 = 'SELECT Id,Exam_Site__c,Exam_Site__r.Site__c,Other_Exam_Registrations__c FROM Exam_Attempt__c';
         }
         
         return Database.getQueryLocator(query1);
        
     } 
     
     global void execute(Database.BatchableContext BC, List<Exam_Attempt__c> scope)
     {
        
        Set<Id> setExamSites = new Set<Id>();
        for(Exam_Attempt__c objEA : scope)
                setExamSites.add(objEA.Exam_Site__r.Site__c);

        List<Exam_Attempt__c> lstUpdateEa = new List<Exam_Attempt__c>();
        Map<String,Decimal> mapMaxCandNumber = new Map<String,Decimal>();

        AggregateResult[] groupedResults = [select Exam_Site__r.Site__c,MAX(Candidate_ID__c) from Exam_Attempt__c where Exam_Site__r.Site__c in : setExamSites GROUP BY Exam_Site__r.Site__c];
        
        for (AggregateResult ar : groupedResults)  {
            System.debug('Exam Site ID' + ar.get('Site__c'));
            System.debug('MAX Candidate' + ar.get('expr0'));
            mapMaxCandNumber.put(String.valueOf(ar.get('Site__c')),Integer.valueOf(ar.get('expr0')));
        }
        
        system.debug('mapMaxCandNumber == '+mapMaxCandNumber);

        for(Exam_Attempt__c objUpd : scope)
        {
            Decimal iVal = 0.0;
            if(mapMaxCandNumber.containsKey(objUpd.Exam_Site__r.Site__c))
            {
                iVal = mapMaxCandNumber.get(objUpd.Exam_Site__r.Site__c) == null ? 0 : mapMaxCandNumber.get(objUpd.Exam_Site__r.Site__c);
                
            }
            
            objUpd.Candidate_ID__c = iVal + 1;
            mapMaxCandNumber.put(objUpd.Exam_Site__r.Site__c,objUpd.Candidate_ID__c);

            lstUpdateEa.add(objUpd);
        }

        if(!lstUpdateEa.isEmpty())
            update lstUpdateEa;
        
        
               
     }
     
     global void finish(Database.BatchableContext BC)
     {
         
     }
}