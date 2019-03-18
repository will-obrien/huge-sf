public class LinkToUpdateSFDCController2 {

       public Implementation_Services__c c { get; set; }
       public String ImplementationServiceName {get; set;}
    
    // Constructor********************   
        public LinkToUpdateSFDCController2 () {            

            c = new Implementation_Services__c();
        } 
         
        
   // Method to update the record ********************   
       
        public PageReference Submit() {    
           
           
           List<Implementation_Services__c> ImplementationServiceDetail=new List<Implementation_Services__c>([Select id,name,Rates_Entered__c,Bill_Cycle__c from Implementation_Services__c where name=:ImplementationServiceName ]);

         
        // Validation Check before entering data into the SFDC System
 
         if (ImplementationServiceName == '')
         {
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Implementation Service Name'));
           return null;
         }
         
         if (ImplementationServiceDetail.size() ==0)
         {
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Sorry!  Entered Implementation Service Name is not correct. Please enter correct name.'));
           return null;
         }
         
        
         for(Implementation_Services__c I:ImplementationServiceDetail)
         {
         
           I.Bill_Cycle__c=C.Bill_Cycle__c;
           I.Rates_Entered__c=C.Rates_Entered__c ;
          update I;
         }

        return page.ThankYouPageImplementationService;
        }
        
         private static testMethod void Test_Submit(){
         	Test.startTest();
         	Opportunity opp = PGITestUtilities.getOpportunityDetails();
         	insert opp;
         	Implementation_Services__c impServices = PGITestUtilities.getImplementationServices(opp.Id);
         	insert impServices;
         	impServices = [SELECT Name FROM Implementation_Services__c WHERE Id =: impServices.Id];

         	PageReference pageRef = Page.LinkToUpdateSFDC2;
         	Test.setCurrentPage(pageRef);
         	LinkToUpdateSFDCController2 controller = new LinkToUpdateSFDCController2();
         	controller.ImplementationServiceName = impServices.Name;
         	controller.C.Rates_Entered__c = true;
         	controller.C.Bill_Cycle__c = '12'; 
         	PageReference retPageRef = controller.Submit();
         	Test.stopTest();
         	
         	system.assertNotEquals(retPageRef, null);
         	Implementation_Services__c retImpServices = [SELECT Rates_Entered__c, Bill_Cycle__c FROM Implementation_Services__c WHERE Id =: impServices.Id];
         	system.assertEquals(retImpServices.Rates_Entered__c, true);
         	system.assertEquals(retImpServices.Bill_Cycle__c, '12');
         }
         
         
         private static testMethod void Test_Submit_ImplementationServiceName_Blank() {
         	Test.startTest();
         	PageReference pageRef = Page.LinkToUpdateSFDC2;
         	Test.setCurrentPage(pageRef);
         	LinkToUpdateSFDCController2 controller = new LinkToUpdateSFDCController2();
         	controller.ImplementationServiceName = '';
         	PageReference retPageRef = controller.Submit();
         	Test.stopTest();
         	
         	system.assertEquals(retPageRef, null);
         }
         
         private static testMethod void Test_Submit_ImplementationServiceName_NotFound(){
         	Test.startTest();
         	PageReference pageRef = Page.LinkToUpdateSFDC2;
         	Test.setCurrentPage(pageRef);
         	LinkToUpdateSFDCController2 controller = new LinkToUpdateSFDCController2();
         	controller.ImplementationServiceName = 'test record not found';
         	PageReference retPageRef = controller.Submit();
         	Test.stopTest();
         	
         	system.assertEquals(retPageRef, null);
         }  
}