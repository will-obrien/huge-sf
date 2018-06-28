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
*   Author:             7/22/2015
*   Last Modified:      7/22/2015
*   Last Modified By:   Asha Calderon
*
*   
*   
**********************************************************************************************************************/
/******************
Test_OpportunityAction
@description:
Test classes for OpportunityAction invocable method for use in flow
**/

@isTest
private class Test_OpportunityAction {


/******************
@method:
testAction1

@description:
- Setup the custom setting OppFieldsforStamping__c which has all the fields needed to query
- Setup the custom setting MicroProductList__c  which houses the list of micro products to check against
- Create test accounts & test Opportunities
- test is for micro products from the custom setting list of microproducts
- verifies that the opp returned is the earliest closed date
**/

    static testMethod void testAction1() {
        
    //setup custom settings
    OppFieldsforStamping__c os1 = new OppFieldsforStamping__c();    
    os1.name = 'fieldname1';
    os1.ActiveField__c = true;
    os1.APIName__c= 'Amount';    
    insert os1;
    
    OppFieldsforStamping__c os2 = new OppFieldsforStamping__c();    
    os2.name = 'fieldname2';
    os2.ActiveField__c = true;
    os2.APIName__c= 'Name';   
    insert os2;
    
    OppFieldsforStamping__c os3 = new OppFieldsforStamping__c();    
    os3.name = 'fieldname3';
    os3.ActiveField__c = true;
    os3.APIName__c= 'Account_Email__c'; 
    insert os3;
    
    
    
    MicroProductList__c mp1 = new MicroProductList__c();    
    mp1.name = 'microname1';
    mp1.Active__c = true;
    mp1.Full_Product_Name__c = 'Live Market Forex Session';    
    insert mp1;
    
    MicroProductList__c mp2 = new MicroProductList__c();    
    mp2.name = 'microname2';
    mp2.Active__c = true;
    mp2.Full_Product_Name__c = 'Ultimate Market Scanner (Forex Feed)';   
    insert mp2;
    
    MicroProductList__c mp3 = new MicroProductList__c();    
    mp3.name = 'microname3';
    mp3.Active__c = true;
    mp3.Full_Product_Name__c = 'FX Nest Egg'; 
    insert mp3;    

        
      //setup recordTypeID map for Opp and Account
      Map<String, ID> recmapopp = recTypeIDOpportunity();
      Map<String, ID> recmapacct = recTypeIDAccount();      
    
       
     //create test accounts
      
        Account testAccount1 = new Account();        
             testAccount1.FirstName = 'testfirstname1';
             testAccount1.LastName = 'testlastname1';
             testAccount1.RecordTypeID = recmapacct.get('Person Account');  
       insert testAccount1;
            
       List<id> idlist = new List<id>();     
       idlist.add(testAccount1.id);
    //create test opps
        Opportunity testopp = new Opportunity(); 
            testopp.Name = 'test opp 1'; 
            testopp.recordTypeID = recmapopp.get('Education');
            testopp.CloseDate = date.today().adddays(-3);
            testopp.AccountID = testAccount1.id; 
            testopp.Closed_By__c = UserInfo.getUserId();
            testopp.Product__c = 'Live Market Forex Session'; 
            testopp.StageName = 'Closed Won';
            testopp.Sub_Stage__c = 'Cancelled';
            testopp.Amount = 1000;    

        insert testopp;

        Opportunity testopp2 = new Opportunity(); 
            testopp2.Name = 'test opp 2'; 
            testopp2.recordTypeID = recmapopp.get('Education');
            testopp2.CloseDate = date.today().adddays(-30);
            testopp2.AccountID = testAccount1.id; 
            testopp2.Closed_By__c = UserInfo.getUserId();
            testopp2.Product__c = 'FX Nest Egg'; 
            testopp2.StageName = 'Closed Won';
            testopp2.Sub_Stage__c = 'Cancelled';
            testopp2.Amount = 2000;    

        insert testopp2;
        
        
        
          Opportunity testopp3 = new Opportunity(); 
            testopp3 = new Opportunity();
            testopp3.Name = 'test opp 3'; 
            testopp3.recordTypeID = recmapopp.get('Education');
            testopp3.CloseDate = date.today().adddays(-1);
            testopp3.AccountID = testAccount1.id; 
            testopp3.Closed_By__c = UserInfo.getUserId();
            testopp3.Product__c = 'Live Market Forex Session'; 
            testopp3.StageName = 'Closed Won';
            testopp3.Sub_Stage__c = 'Cancelled';
            testopp3.Amount = 4000;    

        insert testopp3;      

        Opportunity testopp4 = new Opportunity(); 
            testopp4.Name = 'test opp 2'; 
            testopp4.recordTypeID = recmapopp.get('Education');
            testopp4.CloseDate = date.today().adddays(-31);
            testopp4.AccountID = testAccount1.id; 
            testopp4.Closed_By__c = UserInfo.getUserId();
            testopp4.Product__c = 'Art of Yen Course'; 
            testopp4.StageName = 'Closed Won';
            testopp4.Sub_Stage__c = 'Cancelled';
            testopp4.Amount = 2000;    

        insert testopp4;
        
        // Begin Testing
        Test.startTest();
            
         List<Opportunity> returnedopps = OpportunityAction.getFirstMicroClosedWonOpp(idlist);
         System.assertequals(1, returnedopps.size());
         System.assertequals(returnedopps[0].id, testopp2.id);
         
            
        Test.stopTest();
        
    }

/******************
@method:
testAction2

@description:
- Setup the custom setting OppFieldsforStamping__c which has all the fields needed to query
- Setup the custom setting MicroProductList__c  which houses the list of micro products to check against
- Creates multiple test accounts & test Opportunities
- test is for micro products from the custom setting list of microproducts
- verifies that the opp returned is the earliest closed date
- verifies if one test account with no related opportunities and it should return null
**/

