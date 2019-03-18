public class OpportunityScorecardHelper {
    public static void validateDuplicateOppScorecard(List<GCS_Acq_Opportunity_Scorecard__c> oppScorecardList){
        Set<Id> opportunityIds = new Set<Id>();
        for(GCS_Acq_Opportunity_Scorecard__c oppScorecard : oppScorecardList){
            if(oppScorecard.Opportunity__c != null){
                opportunityIds.add(oppScorecard.Opportunity__c);
            }   
        }
        
        Map<Id, GCS_Acq_Opportunity_Scorecard__c> oppScorecardMap = new Map<Id, GCS_Acq_Opportunity_Scorecard__c>();
        for(GCS_Acq_Opportunity_Scorecard__c oppScorecard : [SELECT Id, Name, Opportunity__c FROM GCS_Acq_Opportunity_Scorecard__c WHERE Opportunity__c IN :opportunityIds]){
            oppScorecardMap.put(oppScorecard.Opportunity__c, oppScorecard);
        }
        
        for (GCS_Acq_Opportunity_Scorecard__c oppScorecard: oppScorecardList){
            if(oppScorecardMap.containsKey(oppScorecard.Opportunity__c)){
                oppScorecard.addError('There can only be 1 scorecard record for each opportunity.  Please edit the existing scorecard record ' + oppScorecardMap.get(oppScorecard.Opportunity__c).Name + '.');
            }
        }
    }
    
    //Dynamic count field values which start with Q
    public static Map<Id, Integer> countTotalScore(List<GCS_Acq_Opportunity_Scorecard__c> oppScorecardList){
        Map<Id, Integer> mapTotalQuestionsAnswered = new Map<Id, Integer>();
        for(GCS_Acq_Opportunity_Scorecard__c oppScorecard : oppScorecardList){
            Integer totalQuestionsAnswered = 0;
            Integer totalScore = 0;     
            Map<String,Object> mapOpp = (Map<String,Object>)Json.deserializeUntyped(Json.serialize(oppScorecard));
            for (String key : mapOpp.keySet()) {        
                if (key.startsWithIgnoreCase('Q')){
                    Integer keyValue = Integer.valueOf(mapOpp.get(key));
                    totalScore += keyValue;
                    if(keyValue != null){
                        totalQuestionsAnswered++;
                    }
                }
            }
            oppScorecard.Total_Score__c = totalScore;
            mapTotalQuestionsAnswered.put(oppScorecard.Id, totalQuestionsAnswered);
        }
        return mapTotalQuestionsAnswered;
    }
    
    //Dynamic count field values which start with Q
    public static void countCompletionPercent(List<GCS_Acq_Opportunity_Scorecard__c> oppScorecardList, Map<Id, Integer> mapTotalQuestionsAnswered){
        Integer scoreFieldCount = OpportunityScorecardHelper.getScoreFieldCount();  
        for(GCS_Acq_Opportunity_Scorecard__c oppScorecard : oppScorecardList){
            Integer totalQuestionsAnswered = mapTotalQuestionsAnswered.get(oppScorecard.Id);
            oppScorecard.Completion__c = totalQuestionsAnswered * 100 / scoreFieldCount;
        }
    }
    
    private static Integer getScoreFieldCount(){
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('GCS_Acq_Opportunity_Scorecard__c').getDescribe().Fields.getMap();
        Integer scoreFieldCount = 0;
        for(String fld: fieldMap.keySet()){
            if(fld.startsWithIgnoreCase('Q')){
                scoreFieldCount++;
            }
        }
        return scoreFieldCount;
    }
    
    public static void setOwner(List<GCS_Acq_Opportunity_Scorecard__c> oppScorecardList){
        Set<Id> opportunityIds = new Set<Id>();
        for(GCS_Acq_Opportunity_Scorecard__c oppScorecard : oppScorecardList){
            if(oppScorecard.Opportunity__c != null){
                opportunityIds.add(oppScorecard.Opportunity__c);
            }   
        }
        
        Map<Id, Opportunity> opportunityOwnerMap = new Map<Id, Opportunity>([SELECT Id, OwnerId FROM Opportunity WHERE Id IN :opportunityIds]);
        for (GCS_Acq_Opportunity_Scorecard__c oppScorecard: oppScorecardList){
            if(opportunityOwnerMap.containsKey(oppScorecard.Opportunity__c)){
                oppScorecard.OwnerId = opportunityOwnerMap.get(oppScorecard.Opportunity__c).OwnerId;
            }
        }
    }
}