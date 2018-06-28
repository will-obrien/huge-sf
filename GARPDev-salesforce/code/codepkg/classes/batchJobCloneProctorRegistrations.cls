global class batchJobCloneProctorRegistrations implements Database.Batchable<sObject>,Database.StateFul{
    
    public String fromExamGroupId;  
    public String toExamGroupId;  
    public String testId;
    public MAP<String,ID> examSiteMap = new MAP<String,ID>();
    
    global batchJobCloneProctorRegistrations (String fromExamGroupId, String toExamGroupId, String testId){
        this.fromExamGroupId = fromExamGroupId;
        this.toExamGroupId = toExamGroupId;
        this.testId = testId;
        
        MAP<ID,String> testSiteMap = new MAP<ID,String>();
        List<Exam_Sites__c> lstExamSites = [Select Id, Name, Site__c, Exam__r.Exam_Group__c from Exam_Sites__c where Exam__r.Exam_Group__c = :toExamGroupId];
        for(Exam_Sites__c es :lstExamSites) {
            testSiteMap.put(es.Site__c,es.Name);
        }
        system.debug('testSiteMap:' + testSiteMap);
        
        List<Site__c> lstSite = [select Id, Name, Site_Code__c from Site__c where Id in :testSiteMap.keySet()];
        system.debug('lstSite:' + lstSite);
        
        for(Site__c site :lstSite) {
            examSiteMap.put(site.Site_Code__c, site.Id);
        }
        system.debug('examSiteMap:' + examSiteMap);
    }
     
   global Database.QueryLocator start(Database.BatchableContext BC){         
       //String testId = 'a1o40000001Un1n';
       if(testId != null)
           return Database.getQueryLocator('select Id, Name, Contact__c, Exam_Group__c, Proctor_Email__c, Proctor_First_Name__c, Proctor_Last_Name__c, Proctor_Type__c, Test_Site__c, Test_Site_Code__c, Type__c, Cloned_From__c, Box_Shipping_Address_1__c, Box_Shipping_Address_2__c, Box_Shipping_Address_3__c, Box_Shipping_Address_City__c, Box_Shipping_City__c, Box_Shipping_Company__c, Box_Shipping_Country__c, Box_Shipping_Phone_Number__c, Box_Shipping_Postal_Code__c, Box_Shipping_State_Provence__c, Exam_Shipping_Address_1__c, Exam_Shipping_Address_2__c, Exam_Shipping_Address_3__c, Exam_Shipping_City__c, Exam_Shipping_Company__c, Exam_Shipping_Country__c, Exam_Shipping_Phone_Number__c, Exam_Shipping_Postal_Code__c, Exam_Shipping_State_Provence__c, Payment_Shipping_Address_1__c, Payment_Shipping_Address_2__c, Payment_Shipping_Address_3__c, Payment_Shipping_City__c, Payment_Shipping_Company__c, Payment_Shipping_Country__c, Payment_Shipping_Phone_Number__c, Payment_Shipping_Postal_Code__c, Payment_Shipping_State_Provence__c from Proctor_Registration__c where Test_Site__c != NULL and Exam_Group__c = :fromExamGroupId and Cloned__c = False and ID = :testId');
       else return Database.getQueryLocator('select Id, Name, Contact__c, Exam_Group__c, Proctor_Email__c, Proctor_First_Name__c, Proctor_Last_Name__c, Proctor_Type__c, Test_Site__c, Test_Site_Code__c, Type__c, Cloned_From__c, Box_Shipping_Address_1__c, Box_Shipping_Address_2__c, Box_Shipping_Address_3__c, Box_Shipping_Address_City__c, Box_Shipping_City__c, Box_Shipping_Company__c, Box_Shipping_Country__c, Box_Shipping_Phone_Number__c, Box_Shipping_Postal_Code__c, Box_Shipping_State_Provence__c, Exam_Shipping_Address_1__c, Exam_Shipping_Address_2__c, Exam_Shipping_Address_3__c, Exam_Shipping_City__c, Exam_Shipping_Company__c, Exam_Shipping_Country__c, Exam_Shipping_Phone_Number__c, Exam_Shipping_Postal_Code__c, Exam_Shipping_State_Provence__c, Payment_Shipping_Address_1__c, Payment_Shipping_Address_2__c, Payment_Shipping_Address_3__c, Payment_Shipping_City__c, Payment_Shipping_Company__c, Payment_Shipping_Country__c, Payment_Shipping_Phone_Number__c, Payment_Shipping_Postal_Code__c, Payment_Shipping_State_Provence__c from Proctor_Registration__c where Test_Site__c != NULL and Exam_Group__c = :fromExamGroupId and Cloned__c = False');
   }

   global void execute(Database.BatchableContext BC, List<Proctor_Registration__c> scope){
       
       system.debug('scope:' + scope);
       
       List<Proctor_Registration__c> newPRs = new List<Proctor_Registration__c>();
       for(Proctor_Registration__c pr :scope) {
           //Proctor_Registration__c newPR = new 
           Proctor_Registration__c newPR = pr.Clone(false,true,false,false);
           
           system.debug('newPR1:' + newPR);
           
           String newSiteCode = examSiteMap.get(pr.Test_Site_Code__c);
           
           if(newPR.Name != NULL && newPR.Proctor_First_Name__c != NULL && newPR.Proctor_Last_Name__c != NULL && 
              newPR.Proctor_Email__c != NULL && newPR.Type__c != NULL && newSiteCode != NULL) {
               newPR.Exam_Group__c = toExamGroupId;
               newPR.Test_Site__c = examSiteMap.get(pr.Test_Site_Code__c);
               
                  if(newPR.Type__c == 'Supervisor')
                      newPR.Status__c = 'Review Documents';
                  else newPR.Status__c = NULL;
                  
                  if(newPR.Type__c == 'Assistant Supervisor')
                      newPR.Type__c = 'Room Proctor';

                  if(newPR.Proctor_Type__c == NULL)
                  	newPR.Proctor_Type__c = 'GARP';
                  
                  newPR.Selected__c = false;
                  newPR.Confirmed__c = false;
                  newPR.Worked__c = false;
                  newPR.Roster_Downloaded_Date__c = null;
                  newPR.Last_Roster_Download_Date__c = null;
                  newPR.UPS_Response__c = null;
                  
                  newPR.Cloned_From__c = pr.Id;           
                  system.debug('newPR2:' + newPR);
                  
                  newPRs.add(newPR);               
           }
           pr.Cloned__c = true;
       }
       
       system.debug('newPRs:' + newPRs);
       insert newPRs;
       update scope;
   }
    
    
   global void finish(Database.BatchableContext BC){
   
   }
}