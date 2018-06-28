@isTest
    
public class oldIndexNumTest{

        /** Defining the public records that would be used for the test Class **/
        Public Static Address__c addressTest;
        
         public Static Profile sysadminProfile;
         
         
    /** Defining the first user that be used for testing this Class **/
     public static User userSysadmin
    {
        get{
            if (userSysadmin == null )
            {
                sysadminProfile = [Select Id, Name From Profile where name = 'System Administrator' limit 1];
                userSysadmin  = new user (Username = 'test@key.net', FirstName = 'First', LastName ='Last', alias = 'sysadmin', 
                            email='test@key.net', communityNickname='test1', TimeZoneSidKey='Australia/Perth',
                            LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', ProfileId=sysadminProfile.Id ,
                            LanguageLocaleKey='en_US');
                insert userSysadmin;             
             }
             return userSysadmin;
            }
        set;
    } 

    
    /**  Creating the records that would be used in this test class **/
//     @future
     public static void createTestData(){
/*            
            Card__c c = new Card__c();
            c.name = 'Test Card';
            insert c;
//            inserting a address record       
            addressTest = new Address__c();
            addressTest.card__c = c.id;
            insert addressTest;    
*/            
       }

   
     public static testmethod  void testPDFAttacher(){
     
         
         /** Starting the Test **/
         test.startTest();
         /** Instantiating the rest of the records by changing the Context in order to avoid the Mixed DML Erroe **/
         system.runAs(userSysadmin){
         
             createTestData();

         }
        
         test.stopTest();
     
     }
     
     
     
}
