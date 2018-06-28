/**

Test Case for the following Controller Extension:
CommunicationActionOptionRespController 

**/

@isTest 
public class CommunicationActionOptRespControllerTest{
    public static String        surveyId       {get; set;}
  public  static List<String>  questionIds    {get; set;}
  public static String          contactId      {get; set;}
  public static String        surveyTakerId  {get; set;}
  public static String        contactId2     {get; set;}
  
    static testMethod void validateTest() {
    
    questionIds = new List<String>();
    createTestSurvey();
    createTestQuestions();
    createTestContact();
    createSurveyTaker();
    createTestResponses();
    PageReference myVfPage = Page.CommunicationActionOptionResponse;
Test.setCurrentPage(myVfPage);

// Put Id into the current page Parameters
ApexPages.currentPage().getParameters().put('CommunicationId',getSurveyId());
ApexPages.currentPage().getParameters().put('Question','ACTION789');
CommunicationActionOptionRespController caorc = new CommunicationActionOptionRespController();


    }
    
     public static String getSurveyId()
  {
   return surveyId;
  }
  

  
  private static void createSurveyTaker(){

    SurveyTaker__c st = new SurveyTaker__c();
    st.Contact__c = contactId;
    st.Survey__c = surveyId;
    st.Taken__c = 'false';
    insert st;
    surveyTakerId = st.Id;
  }
  
  
  public static void createTestSurvey(){
    Survey__c s = new Survey__c();
    s.Name = 'Testing Survey';
    s.Submit_Response__c = 'empty'; 
    insert s;
    surveyId = s.Id;
  }
  
  public static void createTestQuestions(){
    questionIds.add(createQuestion(0));
    questionIds.add(createQuestion(1));
    questionIds.add(createQuestion(2));
    questionIds.add(createQuestion(3));
    questionIds.add(createQuestion2(4));
  }
  
  private static String createQuestion(Integer i){
    Survey_Question__c q = new Survey_Question__c();
    q.Name = 'Testing Question';
    q.Survey__c = surveyId;
    q.Type__c = getType(i);
    q.Choices__c = getChoices();
    q.Question__c = 'ACTION789';
    q.OrderNumber__c = i;
    q.Required__c = true;
    insert q;
    return q.id;        
  }
  
  private static String createQuestion2(Integer i){
    Survey_Question__c q = new Survey_Question__c();
    q.Name = 'Testing Question';
    q.Survey__c = surveyId;
    q.Type__c = getType(i);
    q.Choices__c = getChoices();
    q.Question__c = 'ACTION789 Text Input';
    q.OrderNumber__c = i;
    q.Required__c = true;
    insert q;
    return q.id;        
  }
  
  
  private static void createTestContact() {
    Account caOwner = getParentAccount();
   insert caOwner;
    Contact c = new Contact();
    c.LastName = 'Doe';
    c.FirstName = 'John';
    c.Email = 'surveyAppUser@hotmail.com';
    c.accountId = caOwner.id;
    insert c;
    contactId = c.Id;   
    
    Contact c2 = new Contact();
    c2.LastName = 'Doe2';
    c2.FirstName = 'John2';
    c2.Email = 'surveyAppUser2@hotmail.com';
    c2.accountid = caowner.id;
    insert c2;
    contactId2 = c2.Id;   
  }
  
     private static Account getParentAccount()
    {
        Account parentAccount = new Account();
        parentAccount.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CA Owner').getRecordTypeID();
        parentAccount.name = 'ParentAccount';
        parentAccount.type = 'Owner';
        parentAccount.phone='2128425500';
        parentAccount.website  = 'https//www.test.com';
        parentAccount.valid_From_GMT__c= date.today()+1;
        parentAccount.valid_to_GMT__c= date.today()+10;
        parentAccount.company_website__c=  'https//www.test.com';
        parentAccount.organizational_type__c=  'Organizational Type';
        parentAccount.geographic_focus__c=  'Geographic focus';
        parentAccount.primary_market_customer_base__c = 'Primary Market';
        return parentAccount;
    }

  
  private static String createTestResponses() {
    SurveyQuestionResponse__c r = new SurveyQuestionResponse__c();
    r.Response__c = 'two';
    Survey_Question__c sq = [Select id from Survey_Question__c where id=: questionIds[1] limit 1];
    r.Survey_Question__c = sq.id;
    r.SurveyTaker__c = surveyTakerId;
    insert r;
    
        SurveyQuestionResponse__c r3 = new SurveyQuestionResponse__c();
    r3.Response__c = 'hello';
    Survey_Question__c sq1 = [Select id from Survey_Question__c where id=: questionIds[4] limit 1];
    r3.Survey_Question__c = sq1.id;
    r3.SurveyTaker__c = surveyTakerId;
    insert r3;
    SurveyQuestionResponse__c r2 = new SurveyQuestionResponse__c();
    r2.Response__c = 'two';
    sq = [Select id from Survey_Question__c where id=: questionIds[1] limit 1];
    r2.Survey_Question__c = sq.id;
    r2.SurveyTaker__c = surveyTakerId;
    insert r2;
    return 'true';
  }
  
  private static String getType(Integer i){
    if      (i==1)
     return 'Multi-Select--Vertical';
    else if (i==2)
     return 'Single Select--Vertical';
    else if (i==3)
     return 'Free Text';
    else
     return 'Single Select--Horizontal';
  }
  private static String getChoices(){
    return 'one\ntwo\nthree\n';
  }
    
    
}