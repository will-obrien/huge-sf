@isTest(seeAllData=true)
private class testContactRemoter{

    static testMethod void testContact() {
        TempAccount objTempData  = new TempAccount();
        objTempData.Email = 'Test@Test.com';
        objTempData.FirstName = 'Testing FName';
        objTempData.LastName = 'Tetsing LName';
        objTempData.garpMembership_Type = 'Individual';
        objTempData.Degree_Program_Name = 'MS';
        objTempData.HomePhone = '999999999';
        objTempData.MobilePhone = '00110000';
        objTempData.JobFunction = 'Developer';
        objTempData.MailingCity = 'Chicago';
        objTempData.MailingCountry = 'USA';
        objTempData.MailingStreet = 'Street 1';
        objTempData.Company = 'Test Company';
        objTempData.MiddleInitial = 'T';
        objTempData.Salutation  = 'MR';
        objTempData.School  = 'Test';
        objTempData.CA  = true;
        objTempData.CFA = true; 
        objTempData.PMP = true; 
        objTempData.CPA = true; 
        objTempData.OtherDesignation = true;        
        objTempData.NickName = 'Test Nick'; 
        objTempData.inSchool = true;
        
        //Create Lead
        Lead testLead = new Lead();
        testLead.Email =  objTempData.Email;
        testLead.FirstName = 'Test';
        testLead.Company = 'Test company';
        testLead.LastName = 'Test Last Name';
        insert testLead;
        objTempData.Id = testLead.Id;
        
        //Create  Sites
        Site__c objSite = new Site__c();
        objSite.Name = 'Testing Site';
        objSite.Active__c = true;
        objSite.Non_selectable__c = false;
        insert objSite;
        
        Exam_Group__c objExamGrp = new Exam_Group__c();
        objExamGrp.Active__c = true;
        Date dt1 = system.today();
        objExamGrp.Registration_Start_Date__c = dt1.addDays(4);
        insert objExamGrp;
        
        //create Exams
        Exam__c objExam = new Exam__c();
        objExam.Name = 'Test Exam Name';
        Date dt = system.today();
        objExam.Exam_Date__c = dt.addDays(4);
        objExam.Enrollment_Fee__c = 500;
        
        objExam.Last_Date_For_Early_Registration__c = dt.addDays(1);
        objExam.Last_Date_For_Standard_Registration__c = dt.addDays(2);
        objExam.Last_Date_For_Late_Registration__c = dt.addDays(3);
        objExam.Exam__c  = 'FRM Part 1';
       
        objExam.Exam_Group__c = objExamGrp.Id;
        insert objExam;
        
        //create exam sites
        Exam_Sites__c objExamSite = new Exam_Sites__c();
        objExamSite.Name = 'Test Exam Site';
        objExamSite.Exam__c = objExam.Id;
        objExamSite.Site__c = objSite.Id;
        insert objExamSite;
        
        //Products 
        product2 objProd = new product2();
        objProd.Name = 'Test Prod1';
        objProd.productCode = 'GL0008';
        objProd.IsActive = true;
        insert objProd;
        
        product2 objProd1 = new product2();
        objProd1.Name = 'Test Prod1';
        objProd1.productCode = 'GL0009';
        objProd1.IsActive = true;
        insert objProd1;
        
        product2 objProd2 = new product2();
        objProd2.Name = 'Test Prod1';
        objProd2.productCode = 'GL0016';
        objProd2.IsActive = true;
        insert objProd2;
        
        //Pricebook
        pricebook2 objPricebook = [select name, isactive from Pricebook2 where IsStandard = true limit 1];
        //objPricebook.Name = 'Test Price Book';
        //objPricebook.IsActive = true;
        //objPricebook.IsStandard = true;
        //insert objPricebook;
        
        //Insert PricebookEntry records
        PricebookEntry objPricebook1 = new PricebookEntry();
        objPricebook1.Pricebook2Id = objPricebook.Id;
        objPricebook1.Product2Id = objProd.Id;
        objPricebook1.UnitPrice = 100;
        objPricebook1.UseStandardPrice = false;
        insert objPricebook1;
        
        PricebookEntry objPricebook2 = new PricebookEntry();
        objPricebook2.Pricebook2Id = objPricebook.Id;
        objPricebook2.Product2Id = objProd1.Id;
        objPricebook2.UnitPrice = 100;
            objPricebook2.UseStandardPrice = false;
        insert objPricebook2;
        
        PricebookEntry objPricebook3 = new PricebookEntry();
        objPricebook3.Pricebook2Id = objPricebook.Id;
        objPricebook3.Product2Id = objProd2.Id;
        objPricebook3.UnitPrice = 100;
            objPricebook3.UseStandardPrice = false;
        insert objPricebook3;
        
        objTempData.sitename = 'Testing Site';
        ContactRemoter.GetMember(objTempData);
        ContactRemoter.SetLead(objTempData);
        objTempData.isFrmChecked = true;
        ContactRemoter.CreateOrder(objTempData);
        ContactRemoter.getActiveSites();
        List<String> lstProdCodes = new List<String>{'GL0008','GL0009','GL0016'};
        objTempData.productcode = lstProdCodes;
        ContactRemoter.getProduct('GL0008');
        ContactRemoter.getProduct('GL0009');
        ContactRemoter.getProduct('GL0016');
        ContactRemoter.getProduct('');
        ContactRemoter.Registrationdate();
        // ContactRemoter.getJobRequirementID();
        objTempData.email = 'Testing@testing.com';
        ContactRemoter.SetLead(objTempData);
        
        //Create Lead
        Lead testLead1 = new Lead();
        testLead1.Email =  objTempData.Email;
        testLead1.FirstName = 'Test1';
        testLead1.Company = 'Test company 1';
        testLead1.LastName = 'Test Last Name1';
        insert testLead1;
        objTempData.Id = testLead1.Id;
        objTempData.sameShip = 'true';
        ContactRemoter.CreateOrder(objTempData);
      // ContactRemoter.getAccountNames();
  
    }

}