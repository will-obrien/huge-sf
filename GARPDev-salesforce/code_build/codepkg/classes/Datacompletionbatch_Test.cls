@isTest                              
private class Datacompletionbatch_Test{    

    static 
    {
        Account objAccount = new Account();
            objAccount.Name = 'Test Account';
            insert objAccount;
            insert new Updateids__c(Name='GARP',Record_id__c = 'a0A4000000uA1fU'); 
            //a0A4000000uA1fU 01sf00000008rTn
            insert new Default_Settings__c(Name='Default',Record_id__c = '01s40000000VV1K',Prod_Code_952__c = '952'); 
            
           // 01s40000000VV1K 01tf0000002boAZ
            
            
            insert new UpdateIds__c(Name='User', Record_Id__c='00540000001y7OX');        

            
        ChargentBase__Gateway__c chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        insert new UpdateIds__c(Name= 'ICBRR', Record_Id__c = 'a0Cf0000004O778');  


            

           Opportunity opp = new Opportunity(accountId =objAccount.Id,LEGACY_PurchasesRefNo__c = '123456',Company__c = 'GARP',Name ='Test OPP',StageName = 'New',CloseDate = System.today().addDays(4));
            insert opp;



            
             Id frmRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program');
             Id erpRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program');
             Id cpeRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','CPE');
            Contract  objContract1 = new Contract();
            objContract1.Name = 'FRM FULL';
            objContract1.accountId = objAccount.Id;
            objContract1.startDate = system.today();
            objContract1.recordTypeId = frmRecordTypeID;
            objContract1.All_Requirements_Completed_Date__c = system.today();
            insert objContract1;

            Contract  cpeCon = new Contract();
            cpeCon.Name = 'CPE';
            cpeCon.accountId = objAccount.Id;
            cpeCon.startDate = system.today();
            cpeCon.recordTypeId = cpeRecordTypeID;
            cpeCon.Status = 'Draft';
            insert cpeCon;

            cpeCon.Status = 'Activated ( Auto-Renew )';
            update cpeCon;
            
            Contract  objContract2 = new Contract();
            objContract2.Name = 'FRM Part 1';
            objContract2.accountId = objAccount.Id;
            objContract2.recordTypeId = erpRecordTypeID;
            insert objContract2;
            
            Contract  objContract3 = new Contract();
            objContract3.Name = 'FRM PART 2';
            objContract3.accountId = objAccount.Id;
            insert objContract3;
            
            Contract  objContract4 = new Contract();
            objContract4.Name = 'PASS ERP';
            objContract4.accountId = objAccount.Id;
            insert objContract4;
            
            Exam__c objExam1 = new Exam__c(Name ='Test Exam1', Exam__c='FRM Part 1',Exam_Date__c = system.today()-90);
            insert objExam1;
            
            Exam__c objExam2 = new Exam__c(Name='Test Exam2',Exam__c='FRM Part 2',Exam_Date__c = system.today()-90);
            insert objExam2;
            
            Exam__c objExam3 = new Exam__c(Name='Test Exam3',Exam__c='ERP',Exam_Date__c = system.today()-90);
            insert objExam3;
            
            Exam__c objExam4 = new Exam__c(Name='Test Exam4',Exam__c='Icbrr Part I',Exam_Date__c = system.today()-90);
            insert objExam4;
            
            Exam__c objExam5 = new Exam__c(Name='Test Exam5',Exam__c='Icbrr Part II',Exam_Date__c = system.today()-90);
            insert objExam5;
            
            Exam__c objExam6 = new Exam__c(Name='Test Exam5',Exam__c='ICBRR',Exam_Date__c = system.today()-90);
            insert objExam6;
            
            Exam__c objExam7 = new Exam__c(Name='Test Exam5',Exam__c='FRM FULL Program',Exam_Date__c = system.today()-90);
            insert objExam7;
            
            Site__c objSite = new Site__c(name = 'Test Site');
            insert objSite;
            
            Exam_Sites__c objES1 = new Exam_Sites__c(Name = 'Test Exam Site 1',Exam__c = objExam1.Id,Site__c = objSite.Id);
            insert objES1;
            
            Exam_Sites__c objES2 = new Exam_Sites__c(Name = 'Test Exam Site 2',Exam__c = objExam2.Id,Site__c = objSite.Id);
            insert objES2;
            
            Exam_Sites__c objES3 = new Exam_Sites__c(Name = 'Test Exam Site 3',Exam__c = objExam3.Id,Site__c = objSite.Id);
            insert objES3;
            
            Exam_Sites__c objES4 = new Exam_Sites__c(Name = 'Test Exam Site 4',Exam__c = objExam4.Id,Site__c = objSite.Id);
            insert objES4;
            
            Exam_Sites__c objES5 = new Exam_Sites__c(Name = 'Test Exam Site 5',Exam__c = objExam5.Id,Site__c = objSite.Id);
            insert objES5;
            
            Exam_Sites__c objES6 = new Exam_Sites__c(Name = 'Test Exam Site 6',Exam__c = objExam6.Id,Site__c = objSite.Id);
            insert objES6;
            
            Exam_Sites__c objES7 = new Exam_Sites__c(Name = 'Test Exam Site 7',Exam__c = objExam7.Id,Site__c = objSite.Id);
            insert objES7;
            
            system.debug('EXAM SITES == '+objES1+' '+ objES2 + ' '+ objES3 + ' '+ objES4 + ' '+ objES5 + ' '+ objES6 + ' '+objES7);
            Exam_Attempt__c obj1 = new Exam_Attempt__c();
            obj1.Candidate_Commitment__c = objContract1.Id;
            obj1.Exam_Site__c = objES1.Id;
            obj1.Cancelled__c = true;
            insert obj1;
            
            Exam_Attempt__c obj2 = new Exam_Attempt__c();
            obj2.Candidate_Commitment__c = objContract1.Id;
            obj2.Exam_Site__c = objES2.Id;
            obj2.Cancelled__c = true;
            insert obj2;
            
            Exam_Attempt__c obj3 = new Exam_Attempt__c();
            obj3.Candidate_Commitment__c = objContract1.Id;
            obj3.Exam_Site__c = objES3.Id;
            obj3.Cancelled__c = true;
            insert obj3;
            
            Exam_Attempt__c obj4 = new Exam_Attempt__c();
            obj4.Candidate_Commitment__c = objContract1.Id;
            obj4.Exam_Site__c = objES4.Id;
            obj4.Cancelled__c = true;
            insert obj4;
            
            Exam_Attempt__c obj5 = new Exam_Attempt__c();
            obj5.Candidate_Commitment__c = objContract1.Id;
            obj5.Exam_Site__c = objES5.Id;
            obj5.Cancelled__c = true;
            insert obj5;
            
            Exam_Attempt__c obj6 = new Exam_Attempt__c();
            obj6.Candidate_Commitment__c = objContract1.Id;
            obj6.Exam_Site__c = objES6.Id;
            obj6.Cancelled__c = true;
            insert obj6;
            
            Exam_Attempt__c obj7 = new Exam_Attempt__c();
            obj7.Candidate_Commitment__c = objContract1.Id;
            obj7.Exam_Site__c = objES7.Id;
            obj7.Cancelled__c = false;
            insert obj7;
            Id examRecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c','Exam');
            Candidate_Requirement__c objCR = new Candidate_Requirement__c(Name = 'Pass ERP',Candidate_Commitment__c = objContract1.Id,recordTypeId = examRecordTypeID,Status__c = 'Completed');
            insert objCR;
            
            Exam_Attempt__c obj8 = new Exam_Attempt__c();
            obj8.Candidate_Commitment__c = objContract1.Id;
            obj8.Exam_Site__c = objES7.Id;
            obj8.Result__c = 'Pass';
            obj8.Candidate_Requirement__c = objCR.Id;
            insert obj8;

            Contact objCon = new Contact(firstName = 'FNAME',LastName='LName',Email='Test@Test.com',accountId = objAccount.Id);
            insert objCon;

            Profile pf = [SELECT Id FROM profile WHERE name='System Administrator'];
            User objUser = new User(username='username@qw.com',firstname = 'FNamee',lastName='LNamee',Email='email@test.com',communityNickname='TY',alias = 'trr',profileId = pf.Id,Password__c = 'Testerr',emailencodingkey='UTF-8',languagelocalekey='en_US',localesidkey='en_US',timezonesidkey='America/New_York');
            insert objUser;
            
            
    }
    /*
    static testmethod void testDatacompletionbatch() {        
            Test.startTest();
          Datacompletionbatch1 c = new Datacompletionbatch1();
            ID batchprocessid  = Database.executeBatch(c);       
           Test.stopTest();
           System.abortJob(batchprocessid);       
        }
        
    static testmethod void testDatacompletionbatch1() {        
            Test.startTest();
           Datacompletionbatch2 c = new Datacompletionbatch2();
           ID batchprocessid  = Database.executeBatch(c);       
           Test.stopTest();  
           System.abortJob(batchprocessid);     
        }
        
    static testmethod void testDatacompletionbatch2() {        
            Test.startTest();
           Datacompletionbatch3 c = new Datacompletionbatch3();
           ID batchprocessid  = Database.executeBatch(c);       
           Test.stopTest();
           System.abortJob(batchprocessid);       
        }
        
    static testmethod void testDatacompletionbatch4() {        
            Test.startTest();
           Datacompletionbatch4 c = new Datacompletionbatch4();
           ID batchprocessid  = Database.executeBatch(c);       
           Test.stopTest();    
           System.abortJob(batchprocessid);   
        }*/
       
