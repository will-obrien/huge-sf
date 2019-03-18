@isTest
public class testBatch {

    public static testMethod void testBatch() {
    
       String query;
       String field;
       String value;
       Test.StartTest();
       Account a = new Account(Name='testAccount');
       insert a;
       query='SELECT ID, Name, phone ' +
                'FROM Account ';
       field='phone';
       value='111';
       SearchAndReplace SandR = new SearchAndReplace(query,field,value);
       
    
       ID batchprocessid = Database.executeBatch(SandR);
       Test.StopTest();
    
       System.AssertEquals(
               database.countquery('SELECT COUNT()'
                  +' FROM Account WHERE phone= \'111\''),
               1);  
       
    }
 }