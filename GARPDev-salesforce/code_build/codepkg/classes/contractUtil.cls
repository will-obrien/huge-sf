public class contractUtil {  
  
  
   
   public static void createIcbrrExport(List<Exam_Attempt__c> lstEA,Map<Id,Contract> mapContracts)
   {
        List<Ready_for_Icbrr_Export__c> lstICBRRDetails = new List<Ready_for_Icbrr_Export__c>();
        for(Exam_Attempt__c objEA : lstEA)
        {
           
            Ready_for_Icbrr_Export__c objIcbrr = new Ready_for_Icbrr_Export__c();
            objIcbrr.Exam_Registration__c = objEA.Id;
            objIcbrr.Address1__c = objEA.Member__r.MailingStreet;
            objIcbrr.City__c = objEA.Member__r.MailingCity;
            objIcbrr.Country__c = objEA.Member__r.MailingCountry;
            objIcbrr.State__c = objEA.Member__r.MailingState;
            objIcbrr.PostalCode__c = objEA.Member__r.MailingPostalCode;
            objIcbrr.Suffix__c = objEA.Member__r.Suffix__c;
            objIcbrr.MiddleName__c = objEA.Member__r.Middle_Initial__c;
            objIcbrr.Salutation__c = objEA.Member__r.Salutation;
            objIcbrr.FirstName__c = objEA.Member__r.FirstName;
            objIcbrr.LastName__c = objEA.Member__r.LastName;
            objIcbrr.Phone__c = objEA.Member__r.Phone;
            objIcbrr.AuthorizationTransactionType__c = 'INSERT';
            objIcbrr.ExamAuthorizationCount__c ='1';
            objIcbrr.ExamSeriesCode__c ='2010-777';
            objIcbrr.ClientAuthorizationID__c = objEA.Opportunity__r.GARP_Invoice_Number__c;
            objIcbrr.EligibilityApptDateFirst__c = objEA.Candidate_Commitment__r.StartDate;
            objIcbrr.EligibilityApptDateLast__c = objEA.Candidate_Commitment__r.Enddate;
            objIcbrr.Contact_Id__c = objEA.Member__c;
            objIcbrr.Email__c = objEA.Member__r.Email;
            objIcbrr.ClientCandidateId__c = padLeft(objEA.Garp_Id__c);
            objIcbrr.LastUpdate__c = system.now();
            objIcbrr.Active__c = true;
            lstICBRRDetails.add(objIcbrr);
            
        }
        insert lstICBRRDetails;
   }
   
       public static String padLeft(String textToPad) {
           if(textToPad == null) return '';
        for(integer i = 0; i < 10 - textToPad.length(); i++)
            textToPad = '0' + textToPad;
        return textToPad;
    }
 }