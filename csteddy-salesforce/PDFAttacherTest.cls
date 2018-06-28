@isTest
    
public class PDFAttacherTest{

        /** Defining the public records that would be used for the test Class **/
        Public Static Crew__c crewTest;
        Public Static Property__c propertyTest;
        Public Static Group groupTest;
        Public Static Client__c clientTest;
        Public Static Property_Contact__c propertyContactTest;
        Public Static QueueSobject queueObjectTest;  
        Public Static Inspection__c inspectionTest;
        public Static ApexPages.StandardController PDFAttacherController;
        public Static PDFAttacher pdf;
    
        
        
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

    /** Defining the second user that be used for testing this Class **/
     public static User userSysadmin1
    {
        get{
            if (userSysadmin1 == null )
            {
                sysadminProfile = [Select Id, Name From Profile where name = 'System Administrator' limit 1];
                userSysadmin1  = new user (Username = 'test1@key.net', FirstName = 'First1', LastName ='Last1', alias = 'sysa', 
                            email='test1@key.net', communityNickname='test', TimeZoneSidKey='Australia/Perth',
                            LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', ProfileId=sysadminProfile.Id ,
                            LanguageLocaleKey='en_US');
                insert userSysadmin1;             
             }
             return userSysadmin1;
            }
        set;
    } 
    
    /**  Creating the records that would be used in this test class **/
//     @future
     public static void createTestData(){
            
            /** inserting a crew record **/       
            crewTest = new crew__c();
            crewTest.User__c = userSysadmin.Id;
            crewTest.Name = 'Test Crew';
            insert crewTest;    
            
            /** Inserting a client record **/
            clientTest = new client__c();
            clientTest.Name='test';
            insert clientTest;
            
            /**Inserting a Property Contact Record **/
            propertyContactTest = new property_Contact__c();
            propertyContactTest.Name='test';
            insert propertyContactTest;
            
            date myDate = date.today();
            date weekStart = myDate.toStartofWeek().addDays(1);
            
            /** Inserting a Property Record**/
            propertyTest = new property__c();
            propertyTest.Week_of_Next_Visit__c = weekStart;
            propertyTest.Inactive__c = False;
            propertyTest.Name='test';
            propertyTest.Frequency__c=2;
            propertyTest.Client__c=clientTest.id;
            propertyTest.Property_Contact_1__c=propertyContactTest.id;
            propertyTest.Crew__c = crewTest.Id;
            propertyTest.Location__c = 'Test';

            insert propertyTest;
           
            propertyTest.Name='test1';
            update propertyTest;
             
            inspectionTest = new inspection__c();
            inspectionTest.Name='Bond-007';
            inspectionTest.Date_of_Visit__c=date.today();
            inspectionTest.Property__c=propertyTest.id;
            inspectionTest.General_Site_Condition__c='Good';
            insert inspectionTest;
           
            Inspection__c inspectattach=[select id, Name from Inspection__c where Name=:'Bond-007' AND General_Site_Condition__c=:'Good'];
            PDFAttacherController= new ApexPages.StandardController(inspectattach);
            pdf = new PDFAttacher(PDFAttacherController); 
            
            pdf.attachPDF();

       }

     /** Creatng the Groups that would be used to test the Update Property Owner Trigger **/
     public static void initGroup(){
            /** Creating the Group Record **/
            groupTest = new Group();
            groupTest.Name = 'Test Crew';
            groupTest.Type='Queue';
            insert groupTest;   
            
            /** Creating the Queue Record **/
            queueObjectTest = new QueueSobject();
            queueObjectTest.QueueId = groupTest.Id;
            queueObjectTest.SobjectType = 'Property__c';
            insert queueObjectTest;
            
               
    }
    
   
     public static testmethod  void testPDFAttacher(){
     
         
         /** Starting the Test **/
         test.startTest();
         /** Insatanciating the Group using the First User **/
         system.runAs(userSysadmin1){  
         initGroup();
         }
         /** Instantiating the rest of the records by changing the Context in order to avoid the Mixed DML Erroe **/
         system.runAs(userSysadmin){
         
             createTestData();
/*              
                          propertyTest.Name='test1';
            update propertyTest;
             
            inspectionTest = new inspection__c();
            inspectionTest.Name='Bond-007';
            inspectionTest.Date_of_Visit__c=date.today();
            inspectionTest.Property__c=propertyTest.id;
            inspectionTest.General_Site_Condition__c='Good';
            insert inspectionTest;
           
            Inspection__c inspectattach=[select id, Name from Inspection__c where Name=:'Bond-007' AND General_Site_Condition__c=:'Good'];
            PDFAttacherController= new ApexPages.StandardController(inspectattach);
            pdf = new PDFAttacher(PDFAttacherController); 
            
            pdf.attachPDF();
  */                     
         }
        
         test.stopTest();
     
     }
     
     
     
}
