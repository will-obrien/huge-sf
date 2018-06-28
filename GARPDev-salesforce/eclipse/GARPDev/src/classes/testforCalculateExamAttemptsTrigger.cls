@isTest
private class testforCalculateExamAttemptsTrigger {
   
      static testMethod void testforCalculateExamAttemptsTrigger(){
           
          
          // Create an account so that we can create a member
          account a = new account(
            name = 'test account' ) ;
          insert a ;
          
          // Create a member for test
          contact c = new contact( 
            lastName = 'last',
            account = a ) ;
          
          //Create a Site for test
          Site__c s = new Site__c(
            Active__c = TRUE,
            name='test site');
          insert s;
           
          // Create a Venue for test
          Venue__c v = new Venue__c(
            name = 'Test Venue', 
            Site__c = s.id,
            Active__c = TRUE,
            hasSeatsAssigned__c = TRUE );
          insert v ;

          // Create a second Venue for test
          Venue__c v2 = new Venue__c(
            name = 'Test Venue #2', 
            Site__c = s.id,
            Active__c = TRUE,
            hasSeatsAssigned__c = TRUE );
          insert v2 ;
          
          // Create a Room for test
          Room__c r = new Room__c(
            name = 'Test Room', 
            Active__c = TRUE, 
            Capacity__c = 5,
            Seats_Allocated__c = 0,
            Venue__c = v.id );
          insert r ;

          // Create a Room in venue #2 for test
          Room__c r2 = new Room__c(
            name = 'Test Room #1 in Venue #2', 
            Active__c = TRUE, 
            Capacity__c = 5,
            Seats_Allocated__c = 0,
            Venue__c = v2.id );
          insert r2 ;          
          
          // Create an Exam for test
          Exam__c e = new Exam__c(
            name = 'test exam name',
            Exam__c = 'FRM Part 1',
            Exam_Date__c = date.today(),
            Last_Date_For_Early_Registration__c = date.today()-5,
            Last_Date_For_Late_Registration__c = date.today()-3,
            Last_Date_For_Standard_Registration__c = date.today()-4,
            Standard_Exam_Registration_Fee__c = 5,
            Early_Exam_Registration_Fee__c = 5,
            Late_Exam_Registration_Fee__c = 5,
            Enrollment_Fee__c = 5 ) ;
          insert e ;

          // Create a second Exam for test
          Exam__c e2 = new Exam__c(
            name = 'Second test exam name',
            Exam__c = 'FRM Part 2',
            Exam_Date__c = date.today(),
            Last_Date_For_Early_Registration__c = date.today()-5,
            Last_Date_For_Late_Registration__c = date.today()-3,
            Last_Date_For_Standard_Registration__c = date.today()-4,
            Standard_Exam_Registration_Fee__c = 5,
            Early_Exam_Registration_Fee__c = 5,
            Late_Exam_Registration_Fee__c = 5,
            Enrollment_Fee__c = 5 ) ;
          insert e2 ;
         
          
          // Create exam site
          Exam_Sites__c es = new Exam_Sites__c(
            name = 'test exam site',
            Exam__c = e.id, 
            Site__c = s.id ) ;
          insert es ;

          // Create second exam site
          Exam_Sites__c es2 = new Exam_Sites__c(
            name = 'test exam site',
            Exam__c = e2.id, 
            Site__c = s.id ) ;
          insert es2 ;
            
          // Create Exam Attempt
          Exam_Attempt__c ea = new Exam_Attempt__c(
            name = 'Test exam Attempt',
            Room__c = r.id,
            Exam_Site__c = es.id,
            Member__c = c.id ) ;
          insert ea;
          
          // Create a second Exam Attempt
          Exam_Attempt__c ea2 = new Exam_Attempt__c(
            name = 'Test exam Attempt #2 with same member',
            Room__c = r.id,
            Exam_Site__c = es2.id,
            Member__c = c.id ) ;
          insert ea2;          
           
          //Now insert data causing the Venue SetRoomSatus trigger to fire.
          Test.startTest();

          ea.Room__c = r2.id ;
          update ea ;
          
          ea.Room__c = r.id ;
          update ea ;          


/**

          v.Active__c = FALSE ;
          try {
            update v ;
          } catch (DmlException ex) { 
            //Assert Error Message
            System.assert(ex.getMessage().contains('Update failed. First exception '+
              'on row 0 with id '+v.id+'; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, '+
              'Cannot deactivate venue until ALL candidates have been moved to other venues.: [Active__c]'), 
               ex.getMessage()); 

           //Assert Field
           System.assertEquals(Venue__c.Active__c, ex.getDmlFields(0)[0]);

           //Assert Status Code
           System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  , 
             ex.getDmlStatusCode(0));
          }

          //Now insert data causing the Room SetRoomSatus trigger to fire.
          r.Active__c = FALSE ;
          try {
            update r ;
          } catch (DmlException ex1) { 
            //Assert Error Message
            System.assert(ex1.getMessage().contains('Update failed. First exception '+
              'on row 0 with id '+r.id+'; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, '+
              'Cannot deactivate Room until ALL candidates have been moved to other Rooms.: [Active__c]'), 
               ex1.getMessage()); 

           //Assert Field
           System.assertEquals(Room__c.Active__c, ex1.getDmlFields(0)[0]);

           //Assert Status Code
           System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  , 
             ex1.getDmlStatusCode(0));
          }
          
          v.Active__c = TRUE ;
          update v ;

          r.Active__c = TRUE ;
          update r ;
          
          ea.Room__c = NULL ;
          update ea;
          
          v.Active__c = FALSE ;
          update v ;

          r.Active__c = FALSE ;
          update r ;
       **/   
          Test.stopTest();   
      }  
  }