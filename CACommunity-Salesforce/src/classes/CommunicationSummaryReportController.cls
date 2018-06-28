global without sharing class CommunicationSummaryReportController{

 public String communicationId;
 
 public String surveyName {get;set;}
 
 public     Map<String,Map<String,List<QnA>>> resultMap {get;set;}
 
  // constructor method for standard controller
    public CommunicationSummaryReportController() {
    
     if(ApexPages.currentPage().getParameters().get('CommunicationId')!=null)
     {
            communicationId = ApexPages.currentPage().getParameters().get('CommunicationId');     
     }
     else
     {
       ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Please provide a valid communication id.'));
     }
     
     List<SurveyQuestionResponse__c> allResponseLst = [select Survey_Question__r.Survey__r.name,SurveyTaker__r.CA_Owner__c,SurveyTaker__r.Contact__r.name, 
                                               Survey_Question__R.Name,Response__c   
                                               FROM SurveyQuestionResponse__c 
                                               WHERE Survey_Question__r.Survey__c= :communicationId and
                                                     SurveyTaker__r.CA_Owner__c <> '' and
                                                     Survey_Question__R.Do_not_publish__c <> True
                                               ORDER BY  SurveyTaker__r.CA_Owner__c, SurveyTaker__r.Contact__r.name, 
                                               Survey_Question__R.Name];

    for(SurveyQuestionResponse__c responseSO : allResponseLst )
    {
     
      surveyName = responseSo.Survey_Question__r.Survey__r.name;
     
      if(resultMap!=null && resultMap.size() > 0 && resultMap.containsKey(responseSo.SurveyTaker__r.CA_Owner__c))
      {
         
         Map<String,List<QnA>> tempMap= resultMap.get(responseSo.SurveyTaker__r.CA_Owner__c);
         List<QnA> answerLst;
         if(tempMap.containsKey(responseSo.SurveyTaker__r.Contact__r.name))
         {
           answerLst =tempMap.get(responseSo.SurveyTaker__r.Contact__r.name);

         }
         else
         {
           answerLst =New List<QnA>();         
         }
         
          QnA qnAWrapper = New QnA(); 
          qnAWrapper.question=responseSo.Survey_Question__R.Name;
          qnAWrapper.answer = responseSo.Response__c;
          answerLst.add(qnAWrapper);
          tempMap.put(responseSo.SurveyTaker__r.Contact__r.name,answerLst);
          resultMap.put(responseSo.SurveyTaker__r.CA_Owner__c,tempMap);
      }
      else
      {
         List<QnA > answerLst = New List<QnA >();
         QnA qnAWrapper = New QnA(); 
         qnAWrapper.question=responseSo.Survey_Question__R.Name;
          qnAWrapper.answer = responseSo.Response__c;
          answerLst.add(qnAWrapper);
         Map<String,List<QnA>>     tempMap = New Map<String,List<QnA>>();
         tempMap.put(responseSo.SurveyTaker__r.Contact__r.name,answerLst);
         if(resultMap==null)
         {
         resultMap = New Map<String,Map<String,List<QnA>>>();
         }
         resultMap.put(responseSo.SurveyTaker__r.CA_Owner__c,tempMap); 
      }
    }
        
  }
  
  class QnA
  
  {
   public String question {get;set;}
    public String answer {get;set;}
  
  }

}