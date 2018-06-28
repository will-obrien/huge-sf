@isTest
public class batchJobActivateProcReg_test {

    Static Exam_Group__c egTo;
    Static Exam_Group__c egFrom;
    Static Proctor_Registration__c pr;
    Static Proctor_Registration__c pr1;
    
    static void testData()
     {
        Date ed = date.newInstance(2015, 11, 21);
        egTo = new Exam_Group__c(name = '15-Nov', Exam_Date__c = ed);
        insert egTo;
         
        Exam__c examTo = new Exam__c(name = 'Exam To', Exam_Group__c = egTo.Id, Exam_Date__c = ed);
        insert examTo;
           
        Site__c tsTo = new Site__c(name = 'TS1', Site_Code__c = 'AAA', Display_Address__c = 'xx');
        insert tsTo;
         
        Exam_Sites__c esTo = new Exam_Sites__c(name = 'Exam Sites To', Site__c = tsTo.Id, Exam__c = examTo.Id);
        insert esTo;

        
        ed = date.newInstance(2015, 3, 16);
        egFrom = new Exam_Group__c(name = '15-May', Exam_Date__c = ed);
        insert egFrom;

        Exam__c examFrom = new Exam__c(name = 'Exam From', Exam_Group__c = egFrom.Id, Exam_Date__c = ed);
        insert examFrom;
           
        Site__c tsFrom = new Site__c(name = 'TS1', Site_Code__c = 'AAA', Display_Address__c = 'xx');
        insert tsFrom;
         
        Exam_Sites__c esFrom = new Exam_Sites__c(name = 'Exam Sites From', Site__c = tsFrom.Id, Exam__c = examFrom.Id);
        insert esFrom;
         
        pr = new Proctor_Registration__c(name = 'PR1', Exam_Group__c = egFrom.Id, Test_Site__c = tsFrom.Id, Proctor_First_Name__c = 'FN', Proctor_Last_Name__c = 'LN', Type__c = 'Supervisor', Proctor_Email__c = 'Supervisor@gmail.com');
        insert pr;

        pr1 = new Proctor_Registration__c(name = 'PR1', Exam_Group__c = egFrom.Id, Test_Site__c = tsFrom.Id, Proctor_First_Name__c = 'FN', Proctor_Last_Name__c = 'LN', Type__c = 'Room', Proctor_Email__c = 'Room@gmail.com');
        insert pr1;
         
     }
     
     static testMethod void UnitTest_1()
     {
         testData();
         test.startTest();
         batchJobActivateProctorRegistrations b = new batchJobActivateProctorRegistrations(egTo.id, 'Supervisor', pr.Id);
         database.executeBatch(b);

         batchJobActivateProctorRegistrations b1 = new batchJobActivateProctorRegistrations(egTo.id, 'Non-Supervisor', pr.Id);
         database.executeBatch(b1);

         test.stopTest();
     }
}