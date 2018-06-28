@isTest(OnInstall=false)
public with sharing class TestDair {
     @IsTest(OnInstall=false)
    static void myUnitTest() {
        User stdUser  = TestHelper.getStandardUser(true);
         Project__c newProj = new Project__c();
        System.runAs(stdUser){
           Test.startTest();
            List<DAIR_Report__c> dairReports  = [Select Id,DAIR_Status__c from DAIR_Report__c LIMIT 1];
            if(dairReports.size() > 0){            
            dairReports[0].DAIR_Status__c ='Draft';        
            PageReference page = new PageReference('/apex/DAIRReportOverride');
            page.getParameters().put('id',dairReports[0].id);
            Test.setCurrentPageReference(page);  
            ApexPages.StandardController stdCtrl = new ApexPages.StandardController(dairReports[0]);
            DAIRReportOverride controller = new DAIRReportOverride(stdCtrl);
            PageReference pf = controller.onLoad();      
            PageReference pftest = new PageReference('/'+dairReports[0].id);      
            Test.stopTest();
            System.assertEquals(pf , pftest);
         }
        }    
      }
      @IsTest(SeeAllData=true)
     static void testNonDIARReportUpdate(){   
     	   boolean b = false; 
            User stdUser  = TestHelper.getStandardUser(true);           
            System.runAs(stdUser){             
            List<DAIR_Report__c> dairReports  = [Select Id,DAIR_Status__c from DAIR_Report__c LIMIT 1];
            if(dairReports.size() > 0){            
            dairReports[0].DAIR_Status__c ='Submitted';        
            PageReference page = new PageReference('/apex/DAIRReportOverride');
            page.getParameters().put('id',dairReports[0].id);
            Test.setCurrentPageReference(page);  
            ApexPages.StandardController stdCtrl = new ApexPages.StandardController(dairReports[0]);
            DAIRReportOverride controller = new DAIRReportOverride(stdCtrl);
            Test.startTest();
            PageReference pf =  controller.onLoad();
            Test.stopTest();
            List<ApexPages.Message> msgList = ApexPages.getMessages();                                 
            System.assertEquals(pf , null);           
			for(ApexPages.Message msg :  msgList) {
    			System.assertEquals( msg.getDetail(),'Record is already Submitted');
    			System.assertEquals( msg.getSeverity(),ApexPages.Severity.Warning);
   			  if (msg.getDetail().contains('Record is already Submitted')) b = true;
            }   
            System.assert(ApexPages.hasMessages()); 
            System.assert(b);            
        }
     }
}

      @IsTest(SeeAllData=true)
      static void  testNonDIARReportMessages(){   
     	   boolean b = false; 
            User stdUser  = TestHelper.getStandardUser(true);           
            System.runAs(stdUser){             
            Test.startTest();
            List<DAIR_Report__c> dairReports  = [Select Id,DAIR_Status__c from DAIR_Report__c LIMIT 1];
            if(dairReports.size() > 0){            
            dairReports[0].DAIR_Status__c ='Submitted';        
            PageReference page = new PageReference('/apex/DAIRReportOverride');
            page.getParameters().put('id',dairReports[0].id);
            Test.setCurrentPageReference(page);  
            ApexPages.StandardController stdCtrl = new ApexPages.StandardController(dairReports[0]);
            DAIRReportOverride controller = new DAIRReportOverride(stdCtrl);
            PageReference pf =  controller.onLoad();
            List<ApexPages.Message> msgList = ApexPages.getMessages();
            Test.stopTest();                                   
            System.assertEquals(pf , null);           
			for(ApexPages.Message msg :  msgList) {
    			System.assertEquals( msg.getDetail(),'Record is already Submitted');
    			System.assertEquals( msg.getSeverity(),ApexPages.Severity.Warning);
   			  if (msg.getDetail().contains('Record is already Submitted')) b = true;
            }   
            System.assertEquals(ApexPages.hasMessages(),true); 
            System.assertEquals(b, true);                      
        }
     }
}
}