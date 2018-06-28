public class Milestone1_Clone_Utility {

    public static Milestone1_Project__c cloneProject(Milestone1_Project__c rec){
        Milestone1_Project__c newRec = rec.clone(false);
        newRec.ImportID__c = rec.Id;
        return newRec;
    }
    
    public static Map<String, Milestone1_Milestone__c> cloneMilestonesIntoMap(List<Milestone1_Milestone__c> recs){
        Map<String, Milestone1_Milestone__c> recMap = new Map<String, Milestone1_Milestone__c>();
        for(Milestone1_Milestone__c rec : recs){
            Milestone1_Milestone__c newRec = rec.clone(false);
            newRec.ImportID__c = rec.Id;
            recMap.put(rec.Id, newRec);
        }
        return recMap;
    }
    
    public static List<Milestone1_Task__c> cloneTasksIntoList(List<Milestone1_Task__c> recs){
        List<Milestone1_Task__c> newRecs = new List<Milestone1_Task__c>();
        for(Milestone1_Task__c rec : recs){
            Milestone1_Task__c newRec = rec.clone(false);
            newRecs.add(newRec);
        }
        return newRecs;
    }
    
    public static Map<String, Milestone1_Task__c> cloneTasksIntoMap(List<Milestone1_Task__c> recs){
        Map<String, Milestone1_Task__c> recMap = new Map<String, Milestone1_Task__c>();
        for(Milestone1_Task__c rec : recs){
            Milestone1_Task__c newRec = rec.clone(false);
            newRec.ImportID__c = rec.Id;
            recMap.put(rec.Id, newRec);
        }
        return recMap;
    }

}