    /*static testmethod void testDatacompletionbatch5() {        
            Test.startTest();
           Datacompletionbatch5 c = new Datacompletionbatch5();
           Database.executeBatch(c);       
           Test.stopTest();       
        }*/
    /*
    static testmethod void testDatacompletionbatch6() {        
            Test.startTest();
           Datacompletionbatch6 c = new Datacompletionbatch6();
           Database.executeBatch(c);       
           Test.stopTest();       
        }
    
    static testmethod void testDatacompletionbatch12() {        
            Test.startTest();
           Datacompletionbatch12 c = new Datacompletionbatch12();
           Database.executeBatch(c);       
           Test.stopTest();       
        }
    

        static testmethod void testDatacompletionbatch7() {        
            Test.startTest();
           Datacompletionbatch7 c = new Datacompletionbatch7();
           ID batchprocessid  = Database.executeBatch(c);       
           Test.stopTest();  
           System.abortJob(batchprocessid);     
        }

        static testmethod void testDatacompletionbatch8() {        
           Test.startTest();
           Datacompletionbatch8 c = new Datacompletionbatch8();
           ID batchprocessid  = Database.executeBatch(c,1);       
           Test.stopTest(); 
           System.abortJob(batchprocessid);      
        }

        static testmethod void testDatacompletionbatch9() {        
            Test.startTest();
           Datacompletionbatch9 c = new Datacompletionbatch9();
           ID batchprocessid  = Database.executeBatch(c);       
           Test.stopTest();    
           System.abortJob(batchprocessid);   
        }*/
/*
        static testmethod void testDatacompletionbatch10() {        
            Test.startTest();
           Datacompletionbatch10 c = new Datacompletionbatch10();
           ID batchprocessid  = Database.executeBatch(c);       
           Test.stopTest();    
           System.abortJob(batchprocessid);   
        }
        
        static testmethod void testDatacompletionbatch13() {        
            Test.startTest();
           Datacompletionbatch13 c = new Datacompletionbatch13();
           ID batchprocessid  = Database.executeBatch(c);       
           Test.stopTest();  
           System.abortJob(batchprocessid);     
        }
        
        static testmethod void testDatacompletionbatch14() {        
            Test.startTest();
           Datacompletionbatch14 c = new Datacompletionbatch14();
           ID batchprocessid  = Database.executeBatch(c);       
           Test.stopTest(); 
           System.abortJob(batchprocessid);      
        }
        
        static testmethod void testDatacompletionbatch15() {        
            Test.startTest();
           Datacompletionbatch15 c = new Datacompletionbatch15();
          ID batchprocessid  =  Database.executeBatch(c);       
           Test.stopTest(); 
           System.abortJob(batchprocessid);      
        }
        static testmethod void testDatacompletionbatch16() {        
            Test.startTest();
           Datacompletionbatch16 c = new Datacompletionbatch16();
          ID batchprocessid  =  Database.executeBatch(c);       
           Test.stopTest(); 
           System.abortJob(batchprocessid);      
        }
         static testmethod void testDatacompletionbatch17() {        
            Test.startTest();
           Datacompletionbatch17 c = new Datacompletionbatch17();
           ID batchprocessid  = Database.executeBatch(c);       
           Test.stopTest(); 
           System.abortJob(batchprocessid);      
        }*/
         static testmethod void testDatacompletionbatch18() {        
            Test.startTest();
           Datacompletionbatch18 c = new Datacompletionbatch18();
          ID batchprocessid  =  Database.executeBatch(c);       
           Test.stopTest(); 
           System.abortJob(batchprocessid);      
        }
      /*
        static testmethod void testDatacompletionbatch19() {        
            Test.startTest();
           Datacompletionbatch19 c = new Datacompletionbatch19();
           ID batchprocessid  = Database.executeBatch(c);       
           Test.stopTest(); 
           System.abortJob(batchprocessid);    
        }*/
               
    }