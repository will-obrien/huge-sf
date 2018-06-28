public class examGroupUtils
{
    public static boolean isRecursive = false;
    public static void onAfterUpdate(List<Exam_Group__c> lstExamGroups)
    {
        Date dtExamDate;
        Set<ID> setExamGroups = new Set<Id>();
        for(Exam_Group__c obj : lstExamGroups)
        {
            if(obj.Active__c)
            {
                dtExamDate = obj.Exam_Date__c;
                setExamGroups.add(obj.Id);
                
            }}
        if(setExamGroups.size() <= 0 ) return;
        List<Exam_Group__c> lstInaciveExamGroups = [select id,name,Exam_Date__c,Cloned_From__c from Exam_Group__c where Active__c =: false and Exam_Date__c <: dtExamDate order by Exam_Date__c desc];
        if(lstInaciveExamGroups == null || lstInaciveExamGroups.size() <= 0 ) return;
        Exam_Group__c previousGroup = lstInaciveExamGroups[0];
        setExamGroups.add(previousGroup.Id);
        List<Exam_Attempt__c> lstExamAttempts = [select id,Exam_Site__c,Defered__c,Exam_Site__r.Exam__r.Exam_Group__c,Exam_Site__r.Exam__r.Exam_Group__r.Active__c,Exam_Site__r.Exam_Site_Code_idetifier__c from Exam_Attempt__c where Exam_Site__r.Exam__r.Exam_Group__c =: previousGroup.Id and Defered__c = 'Pending' ];
        String strActiveIdentifier;
        String strInActiveIndentifier;
        Id activeExamSite;
        Set<ID> setExamAttemptstoUpdate = new Set<ID>();
        Map<String,Id> mapOldSiteCodes = new Map<String,Id>();
        Map<String,Id> mapNewSiteCodes = new Map<String,Id>();
        for(Exam_Attempt__c obj : lstExamAttempts)  
        {
           
            if(!obj.Exam_Site__r.Exam__r.Exam_Group__r.Active__c && obj.Defered__c == 'Pending')
            {
                mapOldSiteCodes.put(obj.Exam_Site__r.Exam_Site_Code_idetifier__c,obj.Exam_Site__c);
            
            }
            
        }
        for(Exam_sites__c  objSite : [select id,name,Exam_Site_Code_idetifier__c from Exam_sites__c where Exam__r.Exam_Group__c in: setExamGroups])
        {
            mapNewSiteCodes.put(objSite.Exam_Site_Code_idetifier__c,objSite.Id);
        }
       
        List<Exam_Attempt__c> lstToUpdate = new List<Exam_Attempt__c>();
        for(Exam_Attempt__c obj : lstExamAttempts)  
        {
            
            if(!obj.Exam_Site__r.Exam__r.Exam_Group__r.Active__c)
            {
        
                obj.Exam_Site__c =  mapNewSiteCodes.get(obj.Exam_Site__r.Exam_Site_Code_idetifier__c);
                obj.Defered__c = 'Approved';
                lstToUpdate.add(obj);
                    
            }}
        isRecursive = true;
        update lstToUpdate;
        }}