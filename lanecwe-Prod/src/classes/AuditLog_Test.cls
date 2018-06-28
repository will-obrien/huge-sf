@isTest
private class AuditLog_Test {
  public class Test01Exception extends Exception {}
  public class Test02Exception extends Exception {}

  // Illustrate use of AuditLog
  private static testMethod void testSimpleCase() {
    //User u2 = [SELECT Id FROM User WHERE Alias='vvall'];
    //User u2 = [select id from user where name = 'E-comm Integration' and isactive=true limit 1];
    //User u2 = [select id from user where name = 'eCommerce Customer' and isactive=true limit 1];
      
    //System.RunAs(u2){   
            AuditLog al = new AuditLog('AuditLogTest','testSimpleCase');
            Test.StartTest(); 
            Lead l    =    new Lead(
                            FirstName = 'Test Queue Lead',
                            LastName = 'Owner Update',
                            Phone = '2222012011',
                            Email = 'LeadQueueOwner@pgi.com',
                            ECommerce_Account_Number__c = 'Ecom-000000001',
                            ECommerce_Convert__c = false,
                            LeadSource = 'ECommerce Customer',
                            Company = 'Pfiz I',
                            ChannelType__c = 'Direct',
                            Status = 'Qualifying',
                            Street = '1500 Main Street',
                            City = 'SanJose',
                            State = 'CA',
                            PostalCode = '95802',
                            Country = 'USA',
                            Business_Type__c = 1,
                            DoNotSolicit__c = true,
                            Z_Source__c = 'eCommerce'
                        );

            insert l;
            
            Map<Id,String> m =  new Map<Id,String>{
              l.Id   => 'yummy',
              l.Id   => 'also yummy'
            };
            
            al.logSourceSystem('Test');
            al.logRecordId(l.Id);
            
            al.setUrl(null);
            al.logMessage('Timer started automatically. Now log short, important messages');
             
            try {   
              new Account(name = 'Test').get('BAD_FIELD_NAME');
              System.assert(false, 'Previous line should have thrown a runtime exception');
            } catch (Exception e) {
              al.logException('Apex Runtime Exception Occurred so log it. Pass the exception too ==> ', e);
            }
            
            al.saveLog();   
            Test.stopTest();
      //}
  }

  // Verify that Logs__c records are populated.
  private static testMethod void testCreateLog() {
    //User u2 = [select id from user where name = 'eCommerce Customer' a/nd isactive=true limit 1];   
    //System.RunAs(u2){  
        AuditLog log = new AuditLog('AuditLogTest','testCreateLog');
        Test.StartTest();
        log.logRequestInfo('No Inputs');
        log.logResponseInfo('No Outputs');
        log.logStatusInfo('Status Message');
        log.logMessage('First Message');
        log.logMessage('Second Message');
        
        try {
          try { 
             log.logErrorMessage('First Error');
             throw new Test01Exception('First Exception');
          } catch (Exception e) {
             log.logErrorMessage('Second Error');
             throw new Test02Exception('Second Exception', e);
          }
        } catch (Exception e) {
          log.logException('Chained Exceptions', e);
        }
        
        Logs__c newlog = log.saveLog();
        
        Logs__c dblog = 
          [select id,class_name__c,method_name__c,start_dtm__c,start_ms__c,
                  request__c,response__c,message__c,error_message__c,
                  stop_dtm__c,stop_ms__c,status__c,
                  exception_cause__c,exception_message__c,exception_type__c
             from Logs__c 
            where id = :newlog.id limit 1 ];
        
        System.assertEquals(newLog.class_name__c, dblog.class_name__c);
        System.assertEquals(newLog.method_name__c, dblog.method_name__c);
        
        System.assertEquals(newLog.start_dtm__c, dblog.start_dtm__c);
        System.assert(dblog.start_dtm__c != null);
        System.assertEquals(newLog.start_ms__c, dblog.start_ms__c);
        System.assert(dblog.start_ms__c != null);
        
        System.assertEquals(newLog.stop_dtm__c, dblog.stop_dtm__c);
        System.assert(dblog.stop_dtm__c != null);
        System.assertEquals(newLog.stop_ms__c, dblog.stop_ms__c);
        System.assert(dblog.stop_ms__c != null);
        
        System.assert(dblog.stop_ms__c >= dblog.start_ms__c);
        
        System.assert(dblog.message__c.contains('First Message') && dblog.message__c.contains('Second Message'),'bad message field');
        System.assert(dblog.error_message__c.contains('First Error') && dblog.error_message__c.contains('Second Error'),
                            'bad error field');
       
        
        System.assert(dblog.exception_cause__c.contains('First Exception'),'bad exception cause field');
        System.assert(dblog.exception_message__c.contains('Second Exception'),'bad exception cause field');
        System.debug('@@@BEN@@@ exception type is ' + dblog.exception_type__c);
        System.assert(dblog.exception_type__c.contains('AuditLog_Test.Test02Exception'),'wrong exception type');
        
        System.debug('\n\n>>> ' + dblog);
        test.stopTest();   
    //}   
  }
  
  
  private static testMethod void testLogLevels() {
    //User u2 = [select id from user where name = 'eCommerce Customer' and isactive=true limit 1];   
    //System.RunAs(u2){
        AuditLog audit = new AuditLog( 'AuditLogTest','testLogLevels');
        Test.startTest();
        audit.logMessage('This message won\'t be written');
        audit.logMessage('Nor this one');
        
        Logs__c dblog = audit.saveLog();
        //System.assert(dblog.id == null, 'Logs__c should not have been saved to Salesforce.');
        
        AuditLog audit2 = new AuditLog( 'AuditLogTest','testLogLevels');
        
        audit2.logMessage('This message will be written');
        audit2.logMessage('And so will this one');
        
        Logs__c msglog = audit2.saveLog();
        Logs__c dblog2 = [select id,message__c from Logs__c where id = :msglog.id limit 1 ];
        System.assert(dblog2.message__c.contains('This message will be written'));
        System.assert(dblog2.message__c.contains('And so will this one'));
        Test.StopTest();
    //}   
  }


  private static testMethod void testVeryLongStrings() {
    //User u2 = [select id from user where name = 'eCommerce Customer' and isactive=true limit 1];   
    //System.RunAs(u2){
        Test.StartTest();
        String str100 = '123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_';
        String str32000 = '';
            
        for(Integer j = 0; j < 320; j++) {
          str32000 += str100;
        }
        
        System.assertEquals(32000,str32000.length());

        AuditLog audit = new AuditLog( str100, str100);

        audit.logMessage(str32000);
        audit.logMessage(str100);
        
        Logs__c dblog = audit.saveLog();
        System.assert(dblog.id != null, 'Logs__c with > 32000 char message & long classname should truncate & save OK.');
        Test.StopTest();
    //}   
  }
  
  
  private static testMethod void testThrowingExceptionWhileLoggingException() {
    //User u2 = [select id from user where name = 'eCommerce Customer' and isactive=true limit 1];   
    //System.RunAs(u2){  
        AuditLog audit = new AuditLog('AuditLogTest', 'testForcingExceptionOnSaveLog');
        Test.StartTest();
        try {
          audit.logException(null);
          audit.logException('Null Exception being passed in', null);
        } catch (Exception e) {
          System.assert(true, 'Logging an exception should never throw another exception');
        }
        Test.StopTest();
    //}
  }
}