/**********************************************************************************************************************
*   Market Traders Institute, Inc.    CONFIDENTIAL
* ---------------------------------------------------------------------------------------------------------------------
*   [2015] Market Traders Institute
*   All Rights Reserved
*
*   NOTICE:  All information contained herein is, and remains the property of Market Traders Institute, Inc. and its
*   suppliers, if any.  The intellectual and technical concepts contained herein are proprietary to Market Traders 
*   Institute, Inc. and its suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are 
*   protected by trade secret or copyright law.  Dissemination of this information or reproduction of this material
*   is strictly forbidden unless prior written permission is obtained from Market Traders Institute, Inc.
*
*   Date Created:       Asha Calderon
*   Author:             5/19/2015
*   Last Modified:      6/23/2015
*   Last Modified By:   Asha Calderon
*
*   
*   
**********************************************************************************************************************/
/******************
Test_OpportunityStamper
@description:
Test classes for OpportunityStamper
**/

@isTest
private class Test_OpportunityStamper {


/******************
@method:
testStamper1

@description:
-Setup the custom setting for the OpportunityStamperMapping which has a correlation between previous 
product names and current product names
- Create test accounts,test Opportunities, test webinars and test webinar attnds records
- test is for UTP on Demand product
- checks to see which product is being tested (LMFS,UOC,UTP) - since teststamper1 is just UTP only the 2nd loop is run
- verifies that the webinar attendance record marked as the first, latest and latest with a duration over 25 are not null 
- verifies that the first attendance webinar event date is greater than the latest attended
- verifies that the latest 25+ adjusted duration is greater than 25 minutes

**/
    static testMethod void testStamper1() {
        
    //setup custom setting
    OpportunityStamperMapping__c os1 = new OpportunityStamperMapping__c();    
    os1.name = 'UTP';
    os1.isActive__c = true;
    os1.Opportunity_Product__c = 'UTP OnDemand';    
    insert os1;
    
    OpportunityStamperMapping__c os2 = new OpportunityStamperMapping__c();    
    os2.name = 'LMFS';
    os2.isActive__c = true;
    os2.Opportunity_Product__c = 'Live Market Forex Session';   
    insert os2;
    
    OpportunityStamperMapping__c os3 = new OpportunityStamperMapping__c();    
    os3.name = 'UOC';
    os3.isActive__c = true;
    os3.Opportunity_Product__c = 'Ultimate Options Course'; 
    insert os3;
    

     Handler_Account.BYPASS = true;
        
      //setup recordTypeID map for Opp and Account
      Map<String, ID> recmapopp = recTypeIDOpportunity();
      Map<String, ID> recmapacct = recTypeIDAccount();      
    
    //create list of products
        List<String> listofproducts = new List<String>();
        listofproducts.add('UTP OnDemand');
        listofproducts.add('Live Market Forex Session');
        listofproducts.add('Ultimate Options Course');
        
        Map<String,String> maptoproductabbrv = new Map<String,String>();
        maptoproductabbrv.put('UTP OnDemand','UTP');
        maptoproductabbrv.put('Live Market Forex Session','LMFS');
        maptoproductabbrv.put('Ultimate Options Course','UOC');
       
    
     //create test accounts
        list<Account> listofaccounts = new List<Account>();        
        Account testAccount1 = new Account();
        

        testAccount1 = new Account();
             testAccount1.FirstName = 'testfirstname'+ 1;//i;
             testAccount1.LastName = 'testlastname' +1; //i;
             testAccount1.RecordTypeID = recmapacct.get('Person Account');  
             testAccount1.Lead_Source_LMFS__c = 'Test lead source'; 
             testAccount1.Lead_Source_LMFS_PREV__c = 'Test lead source';     
             testAccount1.Lead_Source_UOC__c   = 'Test lead source';  
             testAccount1.Lead_Source_UOC_PREV__c  = 'Test lead source';               
             testAccount1.Lead_Source_UTP__c = 'Test lead source';                 
             testAccount1.Lead_Source_previous__c = 'Test lead source';                 
             testAccount1.Lead_Source_Date_LMFS__c = Date.today().adddays(-5);                
             testAccount1.Lead_Source_Date_LMFS_PREV__c = Date.today().adddays(-5);    
             testAccount1.Lead_Source_Date_UOC__c = Date.today().adddays(-5);                
             testAccount1.Lead_Source_Date_UOC_PREV__c = Date.today().adddays(-5);                  
             testAccount1.Lead_Source_Date__c = Date.today().adddays(-5);                 
             testAccount1.Lead_Source_Date_previous__c = Date.today().adddays(-5); 
             testAccount1.Lead_Source_Detail_LMFS__c  = 'Test lead source';   
             testAccount1.Lead_Source_Detail_LMFS_PREV__c  = 'Test lead source';               
             testAccount1.Lead_Source_Detail_UOC__c = 'Test lead source';                  
             testAccount1.Lead_Source_Detail_UOC_PREV__c  = 'Test lead source';                
             testAccount1.Lead_Source_Detail__c   = 'Test lead source';                          
             testAccount1.Lead_Source_Detail_previous__c = 'Test lead source';

    insert testAccount1;
            
    //create test opps
        List<Opportunity> listopps = new List<Opportunity>();
        Opportunity testopp = new Opportunity();        

        Integer index = 0;
      
            testopp = new Opportunity();
            testopp.Name = 'test opp '+1; //i;
            testopp.recordTypeID = recmapopp.get('Education'); // changed to sorted by rectype aac 3.13.16 - Education = UTP
            testopp.CloseDate = date.today().adddays(-1);
            testopp.AccountID = testAccount1.id; //listofaccounts[i];
            testopp.Closed_By__c = UserInfo.getUserId();
            testopp.Product__c = listofproducts[index]; 
            testopp.AVSFQB__Generate_Object__c = 'None';
            testopp.Sale_Invoice_First_Date_After_Down__c = Date.today();
            testopp.Sale_Invoice_Qty_Payments_After_Down__c = 1;
            testopp.StageName ='Closed Won';
            testopp.Sub_Stage__c = 'Cancelled';
            testopp.Charting_Start__c = Date.today(); 
            testopp.Charting_Expiration__c = Date.today(); 
            testopp.LeadSource = 'Webinar';
            testopp.Purchase_Amount__c = 0;  
            testopp.web_LMFS_FirstAttd__c = null;
            testopp.web_LMFS_LastAttd__c = null;
            testopp.web_LMFS_LastAttd25__c = null;
            testopp.web_UTP_FirstAttd__c = null;
            testopp.web_UTP_LastAttd__c = null;
            testopp.web_UTP_LastAttd25__c = null;
            testopp.web_UOC_FirstAttd__c = null;
            testopp.web_UOC_LastAttd__c = null;
            testopp.web_UOC_LastAttd25__c = null;          
            testopp.Amount = 0;

  Database.SaveResult insertResultsWA = Database.insert(testopp,false);
  Database.SaveResult result = insertResultsWA;  
        if (!result.isSuccess()) {
            for (Database.Error error : result.getErrors()) {
                System.debug(Logginglevel.ERROR,'@asha: @debug:OppStamperTest: Opp insert result:'+ error.getMessage());
            }
        }else{
            System.debug(Logginglevel.ERROR,'@asha:@debug: OppStamperTest: Opp insert result: isSuccess'+ result.isSuccess());
        }
   
         
     //create test webinars   
      Integer daystoadd = 0;
        List<Webinar__c> testWebinars = new List<Webinar__c>();
        Webinar__c testWeb1 = new Webinar__c();
        for(integer i = 0; i< 5; i++){
            testWeb1 = new Webinar__c();
            testWeb1.Name = 'test webinar LMFS'+ i;
            testWeb1.Webinar_ID__c = 'LMFS-testwebid-'+i;
            testWeb1.Event_Date_Time__c = Date.today().addDays(-daystoadd);
            testWeb1.Event_Time__c = '12:00';
            testWeb1.PrimaryPresenter__c = 'test presenter';
            testWeb1.Product_Presented__c = listofproducts[0];
            testWeb1.StampType__c = 'UTP OnDemand'; 
            testWebinars.add(testWeb1);
            daystoadd++;
        }
     
   
        
        insert testWebinars;
        
        et4ae5__SendDefinition__c emailSend = new et4ae5__SendDefinition__c();
        insert emailSend;
        
        //create test webinar attnds records

        Webinar_Attendance__c testWebAtt;
        
        // UTP data
       list<Webinar_Attendance__c> testAttendances = new List<Webinar_Attendance__c>();   
       index = 0;  
       for(Webinar__c web: testWebinars){
      // String stamp = maptoproductabbrv.get(web.Product_Presented__c); 
           
            Webinar_Attendance__c testWebAtt1 = new Webinar_Attendance__c();
            testWebAtt1.Account__c = testAccount1.id; //listofaccounts[0].Id;
            testWebAtt1.Webinar__c = web.id;
            testWebAtt1.Attended__c = true;
            testWebAtt1.Source_Other__c = 'test source';
            testWebAtt1.Duration__c = 40;
            testWebAtt1.Join_Time__c = (index == 5)? web.Event_Date_Time__c.addminutes(20): web.Event_Date_Time__c.addminutes(5);
            testWebAtt1.OnDemand_Views__c = 1;
            testWebAtt1.Credit_Name__c = 'test credit name';
            testWebAtt1.Credit_User__c = null;  // MAY NEED USER ID
            testWebAtt1.Stamp_Type__c = 'UTP';
            testWebAtt1.Status__c = 'Complete';
            testWebAtt1.IER_et4ae5_SendDefinition__c = emailSend.Id;
            testAttendances.add(testWebAtt1);
            
          
        }
        Handler_WebinarAttendance.AFTERFIRED = true;
   List<Database.SaveResult> insertWAs = Database.insert(testAttendances,false);
        for(Database.SaveResult results : insertWAs){  
            if (!results.isSuccess()) {
                for (Database.Error error : results.getErrors()) {
                    System.debug(Logginglevel.ERROR,'@asha: @debug:OppStamperTest: WA insert result:'+ error.getMessage());
                }
            }else{
                System.debug(Logginglevel.ERROR,'@asha:@debug: OppStamperTest: WA insert result: isSuccess'+ results.isSuccess());
            }
        }  

        List<Webinar_Attendance__c> listofwebattnd = [Select id,Webinar__c from webinar_Attendance__c];
        System.debug('@asha : @debug: Test_OpportunityStamper: size of web attendances created' + testAttendances.size());
        System.assertequals(testAttendances.size(),listofwebattnd.size());
        
        
             


           // testopp.StageName = 'Closed Won';            
           // update testopp;    
        // Begin Testing
        Test.startTest();
            Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
            oppMap.put(testopp.Id, testopp);
            

            
            OpportunityStamper.stampOpportunitiesSynchronous(oppMap);
            list<opportunity> oppsafterstagechange = [Select id,
            StageName,
            Sub_Stage__c,
            Charting_Start__c,
            Charting_Expiration__c,
            Purchase_Amount__c,  
            web_LMFS_FirstAttd__c,
            web_LMFS_LastAttd__c,
            web_LMFS_LastAttd25__c,
            web_UTP_FirstAttd__c,
            web_UTP_LastAttd__c,
            web_UTP_LastAttd25__c,
            web_UOC_FirstAttd__c,
            web_UOC_LastAttd__c,
            web_UOC_LastAttd25__c,
            Product__c
            From Opportunity 
            where id in: listopps];
        
                   //check to see if opp fields are not null and that stage is now closed won
           for(Opportunity o : oppsafterstagechange ){
               //change the stage to start the trigger               
               System.assertequals('Closed Won',o.StageName,'@asha : @debug: Test_OpportunityStamper: Stage is not closed won'+ o.stagename);  
               System.debug('@asha : @debug: Test_OpportunityStamper: Product is '+ o.Product__c);
               List<ID> webattndids = new list<ID>();
               //if lmfs
               if(o.Product__c == listofproducts[1]){

               System.assertnotequals(null,o.web_LMFS_FirstAttd__c,'@asha : @debug: Test_OpportunityStamper: LMFS 1st attnd is still null ' + o.web_LMFS_FirstAttd__c);
               System.assertnotequals(null,o.web_LMFS_LastAttd__c,'@asha : @debug: Test_OpportunityStamper: LMFS last attnd is still null ' + o.web_LMFS_LastAttd__c);             
               System.assertnotequals(null,o.web_LMFS_LastAttd25__c,'@asha : @debug: Test_OpportunityStamper: LMFS last attnd 25+ is still null ' + o.web_LMFS_LastAttd25__c);
               webattndids = new list<ID>();
               webattndids.add(o.web_LMFS_FirstAttd__c);
               webattndids.add(o.web_LMFS_LastAttd__c);
               webattndids.add(o.web_LMFS_LastAttd25__c);               
               Map<Id,Webinar_Attendance__c> webattndrecords = new Map<id,Webinar_Attendance__c>([Select id, Adjusted_Duration__c,WEBINAR_Event_Date__c  from Webinar_Attendance__c Where id in: webattndids ]);
               System.assertequals(3, webattndrecords.keyset().size());
               System.assert(webattndrecords.get(o.web_LMFS_FirstAttd__c).WEBINAR_Event_Date__c > webattndrecords.get(o.web_LMFS_LastAttd__c).WEBINAR_Event_Date__c, '@asha:@debug:Test_OpportunityStamper Issue with first attended web attend and last attend: last:'+webattndrecords.get(o.web_LMFS_LastAttd__c).WEBINAR_Event_Date__c+' first '+webattndrecords.get(o.web_LMFS_FirstAttd__c).WEBINAR_Event_Date__c );
               System.assert(webattndrecords.get(o.web_LMFS_LastAttd25__c).Adjusted_Duration__c > 25, '@asha:@debug:Test_OpportunityStampter : Issue with last webinar being greater than 25 minutes: duration '+webattndrecords.get(o.web_UTP_LastAttd25__c).Adjusted_Duration__c );
               
               
               }
                //if utp
               if(o.Product__c == listofproducts[0]){
               System.assertnotequals(null,o.web_UTP_FirstAttd__c,'@asha : @debug: Test_OpportunityStamper: UTP 1st attnd is still null' + o.web_UTP_FirstAttd__c);
               System.assertnotequals(null,o.web_UTP_LastAttd__c,'@asha : @debug: Test_OpportunityStamper: UTP last attnd is still null' + o.web_UTP_LastAttd__c);
               System.assertnotequals(null,o.web_UTP_LastAttd25__c,'@asha : @debug: Test_OpportunityStamper: UTP last attnd 25+is still null' + o.web_UTP_LastAttd25__c);
                webattndids = new list<ID>();
               webattndids.add(o.web_UTP_FirstAttd__c);
               webattndids.add(o.web_UTP_LastAttd__c);
               webattndids.add(o.web_UTP_LastAttd25__c);               
               Map<Id,Webinar_Attendance__c> webattndrecords = new Map<id,Webinar_Attendance__c>([Select id, Adjusted_Duration__c,WEBINAR_Event_Date__c  from Webinar_Attendance__c Where id in: webattndids ]);
               System.assertequals(3, webattndrecords.keyset().size());
               System.debug('@asha: Test_OpportunityStamper utp First attended webinar event date: '+ webattndrecords.get(o.web_UTP_FirstAttd__c).WEBINAR_Event_Date__c );
               System.debug('@asha: Test_OpportunityStamper utp First attended webinar event date: '+ webattndrecords.get(o.web_UTP_LastAttd__c).WEBINAR_Event_Date__c );
               System.debug('@asha: Test_OpportunityStamper utp First attended webinar event date: '+ webattndrecords.get(o.web_UTP_LastAttd25__c).WEBINAR_Event_Date__c );                              
               System.assert(webattndrecords.get(o.web_UTP_FirstAttd__c).WEBINAR_Event_Date__c > webattndrecords.get(o.web_UTP_LastAttd__c).WEBINAR_Event_Date__c, '@asha:@debug:Test_OpportunityStamper Issue with first attended web attend and last attend: last:'+webattndrecords.get(o.web_UTP_LastAttd__c).WEBINAR_Event_Date__c+' first '+webattndrecords.get(o.web_UTP_FirstAttd__c).WEBINAR_Event_Date__c );
               System.assert(webattndrecords.get(o.web_UTP_LastAttd25__c).Adjusted_Duration__c > 25, '@asha:@debug:Test_OpportunityStampter : Issue with last webinar being greater than 25 minutes: duration '+webattndrecords.get(o.web_UTP_LastAttd25__c).Adjusted_Duration__c );
               
               
               }
               //if uoc
               if(o.Product__c == listofproducts[2]){
               System.assertnotequals(null,o.web_UOC_FirstAttd__c,'@asha : @debug: Test_OpportunityStamper: UOC  1st attnd is still null' + o.web_UOC_FirstAttd__c);
               System.assertnotequals(null,o.web_UOC_LastAttd__c,'@asha : @debug: Test_OpportunityStamper: UOC last attnd is still null' + o.web_UOC_LastAttd__c);
               System.assertnotequals(null,o.web_UOC_LastAttd25__c,'@asha : @debug: Test_OpportunityStamper: UOC last attnd 25+ is still null' + o.web_UOC_LastAttd25__c); 
               
               webattndids = new list<ID>();
               webattndids.add(o.web_UOC_FirstAttd__c);
               webattndids.add(o.web_UOC_LastAttd__c);
               webattndids.add(o.web_UOC_LastAttd25__c);
               Map<Id,Webinar_Attendance__c> webattndrecords = new Map<id,Webinar_Attendance__c>([Select id, Adjusted_Duration__c,WEBINAR_Event_Date__c  from Webinar_Attendance__c Where id in: webattndids ]);
               System.assertequals(3, webattndrecords.keyset().size());
               System.assert(webattndrecords.get(o.web_UOC_LastAttd__c).WEBINAR_Event_Date__c > webattndrecords.get(o.web_UOC_FirstAttd__c).WEBINAR_Event_Date__c, '@asha:@debug:Test_OpportunityStamper Issue with first attended web attend and last attend: last:'+webattndrecords.get(o.web_UOC_LastAttd__c).WEBINAR_Event_Date__c+' first '+webattndrecords.get(o.web_UOC_FirstAttd__c).WEBINAR_Event_Date__c );
               System.assert(webattndrecords.get(o.web_UOC_LastAttd25__c).Adjusted_Duration__c > 25, '@asha:@debug:Test_OpportunityStampter : Issue with last webinar being greater than 25 minutes: duration '+webattndrecords.get(o.web_UOC_LastAttd25__c).Adjusted_Duration__c );
               
               
               
               }  
           }          
        Test.stopTest();
        
    }
    
/******************
    @method:
    testStamper2
    
    @description:
    -Setup the custom setting for the OpportunityStamperMapping which has a correlation between previous 
    product names and current product names
    - Create test accounts,test Opportunities, test webinars and test webinar attnds records
    - test is for Live Market Forex Session product
    - checks to see which product is being tested (LMFS,UOC,UTP) - since teststamper2 is just LMFS only the 1st loop is run
    - verifies that the webinar attendance record marked as the first, latest and latest with a duration over 25 are not null 
    - verifies that the first attendance webinar event date is greater than the latest attended
    - verifies that the latest 25+ adjusted duration is greater than 25 minutes
        
**/   

