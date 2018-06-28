public class contractSyncUtil {

    public static boolean bRecursive = false;
    static id MembershipTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'Membership');
    static id FRMExamTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'FRM Program');
    static id ERPExamTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'ERP Program');
    static id ICBRRExamTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'ICBRR Program');
    static id FBRExamTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'FBR Program');
    static id WileyTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'Wiley Bookstore');
    static id CPETypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'CPE');

    static id progReqCPECredit = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'CPE');

    public static void updateContracts(Map < Id, Contract > mapAccountIds) {

        List < Contact > lstActiveContacts = new List < Contact > ();
        MAP<Id, Opportunity> updateOppMap = new MAP<Id, Opportunity>();
        MAP<Id, Opportunity> currOppMap = new MAP<Id, Opportunity>();
        
        List < Contract > lstContract = [select Id, Name, AccountId, Status, All_Requirements_Completed_Date__c, All_Requirements_Completed__c, Membership_Type__c, StartDate, EndDate, ActivatedDate, Opportunity__c, recordTypeId from Contract where accountId in : mapAccountIds.keySet() Order By StartDate];
        List < Opportunity > lstOpportunityEligible = [SELECT Id, Name, Amount, AccountId, Member_Status__c, Eligible_for_Membership_Extension__c, CloseDate, StageName, Display_Invoice_Number__c,
                (SELECT Quantity, ListPrice, TotalPrice, PriceBookEntry.UnitPrice, PricebookEntry.Name,
                PricebookEntry.Product2.ProductCode, PricebookEntry.Product2.Product_ID__c FROM OpportunityLineItems),
                FRM_1_Registration_Fee__c, FRM_2_Registration_Fee__c, EA_Id__c,  Undefred_EA_Id__c,
                FRM_I_Registration__c, FRM_II_Registration__c, ERP_Registration__c, Deferred_Exam_Registration__c
				FROM Opportunity where 
                AccountId in : mapAccountIds.keySet() and StageName like '%Close%' and StageName != 'Closed Lost'
            order by CloseDate
        ];
                
        for(Opportunity opp: lstOpportunityEligible) {
            currOppMap.put(opp.Id, opp);
        }
        List < Product_Refunds__c > lstPr = [select Id, Refund_amount__c, Opportunity__c, Opportunity__r.AccountId,
            Product__r.ProductCode, Product__r.Product_ID__c from Product_Refunds__c where
            Status__c = 'Completed'
            and Opportunity__c in : lstOpportunityEligible
        ];

        MAP < ID, List < Product_Refunds__c >> mapPR = new MAP < ID, List < Product_Refunds__c >> ();
        MAP < ID, List < Product_Refunds__c >> mapExamRegPR = new MAP < ID, List < Product_Refunds__c >> ();
        MAP < ID, List < Product_Refunds__c >> mapWileyPR = new MAP < ID, List < Product_Refunds__c >> ();
        
        for (Product_Refunds__c pr: lstPr) {

            if (pr.Product__r.ProductCode == 'MEMW' ||
                pr.Product__r.Product_ID__c == '1147') {
                    
                List < Product_Refunds__c > lst = mapWileyPR.get(pr.Opportunity__c);
                if (lst == null) {
                    List < Product_Refunds__c > newlst = new List < Product_Refunds__c > ();
                    newlst.add(pr);
                    mapWileyPR.put(pr.Opportunity__c, newlst);
                } else {
                    lst.add(pr);
                    mapWileyPR.put(pr.Opportunity__c, lst);
                }
                    
            }
                
                
            if (pr.Product__r.ProductCode == '208' ||
                pr.Product__r.ProductCode == '7' ||
                pr.Product__r.ProductCode == '207' ||
                pr.Product__r.ProductCode == '1129' ||
                pr.Product__r.ProductCode == '4' ||
                pr.Product__r.ProductCode == '944' ||
                pr.Product__r.ProductCode == 'MEMS' ||
                pr.Product__r.ProductCode == 'MEMI' ||
                pr.Product__r.ProductCode == 'MEMC' ||
                pr.Product__r.ProductCode == '395' ||
                pr.Product__r.ProductCode == 'MEMF' ||
                pr.Product__r.Product_ID__c == '181' ||
                pr.Product__r.Product_ID__c == '209' ||
                pr.Product__r.Product_ID__c == '5' ||
                pr.Product__r.Product_ID__c == '6') {

                List < Product_Refunds__c > lst = mapPR.get(pr.Opportunity__c);
                if (lst == null) {
                    List < Product_Refunds__c > newlst = new List < Product_Refunds__c > ();
                    newlst.add(pr);
                    mapPR.put(pr.Opportunity__c, newlst);
                } else {
                    lst.add(pr);
                    mapPR.put(pr.Opportunity__c, lst);
                }
            }
            
            if (pr.Product__r.ProductCode == 'ENCL' ||
                pr.Product__r.ProductCode == 'ENCE' ||
                pr.Product__r.ProductCode == 'ENCS' ||
                pr.Product__r.ProductCode == 'FRM1E' ||
                pr.Product__r.ProductCode == 'FRM1S' ||
                pr.Product__r.ProductCode == 'FRM1L' ||
                pr.Product__r.ProductCode == 'FRM2E' ||
                pr.Product__r.ProductCode == 'FRM2S' ||
                pr.Product__r.ProductCode == 'FRM2L' ||
                pr.Product__r.Product_ID__c == '1155' ||
                pr.Product__r.Product_ID__c == '1156') {

                List < Product_Refunds__c > lst = mapExamRegPR.get(pr.Opportunity__c);
                if (lst == null) {
                    List < Product_Refunds__c > newlst = new List < Product_Refunds__c > ();
                    newlst.add(pr);
                    mapExamRegPR.put(pr.Opportunity__c, newlst);
                } else {
                    lst.add(pr);
                    mapExamRegPR.put(pr.Opportunity__c, lst);
                }
            }            
            
        }
        List < Candidate_Requirement__c > lstCandidateRequirement = [select Id, Name, RecordTypeID, Status__c, Certificate_Sent_Date__c, Date_of_Failed_Review__c, Date_of_Ready_for_Review__c, Date_of_Completion__c, Approved_Credits_Total__c, Candidate_Commitment__c, Approved_Credits__c, Candidate_Commitment__r.StartDate from Candidate_Requirement__c where Candidate_Commitment__c in : lstContract];



        List < Contact > lstContacts = new List < Contact > ();
        for (Contact objContact: [select id, KPI_Member__c, Membership_Type__c, CVent_Contact_Type__c, KPI_Membership_Since__c,
                KPI_Membership_Expiration_Date__c, KPI_Membership_Payment_Lapsed_Months__c, KPI_Membership_Payment_Status__c,
                KPI_Membership_Source__c, KPI_Membership_Original_Business_Type__c, KPI_Membership_Renewal_Type__c,
                KPI_Membership_Business_Type__c, KPI_Membership_Renewal_Count__c, KPI_Membership_Original_Type__c,
                KPI_Membership_Renew_Count__c, KPI_Membership_Comp_Count__c,
                KPI_Membership_Converted_Exam_Comp__c,KPI_Membership_Converted_Affiliate__c,
                KPI_Membership_Renewal_Date__c, Membership_Last_Contract_Start_Date__c, KPI_Membership_Purchase_History__c,
                KPI_Membership_Contract_History__c, Membership_Caluclated_Expiration_Date__c,
                                  
                KPI_FRM_Resume_Status__c, KPI_FRM_Resume_Status_Date__c, KPI_FRM_Resume_Certificate_Sent_Date__c, KPI_FRM_Resume_Submission_Date__c,
                KPI_ERP_Resume_Status__c, KPI_ERP_Resume_Status_Date__c, KPI_ERP_Resume_Certificate_Sent_Date__c, KPI_ERP_Resume_Submission_Date__c,

                KPI_FRM_Resume_Program_Requirement_ID__c, KPI_ERP_Resume_Program_Requirement_ID__c,
                KPI_FRM_Certified_Date__c, KPI_FRM_Certified_Year__c, KPI_FRM_Certified__c, KPI_FRM_Candidate__c,
                KPI_FRM_Holder__c, KPI_FRM_Candidate_Payment_Lapsed_Months__c, KPI_FRM_Candidate_Payment_Status__c,

                KPI_FRM_Candidate_Business_Type__c, KPI_ERP_Certified_Date__c, KPI_ERP_Certified_Year__c,

                KPI_FRM_Program_Start_Date__c, KPI_FRM_Program_Expiration_Date__c, KPI_ERP_Program_Start_Date__c, KPI_ERP_Program_Expiration_Date__c,

                KPI_ERP_Certified__c, KPI_ERP_Candidate__c, KPI_ERP_Holder__c, KPI_ERP_Candidate_Payment_Lapsed_Months__c,
                KPI_ERP_Candidate_Payment_Status__c, KPI_ERP_Candidate_Business_Type__c, KPI_ICBRR_Participant__c,
                KPI_FBR_Participant__c, KPI_CPE_Participation__c, KPI_CPE_Current_Cycle__c, KPI_CPE_Credits__c,
                KPI_CPE_Last_Completed_Cycle__c, KPI_CPE_Requirement_Status__c, CPE_Current_Program_Requirement__c, accountId,
                
                KPI_Wiley__c, KPI_Wiley_Business_Type__c, KPI_Wiley_Join_Date__c, KPI_Wiley_Payment_Status__c,
                Email_Member_Update__c, MailingCountry from contact where accountId in : mapAccountIds.keySet()
            ]) {

            objContact.KPI_FRM_Resume_Program_Requirement_ID__c = null;
            objContact.KPI_ERP_Resume_Program_Requirement_ID__c = null;
			objContact.KPI_FRM_Program_Start_Date__c = null;
            objContact.KPI_FRM_Program_Expiration_Date__c = null;
            objContact.KPI_ERP_Program_Start_Date__c = null;
            objContact.KPI_ERP_Program_Expiration_Date__c = null;
            objContact.KPI_FRM_Certified_Date__c = null;
            objContact.KPI_FRM_Certified_Year__c = null;
            objContact.KPI_FRM_Certified__c = false;
            objContact.KPI_FRM_Candidate__c = false;
            objContact.KPI_FRM_Holder__c = false;
            objContact.KPI_FRM_Candidate_Payment_Lapsed_Months__c = null;
            objContact.KPI_FRM_Candidate_Payment_Status__c = null;
            objContact.KPI_FRM_Candidate_Business_Type__c = null;

            objContact.KPI_ERP_Certified_Date__c = null;
            objContact.KPI_ERP_Certified_Year__c = null;
            objContact.KPI_ERP_Certified__c = false;
            objContact.KPI_ERP_Candidate__c = false;
            objContact.KPI_ERP_Holder__c = false;
            objContact.KPI_ERP_Candidate_Payment_Lapsed_Months__c = null;
            objContact.KPI_ERP_Candidate_Payment_Status__c = null;
            objContact.KPI_ERP_Candidate_Business_Type__c = null;

            objContact.KPI_ICBRR_Participant__c = false;
            //objContact.KPI_ICBRR_Result__c = null;
            objContact.KPI_FBR_Participant__c = false;

            objContact.KPI_CPE_Participation__c = false;
            objContact.KPI_CPE_Current_Cycle__c = null;
            objContact.KPI_CPE_Credits__c = null;
            objContact.KPI_CPE_Last_Completed_Cycle__c = null;
            objContact.KPI_CPE_Requirement_Status__c = null;
            objContact.CPE_Current_Program_Requirement__c = null;

            objContact.KPI_Wiley__c = false;
            objContact.KPI_Wiley_Business_Type__c = null;
            objContact.KPI_Wiley_Join_Date__c = null;
            objContact.KPI_Wiley_Payment_Status__c = null;
                   
              
            objContact.KPI_Member__c = false;
            objContact.Membership_Type__c = 'Affiliate';
            objContact.CVent_Contact_Type__c = 'Non-Member';
            objContact.KPI_Membership_Since__c = null;
            objContact.KPI_Membership_Expiration_Date__c = null;
            objContact.KPI_Membership_Payment_Lapsed_Months__c = null;
            objContact.KPI_Membership_Payment_Status__c = null;
            objContact.KPI_Membership_Source__c = null;
            objContact.KPI_Membership_Original_Business_Type__c = null;
            objContact.KPI_Membership_Original_Source__c = null;
            objContact.KPI_Membership_Renewal_Type__c = null;
            objContact.KPI_Membership_Business_Type__c = null;
                
            objContact.KPI_Membership_Renewal_Count__c = null;
            objContact.KPI_Membership_Comp_Count__c = NULL;
            objContact.KPI_Membership_Renew_Count__c = NULL;
            objContact.KPI_Membership_Converted_Exam_Comp__c = false;
            objContact.KPI_Membership_Converted_Affiliate__c = false;
                
            objContact.KPI_Membership_Renewal_Date__c = null;
            objContact.KPI_Membership_Original_Type__c = null;
            objContact.Membership_Last_Contract_Start_Date__c = null;

            objContact.KPI_FRM_Resume_Status__c = null;
            objContact.KPI_FRM_Resume_Status_Date__c = null;
            objContact.KPI_FRM_Resume_Certificate_Sent_Date__c = null;
            objContact.KPI_FRM_Resume_Submission_Date__c = null;

            objContact.KPI_ERP_Resume_Status__c = null;
            objContact.KPI_ERP_Resume_Status_Date__c = null;
            objContact.KPI_ERP_Resume_Certificate_Sent_Date__c = null;
            objContact.KPI_ERP_Resume_Submission_Date__c = null;
            objContact.KPI_Membership_Purchase_History__c = null;
            objContact.KPI_Membership_Contract_History__c = null;
                
            objContact.Email_Member_Update__c = false;

                
            Map<String,String> abbrevMap = new Map<String,String>();
            abbrevMap.put('Individual','Indv');
            abbrevMap.put('Student','Stud');
            abbrevMap.put('Affiliate','Aff');
            abbrevMap.put('Expired','Exp');
            abbrevMap.put('Canceled','Can');
           abbrevMap.put('MEMI','Individual');
           abbrevMap.put('MEMC','Individual');
           abbrevMap.put('MEMF','Individual');                   
           abbrevMap.put('MEMS','Student');
           abbrevMap.put('AFREE','Affiliate');

                
           Map<String,String> statusMap = new Map<String,String>();
           statusMap.put('MEMI','Individual');
           statusMap.put('MEMC','Individual');
           statusMap.put('MEMF','Individual');                   
           statusMap.put('MEMS','Student');
           statusMap.put('AFREE','Affiliate');

           
            List < Contract > contracts = new List < Contract > ();
			Date firstFrmProgStartDate;
            Date firstErpProgStartDate;
            String renewStatusLevel = '';
            Boolean userComp = false;
            Boolean userPay = false;
            Integer renewalCount = 0;
            String lastUserType = '';
            Integer frmCnt = 0;
            Integer frmCanceledCnt = 0;
            Integer erpCnt = 0;
            Integer erpCanceledCnt = 0;
            Integer memCnt = 0;
            Contract lastContract = null;
            Contract thisContract = null;
            Contract firstMemberContract = null;
            Contract lastMemberContract = null;
            Date memberSinceContract = null;
            Date nowDateTime = date.today();
            //Datetime contractStartDateTime;
            //Datetime contractEndDateTime;
                
            Map<ID,ID> acctOppMap = new Map<ID,ID>();
            // Contracts are in Start Date Order!!
            for (Contract con: lstContract) {
				
                
                system.debug('* * * Core con:'+con);
                
                
                if (objContact.accountId != con.AccountId)
                    continue;
                
                Boolean foundDupe = false;
                for (Contact conLook: lstContacts) {
                    if (conLook.Id == objContact.Id) {
                        foundDupe = true;
                        break;
                    }
                }
                if (foundDupe)
                    continue;
                
                
           
                
                
                if (con.recordTypeId == MembershipTypeId)
                    thisContract = con;

                Boolean currentCPE = false;

                if (con.status.indexof('Canceled') > -1) {
                    
                    system.debug('* * * Core Canceled1:'+con);
                    

                    if (con.recordTypeId == FRMExamTypeId || con.recordTypeId == ERPExamTypeId) {
                        if (con.recordTypeId == FRMExamTypeId) {
                            frmCanceledCnt++;
                            objContact.KPI_FRM_Certified_Date__c = null;
                            objContact.KPI_FRM_Certified_Year__c = null;
                            objContact.KPI_FRM_Certified__c = false;
                            objContact.KPI_FRM_Candidate__c = false;
                            objContact.KPI_FRM_Holder__c = false;
                            objContact.KPI_FRM_Candidate_Payment_Lapsed_Months__c = null;
                            objContact.KPI_FRM_Resume_Status__c = null;
                            objContact.KPI_FRM_Resume_Status_Date__c = null;
                            objContact.KPI_FRM_Resume_Certificate_Sent_Date__c = null;
                            objContact.KPI_FRM_Resume_Submission_Date__c = null;
                            objContact.KPI_FRM_Candidate_Business_Type__c = null;
                        }
                        if (con.recordTypeId == ERPExamTypeId) {
                            erpCanceledCnt++;
                            objContact.KPI_ERP_Certified_Date__c = null;
                            objContact.KPI_ERP_Certified_Year__c = null;
                            objContact.KPI_ERP_Certified__c = false;
                            objContact.KPI_ERP_Candidate__c = false;
                            objContact.KPI_ERP_Holder__c = false;
                            objContact.KPI_ERP_Candidate_Payment_Lapsed_Months__c = null;
                            objContact.KPI_ERP_Resume_Status__c = null;
                            objContact.KPI_ERP_Resume_Status_Date__c = null;
                            objContact.KPI_ERP_Resume_Certificate_Sent_Date__c = null;
                            objContact.KPI_ERP_Resume_Submission_Date__c = null;
                            objContact.KPI_ERP_Candidate_Business_Type__c = null;
                        }
                    }
                    if (con.recordTypeId == CPETypeId) {
                        Candidate_Requirement__c lastCR = new Candidate_Requirement__c();
                        for (Candidate_Requirement__c cr: lstCandidateRequirement) {
                            if (cr.Candidate_Commitment__c == con.Id) {
                                if (cr.Name == 'CPE') {
                                    objContact.KPI_CPE_Requirement_Status__c = 'Pending';
                                    if (cr.Status__c == 'Completed') {
                                        objContact.KPI_CPE_Last_Completed_Cycle__c = String.valueOf(cr.Candidate_Commitment__r.StartDate.year()) + '/' + String.valueOf(cr.Candidate_Commitment__r.StartDate.year() + 1);
                                        if ((cr.Candidate_Commitment__r.StartDate.year() + 2) == Date.today().year() || (cr.Candidate_Commitment__r.StartDate.year() + 3) == Date.today().year()) {
                                            lastCR = cr;
                                            objContact.KPI_CPE_Requirement_Status__c = 'In Good Standing';
                                        }
                                    }
                                }
                            }
                        }
                        if (lastCR != null && lastCR.Status__c != 'Completed') {
                            objContact.KPI_CPE_Requirement_Status__c = 'Lapsed';
                        }
                    }
                }
                
            

                
                // To get the FRM program start date (Start date of the first FRM program)
                if (con.recordTypeId == FRMExamTypeId && (con.status.indexof('Activated') > -1 || con.status.indexof('Expired') > -1 || con.status.indexof('Completed') > -1))
                {
                	
                    if(firstFrmProgStartDate == NULL || con.StartDate <= firstFrmProgStartDate )
                    {
                        system.debug('* * * Contract Status is:'+con.status); 
						firstFrmProgStartDate = con.StartDate;                        
                    }
                    
                	system.debug('* * * First FRM Start Date:'+firstFrmProgStartDate); 
                    objContact.KPI_FRM_Program_Start_Date__c = firstFrmProgStartDate;
                }
                
                
                // To get the ERP program start date (Start date of the first ERP program)
                if (con.recordTypeId == ERPExamTypeId && (con.status.indexof('Activated') > -1 || con.status.indexof('Expired') > -1 || con.status.indexof('Completed') > -1))
                {
                	
                    if(firstErpProgStartDate == NULL || con.StartDate <= firstErpProgStartDate )
                    {
                        system.debug('* * * Contract Status is:'+con.status); 
						firstErpProgStartDate = con.StartDate;                        
                    }
                    
                	system.debug('* * * First ERP Start Date:'+firstErpProgStartDate); 
                    objContact.KPI_ERP_Program_Start_Date__c = firstErpProgStartDate;
                }
                
                
                 if (con.status.indexof('Expired') > -1 && con.recordTypeId == FRMExamTypeId)
                        {
                            system.debug('********Expired ');
                            objContact.KPI_FRM_Program_Expiration_Date__c = con.EndDate;
							objContact.KPI_FRM_Candidate_Payment_Status__c = 'Lapsed';                            
                        }
                
                if (con.status.indexof('Expired') > -1 && con.recordTypeId == ERPExamTypeId)
                        {
                            system.debug('********Expired ');
                            objContact.KPI_ERP_Program_Expiration_Date__c = con.EndDate;
							objContact.KPI_ERP_Candidate_Payment_Status__c = 'Lapsed';                            
                        }


                // Active Contracts            
                if (con.status.indexof('Activated') > -1 || con.status.indexof('Completed') > -1) {

                    system.debug('* * * Active or Completed Contract2:'+con);

                    //if (con.recordTypeId == WileyTypeId) {
                    //    system.debug('* * * Wiley:' + con.Membership_Type__c);
                    //    objContact.KPI_J_Wiley__c = true;
                    //}


                    if (con.recordTypeId == CPETypeId) {
                        currentCPE = true;
                        if (con.StartDate != null) {
                            objContact.KPI_CPE_Current_Cycle__c = String.valueOf(con.StartDate.year()) + '/' + String.valueOf(con.StartDate.year() + 1);
                            if (con.StartDate.year() <= Date.today().year()) {
                                objContact.KPI_CPE_Participation__c = true;
                            }
                        }
                    }

                    if (con.recordTypeId == FRMExamTypeId || con.recordTypeId == ERPExamTypeId || con.recordTypeId == CPETypeId) {

                        system.debug('* * * FRM/ERP:' + con.All_Requirements_Completed__c);

                        Date lastDate = null;
                        Boolean passNotDone = false;
                        Candidate_Requirement__c lastCR = new Candidate_Requirement__c();
                        Id examRecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Exam');
                        Id jobRecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Job Experience');

                        for (Candidate_Requirement__c cr: lstCandidateRequirement) {

                            if (cr.Candidate_Commitment__c == con.Id) {

                                system.debug('* * * Candidate_Requirement__c?:' + cr.Name + ':' + cr.Id + ':' + cr.Candidate_Commitment__c + ':' + con.Id + ':' + cr.Name + ':' + cr.Status__c + ':' + cr.Date_of_Completion__c + ':' + cr.RecordTypeID);
                                //if(cr.Name.toLowerCase().indexof('pass') > -1 && cr.Status__c != 'Completed')
                                if (cr.RecordTypeID == examRecordTypeID && cr.Status__c != 'Completed')
                                    passNotDone = true;

                                if (cr.Status__c == 'Completed' && (lastDate == null || cr.Date_of_Completion__c >= lastDate)) {
                                    lastDate = cr.Date_of_Completion__c;
                                }

                                if(cr.recordTypeId == progReqCPECredit) {
                                	//System.assert(false, 'BOOM!!!!' + cr);                                
                                    if (currentCPE)
                                        objContact.CPE_Current_Program_Requirement__c = cr.Id;
                                    objContact.KPI_CPE_Credits__c = cr.Approved_Credits_Total__c;
                                }

                                if (cr.RecordTypeID == jobRecordTypeID && con.recordTypeId == FRMExamTypeId) {

                                    objContact.KPI_FRM_Resume_Submission_Date__c = cr.Date_of_Ready_for_Review__c;
                                    system.debug('The submission date is ++++'+objContact.KPI_FRM_Resume_Submission_Date__c);
                                    if (cr.Status__c == 'Initial')
                                        objContact.KPI_FRM_Resume_Status__c = NULL;

                                    if (cr.Status__c == 'Ready For Review')
                                        objContact.KPI_FRM_Resume_Status__c = 'Waiting for Review';
                                    
                                    if (cr.Status__c == 'Failed Review')
                                        objContact.KPI_FRM_Resume_Status__c = 'Denied';

                                    if (cr.Status__c == 'Completed')
                                        objContact.KPI_FRM_Resume_Status__c = 'Approved';


                                    objContact.KPI_FRM_Resume_Program_Requirement_ID__c = cr.Id;
                                    if (cr.Status__c == 'Completed' && cr.Date_of_Completion__c != null)
                                        objContact.KPI_FRM_Resume_Status_Date__c = cr.Date_of_Completion__c;

                                    if (cr.Status__c == 'Failed Review' && cr.Date_of_Failed_Review__c != null)
                                        objContact.KPI_FRM_Resume_Status_Date__c = cr.Date_of_Failed_Review__c;

                                    if (cr.Certificate_Sent_Date__c != null)
                                        objContact.KPI_FRM_Resume_Certificate_Sent_Date__c = cr.Certificate_Sent_Date__c;

                                }

                                if (cr.RecordTypeID == jobRecordTypeID && con.recordTypeId == ERPExamTypeId) {
                                    
                                    objContact.KPI_ERP_Resume_Submission_Date__c = cr.Date_of_Ready_for_Review__c;
                                    
                                    if (cr.Status__c == 'Initial')
                                        objContact.KPI_ERP_Resume_Status__c = NULL;

                                    if (cr.Status__c == 'Ready For Review')
                                        objContact.KPI_ERP_Resume_Status__c = 'Waiting for Review';

                                    if (cr.Status__c == 'Failed Review')
                                        objContact.KPI_ERP_Resume_Status__c = 'Denied';

                                    if (cr.Status__c == 'Completed')
                                        objContact.KPI_ERP_Resume_Status__c = 'Approved';

                                    objContact.KPI_ERP_Resume_Program_Requirement_ID__c = cr.Id;
                                    if (cr.Status__c == 'Completed' && cr.Date_of_Completion__c != null)
                                        objContact.KPI_ERP_Resume_Status_Date__c = cr.Date_of_Completion__c;

                                    if (cr.Status__c == 'Failed Review' && cr.Date_of_Failed_Review__c != null)
                                        objContact.KPI_ERP_Resume_Status_Date__c = cr.Date_of_Failed_Review__c;

                                    if (cr.Certificate_Sent_Date__c != null)
                                        objContact.KPI_ERP_Resume_Certificate_Sent_Date__c = cr.Certificate_Sent_Date__c;

                                }
                            }
                        }

                        if (con.recordTypeId == FRMExamTypeId && (con.status.indexof('Completed') > -1)) {
                         
                            objContact.KPI_FRM_Program_Expiration_Date__c = con.All_Requirements_Completed_Date__c;
                            objContact.KPI_FRM_Candidate_Payment_Lapsed_Months__c = NULL;
                            objContact.KPI_FRM_Candidate_Payment_Status__c = con.status;

                        } else if (con.status.indexof('Activated') > -1 && con.recordTypeId == FRMExamTypeId) {
                        
                            objContact.KPI_FRM_Program_Expiration_Date__c = con.EndDate;

                            if (nowDateTime > con.EndDate) {
                                Integer monthDiff = con.EndDate.monthsBetween(nowDateTime);
                                objContact.KPI_FRM_Candidate_Payment_Lapsed_Months__c = monthDiff;
                                objContact.KPI_FRM_Candidate_Payment_Status__c = 'Lapsed';
                            } else {
                                objContact.KPI_FRM_Candidate_Payment_Status__c = 'In Good Standing';
                                objContact.KPI_FRM_Candidate_Payment_Lapsed_Months__c = null;
                            }

                        }
                        
                       
                        /** ERP ***/
                        if (con.recordTypeId == ERPExamTypeId && (con.status.indexof('Completed') > -1)) {
                            
                            objContact.KPI_ERP_Program_Expiration_Date__c = con.All_Requirements_Completed_Date__c;
                            objContact.KPI_ERP_Candidate_Payment_Lapsed_Months__c = NULL;
                            objContact.KPI_ERP_Candidate_Payment_Status__c = con.status;

                        } else if (con.status.indexof('Activated') > -1 && con.recordTypeId == ERPExamTypeId) {
                            objContact.KPI_ERP_Program_Expiration_Date__c = con.EndDate;

                            if (nowDateTime > con.EndDate) {
                                Integer monthDiff = con.EndDate.monthsBetween(nowDateTime);
                                objContact.KPI_ERP_Candidate_Payment_Lapsed_Months__c = monthDiff;
                                objContact.KPI_ERP_Candidate_Payment_Status__c = 'Lapsed';
                            } else {
                                objContact.KPI_ERP_Candidate_Payment_Status__c = 'In Good Standing';
                                objContact.KPI_ERP_Candidate_Payment_Lapsed_Months__c = null;
                            }

                        }
                        

                        system.debug('* * * passNotDone:' + passNotDone + ':' + lastDate);

                        system.debug('* * * RecordTypes:' + con.recordTypeId + ':' + FRMExamTypeId + ':' + ERPExamTypeId);

                        if (con.All_Requirements_Completed__c) {
                            if (con.recordTypeId == FRMExamTypeId && lastDate != null) {
                                system.debug('* * * In 1');
                                objContact.KPI_FRM_Certified_Date__c = lastDate;
                                objContact.KPI_FRM_Certified_Year__c = string.valueof(lastDate.year());
                                objContact.KPI_FRM_Certified__c = true;
                                objContact.KPI_FRM_Candidate__c = false;
                                objContact.KPI_FRM_Holder__c = false;
                            }
                            if (con.recordTypeId == ERPExamTypeId && lastDate != null) {
                                system.debug('* * * In 2');
                                objContact.KPI_ERP_Certified_Date__c = lastDate;
                                objContact.KPI_ERP_Certified_Year__c = string.valueof(lastDate.year());
                                objContact.KPI_ERP_Certified__c = true;
                                objContact.KPI_ERP_Candidate__c = false;
                                objContact.KPI_ERP_Holder__c = false;
                            }
                        } else {
                            if (con.recordTypeId == FRMExamTypeId) {
                                system.debug('* * * In 3');
                                objContact.KPI_FRM_Certified__c = false;
                                if (passNotDone) {
                                    objContact.KPI_FRM_Holder__c = false;
                                    objContact.KPI_FRM_Candidate__c = true;
                                } else {
                                    objContact.KPI_FRM_Holder__c = true;
                                    objContact.KPI_FRM_Candidate__c = true;
                                }
                            }
                            if (con.recordTypeId == ERPExamTypeId) {
                                system.debug('* * * In 4');
                                objContact.KPI_ERP_Certified__c = false;
                                if (passNotDone) {
                                    objContact.KPI_ERP_Holder__c = false;
                                    objContact.KPI_ERP_Candidate__c = true;
                                } else {
                                    objContact.KPI_ERP_Holder__c = true;
                                    objContact.KPI_ERP_Candidate__c = true;
                                }
                            }
                        }
                    }

                    if (con.recordTypeId == ICBRRExamTypeId) {
                        objContact.KPI_ICBRR_Participant__c = true;
                        //objContact.KPI_ICBRR_Result__c = null;
                    }
                    if (con.recordTypeId == FBRExamTypeId) {
                        objContact.KPI_FBR_Participant__c = true;
                    }
                }

                // Dont I need to check for not Draft!!
                if (con.recordTypeId == FRMExamTypeId) {
                    frmCnt++;
                }
                if (con.recordTypeId == ERPExamTypeId) {
                    erpCnt++;
                }
                                    
                if (con.recordTypeId == WileyTypeId && con.status.indexof('Canceled') == -1 && con.status.indexof('Draft') == -1) {
                    
                    system.debug('* * * Wiley not Canceled nor Draft Contract3:'+con);
                    
                    objContact.KPI_Wiley__c = True;
                    
                    if(con.status.indexof('Expired') > -1) {
                        objContact.KPI_Wiley_Payment_Status__c = 'Lapsed';
                    } else if(con.status.indexof('Activ') > -1) {
                        objContact.KPI_Wiley_Payment_Status__c = 'In Good Standing';
                    }
                    for (Opportunity opp: lstOpportunityEligible) {
                        
                        system.debug('exam reg calc opp:'+opp);
                        //ID used = acctOppMap.get(opp.Id);
                            
                        if (opp.AccountId == con.AccountId) {
                            Boolean found=false;
                            for (OpportunityLineItem ol: opp.OpportunityLineItems) {
                             
                                if (ol.PricebookEntry.Product2.ProductCode == 'MEMW' ||
                                    ol.PricebookEntry.Product2.Product_ID__c == '1147')
                                    found=true;
                                
                            }
                            system.debug('found reg:'+found); 
                            
                            opp.Wiley_Status__c = null;
                            updateOppMap.put(opp.Id,opp);
                            system.debug('Wiley_Status__c: ' + Opp);
                            
                            if(found) {
                                if(objContact.KPI_Wiley_Business_Type__c == null) {
                                    objContact.KPI_Wiley_Business_Type__c = 'New';
                                    objContact.KPI_Wiley_Join_Date__c = opp.CloseDate;
                                    
                                    Opp.Wiley_Status__c = 'New';
                                    updateOppMap.put(opp.Id,opp);
                                    system.debug('Wiley_Status__c: ' + Opp);                                    
                                        
                                } else {
                                    objContact.KPI_Wiley_Business_Type__c = 'Renew';

                                    Opp.Wiley_Status__c = 'Renew';
                                    updateOppMap.put(opp.Id,opp);
                                    system.debug('Wiley_Status__c: ' + Opp);                                    
                                }
                            }
                            
                            if(found) {
                                updateOppMap.put(opp.Id,opp);
                                system.debug('Exam Registration total update: ' + Opp);
                            }
                                
                        }
                    }
                }
                
                if ((con.recordTypeId == FRMExamTypeId || con.recordTypeId == ERPExamTypeId) && con.status.indexof('Canceled') == -1 && con.status.indexof('Draft') == -1) {
                    
                    system.debug('* * * FRM/ERP NOT Canceled nor Draft Contract3:'+con);
                    
                    for (Opportunity opp: lstOpportunityEligible) {
                        
                        system.debug('exam reg calc opp:'+opp);
                        //ID used = acctOppMap.get(opp.Id);
                            
                        if (opp.AccountId == con.AccountId) {
                            Boolean found=false;
                            for (OpportunityLineItem ol: opp.OpportunityLineItems) {
                                
                                if (ol.PricebookEntry.Product2.ProductCode == 'ENCL' || 
                                    ol.PricebookEntry.Product2.ProductCode == 'ENCE' || 
                                    ol.PricebookEntry.Product2.ProductCode == 'ENCS')
                                    found=true;
                                
                                if (ol.PricebookEntry.Product2.ProductCode == 'FRM1E' || 
                                    ol.PricebookEntry.Product2.ProductCode == 'FRM1S' || 
                                    ol.PricebookEntry.Product2.ProductCode == 'FRM1L' ||
                                    ol.PricebookEntry.Product2.Product_ID__c == '1155' || 
                                    ol.PricebookEntry.Product2.Product_ID__c == '943' ||
                                    ol.PricebookEntry.Product2.Product_ID__c == '682')
                                    found=true;
                                
                                if (ol.PricebookEntry.Product2.ProductCode == 'FRM2E' || 
                                    ol.PricebookEntry.Product2.ProductCode == 'FRM2S' || 
                                    ol.PricebookEntry.Product2.ProductCode == 'FRM2L' || 
                                    ol.PricebookEntry.Product2.Product_ID__c == '1156')
                                    found=true;
                                
                            }
                            system.debug('found reg:'+found); 
                            
                            if(found) {
                                updateOppMap.put(opp.Id,opp);
                                system.debug('Exam Registration total update: ' + Opp);
                            }
                                
                        }
                    }
                }
                
                if (con.recordTypeId == MembershipTypeId && con.status.indexof('Activated') > -1 && (con.Membership_Type__c == 'Individual' || con.Membership_Type__c == 'Student')) {
                    if (objContact.MailingCountry != 'Canada') {
	                    objContact.Email_Member_Update__c = true;
                    }
                    system.debug('Email_Member_Update__c: ' + objContact.Email_Member_Update__c);
                } else if (con.recordTypeId == MembershipTypeId && con.status.indexof('Expired') > -1 && (con.Membership_Type__c == 'Individual' || con.Membership_Type__c == 'Student')) {
                    objContact.Email_Member_Update__c = false;
                    system.debug('Email_Member_Update__c: ' + objContact.Email_Member_Update__c);
                }
                
                if (con.recordTypeId == MembershipTypeId && con.status.indexof('Canceled') == -1 && con.status.indexof('Draft') == -1) {
                    
                    system.debug('* * * Membership NOT Canceled nor Draft Contract3:'+con);
                    objContact.KPI_Member__c = true;
                    
                    memCnt++;
                    Boolean comp = false;
                    Boolean pay = false;
                    String FirstOppPayType = Null;
                    Integer oppCount = 0;
                    Integer payCount = 0;
                    Integer renewCount = 0;
                    Integer compCount = 0;
                    Date lastRenawalDate;
                    String memberProduct=null;

                    //contractStartDateTime = datetime.newInstance(con.StartDate.year(), con.StartDate.month(),con.StartDate.day());
                    //contractEndDateTime = datetime.newInstance(con.EndDate.year(), con.EndDate.month(),con.EndDate.day());

                    objContact.KPI_Membership_Purchase_History__c = null;
                    ObjContact.Membership_Caluclated_Expiration_Date__c = null;
                    objContact.KPI_Membership_Contract_History__c = null;
                    Date lastExpDate = null;
                    String lastMemberType = null;
                    String lastMemberStatus = null;
                    Boolean hasPaid=false;
                    for (Opportunity opp: lstOpportunityEligible) {
                        
                        system.debug('calc opp:'+opp);
                        //ID used = acctOppMap.get(opp.Id);
                            
                        if (opp.AccountId == con.AccountId && opp.StageName.indexOf('Closed') > -1 && opp.StageName.indexOf('Lost') == -1) {
                            //acctOppMap.put(opp.Id,opp.AccountId);
                            Boolean found = false;
                            Decimal amount = 0.0;
                            for (OpportunityLineItem ol: opp.OpportunityLineItems) {
                                if (ol.PricebookEntry.Product2.ProductCode == '208' ||
                                    ol.PricebookEntry.Product2.ProductCode == '7' ||
                                    ol.PricebookEntry.Product2.ProductCode == '207' ||
                                    ol.PricebookEntry.Product2.ProductCode == '1129' ||
                                    ol.PricebookEntry.Product2.ProductCode == '4' ||
                                    ol.PricebookEntry.Product2.ProductCode == '944' ||
                                    ol.PricebookEntry.Product2.ProductCode == 'MEMS' ||
                                    ol.PricebookEntry.Product2.ProductCode == 'MEMI' ||
                                    ol.PricebookEntry.Product2.ProductCode == 'MEMC' ||
                                    ol.PricebookEntry.Product2.ProductCode == '395' ||
                                    ol.PricebookEntry.Product2.ProductCode == 'MEMF' ||
                                    ol.PricebookEntry.Product2.ProductCode == 'AFREE' ||
                                    ol.PricebookEntry.Product2.Product_ID__c == '181' ||
                                    ol.PricebookEntry.Product2.Product_ID__c == '209' ||
                                    ol.PricebookEntry.Product2.Product_ID__c == '5' ||
                                    ol.PricebookEntry.Product2.Product_ID__c == '6') {
                                    found = True;
                                    if(ol.PricebookEntry.Product2.Product_ID__c == '181' ||
                                            ol.PricebookEntry.Product2.Product_ID__c == '209' ||
                                            ol.PricebookEntry.Product2.Product_ID__c == '5' ||
                                            ol.PricebookEntry.Product2.Product_ID__c == '6') {
                                        memberProduct = ol.PricebookEntry.Product2.Product_ID__c;
                                    } else {
                                        memberProduct = ol.PricebookEntry.Product2.ProductCode;
                                    }
                                    amount += ol.TotalPrice;
                                    if(Opp.CloseDate >= con.StartDate && Opp.CloseDate < con.EndDate)
                                        oppCount++;
                                    break;
                                }
                            }
                            
                            if(memberProduct == '395' || memberProduct == '181' || memberProduct == '207' || memberProduct == '1129' || memberProduct == '4') {
                                memberProduct = 'MEMI';
                            } else if(memberProduct == '209' || memberProduct == '5') {
                                memberProduct = 'MEMC';
                            } else if(memberProduct == '208' || memberProduct == '7' || memberProduct == '6') {
                                memberProduct = 'MEMS';
                            } else if(memberProduct == '944' || (amount == 0.0 && memberProduct != 'AFREE')) {
                                memberProduct = 'MEMF';
                            } else if(memberProduct == '3') {
                                memberProduct = 'AFREE';
                            }
                            
                            
                            Boolean refund = false;
                            Decimal totalAmount = 0.0;
                            List<Product_Refunds__c> lPR = mapPR.get(opp.Id);
                            system.debug('Fix: ' + opp + ':' + lPR);                                
                            if(lPR != null) {
                                for(Product_Refunds__c pr :lPR) {
                                    if(pr.Refund_amount__c != null)
                                        totalAmount+=pr.Refund_amount__c;
                                }
                            }
                            if(totalAmount >= opp.Amount && lPR != null) {
                                refund = true;
                            }
                            
                            opp.Member_Status__c = null;
                            updateOppMap.put(opp.Id,opp);
                            system.debug('Member_Status__c: ' + Opp);
                            
                            if(refund == false && found == true) {
                            
                                if((opp.Display_Invoice_Number__c != Null && opp.Display_Invoice_Number__c.indexOf('ATM') == -1) && 
                                   (lastExpDate == null || (lastExpDate != null && opp.CloseDate > lastExpDate))) {
                                    
                                    Boolean Lapsed=false;
                                    if(lastExpDate != null && opp.CloseDate > lastExpDate) {
                                        Lapsed=true;
                                        
                                        // Expire Old Contract                                        
                                        DateTime laspedDateTime = datetime.newInstance(lastExpDate.year(), lastExpDate.month(),lastExpDate.day());
                                        String newStatus = '[' + laspedDateTime.format('dd/MM/yyyy') + '~' + lastMemberType + '~' + abbrevMap.get('Expired') + ']:';
                                        if(objContact.KPI_Membership_Contract_History__c == null) {
                                            objContact.KPI_Membership_Contract_History__c = newStatus;
                                        } else {
                                            if(objContact.KPI_Membership_Contract_History__c.length() + newStatus.length() > 255)
                                                objContact.KPI_Membership_Contract_History__c = objContact.KPI_Membership_Contract_History__c.subString((objContact.KPI_Membership_Contract_History__c.length() + newStatus.length()-255), objContact.KPI_Membership_Contract_History__c.length());
                                            objContact.KPI_Membership_Contract_History__c += newStatus;
                                        }
                                        system.debug('lastExpDate Expire: ' + objContact.KPI_Membership_Contract_History__c);
                                    }

                                    // Start New Contract                                    
                                    DateTime closeDateTime = datetime.newInstance(opp.CloseDate.year(), opp.CloseDate.month(),opp.CloseDate.day());
                                    lastExpDate = opp.CloseDate.addDays(365);
                                    //lastMemberType = memberProduct;
                                    
                                    String newStatus = '[' + closeDateTime.format('dd/MM/yyyy') + '~' + memberProduct + ']';
                                    if(objContact.KPI_Membership_Contract_History__c == null) {
                                        objContact.KPI_Membership_Contract_History__c = newStatus;
                                    } else {
                                        if(objContact.KPI_Membership_Contract_History__c.length() + newStatus.length() > 255)
                                            objContact.KPI_Membership_Contract_History__c = objContact.KPI_Membership_Contract_History__c.subString((objContact.KPI_Membership_Contract_History__c.length() + newStatus.length()-255), objContact.KPI_Membership_Contract_History__c.length());
                                        objContact.KPI_Membership_Contract_History__c += newStatus;
                                    }     
                                    
                                    system.debug('lastExpDate New: ' + objContact.KPI_Membership_Contract_History__c);
                                    
                                    opp.Member_Status__c=null;
                                    if(lastMemberStatus == null) {
                                        if(memberProduct == 'MEMI' || memberProduct == 'MEMC' || memberProduct == 'MEMS') {
                                            
                                            system.debug('Member_Status__c1:');
                                                         
                                            opp.Member_Status__c = statusMap.get(memberProduct) + ' New Paid';
                                            
                                            objContact.KPI_Membership_Original_Business_Type__c = 'New Business';
                                            objContact.KPI_Membership_Original_Source__c = 'Member Registration';
                                            objContact.KPI_Membership_Original_Type__c = statusMap.get(memberProduct);
                                            
                                            objContact.KPI_Membership_Business_Type__c = 'New Business';
                                            objContact.KPI_Membership_Source__c = 'Member Registration';
                                            objContact.Membership_Type__c = statusMap.get(memberProduct);
                                            
                                            objContact.KPI_Membership_Since__c = opp.CloseDate;
                                            hasPaid=true;
                                            
                                        } else if(memberProduct == 'MEMF') {
                                            
                                            system.debug('Member_Status__c2:');
                                            
                                            opp.Member_Status__c = statusMap.get(memberProduct) + ' New Comp';    

                                            objContact.KPI_Membership_Original_Business_Type__c = 'Exam Comp';
                                            objContact.KPI_Membership_Original_Source__c = 'FRM/ERP Registration';
                                            objContact.KPI_Membership_Original_Type__c = statusMap.get(memberProduct);

                                            objContact.KPI_Membership_Business_Type__c = 'Exam Comp';
                                            objContact.KPI_Membership_Source__c = 'FRM/ERP Registration';
                                            objContact.Membership_Type__c = statusMap.get(memberProduct);
                                            compCount++;
                                            
                                            system.debug('* * * compCount1:' + compCount);
                                            
                                        } else {
                                            
                                            system.debug('Member_Status__c3:');
                                            
                                            opp.Member_Status__c = statusMap.get(memberProduct) + ' New';    
                                            
                                            objContact.KPI_Membership_Original_Business_Type__c = NULL;
                                            objContact.KPI_Membership_Original_Source__c = NULL;
                                            objContact.KPI_Membership_Original_Type__c = statusMap.get(memberProduct);
                                            
                                            objContact.KPI_Membership_Business_Type__c = NULL;
                                            objContact.KPI_Membership_Source__c = NULL;
                                            objContact.Membership_Type__c = statusMap.get(memberProduct);   

                                            objContact.KPI_Membership_Since__c = opp.CloseDate;
                                        }                                        
                                    } else {
                                        if(!hasPaid && (memberProduct == 'MEMI' || memberProduct == 'MEMC' || memberProduct == 'MEMS')) {
                                               
                                            system.debug('Member_Status__c4:');
                                                                                              
                                            if(objContact.Membership_Type__c == 'Affiliate') {                                               
                                                objContact.KPI_Membership_Converted_Affiliate__c = true;
                                                opp.Member_Status__c = statusMap.get(memberProduct) + ' Affiliate Conversion';
                                            } else {
                                                objContact.KPI_Membership_Converted_Exam_Comp__c = true;
                                                opp.Member_Status__c = statusMap.get(memberProduct) + ' Exam Comp Conversion';
                                            }
                                                
                                            objContact.KPI_Membership_Business_Type__c = 'Conversion';
                                            objContact.KPI_Membership_Renewal_Type__c = 'Upgrade';
                                            objContact.Membership_Type__c = statusMap.get(memberProduct);
                                            objContact.KPI_Membership_Source__c = 'Member Registration';
                                            objContact.KPI_Membership_Renewal_Date__c = opp.CloseDate;
                                            //renewCount++;
                                            
                                            if(Lapsed)
                                                objContact.KPI_Membership_Since__c = opp.CloseDate;
                                            
                                            hasPaid = true;


                                        } else if(hasPaid && (memberProduct == 'MEMI' || memberProduct == 'MEMC' || memberProduct == 'MEMS')) {
                                               
                                            system.debug('Member_Status__c5:');
                                               
                                            opp.Member_Status__c = statusMap.get(memberProduct) + ' Renew';

                                            objContact.KPI_Membership_Business_Type__c = 'Renewal';

                                            if((lastMemberType == 'MEMI' || lastMemberType == 'MEMC') && memberProduct == 'MEMS')
                                               objContact.KPI_Membership_Renewal_Type__c = 'Downgrade';
                                            else objContact.KPI_Membership_Renewal_Type__c = 'Same';

                                            objContact.Membership_Type__c = statusMap.get(memberProduct);
                                            objContact.KPI_Membership_Source__c = 'Member Registration';
                                            objContact.KPI_Membership_Renewal_Date__c = opp.CloseDate;
                                            renewCount++;

                                            if(Lapsed)
                                                objContact.KPI_Membership_Since__c = opp.CloseDate;
                                               
                                            hasPaid = true;
                                            
                                        } else if(memberProduct == 'MEMF') {
                                            
                                            system.debug('Member_Status__c6:');
                                            
                                            opp.Member_Status__c = statusMap.get(memberProduct) + ' Comp';
                                            objContact.Membership_Type__c = statusMap.get(memberProduct);
                                            if(objContact.KPI_Membership_Business_Type__c == NULL) {
                                                objContact.KPI_Membership_Business_Type__c = 'Exam Comp';
                                                objContact.KPI_Membership_Source__c = 'FRM/ERP Registration';
                                            }
                                            compCount++;
                                        }                                           
                                    }
                                    lastMemberStatus = opp.Member_Status__c;
                                    updateOppMap.put(opp.Id,opp);
                                    system.debug('Member_Status__c: ' + Opp);
                                
                                } else if(lastExpDate != NULL) {
                                    
                                    // Changed Type without Lapsing
                                    if(abbrevMap.get(lastMemberType) != abbrevMap.get(memberProduct)) {

                                        // Cancel Old Contract                                        
                                        DateTime laspedDateTime = datetime.newInstance(lastExpDate.year(), lastExpDate.month(),lastExpDate.day());
                                        String newStatus = '[' + laspedDateTime.format('dd/MM/yyyy') + '~' + lastMemberType + '~' + abbrevMap.get('Canceled') + ']:';
                                        if(objContact.KPI_Membership_Contract_History__c == null) {
                                            objContact.KPI_Membership_Contract_History__c = newStatus;
                                        } else {
                                            if(objContact.KPI_Membership_Contract_History__c.length() + newStatus.length() > 255)
                                                objContact.KPI_Membership_Contract_History__c = objContact.KPI_Membership_Contract_History__c.subString((objContact.KPI_Membership_Contract_History__c.length() + newStatus.length()-255), objContact.KPI_Membership_Contract_History__c.length());
                                            objContact.KPI_Membership_Contract_History__c += newStatus;
                                        }
                                        system.debug('lastExpDate Changed Type cancel: ' + objContact.KPI_Membership_Contract_History__c);
                                        
                                        // Start New Contract                                    
                                        DateTime closeDateTime = datetime.newInstance(opp.CloseDate.year(), opp.CloseDate.month(),opp.CloseDate.day());
                                        lastExpDate = opp.CloseDate.addDays(365);
                                        //lastMemberType = memberProduct;
                                        
                                        newStatus = '[' + closeDateTime.format('dd/MM/yyyy') + '~' + memberProduct + ']';
                                        if(objContact.KPI_Membership_Contract_History__c == null) {
                                            objContact.KPI_Membership_Contract_History__c = newStatus;
                                        } else {
                                            if(objContact.KPI_Membership_Contract_History__c.length() + newStatus.length() > 255)
                                                objContact.KPI_Membership_Contract_History__c = objContact.KPI_Membership_Contract_History__c.subString((objContact.KPI_Membership_Contract_History__c.length() + newStatus.length()-255), objContact.KPI_Membership_Contract_History__c.length());
                                            objContact.KPI_Membership_Contract_History__c += newStatus;
                                        }     
                                        
                                        system.debug('lastExpDate New: ' + objContact.KPI_Membership_Contract_History__c);
                                        
                                        
                                    } else {
                                        
                                        // ReNew Contract
                                        lastExpDate = lastExpDate.addDays(365);
                                        //lastMemberType = memberProduct;    
                                        
                                    }
                                    opp.Member_Status__c=null;
                                    if(lastMemberStatus == null) {
                                        if(memberProduct == 'MEMI' || memberProduct == 'MEMC' || memberProduct == 'MEMS') {
                                            
                                            system.debug('Member_Status__c1:');
                                                         
                                            opp.Member_Status__c = statusMap.get(memberProduct) + ' New Paid';
                                            
                                            objContact.KPI_Membership_Original_Business_Type__c = 'New Business';
                                            objContact.KPI_Membership_Original_Source__c = 'Member Registration';
                                            objContact.KPI_Membership_Original_Type__c = statusMap.get(memberProduct);
                                            
                                            objContact.KPI_Membership_Business_Type__c = 'New Business';
                                            objContact.KPI_Membership_Source__c = 'Member Registration';
                                            objContact.Membership_Type__c = statusMap.get(memberProduct);
                                            
                                            objContact.KPI_Membership_Since__c = opp.CloseDate;
                                            hasPaid=true;
                                            
                                        } else if(memberProduct == 'MEMF') {
                                            
                                            system.debug('Member_Status__c2:');
                                            
                                            opp.Member_Status__c = statusMap.get(memberProduct) + ' New Comp';    

                                            objContact.KPI_Membership_Original_Business_Type__c = 'Exam Comp';
                                            objContact.KPI_Membership_Original_Source__c = 'FRM/ERP Registration';
                                            objContact.KPI_Membership_Original_Type__c = statusMap.get(memberProduct);

                                            objContact.KPI_Membership_Business_Type__c = 'Exam Comp';
                                            objContact.KPI_Membership_Source__c = 'FRM/ERP Registration';
                                            objContact.Membership_Type__c = statusMap.get(memberProduct);
                                            compCount++;
                                            
                                            system.debug('* * * compCount1:' + compCount);
                                            
                                        } else {
                                            
                                            system.debug('Member_Status__c3:');
                                            
                                            opp.Member_Status__c = statusMap.get(memberProduct) + ' New';    
                                            
                                            objContact.KPI_Membership_Original_Business_Type__c = NULL;
                                            objContact.KPI_Membership_Original_Source__c = NULL;
                                            objContact.KPI_Membership_Original_Type__c = statusMap.get(memberProduct);
                                            
                                            objContact.KPI_Membership_Business_Type__c = NULL;
                                            objContact.KPI_Membership_Source__c = NULL;
                                            objContact.Membership_Type__c = statusMap.get(memberProduct);   

                                            objContact.KPI_Membership_Since__c = opp.CloseDate;
                                        }                                        
                                    } else {
                                        if(!hasPaid && (memberProduct == 'MEMI' || memberProduct == 'MEMC' || memberProduct == 'MEMS')) {
                                               
                                            system.debug('Member_Status__c4:');
                                                                                              
                                            if(objContact.Membership_Type__c == 'Affiliate') {                                               
                                                objContact.KPI_Membership_Converted_Affiliate__c = true;
                                                opp.Member_Status__c = statusMap.get(memberProduct) + ' Affiliate Conversion';
                                            } else {
                                                objContact.KPI_Membership_Converted_Exam_Comp__c = true;
                                                opp.Member_Status__c = statusMap.get(memberProduct) + ' Exam Comp Conversion';
                                            }
                                                
                                            objContact.KPI_Membership_Business_Type__c = 'Conversion';
                                            objContact.KPI_Membership_Renewal_Type__c = 'Upgrade';
                                            objContact.Membership_Type__c = statusMap.get(memberProduct);
                                            objContact.KPI_Membership_Source__c = 'Member Registration';
                                            objContact.KPI_Membership_Renewal_Date__c = opp.CloseDate;
                                            //renewCount++;
                                            
                                            //if(Lapsed)
                                            //    objContact.KPI_Membership_Since__c = opp.CloseDate;
                                            
                                            hasPaid = true;


                                        } else if(hasPaid && (memberProduct == 'MEMI' || memberProduct == 'MEMC' || memberProduct == 'MEMS')) {
                                               
                                            system.debug('Member_Status__c5:');
                                               
                                            opp.Member_Status__c = statusMap.get(memberProduct) + ' Renew';

                                            objContact.KPI_Membership_Business_Type__c = 'Renewal';

                                            if((lastMemberType == 'MEMI' || lastMemberType == 'MEMC') && memberProduct == 'MEMS')
                                               objContact.KPI_Membership_Renewal_Type__c = 'Downgrade';
                                            else objContact.KPI_Membership_Renewal_Type__c = 'Same';

                                            objContact.Membership_Type__c = statusMap.get(memberProduct);
                                            objContact.KPI_Membership_Source__c = 'Member Registration';
                                            objContact.KPI_Membership_Renewal_Date__c = opp.CloseDate;
                                            renewCount++;

                                            //if(Lapsed)
                                            //    objContact.KPI_Membership_Since__c = opp.CloseDate;
                                               
                                            hasPaid = true;
                                            
                                        } else if(memberProduct == 'MEMF') {
                                            
                                            system.debug('Member_Status__c6:');
                                            
                                            opp.Member_Status__c = statusMap.get(memberProduct) + ' Comp';
                                            objContact.Membership_Type__c = statusMap.get(memberProduct);
                                            if(objContact.KPI_Membership_Business_Type__c == NULL) {
                                                objContact.KPI_Membership_Business_Type__c = 'Exam Comp';
                                                objContact.KPI_Membership_Source__c = 'FRM/ERP Registration';
                                            }
                                            compCount++;
                                        }                                           
                                    }
                                    lastMemberStatus = opp.Member_Status__c;
                                    updateOppMap.put(opp.Id,opp);
                                    system.debug('Member_Status__c: ' + Opp);
                                    

                                } else {
                                    // ATM is the First Contract
                                    // Start New Contract                                    
                                    DateTime closeDateTime = datetime.newInstance(opp.CloseDate.year(), opp.CloseDate.month(),opp.CloseDate.day());
                                    lastExpDate = opp.CloseDate.addDays(365);
                                    //lastMemberType = memberProduct;
                                    
                                    String newStatus = '[' + closeDateTime.format('dd/MM/yyyy') + '~' + memberProduct + ']';
                                    if(objContact.KPI_Membership_Contract_History__c == null) {
                                        objContact.KPI_Membership_Contract_History__c = newStatus;
                                    } else {
                                        if(objContact.KPI_Membership_Contract_History__c.length() + newStatus.length() > 255)
                                            objContact.KPI_Membership_Contract_History__c = objContact.KPI_Membership_Contract_History__c.subString((objContact.KPI_Membership_Contract_History__c.length() + newStatus.length()-255), objContact.KPI_Membership_Contract_History__c.length());
                                        objContact.KPI_Membership_Contract_History__c += newStatus;
                                    }     
                                    
                                    system.debug('lastExpDate New: ' + objContact.KPI_Membership_Contract_History__c);
                                    
                                    opp.Member_Status__c=null;
                                    if(lastMemberStatus == null) {
                                        if(memberProduct == 'MEMI' || memberProduct == 'MEMC' || memberProduct == 'MEMS') {
                                            
                                            system.debug('Member_Status__c1:');
                                                         
                                            opp.Member_Status__c = statusMap.get(memberProduct) + ' New Paid';
                                            
                                            objContact.KPI_Membership_Original_Business_Type__c = 'New Business';
                                            objContact.KPI_Membership_Original_Source__c = 'Member Registration';
                                            objContact.KPI_Membership_Original_Type__c = statusMap.get(memberProduct);
                                            
                                            objContact.KPI_Membership_Business_Type__c = 'New Business';
                                            objContact.KPI_Membership_Source__c = 'Member Registration';
                                            objContact.Membership_Type__c = statusMap.get(memberProduct);
                                            
                                            objContact.KPI_Membership_Since__c = opp.CloseDate;
                                            hasPaid=true;
                                            
                                        } else if(memberProduct == 'MEMF') {
                                            
                                            system.debug('Member_Status__c2:');
                                            
                                            opp.Member_Status__c = statusMap.get(memberProduct) + ' New Comp';    

                                            objContact.KPI_Membership_Original_Business_Type__c = 'Exam Comp';
                                            objContact.KPI_Membership_Original_Source__c = 'FRM/ERP Registration';
                                            objContact.KPI_Membership_Original_Type__c = statusMap.get(memberProduct);

                                            objContact.KPI_Membership_Business_Type__c = 'Exam Comp';
                                            objContact.KPI_Membership_Source__c = 'FRM/ERP Registration';
                                            objContact.Membership_Type__c = statusMap.get(memberProduct);
                                            compCount++;
                                            
                                            system.debug('* * * compCount1:' + compCount);
                                            
                                        } else {
                                            
                                            system.debug('Member_Status__c3:');
                                            
                                            opp.Member_Status__c = statusMap.get(memberProduct) + ' New';    
                                            
                                            objContact.KPI_Membership_Original_Business_Type__c = NULL;
                                            objContact.KPI_Membership_Original_Source__c = NULL;
                                            objContact.KPI_Membership_Original_Type__c = statusMap.get(memberProduct);
                                            
                                            objContact.KPI_Membership_Business_Type__c = NULL;
                                            objContact.KPI_Membership_Source__c = NULL;
                                            objContact.Membership_Type__c = statusMap.get(memberProduct);   

                                            objContact.KPI_Membership_Since__c = opp.CloseDate;
                                        }                                        
                                    } else {
                                        if(!hasPaid && (memberProduct == 'MEMI' || memberProduct == 'MEMC' || memberProduct == 'MEMS')) {
                                               
                                            system.debug('Member_Status__c4:');
                                                                                              
                                            if(objContact.Membership_Type__c == 'Affiliate') {                                               
                                                objContact.KPI_Membership_Converted_Affiliate__c = true;
                                                opp.Member_Status__c = statusMap.get(memberProduct) + ' Affiliate Conversion';
                                            } else {
                                                objContact.KPI_Membership_Converted_Exam_Comp__c = true;
                                                opp.Member_Status__c = statusMap.get(memberProduct) + ' Exam Comp Conversion';
                                            }
                                                
                                            objContact.KPI_Membership_Business_Type__c = 'Conversion';
                                            objContact.KPI_Membership_Renewal_Type__c = 'Upgrade';
                                            objContact.Membership_Type__c = statusMap.get(memberProduct);
                                            objContact.KPI_Membership_Source__c = 'Member Registration';
                                            objContact.KPI_Membership_Renewal_Date__c = opp.CloseDate;
                                            //renewCount++;
                                            
                                            //if(Lapsed)
                                            //    objContact.KPI_Membership_Since__c = opp.CloseDate;
                                            
                                            hasPaid = true;


                                        } else if(hasPaid && (memberProduct == 'MEMI' || memberProduct == 'MEMC' || memberProduct == 'MEMS')) {
                                               
                                            system.debug('Member_Status__c5:');
                                               
                                            opp.Member_Status__c = statusMap.get(memberProduct) + ' Renew';

                                            objContact.KPI_Membership_Business_Type__c = 'Renewal';

                                            if((lastMemberType == 'MEMI' || lastMemberType == 'MEMC') && memberProduct == 'MEMS')
                                               objContact.KPI_Membership_Renewal_Type__c = 'Downgrade';
                                            else objContact.KPI_Membership_Renewal_Type__c = 'Same';

                                            objContact.Membership_Type__c = statusMap.get(memberProduct);
                                            objContact.KPI_Membership_Source__c = 'Member Registration';
                                            objContact.KPI_Membership_Renewal_Date__c = opp.CloseDate;
                                            renewCount++;

                                            //if(Lapsed)
                                            //    objContact.KPI_Membership_Since__c = opp.CloseDate;
                                               
                                            hasPaid = true;
                                            
                                        } else if(memberProduct == 'MEMF') {
                                            
                                            system.debug('Member_Status__c6:');
                                            
                                            opp.Member_Status__c = statusMap.get(memberProduct) + ' Comp';
                                            objContact.Membership_Type__c = statusMap.get(memberProduct);
                                            if(objContact.KPI_Membership_Business_Type__c == NULL) {
                                                objContact.KPI_Membership_Business_Type__c = 'Exam Comp';
                                                objContact.KPI_Membership_Source__c = 'FRM/ERP Registration';
                                            }
                                            compCount++;
                                        }                                           
                                    }
                                    lastMemberStatus = opp.Member_Status__c;
                                    updateOppMap.put(opp.Id,opp);
                                    system.debug('Member_Status__c: ' + Opp);

                                }
                                lastMemberType = memberProduct;
                                system.debug('lastMemberType:' + lastMemberType); 
                                             
                            }
                                                        
                            system.debug('precalc1:' + compCount + ':' + found + ':' + amount + ':' + oppCount + ':' + refund + ':' + memberProduct + ':' + totalAmount + ':' + lastExpDate);
                            
                            // Purchases Found
                            if (found == True && refund == false) {
                                
                                Datetime oppClodeDateTime = datetime.newInstance(Opp.CloseDate.year(), Opp.CloseDate.month(),Opp.CloseDate.day());
                                
                                String newStatus;
                                if((objContact.KPI_Membership_Purchase_History__c == null || objContact.KPI_Membership_Purchase_History__c.indexOf('*') == -1) && amount > 0) {
                                    newStatus = '[' + oppClodeDateTime.format('dd/MM/yyyy') + '*' + memberProduct + ']';
                                } else {
                                    newStatus = '[' + oppClodeDateTime.format('dd/MM/yyyy') + '~' + memberProduct + ']';    
                                }
                                
                                if(objContact.KPI_Membership_Purchase_History__c == null) {
                                    objContact.KPI_Membership_Purchase_History__c = newStatus;
                                } else {
                                    if(objContact.KPI_Membership_Purchase_History__c.length() + newStatus.length() > 255)
                                        objContact.KPI_Membership_Purchase_History__c = objContact.KPI_Membership_Purchase_History__c.subString((objContact.KPI_Membership_Purchase_History__c.length() + newStatus.length()-255), objContact.KPI_Membership_Purchase_History__c.length());
                                    objContact.KPI_Membership_Purchase_History__c += newStatus;
                                }
                                    

                                system.debug('KPI_Membership_Purchase_History__c:' + opp.Id + ':' + objContact.KPI_Membership_Purchase_History__c);
                                
                                //if(Opp.CloseDate >= con.StartDate && Opp.CloseDate < con.EndDate) {
                                //    if (amount > 0) {
                                //        pay = true;
                                //        payCount++;
                                //        lastRenawalDate = Opp.CloseDate;                                        
                                //        if (FirstOppPayType == Null)
                                //            FirstOppPayType = 'pay';
                                //    } else {
                                //        comp = true;
                                //        if (FirstOppPayType == Null)
                                //            FirstOppPayType = 'comp';
                                //    }
                                //}
                            }
                        }
                    }

                    system.debug('* * * compCount:' + compCount);
                    
                    if(compCount>0)
                        objContact.KPI_Membership_Comp_Count__c = compCount;
                    if(renewCount>0)
                        objContact.KPI_Membership_Renew_Count__c = renewCount;
                    
                    
                    
                    system.debug('* * * Contracts:' + con.Id + ':' + comp + ':' + pay + ':' + firstMemberContract + ':' + FirstOppPayType + ':' + oppCount + ':' + renewalCount);

                    // Complete Contract History
                    if(lastExpDate != null) {
                        DateTime lastExpDateTime = datetime.newInstance(lastExpDate.year(), lastExpDate.month(),lastExpDate.day());
                        
                        String newStatus;
                        if(lastExpDate < Date.today())
                            newStatus = '[' + lastExpDateTime.format('dd/MM/yyyy') + '~' + memberProduct + '~Exp]';
                        else newStatus = '[' + lastExpDateTime.format('dd/MM/yyyy') + '~' + memberProduct + '~Active]';
                        
                        if(objContact.KPI_Membership_Contract_History__c == null) {
                            objContact.KPI_Membership_Contract_History__c = newStatus;
                        } else {
                            if(objContact.KPI_Membership_Contract_History__c.length() + newStatus.length() > 255)
                                objContact.KPI_Membership_Contract_History__c = objContact.KPI_Membership_Contract_History__c.subString((objContact.KPI_Membership_Contract_History__c.length() + newStatus.length()-255), objContact.KPI_Membership_Contract_History__c.length());
                            objContact.KPI_Membership_Contract_History__c += newStatus;
                        }     
                        
                        system.debug('lastExpDate Active: ' + objContact.KPI_Membership_Contract_History__c);
                    }
                    ObjContact.Membership_Caluclated_Expiration_Date__c = lastExpDate;
                    
                    // moved
                    //if (memberSinceContract == null)
                    //    memberSinceContract = con.StartDate;

                    //if (lastContract != null && lastContract.status.indexof('Canceled') == -1)
                    //    memberSinceContract = con.StartDate;
                            

                    //if(objContact.KPI_Membership_Contract_History__c == null) {
                    //    objContact.KPI_Membership_Contract_History__c = '[' + contractStartDateTime.format('dd/MM/yyyy') + '*' + abbrevMap.get(con.Membership_Type__c) + ']';
                    //} else {
                    //    String newStatus = '[' + contractStartDateTime.format('dd/MM/yyyy') + '~' + abbrevMap.get(con.Membership_Type__c) + ']';
                    //    if(objContact.KPI_Membership_Contract_History__c.length() + newStatus.length() > 255)
                    //        objContact.KPI_Membership_Contract_History__c = objContact.KPI_Membership_Contract_History__c.subString((objContact.KPI_Membership_Contract_History__c.length() + newStatus.length()-255), objContact.KPI_Membership_Contract_History__c.length());
                    //    objContact.KPI_Membership_Contract_History__c += newStatus;
                    //} 
                                        
                    //Activated
                    if (con.status.indexof('Activated') > -1) {
    
                        system.debug('* * * Active Contract:' + con.id + ':' + con.recordTypeId);
                        
                        objContact.KPI_Membership_Payment_Status__c = 'In Good Standing';
                        objContact.KPI_Membership_Payment_Lapsed_Months__c = null;
    
                        if (lastContract == null)
                            memberSinceContract = con.StartDate;
                        
                        system.debug('* * * Member:' + con.Membership_Type__c);
                        objContact.KPI_Member__c = true;
                        objContact.Membership_Type__c = con.Membership_Type__c;
                        //if (con.Membership_Type__c == 'Individual') {
                        //    objContact.CVent_Contact_Type__c = 'Member';
                        //}
                        //if(objContact.KPI_Membership_Since__c == NULL)
                        //  objContact.KPI_Membership_Since__c = con.StartDate;
                        
                        objContact.KPI_Membership_Expiration_Date__c = con.EndDate;
                        
                        Opportunity currOpp = currOppMap.get(con.Opportunity__c);
                        if(currOpp != null) {
                            currOpp.Member_Expire_Date__c = con.EndDate;
                            updateOppMap.put(currOpp.Id,currOpp);
                        }

                    }
                
                    //Lapsed or Expired
                    system.debug('* * * Lapsed?:' + nowDateTime + ':' + con.EndDate + ':' + objContact.Id + ':' + objContact.Id);
                    
                    if (con.status.indexof('Expired') > -1 || nowDateTime > con.EndDate) {
    
                        system.debug('* * * Expired Contract:' + con.id + ':' + con.recordTypeId);
    
                        //String newStatus = '[' + contractEndDateTime.format('dd/MM/yyyy') + '~' + abbrevMap.get(con.Membership_Type__c) + '~' + abbrevMap.get('Expired') + ']';
                        
                        //if(objContact.KPI_Membership_Contract_History__c == null) {
                        //    objContact.KPI_Membership_Contract_History__c = newStatus;
                        //} else {
                        //    if(objContact.KPI_Membership_Contract_History__c.length() + newStatus.length() > 255)
                        //      objContact.KPI_Membership_Contract_History__c = objContact.KPI_Membership_Contract_History__c.subString((objContact.KPI_Membership_Contract_History__c.length() + newStatus.length()-255), objContact.KPI_Membership_Contract_History__c.length());
                        //  objContact.KPI_Membership_Contract_History__c += newStatus;
                        //} 

                        Integer monthDiff = con.EndDate.monthsBetween(nowDateTime);
                        objContact.KPI_Membership_Payment_Lapsed_Months__c = monthDiff;
                        objContact.KPI_Membership_Payment_Status__c = 'Lapsed';      
                        system.debug('* * * Set Lapsed:' + objContact.KPI_Membership_Payment_Status__c);
                        
                        //if (con.recordTypeId == MembershipTypeId) {
                        //    system.debug('* * * Member:' + con.Membership_Type__c);
                        //    objContact.KPI_Member__c = true;
                        //    objContact.Membership_Type__c = con.Membership_Type__c;
                        //    if (con.Membership_Type__c == 'Individual') {
                        //        objContact.CVent_Contact_Type__c = 'Member';
                        //    }
                        //    objContact.KPI_Membership_Since__c = con.StartDate;
                            objContact.KPI_Membership_Expiration_Date__c = con.EndDate;
                        //}
                    }

                    //if (firstMemberContract != null) {
                    //    if ((lastUserType == 'Affiliate' && con.Membership_Type__c != 'Affiliate') ||
                    //        (lastUserType == 'Student' && con.Membership_Type__c == 'Individual')) {
                    //        objContact.KPI_Membership_Renewal_Type__c = 'Upgrade';
                    //    } else if (lastUserType == con.Membership_Type__c) {
                    //        objContact.KPI_Membership_Renewal_Type__c = 'Same';
                    //    } else {
                    //        objContact.KPI_Membership_Renewal_Type__c = 'Downgrade';
                    //    }
                    //}

                    //if (firstMemberContract == null) {
                        //firstMemberContract = con;

                        //objContact.KPI_Membership_Original_Type__c = firstMemberContract.Membership_Type__c;
                        
                        //objContact.Date_Joined__c = con.StartDate;
                        //if (FirstOppPayType == 'pay') {
                        //    objContact.KPI_Membership_Original_Business_Type__c = 'New Business';
                        //    objContact.KPI_Membership_Original_Source__c = 'Registration';
                        //    objContact.KPI_Membership_Source__c = 'Registration';
                        //    if (oppCount == 1) {
                        //        objContact.KPI_Membership_Business_Type__c = 'New Business';
                        //    }
                        //} else if (FirstOppPayType == 'comp') {
                        //    objContact.KPI_Membership_Original_Business_Type__c = 'Exam Comp';
                        //    objContact.KPI_Membership_Original_Source__c = 'FRM/ERP Program';
                        //    objContact.KPI_Membership_Source__c = 'FRM/ERP Program';
                        //    if (oppCount == 1) {
                        //        objContact.KPI_Membership_Business_Type__c = 'Exam Comp';
                        //    }
                        //}
                        //if (oppCount > 1) {
                        //    renewalCount += payCount;
                        //    objContact.KPI_Membership_Renewal_Date__c = lastRenawalDate;
                        //    if (FirstOppPayType == 'comp' && pay == true)
                        //        objContact.KPI_Membership_Business_Type__c = 'Conversion';
                        //    else if (pay == true)
                        //        objContact.KPI_Membership_Business_Type__c = 'Renewal';
                        //    else objContact.KPI_Membership_Business_Type__c = 'Exam Comp';
                        //}
                    //} else if (pay == true) {
                        //objContact.KPI_Membership_Source__c = 'Registration';
                        //renewalCount += payCount;
                        //objContact.KPI_Membership_Renewal_Date__c = lastRenawalDate;
                        // If not the first Contract and Paid
                        //if (objContact.KPI_Membership_Business_Type__c == 'Exam Comp')
                        //    objContact.KPI_Membership_Business_Type__c = 'Conversion';
                        //else objContact.KPI_Membership_Business_Type__c = 'Renewal';
                    //} else {
                        //objContact.KPI_Membership_Source__c = 'FRM/ERP Program';
                    //}

                    if (lastMemberContract == null && con.recordTypeId == MembershipTypeId) {
                        lastMemberContract = con;
                    }
                    if (lastMemberContract != null && con.recordTypeId == MembershipTypeId) {
                        if (con.StartDate > lastMemberContract.StartDate)
                            lastMemberContract = con;
                    }

                    system.debug('* * * lastUserType:' + lastUserType + ':' + con.Membership_Type__c);
                    lastUserType = con.Membership_Type__c;
                    lastContract = con;

                    if (renewalCount > 0) {
                        //objContact.KPI_Membership_Renewal_Count__c = string.valueof(renewalCount);
                    }
                }

            }

            if (lastMemberContract != null) {
                objContact.Membership_Last_Contract_Start_Date__c = lastMemberContract.StartDate;
            }

            if (frmCnt == 1) {
                if (frmCanceledCnt == 1)
                    objContact.KPI_FRM_Candidate_Business_Type__c = null;
                else objContact.KPI_FRM_Candidate_Business_Type__c = 'New';
            } else if (frmCnt > 1) {
                objContact.KPI_FRM_Candidate_Business_Type__c = 'Renewal';
            }

            if (erpCnt == 1) {
                if (erpCanceledCnt == 1)
                    objContact.KPI_ERP_Candidate_Business_Type__c = null;
                else objContact.KPI_ERP_Candidate_Business_Type__c = 'New';
            } else if (erpCnt > 1) {
                objContact.KPI_ERP_Candidate_Business_Type__c = 'Renewal';
            }

            system.debug('* * * objContact:' + objContact);

            if (objContact.KPI_Membership_Payment_Status__c == 'In Good Standing') {
                objContact.KPI_Membership_Since__c = memberSinceContract;
            } else {
                objContact.KPI_Membership_Since__c = null;
            }

            lstContacts.add(objContact);
        }

        if (lstContacts.size() > 0)
            update lstContacts;

        system.debug('updateOppMap: ' + updateOppMap);
        
        List<Opportunity> lstUpdateOpp = new List<Opportunity>();
        for(Opportunity op :updateOppMap.values()) {
            lstUpdateOpp.add(op);
        }
            

        system.debug('lstUpdateOpp: ' + lstUpdateOpp);
        update lstUpdateOpp;
    }

}