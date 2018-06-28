public class AutoCandidateGeneration
{
    public static void AddCandidateId(List<Exam_Attempt__c> lstEA)
    {
        // /Candidate_ID__c
        //Exam_Site__c
        Set<Id> setExamSites = new Set<Id>();
        for(Exam_Attempt__c objEA : lstEA)
                setExamSites.add(objEA.Exam_Site__c);


        Map<String,Decimal> mapMaxCandNumber = new Map<String,Decimal>();

        AggregateResult[] groupedResults = [select Exam_Site__c,MAX(Candidate_ID__c) from Exam_Attempt__c where Exam_Site__c in : setExamSites GROUP BY Exam_Site__c];
        
        for (AggregateResult ar : groupedResults)  {
            System.debug('Exam Site ID' + ar.get('Exam_Site__c'));
            System.debug('MAX Candidate' + ar.get('expr0'));
            mapMaxCandNumber.put(String.valueOf(ar.get('Exam_Site__c')),Integer.valueOf(ar.get('expr0')));
        }
        
        system.debug('mapMaxCandNumber == '+mapMaxCandNumber);

        for(Exam_Attempt__c objUpd : lstEA)
        {
            Decimal iVal = 0.0;
            if(mapMaxCandNumber.containsKey(objUpd.Exam_Site__c))
            {
                iVal = mapMaxCandNumber.get(objUpd.Exam_Site__c) == null ? 0 : mapMaxCandNumber.get(objUpd.Exam_Site__c);
                
            }
            
            objUpd.Candidate_ID__c = iVal + 1;
            mapMaxCandNumber.put(objUpd.Exam_Site__c,objUpd.Candidate_ID__c);


        }



    }


}