  static testMethod void testStamper2() {
        
      //setup recordTypeID map for Opp and Account
      Map<String, ID> recmapopp = recTypeIDOpportunity();
      Map<String, ID> recmapacct = recTypeIDAccount();      
    
    //create list of products
        List<String> listofproducts = new List<String>();
        listofproducts.add('UTP OnDemand');
        listofproducts.add('Live Market Forex Session');
        listofproducts.add('Ultimate Options Course');
        
        Map<String,String> maptoproductabbrv = new Map<String,String>();
        maptoproductabbrv.put('UTP OnDemand','UTP');
        maptoproductabbrv.put('Live Market Forex Session','LMFS');
        maptoproductabbrv.put('Ultimate Options Course','UOC');
       
    
     //create test accounts
        list<Account> listofaccounts = new List<Account>();        
        Account testAccount1 = new Account();
        
       // for(integer i = 0; i< 5; i++){  
        testAccount1 = new Account();
             testAccount1.FirstName = 'testfirstname'+ 1;//i;
             testAccount1.LastName = 'testlastname' +1; //i;
             testAccount1.RecordTypeID = recmapacct.get('Person Account');  
             testAccount1.Lead_Source_LMFS__c = 'Test lead source'; 
             testAccount1.Lead_Source_LMFS_PREV__c = 'Test lead source';     
             testAccount1.Lead_Source_UOC__c   = 'Test lead source';  
             testAccount1.Lead_Source_UOC_PREV__c  = 'Test lead source';               
             testAccount1.Lead_Source_UTP__c = 'Test lead source';                 
             testAccount1.Lead_Source_previous__c = 'Test lead source';                 
             testAccount1.Lead_Source_Date_LMFS__c = Date.today().adddays(-5);                
             testAccount1.Lead_Source_Date_LMFS_PREV__c = Date.today().adddays(-5);    
             testAccount1.Lead_Source_Date_UOC__c = Date.today().adddays(-5);                
             testAccount1.Lead_Source_Date_UOC_PREV__c = Date.today().adddays(-5);                  
             testAccount1.Lead_Source_Date__c = Date.today().adddays(-5);                 
             testAccount1.Lead_Source_Date_previous__c = Date.today().adddays(-5); 
             testAccount1.Lead_Source_Detail_LMFS__c  = 'Test lead source';   
             testAccount1.Lead_Source_Detail_LMFS_PREV__c  = 'Test lead source';               
             testAccount1.Lead_Source_Detail_UOC__c = 'Test lead source';                  
             testAccount1.Lead_Source_Detail_UOC_PREV__c  = 'Test lead source';                
             testAccount1.Lead_Source_Detail__c   = 'Test lead source';                          
             testAccount1.Lead_Source_Detail_previous__c = 'Test lead source';
    insert testAccount1;
            
    //create test opps
        List<Opportunity> listopps = new List<Opportunity>();
        Opportunity testopp = new Opportunity();        
 
            testopp = new Opportunity();
            testopp.Name = 'test opp '+1; //i;
            testopp.recordTypeID = recmapopp.get('Micro'); // changed to sorted by rectype aac 3.13.16 - Micro = LMFS
            testopp.CloseDate = date.today().adddays(-1);
            testopp.AccountID  = testAccount1.id; 
            testopp.Closed_By__c = UserInfo.getUserId();
            testopp.Product__c = listofproducts[1]; 
            testopp.AVSFQB__Generate_Object__c = 'None';
            testopp.Sale_Invoice_First_Date_After_Down__c = Date.today();
            testopp.Sale_Invoice_Qty_Payments_After_Down__c = 1;
            testopp.StageName = 'Closed Won';
            testopp.Sub_Stage__c = 'Cancelled';
            testopp.Charting_Start__c = Date.today(); 
            testopp.Charting_Expiration__c = Date.today(); 
            testopp.LeadSource = 'Webinar';
            testopp.Purchase_Amount__c = 0;  
            testopp.web_LMFS_FirstAttd__c = null;
            testopp.web_LMFS_LastAttd__c = null;
            testopp.web_LMFS_LastAttd25__c = null;
            testopp.web_UTP_FirstAttd__c = null;
            testopp.web_UTP_LastAttd__c = null;
            testopp.web_UTP_LastAttd25__c = null;
            testopp.web_UOC_FirstAttd__c = null;
            testopp.web_UOC_LastAttd__c = null;
            testopp.web_UOC_LastAttd25__c = null;          
            testopp.Amount = 0;

  Database.SaveResult insertResultsWA = Database.insert(testopp,false);
  Database.SaveResult result = insertResultsWA;  
        if (!result.isSuccess()) {
            for (Database.Error error : result.getErrors()) {
                System.debug(Logginglevel.ERROR,'@asha: @debug:OppStamperTest: Opp insert result:'+ error.getMessage());
            }
        }else{
            System.debug(Logginglevel.ERROR,'@asha:@debug: OppStamperTest: Opp insert result: isSuccess'+ result.isSuccess());
        }
   

         
     //create test webinars   
      Integer daystoadd = 0;
        List<Webinar__c> testWebinars = new List<Webinar__c>();
    
       
        Webinar__c testWeb2 = new Webinar__c();
        for(integer i = 0; i< 5; i++){
            testWeb2 = new Webinar__c();
            testWeb2.Name = 'test webinar LMFS '+i;
            testWeb2.Webinar_ID__c = 'LMFS-testwebid-'+i;            
            testWeb2.Event_Date_Time__c = Datetime.now().addDays(-daystoadd);
            testWeb2.Event_Time__c = '12:00';
            testWeb2.PrimaryPresenter__c = 'test presenter';
            testWeb2.Product_Presented__c = listofproducts[1]; //lmfs in the product list 
            testWeb2.StampType__c = 'Live Market Forex Session';
            testWebinars.add(testWeb2);
            daystoadd++;
        }        

        
        insert testWebinars;
        
        et4ae5__SendDefinition__c emailSend = new et4ae5__SendDefinition__c();
        insert emailSend;
        
        //create test webinar attnds records

        Webinar_Attendance__c testWebAtt;
        
        // LMFS data
       list<Webinar_Attendance__c> testAttendances = new List<Webinar_Attendance__c>();   
       Integer index   =0;
       for(Webinar__c web: testWebinars){

            
            Webinar_Attendance__c testWebAtt2 = new Webinar_Attendance__c();
            testWebAtt2.Account__c = testAccount1.id;
            testWebAtt2.Webinar__c = web.id;
            testWebAtt2.Attended__c = true;
            testWebAtt2.Source_Other__c = 'test source';
            testWebAtt2.Duration__c = 40;
            testWebAtt2.Join_Time__c = (index == 5)? web.Event_Date_Time__c.addminutes(20): web.Event_Date_Time__c.addminutes(5);
            testWebAtt2.OnDemand_Views__c = 1;
            testWebAtt2.Credit_Name__c = 'test credit name';
            testWebAtt2.Credit_User__c = null;  // MAY NEED USER ID
            testWebAtt2.Stamp_Type__c = 'LMFS';
            testWebAtt2.Status__c = 'Complete';
            testWebAtt2.IER_et4ae5_SendDefinition__c = emailSend.Id;
            testAttendances.add(testWebAtt2);           
       
        }
        
     Handler_WebinarAttendance.AFTERFIRED = true;
   	List<Database.SaveResult> insertWAs = Database.insert(testAttendances,false);
        for(Database.SaveResult results : insertWAs){  
            if (!results.isSuccess()) {
                for (Database.Error error : results.getErrors()) {
                    System.debug(Logginglevel.ERROR,'@asha: @debug:OppStamperTest: WA insert result:'+ error.getMessage());
                }
            }else{
                System.debug(Logginglevel.ERROR,'@asha:@debug: OppStamperTest: WA insert result: isSuccess'+ results.isSuccess());
            }
        }  
        List<Webinar_Attendance__c> listofwebattnd = [Select id,Webinar__c from webinar_Attendance__c];
        System.debug('@asha : @debug: Test_OpportunityStamper: size of web attendances created' + testAttendances.size());
        System.assertequals(testAttendances.size(),listofwebattnd.size());
      
        // Begin Testing
        Test.startTest();
            Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
            oppMap.put(testopp.Id, testopp);
            List<Id> oppidlist = new list<id>();
            oppidlist.addAll(oppMap.keySet());
			
            OpportunityStamper.stampOpportunitiesSynchronous(oppMap);
            list<opportunity> oppsafterstagechange = [Select id,
            StageName,
            Sub_Stage__c,
            Charting_Start__c,
            Charting_Expiration__c,
            Purchase_Amount__c,  
            web_LMFS_FirstAttd__c,
            web_LMFS_LastAttd__c,
            web_LMFS_LastAttd25__c,
            web_UTP_FirstAttd__c,
            web_UTP_LastAttd__c,
            web_UTP_LastAttd25__c,
            web_UOC_FirstAttd__c,
            web_UOC_LastAttd__c,
            web_UOC_LastAttd25__c,
            Product__c
            From Opportunity 
            where id in: listopps];
        
                   //check to see if opp fields are not null and that stage is now closed won
           for(Opportunity o : oppsafterstagechange ){
               //change the stage to start the trigger               
               System.assertequals('Closed Won',o.StageName,'@asha : @debug: Test_OpportunityStamper: Stage is not closed won'+ o.stagename);  
               System.debug('@asha : @debug: Test_OpportunityStamper: Product is '+ o.Product__c);
               List<ID> webattndids = new list<ID>();
               //if lmfs
               if(o.Product__c == listofproducts[1]){

               System.assertnotequals(null,o.web_LMFS_FirstAttd__c,'@asha : @debug: Test_OpportunityStamper: LMFS 1st attnd is still null ' + o.web_LMFS_FirstAttd__c);
               System.assertnotequals(null,o.web_LMFS_LastAttd__c,'@asha : @debug: Test_OpportunityStamper: LMFS last attnd is still null ' + o.web_LMFS_LastAttd__c);             
               System.assertnotequals(null,o.web_LMFS_LastAttd25__c,'@asha : @debug: Test_OpportunityStamper: LMFS last attnd 25+ is still null ' + o.web_LMFS_LastAttd25__c);
               webattndids = new list<ID>();
               webattndids.add(o.web_LMFS_FirstAttd__c);
               webattndids.add(o.web_LMFS_LastAttd__c);
               webattndids.add(o.web_LMFS_LastAttd25__c);               
               Map<Id,Webinar_Attendance__c> webattndrecords = new Map<id,Webinar_Attendance__c>([Select id, Adjusted_Duration__c,WEBINAR_Event_Date__c  from Webinar_Attendance__c Where id in: webattndids ]);
               System.assertequals(3, webattndrecords.keyset().size());
               System.debug('@asha: Test_OpportunityStamper lmfs First attended webinar event date: '+ webattndrecords.get(o.web_LMFS_FirstAttd__c).WEBINAR_Event_Date__c );
               System.debug('@asha: Test_OpportunityStamper lmfs First attended webinar event date: '+ webattndrecords.get(o.web_LMFS_LastAttd__c).WEBINAR_Event_Date__c );
               System.debug('@asha: Test_OpportunityStamper lmfs First attended webinar event date: '+ webattndrecords.get(o.web_LMFS_LastAttd25__c).WEBINAR_Event_Date__c );   
               System.assertequals(3, webattndrecords.keyset().size());
               System.assert(webattndrecords.get(o.web_LMFS_FirstAttd__c).WEBINAR_Event_Date__c < webattndrecords.get(o.web_LMFS_LastAttd__c).WEBINAR_Event_Date__c, '@asha:@debug:Test_OpportunityStamper Issue with first attended web attend and last attend: last:'+webattndrecords.get(o.web_LMFS_LastAttd__c).WEBINAR_Event_Date__c+' first '+webattndrecords.get(o.web_LMFS_FirstAttd__c).WEBINAR_Event_Date__c );
               System.assert(webattndrecords.get(o.web_LMFS_LastAttd25__c).Adjusted_Duration__c > 25, '@asha:@debug:Test_OpportunityStampter : Issue with last webinar being greater than 25 minutes: duration '+webattndrecords.get(o.web_UTP_LastAttd25__c).Adjusted_Duration__c );
               
               
               }
                //if utp
               if(o.Product__c == listofproducts[0]){
               System.assertnotequals(null,o.web_UTP_FirstAttd__c,'@asha : @debug: Test_OpportunityStamper: UTP 1st attnd is still null' + o.web_UTP_FirstAttd__c);
               System.assertnotequals(null,o.web_UTP_LastAttd__c,'@asha : @debug: Test_OpportunityStamper: UTP last attnd is still null' + o.web_UTP_LastAttd__c);
               System.assertnotequals(null,o.web_UTP_LastAttd25__c,'@asha : @debug: Test_OpportunityStamper: UTP last attnd 25+is still null' + o.web_UTP_LastAttd25__c);
                webattndids = new list<ID>();
               webattndids.add(o.web_UTP_FirstAttd__c);
               webattndids.add(o.web_UTP_LastAttd__c);
               webattndids.add(o.web_UTP_LastAttd25__c);               
               Map<Id,Webinar_Attendance__c> webattndrecords = new Map<id,Webinar_Attendance__c>([Select id, Adjusted_Duration__c,WEBINAR_Event_Date__c  from Webinar_Attendance__c Where id in: webattndids ]);
               System.assertequals(3, webattndrecords.keyset().size());
               System.assert(webattndrecords.get(o.web_UTP_FirstAttd__c).WEBINAR_Event_Date__c > webattndrecords.get(o.web_UTP_LastAttd__c).WEBINAR_Event_Date__c, '@asha:@debug:Test_OpportunityStamper Issue with first attended web attend and last attend: last:'+webattndrecords.get(o.web_UTP_LastAttd__c).WEBINAR_Event_Date__c+' first '+webattndrecords.get(o.web_UTP_FirstAttd__c).WEBINAR_Event_Date__c );
               System.assert(webattndrecords.get(o.web_UTP_LastAttd25__c).Adjusted_Duration__c > 25, '@asha:@debug:Test_OpportunityStampter : Issue with last webinar being greater than 25 minutes: duration '+webattndrecords.get(o.web_UTP_LastAttd25__c).Adjusted_Duration__c );
               
               }
               //if uoc
               if(o.Product__c == listofproducts[2]){
               System.assertnotequals(null,o.web_UOC_FirstAttd__c,'@asha : @debug: Test_OpportunityStamper: UOC  1st attnd is still null' + o.web_UOC_FirstAttd__c);
               System.assertnotequals(null,o.web_UOC_LastAttd__c,'@asha : @debug: Test_OpportunityStamper: UOC last attnd is still null' + o.web_UOC_LastAttd__c);
               System.assertnotequals(null,o.web_UOC_LastAttd25__c,'@asha : @debug: Test_OpportunityStamper: UOC last attnd 25+ is still null' + o.web_UOC_LastAttd25__c); 
               webattndids = new list<ID>();
               webattndids.add(o.web_UOC_FirstAttd__c);
               webattndids.add(o.web_UOC_LastAttd__c);
               webattndids.add(o.web_UOC_LastAttd25__c);
               Map<Id,Webinar_Attendance__c> webattndrecords = new Map<id,Webinar_Attendance__c>([Select id, Adjusted_Duration__c,WEBINAR_Event_Date__c  from Webinar_Attendance__c Where id in: webattndids ]);
               System.assertequals(3, webattndrecords.keyset().size());
               System.assert(webattndrecords.get(o.web_UOC_LastAttd__c).WEBINAR_Event_Date__c > webattndrecords.get(o.web_UOC_FirstAttd__c).WEBINAR_Event_Date__c, '@asha:@debug:Test_OpportunityStamper Issue with first attended web attend and last attend: last:'+webattndrecords.get(o.web_UOC_LastAttd__c).WEBINAR_Event_Date__c+' first '+webattndrecords.get(o.web_UOC_FirstAttd__c).WEBINAR_Event_Date__c );
               System.assert(webattndrecords.get(o.web_UOC_LastAttd25__c).Adjusted_Duration__c > 25, '@asha:@debug:Test_OpportunityStampter : Issue with last webinar being greater than 25 minutes: duration '+webattndrecords.get(o.web_UOC_LastAttd25__c).Adjusted_Duration__c );
               
              
               }  
           }          
        Test.stopTest();
        
    }
    
/******************
    @method:
    testStamper3
    
    @description:
    -Setup the custom setting for the OpportunityStamperMapping which has a correlation between previous 
    product names and current product names
    - Create test accounts,test Opportunities, test webinars and test webinar attnds records
    - test is for UOC product
    - checks to see which product is being tested (LMFS,UOC,UTP) - since testStamper3 is just UOC only the 1st loop is run
    - verifies that the webinar attendance record marked as the first, latest and latest with a duration over 25 are not null 
    - verifies that the first attendance webinar event date is greater than the latest attended
    - verifies that the latest 25+ adjusted duration is greater than 25 minutes
        
**/       
    
