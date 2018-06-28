@isTest(SeeAllData=True)
public class PDFAttacherTest2 {
Public Static Void PDFAttacherTest1(){
    Inspection__c inspectTest=[select id, Name, Date_of_Visit__c from Inspection__c Limit 1];
    ApexPages.StandardController PDFAttacherController = new ApexPages.StandardController(inspectTest);
    PDFAttacher pdf = new PDFAttacher(PDFAttacherController); 
    
    //PageReference a = 'https://ap1.salesforce.com/'+inspectTest.id;
    (pdf.attachPDF());
    }
}
