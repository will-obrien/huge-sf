public class RemovedCACertificateReportController{

 public List<Account> accountSoLst {get;set;}
 
  // constructor method for standard controller
    public RemovedCACertificateReportController() {   
                                          
           accountSoLst =  [select  Parent.Name,
                                    Certificate_Issuer_Organization__c,
                                    Certificate_Issuer_Organizational_Unit__c,
                                    Name,
                                    SHA_1_Fingerprint__c,                                                                  
                                    Valid_From_YYYY_MMM_DD__c,
                                    Valid_To_YYYY_MMM_DD__c,
                                    Signing_Key_Parameters__c,
                                    Signature_Algorithm__c,
                                    Trust_Bits__c,
                                    EV_Policy_OID_s__c, 
                                    Removal_Bug_No_or_Date__c,
                                    Approval_Bug__c,
                                    NSS_Release_When_First_Included__c,
                                    Firefox_Release_When_First_Included__c,
                                    NSS_Release_When_Removed__c,
                                    Firefox_Release_When_Removed__c,
                                    URL_to_Test_Website_or_Example_Cert__c,
                                    Mozilla_Applied_Constraints__c, 
                                    Parent.Company_Website__c,
                                    Parent.Geographic_Focus__c,
                                    Certificate_Policy_CP__c,
                                    Certification_Practice_Statement_CPS__c,
                                    Standard_Audit__c,
                                    BR_Audit__c, 
                                    EV_Audit__c,
                                    Auditor__c,
                                    Standard_Audit_Type__c,
                                    Standard_Audit_Statement_Dt__c,
                                    Comments__c  
                                          from  Account
                                          where Status__c In ('Removed') and RecordType.Name In ('Root Certificate')
                                          order by Parent.Name, Name];
     
 
     
     }
     
     String CurrentDate = ' ';
 
    // Get current Datetime in long date format   

    public String getCurrentDate() {

      Datetime cDT = System.now();
      CurrentDate = cDT.format('MMMM d, yyyy');

      return CurrentDate;

   }

     
  }