global class updateFRM2withFRM1 implements Database.Batchable<sObject> 
{
    global List<ExamSiteids__c> examSiteIds = ExamSiteids__c.getall().values();

    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        List<Exam_Date__c > lstDate = Exam_Date__c.getAll().values();
        String strSection = lstDate[0].Name;
        String datExam = lstDate[0].Date_String__c;
        String StrDefered = 'Pending';
        String RADADA = 'Approved';
        String oppstatus = 'closed';
        String status = 'draft';
        Set<String> setSiteIds = new Set<String>();
     
      for(ExamSiteids__c examSite : examSiteIds)
      {
        setSiteIds.add(examSite.Name);
      }
             
        String query1 = 'SELECT Id,Exam_Site__c,Member__c,Exam_Site__r.Site__c,ADA_Status__c,RAD_Status__c,Opportunity_StageName__c ,Other_Exam_Registrations__c FROM Exam_Attempt__c Where Section__c =\''+strSection+'\'';
               query1 += ' AND Other_Exam_Registrations__c = NULL';
               query1 += ' AND Exam_Date__c ='+ datExam; 
               query1 += ' AND Opportunity_StageName__c =\''+oppstatus+'\'';                 
               query1 += ' AND  Cancelled__c != true'; 
               query1 += ' AND Defered__c !=\''+StrDefered+'\'';  
               query1 += ' AND  ADA_Status__c != \''+RADADA+'\''; 
               query1 += ' AND  RAD_Status__c != \''+RADADA+'\''; 
               query1 += ' AND  Exam_Site__r.Site__c in: setSiteIds'; 
               
         if(test.isRunningTest()){
            query1 = 'SELECT Id,Exam_Site__c,Exam_Site__r.Site__c,Member__c,Other_Exam_Registrations__c FROM Exam_Attempt__c Where Section__c =\''+strSection+'\'';
               query1 += ' AND Other_Exam_Registrations__c = NULL';
               query1 += ' AND Exam_Date__c ='+ datExam; 
               query1 += ' AND Defered__c !=\''+StrDefered+'\'';                 
               query1 += ' AND  Cancelled__c != true';
               query1 += ' AND  Candidate_Commitment__r.status !=\''+status+'\''; 
              // query1 += ' AND  Exam_Site__c =\''+strexsiteid+'\'';
              query1+= ' limit 10';
         }      
       
         return Database.getQueryLocator(query1);
    }
    global void execute(Database.BatchableContext ctx, List<Exam_Attempt__c> scope)
    {
        List<Exam_Date__c > lstDate = Exam_Date__c.getAll().values();
        String strSection = 'FRM Part 1';
        String datExam = lstDate[0].Date_String__c;
        
        Map<Id,String> mapMember = new Map<Id,String>();
        List<String> lstMember = new List<String>();
        Map<String,Id> mapExam2 = new Map<String,Id>();
        List<Exam_Attempt__c> objExmAttempt = new List<Exam_Attempt__c>();
        
        for(Exam_Attempt__c objList : scope)
        {
            mapMember.put(objList.Id,objList.Member__c);
            lstMember .add(objList.Member__c);        
        }
        
        List<Exam_Attempt__c> lstExam2 = [SELECT Id,Member__c,Cancelled__c,ADA_Status__c,Defered__c,RAD_Status__c,Opportunity_StageName__c FROM Exam_Attempt__c where Member__c in: lstMember AND Section__c =: strSection AND Exam_Date__c = 2015-11-21
        and Cancelled__c !=true and Defered__c!='Pending'and ADA_Status__c!= 'Approved' and RAD_Status__c != 'Approved' and Opportunity_StageName__c ='closed' and  Other_Exam_Registrations__c = ''];
        
         
        
        for(Exam_Attempt__c objExam2 : lstExam2)
        {
            mapExam2.put(objExam2.Member__c,objExam2.Id);
        } 
        for(Exam_Attempt__c objScope : scope)
        {
            if(mapExam2!= null && mapExam2.get(objScope.Member__c)!= null)
            {
               objScope.Other_Exam_Registrations__c = mapExam2.get(objScope.Member__c);
               Exam_Attempt__c eaSwap = new Exam_Attempt__c(id=objScope.Other_Exam_Registrations__c,Other_Exam_Registrations__c = objScope.Id);
               
               objExmAttempt.add(objScope);
                objExmAttempt.add(eaSwap);
               
            }
            
        
        }
        Database.saveresult[] SR = database.update(objExmAttempt, false);        
        
    }
    global void finish(Database.BatchableContext ctx)
    {
                
    }

    
}