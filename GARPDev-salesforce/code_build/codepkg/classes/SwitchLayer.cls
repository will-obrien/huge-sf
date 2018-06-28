public without sharing class SwitchLayer
{   
    static id frmRecTypeId  = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program');
    static id erpRecTypeId  = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program');
    public static List<Exam__c> lstExamDetails = null;
    public static List<wrapperUtils.wrapperProductInfo> swithcLogic()
    {
        User objUser = Utilities.getCurrentUserDetails();
        if(objUser.Contactid == null) return null;
        Contact objContact = [select id,accountID from contact where id=: objUser.Contactid];
        boolean isERP = false;
        
        boolean isFRM = false;
        boolean isERPContractActive = false;
        boolean isFRMContractActive = false;
        //Get all active contracts here
        for(Contract objCon : [select id,name,recordTypeID from Contract where (recordTypeID =: frmRecTypeId or recordTypeID =: erpRecTypeId) and status like '%Activated%' and AccountId =: objContact.accountID])
        {
            if(objCon.recordTypeID == erpRecTypeId)
                isERPContractActive = true;
            else if(objCon.recordTypeID == frmRecTypeId)
                isFRMContractActive = true;
        }
        system.debug('isERPContractActive == '+isERPContractActive);
        system.debug('isFRMContractActive == '+isFRMContractActive);
        List<Exam_Attempt__c> lstExamAttempts = [select id,Candidate_Commitment__c,Section__c,Result__c,program__c,Defered__c,Candidate_Commitment__r.RecordtypeId,Exam_Site__r.Exam__r.Exam_Group__r.Active__c,Candidate_Commitment__r.Status,Cancelled__c,Exam_Site__r.Exam__r.Exam_Group__r.Last_Date_For_Early_Registration__c,Exam_Site__r.Exam__r.Exam_Group__r.Last_Date_For_Standard_Registration__c,Exam_Site__r.Exam__r.Exam_Group__r.Last_Date_For_Late_Registration__c from Exam_Attempt__c where Member__c =: objUser.Contactid];
        system.debug('lstExamAttempts == '+lstExamAttempts);
        for(Exam_Attempt__c objEA :lstExamAttempts)
        {
            system.debug('objEA == '+objEA);
            if(objEA != null && objEA.Candidate_Commitment__r != null && objEA.Exam_Site__r != null && objEA.Cancelled__c != null && objEA.program__c != null) {
                if(objEA.Candidate_Commitment__r.Status.indexOf('Activated') >= 0 && 
                   objEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c && 
                   objEA.Defered__c == null && objEA.Cancelled__c != true && 
                   objEA.program__c == erpRecTypeId)
                    isERP = true;
                else if(objEA.Candidate_Commitment__r.Status.indexOf('Activated') >= 0 && objEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c && objEA.Defered__c == null && objEA.Cancelled__c != true && objEA.program__c == frmRecTypeId)
                    isFRM = true;
            }
        }
        system.debug('isFRM == '+isFRM);
        system.debug('isERP == '+isERP);
        Set<String> setProdCodes = new Set<String>{'FRM1L','FRM1S','FRM1E','FRM2L','FRM2S','FRM2E','ENCS','ENCL','ENCE','FRM1H','FRM2H','FRM1','ENC','ENCCP'};
        List<wrapperUtils.wrapperProductInfo> lstWrapper = new List<wrapperUtils.wrapperProductInfo>();
        Map<String,PriceBookEntry> mapPriceBookDetails = new Map<String,PriceBookEntry>();
        for(PriceBookEntry PricebookEntryId : [select unitprice,productcode,product2Id,product2.Gl_Code__c from PriceBookEntry where Pricebook2.IsActive = true and productcode in: setProdCodes and isActive = true])
        {
            mapPriceBookDetails.put(PricebookEntryId.productcode+PricebookEntryId.product2.Gl_Code__c,PricebookEntryId);
        
        }
        List<String> lstExamNames = new List<String>{'FRM Part 1','FRM Part 2','ERP'};
        lstExamDetails = [select id,Exam__c,Exam_Group__r.Early_Exam_Registration_Fee__c,Exam_Date__c,Exam_Group__r.Standard_Exam_Registration_Fee__c,Exam_Group__r.Late_Exam_Registration_Fee__c,Exam_Group__r.Last_Date_For_Early_Registration__c,Exam_Group__r.Last_Date_For_Standard_Registration__c,Exam_Group__r.Last_Date_For_Late_Registration__c from Exam__c where Exam__c in: lstExamNames and Exam_Group__r.Active__c = true];
        //Check if ERP is true then call ERP function else call FRM function.
        if(isERP)
        {
              List<wrapperUtils.wrapperProductInfo> lstDetails = checkFRMDetails(isFRMContractActive,lstExamAttempts,mapPriceBookDetails);
            if(lstDetails != null && lstDetails.size() > 0)
                lstWrapper.addAll(lstDetails);
           
        }
        else if(isFRM)
        {
             wrapperUtils.wrapperProductInfo obj = checkERPDetails(isERPContractActive,lstExamAttempts,mapPriceBookDetails);
            if(obj != null)
                lstWrapper.add(obj);
        }
        
        return lstWrapper;
    
    }
    
    public static wrapperUtils.wrapperProductInfo checkERPDetails(boolean bIsERPActive,List<Exam_Attempt__c> lstEAttempts,Map<String,PriceBookEntry> mapPriceBookDetails)
    {
        wrapperUtils.wrapperProductInfo objWrap = new wrapperUtils.wrapperProductInfo();
        objWrap.bSwitchFess = true;
        PriceBookEntry objSwitchPriceBook = [select unitprice,productcode,product2.GL_Code__c from PriceBookEntry where Pricebook2.IsActive = true and productcode =: 'GL0051' and isActive =: true];
        objWrap.strSwitchGlCode = objSwitchPriceBook.product2.GL_Code__c;
        objWrap.switchprodcode  = objSwitchPriceBook.productcode;
        objWrap.switchprice  = objSwitchPriceBook.unitprice;
        PriceBookEntry objPriceBook = getProductCodesByStage(mapPriceBookDetails,'ERP');
        objWrap.examPrice = 0;//objPriceBook != null ?  objPriceBook.unitPrice : 0;
        objWrap.strProductCode = objPriceBook != null ? objPriceBook.productcode : null;
        objWrap.strGlCode = objPriceBook != null ? objPriceBook.product2.Gl_Code__c : null; 
        objWrap.strDisplayName   = 'ERP Exam';
        objWrap.bERPEnrollment = false;
        system.debug('lstEAttempts == '+lstEAttempts);
        for(Exam_Attempt__c obj : lstEAttempts)
        {
            system.debug('In ERP obj == '+obj);
            if(!obj.Exam_Site__r.Exam__r.Exam_Group__r.Active__c )
            {
                    system.debug('bIsERPActive == '+bIsERPActive);
                    if(!bIsERPActive && (obj.Section__c == 'FRM Part 1' || obj.Section__c == 'FRM Part 2'|| obj.Section__c == 'FRM Full Program'))
                    {
                        objWrap.bERPEnrollment = true;
                        break;
                    }
                    
            }   
            
                
        }
        system.debug('objWrap == '+objWrap);
        return objWrap;
        
        
    }
    
    public static List<wrapperUtils.wrapperProductInfo> checkFRMDetails(boolean bIsFRMActive,List<Exam_Attempt__c> lstEAttempts,Map<String,PriceBookEntry> mapPriceBookDetails)
    {
        
        boolean bCreateFrm1 = false;
        boolean bCreateFrm2 = false;
        boolean bhasEnrollment = false;
        List<wrapperUtils.wrapperProductInfo> lstWraps = new List<wrapperUtils.wrapperProductInfo>();
        system.debug('lstEAttempts == '+lstEAttempts);
        
        for(Exam_Attempt__c obj : lstEAttempts)
        {
             system.debug('obj == '+obj);
            if(!obj.Exam_Site__r.Exam__r.Exam_Group__r.Active__c)
            {
                system.debug('obj Main == '+obj);
                system.debug('bIsFRMActive == '+bIsFRMActive);
                if(!bIsFRMActive && obj.Section__c == 'ERP') bhasEnrollment = true;
                if(obj.Section__c == 'FRM Part 1' && obj.Result__c == 'Pass' && obj.Candidate_Commitment__r.Status.indexOf('Activated') >= 0)
                {
                    bCreateFrm2 = true;
                }
                else
                {
                    bCreateFrm1 = true;
                }
            }
            
                
        }
        wrapperUtils.wrapperProductInfo objFRM2Wrap = new wrapperUtils.wrapperProductInfo();
        wrapperUtils.wrapperProductInfo objFRM1Wrap = new wrapperUtils.wrapperProductInfo();
        if(bCreateFrm2)
        {
            objFRM2Wrap.bFRMEnrollment = bhasEnrollment;
            PriceBookEntry objPriceBook = getProductCodesByStage(mapPriceBookDetails,'FRM Part 2');
            //PricebookEntryId.productcode+product2.Gl_Code__c
            objFRM2Wrap.strProductCode  = objPriceBook != null ?  objPriceBook.productcode : null;
            objFRM2Wrap.strDisplayName   = 'FRM Part 2';
            objFRM2Wrap.strGlCode = objPriceBook != null ? objPriceBook.product2.Gl_Code__c : null; 
            objFRM2Wrap.examPrice  = 0;//objPriceBook != null ? objPriceBook.unitprice : 0;
            objFRM2Wrap.bSwitchFess = false;
            lstWraps.add(objFRM2Wrap);
            
        }
        else if(bCreateFrm1 || !bhasEnrollment)
        {
            objFRM1Wrap.bFRMEnrollment = bhasEnrollment;
            PriceBookEntry objPriceBook = getProductCodesByStage(mapPriceBookDetails,'FRM Part 1');
            objFRM1Wrap.strProductCode  = objPriceBook != null ? objPriceBook.productcode : null;
            objFRM1Wrap.strGlCode = objPriceBook != null ? objPriceBook.product2.Gl_Code__c : null; 
            objFRM1Wrap.strDisplayName   = 'FRM Part 1';
            objFRM1Wrap.examPrice  = 0;//objPriceBook != null ? objPriceBook.unitprice : 0;
            objFRM1Wrap.bSwitchFess = false;
            //List<String> lstExamNames = new List<String>{'FRM Part 1','FRM Part 2','ERP'};
            //List<Exam__c> lstExamDetails = [select id,Exam__c,Exam_Group__r.Early_Exam_Registration_Fee__c,Exam_Group__r.Standard_Exam_Registration_Fee__c,Exam_Group__r.Late_Exam_Registration_Fee__c,Exam_Group__r.Last_Date_For_Early_Registration__c,Exam_Group__r.Last_Date_For_Standard_Registration__c,Exam_Group__r.Last_Date_For_Late_Registration__c from Exam__c where Exam__c in: lstExamNames and Exam_Group__r.Active__c = true];
            //System.debug('lstExamDetails = '+lstExamDetails);
            //Map<String,decimal> mapExamFees = Registration.getExamFee(lstExamDetails);
            //System.debug('mapExamFees = '+mapExamFees);
            objFRM2Wrap.bFRMEnrollment = bhasEnrollment;
            PriceBookEntry objPriceBook2 = getProductCodesByStage(mapPriceBookDetails,'FRM Part 2');
            objFRM2Wrap.strProductCode  = objPriceBook2 != null ? objPriceBook2.productcode : null;
            objFRM2Wrap.strGlCode = objPriceBook2 != null ? objPriceBook2.product2.Gl_Code__c : null; 
            objFRM2Wrap.strDisplayName   = 'FRM Part 2';
            objFRM2Wrap.examPrice  =  objPriceBook2 != null ? objPriceBook2.unitPrice : 0;
            //if(mapExamFees != null)
                //objFRM2Wrap.examPrice  = mapExamFees.get('FRM Part 2');
                
            objFRM2Wrap.bSwitchFess = false;
            
            lstWraps.add(objFRM1Wrap);
            lstWraps.add(objFRM2Wrap);
        
        }
        
        
        return lstWraps;
        
    }
    
    public static PriceBookEntry getProductCodesByStage(Map<String,PriceBookEntry> mapPriceBookDetails, string strProductType)
    {
        system.debug('mapPriceBookDetails == '+mapPriceBookDetails);
        system.debug('lstExamDetails == '+lstExamDetails);
        for(Exam__c objExam : lstExamDetails)
        {
            if(objExam.Exam__c != strProductType) continue;
            if(system.today() <= objExam.Exam_Group__r.Last_Date_For_Early_Registration__c)
            { 
                return getProductCodeByMonth(mapPriceBookDetails,objExam.Exam__c,objExam.Exam_Date__c.month(),'E');
                
            }
            else if(system.today() <= objExam.Exam_Group__r.Last_Date_For_Standard_Registration__c)
            {
                return getProductCodeByMonth(mapPriceBookDetails,objExam.Exam__c,objExam.Exam_Date__c.month(),'S');
                 
            }
            else if(system.today() <= objExam.Exam_Group__r.Last_Date_For_Late_Registration__c)
            {
                return getProductCodeByMonth(mapPriceBookDetails,objExam.Exam__c,objExam.Exam_Date__c.month(),'L');
                 
            }
        }
        return null;
    
    }
    
    public static PriceBookEntry getProductCodeByMonth(Map<String,PriceBookEntry> mapPriceBookDetails, string strExamName, integer iMonth, string strExamStage)
    {
        String strGLCode = (iMonth == 5 ? '4001' : '4002');
        system.debug('strGLCode == '+strGLCode);
        String strProdCode = (strExamName.indexOf('FRM Part 1') >= 0 ? 'FRM1': (strExamName.indexOf('FRM Part 2') >= 0 ? 'FRM2' : 'ENC')) + strExamStage;
        system.debug('strProdCode == '+strProdCode);
        return mapPriceBookDetails.get(strProdCode+strGLCode);
    }
    

}