@isTest
public class updateFRM2withFRM1_Test {

    Static Void testdata()
    {
          Site__c testSite = new Site__c(Name = 'USA, TX, Houston',Active__c=True,Site_Code__c='111',Display_Address__c='USA, TX, Houston');
          insert testSite;
            ExamSiteids__c siteIds = new ExamSiteids__c(Name = testSite.id);
            insert siteIds;
            Exam_Date__c examDate = new Exam_Date__c(Name = 'FRM Part 1',Date_String__c = '2015-05-16');
          insert examDate;
        
          Exam_Group__c examGroup = new Exam_Group__c(Name='15-May');
          insert examGroup;
          Exam__c exam = new Exam__c(Name='May 2015 FRM Exam Part I',Exam__c='FRM Part 1',Exam_Group__c=examGroup.id,Exam_Date__c=date.newInstance(2015,5,16));
          insert exam;
         
          Exam__c exam2 = new Exam__c(Name='May 2015 FRM Exam Part II',Exam__c='FRM Part 2',Exam_Group__c=examGroup.id,Exam_Date__c=date.newInstance(2015,5,16));
          insert exam2;
         
          Exam_Sites__c examSites = new Exam_Sites__c(Name='May 2015 FRM Exam Part I USA, TX, Houston',Exam__c = exam.id,Exam_Date__c = date.newInstance(2015,5,16),Site__c=testSite.id, CurrencyIsoCode = 'USD' );
          insert examSites;
          
        
          Exam_Sites__c examSitesMay = new Exam_Sites__c(Name='May 2015 FRM Exam Part I USA, MA, BOSTON',Exam__c = exam.id,Exam_Date__c = date.newInstance(2015,5,16),Site__c=testSite.id, CurrencyIsoCode = 'USD' );
          insert examSitesMay;
          
           Exam_Sites__c examSites2 = new Exam_Sites__c(Name='May 2015 FRM Exam Part II USA, TX, Houston',Exam__c = exam2.id,Exam_Date__c = date.newInstance(2015,5,16),Site__c=testSite.id, CurrencyIsoCode = 'USD' );
          insert examSites2;
          
          Exam_Sites__c examSitesMay2 = new Exam_Sites__c(Name='May 2015 FRM Exam Part II USA, MA, BOSTON',Exam__c = exam2.id,Exam_Date__c = date.newInstance(2015,5,16),Site__c=testSite.id, CurrencyIsoCode = 'USD' );
          insert examSitesMay2;
        
          Exam_Attempt__c examRegMay = new Exam_Attempt__c(Exam_Site__c=examSitesMay.id);
          insert examRegMay;
          
          Exam_Attempt__c examReg = new Exam_Attempt__c(Exam_Site__c=examSites.id,Other_Exam_Registrations__c=examRegMay.id,Defered__c='APPROVED',Cancelled__c = False);
          insert examReg;
          
         Exam_Attempt__c examRegMay2 = new Exam_Attempt__c(Exam_Site__c=examSitesMay2.id);
         insert examRegMay2;
          
          Exam_Attempt__c examReg2 = new Exam_Attempt__c(Exam_Site__c=examSites2.id,Other_Exam_Registrations__c=examRegMay2.id,Defered__c='APPROVED',Cancelled__c = False);
          insert examReg2;
        
        
          Venue__c venue = new Venue__c(Name = 'May 2015 USA, TX, Houston',Site__c =testSite.id,Active__c=true );
          insert venue;
          Room__c room = new Room__c(Name='Salon  A',Capacity__c = 25, Venue__c = venue.id, Priority__c = 1, Active__c = true);
          insert room;
        
    }
    
    Static testMethod Void unit_test1()
    {
        testdata();
        test.startTest();
        updateFRM2withFRM1 b = new updateFRM2withFRM1();
        database.executeBatch(b);
        test.stopTest();
    }
    
}