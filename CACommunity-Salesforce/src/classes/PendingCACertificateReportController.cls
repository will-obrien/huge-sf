public class PendingCACertificateReportController{

 public List<Root_case__c> rootCaseSoLst {get;set;}
 
  // constructor method for standard controller
    public PendingCACertificateReportController() {   
                                          
           rootCaseSoLst =  [select Case_No__r.Account.name,
                                    O_From_Issuer_Field__c,
                                    OU_From_Issuer_Field__c,
                                    Root_Certificate_Name__c,
                                    Request_Status__c,
                                    Root_Certificate_Download_URL__c,
                                    SHA_1_Fingerprint__c,
                                    Valid_From_YYYY_MMM_DD__c,
                                    Valid_To_YYYY_MMM_DD__c,
                                    Signing_Key_Parameters__c,
                                    Certificate_Signature_Algorithm__c,
                                    Trust_Bits__c,
                                    EV_Policy_OID_s__c, 
                                    Case_No__r.Link_to_Bugzilla_Bug__c,
                                    Test_Website_URL_SSL_or_Example_Cert__c,
                                    Mozilla_Applied_Constraints__c, 
                                    Case_No__r.Company_Website__c,
                                    Case_No__r.Geographic_Focus__c, 
                                    CA_Document_Repository__c,
                                    CP__c, 
                                    CPS__c , 
                                    Standard_Audit__c,
                                    BR_Audit__c, 
                                    EV_Audit__c, 
                                    Auditor_Name__c    ,
                                    Standard_Audit_Type__c, 
                                    Standard_Audit_Statement_Dt__c , 
                                    Publicly_Disclosed_and_Audited_subCAs__c 
                                          from  Root_Case__c
                                          where Case_No__r.Status != 'Closed'  and request_Status__c not in ('Denied','Complete')
                                          order by Case_No__r.Account.name, Root_Certificate_Name__c];
     
     
     
     }
     
     String CurrentDate = ' ';
 
    // Get current Datetime in long date format   

    public String getCurrentDate() {

      Datetime cDT = System.now();
      CurrentDate = cDT.format('MMMM d, yyyy');

      return CurrentDate;

   }

     
  }