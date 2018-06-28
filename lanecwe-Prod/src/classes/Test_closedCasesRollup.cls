@isTest
private class Test_closedCasesRollup
{
  private static Project__c project;
  private static List<Case> caseList = new List<Case>();
    static testMethod void myUnitTest() 
    {
    setUp();      
      Test.startTest();
      project = [select id, Number_of_Cases__c from Project__c where id=:project.Id];
      system.assertEquals(project.Number_of_Cases__c, 5);
      
      List<Case> casesToDelete = new List<Case>();
      for (Integer i = 0; i < 2; i++)
      {
        casesToDelete.add(caseList.get(i));
      }
      delete casesToDelete;
      
      project = [select id, Number_of_Cases__c from Project__c where id=:project.Id];
      system.assertEquals(project.Number_of_Cases__c, 3);
      Test.stopTest();
    }
    
    private static void setUp()
    {
      project = createProject();
      insert project;
      system.assertNotEquals(project.Id, null);
      for (Integer i = 0; i < 5; i++)
      {
        caseList.add(CreateCases(project.Id));
      }
      insert caseList;
    }
    
    private static Project__c createProject()
    {
      project = new Project__c();
      project.Business_Sponsor_Name__c = 'Test Project';
      return project;
    }
    
    private static Case createCases(Id projectId)
    {
      Case testCase = new Case();
      testCase.Status = 'New';
      testCase.Priority = 'Medium';
      testCase.Issues_Category__c = 'Sales Issue';
      testCase.Issues_Category_Type__c = 'Issues';
      testCase.Type_Details__c = 'General Enquiry';
      testCase.Origin = 'NA - SFDC Support';
      testCase.Estimated_Resolution_Date__c = system.today().addDays(5);
      testCase.Region__c = 'APAC';
      testCase.Subject = 'Test Case';
      testCase.Project__c = project.Id;
      return testCase;
    }
}