        static testMethod void testStamper3() {
        
      //setup recordTypeID map for Opp and Account
      Map<String, ID> recmapopp = recTypeIDOpportunity();
      Map<String, ID> recmapacct = recTypeIDAccount();      
    
    //create list of products
        List<String> listofproducts = new List<String>();
        listofproducts.add('UTP OnDemand');
        listofproducts.add('Live Market Forex Session');
        listofproducts.add('Ultimate Options Course');
        
        Map<String,String> maptoproductabbrv = new Map<String,String>();
        maptoproductabbrv.put('UTP OnDemand','UTP');
        maptoproductabbrv.put('Live Market Forex Session','LMFS');
        maptoproductabbrv.put('Ultimate Options Course','UOC');
       
    
     //create test accounts
        list<Account> listofaccounts = new List<Account>();        
        Account testAccount1 = new Account();
        
        testAccount1 = new Account();
             testAccount1.FirstName = 'testfirstname'+ 1;//i;
             testAccount1.LastName = 'testlastname' +1; //i;
             testAccount1.RecordTypeID = recmapacct.get('Person Account');  
             testAccount1.Lead_Source_LMFS__c = 'Test lead source'; 
             testAccount1.Lead_Source_LMFS_PREV__c = 'Test lead source';     
             testAccount1.Lead_Source_UOC__c   = 'Test lead source';  
             testAccount1.Lead_Source_UOC_PREV__c  = 'Test lead source';               
             testAccount1.Lead_Source_UTP__c = 'Test lead source';                 
             testAccount1.Lead_Source_previous__c = 'Test lead source';                 
             testAccount1.Lead_Source_Date_LMFS__c = Date.today().adddays(-5);                
             testAccount1.Lead_Source_Date_LMFS_PREV__c = Date.today().adddays(-5);    
             testAccount1.Lead_Source_Date_UOC__c = Date.today().adddays(-5);                
             testAccount1.Lead_Source_Date_UOC_PREV__c = Date.today().adddays(-5);                  
             testAccount1.Lead_Source_Date__c = Date.today().adddays(-5);                 
             testAccount1.Lead_Source_Date_previous__c = Date.today().adddays(-5); 
             testAccount1.Lead_Source_Detail_LMFS__c  = 'Test lead source';   
             testAccount1.Lead_Source_Detail_LMFS_PREV__c  = 'Test lead source';               
             testAccount1.Lead_Source_Detail_UOC__c = 'Test lead source';                  
             testAccount1.Lead_Source_Detail_UOC_PREV__c  = 'Test lead source';                
             testAccount1.Lead_Source_Detail__c   = 'Test lead source';                          
             testAccount1.Lead_Source_Detail_previous__c = 'Test lead source';

    insert testAccount1;
            
    //create test opps
        List<Opportunity> listopps = new List<Opportunity>();
        Opportunity testopp = new Opportunity();        
     
            testopp = new Opportunity();
            testopp.Name = 'test opp '+1; 
            testopp.recordTypeID = recmapopp.get('Options'); // changed to sorted by rectype aac 3.13.16 - Options = UOC
            testopp.CloseDate = date.today().adddays(-1);
            testopp.AccountID  = testAccount1.id; 
            testopp.Closed_By__c = UserInfo.getUserId();
            testopp.Product__c = listofproducts[2]; //uoc prod
            testopp.AVSFQB__Generate_Object__c = 'None';
            testopp.Sale_Invoice_First_Date_After_Down__c = Date.today();
            testopp.Sale_Invoice_Qty_Payments_After_Down__c = 1;
            testopp.StageName = 'Closed Won';
            testopp.Sub_Stage__c = 'Cancelled';
            testopp.Charting_Start__c = Date.today(); 
            testopp.Charting_Expiration__c = Date.today(); 
            testopp.LeadSource = 'Webinar';
            testopp.Purchase_Amount__c = 0;  
            testopp.web_LMFS_FirstAttd__c = null;
            testopp.web_LMFS_LastAttd__c = null;
            testopp.web_LMFS_LastAttd25__c = null;
            testopp.web_UTP_FirstAttd__c = null;
            testopp.web_UTP_LastAttd__c = null;
            testopp.web_UTP_LastAttd25__c = null;
            testopp.web_UOC_FirstAttd__c = null;
            testopp.web_UOC_LastAttd__c = null;
            testopp.web_UOC_LastAttd25__c = null;          
            testopp.Amount = 0;

    insert testopp;

          
     //create test webinars   
      Integer daystoadd = 0;
        List<Webinar__c> testWebinars = new List<Webinar__c>();

        Webinar__c testWeb3 = new Webinar__c();

        for(integer i = 0; i <5; i++){
            testWeb3 = new Webinar__c();
            testWeb3.Name = 'test webinar UOC '+i;
            testWeb3.Webinar_ID__c = 'UOC-testwebid-'+i;            
            testWeb3.Event_Date_Time__c = Datetime.now().adddays(-daystoadd);
            testWeb3.Event_Time__c = '12:00';
            testWeb3.PrimaryPresenter__c = 'test presenter 2';
            testWeb3.Product_Presented__c = listofproducts[2]; //uoc prod
            testWeb3.StampType__c = 'Ultimate Options Course';
            testWebinars.add(testWeb3);
            daystoadd++;
        }
        
        
        insert testWebinars;
        
        et4ae5__SendDefinition__c emailSend = new et4ae5__SendDefinition__c();
        insert emailSend;
        
        //create test webinar attnds records

        Webinar_Attendance__c testWebAtt;
        
        // UOC data
       list<Webinar_Attendance__c> testAttendances = new List<Webinar_Attendance__c>();   
      Integer index = 0;  
       for(Webinar__c web: testWebinars){
          
            Webinar_Attendance__c testWebAtt1 = new Webinar_Attendance__c();
            testWebAtt1.Account__c = testAccount1.id; 
            testWebAtt1.Webinar__c = web.id;
            testWebAtt1.Attended__c = true;
            testWebAtt1.Source_Other__c = 'test source';
            testWebAtt1.Duration__c = 40;
            testWebAtt1.Join_Time__c = (index == 5)? web.Event_Date_Time__c.addminutes(20): web.Event_Date_Time__c.addminutes(5);
            testWebAtt1.OnDemand_Views__c = 1;
            testWebAtt1.Credit_Name__c = 'test credit name';
            testWebAtt1.Credit_User__c = null;  // MAY NEED USER ID
            testWebAtt1.Stamp_Type__c = 'UOC';
            testWebAtt1.Status__c = 'Complete';
            testWebAtt1.IER_et4ae5_SendDefinition__c = emailSend.Id;
            testAttendances.add(testWebAtt1);     
            
        }
        
   
        insert testAttendances;
        List<Webinar_Attendance__c> listofwebattnd = [Select id,Webinar__c from webinar_Attendance__c];
        System.debug('@asha : @debug: Test_OpportunityStamper: size of web attendances created' + testAttendances.size());
        System.assertequals(testAttendances.size(),listofwebattnd.size());
      
        // Begin Testing
        Test.startTest();
            Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
            oppMap.put(testopp.Id, testopp);
            List<Id> oppidlist = new list<id>();
            oppidlist.addAll(oppMap.keySet());
            testopp.StageName = 'Closed Won';            
            update testopp;
            OpportunityStamper.stampOpportunitiesAsynchronous(oppidlist);
            list<opportunity> oppsafterstagechange = [Select id,
            StageName,
            Sub_Stage__c,
            Charting_Start__c,
            Charting_Expiration__c,
            Purchase_Amount__c,  
            web_LMFS_FirstAttd__c,
            web_LMFS_LastAttd__c,
            web_LMFS_LastAttd25__c,
            web_UTP_FirstAttd__c,
            web_UTP_LastAttd__c,
            web_UTP_LastAttd25__c,
            web_UOC_FirstAttd__c,
            web_UOC_LastAttd__c,
            web_UOC_LastAttd25__c,
            Product__c
            From Opportunity 
            where id in: listopps];
        
                   //check to see if opp fields are not null and that stage is now closed won
           for(Opportunity o : oppsafterstagechange ){
               //change the stage to start the trigger               
               System.assertequals('Closed Won',o.StageName,'@asha : @debug: Test_OpportunityStamper: Stage is not closed won'+ o.stagename);  
               System.debug('@asha : @debug: Test_OpportunityStamper: Product is '+ o.Product__c);
                List<ID> webattndids = new list<ID>();
               //if lmfs
               if(o.Product__c == listofproducts[1]){

               System.assertnotequals(null,o.web_LMFS_FirstAttd__c,'@asha : @debug: Test_OpportunityStamper: LMFS 1st attnd is still null ' + o.web_LMFS_FirstAttd__c);
               System.assertnotequals(null,o.web_LMFS_LastAttd__c,'@asha : @debug: Test_OpportunityStamper: LMFS last attnd is still null ' + o.web_LMFS_LastAttd__c);             
               System.assertnotequals(null,o.web_LMFS_LastAttd25__c,'@asha : @debug: Test_OpportunityStamper: LMFS last attnd 25+ is still null ' + o.web_LMFS_LastAttd25__c);                                      
               webattndids = new list<ID>();
               webattndids.add(o.web_LMFS_FirstAttd__c);
               webattndids.add(o.web_LMFS_LastAttd__c);
               webattndids.add(o.web_LMFS_LastAttd25__c);               
               Map<Id,Webinar_Attendance__c> webattndrecords = new Map<id,Webinar_Attendance__c>([Select id, Adjusted_Duration__c,WEBINAR_Event_Date__c  from Webinar_Attendance__c Where id in: webattndids ]);
               System.assertequals(3, webattndrecords.keyset().size());
               System.assert(webattndrecords.get(o.web_LMFS_FirstAttd__c).WEBINAR_Event_Date__c < webattndrecords.get(o.web_LMFS_LastAttd__c).WEBINAR_Event_Date__c, '@asha:@debug:Test_OpportunityStamper Issue with first attended web attend and last attend: last:'+webattndrecords.get(o.web_LMFS_LastAttd__c).WEBINAR_Event_Date__c+' first '+webattndrecords.get(o.web_LMFS_FirstAttd__c).WEBINAR_Event_Date__c );
               System.assert(webattndrecords.get(o.web_LMFS_LastAttd25__c).Adjusted_Duration__c > 25, '@asha:@debug:Test_OpportunityStampter : Issue with last webinar being greater than 25 minutes: duration '+webattndrecords.get(o.web_UTP_LastAttd25__c).Adjusted_Duration__c );
               
              
               
               }
                //if utp
               if(o.Product__c == listofproducts[0]){
               System.assertnotequals(null,o.web_UTP_FirstAttd__c,'@asha : @debug: Test_OpportunityStamper: UTP 1st attnd is still null' + o.web_UTP_FirstAttd__c);
               System.assertnotequals(null,o.web_UTP_LastAttd__c,'@asha : @debug: Test_OpportunityStamper: UTP last attnd is still null' + o.web_UTP_LastAttd__c);
               System.assertnotequals(null,o.web_UTP_LastAttd25__c,'@asha : @debug: Test_OpportunityStamper: UTP last attnd 25+is still null' + o.web_UTP_LastAttd25__c);
               
               webattndids = new list<ID>();
               webattndids.add(o.web_UTP_FirstAttd__c);
               webattndids.add(o.web_UTP_LastAttd__c);
               webattndids.add(o.web_UTP_LastAttd25__c);               
               Map<Id,Webinar_Attendance__c> webattndrecords = new Map<id,Webinar_Attendance__c>([Select id, Adjusted_Duration__c,WEBINAR_Event_Date__c  from Webinar_Attendance__c Where id in: webattndids ]);
               System.assertequals(3, webattndrecords.keyset().size());
               System.assert(webattndrecords.get(o.web_UTP_LastAttd__c).WEBINAR_Event_Date__c > webattndrecords.get(o.web_UTP_FirstAttd__c).WEBINAR_Event_Date__c, '@asha:@debug:Test_OpportunityStamper Issue with first attended web attend and last attend: last:'+webattndrecords.get(o.web_UTP_LastAttd__c).WEBINAR_Event_Date__c+' first '+webattndrecords.get(o.web_UTP_FirstAttd__c).WEBINAR_Event_Date__c );
               System.assert(webattndrecords.get(o.web_UTP_LastAttd25__c).Adjusted_Duration__c > 25, '@asha:@debug:Test_OpportunityStampter : Issue with last webinar being greater than 25 minutes: duration '+webattndrecords.get(o.web_UTP_LastAttd25__c).Adjusted_Duration__c );
               
              
               }
               //if uoc
               if(o.Product__c == listofproducts[2]){
               System.assertnotequals(null,o.web_UOC_FirstAttd__c,'@asha : @debug: Test_OpportunityStamper: UOC  1st attnd is still null' + o.web_UOC_FirstAttd__c);
               System.assertnotequals(null,o.web_UOC_LastAttd__c,'@asha : @debug: Test_OpportunityStamper: UOC last attnd is still null' + o.web_UOC_LastAttd__c);
               System.assertnotequals(null,o.web_UOC_LastAttd25__c,'@asha : @debug: Test_OpportunityStamper: UOC last attnd 25+ is still null' + o.web_UOC_LastAttd25__c); 
               
               webattndids = new list<ID>();
               webattndids.add(o.web_UOC_FirstAttd__c);
               webattndids.add(o.web_UOC_LastAttd__c);
               webattndids.add(o.web_UOC_LastAttd25__c);
               Map<Id,Webinar_Attendance__c> webattndrecords = new Map<id,Webinar_Attendance__c>([Select id, Adjusted_Duration__c,WEBINAR_Event_Date__c  from Webinar_Attendance__c Where id in: webattndids ]);
               System.assertequals(3, webattndrecords.keyset().size());
               System.debug('@asha: Test_OpportunityStamper UOC First attended webinar event date: '+ webattndrecords.get(o.web_UOC_FirstAttd__c).WEBINAR_Event_Date__c );
               System.debug('@asha: Test_OpportunityStamper UOC latest attended webinar event date: '+ webattndrecords.get(o.web_UOC_LastAttd__c).WEBINAR_Event_Date__c );
               System.debug('@asha: Test_OpportunityStamper UOC latest 25+ attended webinar event date: '+ webattndrecords.get(o.web_UOC_LastAttd25__c).WEBINAR_Event_Date__c );   
               System.assertequals(3, webattndrecords.keyset().size());
               System.assert(webattndrecords.get(o.web_UOC_LastAttd__c).WEBINAR_Event_Date__c > webattndrecords.get(o.web_UOC_FirstAttd__c).WEBINAR_Event_Date__c, '@asha:@debug:Test_OpportunityStamper Issue with first attended web attend and last attend: last:'+webattndrecords.get(o.web_UOC_LastAttd__c).WEBINAR_Event_Date__c+' first '+webattndrecords.get(o.web_UOC_FirstAttd__c).WEBINAR_Event_Date__c );
               System.assert(webattndrecords.get(o.web_UOC_LastAttd25__c).Adjusted_Duration__c > 25, '@asha:@debug:Test_OpportunityStampter : Issue with last webinar being greater than 25 minutes: duration '+webattndrecords.get(o.web_UOC_LastAttd25__c).Adjusted_Duration__c );
               
               
               }  
           }          
        Test.stopTest();
        
    }
    
