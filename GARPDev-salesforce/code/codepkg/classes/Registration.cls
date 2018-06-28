public without sharing class Registration {
    public static boolean bFRMActivatedXX = false;
    public static boolean bERPActivatedXX = false;
    static Decimal dTotalPrice = 0;
    static Id siteID = null;
    static boolean bCreateMemContracts = true;
    static id userid = [select id, name, Record_id__c from updateids__c where name = 'User'].Record_id__c;
    static decimal dStandardAmount = 0;
    static boolean bHasFrmEnrollment = false;
    static boolean bHasErpEnrollment = false;
    static boolean bFRMPaidFor2009 = false;
    static boolean bERPPaidFor2009 = false;
    public class wrapperSetLead {
        public TempAccount tempAccount {
            get;
            set;
        }
        public Id leadId {
            get;
            set;
        }
    }

    public class wrapperCheckExistingMember {
        public TempAccount tempAccount {
            get;
            set;
        }
        public Id contactId {
            get;
            set;
        }
    }

    public class wrapperCreateOrder {
        public Id contactId {
            get;
            set;
        }
         public Id opportunityId {
            get;
            set;
        }

         public String garpId {
            get;
            set;
        }

        public Decimal totalCost {
            get;
            set;
        }

        public String invoiceNumber {
            get;
            set;
        }
        
        public String company {
            get;
            set;
        }

        public Decimal shipping {
            get;
            set;
        }

        public Decimal tax {
            get;
            set;
        }
 
        public String productDetails {
            get;
            set;
        }

        public ChargentSFA__Payment_Request__c payRequest {
            get;
            set;            
        }

        public String errorMsg {
            get;
            set;
        }
        
    }

    public class wrapperGetContact {
        public contact contactReturnData {
            get;
            set;
        }
        public TempAccount tempAccount {
            get;
            set;
        }
    }


    public class wrapperProductInfo {
        public string strProductCode {
            get;
            set;
        }
        public string strProductName {
            get;
            set;
        }
        public string strGLCode {
            get;
            set;
        }
        public string strDisplayName {
            get;
            set;
        }
        public boolean bFRMActivated {
            get;
            set;
        }
        public boolean bERPActivated {
            get;
            set;
        }
        public boolean bFRM1Deffered {
            get;
            set;
        }
        public boolean bFRM2Deffered {
            get;
            set;
        }
        public boolean bERPDeffered {
            get;
            set;
        }
        public boolean bERP1Deffered {
            get;
            set;
        }
        public boolean bERP2Deffered {
            get;
            set;
        }
        public boolean bFRM1UnDeffered {
            get;
            set;
        }
        public boolean bFRM2UnDeffered {
            get;
            set;
        }
        public boolean bERPUnDeffered {
            get;
            set;
        }
        public boolean bFRMSwitch {
            get;
            set;
        }
        public boolean bERPSwitch {
            get;
            set;
        }
        public String strFRMOneBookProdCode {
            get;
            set;
        }
        public String strFRMOneBookGLCode {
            get;
            set;
        }
        public decimal dFRMOneBookAmount {
            get;
            set;
        }
         public String strERPOneBookProdCode {
            get;
            set;
        }
        public String strERPOneBookGLCode {
            get;
            set;
        }
        public decimal dERPOneBookAmount {
            get;
            set;
        }
        public String strFRMTwoBookProdCode {
            get;
            set;
        }
        public String strFRMTwoBookGLCode {
            get;
            set;
        }
        public decimal dFRMTwoBookAmount {
            get;
            set;
        }
        public String strERPTwoBookProdCode {
            get;
            set;
        }
        public String strERPTwoBookGLCode {
            get;
            set;
        }
        
        public decimal dERPTwoBookAmount {
            get;
            set;
        }
        public String strFRMOneEnrollmentProdCode {
            get;
            set;
        }
        public String strFRMOneEnrollmentGLCode {
            get;
            set;
        }
        public decimal dFRMOneEnrollmentAmount {
            get;
            set;
        }
        public decimal examPrice {
            get;
            set;
        }
        public String strERPBookProdCode {
            get;
            set;
        }
        public String strERPBookGLCode {
            get;
            set;
        }
        public decimal dERPBookAmount {
            get;
            set;
        }
        public String strERPOneEnrollmentProdCode {
            get;
            set;
        }
        public String strERPOneEnrollmentGLCode {
            get;
            set;
        }
        public decimal dERPEnrollmentAmount {
            get;
            set;
        }
        public string strFCBRMemberProdCode {
            get;
            set;
        }
        public string strFCBRNonMemberProdCode {
            get;
            set;
        }
        public string strFCBRMemberGlCode {
            get;
            set;
        }
        public string strFCBRNonMemberGlCode {
            get;
            set;
        }
        public decimal dFCBRMemberExamAmt {
            get;
            set;
        }
        public decimal dFCBRNonMemberExamAmt {
            get;
            set;
        }
        public string strCBRMemberProdCode {
            get;
            set;
        }
        public string strCBRNonMemberProdCode {
            get;
            set;
        }
        public string strCBRMemberGlCode {
            get;
            set;
        }
        public string strCBRNonMemberGlCode {
            get;
            set;
        }
        public decimal dCBRMemberExamAmt {
            get;
            set;
        }
        public decimal dCBRNonMemberExamAmt {
            get;
            set;
        }
        public string strMemberProdCode {
            get;
            set;
        }
        public string strMemberGLCode {
            get;
            set;
        }
        public decimal dMemberAmt {
            get;
            set;
        }
        public string strWileyProdCode {
            get;
            set;
        }
        public string strWileyGLCode {
            get;
            set;
        }
        public string strIndividualProdCode {
            get;
            set;
        }
        public string strIndividualGLCode {
            get;
            set;
        }

        public string strAffiliateGLCode {
            get;
            set;
        }
        public string strAffiliateProdCode {
            get;
            set;
        }
        public string strTaxGLCode {
            get;
            set;
        }
        public string strTaxProdCode {
            get;
            set;
        }
        public string strCanadianTaxGLCode {
            get;
            set;
        }
        public string strCanadianTaxProdCode {
            get;
            set;
        }
        public string strShippingGLCode {
            get;
            set;
        }
        public string strShippingProdCode {
            get;
            set;
        }
        public string strFreeIndividualProdCode {
            get;
            set;
        }
        public string strFreeIndividualGLCode {
            get;
            set;
        }
        public string strDeferredPaymentGLCode {
            get;
            set;
        }
        public string strDeferrePaymentProdCode {
            get;
            set;
        }
        public boolean returning {
            get;
            set;
        }
    }

    public static Boolean removeOrder(String oppId, Boolean removeContract) {
        if (oppId != null) {
            
            //List <ChargentSFA__Transaction__c> lstTrans = [select Id, Name from ChargentSFA__Transaction__c where ChargentSFA__Opportunity__c = :oppId];
            //delete lstTrans;
            
            List < Opportunity > lstOpp = [select Id, Name from Opportunity where id = : oppId];
            if (lstOpp != null && lstOpp.size() > 0) {

                List < Contract > lstContract = [select Id, Name, Opportunity__c from contract where Opportunity__c in : lstOpp];
                if (lstContract != null && lstContract.size() > 0 && removeContract) {
                    //for(Contract con :lstContract) {
                    //    ea.Cancelled__c = true;
                    //}
                    //update lstEA;                    
                    //delete lstContract;
                }
                List < Exam_Attempt__c > lstEA = [select Id, Name from Exam_Attempt__c where Opportunity__c in : lstOpp];
                if (lstEA != null && lstEA.size() > 0 && removeContract) {
                    for(Exam_Attempt__c ea :lstEA) {
                        ea.Cancelled__c = true;
                    }
                    update lstEA;
                }
                for(Opportunity opp :lstOpp) {
                    opp.StageName = 'Closed Lost';
                }
                update lstOpp;
                //delete lstOpp;
                return true;
            }
        }
        return false;
    }


    public static Contact setContactInfo(TempAccount tempAccount) {

        List < contact > lstcnt = [select id, Email, Name_As_it_Appears_On_ID__c, ID_Type__c, ID_Number__c, Company__c, Corporate_Title__c, Job_Function__c, Area_of_Concentration__c, Professional_Designation_CA__c, Professional_Designation_CFA__c, Professional_Designation_CMA__c, Professional_Designation_CPA__c, School_Name__c, Degree_Program_Name__c, Currently_in_School__c, Currently_Working__c from contact where Id = : tempAccount.Id];
        if (lstcnt != null && lstcnt.size() > 0) {

            Contact con = lstcnt[0];
            
            con.Name_As_it_Appears_On_ID__c = tempAccount.idName;
            con.ID_Type__c = tempAccount.idType;
            con.ID_Number__c = tempAccount.idNumber;

            con.Company__c = tempAccount.Company;
            con.Corporate_Title__c = tempAccount.Title;
            con.Job_Function__c = tempAccount.JobFunction;
            con.Area_of_Concentration__c = tempAccount.Organization;
            con.Years_of_Experience__c = tempAccount.Years_of_Experience;
            
            if(tempAccount.CA != null)
                con.Professional_Designation_CA__c = tempAccount.CA;
            if(tempAccount.CFA != null)            
                con.Professional_Designation_CFA__c = tempAccount.CFA;
            if(tempAccount.CMA != null)            
                con.Professional_Designation_CMA__c = tempAccount.CMA;
            if(tempAccount.CPA != null)            
                con.Professional_Designation_CPA__c = tempAccount.CPA;
 
            if(tempAccount.OtherDesignation != null) {
                con.Professional_Designation_Other__c = tempAccount.OtherDesignation;
                con.Other_Qualifications__c = tempAccount.OtherDesignationText;
            }
                
            con.School_Name__c = tempAccount.School;
            con.Degree_Program_Name__c = tempAccount.Degree_Program_Name;
            
            con.Email_Information_Exchange__c = tempAccount.infoExchange;
            //We moved this field to the Registration page from Registration Info page - sr 7/22/2015 
            //con.Exam_Prep_Provider_Outreach__c = tempAccount.eppHelp;
            
            con.Currently_Working__c = tempAccount.isWorking;
            con.Currently_in_School__c = tempAccount.inSchool;
            
            update con;

            return con;
        } else {
            return null;
        }

    }

    public static wrapperGetContact getContactInfo(String contactId) {

        wrapperGetContact retCon = new wrapperGetContact();
        retCon.tempAccount = new TempAccount();

        List < contact > lstcnt = [select Id, Email, GARP_Member_ID__c, KPI_Membership_Payment_Status__c, KPI_CPE_Participation__c, Membership_Type__c, Name_As_it_Appears_On_ID__c, ID_Type__c, ID_Number__c, Company__c, Corporate_Title__c, Job_Function__c, Area_of_Concentration__c, Years_of_Experience__c, Professional_Designation_CA__c, Professional_Designation_CFA__c, Professional_Designation_CMA__c, Professional_Designation_CPA__c, Professional_Designation_Other__c, Other_Qualifications__c, School_Name__c, Degree_Program_Name__c, Email_Information_Exchange__c, Exam_Prep_Provider_Outreach__c, Currently_Working__c, Currently_in_School__c from contact where (Id = :contactId OR GARP_Member_ID__c = :contactId)];
        if (lstcnt != null && lstcnt.size() > 0) {
            retCon.contactReturnData = lstcnt[0];
            return retCon;
        } else {
            return null;
        }

    }

    public static wrapperCheckExistingMember CheckExistingMember(String Email) {
        contact cld = null;
        List < contact > lstcnt = [select Id, Email from contact where Email = : Email];

        wrapperCheckExistingMember em = new wrapperCheckExistingMember();

        if (lstcnt != null && lstcnt.size() > 0) {
            em.tempAccount = new TempAccount();
            em.contactId = lstcnt[0].Id;
            return em;
        } else {
            em.tempAccount = new TempAccount();
            em.contactId = null;
            return em;
        }
    }

    public static Id setLead(String email, String firstName, String LastName, String garpMembershipType) {
        Lead ld = null;
        if (email == null) return null;
        List < Lead > lstLeads = [select id, Name, Email from Lead where Email = : email and Isconverted = false LIMIT 1];

        //wrapperSetLead wrapperSetLeadReturn = new wrapperSetLead();    
        //wrapperSetLeadReturn.tempAccount = new TempAccount();

        if (lstLeads != null && lstLeads.size() > 0) {
            ld = lstLeads[0];
            ld.FirstName = firstName;
            ld.LastName = lastName;
            ld.Company = firstName + ' ' + lastName;
            ld.Email = email;
            ld.LeadSource = garpMembershipType;
            update ld;
            //wrapperSetLeadReturn.leadId = ld.id;
            //return wrapperSetLeadReturn;
            return ld.id;
        } else {
            Lead newLead = new Lead();
            newLead.FirstName = firstName;
            newLead.LastName = lastName;
            newLead.Company = firstName + ' ' + lastName;
            newLead.Email = email;
            newLead.LeadSource = garpMembershipType;
            insert newLead;
            //wrapperSetLeadReturn.leadId = newLead.id;
            //return wrapperSetLeadReturn;
            return newLead.id;
        }
    }


    public static date registrationDate() {
        date d;
        List < Exam_Group__c > lstcnt = [select id, Active__c, Registration_Start_Date__c from Exam_Group__c where Active__C = true];
        if (lstcnt != null && lstcnt.size() > 0) {
            d = lstcnt[0].Registration_Start_Date__c;
        }
        return d;
    }

    public static date testDate() {
        date d;
        List < Exam_Group__c > lstcnt = [select id, Active__c, Exam_Date__c, Registration_Start_Date__c from Exam_Group__c where Active__C = true];
        if (lstcnt != null && lstcnt.size() > 0) {
            d = lstcnt[0].Exam_Date__c;
        }
        return d;
    }

    
    public static List<Contact> GetBussinessContact(TempAccount objData) {
        
       Id memBusRecType = RecordTypeHelper.GetRecordTypeId('Contact','Business Relationship');
        
        contact cld = null;
        
        system.debug('GetBussinessContact:'+objData.Email);
        
        List < contact > lstcnt = [select id, Email, RecordTypeId from contact where Email = : objData.Email and RecordTypeId = :memBusRecType];
        if (lstcnt != null && lstcnt.size() > 0) {

            return lstcnt;

        }
        return null;
        
    }
    
    
    public static boolean GetMember(TempAccount objData) {
        contact cld = null;
        
        system.debug('GetMember:'+objData.Email);
        
        List < contact > lstcnt = [select id, Email from contact where Email = : objData.Email];
        if (lstcnt != null && lstcnt.size() > 0) {

            cld = lstcnt[0];
            return true;

        } else {
            
            system.debug('Contact not Found!:'+objData.Email);
            
            List<User> lstUser = [Select Id,ContactId,Email from User where Email = :objData.Email and UserType = 'CspLitePortal'];
            
            system.debug('lstUser:'+lstUser);
            
            if (lstUser != null && lstUser.size() > 0) {
                return true;
            }
        }
        return false;
        
    }
    public static Id SetLead(TempAccount objData) {
        return checkLead(objData);
    }

    public static Id checkLead(TempAccount objData) {
        Lead ld = null;
        if (objData.Email == null) return null;
        List < Lead > lstLeads = [select id, Name, Email from Lead where Email = : objData.Email and Isconverted = false LIMIT 1];
        if (lstLeads != null && lstLeads.size() > 0) {
            ld = lstLeads[0];
            ld.FirstName = objData.FirstName;
            ld.LastName = objData.LastName;
            ld.Company = objData.FirstName + ' ' + objData.LastName;
            ld.Email = objData.Email;
            ld.Membership_Type__c = objData.garpMembership_Type;
            update ld;
            system.debug('ld=== ' + ld);
            return ld.id;
        } else {
            Lead newLead = new Lead();
            newLead.FirstName = objData.FirstName;
            newLead.LastName = objData.LastName;
            newLead.Company = objData.FirstName + ' ' + objData.LastName;
            newLead.Email = objData.Email;
            newLead.Membership_Type__c = objData.garpMembership_Type;
            insert newLead;
            return newLead.id;
        }
    }

    /**
     * BELOW are Methods for registration flows for an Unknown from website
     *
     * DO NOT MODIFY ANYTHING PAST THIS POINT UNLESS YOU KNOW WHAT YOU'RE DOING!
     *
     * If you do modify anything below, you will also need to:
     * (1) Temp Account and Contact remoter for properties definition and return calls to front end.
     *
     */
    public static wrapperCreateOrder CreateOrder(TempAccount objData) {

        
        Id OpportunityId = null;
        Id contactId = null;
        Id accountId = null;

        Contact con = null;
        Account acct = null;
                    
        if (objData.contactId != null) {
            contactId = objData.contactId;
            List < Contact > lstContact = [SELECT Id, Name, AccountId FROM Contact WHERE Id = : contactId];
                        
            if (lstContact != null && lstContact.size() > 0) {
                List < Account > lstAcct = [select Id, Name from Account where Id = : lstContact[0].AccountId];
                if (lstAcct != null && lstAcct.size() > 0) {
                    
                    accountId = lstAcct[0].Id;

                    Opportunity opp = new Opportunity();
                    opp.Name = 'FRM/ERP Registration';
                    opp.Accountid = accountId;
                    opp.StageName = 'New Lead';
                    opp.ChargentSFA__Billing_First__c = objData.FirstName;
                    opp.ChargentSFA__Billing_Last__c = objData.LastName;
                    opp.ChargentSFA__Billing_Email__c = objData.Email;

                    opp.Alternate_Method_of_Payment__c = objData.paymentMethod;

                    opp.CloseDate = system.today();
                    opp.Eligible_for_Membership_Extension__c = true;
                    if(objData.campaignId!=null)
                        opp.CampaignId = objData.campaignId;
                    insert opp;

                    //System.assert(false, 'BOOM!1' + opp);
                    
                    OpportunityContactRole contactRole = new OpportunityContactRole(OpportunityId=opp.id, ContactId=lstContact[0].Id, Role='Decision Maker');
                    insert contactRole;
        
                    OpportunityId = opp.Id;
                    
                }
            }

        } else {

            Database.LeadConvert convertLead = new Database.LeadConvert();
            convertLead.setLeadId(objData.id);
            LeadStatus ls = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
            convertLead.setConvertedStatus(ls.MasterLabel);
            Database.LeadConvertResult lcr = Database.convertLead(convertLead);
            if (lcr.isSuccess()) {
                Lead convertedLead = [SELECT ConvertedAccountId, ConvertedContactId, ConvertedDate, ConvertedOpportunityId FROM Lead where id = : objData.id];
                system.debug('convertedLead ==' + convertedLead);
                contactId = convertedLead.ConvertedContactId;
                accountId = convertedLead.ConvertedAccountId;
                OpportunityId = convertedLead.ConvertedOpportunityId;
                if (objData.isFrmChecked != true && objData.isErpChecked != true && !objData.isIcbrChecked)
                    updateOpportunityinfoForMembers(OpportunityId, objData);
            }
        }
        
        acct = updateAccountInfo(objData, accountId);
        con = updateContactInfo(objData, contactId);
                       
        Id membershipContract = CreateMemberShipContract(objData, accountId, OpportunityId, contactId, true);
        createOppLineItems(OpportunityId, objData);
        Id contractID;
        List < Candidate_Requirement__c > lstCandReqs;
        if (objData.isFBRChecked != null && objData.isFBRChecked) {
            contractID = CreateContract(accountId, objData, OpportunityId, contactId);
            lstCandReqs = createCandidateRequirements(contractID, objData);
        }
        
                
        if (objData.isFrmChecked == true || objData.isErpChecked == true || objData.Membership_Type != 'AFREE' || objData.isIcbrChecked)
            createExamAttempts(objData, contactId, accountId, OpportunityId, (objData.isFrmChecked == true || objData.isErpChecked == true));
        else updateOpportunityinfo(objData, OpportunityId, true, false, false);

        if(objData.paymentMethod != 'CC' && objData.Membership_Type != 'AFREE') {

            Opportunity opp = new Opportunity();
            opp.Name = 'Affiliate Membership';
            opp.Accountid = accountId;
            opp.StageName = 'New Lead';
            opp.CloseDate = system.today();
            opp.Eligible_for_Membership_Extension__c = true;
            opp.ChargentSFA__Billing_First__c = objData.FirstName;
            opp.ChargentSFA__Billing_Last__c = objData.LastName;
            opp.ChargentSFA__Billing_Email__c = objData.Email;
            opp.Alternate_Method_of_Payment__c = objData.paymentMethod;
            if(objData.campaignId!=null)
                opp.CampaignId = objData.campaignId;
            
            insert opp;
            
            OpportunityContactRole contactRole = new OpportunityContactRole(OpportunityId=opp.id, ContactId=contactId, Role='Decision Maker');
            insert contactRole;
       
            objData.Membership_Type = 'AFREE';
            objData.garpMembership_Type = 'AFREE';
            TempAccount.productDefinition productDefition = new TempAccount.productDefinition();
            productDefition.GLCode = '4999';
            productDefition.ProductCode = 'AFREE';
            objData.productcode1 = new TempAccount.productDefinition[]{ productDefition };   
            objData.ShippingOptionsString='';
                
            Id membershipAffiliateContract = CreateMemberShipContract(objData, acct.Id, opp.Id, con.Id, false);
                        
            createOppLineItems(opp.Id, objData);
                   
        }
        
        wrapperCreateOrder returnWrapper = new wrapperCreateOrder();
        returnWrapper.garpId = con.GARP_Member_ID__c;
        returnWrapper.totalCost = dTotalPrice;
        returnWrapper.contactId = contactId;
        returnWrapper.opportunityId =OpportunityId ;
        return returnWrapper;


    }
    
    public static wrapperCreateOrder createOrderForPortalUsers(TempAccount objData) {
        bCreateMemContracts = false;
        system.debug('objData == '+objData);
        Id currentUSer = userInfo.getuserId();
        User objUSer = [select id, Email, contactId from user where id = : currentUSer];
        Contact objContact = [select id, GARP_Member_ID__c, Name, Accountid, MailingCity, ID_Number__c, ID_Type__c, Name_As_it_Appears_On_ID__c, MailingCountry, MailingPostalCode, MailingState, MailingStreet from contact where id = : objUSer.contactId];
        objContact.Exam_Prep_Provider_Outreach__c = objData.eppHelp;
        update objContact;
        Opportunity oppRecord = CreateOpportunity(objContact);
        createOppLineItems(oppRecord.Id, objData);
        Id paymentId = null;
        
        List <campaign> lstCam;   
        if(objData.campaignId != null)
            lstCam = [SELECT Id, Name FROM campaign WHERE Id = : objData.campaignId];

        createExamAttempts(objData, objContact.Id, oppRecord.AccountId, oppRecord.Id, true);
                
        wrapperCreateOrder returnWrapper = new wrapperCreateOrder();
        returnWrapper.garpId = objContact.GARP_Member_ID__c;
        returnWrapper.totalCost = dTotalPrice;
        returnWrapper.contactId = objContact.Id;
        returnWrapper.opportunityId =oppRecord.Id;
        return returnWrapper;        
        
       
    }    

    public static void updateOpportunityinfoForMembers(Id recordId,TempAccount objData) {
        Opportunity o = [select id, Eligible_for_Membership_Extension__c from opportunity where id = : recordId];

        if(objData.autoRenew == true) {
            o.Auto_Renew__c=true;
        }
        o.Eligible_for_Membership_Extension__c = true;
        update o;
    }
    
    public Boolean changeExamSite(String examAttemptId, String newExamSiteId) {
        Exam_Attempt__c ea = [select Id, Name, Exam_Site__c from Exam_Attempt__c where Id = :examAttemptId];
        if(ea != null) {
            ea.Exam_Site__c = newExamSiteId;
            update ea;
            return true;
        }
        
        return false;
    }
    
    public static set < String > getActiveSites() {

        set < String > lstSiteNames = new set < String > ();
        String strQuery = 'select id,Site__c,Exam__c,site__r.name from Exam_Sites__c where site__r.Active__c = true and site__r.Non_selectable__c = false  and Exam__r.Exam_Group__r.Active__c = true';
        if (siteID != null)
            strQuery += ' and site__c =:siteID';
        system.debug('strQuery == ' + strQuery);
        for (Exam_Sites__c obj: Database.query(strQuery)) {
            lstSiteNames.add(obj.site__r.name);
        }
        return lstSiteNames;
    }

    public static Boolean returnBool(Boolean inBool) {
        if (inBool == null)
            return false;
        else return inBool;
    }

    public static Contact updateContactInfo(TempAccount objData, Id recordId) {
        contact con = [select id, GARP_Member_ID__c, Faculty_Reference__c, Degree_Program_Name__c, MailingCity, Other_Qualifications__c, Mailing_Address_Company__c, MailingCountry, MailingState, MailingPostalCode, MailingStreet, Middle_Initial__c, Nickname__c, Professional_Designation_CPA__c, Professional_Designation_Other__c, Professional_Designation_CA__c, professional_Designation_CFA__c, Professional_Designation_PMP__c, Email, Currently_in_School__c, School_Name__c, Company__c, Membership_Type__c, FirstName, HomePhone, Job_Function__c, LastName, MobilePhone, Suffix__c, KPI_Membership_Auto_Renew_Orig_Status__c from contact where id = : recordId];
        String strNameByProdcutCode = '';

        con.Degree_Program_Name__c = objData.Degree_Program_Name;
        con.Email = objData.Email;
        con.Title = objData.Salutation;
        con.FirstName = objData.FirstName;
        con.HomePhone = objData.HomePhone;
        con.MobilePhone = objData.MobilePhone;
        con.Job_Function__c = objData.JobFunction;
        con.Area_of_Concentration__c = objData.Organization;
        con.LastName = objData.LastName;
        con.Mailing_Address_Company__c = objData.MailingCompany;
        con.MailingCity = objData.MailingCity;
        con.MailingCountry = objData.MailingCountry;
        con.MailingStreet = objData.MailingStreet;
        if(objData.MailingStreetTwo != null && objData.MailingStreetTwo.length() > 0)
            con.MailingStreet += '\n' + objData.MailingStreetTwo;
        if(objData.MailingStreetThree != null && objData.MailingStreetThree.length() > 0)
            con.MailingStreet += '\n' + objData.MailingStreetThree;
        con.Company__c = objData.Company;
        con.Middle_Initial__c = objData.MiddleInitial;
        con.Suffix__c = objData.Salutation;
        con.MailingPostalCode = objData.MailingPostalCode;
        con.MailingState = objData.MailingState;

        if (objData.isFrmChecked == true || objData.isErpChecked == true)
            con.Membership_Type__c = 'Individual';

        con.Degree_Program_Name__c = objData.Degree_Program_Name;
        con.School_Name__c = objData.School;
        con.Professional_Designation_CA__c = returnBool(objData.CA);
        con.Professional_Designation_CFA__c = returnBool(objData.CFA);
        con.Professional_Designation_PMP__c = returnBool(objData.PMP);
        con.Professional_Designation_CPA__c = returnBool(objData.CPA);
        con.Professional_Designation_ACCA__c = returnBool(objData.ACCA);
        con.Professional_Designation_CMA__c = returnBool(objData.CMA);
        con.Professional_Designation_Other__c = returnBool(objData.OtherDesignation);
        if (objData.OtherDesignation == true)
            con.Other_Qualifications__c = objData.OtherDesignationText;

        con.Nickname__c = objData.NickName;
        con.Currently_in_School__c = returnBool(objData.inSchool);
        con.ID_Type__c = objData.idType;
        con.Name_As_it_Appears_On_ID__c = objData.idName;
        con.ID_Number__c = objData.idNumber;
        con.KPI_Membership_Auto_Renew_Orig_Status__c = returnBool(objData.autoRenew);
        con.Exam_Prep_Provider_Outreach__c = objData.eppHelp;

        con.recordTypeId = RecordTypeHelper.GetRecordTypeId('Contact', 'Member');
        if (objData.isStudentChecked != null && objData.isStudentChecked) {
            con.Faculty_Reference__c = objData.facultyReference;
            con.Faculty_Reference_Email_Address__c = objData.facultyReferenceEmail;
            con.Expected_Graduation_Date__c = objData.graduationDate;
        }

        for (TempAccount.productDefinition objProdDef: objData.productcode1) {
            if (objProdDef.ProductCode == 'AFREE') {
                con.Membership_Type__c = 'Afiliate';

            } else if (objProdDef.ProductCode == 'MEMI' || objProdDef.ProductCode == 'MEMF') {
                con.Membership_Type__c = 'Individual';
                //if (objData.MailingCountry != 'Canada') {
                    //con.Email_Member_Update__c = true;
                //}

            } else if (objProdDef.ProductCode == 'MEMS') {
                con.Membership_Type__c = 'Student';
                //if (objData.MailingCountry != 'Canada') {
                    //con.Email_Member_Update__c = true;
                //}
            }

        }

        con.Email_Daily_News__c=true;
        con.Email_The_Week_in_Risk__c=true;
        con.Email_Chapter_Meetings__c=true;
        con.Email_Career_Center_Job_Board__c=true;
        con.Email_GARP_Updates__c=true;                         
        
        update con;
        
        return con;
    }

    public static Account updateAccountInfo(TempAccount objData, Id recordId) {
        Account acc = [select id, Billing_Address_Company__c, BillingCity, BillingCountry, BillingStreet, BillingPostalCode, BillingState, ShippingState, ShippingPostalCode, ShippingStreet, ShippingCity, ShippingCountry, Type from Account where id = : recordId];

        if (acc != null) {
            acc.BillingCity = objData.BillingCity;
            acc.BillingCountry = objData.BillingCountry;
            acc.Billing_Address_Company__c = objData.BillingCompany;
            acc.BillingStreet = objData.BillingStreet;

            if(objData.BillingStreetTwo != null && objData.BillingStreetTwo.length() > 0)
                acc.BillingStreet += '\n' + objData.BillingStreetTwo;
            if(objData.BillingStreetThree != null && objData.BillingStreetThree.length() > 0)
                acc.BillingStreet += '\n' + objData.BillingStreetThree;

            acc.BillingPostalCode = objData.BillingPostalCode;
            acc.BillingState = objData.BillingState;

            acc.ShippingCity = objData.MailingCity;
            acc.ShippingCountry = objData.MailingCountry;
            acc.ShippingStreet = objData.MailingStreet;
            
            if(objData.MailingStreetTwo != null && objData.MailingStreetTwo.length() > 0)
                acc.ShippingStreet += '\n' + objData.MailingStreetTwo;
            if(objData.MailingStreetThree != null && objData.MailingStreetThree.length() > 0)
                acc.ShippingStreet += '\n' + objData.MailingStreetThree;
            
            acc.ShippingPostalCode = objData.MailingPostalCode;
            acc.ShippingState = objData.MailingState;

            acc.Type = objData.Organization;
            acc.recordTypeId = RecordTypeHelper.GetRecordTypeId('Account', 'Individual');
            acc.ownerid = userid;
        }
        update acc;
        
        return acc;
    }

    public static void updateOpportunityinfo(TempAccount objData, Id recordId, boolean basicInfoOnly, boolean bCheckMemExtn, boolean bIsPortalUser) {
        opportunity opp = [select id, StageName, Shipping_First_Name__c, Shipping_Last_Name__c, Shipping_Phone_No__c, 
                           Shipping_E_mail__c, Shipping_Serive_Selected__c, Shipping_Company_Name__c, Shipping_Street__c, 
                           Shipping_Country__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State__c,
                           Switch_to_erp__c, Has_Books__c, Switch_to_frm__c, Eligible_for_Membership_Extension__c, Auto_Renew__c from opportunity where id = : recordId];

        opp.Shipping_First_Name__c = objData.FirstName;
        opp.Shipping_Last_Name__c = objData.LastName;
        opp.Shipping_Phone_No__c = objData.HomePhone;
        opp.Shipping_E_mail__c = objData.Email;
        
        if(objData.campaignId!=null)
            opp.CampaignId = objData.campaignId;        
        
        opp.Shipping_Company_Name__c = objData.MailingCompany;
        opp.Shipping_Street__c = objData.MailingStreet;
        opp.Shipping_City__c = objData.MailingCity;
        opp.Shipping_State__c = objData.MailingState;
        opp.Shipping_Country__c = objData.MailingCountry;
        opp.Shipping_Postal_Code__c = objData.MailingPostalCode;
        
        opp.ChargentSFA__Billing_Email__c = objData.Email;
        opp.ChargentSFA__Billing_First__c = objData.FirstName;
        opp.ChargentSFA__Billing_Last__c = objData.LastName;
        opp.ChargentSFA__Billing_Phone__c = objData.HomePhone;
        opp.ChargentSFA__Billing_Company__c = objData.BillingCompany;
        
        opp.ChargentSFA__Billing_Address__c = objData.BillingStreet;
        if(objData.BillingStreetTwo != null && objData.BillingStreetTwo.length() > 0)
            opp.ChargentSFA__Billing_Address__c += '\n' + objData.BillingStreetTwo;
        if(objData.BillingStreetThree != null && objData.BillingStreetThree.length() > 0)
            opp.ChargentSFA__Billing_Address__c += '\n' + objData.BillingStreetThree;
        
        opp.ChargentSFA__Billing_City__c = objData.BillingCity;
        opp.ChargentSFA__Billing_State__c = objData.BillingState;
        opp.ChargentSFA__Billing_Zip__c = objData.BillingPostalCode;
        opp.ChargentSFA__Billing_Country__c = objData.BillingCountry;
        
        opp.Alternate_Method_of_Payment__c = objData.paymentMethod;
            
        String strUPSDesc='';
        if (objData.ShippingOptionsString != '' && objData.ShippingOptionsString != null) {
            String[] arrShippingInfo = objData.ShippingOptionsString.split(',');
            if (arrShippingInfo != null && arrShippingInfo.size() > 0) {
                String[] arrPriceInfo = arrShippingInfo[0].split(':');
                String[] arrUPSDesc = arrShippingInfo[1].split(':');
                if(arrUPSDesc.size() > 1)
                    strUPSDesc = arrUPSDesc[1];
                //strUPSDesc = strUPSDesc.replace('"', '').replace('{', '').replace('}', '');
            }
        }
        
        opp.Shipping_Serive_Selected__c = strUPSDesc;
            
        opp.Switch_to_erp__c = returnBool(objData.erpSwitch);
        opp.Has_Books__c = returnBool(objData.hasBooks);
        
        for (TempAccount.productDefinition objProd: objData.productcode1) {
            if(opp.Has_Books__c == true) {
                if (objProd.ProductCode == 'FRM1E' || objProd.ProductCode == 'FRM1L' || objProd.ProductCode == 'FRM1S')
                    opp.Books_FRM_I__c=true;
                else if (objProd.ProductCode == 'FRM2E' || objProd.ProductCode == 'FRM2L' || objProd.ProductCode == 'FRM2S')
                    opp.Books_FRM_II__c=true;
                
                // ERP Split
                //else if (objProd.ProductCode == 'ENCE' || objProd.ProductCode == 'ENCL' || objProd.ProductCode == 'ENCS')
                //    opp.Books_ERP__c=true;
                if (objProd.ProductCode == 'ENC1E' || objProd.ProductCode == 'ENC1L' || objProd.ProductCode == 'ENC1S')
                    opp.Books_ERP_I__c=true;
                else if (objProd.ProductCode == 'ENC2E' || objProd.ProductCode == 'ENC2L' || objProd.ProductCode == 'ENC2S')
                    opp.Books_ERP_II__c=true;

                else if(objData.isFBRChecked)
                    opp.Books_FBR__c=true;
                else if (objData.isIcbrChecked)
                    opp.Books_ICBRR__c=true;
            }
        }
        
        if(basicInfoOnly == false) {
            opp.Switch_to_frm__c = returnBool(objData.frmSwitch);
            if (bIsPortalUser) {
                opp.Eligible_for_Membership_Extension__c = bCheckMemExtn;
            }
            else
                opp.Eligible_for_Membership_Extension__c = true;
            opp.Auto_Renew__c = returnBool(objData.autorenew);            
        }
        
        system.debug('* * * Update Opp:'+opp);

                
        update opp;
        
    }

    public static List < Exam__c > getExamDetails(List < String > lstExamNames) {
        List < Exam__c > lstExamDetails = [select id, Exam__c, Exam_Group__r.Early_Exam_Registration_Fee__c, Exam_Date__c, Exam_Group__r.Standard_Exam_Registration_Fee__c, Exam_Group__r.Late_Exam_Registration_Fee__c, Exam_Group__r.Last_Date_For_Early_Registration__c, Exam_Group__r.Last_Date_For_Standard_Registration__c, Exam_Group__r.Last_Date_For_Late_Registration__c from Exam__c where Exam__c in : lstExamNames and Exam_Group__r.Active__c = true];
        return lstExamDetails;

    }

    public static Map < String, decimal > getExamFee(List < Exam__c > lstExamDetails) {
        if (lstExamDetails == null) return null;
        Map < String, decimal > mapExamFees = new Map < String, decimal > ();
        Decimal dExamFee = 0;
        for (Exam__c objExam: lstExamDetails) {
            if (system.today() <= objExam.Exam_Group__r.Last_Date_For_Early_Registration__c)
                dExamFee = objExam.Exam_Group__r.Early_Exam_Registration_Fee__c;
            else if (system.today() <= objExam.Exam_Group__r.Last_Date_For_Standard_Registration__c)
                dExamFee = objExam.Exam_Group__r.Standard_Exam_Registration_Fee__c;
            else if (system.today() <= objExam.Exam_Group__r.Last_Date_For_Late_Registration__c)
                dExamFee = objExam.Exam_Group__r.Late_Exam_Registration_Fee__c;

            mapExamFees.put(objExam.Exam__c, dExamFee == null ? 0 : dExamFee);
        }
        return mapExamFees;
    }

    public static void createOppLineItems(Id oppId, TempAccount objData) {
        system.debug('productcode1 == ' + objData.productcode1);
        if (objData.productcode1 == null) return;
        Decimal dExamFee = 0;
        String strNameByProdcutCode = '';
        List < String > lstExamNames = new List < String > ();
        boolean bFrm1 = false;
        boolean bFrm2 = false;
        decimal dShipPrice = 0;
        String strUPSDesc = '';

        Set < String > setProdCodes = new Set < String > ();
        Set < String > setGlCodes = new Set < String > ();
        Map<String,String> mapPrice = new Map<String,String>();
        Map<String,String> mapDesc = new Map<String,String>();
        for (TempAccount.productDefinition objProdDef: objData.productcode1) {
            setProdCodes.add(objProdDef.ProductCode);
            setGlCodes.add(objProdDef.GLCode);
            mapPrice.put(objProdDef.ProductCode,objProdDef.price);
            mapDesc.put(objProdDef.ProductCode,objProdDef.description);
        }

        system.debug('setProdCodes == ' + setProdCodes);
        system.debug('setGlCodes == ' + setGlCodes);

        system.debug('objData.ShippingOptionsString == ' + objData.ShippingOptionsString);

        Map < String, decimal > mapExamFees = getExamFee(getExamDetails(lstExamNames));
        if (objData.ShippingOptionsString != '' && objData.ShippingOptionsString != null) {
            String[] arrShippingInfo = objData.ShippingOptionsString.split(',');
            if (arrShippingInfo != null && arrShippingInfo.size() > 0) {
                String[] arrPriceInfo = arrShippingInfo[0].split(':');
                dShipPrice = decimal.valueOf(arrPriceInfo[1]);
                String[] arrUPSDesc = arrShippingInfo[1].split(':');
                strUPSDesc = arrUPSDesc[1];
                strUPSDesc = strUPSDesc.replace('"', '').replace('{', '').replace('}', '');
            }
        }

        system.debug('dShipPrice == ' + dShipPrice);
        system.debug('strUPSDesc == ' + strUPSDesc);

        decimal dTaxPrice = 0;
        if (objData.taxPrice != null) {
            dTaxPrice = objData.taxPrice;
            setProdCodes.add('SLSTX');
        }

        if (dShipPrice != 0)
            setProdCodes.add('SHIP');

        List < OpportunityLineItem > lstOppLineItems = new List < OpportunityLineItem > ();
        for (PriceBookEntry PricebookEntryId: [select unitprice, productcode, product2.Gl_Code__c from PriceBookEntry where Pricebook2.IsActive = true and Pricebook2.IsActive = true and productcode in : setProdCodes and product2.Gl_Code__c in : setGlCodes and isActive = true]) {
            dExamFee = PricebookEntryId.unitprice;
            OpportunityLineItem oppLineItem = new OpportunityLineItem();
            oppLineItem.OpportunityId = oppId;
            oppLineItem.PricebookEntryId = PricebookEntryId.Id;
            oppLineItem.Quantity = 1;
            //Switch fees
            if (dExamFee == null)
                dExamFee = 0;
            if ((objData.erpSwitch != null && objData.erpSwitch) && pricebookEntryId.productcode.indexOf('ENC') >= 0)
            {

                dExamFee = Decimal.valueOf(((mapPrice != null && mapPrice.get(pricebookEntryId.productcode) != null) ? mapPrice.get(pricebookEntryId.productcode) : '0'));
            }
            if (objData.frmSwitch != null && objData.frmSwitch) {
                dExamFee = Decimal.valueOf(((mapPrice != null && mapPrice.get(pricebookEntryId.productcode) != null) ? mapPrice.get(pricebookEntryId.productcode) : '0'));
                /*
                if (bFrm1 && bFrm2 && pricebookEntryId.productcode.indexOf('FRM1') >= 0)
                    dExamFee = 0;
                else if (bFrm1 && !bfrm2 && pricebookEntryId.productcode.indexOf('FRM1') >= 0)
                    dExamFee = 0;
                else if (bFrm2 && !bfrm1 && pricebookEntryId.productcode.indexOf('FRM2') >= 0)
                    dExamFee = 0;*/

            }
            if (pricebookEntryId.productcode.indexOf('MISC') >= 0 || PricebookEntryId.productcode == 'CBRHB')
            {
                dExamFee = Decimal.valueOf(((mapPrice != null && mapPrice.get(pricebookEntryId.productcode) != null) ? mapPrice.get(pricebookEntryId.productcode) : '0'));
                String descString = mapDesc.get(pricebookEntryId.productcode);
                if(descString != null)
                    oppLineItem.Description = descString;
            }

            //Switch Fees End Here
            if (PricebookEntryId.productcode == 'SHIP') {
                dExamFee = dShipPrice.setScale(2);
                oppLineItem.Description = strUPSDesc;

            }
            if (PricebookEntryId.productcode == 'SLSTX') {
                dExamFee = dTaxPrice;
            }
            if (PricebookEntryId.productcode == 'MEMW') {
                oppLineItem.Quantity = 12;
            }
            
            system.debug('objData == ' + objData);
            system.debug('PricebookEntryId == ' + PricebookEntryId);
            if ((PricebookEntryId.productcode == 'FRM1' || PricebookEntryId.productcode == 'ENC') && (objData.returning != null && objData.returning == true)) {
                dExamFee = 150;

            }
            oppLineItem.UnitPrice = dExamFee;
            dTotalPrice += dExamFee;
            lstOppLineItems.add(oppLineItem);

        }

        insert lstOppLineItems;
    }

    public static void createExamAttempts(TempAccount objData, Id contID, Id accID, Id oppId, boolean bCreateContratcs) {
        Id membershipContract = null;
        Id contractID = checkContractExist(objData, accID);
        system.debug('contractID === ' + contractID);
        List < Candidate_Requirement__c > lstCandReqs;
        system.debug('createExamAttempts objData === ' + objData);
        updateOpportunityinfo(objData, oppId, false, contractID == null, (bCreateContratcs || objData.isFrmChecked == true || objData.isErpChecked == true));
        if ((contractID == null && bCreateContratcs) || objData.isIcbrChecked) {
            contractID = CreateContract(accID, objData, oppId, contID);
            lstCandReqs = createCandidateRequirements(contractID, objData);

        }
        if (lstCandReqs == null) {
            lstCandReqs = [select id, name from Candidate_Requirement__c where Candidate_Commitment__c = : contractID];
        }
        if (objData.isIcbrChecked) {
            createExamAttemptsForICBR(objData, contID, accID, oppId, lstCandReqs, contractID);
            return;
        }


        if (objData.siteName == null || objData.examName == null) return;

        //updateSelfRelations(lstCandReqs, objData);
        list < Exam_Sites__c > lstExamSites = new List < Exam_Sites__c > ();
        Set < String > setExamNames = new Set < String > ();

        system.debug('objData.productcode1 === ' + objData.productcode1);
        
        for (TempAccount.productDefinition objProd: objData.productcode1) {
            if (objProd.ProductCode == 'FRM1E' || objProd.ProductCode == 'FRM1L' || objProd.ProductCode == 'FRM1S')
                setExamNames.add('FRM Part 1');
            else if (objProd.ProductCode == 'FRM2E' || objProd.ProductCode == 'FRM2L' || objProd.ProductCode == 'FRM2S')
                setExamNames.add('FRM Part 2');
            //else if (objProd.ProductCode == 'ENCE' || objProd.ProductCode == 'ENCL' || objProd.ProductCode == 'ENCS')
            //    setExamNames.add('ERP');
            else if (objProd.ProductCode == 'ENC1E' || objProd.ProductCode == 'ENC1L' || objProd.ProductCode == 'ENC1S')
                setExamNames.add('ERP Exam Part I');
            else if (objProd.ProductCode == 'ENC2E' || objProd.ProductCode == 'ENC2L' || objProd.ProductCode == 'ENC2S')
                setExamNames.add('ERP Exam Part II');

        }

        system.debug('setExamNames=== ' + setExamNames);

        if(objData.isFrmChecked || objData.isErpChecked) {
            try {
                lstExamSites = [Select id, Name, Exam__r.Exam__c, Exam__r.Exam_Group__c from Exam_Sites__c where Site__r.Name = : objData.siteName and Exam__r.Exam__c in : setExamNames and Exam__r.Exam_Group__r.Active__c = true];
            } catch (exception ex) {
                lstExamSites = null;
            }
        }
        
        system.debug('lstExamSites=== ' + lstExamSites);
        
        ID eaID = registerExam(lstExamSites, contID, lstCandReqs, contractID, oppId);
        if(eaID != NULL) {
            Opportunity o = [select id, Deferred_Exam_Registration__c from opportunity where id = : oppId];
            o.Deferred_Exam_Registration__c = eaID;
            update o;
        }
    }

    public static void updateSelfRelations(List < Candidate_Requirement__c > lstCReq, TempAccount objData) {
        Map < String, Candidate_Requirement__c > mapNames = getCandidatesReqByName(lstCReq);
        if (mapNames == null || mapNames.size() <= 0) return;
        for (Candidate_Requirement__c obj: lstCReq) {
            if (obj.Name == 'Job Requirement' && objData.isFRMChecked)
                obj.Prerequisite__c = mapNames.get('Pass FRM2').Id;
            if (obj.Name == 'Job Requirement' && objData.isERPChecked)
                obj.Prerequisite__c = mapNames.get('Pass ERP').Id;
            else if (obj.Name == 'Pass FRM2')
                obj.Prerequisite__c = mapNames.get('Pass FRM1').Id;
            else if (obj.Name == 'Pass FRM2')
                obj.Prerequisite__c = mapNames.get('Pass FRM1').Id;

        }

        update lstCReq;
    }

    public static Map < String, Candidate_Requirement__c > getCandidatesReqByName(List < Candidate_Requirement__c > lstCReq) {
        if (lstCReq == null) return null;
        Map < String, Candidate_Requirement__c > mapNames = new Map < String, Candidate_Requirement__c > ();
        for (Candidate_Requirement__c obj: lstCReq) {
            mapNames.put(obj.Name, obj);
        }
        return mapNames;
    }

    public static ID CreateContract(ID accID, TempAccount objData, ID oppId, ID contID) {

        List < Contract > lstContract = new List < Contract > ();

        Contract objContract = new Contract();
        objContract.accountId = accID;
        objContract.Opportunity__c = oppId;
        objContract.StartDate = system.today();
        objContract.ContractTerm = 48;
        if (objData.isFrmChecked) {
            objContract.recordTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'FRM Program');
            lstContract.add(objContract);
        } else if (objData.isFBRChecked) {
            objContract.recordTypeID = RecordTypeHelper.GetRecordTypeId('Contract', 'FBR Program');
            objContract.ContractTerm = 6;
            lstContract.add(objContract);
        } else if (objData.isIcbrChecked) {
            objContract.recordTypeID = RecordTypeHelper.GetRecordTypeId('Contract', 'ICBRR Program');
            objContract.ContractTerm = 9;
            lstContract.add(objContract);
        } else if (objData.isErpChecked) {
            objContract.recordTypeID = RecordTypeHelper.GetRecordTypeId('Contract', 'ERP Program');
            lstContract.add(objContract);
        } else if (objData.isErpChecked) {
            objContract.recordTypeID = RecordTypeHelper.GetRecordTypeId('Contract', 'ERP Program');
            lstContract.add(objContract);
        }

        //if (objData.Wiley == 'true') {
        //    system.debug('&&&&&&&1:' + objData.Wiley);
        //    Contract objWContract = new Contract();
        //    objWContract.Name = 'JWiley';
        //    //objWContract.CustomerSigned = contID;
        //    objWContract.accountId = accID;
        //    objWContract.Opportunity__c = oppId;
        //    objWContract.StartDate = system.today();
        //    objWContract.ContractTerm = 12;
        //    objWContract.recordTypeID = RecordTypeHelper.GetRecordTypeId('Contract', 'Wiley Bookstore');
        //    lstContract.add(objContract);
        //}
        if (lstContract.size() > 0) {
            insert lstContract;
            return lstContract[0].Id;
        } else {
            return null;
        }

    }

    public static ID CreateMemberShipContract(TempAccount objData, ID accID, ID oppId, ID contactId, Boolean doWiley) {
        Id memberRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract', 'Membership');
        Contract objContract = null;

        try {
            objContract = new Contract();
            objContract.Name = 'Membership';
            objContract.accountId = accID;
            objContract.CustomerSignedId = contactId;
            objContract.Opportunity__c = oppId;
            objContract.StartDate = system.today();
            // Set to 1 so trigger knows this is the first time!!
            // Trigger will set it to 12
            objContract.ContractTerm = 12;
            objContract.recordTypeID = RecordTypeHelper.GetRecordTypeId('Contract', 'Membership');
            for (TempAccount.productDefinition objProdDef: objData.productcode1) {
                
                if (objProdDef.ProductCode == 'AFREE')
                    objContract.Membership_Type__c = 'Affiliate';
                else if (objProdDef.ProductCode == 'MEMI' || objProdDef.ProductCode == 'MEMF')
                    objContract.Membership_Type__c = 'Individual';
                else if (objProdDef.ProductCode == 'MEMS')
                    objContract.Membership_Type__c = 'Student';

            }

            //if (objData.Wiley == 'true' && doWiley == true) {
            //    system.debug('&&&&&&&2:' + objData.Wiley);
            //    Contract objWContract = new Contract();
            //    objWContract.accountId = accID;
            //    objWContract.Opportunity__c = oppId;
            //    objWContract.StartDate = system.today();
            //    objWContract.ContractTerm = 12;
            //    objWContract.recordTypeID = RecordTypeHelper.GetRecordTypeId('Contract', 'Wiley Bookstore');
            //    insert objWContract;
            //}
            if(objContract.Membership_Type__c == null) return null;
            insert objContract;
            return objContract.Id;

        } catch (exception ex) {
            return null;
        }
    }

    public static List < Candidate_Requirement__c > createCandidateRequirements(Id contractID, TempAccount objData) {
        id oppID = [SELECT Opportunity__c FROM contract WHERE id = : contractID LIMIT 1].Opportunity__c;
        
        //string email = [SELECT Shipping_E_mail__c FROM opportunity WHERE id = : oppID LIMIT 1].Shipping_E_mail__c;
        String email = objData.Email;
        
        List < Candidate_Requirement__c > lstCandReq = new List < Candidate_Requirement__c > ();
        Candidate_Requirement__c objCandReq;
        
        // ERP Split
        Integer iCount = (objData.isFrmChecked ? 3 : (objData.isERPChecked ? 3 : (objData.isFBRChecked || objData.isIcbrChecked) ? 1 : 0));
        
        system.debug('iCount:' + iCount);
        
        Id examRecType = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Exam');
        Id jobExpRecType = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Job Experience');
        
        Candidate_Requirement__c crJob=null;
        Candidate_Requirement__c crE1=null;
        Candidate_Requirement__c crE2=null;
        
        for (Integer i = 0; i < iCount; i++) {
            objCandReq = new Candidate_Requirement__c();
            objCandReq.Candidate_Commitment__c = contractID;
            objCandReq.Candidate_Email__c = email;
            if (i == 0) {
                if (objData.isFBRChecked) {
                    objCandReq.Name = 'Pass FBR';
                    objCandReq.Exam__c = 'FBR';
                    objCandReq.Status__c = 'Initial';
                } else if (objData.isIcbrChecked) {
                    objCandReq.Name = 'Pass ICBRR';
                    objCandReq.Exam__c = 'ICBRR';
                    objCandReq.Status__c = 'Initial';
                } else {
                    objCandReq.Name = 'Job Requirement';
                    objCandReq.Status__c = 'Initial';
                    objCandReq.recordTypeID = jobExpRecType;
                    objCandReq.Email_GARP_Member__c = objData.Email;
                    crJob = objCandReq;
                }
            } else if (i == 1) {
                if (objData.isERPChecked) {
                    objCandReq.Name = 'Pass ERP1';
                    objCandReq.Exam__c = 'ERP Part I';
                    objCandReq.Status__c = 'Initial';
                    objCandReq.recordTypeID = examRecType;
                    crE1 = objCandReq;
                } else {
                    objCandReq.Name = 'Pass FRM1';
                    objCandReq.Exam__c = 'FRM Part I';
                    objCandReq.Status__c = 'Initial';
                    objCandReq.recordTypeID = examRecType;
                    crE1 = objCandReq;
                }
            } else {
                if (objData.isERPChecked) {
                    objCandReq.Name = 'Pass ERP2';
                    objCandReq.Exam__c = 'ERP Part II';
                    objCandReq.Status__c = 'Initial';
                    objCandReq.recordTypeID = examRecType;
                    crE2 = objCandReq;
                } else {
                    objCandReq.Name = 'Pass FRM2';
                    objCandReq.Exam__c = 'FRM Part II';
                    objCandReq.Status__c = 'Initial';
                    objCandReq.recordTypeID = examRecType;                    
                    crE2 = objCandReq;
                }
            }
            lstCandReq.add(objCandReq);
        }
        if (lstCandReq.size() > 0) {
            if(crE2!=null && crE1!=null) 
                crE2.Prerequisite__c = crE1.Id;
            if(crE2!=null && crJob!=null)
                crJob.Prerequisite__c = crE2.Id;
            insert lstCandReq;
        }
            
        
        return lstCandReq;
    }

    public static ID registerExam(List < Exam_Sites__c > lstExamSites, Id contID, List < Candidate_Requirement__c > lstCandReqs, id ContractID, Id oppId) {
        Exam_Attempt__c objAttempt = null;
        Map < String, Id > mapCandIds = new Map < String, Id > ();
        for (Candidate_Requirement__c obj: lstCandReqs) {
            string strName = '';
            if (obj.Name.contains('FRM1'))
                strName = 'FRM Part 1';
            else if (obj.Name.contains('FRM2'))
                strName = 'FRM Part 2';
           /* else if (obj.Name.contains('ERP'))
                strName = 'ERP';*/
            else if (obj.Name == 'Pass ERP1')
                strName = 'ERP Exam Part I';
            else if (obj.Name == 'Pass ERP2')
                strName = 'ERP Exam Part II';
            mapCandIds.put(strName, obj.Id);
        }
        List < Exam_Attempt__c > lstExamApptempts = new List < Exam_Attempt__c > ();
        Exam_Attempt__c objSwapEAFRM1=null;
        Exam_Attempt__c objSwapEAFRM2=null;
        
        // ERP Split
        Exam_Attempt__c objSwapEAERP1=null;
        Exam_Attempt__c objSwapEAERP2=null;
        
        ID examGroup;
        
        for (Exam_Sites__c objExamSite: lstExamSites) {
            objAttempt = new Exam_Attempt__c();
            objAttempt.Exam_Site__c = objExamSite.Id;
            objAttempt.Member__c = contID;
            String strExamName = '';
            objAttempt.Candidate_Commitment__c = ContractID;
            objAttempt.Opportunity__c = oppId;
            objAttempt.Candidate_Requirement__c = mapCandIds.get(objExamSite.Exam__r.Exam__c);
            lstExamApptempts.add(objAttempt);
            if(objExamSite.Exam__r.Exam_Group__c != null)
                examGroup = objExamSite.Exam__r.Exam_Group__c;
        }
        if (lstExamApptempts.size() > 0) {
            insert lstExamApptempts;
        }
        lstExamApptempts = [select Id, Name, Exam_Site__r.Exam__r.Exam__c from Exam_Attempt__c where Member__c = :contID and Candidate_Commitment__c = :ContractID and Exam_Site__r.Exam__r.Exam_Group__c = :examGroup];
        
        system.debug('* * * lstExamApptempts ...'+ lstExamApptempts);
        
        for (Exam_Attempt__c ea: lstExamApptempts) {
            if(ea.Exam_Site__r.Exam__r.Exam__c == 'FRM Part 1') {
                objSwapEAFRM1 = ea;
            }
            if(ea.Exam_Site__r.Exam__r.Exam__c == 'FRM Part 2') {
                objSwapEAFRM2 = ea;
            }            
            if(ea.Exam_Site__r.Exam__r.Exam__c == 'ERP Exam Part I') {
                objSwapEAERP1 = ea;
            }
            if(ea.Exam_Site__r.Exam__r.Exam__c == 'ERP Exam Part II') {
                objSwapEAERP2 = ea;
            }
        }
        
        system.debug('* * * objSwapEAFRM1 ...'+ objSwapEAFRM1 + ':' + objSwapEAFRM2 + ':' + objSwapEAERP1 + ':' + objSwapEAERP2);
        
        if(objSwapEAFRM1!=null && objSwapEAFRM2!=null) {
            objSwapEAFRM1.Other_Exam_Registrations__c = objSwapEAFRM2.Id;
            objSwapEAFRM2.Other_Exam_Registrations__c = objSwapEAFRM1.Id;
            update lstExamApptempts;
        }

        if(objSwapEAERP1!=null && objSwapEAERP2!=null) {
            objSwapEAERP1.Other_Exam_Registrations__c = objSwapEAERP2.Id;
            objSwapEAERP2.Other_Exam_Registrations__c = objSwapEAERP1.Id;
            update lstExamApptempts;
        }

        if(lstExamApptempts != null && lstExamApptempts.size() > 0)
            return lstExamApptempts[0].Id;
        else return null;
    }

    public static Opportunity createOpportunity(Contact objContact) {
        Opportunity opp = new Opportunity();
        try {
            opp.Name = 'Exam Registration';
            opp.Accountid = objContact.AccountId;
            opp.StageName = 'New Lead';
            opp.CloseDate = system.today();
            opp.Program__c = 'FRM';
            Id recordTypeID = RecordTypeHelper.GetRecordTypeId('Opportunity', 'Automated');
            opp.RecordTypeId = recordTypeID;
            insert opp;
            
            OpportunityContactRole contactRole = new OpportunityContactRole(OpportunityId=opp.id, ContactId=objContact.Id, Role='Decision Maker');
            insert contactRole;
            
            return opp;
        } catch (exception ex) {
            return null;
        }
    }



    public static Map < String, wrapperProductInfo > getProductCodes() {
        Id currentUSer = userInfo.getuserId();
        Id frmRecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'FRM Program');
        Id erpRecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'ERP Program');
        User objUSer = [select id, Email, contactId from user where id = : currentUSer];
        List < Exam_Attempt__c > lstExamAttempts = [select id, Defered__c, Member__c, Exam_Date__c, Exam_Site__c, Exam_Site__r.site__c, Section__c, Result__c, Candidate_Commitment__c, Candidate_Commitment__r.Status, Exam_Site__r.Exam__r.Exam_Group__r.Active__c from Exam_Attempt__c where(Candidate_Commitment__r.Status like '%Activated%'
            or Candidate_Commitment__r.Status = : 'Completed') and Member__c = : objUser.contactId and Cancelled__c != true order by Exam_Date__c DESC];

        Contact contactRecord = [select id, KPI_ERP_Enrollment_Date__c,accountID, KPI_FRM_Enrollment_Date__c from contact where id = : objUser.contactId];
        
        for(Contract obj : [select id, recordtypeID,StartDate,Enrollment_paid_for_2009__c from Contract where accountID =: contactRecord.accountID and Status like '%Activated%'])
        {

            if(obj.recordtypeID == frmRecordTypeId)
            {
                bHasFrmEnrollment = true;
                if(obj.StartDate.Year() == 2009 && !obj.Enrollment_paid_for_2009__c)
                    bFRMPaidFor2009 = true;

            }
            else if(obj.recordtypeID == erpRecordTypeId)
            {
                bHasERPEnrollment = true;
                if(obj.StartDate.Year() == 2009 && !obj.Enrollment_paid_for_2009__c)
                    bERPPaidFor2009 = true;

            }
                
        }
        system.debug('bHasFrmEnrollment == '+bHasFrmEnrollment);
        system.debug('bHasERPEnrollment == '+bHasERPEnrollment);

        List < String > lstExamNames = new List < String > ();
        lstExamNames.add('FRM Part 1');
        lstExamNames.add('FRM Part 2');
        lstExamNames.add('ERP Exam Part I');
        lstExamNames.add('ERP Exam Part II');
        Map < String, wrapperProductInfo > mapExamFees = null;
        if (lstExamAttempts != null && lstExamAttempts.size() > 0) {
            mapExamFees = getProductCodesBasedOnFilters1(lstExamAttempts, objUSer);
            mapExamFees = getMiscellaneousProdCodes(mapExamFees);
        } else {
            mapExamFees = getExamFee1(getExamDetails(lstExamNames));
            mapExamFees = getMiscellaneousProdCodes(mapExamFees);
        }
        system.debug('mapExamFees :'+mapExamFees);
        return mapExamFees;
    }



    public static Map < String, wrapperProductInfo > getProductCodesBasedOnFilters1(List < Exam_Attempt__c > lstExamAttempts, User objUSer) {
        system.debug('In getProductCodesBasedOnFilters1 lstExamAttempts == ' + lstExamAttempts);
        Set < String > setExamToRegister = new Set < String > ();
        boolean bInvokeFrms = false;
        boolean bInvokeErps = false;
        boolean bIsErpDeferred = false;

        for (Exam_Attempt__c objEA: lstExamAttempts) {
            if (!objEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c) continue;
            //Check if registered for ERP then we should not show any exams. If erp is failed then show only ERP to the end user for registration
            if (objEA.Section__c.indexOf('ERP') >= 0) {
                bInvokeErps = true;
               // if (objEA.Defered__c == 'Pending')
                   // bIsErpDeferred = true;
            } else if (objEA.Section__c.indexOf('FRM') >= 0) bInvokeFrms = true;
        }
        system.debug('bIsErpDeferred == '+bIsErpDeferred);
        system.debug('bInvokeFrms == '+bInvokeFrms);
       // if (bIsErpDeferred)
          //  setExamToRegister = getFRMExams(objUSer);
        if (bInvokeFrms)
            setExamToRegister = getFRMExams(objUSer);
        else if (bInvokeErps)
            setExamToRegister = getERPExams(objUSer);
        else if (!bInvokeFrms && !bInvokeErps) {
            Set < String > setFrms = getFRMExams(objUSer);
            Set < String > setErps = getERPExams(objUSer);
            if (setFrms != null) setExamToRegister.addAll(setFrms);
            if (setErps != null) setExamToRegister.addAll(setErps);

        }
        system.debug('&&&&&&&:'+setExamToRegister);
        if (setExamToRegister == null || setExamToRegister.size() <= 0) return null;
              system.debug('&&&&&&&:'+setExamToRegister);
        Map < String, wrapperProductInfo > mapExamFes = getExamFee1(getExamDetails(new List < String > (setExamToRegister)));
        return mapExamFes;
    }

    public static Set < String > getFRMExams(User objUser) {
        Set < String > setExamToRegister = new Set < String > ();
        boolean bhasRecords = false;
        boolean bhasFrm12 = false;
        Integer iDefferedCount = 0;
        Integer iActiveEA = 0;
        Date dtExamDate = null;
        boolean bFrm1 = false;
        boolean bFrm2 = false;
        boolean bPassFrm1 = false;
        Id frmRecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'FRM Program');
        for (Exam_Attempt__c objFRMEA: [select id, Defered__c, Opportunity_StageName__c, Member__c, Exam_Date__c, Exam_Site__c, Exam_Site__r.Exam__r.Exam_Group__r.Active__c, Exam_Site__r.site__c, Section__c, Result__c, Candidate_Commitment__c, Candidate_Commitment__r.Status from Exam_Attempt__c where(Candidate_Commitment__r.Status like '%Activated%'
                or Candidate_Commitment__r.Status = : 'Completed') and Member__c = : objUser.contactId and Opportunity_StageName__c ='closed' and Candidate_Commitment__r.recordTypeID = : frmRecordTypeId and Cancelled__c != true order by Exam_Date__c DESC]) {

            system.debug('objFRMEA == '+objFRMEA);
            system.debug('Active == '+objFRMEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c);
            if (objFRMEA.Candidate_Commitment__r.Status == 'Completed') return null;
            bhasRecords = true;
            if (dtExamDate == null) dtExamDate = objFRMEA.Exam_Date__c;
            if (objFRMEA.Defered__c == 'Pending')
                iDefferedCount += 1;
            if (objFRMEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c)
                iActiveEA += 1;

        //&& objFRMEA.Defered__c == null
           if (objFRMEA.Section__c.indexOf('FRM Part 2') >= 0 && (objFRMEA.Result__c == 'pass' || objFRMEA.Result__c == null|| objFRMEA.Result__c == '')) {
               
               
                if (objFRMEA.Result__c == null && !objFRMEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c) {
                    setExamToRegister.clear();}
                    system.debug('&&&&&&:'+bhasFrm12);
                bhasFrm12 = true;
                bFrm2 = true;
                break;
            
            } 
            
            else if (objFRMEA.Section__c.indexOf('FRM Full Program') >= 0 && !bFrm1 && !bFrm2) {
                bFRMActivatedXX = true;
                if (objFRMEA.Result__c == 'Pass') {
                     bhasFrm12 = true;
                     break;
                } else if ((objFRMEA.Result__c != null) && objFRMEA.Result__c != 'Pass' || objFRMEA.Result__c == 'No-Show') {
                    setExamToRegister.clear();
                    setExamToRegister.add('FRM Part 1');
                    setExamToRegister.add('FRM Part 2');
                    }
            }
            
            
            else if (objFRMEA.Section__c.indexOf('FRM Part 1') >= 0) {
                bFRMActivatedXX = true;
                bFrm1 = true;
                 
                if (objFRMEA.Result__c == null && !objFRMEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c) {
                  break;
                   // setExamToRegister.clear();
                } else if ((objFRMEA.Result__c != null) && objFRMEA.Result__c != 'Pass' || objFRMEA.Result__c == 'No-Show') {
                    setExamToRegister.clear();
                    if(bPassFrm1==false)
                        setExamToRegister.add('FRM Part 1');
                    setExamToRegister.add('FRM Part 2');
                } else if (objFRMEA.Result__c == 'Pass' || objFRMEA.Result__c == null) {
                  
                  bPassFrm1=true ;              
                    setExamToRegister.clear();  
                    setExamToRegister.add('FRM Part 2');
                }
            }

        }

        system.debug('iDefferedCount == '+iDefferedCount);
        system.debug('iActiveEA == '+iActiveEA);
        if (iDefferedCount == iActiveEA && iDefferedCount > 0)
            setExamToRegister = getERPExams(objUser);
      system.debug('*********:'+bhasFrm12);
        if (bhasFrm12 && (iDefferedCount != iActiveEA) ) return null;
        else if (!bhasRecords) {
            setExamToRegister.add('FRM Part 1');
            setExamToRegister.add('FRM Part 2');
        }

        system.debug('setExamToRegister == '+setExamToRegister);
        return setExamToRegister;
    }

    public static Set < String > getERPExams(User objUser) {
        Set < String > setExamToRegister = new Set < String > ();
        boolean bhasRecords = false;
        boolean bhasErp12 = false;
        Integer iDefferedCount = 0;
        Integer iActiveEA = 0;
        Date dtExamDate = null;
        boolean bErp1 = false;
        boolean bErp2 = false;
        boolean bPassErp1 = false;
        Id erpRecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'ERP Program');
        for (Exam_Attempt__c objERPEA: [select id, Defered__c, Member__c, Opportunity_StageName__c,Exam_Date__c, Exam_Site__r.Exam__r.Exam_Group__r.Active__c, Exam_Site__c, Exam_Site__r.site__c, Section__c, Result__c, Candidate_Commitment__c, Candidate_Commitment__r.Status from Exam_Attempt__c where(Candidate_Commitment__r.Status like '%Activated%'
                or Candidate_Commitment__r.Status = : 'Completed') and Member__c = : objUser.contactId and Candidate_Commitment__r.recordTypeID = : erpRecordTypeId and Opportunity_StageName__c ='closed' and  Cancelled__c != true order by Exam_Date__c DESC]) {
            
            system.debug('objERPEA == '+objERPEA);
            system.debug('Active == '+objERPEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c);

            if (objERPEA.Candidate_Commitment__r.Status == 'Completed') return null;
            bhasRecords = true;
            if (dtExamDate == null) dtExamDate = objERPEA.Exam_Date__c;

            if (objERPEA.Defered__c == 'Pending')
                iDefferedCount += 1;
            if (objERPEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c)
                iActiveEA += 1;
           //&& objERPEA.Defered__c == null
            if (objERPEA.Section__c.indexOf('ERP Exam Part II') >= 0  && (objERPEA.Result__c == 'pass' || objERPEA.Result__c == null|| objERPEA.Result__c == '')) {
               system.debug('&&&&&&:'+bhasErp12);
                bhasErp12 = true;
                bErp2 = true;
                break;
            
            } 

             else if (objERPEA.Section__c == 'ERP' && !bErp1 && !bErp2) {
                 
                if (objERPEA.Result__c == 'Pass' || objERPEA.Result__c == ''|| objERPEA.Result__c == null) {
                    
                     bhasErp12 = true;
                     break;
                } else if ((objERPEA.Result__c != null) && objERPEA.Result__c != 'Pass' || objERPEA.Result__c == 'No-Show') {
                    setExamToRegister.clear();
                    setExamToRegister.add('ERP Exam Part I');
                    setExamToRegister.add('ERP Exam Part II');
                    }
            }

               else if (objERPEA.Section__c.indexOf('ERP Exam Part I') >= 0) {
                bErp1 = true;
                if (objERPEA.Result__c == null && !objERPEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c) {
                    setExamToRegister.clear();
                } else if ((objERPEA.Result__c != null) && objERPEA.Result__c != 'Pass' || objERPEA.Result__c == 'No-Show') {
                    setExamToRegister.clear();
                    if(bPassErp1==false)
                        setExamToRegister.add('ERP Exam Part I');
                    setExamToRegister.add('ERP Exam Part II');
                } else if (objERPEA.Result__c == 'Pass' || objERPEA.Result__c == null) {
                  
                  bPassErp1=true ;              
                    setExamToRegister.clear();  
                    setExamToRegister.add('ERP Exam Part II');
                }

            }

        }
          system.debug('iDefferedCount == '+iDefferedCount);
        system.debug('iActiveEA == '+iActiveEA);
        if (iDefferedCount == iActiveEA && iDefferedCount > 0)
            setExamToRegister = getFRMExams(objUser);
        system.debug('@@@@@@:'+bhasErp12);
        if (bhasErp12 &&(iDefferedCount != iActiveEA)) return null;  
        else if (!bhasRecords) {
            setExamToRegister.add('ERP Exam Part I');
            setExamToRegister.add('ERP Exam Part II');
        }

        system.debug('setExamToRegister == '+setExamToRegister);
        return setExamToRegister;
    }

    public static Id checkContractExist(TempAccount objData, Id accounID) {
        ID recTypeID = null;
        for (TempAccount.productDefinition objProd: objData.productcode1) {
            if (objProd.ProductCode == 'FRM1E' || objProd.ProductCode == 'FRM1L' || objProd.ProductCode == 'FRM1S' || objProd.ProductCode == 'FRM2E' || objProd.ProductCode == 'FRM2L' || objProd.ProductCode == 'FRM2S')
                recTypeID = RecordTypeHelper.GetRecordTypeId('Contract', 'FRM Program');
            // ERP Split
            //else if (objProd.ProductCode == 'ENCE' || objProd.ProductCode == 'ENCL' || objProd.ProductCode == 'ENCS')
            //    recTypeID = RecordTypeHelper.GetRecordTypeId('Contract', 'ERP Program');
            else if (objProd.ProductCode == 'ENC1E' || objProd.ProductCode == 'ENC1L' || objProd.ProductCode == 'ENC1S' || objProd.ProductCode == 'ENC2E' || objProd.ProductCode == 'ENC2L' || objProd.ProductCode == 'ENC2S')
                recTypeID = RecordTypeHelper.GetRecordTypeId('Contract', 'ERP Program');
        }
        try {
            Contract obj = [select id, recordtypeID from Contract where recordTypeID = : recTypeID and accountID = : accounID and Status like '%Activated%'
                limit 1
            ];
            return obj.Id;
        } catch (exception ex) {
            return null;
        }
    }

    public static void createExamAttemptsForICBR(TempAccount objData, Id contID, Id accID, Id oppId, List < Candidate_Requirement__c > lstCandReqs, Id contractID) {
        Map < String, Id > mapCandIds = new Map < String, Id > ();
        system.debug('lstCandReqs == ' + lstCandReqs);
        for (Candidate_Requirement__c obj: lstCandReqs) {
            mapCandIds.put(obj.Name, obj.Id);
        }
        system.debug('mapCandIds == ' + mapCandIds);
        Exam_Attempt__c objAttempt = new Exam_Attempt__c();
        objAttempt.Member__c = contID;
        String strExamName = 'Pass ICBR';
        objAttempt.Candidate_Commitment__c = contractID;
        objAttempt.Opportunity__c = oppId;
        objAttempt.Candidate_Requirement__c = mapCandIds.get('Pass ICBR');
        updateids__c recIds = updateids__c.getInstance('ICBRR');
        objAttempt.Exam_Site__c = recIds.Record_id__c;//'a0Cf0000004O778';
        insert objAttempt;
    }

    public static decimal getProdPrice(String strKey, Map < String, Product2 > mapMayProductDetails, Map < Id, PriceBookEntry > mapPriceBookDetails) {
        system.debug('mapMayProductDetails == ' + mapMayProductDetails);
        system.debug('mapPriceBookDetails == ' + mapPriceBookDetails);
        system.debug('strKey == ' + strKey);
        if(mapMayProductDetails.get(strKey) != null){
            Id prodID = mapMayProductDetails.get(strKey).id;
            Decimal dPrice = mapPriceBookDetails.get(prodID).unitprice;
            system.debug('dPrice == ' + dPrice);
        return dPrice;
        }
        return null;
    }


    public static Map < String, wrapperProductInfo > getMiscellaneousProdCodes(Map < String, wrapperProductInfo > returnMap) {
        Set < String > setProdCodes = new set < String > ();
        setProdCodes.add('SLSTX');
        setProdCodes.add('SHIP');
        setProdCodes.add('PRFEE');
        setProdCodes.add('MISC');
        setProdCodes.add('AFREE');
        setProdCodes.add('MEMF');
        setProdCodes.add('MEMI');
        wrapperProductInfo objWrapper;
        if (returnMap == null) returnMap = new Map < String, wrapperProductInfo > ();
        for (PriceBookEntry PricebookEntryId: [select unitprice, productcode, product2Id, product2.Gl_code__c from PriceBookEntry where Pricebook2.IsActive = true and Pricebook2.IsActive = true and productcode in : setProdCodes and isActive = true]) {
            if (PricebookEntryId.productcode.indexOf('SLSTX') >= 0) {
                objWrapper = new wrapperProductInfo();
                objWrapper.dMemberAmt = 0;
                objWrapper.strTaxGLCode = PricebookEntryId.product2.Gl_code__c;
                objWrapper.strTaxProdCode = PricebookEntryId.productcode;
                returnMap.put('TAX', objWrapper);

            } else if (PricebookEntryId.productcode.indexOf('SHIP') >= 0) {
                objWrapper = new wrapperProductInfo();
                objWrapper.dMemberAmt = 0;
                objWrapper.strShippingGLCode = PricebookEntryId.product2.Gl_code__c;
                objWrapper.strShippingProdCode = PricebookEntryId.productcode;
                returnMap.put('Shipping', objWrapper);

            } else if (PricebookEntryId.productcode.indexOf('PRFEE') >= 0) {
                objWrapper = new wrapperProductInfo();
                objWrapper.dMemberAmt = PricebookEntryId.unitprice;
                objWrapper.strDeferredPaymentGLCode = PricebookEntryId.product2.Gl_code__c;
                objWrapper.strDeferrePaymentProdCode = PricebookEntryId.productcode;
                returnMap.put('DeferredPayment', objWrapper);

            } else if (PricebookEntryId.productcode.indexOf('MISC') >= 0) {
                objWrapper = new wrapperProductInfo();
                objWrapper.dMemberAmt = PricebookEntryId.unitprice;
                objWrapper.strCanadianTaxGLCode = PricebookEntryId.product2.Gl_code__c;
                objWrapper.strCanadianTaxProdCode = PricebookEntryId.productcode;
                returnMap.put('CanadianTax', objWrapper);

            } else if (PricebookEntryId.productcode.indexOf('AFREE') >= 0) {
                objWrapper = new wrapperProductInfo();
                objWrapper.dMemberAmt = PricebookEntryId.unitprice;
                objWrapper.strAffiliateGLCode = PricebookEntryId.product2.Gl_code__c;
                objWrapper.strAffiliateProdCode = PricebookEntryId.productcode;
                returnMap.put('Affiliate', objWrapper);

            } else if (PricebookEntryId.productcode.indexOf('MEMF') >= 0) {
                objWrapper = new wrapperProductInfo();
                objWrapper.dMemberAmt = PricebookEntryId.unitprice;
                objWrapper.strFreeIndividualGLCode = PricebookEntryId.product2.Gl_code__c;
                objWrapper.strFreeIndividualProdCode = PricebookEntryId.productcode;
                returnMap.put('FreeMembership', objWrapper);
            } else if (PricebookEntryId.productcode.indexOf('MEMI') >= 0) {
                objWrapper = new wrapperProductInfo();
                objWrapper.dMemberAmt = PricebookEntryId.unitprice;
                objWrapper.strMemberGLCode = PricebookEntryId.product2.Gl_code__c;
                objWrapper.strMemberProdCode = PricebookEntryId.productcode;
                returnMap.put('MEMI', objWrapper);
            }


        }
        system.debug('mapWrapper 1== ' + returnMap);
        return returnMap;
    }


    public static Map < String, wrapperProductInfo > getFBRICBRProductCodes(string strProdType) {
        Set < String > setProdCodes = new set < String > ();
        if (strProdType == 'FBR') {
            setProdCodes.add('FBRNM');
            setProdCodes.add('FCBR');
            setProdCodes.add('MEMI');
        } else if (strProdType == 'ICBRR') {
            setProdCodes.add('CBRNM');
            setProdCodes.add('CBR');
            setProdCodes.add('MEMI');
        } else if (strProdType == 'WILEY')
            setProdCodes.add('MEMW');
        else if (strProdType == 'INDIVIDUAL') {
            setProdCodes.add('MEMI');
            setProdCodes.add('MEMW');
        } else if (strProdType == 'STUDENT') {
            setProdCodes.add('MEMS');
            setProdCodes.add('MEMW');
        }

        Map < String, wrapperProductInfo > mapWrapper = new Map < String, wrapperProductInfo > ();
        wrapperProductInfo objWrapper;
        for (PriceBookEntry objPriceBook: [select unitprice, productcode, product2Id, product2.Gl_code__c from PriceBookEntry where Pricebook2.IsActive = true and Pricebook2.IsActive = true and productcode in : setProdCodes and isActive = true]) {
            system.debug('objPriceBook == ' + objPriceBook);

                
            if (objPriceBook.productcode.indexOf('FCBR') >= 0) {
                objWrapper = mapWrapper.get('FBR');
                if(objWrapper == null)
                    objWrapper = new wrapperProductInfo();
                
                objWrapper.dFCBRMemberExamAmt = objPriceBook.unitprice;
                objWrapper.strFCBRMemberGlCode = objPriceBook.product2.Gl_code__c;
                objWrapper.strFCBRMemberProdCode = objPriceBook.productcode;
                mapWrapper.put('FBR', objWrapper);   
                
            } else if (objPriceBook.productcode.indexOf('FBRNM') >= 0) {
                objWrapper = mapWrapper.get('FBR');
                if(objWrapper == null)
                    objWrapper = new wrapperProductInfo();

                objWrapper.dFCBRNonMemberExamAmt = objPriceBook.unitprice;
                objWrapper.strFCBRNonMemberGlCode = objPriceBook.product2.Gl_code__c;
                objWrapper.strFCBRNonMemberProdCode = objPriceBook.productcode;
                mapWrapper.put('FBR', objWrapper);                

            } else if (objPriceBook.productcode == 'CBR') {
                
                system.debug('IN CBR');
                
                objWrapper = mapWrapper.get('ICBRR');
                system.debug('GET ICBRR: ' + objWrapper);
                
                if(objWrapper == null) {
                    system.debug('New objWrapper');
                    objWrapper = new wrapperProductInfo();
                }
                    
                objWrapper.dCBRMemberExamAmt = objPriceBook.unitprice;
                objWrapper.strCBRMemberGlCode = objPriceBook.product2.Gl_code__c;
                objWrapper.strCBRMemberProdCode = objPriceBook.productcode;
                system.debug('Add objWrapper:' + objWrapper);
                
                mapWrapper.put('ICBRR', objWrapper);   
                system.debug('Put mapWrapper:' + mapWrapper);
                
            } else if (objPriceBook.productcode == 'CBRNM') {
                system.debug('IN CBRNM');
                
                objWrapper = mapWrapper.get('ICBRR');
                system.debug('GET ICBRR: ' + objWrapper);
                
                if(objWrapper == null) {
                    system.debug('New objWrapper');
                    objWrapper = new wrapperProductInfo();
                }
                    

                objWrapper.dCBRNonMemberExamAmt = objPriceBook.unitprice;
                objWrapper.strCBRNonMemberGlCode = objPriceBook.product2.Gl_code__c;
                objWrapper.strCBRNonMemberProdCode = objPriceBook.productcode;
                system.debug('Add objWrapper:' + objWrapper);
                
                mapWrapper.put('ICBRR', objWrapper);           
                system.debug('Put mapWrapper:' + mapWrapper);

            } else if (objPriceBook.productcode.indexOf('MEMI') >= 0) {
                objWrapper = new wrapperProductInfo();
                objWrapper.dMemberAmt = objPriceBook.unitprice;
                objWrapper.strMemberGLCode = objPriceBook.product2.Gl_code__c;
                objWrapper.strMemberProdCode = objPriceBook.productcode;
                mapWrapper.put('MEMI', objWrapper);

            } else if (objPriceBook.productcode.indexOf('MEMS') >= 0) {
                objWrapper = new wrapperProductInfo();
                objWrapper.dMemberAmt = objPriceBook.unitprice;
                objWrapper.strMemberGLCode = objPriceBook.product2.Gl_code__c;
                objWrapper.strMemberProdCode = objPriceBook.productcode;
                mapWrapper.put('MEMS', objWrapper);

            } else if (objPriceBook.productcode.indexOf('MEMW') >= 0) {
                objWrapper = new wrapperProductInfo();
                objWrapper.dMemberAmt = objPriceBook.unitprice;
                objWrapper.strWileyGLCode = objPriceBook.product2.Gl_code__c;
                objWrapper.strWileyProdCode = objPriceBook.productcode;
                mapWrapper.put('WILEY', objWrapper);
            }

        }
        system.debug('mapWrapper == ' + mapWrapper);
        return mapWrapper;
    }

    public static Boolean getMonthDetailsOfProdCodes(String strExamName, String strExamStage, Integer iMonth, wrapperProductInfo objProductWrapper,
        Map < String, Product2 > mapMayProductDetails, Map < Id, PriceBookEntry > mapPriceBookDetails) {
        String strGLCode = (iMonth == 5 ? '4001' : '4002');
        system.debug('strGLCode == ' + strGLCode);
        String strProdCode = (strExamName.indexOf('FRM Part 1') >= 0 ? 'FRM1' :strExamName.indexOf('FRM Part 2') >= 0 ? 'FRM2':strExamName.indexOf('ERP Exam Part II') >= 0 ? 'ENC2':strExamName.indexOf('ERP Exam Part I') >= 0 ? 'ENC1':'ERP') + strExamStage;
        system.debug('strProdCode == ' + strProdCode);
        system.debug('strExamName == ' + strExamName);
        if (strExamName.indexOf('FRM Part 1') >= 0) {

            objProductWrapper.examPrice = getProdPrice(strGLCode + strProdCode, mapMayProductDetails, mapPriceBookDetails);
            objProductWrapper.strGLCode = strGLCode;
            objProductWrapper.strProductCode = strProdCode;
            objProductWrapper.strDisplayName = 'FRM Part I';

            //Populate Book and Enrollment below to the wrapper
            objProductWrapper.strFRMOneBookProdCode = 'FRM1H';
            objProductWrapper.strFRMOneBookGLCode = '4030';
            objProductWrapper.dFRMOneBookAmount = getProdPrice(objProductWrapper.strFRMOneBookGLCode + objProductWrapper.strFRMOneBookProdCode, mapMayProductDetails, mapPriceBookDetails);

            objProductWrapper.strFRMOneEnrollmentProdCode = 'FRM1';
            objProductWrapper.strFRMOneEnrollmentGLCode = '4010';
            if(bFRMPaidFor2009)
            {
                objProductWrapper.dFRMOneEnrollmentAmount = 150;
                objProductWrapper.returning = true;
            }
            else if(!bHasFRMEnrollment)
            {
                if (dStandardAmount != 0) objProductWrapper.dFRMOneEnrollmentAmount = dStandardAmount;
                else objProductWrapper.dFRMOneEnrollmentAmount = getProdPrice(objProductWrapper.strFRMOneEnrollmentGLCode + objProductWrapper.strFRMOneEnrollmentProdCode, mapMayProductDetails, mapPriceBookDetails);
            }
            

        } else if (strExamName.indexOf('FRM Part 2') >= 0) {
            objProductWrapper.examPrice = getProdPrice(strGLCode + strProdCode, mapMayProductDetails, mapPriceBookDetails);
            objProductWrapper.strGLCode = strGLCode;
            objProductWrapper.strProductCode = strProdCode;
            objProductWrapper.strDisplayName = 'FRM Part II';

            //Populate Book and Enrollment below to the wrapper
            objProductWrapper.strFRMTwoBookProdCode = 'FRM2H';
            objProductWrapper.strFRMTwoBookGLCode = '4030';
            objProductWrapper.dFRMTwoBookAmount = getProdPrice(objProductWrapper.strFRMTwoBookGLCode + objProductWrapper.strFRMTwoBookProdCode, mapMayProductDetails, mapPriceBookDetails);

        } else if (strExamName.indexOf('ERP Exam Part II') >= 0) {
            objProductWrapper.examPrice = getProdPrice(strGLCode + strProdCode, mapMayProductDetails, mapPriceBookDetails);
            objProductWrapper.strGLCode = strGLCode;
            objProductWrapper.strProductCode = strProdCode;
            objProductWrapper.strDisplayName = 'ERP Exam Part II';

            //Populate Book and Enrollment below to the wrapper
            objProductWrapper.strERPTwoBookProdCode = 'ENC2B';
            objProductWrapper.strERPTwoBookGLCode = '4030';
            objProductWrapper.dERPTwoBookAmount = getProdPrice(objProductWrapper.strERPTwoBookGLCode + objProductWrapper.strERPTwoBookProdCode, mapMayProductDetails, mapPriceBookDetails);

        }   else if (strExamName.indexOf('ERP Exam Part I') >= 0) {
            objProductWrapper.examPrice = getProdPrice(strGLCode + strProdCode, mapMayProductDetails, mapPriceBookDetails);
            objProductWrapper.strGLCode = strGLCode;
            objProductWrapper.strProductCode = strProdCode;
            objProductWrapper.strDisplayName = 'ERP Exam Part I';

            //Populate Book and Enrollment below to the wrapper
            objProductWrapper.strERPOneBookProdCode = 'ENC1B';
            objProductWrapper.strERPOneBookGLCode = '4030';
            objProductWrapper.dERPOneBookAmount = getProdPrice(objProductWrapper.strERPOneBookGLCode + objProductWrapper.strERPOneBookProdCode, mapMayProductDetails, mapPriceBookDetails);

            objProductWrapper.strERPOneEnrollmentProdCode = 'ENC';
            objProductWrapper.strERPOneEnrollmentGLCode = '4010';
            
            if(bERPPaidFor2009)
            {
                objProductWrapper.dERPEnrollmentAmount = 150;
                objProductWrapper.returning = true;
            }
            else if(!bHasERPEnrollment)
            objProductWrapper.dERPEnrollmentAmount = getProdPrice(objProductWrapper.strERPOneEnrollmentGLCode + objProductWrapper.strERPOneEnrollmentProdCode, mapMayProductDetails, mapPriceBookDetails);

        } else {
            return false;
        }
        system.debug('objProductWrapper == ' + objProductWrapper);
        return true;
            

    }

    //Changed on July 8/ 2014
    public static Map < String, wrapperProductInfo > getExamFee1(List < Exam__c > lstExamDetails) {
        system.debug('lstExamDetails ==' + lstExamDetails);
        if (lstExamDetails == null) return null;
        Set < String > setProdCodes = new Set < String > {
            'FRM1L', 'FRM1S', 'FRM1E', 'FRM2L', 'FRM2S', 'FRM2E', 'ENC1E', 'ENC1L', 'ENC1S','ENC2E', 'ENC2L', 'ENC2S', 'FRM1H', 'FRM2H', 'FRM1', 'ENC', 'ENC1B','ENC2B'
        };
        Map < String, Product2 > mapMayProductDetails = new Map < String, Product2 > ();
        Map < Id, PriceBookEntry > mapPriceBookDetails = new Map < ID, PriceBookEntry > ();
        system.debug('Product2>>>'+[select id, productcode, name, IsActive, GL_Code__c from Product2]);
        for (Product2 objProd: [select id, productcode, name, IsActive, GL_Code__c from Product2 where productcode in : setProdCodes and isActive = true]) {
            mapMayProductDetails.put(objProd.GL_Code__c + objProd.productcode, objProd);
        }
        for (PriceBookEntry PricebookEntryId: [select unitprice, productcode, product2Id from PriceBookEntry where Pricebook2.IsActive = true and productcode in : setProdCodes and isActive = true]) {
            mapPriceBookDetails.put(PricebookEntryId.product2Id, PricebookEntryId);

        }
        system.debug('mapMayProductDetails == '+mapMayProductDetails);
        system.debug('mapPriceBookDetails == '+mapPriceBookDetails);
        List < wrapperProductInfo > lstWrapper = new List < wrapperProductInfo > ();
        wrapperProductInfo objWrapper;
        Decimal dExamFee = 0;
        String strProdCode = '';
        system.debug('mapMayProductDetails>>>'+mapMayProductDetails);
        Map < String, wrapperProductInfo > mapWrapper = new Map < String, wrapperProductInfo > ();
        Boolean productsSet = false;
        for (Exam__c objExam: lstExamDetails) {
            objWrapper = new wrapperProductInfo();
            if (system.today() <= objExam.Exam_Group__r.Last_Date_For_Early_Registration__c) {
                productsSet =getMonthDetailsOfProdCodes(objExam.Exam__c, 'E', objExam.Exam_Date__c.month(), objWrapper, mapMayProductDetails, mapPriceBookDetails);

            } else if (system.today() <= objExam.Exam_Group__r.Last_Date_For_Standard_Registration__c) {
                productsSet =getMonthDetailsOfProdCodes(objExam.Exam__c, 'S', objExam.Exam_Date__c.month(), objWrapper, mapMayProductDetails, mapPriceBookDetails);

            } else if (system.today() <= objExam.Exam_Group__r.Last_Date_For_Late_Registration__c) {
                productsSet =getMonthDetailsOfProdCodes(objExam.Exam__c, 'L', objExam.Exam_Date__c.month(), objWrapper, mapMayProductDetails, mapPriceBookDetails);

            }

            if(productsSet == true) {
                //String strExamName = (objExam.Exam__c.indexOf('FRM Part 1') >= 0 ? 'FRMPartOne' :(objExam.Exam__c.indexOf('FRM Part 2') >= 0 ? 'FRMPartTwo' : objExam.Exam__c));
                String strExamName = (objExam.Exam__c.indexOf('FRM Part 1') >= 0 ? 'FRMPartOne' :(objExam.Exam__c.indexOf('FRM Part 2') >= 0 ? 'FRMPartTwo' : (objExam.Exam__c.indexOf('ERP Exam Part II') >= 0 ? 'ERPPartTwo' : objExam.Exam__c.indexOf('ERP Exam Part I') >= 0 ? 'ERPPartOne' : objExam.Exam__c)));
                //:(objExam.Exam__c.indexOf('ERP Exam Part II') >= 0 ? 'ERPPartTwo' : objExam.Exam__c):(objExam.Exam__c.indexOf('ERP Exam Part I') >= 0 ? 'ERPPartOne' : objExam.Exam__c)
                mapWrapper.put(strExamName, objWrapper);
            }
        }
        
        system.debug('mapWrapper>>>'+mapWrapper);
        
        return mapWrapper;
    }

    public static Map < String, Registration.wrapperProductInfo > getProductCodes1(String strExamType) {
        Id currentUSer = userInfo.getuserId();
        system.debug('currentUSer == ' + currentUSer);
        User objUSer = [select id, Email, contactId from user where id = : currentUSer];
        system.debug('objUSer == ' + objUSer);
        List < Exam_Attempt__c > lstExamAttempts = [select id, Defered__c, Member__c, Exam_Date__c, Exam_Site__c, Exam_Site__r.site__c, Section__c, Result__c, Candidate_Commitment__c, Candidate_Commitment__r.Status, Exam_Site__r.Exam__r.Exam_Group__r.Active__c from Exam_Attempt__c where Candidate_Commitment__r.Status = : 'Activated'
            and Member__c = : objUser.contactId and Cancelled__c != true order by Exam_Date__c DESC
        ];

        List < String > lstExamNames = new List < String > ();
        if (strExamType == 'FRM') {
            lstExamNames.add('FRM Part 1');
            lstExamNames.add('FRM Part 2');
        } else if(strExamType == 'ERP'){
             lstExamNames.add('ERP Exam Part I');
            lstExamNames.add('ERP Exam Part II');}

        Map < String, wrapperProductInfo > mapWrapper = new Map < String, wrapperProductInfo > ();
        if (strExamType == 'FBR' || strExamType == 'ICBRR' || strExamType == 'INDIVIDUAL' || strExamType == 'STUDENT' || strExamType == 'WILEY') {
            mapWrapper = getFBRICBRProductCodes(strExamType);
            mapWrapper = getMiscellaneousProdCodes(mapWrapper);
        } else {
            mapWrapper = getExamFee1(getExamDetails(lstExamNames));
            mapWrapper = getMiscellaneousProdCodes(mapWrapper);
        }

        return mapWrapper;



    }
    public static Decimal getPrice(String strProductCode) {
        if (strProductCode == null) return null;
        String strExamName = '';
        if (strProductCode == 'GL0008')
            strExamName = 'FRM Part 1';
        else if (strProductCode == 'GL0009')
            strExamName = 'FRM Part 2';
        else if (strProductCode == 'GL0016')
            strExamName = 'ERP';
        if (strExamName != '') {
            Map < String, decimal > mapExamFees = getExamFee(getExamDetails(new List < String > {
                strExamName
            }));
            if (mapExamFees == null) return 0;
            return mapExamFees.get(strExamName);
        } else {
            try {
                PriceBookEntry objPricebook = [select unitprice, productcode, Product2Id, Pricebook2Id, Name from PriceBookEntry where Pricebook2.IsActive = true and Pricebook2.IsActive = true and productcode = : strProductCode and isActive = true limit 1];
                return objPricebook.unitprice;
            } catch (exception ex) {
                return 0;

            }
        }
    }

    public static boolean chapterMeetingRegister(String contactId, String chapterMeetingId, Boolean isComing) {
        List < Chapter_Meeting_Registration__c > lstChapterMeetingRegistrations = [select Id, Name, Status__c from Chapter_Meeting_Registration__c where Chapter_Meeting__c = : chapterMeetingId and Contact__c = : contactId];
        if (lstChapterMeetingRegistrations != null && lstChapterMeetingRegistrations.size() > 0) {

            if (!isComing) {
                delete lstChapterMeetingRegistrations[0];
            }

        } else if (isComing) {

            Chapter_Meeting_Registration__c newChapterMeetingRegistration = new Chapter_Meeting_Registration__c();
            newChapterMeetingRegistration.put('Status__c', 'Confirmed');
            newChapterMeetingRegistration.put('Role__c', 'Registrant');
            newChapterMeetingRegistration.put('Chapter_Meeting__c', chapterMeetingId);
            newChapterMeetingRegistration.put('Contact__c', contactId);
            insert newChapterMeetingRegistration;

        }
        return true;
    }
    //Registration.ChargeOpportunity('006f000000A6mj1','02','20','Credit Card','Visa','124','4242424242424242','10.00');

    public Static String Charge(Id oppId,String cardMonth,String cardYear,String paymentType,String cardType,String cardSecurity,String cardNumber)
    {
        Opportunity opp = [select id,amount from opportunity where  id =: oppId];
        system.debug('opp.amount === '+opp.amount);
        
        if(opp.amount == 0) {
            opp.StageName = 'Closed';
            update opp;
            return 'Closed Opp Approved';
        } else {
            ChargentSFA.TChargentOperations.TChargentResult outputResult;
            String strInput = PrepareJsonParameters(oppId,cardMonth,cardYear,paymentType,cardType,cardSecurity,cardNumber,opp.amount);
            system.debug('strInput === '+strInput);
            outputResult = ChargentSFA.TChargentOperations.ChargeOpportunity_ClickJSON(strInput);
            system.debug('Response === '+outputResult);
            system.debug('Result == '+outputResult.Message);
            if(outputResult != null) {
                return outputResult.Message;            
            } else {
                return null;
            }
        }
    }
    
    private static String PrepareJsonParameters(Id oppId,String cardMonth,String cardYear,String paymentType,String cardType,String cardSecurity,String cardNumber,Decimal amount)
    {
        String jsonInput = '{\n' +
        ' "ObjectId" : "'+ oppId +'",\n' +
        ' "CardMonth" : "'+ cardMonth +'",\n' +
        ' "CardYear" :"'+ cardYear +'",\n' +
        ' "PaymentMethod" : "'+ paymentType +'",\n' +
        ' "CardType" : "'+ cardType +'",\n' +
        ' "CardSecurity" : "'+ cardSecurity +'",\n' +
        ' "CardNumber" : "'+ cardNumber +'",\n' +
        ' "ChargeAmount" : "'+ amount +'"\n' +
        '}';
        
        return jsonInput;
    
    }

}