    static testMethod void testAction2() {
        
    //setup custom settings
    OppFieldsforStamping__c os1 = new OppFieldsforStamping__c();    
    os1.name = 'fieldname1';
    os1.ActiveField__c = true;
    os1.APIName__c= 'Amount';    
    insert os1;
    
    OppFieldsforStamping__c os2 = new OppFieldsforStamping__c();    
    os2.name = 'fieldname2';
    os2.ActiveField__c = true;
    os2.APIName__c= 'Name';   
    insert os2;
    
    OppFieldsforStamping__c os3 = new OppFieldsforStamping__c();    
    os3.name = 'fieldname3';
    os3.ActiveField__c = true;
    os3.APIName__c= 'Account_Email__c'; 
    insert os3;
    
    
    
    MicroProductList__c mp1 = new MicroProductList__c();    
    mp1.name = 'microname1';
    mp1.Active__c = true;
    mp1.Full_Product_Name__c = 'Live Market Forex Session';    
    insert mp1;
    
    MicroProductList__c mp2 = new MicroProductList__c();    
    mp2.name = 'microname2';
    mp2.Active__c = true;
    mp2.Full_Product_Name__c = 'Ultimate Market Scanner (Forex Feed)';   
    insert mp2;
    
    MicroProductList__c mp3 = new MicroProductList__c();    
    mp3.name = 'microname3';
    mp3.Active__c = true;
    mp3.Full_Product_Name__c = 'FX Nest Egg'; 
    insert mp3;    

        
      //setup recordTypeID map for Opp and Account
      Map<String, ID> recmapopp = recTypeIDOpportunity();
      Map<String, ID> recmapacct = recTypeIDAccount();      
    
       
     //create test accounts
      
        Account testAccount1 = new Account();        
             testAccount1.FirstName = 'testfirstname1';
             testAccount1.LastName = 'testlastname1';
             testAccount1.RecordTypeID = recmapacct.get('Person Account');  
       insert testAccount1;
       
       Account testAccount2 = new Account();        
             testAccount2.FirstName = 'testfirstname1';
             testAccount2.LastName = 'testlastname1';
             testAccount2.RecordTypeID = recmapacct.get('Person Account');  
       insert testAccount2;
       
       
            
       List<id> idlist = new List<id>();     
       idlist.add(testAccount1.id);
       idlist.add(testAccount2.id);
       
    //create test opps
        Opportunity testopp = new Opportunity(); 
            testopp.Name = 'test opp 1'; 
            testopp.recordTypeID = recmapopp.get('Education');
            testopp.CloseDate = date.today().adddays(-3);
            testopp.AccountID = testAccount1.id; 
            testopp.Closed_By__c = UserInfo.getUserId();
            testopp.Product__c = 'Live Market Forex Session'; 
            testopp.StageName = 'Closed Won';
            testopp.Sub_Stage__c = 'Cancelled';
            testopp.Amount = 1000;    
        insert testopp;

        Opportunity testopp2 = new Opportunity(); 
            testopp2.Name = 'test opp 2'; 
            testopp2.recordTypeID = recmapopp.get('Education');
            testopp2.CloseDate = date.today().adddays(-30);
            testopp2.AccountID = testAccount1.id; 
            testopp2.Closed_By__c = UserInfo.getUserId();
            testopp2.Product__c = 'FX Nest Egg'; 
            testopp2.StageName = 'Closed Won';
            testopp2.Sub_Stage__c = 'Cancelled';
            testopp2.Amount = 2000; 
        insert testopp2;
                
        
        Opportunity testopp3 = new Opportunity(); 
            testopp3 = new Opportunity();
            testopp3.Name = 'test opp 3'; 
            testopp3.recordTypeID = recmapopp.get('Education');
            testopp3.CloseDate = date.today().adddays(-1);
            testopp3.AccountID = testAccount1.id; 
            testopp3.Closed_By__c = UserInfo.getUserId();
            testopp3.Product__c = 'Live Market Forex Session'; 
            testopp3.StageName = 'Closed Won';
            testopp3.Sub_Stage__c = 'Cancelled';
            testopp3.Amount = 4000;    

        insert testopp3;      

        Opportunity testopp4 = new Opportunity(); 
            testopp4.Name = 'test opp 2'; 
            testopp4.recordTypeID = recmapopp.get('Education');
            testopp4.CloseDate = date.today().adddays(-31);
            testopp4.AccountID = testAccount1.id; 
            testopp4.Closed_By__c = UserInfo.getUserId();
            testopp4.Product__c = 'Art of Yen Course'; 
            testopp4.StageName = 'Closed Won';
            testopp4.Sub_Stage__c = 'Cancelled';
            testopp4.Amount = 2000;    

        insert testopp4;
        
        // Begin Testing
        Test.startTest();
            
         List<Opportunity> returnedopps = OpportunityAction.getFirstMicroClosedWonOpp(idlist);
         System.assertequals(2, returnedopps.size());
         System.assertequals(returnedopps[0].id, testopp2.id);
         System.assertequals(returnedopps[1], null);
            
        Test.stopTest();
        
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