    /******************
    @method:
    testStamper4
    
    @description:
    -Setup the custom setting for the OpportunityStamperMapping which has a correlation between previous 
    product names and current product names
    - Create test accounts,test Opportunities, test webinars and test webinar attnds records
    - test is for UOC product
    - checks to see which product is being tested (LMFS,UOC,UTP) - since testStamper4 is just BE only the 1 loop is run
    - verifies that the webinar attendance record marked as the first, latest and latest with a duration over 50 are not null 
    - verifies that the first attendance webinar event date is greater than the latest attended
    - verifies that the latest 50+ adjusted duration is greater than 50 minutes
        
**/   
         static testMethod void testStamper4() {
        
      //setup recordTypeID map for Opp and Account
      Map<String, ID> recmapopp = recTypeIDOpportunity();
      Map<String, ID> recmapacct = recTypeIDAccount();      
    
    //create list of products
        List<String> listofproducts = new List<String>();
        listofproducts.add('UTP OnDemand');
        listofproducts.add('Backend');
        listofproducts.add('Ultimate Options Course');
        
        Map<String,String> maptoproductabbrv = new Map<String,String>();
        maptoproductabbrv.put('UTP OnDemand','UTP');
        maptoproductabbrv.put('Live Market Forex Session','LMFS');
        maptoproductabbrv.put('Ultimate Options Course','UOC');
       
    
     //create test accounts
        list<Account> listofaccounts = new List<Account>();        
        Account testAccount1 = new Account();
        
        testAccount1 = new Account();
             testAccount1.FirstName = 'testfirstname'+ 1;//i;
             testAccount1.LastName = 'testlastname' +1; //i;
             testAccount1.RecordTypeID = recmapacct.get('Person Account');  
             testAccount1.Lead_Source_LMFS__c = 'Test lead source'; 
             testAccount1.Lead_Source_LMFS_PREV__c = 'Test lead source';     
             testAccount1.Lead_Source_UOC__c   = 'Test lead source';  
             testAccount1.Lead_Source_UOC_PREV__c  = 'Test lead source';               
             testAccount1.Lead_Source_UTP__c = 'Test lead source';                 
             testAccount1.Lead_Source_previous__c = 'Test lead source';                 
             testAccount1.Lead_Source_Date_LMFS__c = Date.today().adddays(-5);                
             testAccount1.Lead_Source_Date_LMFS_PREV__c = Date.today().adddays(-5);    
             testAccount1.Lead_Source_Date_UOC__c = Date.today().adddays(-5);                
             testAccount1.Lead_Source_Date_UOC_PREV__c = Date.today().adddays(-5);                  
             testAccount1.Lead_Source_Date__c = Date.today().adddays(-5);                 
             testAccount1.Lead_Source_Date_previous__c = Date.today().adddays(-5); 
             testAccount1.Lead_Source_Detail_LMFS__c  = 'Test lead source';   
             testAccount1.Lead_Source_Detail_LMFS_PREV__c  = 'Test lead source';               
             testAccount1.Lead_Source_Detail_UOC__c = 'Test lead source';                  
             testAccount1.Lead_Source_Detail_UOC_PREV__c  = 'Test lead source';                
             testAccount1.Lead_Source_Detail__c   = 'Test lead source';                          
             testAccount1.Lead_Source_Detail_previous__c = 'Test lead source';

    insert testAccount1;
            
    //create test opps
        List<Opportunity> listopps = new List<Opportunity>();
        Opportunity testopp = new Opportunity();        
     
            testopp = new Opportunity();
            testopp.Name = 'test opp '+1; 
            testopp.recordTypeID = recmapopp.get('Continuing Education');
            testopp.CloseDate = date.today().adddays(-1);
            testopp.AccountID  = testAccount1.id; 
            testopp.Closed_By__c = UserInfo.getUserId();
            testopp.Product__c = listofproducts[2]; 
            testopp.AVSFQB__Generate_Object__c = 'None';
            testopp.Sale_Invoice_First_Date_After_Down__c = Date.today();
            testopp.Sale_Invoice_Qty_Payments_After_Down__c = 1;
            testopp.StageName = 'Closed Won';
            testopp.Sub_Stage__c = 'Cancelled';
            testopp.Charting_Start__c = Date.today(); 
            testopp.Charting_Expiration__c = Date.today(); 
            testopp.LeadSource = 'Webinar';
            testopp.Purchase_Amount__c = 0;  
            testopp.web_LMFS_FirstAttd__c = null;
            testopp.web_LMFS_LastAttd__c = null;
            testopp.web_LMFS_LastAttd25__c = null;
            testopp.web_UTP_FirstAttd__c = null;
            testopp.web_UTP_LastAttd__c = null;
            testopp.web_UTP_LastAttd25__c = null;
            testopp.web_UOC_FirstAttd__c = null;
            testopp.web_UOC_LastAttd__c = null;
            testopp.web_UOC_LastAttd25__c = null;          
            testopp.Amount = 0;

    insert testopp;

          
     //create test webinars   
      Integer daystoadd = 0;
        List<Webinar__c> testWebinars = new List<Webinar__c>();

        Webinar__c testWeb3 = new Webinar__c();

        for(integer i = 0; i <5; i++){
            testWeb3 = new Webinar__c();
            testWeb3.Name = 'test webinar CE '+i;
            testWeb3.Webinar_ID__c = 'CE-testwebid-'+i;            
            daystoadd = i + 1;
            testWeb3.Event_Date_Time__c = Datetime.now().adddays(-daystoadd);
            testWeb3.Event_Time__c = '12:00';
            testWeb3.PrimaryPresenter__c = 'test presenter 2';
            testWeb3.Product_Presented__c = listofproducts[1];
            testWeb3.StampType__c = 'Backend';
            testWebinars.add(testWeb3);
            daystoadd++;
        }
        
        
        insert testWebinars;
        
        et4ae5__SendDefinition__c emailSend = new et4ae5__SendDefinition__c();
        insert emailSend;
        
        //create test webinar attnds records

        Webinar_Attendance__c testWebAtt;
        
        // UOC data
       list<Webinar_Attendance__c> testAttendances = new List<Webinar_Attendance__c>();   
      Integer index = 0;  
       for(Webinar__c web: testWebinars){
          
            Webinar_Attendance__c testWebAtt1 = new Webinar_Attendance__c();
            testWebAtt1.Account__c = testAccount1.id; 
            testWebAtt1.Webinar__c = web.id;
            testWebAtt1.Attended__c = true;
            testWebAtt1.Source_Other__c = 'test source';
            testWebAtt1.Duration__c = 40;
            testWebAtt1.Join_Time__c = (index == 5)? web.Event_Date_Time__c.addminutes(20): web.Event_Date_Time__c.addminutes(5);
            testWebAtt1.OnDemand_Views__c = 1;
            testWebAtt1.Credit_Name__c = 'test credit name';
            testWebAtt1.Credit_User__c = null;  // MAY NEED USER ID
            testWebAtt1.Stamp_Type__c = 'Continued Education';
            testWebAtt1.Status__c = 'Complete';
            testWebAtt1.IER_et4ae5_SendDefinition__c = emailSend.Id;
            testAttendances.add(testWebAtt1);     
            
        }
        
   
        insert testAttendances;
        List<Webinar_Attendance__c> listofwebattnd = [Select id,Webinar__c from webinar_Attendance__c];
        System.debug('@asha : @debug: Test_OpportunityStamper: size of web attendances created' + testAttendances.size());
        System.assertequals(testAttendances.size(),listofwebattnd.size());
      
        // Begin Testing
        Test.startTest();
            Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
            oppMap.put(testopp.Id, testopp);
            List<Id> oppidlist = new list<id>();
            oppidlist.addAll(oppMap.keySet());
            OpportunityStamper.stampOpportunitiesAsynchronous(oppidlist);

        
       
        Test.stopTest();
        
                    list<opportunity> oppsafterstagechange = [Select id,
            StageName,
            Sub_Stage__c,
            Charting_Start__c,
            Charting_Expiration__c,
            Purchase_Amount__c,  
            web_LMFS_FirstAttd__c,
            web_LMFS_LastAttd__c,
            web_LMFS_LastAttd25__c,
            web_UTP_FirstAttd__c,
            web_UTP_LastAttd__c,
            web_UTP_LastAttd25__c,
            web_UOC_FirstAttd__c,
            web_UOC_LastAttd__c,
            web_UOC_LastAttd25__c,
            Product__c
            From Opportunity 
            where id in: listopps];
            
            //check to see if opp fields are not null and that stage is now closed won
           for(Opportunity o : oppsafterstagechange ){
               //change the stage to start the trigger               
               System.assertequals('Closed Won',o.StageName,'@asha : @debug: Test_OpportunityStamper: Stage is not closed won'+ o.stagename);  
               System.debug('@asha : @debug: Test_OpportunityStamper: Product is '+ o.Product__c);
                List<ID> webattndids = new list<ID>();
               //if lmfs
               if(o.Product__c == listofproducts[1]){

               System.assertnotequals(null,o.web_LMFS_FirstAttd__c,'@asha : @debug: Test_OpportunityStamper: LMFS 1st attnd is still null ' + o.web_LMFS_FirstAttd__c);
               System.assertnotequals(null,o.web_LMFS_LastAttd__c,'@asha : @debug: Test_OpportunityStamper: LMFS last attnd is still null ' + o.web_LMFS_LastAttd__c);             
               System.assertnotequals(null,o.web_LMFS_LastAttd25__c,'@asha : @debug: Test_OpportunityStamper: LMFS last attnd 25+ is still null ' + o.web_LMFS_LastAttd25__c);                                      
               webattndids = new list<ID>();
               webattndids.add(o.web_LMFS_FirstAttd__c);
               webattndids.add(o.web_LMFS_LastAttd__c);
               webattndids.add(o.web_LMFS_LastAttd25__c);               
               Map<Id,Webinar_Attendance__c> webattndrecords = new Map<id,Webinar_Attendance__c>([Select id, Adjusted_Duration__c,WEBINAR_Event_Date__c  from Webinar_Attendance__c Where id in: webattndids ]);

               
               System.assertequals(3, webattndrecords.keyset().size());
               System.assert(webattndrecords.get(o.web_LMFS_FirstAttd__c).WEBINAR_Event_Date__c < webattndrecords.get(o.web_LMFS_LastAttd__c).WEBINAR_Event_Date__c, '@asha:@debug:Test_OpportunityStamper Issue with first attended web attend and last attend: last:'+webattndrecords.get(o.web_LMFS_LastAttd__c).WEBINAR_Event_Date__c+' first '+webattndrecords.get(o.web_LMFS_FirstAttd__c).WEBINAR_Event_Date__c );
               System.assert(webattndrecords.get(o.web_LMFS_LastAttd25__c).Adjusted_Duration__c > 25, '@asha:@debug:Test_OpportunityStampter : Issue with last webinar being greater than 25 minutes: duration '+webattndrecords.get(o.web_UTP_LastAttd25__c).Adjusted_Duration__c );
               
              
               
               }
                //if utp
               if(o.Product__c == listofproducts[0]){
               System.assertnotequals(null,o.web_UTP_FirstAttd__c,'@asha : @debug: Test_OpportunityStamper: UTP 1st attnd is still null' + o.web_UTP_FirstAttd__c);
               System.assertnotequals(null,o.web_UTP_LastAttd__c,'@asha : @debug: Test_OpportunityStamper: UTP last attnd is still null' + o.web_UTP_LastAttd__c);
               System.assertnotequals(null,o.web_UTP_LastAttd25__c,'@asha : @debug: Test_OpportunityStamper: UTP last attnd 25+is still null' + o.web_UTP_LastAttd25__c);
               
               webattndids = new list<ID>();
               webattndids.add(o.web_UTP_FirstAttd__c);
               webattndids.add(o.web_UTP_LastAttd__c);
               webattndids.add(o.web_UTP_LastAttd25__c);               
               Map<Id,Webinar_Attendance__c> webattndrecords = new Map<id,Webinar_Attendance__c>([Select id, Adjusted_Duration__c,WEBINAR_Event_Date__c  from Webinar_Attendance__c Where id in: webattndids ]);
               System.assertequals(3, webattndrecords.keyset().size());
               System.assert(webattndrecords.get(o.web_UTP_FirstAttd__c).WEBINAR_Event_Date__c < webattndrecords.get(o.web_UTP_LastAttd__c).WEBINAR_Event_Date__c, '@asha:@debug:Test_OpportunityStamper Issue with first attended web attend and last attend: last:'+webattndrecords.get(o.web_UTP_LastAttd__c).WEBINAR_Event_Date__c+' first '+webattndrecords.get(o.web_UTP_FirstAttd__c).WEBINAR_Event_Date__c );
               System.assert(webattndrecords.get(o.web_UTP_LastAttd25__c).Adjusted_Duration__c > 25, '@asha:@debug:Test_OpportunityStampter : Issue with last webinar being greater than 25 minutes: duration '+webattndrecords.get(o.web_UTP_LastAttd25__c).Adjusted_Duration__c );
               
              
               }
               //if backend
               if(o.recordTypeID == recmapopp.get('Continuing Education')){
               System.assertnotequals(null,o.web_BE_FirstAttd__c,'@asha : @debug: Test_OpportunityStamper: BackEnd  1st attnd is still null' + o.web_BE_FirstAttd__c);
               System.assertnotequals(null,o.web_BE_LastAttd__c,'@asha : @debug: Test_OpportunityStamper: BackEnd last attnd is still null' + o.web_BE_LastAttd__c);
               System.assertnotequals(null,o.web_BE_LastAttd50__c,'@asha : @debug: Test_OpportunityStamper: BackEnd last attnd 25+ is still null' + o.web_BE_LastAttd50__c); 
               
               webattndids = new list<ID>();
               webattndids.add(o.web_BE_FirstAttd__c);
               webattndids.add(o.web_BE_LastAttd__c);
               webattndids.add(o.web_BE_LastAttd50__c);
               Map<Id,Webinar_Attendance__c> webattndrecords = new Map<id,Webinar_Attendance__c>([Select id, Adjusted_Duration__c,WEBINAR_Event_Date__c  from Webinar_Attendance__c Where id in: webattndids ]);
               System.assertequals(3, webattndrecords.keyset().size());
               System.debug('@asha: Test_OpportunityStamper BackEnd First attended webinar event date: '+ webattndrecords.get(o.web_BE_FirstAttd__c).WEBINAR_Event_Date__c );
               System.debug('@asha: Test_OpportunityStamper BackEnd latest attended webinar event date: '+ webattndrecords.get(o.web_BE_LastAttd__c).WEBINAR_Event_Date__c );
               System.debug('@asha: Test_OpportunityStamper BackEnd latest 25+ attended webinar event date: '+ webattndrecords.get(o.web_BE_LastAttd50__c).WEBINAR_Event_Date__c );   
                             
               System.assert(webattndrecords.get(o.web_BE_LastAttd__c).WEBINAR_Event_Date__c > webattndrecords.get(o.web_BE_FirstAttd__c).WEBINAR_Event_Date__c, '@asha:@debug:Test_OpportunityStamper Issue with first attended web attend and last attend: last:'+webattndrecords.get(o.web_BE_LastAttd__c).WEBINAR_Event_Date__c+' first '+webattndrecords.get(o.web_BE_FirstAttd__c).WEBINAR_Event_Date__c );
               System.assert(webattndrecords.get(o.web_BE_LastAttd50__c).Adjusted_Duration__c > 50, '@asha:@debug:Test_OpportunityStampter : Issue with last webinar being greater than 50 minutes: duration '+webattndrecords.get(o.web_BE_LastAttd50__c).Adjusted_Duration__c );
               
               //test that web attend is stamped with opp
               System.assertequals(o.id,webattndrecords.get(o.web_BE_LastAttd50__c).Closed_Won_Opp__c);
               }  
           }   
    }
     
     public static Map<String, ID> recTypeIDOpportunity(){
        
        Map<String, ID> newmap = new Map<String, ID>();
        Schema.DescribeSObjectResult describeopp = Schema.SObjectType.Opportunity;
        List<Schema.RecordTypeInfo> rtInfos = describeopp.getRecordTypeInfos();
        
        for(Schema.RecordTypeInfo rtInfo : rtInfos){ 
            newmap.put(rtInfo.getName(), rtInfo.getRecordTypeId());
        }
        
        return newmap;
    }
    
      public static Map<String, ID> recTypeIDAccount(){
        
        Map<String, ID> newmap = new Map<String, ID>();
        Schema.DescribeSObjectResult describeopp = Schema.SObjectType.Account;
        List<Schema.RecordTypeInfo> rtInfos = describeopp.getRecordTypeInfos();
        
        for(Schema.RecordTypeInfo rtInfo : rtInfos){ 
            newmap.put(rtInfo.getName(), rtInfo.getRecordTypeId());
        }
        
        return newmap;
    }
}