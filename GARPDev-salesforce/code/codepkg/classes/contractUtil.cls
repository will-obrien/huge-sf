public class contractUtil {  
  
  
   
   public static void createIcbrrExport(List<Exam_Attempt__c> lstEA,Map<Id,Contract> mapContracts)
   {
        List<Ready_for_Icbrr_Export__c> lstICBRRDetails = new List<Ready_for_Icbrr_Export__c>();
        for(Exam_Attempt__c objEA : lstEA)
        {
           
            Ready_for_Icbrr_Export__c objIcbrr = new Ready_for_Icbrr_Export__c();
            objIcbrr.Exam_Registration__c = objEA.Id;
            
            if(objEA.Member__r.MailingStreet != null)
                objIcbrr.Address1__c = objEA.Member__r.MailingStreet;
            else if(objEA.Opportunity__r.Account.BillingStreet != null)
                objIcbrr.Address1__c = objEA.Opportunity__r.Account.BillingStreet;
                
            if(objEA.Member__r.MailingCity != null)
                objIcbrr.City__c = objEA.Member__r.MailingCity;
            else if(objEA.Opportunity__r.Account.BillingCity!= null)
                objIcbrr.Address1__c = objEA.Opportunity__r.Account.BillingCity;

            if(objEA.Member__r.MailingCountry!= null)
                objIcbrr.Country__c = objEA.Member__r.MailingCountry;
            else if(objEA.Opportunity__r.Account.BillingCountry!= null)
                objIcbrr.Address1__c = objEA.Opportunity__r.Account.BillingCountry;

            if(objEA.Member__r.MailingState!= null)
                objIcbrr.State__c = objEA.Member__r.MailingState;
            else if(objEA.Opportunity__r.Account.BillingState!= null)
                objIcbrr.Address1__c = objEA.Opportunity__r.Account.BillingState;

            if(objEA.Member__r.MailingPostalCode!= null)
                objIcbrr.PostalCode__c = objEA.Member__r.MailingPostalCode;
            else if(objEA.Opportunity__r.Account.BillingPostalCode!= null)
                objIcbrr.Address1__c = objEA.Opportunity__r.Account.BillingPostalCode;
            
            
            objIcbrr.Suffix__c = objEA.Member__r.Suffix__c;
            objIcbrr.Salutation__c = objEA.Member__r.Salutation;
            objIcbrr.FirstName__c = objEA.Member__r.FirstName;
            objIcbrr.LastName__c = objEA.Member__r.LastName;
            
            if(objEA.Member__r.Phone != null)
                objIcbrr.Phone__c = objEA.Member__r.Phone;
            else if(objEA.Member__r.OtherPhone != null)
                objIcbrr.Phone__c = objEA.Member__r.OtherPhone;
            else if(objEA.Member__r.HomePhone!= null)
                objIcbrr.Phone__c = objEA.Member__r.HomePhone;
                
            objIcbrr.AuthorizationTransactionType__c = 'Add';
            objIcbrr.ClientAuthorizationID__c = objEA.ClientAuthorizationID__c;
            objIcbrr.EligibilityApptDateFirst__c = objEA.Candidate_Commitment__r.StartDate;
            objIcbrr.EligibilityApptDateLast__c = objEA.Candidate_Commitment__r.Enddate;
            objIcbrr.Contact_Id__c = objEA.Member__c;
            objIcbrr.Email__c = objEA.Member__r.Email;
            objIcbrr.ClientCandidateId__c = objEA.Garp_Id__c;
            lstICBRRDetails.add(objIcbrr);
            
        }
        insert lstICBRRDetails;
   }
 }