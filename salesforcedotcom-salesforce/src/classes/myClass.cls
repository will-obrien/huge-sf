@isTest
public class myClass {
    static testMethod void testCaseTrigger(){
          List<Case> cases = new List<Case>{};
               
          for(Integer i = 0; i < 200; i++){
              Case c = new Case(Subject = 'Test Case Triggers' + i);
              cases.add(c);
          }
    
        test.startTest();
        insert cases;
        test.stopTest();
    
        List<Case> insertedCases = [SELECT Subject FROM Case WHERE Id IN :cases];
    
            System.assertEquals(200,insertedCases.size());
    }
}