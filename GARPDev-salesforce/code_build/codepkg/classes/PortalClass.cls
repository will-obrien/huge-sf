public without sharing class PortalClass {

    public static decimal dTotalPrice = 0;

    public static string checkExamAttempts(Id examAttemptID, String strProdCode, String strGLCode, Boolean bWire) {
        return IsExamDeferred(examAttemptID, strProdCode, strGLCode, bWire);
    }
    public static boolean bFRM1Deffered = false;
    public static boolean bFRM2Deffered = false;
    public static boolean bERPDeffered = false;
    public static boolean bFRM1UnDeffered = false;
    public static boolean bFRM2UnDeffered = false;
    public static boolean bERPUnDeffered = false;
    public static boolean bERPCanSwitch = false;
    public static boolean bFRMCanSwitch = false;

    private static string IsExamDeferred(Id examAttemptID, String strProdCode, String strGLCode, Boolean bWire) {
        //try {
            Exam_Attempt__c objExamAttempt = [select id, Exam_Site__c, Candidate_Commitment__c, Candidate_Commitment__r.EndDate, Exam_Site__r.Exam_Date__c, Exam_Site__r.Site__r.Name, Defered__c, Candidate_Commitment__r.Accountid, Member__c from Exam_Attempt__c where id = : examAttemptID and Defered__c = : ''];
        
            system.debug('* * * objExamAttempt ...'+ objExamAttempt);
        
            return compareExamDates(objExamAttempt, strProdCode, strGLCode, bWire);
        //} catch (exception ex)

        //{
        //  return 'Error:This exam is already deferred';
        //}

    }

    private static string compareExamDates(Exam_Attempt__c objExamAttempt, String strProdCode, String strGLCode, Boolean bWire) {

        //try {

            string strIsraeil = 'Israel, Tel Aviv (Sunday)';
            Exam_Group__c objExamGrp = [select Deferral_Exam_Date__c, Last_Date_For_Late_Registration__c, Registration_Start_Date__c, Active__c, Israle_Deferral_Exam_Date__c from Exam_Group__c where Active__c = : true];

            system.debug('* * * objExamGrp ...'+ objExamGrp);
        
            if (objExamAttempt.Candidate_Commitment__r.EndDate < objExamGrp.Deferral_Exam_Date__c) {
                bFRM1Deffered = false;
                bFRM2Deffered = false;
                bERPDeffered = false;
                return 'Error:Contract End Date is less than exam deferred date';
            } else if (objExamAttempt.Exam_Site__r.Site__r.Name == strIsraeil && objExamAttempt.Candidate_Commitment__r.EndDate < objExamGrp.Israle_Deferral_Exam_Date__c) {

                bFRM1Deffered = false;
                bFRM2Deffered = false;
                bERPDeffered = false;
                return 'Error:Contract End Date is less than Israeil exam deferred date';
            } else if (system.today() > objExamGrp.Last_Date_For_Late_Registration__c) {

                bFRM1Deffered = false;
                bFRM2Deffered = false;
                bERPDeffered = false;
                return 'Error:Last date of registration is already completed';
            } else return createOppRecord(objExamAttempt, 'Deferred', strProdCode, strGLCode, bWire);
        //} catch (exception ex) {
        //  return 'compareExamDates:' + ex.getmessage();
        //}
        return '';
    }

    public static string createOppRecord(Exam_Attempt__c objExamAttempt, String strOppName, String strProdCode, String strGLCode, Boolean bWire) {

        Opportunity objOpp = new Opportunity();
        Id recordTypeID = RecordTypeHelper.GetRecordTypeId('Opportunity','Automated');
        
        Id accountId = objExamAttempt.Candidate_Commitment__r.AccountId;
        
        objOpp.Name = strOppName;
        objOpp.accountId = objExamAttempt.Candidate_Commitment__r.AccountId;
        objOpp.stagename = 'New Lead';
        objOpp.CloseDate = System.today();
        objOpp.RecordTypeId = recordTypeID;
        if (strOppName == 'Deferred') objOpp.EA_Id__c = objExamAttempt.id;
        else objOpp.Undefred_EA_Id__c = objExamAttempt.id;
        insert objOpp;        
        
        system.debug('* * * createOppLineItem ...'+ objOpp);
        
        Decimal totalCost = createOppLineItem(objOpp, strProdCode, strGLCode, bWire);

        system.debug('* * * totalCost ...'+ totalCost);
        
        List < Contact > lstContact = [SELECT Id, Name, FirstName, LastName, Email, HomePhone, Company__c, MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet, AccountId, GARP_ID__c, Membership_Type__c FROM Contact WHERE AccountId = :accountId];
        
        system.debug('* * * lstContact ...'+ lstContact);
        
        if (lstContact != null && lstContact.size() > 0) {

            List < Account > lstAcct = [select Id, Name, BillingCity, BillingCountry, BillingPostalCode, BillingState, BillingStreet from Account where Id = : lstContact[0].AccountId];

            system.debug('* * * lstAcct ...'+ lstAcct);
            
            if (lstAcct != null && lstAcct.size() > 0) {
                if(bWire)
                    objOpp.Alternate_Method_of_Payment__c = 'Wire';
                objOpp.ChargentSFA__Billing_Email__c = lstContact[0].Email;
                objOpp.ChargentSFA__Billing_First__c = lstContact[0].FirstName;
                objOpp.ChargentSFA__Billing_Last__c = lstContact[0].LastName;
                objOpp.ChargentSFA__Billing_Phone__c = lstContact[0].HomePhone;
                objOpp.ChargentSFA__Billing_Company__c = lstContact[0].Company__c;
                objOpp.ChargentSFA__Billing_Address__c = lstAcct[0].BillingStreet;
                objOpp.ChargentSFA__Billing_City__c = lstAcct[0].BillingCity;
                objOpp.ChargentSFA__Billing_State__c = lstAcct[0].BillingState;
                objOpp.ChargentSFA__Billing_Zip__c = lstAcct[0].BillingPostalCode;
                objOpp.ChargentSFA__Billing_Country__c = lstAcct[0].BillingCountry;
                objOpp.Shipping_First_Name__c = lstContact[0].FirstName;
                objOpp.Shipping_Last_Name__c = lstContact[0].LastName;
                objOpp.Shipping_E_mail__c = lstContact[0].Email;
                objOpp.Shipping_Company_Name__c = lstContact[0].Company__c;
                objOpp.Shipping_Phone_No__c = lstContact[0].HomePhone;
                objOpp.Shipping_Street__c = lstContact[0].MailingStreet;
                objOpp.Shipping_City__c = lstContact[0].MailingCity;
                objOpp.Shipping_State__c = lstContact[0].MailingState;
                objOpp.Shipping_Postal_Code__c = lstContact[0].MailingPostalCode;
                objOpp.Shipping_Country__c = lstContact[0].MailingCountry;

            }
            
        }
        objOpp.ChargentSFA__Charge_Amount__c = totalCost;
        
        system.debug('* * * Update objOpp ...'+ objOpp);
        
        update objOpp;
        
        if(!bWire)
            return createPaymentDetails(objOpp, objExamAttempt.Member__c);
        else return '';

    }


    private static Decimal createOppLineItem(Opportunity objOpp, string strProdCode, String strGLCode, Boolean bWire) {

        Decimal totalCost = 0;
        PriceBookEntry PricebookEntryId = [select unitprice, productcode, Product2.GL_Code__c from PriceBookEntry where Pricebook2.IsActive = true and productcode = : strProdCode and Product2.GL_Code__c = : strGLCode and isActive = true limit 1];        
        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = objOpp.Id;
        oppLineItem.PricebookEntryId = PricebookEntryId.Id;
        oppLineItem.Quantity = 1;
        oppLineItem.UnitPrice = PricebookEntryId.unitprice;
        totalCost = PricebookEntryId.unitprice;
        
        system.debug('* * * oppLineItem ...'+ oppLineItem + ':' + bWire);
        
        insert oppLineItem;
        if(bWire == true) {
        try
        {
            PriceBookEntry PricebookEntryId2 = [select unitprice, productcode, Product2.GL_Code__c from PriceBookEntry where  Pricebook2.IsActive = true and productcode = 'PRFEE' and isActive = true];
            
            system.debug('* * * PricebookEntryId2 ...'+ PricebookEntryId2);
            
            OpportunityLineItem oppLineItem2 = new OpportunityLineItem();
            oppLineItem2.OpportunityId = objOpp.Id;
            oppLineItem2.PricebookEntryId = PricebookEntryId2.Id;
            oppLineItem2.Quantity = 1;
            oppLineItem2.UnitPrice = PricebookEntryId2.unitprice;
            totalCost = totalCost + PricebookEntryId2.unitprice;
            
            system.debug('* * * oppLineItem2 ...'+ oppLineItem2);
            
            insert oppLineItem2;
        }
        catch(Exception ex)
        {
            
        }
        }
        
        return totalCost;
    }

    public static String createPaymentDetails(opportunity objOpp, Id contId) {

        ChargentSFA__Payment_Request__c objPayment = new ChargentSFA__Payment_Request__c();
        objPayment.ChargentSFA__Billing_Contact__c = contId;
        objPayment.ChargentSFA__Opportunity__c = objOpp.Id;
        
        system.debug('* * * objPayment ...'+ objPayment);
        
        insert objPayment;
        objPayment = [select id, name, ChargentSFA__Pay_Link__c from ChargentSFA__Payment_Request__c where id = :objPayment.Id];
        
        system.debug('* * * Select objPayment ...'+ objPayment);
        
        return objPayment.ChargentSFA__Pay_Link__c;
    }

    public static set < String > getAccountName() {

        id recordTypeId = RecordTypeHelper.GetRecordTypeId('Account', 'Business');
        set < String > lstAccountNames = new set < String > ();
        for (Account obj: [select id, recordTypeId, name from account where recordTypeId = : recordTypeId]) {
            lstAccountNames.add(obj.Name);
        }
        return lstAccountNames;

    }

    public static Id checkAccountExists(string strName) {

        try {
            Account objAccount = [select id, name from account where name = : strName];
            return createExperience(objAccount);
        } catch (exception ex) {
            return createAccount(strName);

        }
    }

    private static Id createAccount(String strName) {

        Account objNewAccount = new Account();
        objNewAccount.Name = strName;
        insert objNewAccount;
        return createExperience(objNewAccount);
    }

    private static Id createExperience(Account objAccount) {
        Experience__c objExp = new Experience__c();
        objExp.Company__c = objAccount.Id;
        objExp.Name = objAccount.Name;
        insert objExp;
        return objExp.Id;
    }

    public static Id getParentId() {

        List < Exam_Attempt__c > lstExamAttempt = null;
        try {
            User objUser = Utilities.getCurrentUserDetails();
            if (objUser.Contactid == null) return null;
            lstExamAttempt = [select id, Candidate_Commitment__c from Exam_Attempt__c where Member__c = : objUser.Contactid limit 1];
            if (lstExamAttempt == null) return null;
            Candidate_Requirement__c objCR = [select id, name from Candidate_Requirement__c where Candidate_Commitment__c = : lstExamAttempt[0].Candidate_Commitment__c and Name = : 'Job Requirement'
            limit 1];
            return objCR.Id;
        } catch (exception ex) {
            return null;
        }
        return null;

    }


    public static Set < String > getActiveExams() {

        Set < String > setActiveExams = new Set < String > ();
        try {

            User objUser = Utilities.getCurrentUserDetails();
            if (objUser.Contactid == null) return null;
            Contact objCon = [select id, accountId from contact where id = : objUser.Contactid];
            id frmRecTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'FRM Program');
            id erpRecTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'ERP Program');

            for (Contract objContract: [select id, Status, recordTypeId, startdate from Contract where Status like '%Activated%'
            and accountId = : objCon.accountId]) {
                if (objContract.startdate.year() == 2009) continue;
                if (objContract.RecordTypeId == frmRecTypeId) setActiveExams.add('FRM is activated');
                if (objContract.RecordTypeId == erpRecTypeId) setActiveExams.add('ERP is activated');
            }
            return setActiveExams;
        } catch (exception ex) {
            return null;
        }
        return null;

    }

    public static void getDefferedExams() {

        List < String > lstActiveExams = new List < String > ();
        List < Exam_Attempt__c > lstExamAttempt = null;
        try {
            User objUser = Utilities.getCurrentUserDetails();
            if (objUser.Contactid == null) return;
            id frmRecTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'FRM Program');
            id erpRecTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'ERP Program');
            boolean activeFRM = false;
            boolean activeERP = false;
            Exam_Group__c objExamGrp = [select Deferral_Exam_Date__c, Last_Date_For_Late_Registration__c, Registration_Start_Date__c, Active__c, Israle_Deferral_Exam_Date__c from Exam_Group__c where Active__c = : true];
            string strIsraeil = 'Israel, Tel Aviv (Sunday)';
            for (Exam_Attempt__c objEA: [select id, Candidate_Commitment__c, Candidate_Commitment__r.EndDate, program__c, Defered__c, Candidate_Commitment__r.RecordtypeId, Exam_Site__r.Exam__r.Exam_Group__r.Active__c, Exam_Site__r.Site__r.Name from Exam_Attempt__c where Member__c = : objUser.Contactid and Candidate_Commitment__r.Status like '%Activated%' and Cancelled__c !=true]) {
                if (objEA.program__c == frmRecTypeId) {
                    bFRM1Deffered = true;
                    bFRM2Deffered = true;

                    if (objEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c) activeFRM = true;
                } else if (objEA.program__c == erpRecTypeId) {
                    bERPDeffered = true;

                    if (objEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c) activeERP = true;
                }

                if (objEA.Candidate_Commitment__r.EndDate < objExamGrp.Deferral_Exam_Date__c) {
                    bFRM1Deffered = false;
                    bFRM2Deffered = false;
                    bERPDeffered = false;

                } else if (objEA.Exam_Site__r.Site__r.Name == strIsraeil && objEA.Candidate_Commitment__r.EndDate < objExamGrp.Israle_Deferral_Exam_Date__c) {

                    bFRM1Deffered = false;
                    bFRM2Deffered = false;
                    bERPDeffered = false;

                } else if (system.today() > objExamGrp.Last_Date_For_Late_Registration__c) {

                    bFRM1Deffered = false;
                    bFRM2Deffered = false;
                    bERPDeffered = false;

                }
            }

            checkSwitch(objUser);

            if (bFRM1Deffered && bFRM2Deffered && bERPDeffered && activeFRM && activeERP)

            {
                bFRM1Deffered = false;
                bFRM2Deffered = false;
                bERPDeffered = false;
            }

            if (bFRM1Deffered && bFRM2Deffered) checkFRMDeferredStats(frmRecTypeId, objUser);
            if (bERPDeffered) checkERPDeferredStats(erpRecTypeId, objUser);
            return;

        } catch (exception ex) {

            return;
        }
        return;
    }

    public static void checkFRMDeferredStats(id frmRecTypeId, User objUser) {

        String strFRM1Result;
        String strFRM2Result;
        boolean bHasFrm2Registered = false;
        boolean bHasFrm1Registered = false;
        bFRM1Deffered = false;
        bFRM2Deffered = false;

        for (Exam_Attempt__c objEA: [select id, Candidate_Commitment__c, program__c, Result__c, Defered__c, Section__c, Candidate_Commitment__r.RecordtypeId from Exam_Attempt__c where Member__c = : objUser.Contactid and Program__c = : frmRecTypeId and Exam_Site__r.Exam__r.Exam_Group__r.Active__c = : true and Cancelled__c !=true]) {
            if (objEA.Section__c == 'FRM Part 1') {
                bHasFrm1Registered = true;
                if (objEA.Defered__c != null) strFRM1Result = objEA.Defered__c;

            } else {
                bHasFrm2Registered = true;
                if (objEA.Defered__c != null) strFRM2Result = objEA.Defered__c;
            }

        }

        if (bHasFrm2Registered && strFRM2Result == 'Pending' && bHasFrm1Registered && strFRM1Result == 'Pending') {
            bFRM2UnDeffered = true;
            bFRM1UnDeffered = true;
        } else if (bHasFrm2Registered && strFRM2Result == 'Pending') {

            bFRM2UnDeffered = true;
        } else if (bHasFrm1Registered && strFRM1Result == 'Pending') {
            bFRM1UnDeffered = true;
        }

        if (strFRM1Result == null && bHasFrm1Registered && strFRM2Result == null && bHasFrm2Registered) {
            bFRM1Deffered = true;
            bFRM2Deffered = true;
        } else if (strFRM2Result == null && bHasFrm2Registered) {
            bFRM1Deffered = false;
            bFRM2Deffered = true;
        } else if (strFRM1Result != null && bHasFrm2Registered) {
            bFRM1Deffered = false;
            bFRM2Deffered = false;
        } else if (strFRM1Result == null && bHasFrm1Registered) {
            bFRM1Deffered = true;
            bFRM2Deffered = false;
        }
    }

    public static void checkERPDeferredStats(id erpRecTypeId, User objUser) {

        string strERPResult;
        boolean bHasERPRegistered = false;
        bERPDeffered = false;
        for (Exam_Attempt__c objEA: [select id, Candidate_Commitment__c, program__c, Result__c, Defered__c, Section__c, Candidate_Commitment__r.RecordtypeId from Exam_Attempt__c where Member__c = : objUser.Contactid and Program__c = : erpRecTypeId and Exam_Site__r.Exam__r.Exam_Group__r.Active__c = : true and Cancelled__c !=true])

        {
            bHasERPRegistered = true;
            if (objEA.Defered__c != null) strERPResult = objEA.Defered__c;
        }
        if (bHasERPRegistered) {
            if (strERPResult == null) bERPDeffered = true;

            if (strERPResult == 'Pending') bERPUnDeffered = true;
        }

    }

    public static void checkSwitch(User objUser) {

        boolean isFrmReg = false;
        boolean isERPReg = false;
        for (Exam_Attempt__c objEA: [select id, Candidate_Commitment__c, program__c, Result__c, Defered__c, Section__c, Candidate_Commitment__r.RecordtypeId from Exam_Attempt__c where Member__c = : objUser.Contactid and Exam_Site__r.Exam__r.Exam_Group__r.Active__c = : true and Defered__c != 'Pending'])

        {
            if (objEA.Section__c.contains('FRM')) isFrmReg = true;
            else if (objEA.Section__c.contains('ERP')) isERPReg = true;
        }

        if (isFrmReg) checkSwithforERP(objUser);
        else if (isERPReg) checkSwithforFRM(objUser);

        Contact cont = [select id, name, accountID from contact where id = : objUser.Contactid];
        List < Opportunity > lstOpps = [select id, name from opportunity where accountId = : cont.accountID and(Switch_to_erp__c = : true OR Switch_to_frm__c = : true)];
        if (lstOpps != null && lstOpps.size() > 0) {

            bERPCanSwitch = false;
            bFRMCanSwitch = false;
        }

    }

    public static void checkSwithforERP(User objUser) {
        id erpRecTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'ERP Program');
        List < Exam_Attempt__c > lstERPEA = [select id, Candidate_Commitment__c, program__c, Result__c, Defered__c, Section__c, Candidate_Commitment__r.RecordtypeId from Exam_Attempt__c where Member__c = : objUser.Contactid and Candidate_Commitment__r.Status like '%Activated%'
        and Cancelled__c != true and Program__c = : erpRecTypeId and(Result__c = : 'Pass'
        OR Result__c = : null)];
        if (lstERPEA == null || lstERPEA.size() <= 0) bERPCanSwitch = true;
    }

    public static void checkSwithforFRM(User objUser) {

        id frmRecTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'FRM Program');
        List < Exam_Attempt__c > lstFRMEA = [select id, Candidate_Commitment__c, program__c, Result__c, Defered__c, Section__c, Candidate_Commitment__r.RecordtypeId from Exam_Attempt__c where Member__c = : objUser.Contactid and Candidate_Commitment__r.Status like '%Activated%'
        and Cancelled__c != true and Program__c = : frmRecTypeId and(Result__c = : 'Pass'
        OR Result__c = : null)];
        if (lstFRMEA == null || lstFRMEA.size() <= 0) bFRMCanSwitch = true;

    }
 
    public static string unDeferrExamAttempts(Id examattemptId, string strProdCode, string strGLCode, Boolean bWire) {
        Exam_Attempt__c objEA = [select id, Member__c, Candidate_Commitment__c, Candidate_Commitment__r.RecordtypeId, Candidate_Commitment__r.AccountId from Exam_Attempt__c where id = : examattemptId];

        return createOppRecord(objEA, 'Un Deferred', strProdCode, strGLCode, bWire);

    }

    public static List < wrapperUtils.wrapperProductDetails > checkrenewMemberShip() {
        try {
            User objUser = Utilities.getCurrentUserDetails();
            if (objUser.Contactid == null) return null;
            id memRecTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'Membership');
            List < Contact > lstContact = [select id, accountId, KPI_FRM_Certified__c, KPI_ERP_Certified__c from Contact where id = : objUser.Contactid];
            if (lstContact != null && lstContact.size() > 0) {
                COntact objContact = lstContact[0];
                List < Contract > lstContract = [select id, name, accountId, ContractTerm, Membership_Type__c from Contract where accountId = : objContact.accountId and recordTypeId = : memRecTypeId and(Status = : 'Activated'
                or Status = : 'Activated ( Auto-Renew )' or Status = : 'Expired')];
                if (lstContract != null && lstContract.size() > 0) {
                    return getMembershipTypeCodes(lstContract[0], objContact);
                } else return null;
            } else {
                return null;
            }

        } catch (exception ex) {
            throw ex;
        }
    }

    public static List < wrapperUtils.wrapperProductDetails > getMembershipTypeCodes(Contract objContract, Contact objContact) {
        decimal term;
        Set < String > setProdCodes = new Set < String > ();
        id memRecTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'Membership');
        AggregateResult[] groupedResults = [select SUM(ContractTerm) term from Contract where accountId = : objContact.accountId and recordTypeId = : memRecTypeId and Membership_Type__c = 'Student'
        and Technically_Zero__c != true];
        for (AggregateResult Result: groupedResults)
        term = (Decimal) Result.get('term');

        if (term >= 24.0) {
            setProdCodes.add('MEMI');
        } else {
            setProdCodes.add('MEMI');
            setProdCodes.add('MEMS');
        }

        List < wrapperUtils.wrapperProductDetails > lstWraps = new List < wrapperUtils.wrapperProductDetails > ();
        wrapperUtils.wrapperProductDetails objWrap;
        for (PriceBookEntry objPriceBook: [select unitprice, productcode from PriceBookEntry where Pricebook2.IsActive = true and productcode in : setProdCodes and isActive = true]) {
            objWrap = new wrapperUtils.wrapperProductDetails();
            if ((objContact.KPI_FRM_Certified__c || objContact.KPI_ERP_Certified__c) && objPriceBook.productcode == 'MEMI') {
                objWrap.strProductCode = objPriceBook.productcode;
                objWrap.dPrice = 150;
                lstWraps.add(objWrap);
            }

            else if (!objContact.KPI_FRM_Certified__c && !objContact.KPI_ERP_Certified__c) {
                objWrap.strProductCode = objPriceBook.productcode;
                objWrap.dPrice = objPriceBook.unitprice;
                lstWraps.add(objWrap);
            }
        }

        if (lstWraps.size() <= 0) return null;
        return lstWraps;

    }

    public static ChargentSFA__Payment_Request__c extendMembership(String strProdCode) {

        User objUser = Utilities.getCurrentUserDetails();
        if (objUser.Contactid == null) return null;
        Contact objContact = [SELECT Id, Name, FirstName, LastName, Email, HomePhone, Company__c, MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet, AccountId, GARP_ID__c, Membership_Type__c, KPI_FRM_Certified__c FROM Contact WHERE Id = :objUSer.contactId];
         List<Account> lstAcct = [select Id, Name, BillingCity, BillingCountry, BillingPostalCode, BillingState, BillingStreet from Account where Id = :objContact.AccountId];
                   Id memberRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','Membership');

        Id recordTypeID = RecordTypeHelper.GetRecordTypeId('Opportunity','Automated');
        List<Contract> lstContract = [select id,status,recordTypeId,Membership_Type__c,Enddate from contract where recordTypeId =: memberRecordTypeID and (status =: 'Activated' or status =: 'Expired') and accountId =: objContact.accountId];

        Opportunity opp = new Opportunity();
        opp.Name='Purchase123';
        opp.StageName='New Lead';
        opp.CloseDate = system.today();
        opp.Renew_Membership__c = true;
        opp.AccountId=objContact.accountId;
        opp.RecordTypeId = recordTypeID;
        opp.ChargentSFA__Billing_Email__c = objContact.Email;
        opp.ChargentSFA__Billing_First__c = objContact.FirstName;
        opp.ChargentSFA__Billing_Last__c = objContact.LastName;
        opp.ChargentSFA__Billing_Phone__c = objContact.HomePhone;
        opp.ChargentSFA__Billing_Company__c = objContact.Company__c;   
        opp.ChargentSFA__Billing_Address__c = lstAcct[0].BillingStreet;
        opp.ChargentSFA__Billing_City__c = lstAcct[0].BillingCity;
        opp.ChargentSFA__Billing_State__c = lstAcct[0].BillingState;
        opp.ChargentSFA__Billing_Zip__c = lstAcct[0].BillingPostalCode;
        opp.ChargentSFA__Billing_Country__c = lstAcct[0].BillingCountry;
        opp.Shipping_First_Name__c = objContact.FirstName;
        opp.Shipping_Last_Name__c = objContact.LastName;
        opp.Shipping_E_mail__c = objContact.Email;
        opp.Shipping_Company_Name__c = objContact.Company__c;
        opp.Shipping_Phone_No__c = objContact.HomePhone;
        opp.Shipping_Street__c = objContact.MailingStreet;
        opp.Shipping_City__c = objContact.MailingCity;
        opp.Shipping_State__c = objContact.MailingState;
        opp.Shipping_Postal_Code__c = objContact.MailingPostalCode;
        opp.Shipping_Country__c = objContact.MailingCountry;
        insert opp;
        
        OpportunityContactRole contactRole = new OpportunityContactRole(OpportunityId=opp.id, ContactId=objContact.Id, Role='Decision Maker');
        insert contactRole;        
        
        createOppLineItems(opp.Id, strProdCode, objContact);
        List<Contract> lstUpdateContracts = new List<Contract>();
         for(Contract objCon : lstContract)
            {
                if(objCon.status == 'Activated')
                {
                    objCon.Opportunity__c = opp.Id;
                    lstUpdateContracts.add(objCon);  
                }
            }
        update lstUpdateContracts;
        ChargentSFA__Payment_Request__c objPayment = new ChargentSFA__Payment_Request__c();
        objPayment.ChargentSFA__Billing_Contact__c = objContact.Id;
        objPayment.ChargentSFA__Opportunity__c = opp.Id;                    
        insert objPayment;
        objPayment = [select id, name, ChargentSFA__Pay_Link__c from ChargentSFA__Payment_Request__c where id = :objPayment.Id];
        return objPayment;

    }

   

    public static void createOppLineItems(Id oppId, String strProdCode, Contact objContact) {

        String strNameByProdcutCode = '';
        PriceBookEntry PricebookEntryId = [select unitprice, productcode from PriceBookEntry where Pricebook2.IsActive = true and productcode = : strProdCode and isActive = : true];
        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = oppId;
        oppLineItem.PricebookEntryId = PricebookEntryId.Id;
        oppLineItem.Quantity = 1;

        if (objContact.KPI_FRM_Certified__c && strProdCode == 'MEMI') oppLineItem.UnitPrice = 150;
        else oppLineItem.UnitPrice = PricebookEntryId.unitprice;
        dTotalPrice = oppLineItem.UnitPrice;
        insert oppLineItem;
    }


    public static List < String > getContactDetails() {

        List < String > lstData = new List < String > ();
        try {
            User objUser = Utilities.getCurrentUserDetails();
            if (objUser.Contactid == null) return null;
            Contact objContact = [select id, accountId, ID_Number__c, ID_Type__c, Name_As_it_Appears_On_ID__c from Contact where id = : objUser.Contactid and ID_Number__c != null and ID_Type__c != null and Name_As_it_Appears_On_ID__c != null];
            lstData.add(objContact.ID_Type__c);
            lstData.add(objContact.ID_Number__c);
            lstData.add(objContact.Name_As_it_Appears_On_ID__c);
            return lstData;
        } catch (exception ex) {
            return null;
        }

        return null;
    }
    
    public static void updateExamSite(Id examAttemptID, Id examSiteID) {
        try {
            Exam_Attempt__c objExamAttempt = [select id, Exam_Site__c from Exam_Attempt__c where id = : examAttemptID];
            objExamAttempt.Exam_Site__c = examSiteID;
            update objExamAttempt;
        } catch (exception ex)

        {
          //return 'Error:This exam is already deferred';
        }

    }
}