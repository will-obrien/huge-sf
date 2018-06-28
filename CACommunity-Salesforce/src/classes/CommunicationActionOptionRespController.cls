public class CommunicationActionOptionRespController {

  private String communicationId;
  
  private string questionParamStr;
  
  private Id reportQuestionId;
  
  public String surveyNameStr {get;set;}
  
  public String questionStr {get;set;}
  
  private String choices;
  
  public List<String> optionStrLst{get;set;}
  
  public Map<String,List<String>> answerMap {get;set;}
  
  public Map<String,List<Boolean>> responseMap {get;set;}
  
  public  List<String>  reponseOwnerLst {get;set;}
  
  public List<Integer> responseCountLst {get;set;}
  
  public String textInputNameStr {get;set;}
  
  public   Map<String,String> textInputRespMap {get;set;}
  
  // constructor which intializes the data that is displayed on the page
  public CommunicationActionOptionRespController () {
    
     // get the parameters from the url and throw error if the param is not available
     if(ApexPages.currentPage().getParameters().get('CommunicationId')!=null)
     {
            communicationId = ApexPages.currentPage().getParameters().get('CommunicationId');     
     }
     else
     {
       ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Please provide a valid communication id.'));
     }

   if(ApexPages.currentPage().getParameters().get('Question')!=null)
     {
            questionParamStr= ApexPages.currentPage().getParameters().get('Question');     
     }
     else
     {
       ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Please provide a valid Question String.'));
     }

    // get all the questions for this survey, 
    Map<Id,Survey_Question__c> questionSoMap = New Map<Id,Survey_Question__c>([select id,question__c,Survey__r.name,choices__c 
                                                                               from   Survey_Question__c  
                                                                               where  survey__c = :communicationId ]);
    // this field will hold the ID of the text input question
    Id textInputQuestionId;
    
    // if there are one or more questions
    if(questionSoMap!=null && questionSoMap .size() > 0)
    {
      
      // loop over each question, NOTE we need to loop over each question 
      // coz of SOQL limitation that we cannot use long text area as filter in where clause
      for(Id questionId : questionSoMap.keyset())
      {
       
       // if the question matches the question provided in input parameter
       if(questionSoMap.get(questionId).question__c.startsWith(questionParamStr))
       {
         // get the question id as we would need to fetch all the answers for this question
         reportQuestionId = questionId;

         // get the question string
         questionStr = questionSoMap.get(questionId).question__c;
        
         // get the intial characters, we would use this to get the text input question id
         textInputNameStr = questionStr.subString(0,9) ;
         
         // get all the valid choices for this question
         choices= questionSoMap.get(questionId).choices__c;
       } 
       
       // get the survey name only once, this is displayed on the top of the page
       if(surveyNameStr==null)
       {
        surveyNameStr =  questionSoMap.get(questionId).Survey__r.name;
       }
       
      }
    
       // loop over all the questions and get the id of the question for the text input (last column)
       for(Id questionId : questionSoMap.keyset()) 
         {
                  if(textInputNameStr!=null && questionSoMap.get(questionId).question__c.startsWith(textInputNameStr+ ' Text Input'))
                       {
                           textInputQuestionId = questionId;
                        }
          }
    }
    else
    {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Survey does not have any questions.'));
    }
    
    
    if(reportQuestionId ==null)
    {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Question not found. Make sure you have provided a valid string in the question param.'));
    }
    else
    {
    
     // get all the responses for the question provided in url param
     List<SurveyQuestionResponse__c> surveyQuestionRespLst=  [select SurveyTaker__r.CA_Owner__c, Response__c,
                                                                     Survey_Question__r.Question__c,Survey_Question__r.Survey__c  
                                                              from   SurveyQuestionResponse__c  
                                                              where  Survey_Question__c = :reportQuestionId and SurveyTaker__r.CA_Owner__c <> ''
                                                              order by SurveyTaker__r.CA_Owner__c];
     
     // get all the responses for the text input question
     List<SurveyQuestionResponse__c> textInputRespLst=  [select SurveyTaker__r.CA_Owner__c, Response__c,
                                                                     Survey_Question__r.Question__c,Survey_Question__r.Survey__c  
                                                              from   SurveyQuestionResponse__c  
                                                              where  Survey_Question__c = :textInputQuestionId and SurveyTaker__r.CA_Owner__c <> ''
                                                              order by SurveyTaker__r.CA_Owner__c];
     

     // this map holds the text input response provided by each owner
     textInputRespMap = New Map<String,String>();

     if(textInputRespLst!=null && textInputRespLst.size() > 0)  
     { 
       // loop over all the responses and populate the map
       // this map is used on the VF page to display the responses
       for(SurveyQuestionResponse__c sqrSo: textInputRespLst) {
        textInputRespMap.put(sqrSo.SurveyTaker__r.CA_Owner__c,sqrSo.Response__c);
       }
     }
     

     
     
     // list which will hold all the valid answers for the question                                                         
     optionStrLst = New List<String>();
     
     if(choices!=null && choices.length() > 0)
     { 
       // split the option by new line character
       optionStrLst = choices.split('\n');
     }
    
    Map<String,Integer> optionMap = New Map<String,Integer>();
    
    Integer optionVal=0;
    
    // loop over all the option and get rid of all the new line characters or whitespaces
    // as this can create an issue while doing exact match
    for(String optionStr : optionStrLst)
    {
       optionStr = optionStr.replace('\r\n', '');
       optionStr = optionStr.replace('\n', '');
       optionStr = optionStr.replace('\r', '');
       optionStr=optionStr.trim();
       optionMap.put(optionStr,optionVal++);
    }
    
    // list to display the owner names on the page
    reponseOwnerLst = New List<String>();
   
    // list which will hold the response of each owner for each question
    responseMap = New Map<String,List<Boolean>>();
     
     if(surveyQuestionRespLst!=null && surveyQuestionRespLst.size() > 0)  
     { 
        // the total response count for each answer
        Integer responseCount=0;
        responseCountLst = New List<Integer>();
        
        // loop over all the valid answers
        for(String responseStr: optionMap.keySet()){
         
         // reset the count for each new answer
         responseCount=0;
            
            // loop over all the owner reponses that we had queried earlier
            for(SurveyQuestionResponse__c sqrSo : surveyQuestionRespLst) 
                {
                    // eliminate new line chars and whitespaces
                    String optionStr = sqrSo.response__c;
                    optionStr = optionStr.replace('\r\n', '');
                    optionStr = optionStr.replace('\n', '');
                    optionStr = optionStr.replace('\r', '');
                    optionStr=optionStr.trim();
                    
                    // increment the count if the answer matches
                    if(responseStr.equalsIgnoreCase(optionStr))
                        {
                          responseCount++;
                        }
                }

        // add the count in the list , this list is used on the vf page
        responseCountLst.add(responseCount);   

      }
      
      // loop over each response
      for(SurveyQuestionResponse__c sqrSo : surveyQuestionRespLst)
      {
         // get rid of the new line chars and whitespaces
         String optionStr = sqrSo.response__c;
         optionStr = optionStr.replace('\r\n', '');
         optionStr = optionStr.replace('\n', '');
         optionStr = optionStr.replace('\r', '');
         optionStr=optionStr.trim();
        
        // get the number from the map
        Integer responseVal = optionMap.get(optionStr);
        
        List<Boolean> tempList; 
        Boolean isNewLst=false,isMapLst=false;
         
        // this is for the case where there could be multiple answer for each question
        if(responseMap.containsKey(sqrSo.SurveyTaker__r.CA_Owner__c))
          {
           tempList = responseMap.get(sqrSo.SurveyTaker__r.CA_Owner__c); 
           isMapLst=true;
          }
         else
          { 
            // if a new list is created then we need to create its size equal to the 
            // number of valid answers and reset each answer to false.
            tempList = New List<Boolean>();
            isNewLst  = true;
            for(Integer i=0;i<optionStrLst.size();i++)
            {
             tempList.add(false);
            } 

              
          }
        
        // loop over each answer
        for(Integer i=0;i<optionStrLst.size();i++)
        {
          
          // check at which position a valid answer is found
          if(i==responseVal) 
          {  
             // remove the false flag and set the true flag at that location in the list
             tempList.remove(i);
             if(i == optionStrLst.size() - 1)
             {
              tempList.add(true);
             }
             else
             {
              tempList.add(i,true);
             }
           }
      

        }
       
        // put the list in the map against each owner, this list gives the right/wrong matrix on the page
        responseMap.put(sqrSo.SurveyTaker__r.CA_Owner__c,tempList);
        if(textInputRespMap.get(sqrSo.SurveyTaker__r.CA_Owner__c)==null)
        {
         textInputRespMap.put(sqrSo.SurveyTaker__r.CA_Owner__c,' ');
        }
      }
      
      // the keys from the map are all valid owners 
      reponseOwnerLst.addAll(responseMap.keySet());
      
      
    
      
      system.debug('##textInputRespMap='+textInputRespMap);
       
     }
    
    }
    

  }
  


  
}