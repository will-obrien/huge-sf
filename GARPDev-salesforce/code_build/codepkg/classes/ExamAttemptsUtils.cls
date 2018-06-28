public class ExamAttemptsUtils
{
    public static boolean isRecursive = false;
    public static boolean isUpdatedOtherReg = false;
    
    public static void onBeforeUpdate(Map<Id,Exam_Attempt__c> oldMap,List<Exam_Attempt__c> lstNewRecords)
    {
        isRecursive = true;
        Set<ID> setContacts = new Set<Id>();
        Map<Id,Id> mapSwapExamSites = new Map<Id,Id>();
        Set<Id> setICBRRs = new Set<ID>();
        Set<Id> setContracts = new Set<Id>();
        for(Exam_Attempt__c eAttempt : lstNewRecords)
        {
            setContracts.add(eAttempt.Candidate_Commitment__c);

        }
        Map<Id,Exam_Attempt__c> mapOtherEA = new Map<Id,Exam_Attempt__c>();
        for(Exam_Attempt__c obj1 : [select id,Candidate_Commitment__c,Section__c,Defered__c,Exam_Site__r.Site__c from Exam_Attempt__c 
                                        where Candidate_Commitment__c in: setContracts and 
                                        Section__c =: 'FRM Part 2' and Defered__c =: 'Approved' ORDER BY Exam_Date__c DESC])
        {
                if(!mapOtherEA.containsKey(obj1.Candidate_Commitment__c))
                    mapOtherEA.put(obj1.Candidate_Commitment__c,obj1);

        }
        system.debug('mapOtherEA == '+mapOtherEA);
        for(Exam_Attempt__c objEA : lstNewRecords)
        {
        system.debug('objEA == '+objEA);
            if(objEA.Section__c == 'FRM Part 2')
            {
                if(objEA.Result__c == 'Pass' || objEA.Result__c == 'Fail' || objEA.Result__c == 'No-Show')
                
                    setContacts.add(objEA.Member__C);
            }
            if(objEA.Section__c == 'FRM Part 1')
            {

                if((objEA.Result__c == 'Fail' || objEA.Result__c == 'No-Show') && (mapOtherEA != null && mapOtherEA.size() > 0 && mapOtherEA.containsKey(objEA.Candidate_Commitment__c)))
                     mapSwapExamSites.put(mapOtherEA.get(objEA.Candidate_Commitment__c).Id,mapOtherEA.get(objEA.Candidate_Commitment__c).Exam_Site__r.Site__c);
            }
            system.debug('mapSwapExamSites == '+mapSwapExamSites);
            if(objEA.Section__c == 'ICBRR')
            {
                setICBRRs.add(objEA.Id);
            }
        
        }
        
        cloneRecords(lstNewRecords,mapSwapExamSites);
        validateExamAttempts(lstNewRecords,setContacts);
        if(setICBRRs.size() > 0)
        {
            createIcbrrRecords(setICBRRs);
            
        }
    
    }
    
    public static void onInsert(Map<Id,Exam_Attempt__c> oldMap,List<Exam_Attempt__c> lstNewRecords)
    {
        isRecursive = true;
        Set<Id> setICBRRs = new Set<ID>();
        for(Exam_Attempt__c objEA : lstNewRecords)
        {
            if(objEA.Section__c == 'ICBRR')
            {
                setICBRRs.add(objEA.Id);
            }
        
        }
        
        if(setICBRRs.size() > 0)
        {
            createIcbrrRecords(setICBRRs);
            
        }
    
    }
    
    public static void createIcbrrRecords(Set<Id> setEAIDS)
    {
         id icbrrRecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract','ICBRR Program');
        List<Exam_Attempt__c> lstExamAttempts = [select id,Name,Garp_Id__c,Candidate_Requirement__c,Member__r.FirstName,Member__r.Middle_Initial__c,Candidate_Commitment__c,ClientAuthorizationID__c,Member__r.LastName,Member__r.Suffix__c,Member__r.MailingCity,Member__r.MailingCountry,Member__r.MailingPostalCode,Member__r.MailingState,Member__r.MailingStreet,Member__r.Salutation,Member__r.Phone,Member__r.Email,Candidate_Commitment__r.StartDate,Opportunity__r.GARP_Invoice_Number__c,Candidate_Commitment__r.EndDate  from Exam_Attempt__c where Candidate_Commitment__r.RecordTypeid =: icbrrRecordTypeId and Id in: setEAIDS];
        contractUtil.createIcbrrExport(lstExamAttempts,null);
    }
    
    public static void cloneRecords(List<Exam_Attempt__c> lstNewRecords,Map<Id,Id> mapSwapExamSites)
    {
        if(mapSwapExamSites.size() <= 0) return;
        try
        {   
            Exam_Sites__c objSite = [select id,name,Exam_Site_Code_idetifier__c from Exam_Sites__c where Site__c in : mapSwapExamSites.values() and Exam__r.Exam__c =: 'FRM Part 1'];
            Exam_Sites__c objUpdateSite = [select id,name,Exam_Site_Code_idetifier__c from Exam_Sites__c where Exam_Site_Code_idetifier__c =: objSite.Exam_Site_Code_idetifier__c and Exam__r.Exam_Group__r.Active__c =: true];
            List<Exam_Attempt__c> lstUpdateEAS = [select id,Exam_Site__c,Cancelled__c,Name,Candidate_Commitment__c,Candidate_Requirement__c,Checked_In__c,Exam_Date__c,hasViolation__c,Member__c,MemberExamAttempt__c,Other_Exam_Deferred__c,Other_Exam_Registration_Results__c,Other_Exam_Registrations__c,Other_Exam_Site__c,Program__c,Result__c,Room__c,Seat_No__c,Section__c,Session__c,Site__c,Unique__c from Exam_Attempt__c where id in: mapSwapExamSites.keySet()];
            List<Exam_Attempt__c> lstClonedRec = new List<Exam_Attempt__c>();
            Set<Id> setCRS = new Set<Id>();
            for(Exam_Attempt__c objEA : lstUpdateEAS)
            {
                setCRS.add(objEA.Candidate_Commitment__c);

            }
            Map<Id,Id> mapProgramReq = new Map<Id,Id>();
            for(Candidate_Requirement__c objCR : [select id,name,Candidate_Commitment__c from Candidate_Requirement__c where Candidate_Commitment__c in: setCRS and Name =: 'Pass FRM1'])
              mapProgramReq.put(objCR.Candidate_Commitment__c,objCR.Id);
                
            Exam_Attempt__c objCloned = new Exam_Attempt__c();
            for(Exam_Attempt__c obj : lstUpdateEAS)
            {
                objCloned = obj.clone(false,true,false,false);
                if(objUpdateSite.Id != null)
                  objCloned.Exam_Site__c = objUpdateSite.Id;
                else
                  objCloned.No_Exam_Site_Found__c = true;
                objCloned.Candidate_Requirement__c = (mapProgramReq != null && mapProgramReq.size() > 0 ? mapProgramReq.get(obj.Candidate_Commitment__c) :null);
                lstClonedRec.add(objCloned);
                
                obj.Cancelled__c = true;
                lstClonedRec.add(obj);
            }
            
            upsert lstClonedRec;
        }
        catch(Exception ex)
        {
        
        }
    }
    
    
    public static void updateFRM(List<Exam_Attempt__c> lstNewRecords,Map<Id,Id> mapSwapExamSites)
    {
        if(mapSwapExamSites.size() <= 0) return;
        try
        {
            Exam_Sites__c objSite = [select id,name from Exam_Sites__c where Site__c in : mapSwapExamSites.values() and Exam__r.Exam__c =: 'FRM Part 1'];
            List<Exam_Attempt__c> lstUpdateEAS = [select id,name,Exam_Site__c,Candidate_Requirement__c from Exam_Attempt__c where id in: mapSwapExamSites.keySet()];
            for(Exam_Attempt__c obj : lstUpdateEAS)
            {
                if(mapSwapExamSites.containsKey(obj.Id))
                    obj.Exam_Site__c = objSite.Id;
            }
            
            update lstUpdateEAS;
        }
        catch(Exception ex)
        {
        
        }
    }
    
    public static void validateExamAttempts(List<Exam_Attempt__c> lstNewRecords,Set<ID> setContacts)
    {
        system.debug('lstNewRecords ==' +lstNewRecords);
        //Map<Id,true> mapShowErrors
        if(setContacts.size() <= 0) return;
        //Map to check FRM part 1 results and throw errors
        Map<Id,boolean> mapResults = new Map<Id,boolean>();
        for(Exam_Attempt__c obj : [select id,Result__c,Section__c,Member__c from Exam_Attempt__c where Member__c in: setContacts and Section__c =: 'FRM Part 1' and Result__c =: null])
        {
            
            mapResults.put(obj.Member__c,true);
        }
        if(mapResults.size() <= 0) return;
        for(Exam_Attempt__c objEA : lstNewRecords)
        {
            if( mapResults.get(objEA.Member__c) == NULL ) system.debug(logginglevel.ERROR, '* * * In ExamAttemptsUtils:validateExamAttempts... caught exception objEAe is.. '+objEA);
            if(mapResults.get(objEA.Member__c))
                objEA.addError('Please select results in FRM Part 1');
        }
    
    }
}