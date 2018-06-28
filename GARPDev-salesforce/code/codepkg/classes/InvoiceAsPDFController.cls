global without sharing class InvoiceAsPDFController{
    
    private static final String LONG_TIME_FORMAT = 'EEEE, MMMM d, yyyy h:mm a';
    private static final String SHORT_TIME_FORMAT = 'EEEE, MMMM d yyyy';
    private static final String SYS_DATE_FORMAT = 'MM/dd/yyyy h:mm a';
    
    @TestVisible private static final String IND_GL = '4040';
    @TestVisible private static final String NOV_EXAM_REG_GL = '4002';
    @TestVisible private static final String MAY_EXAM_REG_GL = '4001';
    @TestVisible private static final String FBR_GL = '4000';
    @TestVisible private static final String PAY_DEFERRED_GL = '6110';
    
    global Id oppId {get;set;} 
    global String status {get;set;}
    global string type {get;set;}
    global string msg {get;set;}
    global Boolean isPaid {get;set;}
    
    global OpportunityWrapper oppty {get;set;}
    global ExamAttemptWrapper exam {get; set;}
    global List<LineItemWrapper> lineItems {get; set;}
    global List<PaymentWrapper> payments {get; set;}
    
    global Boolean FRM {get;set;}
    global Boolean ERP {get;set;}
    global Boolean ICBRR {get;set;}
    global Boolean FBR {get;set;}   
    global Boolean Membership {get; set;}    
    global Boolean Wire  {get;set;}
    global Boolean Check {get;set;}
    global Boolean CreditByFax {get;set;}
    global Boolean CC {get;set;}
    global Decimal OrderNet {get;set;}
   
    global String examRegistrationType{get;set;}
 
   global InvoiceAsPDFController() {
     status = 'Unpaid';
     isPaid = false;
     type = ''; 
     
     msg='hi';
       
     FRM = false;
     ERP= false;
     ICBRR = false;
     FBR = false;
     Membership = false;
     Wire = false;
     Check = false;
     CreditByFax = false;
     CC = true;  
     OrderNet = 0;
       
   }
   
   global String getNow() {
       return System.now().format(SYS_DATE_FORMAT);
   }
 
   global void fetchData() {
   
       //Get opportunity data
       oppId = ApexPages.currentPage().getParameters().get('id');                
       oppty = new OpportunityWrapper([Select id, Company__c, StageName, EA_Id__c, Undefred_EA_Id__c, Alternate_Method_of_Payment__c, ChargentSFA__Payment_Method__c, ChargentSFA__Billing_First__c, ChargentSFA__Billing_Last__c, ChargentSFA__Billing_Company__c, 
                ChargentSFA__Billing_Address__c, ChargentSFA__Billing_City__c, ChargentSFA__Billing_State__c, ChargentSFA__Billing_Zip__c, ChargentSFA__Billing_Country__c,
                ChargentSFA__Billing_Phone__c, ChargentSFA__Billing_Email__c, Shipping_First_Name__c, Shipping_State__c, Shipping_Postal_Code__c,Shipping_Last_Name__c, 
                Shipping_Phone_No__c, Shipping_Company_Name__c, Shipping_Country__c, Display_Invoice_Number__c,Product_Name__c, Shipping_City__c,
                Shipping_Street__c, Shipping_E_mail__c, ChargentSFA__Charge_Amount__c, Amount, GARP_Member_ID__c, CreatedDate, LEGACY_Purchase_Date__c FROM Opportunity
                WHERE id= :oppId and StageName != 'Recurring Intent']);
              
       //system.debug('Exam?:' + oppty.examAttemptId);
       
       //Get exam data 
       list<Exam_Attempt__c> ea = [Select id, Section__c, Exam_Site__r.Exam__r.Exam__c, Exam_Site__r.Name, Exam_Site__r.Site__r.Name, Original_Exam_Site__c, Exam_Date__c, Opportunity__r.Id from  Exam_Attempt__c where (Opportunity__r.Id = :oppID OR Id = :oppty.deferExamAttemptId OR Id = :oppty.undeferExamAttemptId) and Exam_Site__r.Exam__r.Exam__c <> 'ICBRR'];
	   list<Exam_Attempt__c> eaCloned = [Select id, Exam_Site__r.Exam__r.Exam__c, Exam_Site__r.Name, Exam_Site__r.Site__r.Name, Original_Exam_Site__c, Exam_Date__c, Opportunity__r.Id from  Exam_Attempt__c where Cloned_From__c in :ea];                                   
       list<Exam_Attempt__c> eaAll = new list<Exam_Attempt__c>();
       
       eaAll.addAll(ea);
       eaAll.addAll(eaCloned);
       
       Exam_Attempt__c lastEA = null;
       if (!eaAll.isEmpty() && eaAll.size() > 0) {
           for(Exam_Attempt__c e :eaAll ) {
               if(lastEA == null) {
                   lastEA = e;
               } else if(e.Exam_Date__c < lastEA.Exam_Date__c) {
                   lastEA = e;                   
               }
           }
           exam = new ExamAttemptWrapper(lastEA);
       }

        system.debug('Exam?:' + exam);
       
       Decimal total = oppty.Amount;
       String payType = '';
       
       if(oppty.ampMethod != null)
        type = oppty.ampMethod;
       
      
       //Get payment data
       payments = new List<PaymentWrapper>();
       for (ChargentSFA__Transaction__c payment : [Select id ,Name, ChargentSFA__Amount__c, ChargentSFA__Opportunity__r.CloseDate , ChargentSFA__Opportunity__c,ChargentSFA__Opportunity__r.GARP_Member_ID__c,
              ChargentSFA__Opportunity__r.StageName , ChargentSFA__Type__c, ChargentSFA__Payment_Method__c, ChargentSFA__Response_Status__c, ChargentSFA__Gateway_Date__c
              FROM ChargentSFA__Transaction__c  where ChargentSFA__Amount__c!= NULL and ChargentSFA__Opportunity__c = :oppId and ChargentSFA__Opportunity__r.StageName != 'Recurring Intent' AND ((ChargentSFA__Type__c = 'Debit' OR ChargentSFA__Type__c = 'Charge' OR ChargentSFA__Type__c = 'Credit' or ChargentSFA__Type__c = 'Refund' or ChargentSFA__Type__c = 'Charge Back Accepted' or ChargentSFA__Type__c = 'Charge Back Loss') AND (ChargentSFA__Response_Status__c = 'Approved' OR ChargentSFA__Response_Status__c = '' OR ChargentSFA__Response_Status__c = NULL)) ORDER BY ChargentSFA__Gateway_Date__c ASC]){
           
           payments.add(new PaymentWrapper(payment));

           system.debug('pay?:' + payment);
           
           
           if (payment.ChargentSFA__Type__c!=null && payment.ChargentSFA__Amount__c!=null) {
               if(payment.ChargentSFA__Type__c == 'Charge' || payment.ChargentSFA__Type__c == 'Credit' || payment.ChargentSFA__Type__c=='Refund' || payment.ChargentSFA__Type__c=='Charge Back Accepted' || payment.ChargentSFA__Type__c=='Charge Back Loss') {
                   
                   system.debug('pay:' + payment.ChargentSFA__Amount__c);
                   
                   OrderNet+=payment.ChargentSFA__Amount__c;
                   
                   if(payment.ChargentSFA__Payment_Method__c!=null) {
                       if(payment.ChargentSFA__Payment_Method__c == 'Credit Card') {
                           CC=true;
                           Wire=false;
                           Check=false;
                           CreditByFax=false;                    
                       }
                   }
                   if(payment.ChargentSFA__Type__c == 'Charge' ) {
                       
                       system.debug('Charge:' + payment.ChargentSFA__Type__c);
                       
                       if (payType == null || payType == '') {
                           payType = payment.ChargentSFA__Payment_Method__c;
                       } else if (payment.ChargentSFA__Payment_Method__c != null && payment.ChargentSFA__Payment_Method__c != '') {
                           if (!payType.containsIgnoreCase(payment.ChargentSFA__Payment_Method__c)) {
                               payType = payType + ', ' + payment.ChargentSFA__Payment_Method__c;
                           }
                       }
                   }
               }          
           }   
       }
       if(payType != NULL && payType != '')
           type = payType;
       
       if(type.containsIgnoreCase('wire')) {
           CC=false;
           Wire=true;
       } else if(type.containsIgnoreCase('check')) {
           CC=false;
           Check=true;
       } else if(type.containsIgnoreCase('fax')) {
           CC=false;
           CreditByFax=true;
       } else if(oppty != null && oppty.chrgAmpMethod != null && oppty.chrgAmpMethod.containsIgnoreCase('wire')) {              
           CC=false;
           Wire=true;
       }
       if(oppty.stage == 'Closed') {
           status = 'Paid'; 
           isPaid = true;           
       }
       
       //if (total != null && countTotal > 0 && countTotal >= total) {
       //    status = 'Paid'; 
       //    isPaid = true;
       //}  else if(total != null && countTotal > 0 && countTotal < total) {
       //    status = 'Partially Paid'; 
       //    isPaid = true;
       //}
                      
       //Get line item data                 
       lineItems = new List<LineItemWrapper>();
       for(OpportunityLineItem oProd : [Select Product2.Name, Product2.ProductCode, Product2.GL_Code__c, UnitPrice, OpportunityId, Description, TotalPrice, Quantity from OpportunityLineItem where OpportunityId=:oppID order by Product2.Display_Sort_Order__c, TotalPrice DESC] ) {
           lineItems.add(new LineItemWrapper(oProd));
              
           String prodName = oProd.Product2.Name; 
           String description = oProd.Description;
           Decimal totAmt = oProd.UnitPrice;
           String prodCode = oProd.Product2.ProductCode;
           String GLCode = oProd.Product2.GL_Code__c; 
           
           if (GLCode !=null && prodCode != null) {
               if (GLCode == IND_GL) {
                   Membership = true;
               } 
               else if (GLCode == NOV_EXAM_REG_GL || GLCode == MAY_EXAM_REG_GL) {
                   if (prodCode.containsIgnoreCase('frm')) {
                       FRM=true; 
                   }
                   if (prodCode.containsIgnoreCase('enc')) {
                       ERP=true; 
                   }
                   examRegistrationType = getExamType(prodCode);
               }
               else if (GLCode == FBR_GL) {
                   if (prodCode.startsWithIgnoreCase('cbr')) {
                       ICBRR=true; 
                   }
                   if (prodCode.containsIgnoreCase('fcbr') || prodCode.containsIgnoreCase('fbr')) {
                       FBR=true; 
                   }
               }
           } else {
               if (prodName != null) {
                   if (prodName.containsIgnoreCase('exam') && prodName.containsIgnoreCase('erp'))
                       ERP=true; 
                   if (prodName.containsIgnoreCase('exam') && prodName.containsIgnoreCase('frm'))
                       FRM=true; 
                   if (prodName.containsIgnoreCase('icbrr'))
                       ICBRR=true; 
                   if (prodName.containsIgnoreCase('wire'))
                       Wire=true; 
                   if (prodName.containsIgnoreCase('check') || prodName.containsIgnoreCase('fax'))
                       CreditByFax=true; 
               }          
           }         
       }
       //lineItems.sort();       
     }
     
     global class OpportunityWrapper {
         global String id {get; set;}
         global String company {get; set;}
         global String stage {get; set;}
         global String ampMethod {get;set;}
         global String deferExamAttemptId {get;set;}    
         global String undeferExamAttemptId {get;set;}             
         global String chrgAmpMethod {get;set;}
         global String chargentSFAPaymentMethod {get;set;}
         global String chargentSFABillingFirst {get; set;}
         global String chargentSFABillingLast {get; set;}
         global String chargentSFABillingCompany {get; set;}
         global String chargentSFABillingAddress {get; set;}
         global String chargentSFABillingCity {get; set;}
         global String chargentSFABillingState {get; set;}
         global String chargentSFABillingZip {get; set;}
         global String chargentSFABillingCountry {get; set;}
         global String chargentSFABillingPhone {get; set;}
         global String chargentSFABillingEmail {get; set;}
         global String shippingFirstName {get; set;} 
         global String shippingState {get; set;}
         global String shippingPostalCode {get; set;}
         global String shippingLastName {get; set;}
         global String shippingPhoneNo {get; set;}
         global String shippingCompanyName {get; set;}
         global String shippingCountry {get; set;} 
         global String garpInvoiceNumber {get; set;}
         global String garpMemberId {get; set;}
         global String productName {get; set;}
         global String shippingCity {get; set;}
         global String shippingStreet {get; set;}
         global String shippingEmail {get; set;}
         global Decimal chargentSFAChargeAmount {get; set;}
         global Decimal amount {get; set;}
         global String createdDateFormatted {get; set;}
         global Boolean hasBillingAddress {get; set;}
         global Boolean hasShippingAddress {get; set;}
         
         global OpportunityWrapper(Opportunity opp) {
             id = opp.id;
             company = opp.Company__c;  
             stage = opp.StageName;
             ampMethod = opp.Alternate_Method_of_Payment__c; 
             deferExamAttemptId = opp.EA_Id__c;
             undeferExamAttemptId = opp.Undefred_EA_Id__c;             
             chrgAmpMethod = opp.ChargentSFA__Payment_Method__c;
             chargentSFABillingFirst = opp.ChargentSFA__Billing_First__c;
             chargentSFABillingLast = opp.ChargentSFA__Billing_Last__c;
             chargentSFABillingCompany = opp.ChargentSFA__Billing_Company__c;
             chargentSFABillingAddress = opp.ChargentSFA__Billing_Address__c;
             chargentSFABillingCity = opp.ChargentSFA__Billing_City__c;
             chargentSFABillingState = opp.ChargentSFA__Billing_State__c;
             chargentSFABillingZip = opp.ChargentSFA__Billing_Zip__c;
             chargentSFABillingCountry = opp.ChargentSFA__Billing_Country__c;
             chargentSFABillingPhone = opp.ChargentSFA__Billing_Phone__c;
             chargentSFABillingEmail = opp.ChargentSFA__Billing_Email__c;
             shippingFirstName = opp.Shipping_First_Name__c; 
             shippingLastName = opp.Shipping_Last_Name__c;
             shippingCompanyName = opp.Shipping_Company_Name__c;
             shippingStreet = opp.Shipping_Street__c;
             shippingCity = opp.Shipping_City__c;
             shippingState = opp.Shipping_State__c;
             shippingPostalCode = opp.Shipping_Postal_Code__c;
             shippingCountry = opp.Shipping_Country__c;
             shippingPhoneNo = opp.Shipping_Phone_No__c;
             shippingEmail = opp.Shipping_E_mail__c;             
             garpInvoiceNumber = opp.Display_Invoice_Number__c;
             garpMemberId = opp.GARP_Member_ID__c;
             productName = opp.Product_Name__c;           
             chargentSFAChargeAmount = opp.ChargentSFA__Charge_Amount__c;
             amount = opp.Amount;
             if(opp.LEGACY_Purchase_Date__c != null)
                createdDateFormatted = opp.LEGACY_Purchase_Date__c.format(SHORT_TIME_FORMAT );
             else createdDateFormatted = opp.CreatedDate.format(SHORT_TIME_FORMAT );
             
             hasBillingAddress = opp.ChargentSFA__Billing_First__c!=null||opp.ChargentSFA__Billing_Last__c!=null||opp.ChargentSFA__Billing_Company__c!=null||
                                 opp.ChargentSFA__Billing_Address__c!=null||opp.ChargentSFA__Billing_City__c!=null||opp.ChargentSFA__Billing_Company__c!=null||
                                 opp.ChargentSFA__Billing_Zip__c!=null||opp.ChargentSFA__Billing_Country__c!=null||opp.ChargentSFA__Billing_Phone__c!=null||
                                 opp.ChargentSFA__Billing_Email__c!=null;
             hasShippingAddress = opp.Shipping_First_Name__c!=null||opp.Shipping_Last_Name__c!=null||opp.Shipping_Company_Name__c!=null||
                                 opp.Shipping_Street__c!=null||opp.Shipping_City__c!=null||opp.Shipping_State__c!=null||
                                 opp.Shipping_Postal_Code__c!=null||opp.Shipping_Country__c!=null||opp.Shipping_Phone_No__c!=null||
                                 opp.Shipping_E_mail__c!=null;
         }
     }
     
     global class ExamAttemptWrapper {
         global String examSiteName {get; set;}
         global String examDateFormatted {get; set;}
         global Boolean isERP {get; set;}
         
         global ExamAttemptWrapper(Exam_Attempt__c ea) {
             if(ea.Original_Exam_Site__c != null)
				examSiteName = ea.Original_Exam_Site__c;
             else examSiteName = ea.Exam_Site__r.Site__r.Name;
             examDateFormatted = datetime.newInstance(ea.Exam_Date__c.year(), ea.Exam_Date__c.month(), ea.Exam_Date__c.day()).format(SHORT_TIME_FORMAT);
             if(ea.Section__c.indexOf('ERP Exam Part') > -1)
             	isERP=true;
             else isERP=false;
         }
     }
     
     global class PaymentWrapper {
         global String chargentSFAType {get;set;}
         global String chargentSFAPaymentMethod {get;set;}
         global String chargentSFAResponseStatus {get;set;}
         global String chargentSFAGatewayDateFormatted {get;set;}
         global Decimal chargentSFAAmount {get; set;}
         
         global PaymentWrapper(ChargentSFA__Transaction__c payment) {
             chargentSFAType = payment.ChargentSFA__Type__c;
             chargentSFAPaymentMethod = payment.ChargentSFA__Payment_Method__c;
             chargentSFAResponseStatus = payment.ChargentSFA__Response_Status__c;
             chargentSFAGatewayDateFormatted = payment.ChargentSFA__Gateway_Date__c!=null?payment.ChargentSFA__Gateway_Date__c.format(LONG_TIME_FORMAT):null;
             chargentSFAAmount = payment.ChargentSFA__Amount__c;
         }
     }
     
     global class LineItemWrapper implements Comparable {
         global String productName {get;set;}
         global String description {get;set;}
         global Integer quantity {get;set;}
         global String productCode {get;set;}
         global Decimal totalPrice {get;set;}
         global Decimal unitPrice {get;set;}         
         
         global LineItemWrapper(OpportunityLineItem oli) {
             productName = oli.Product2.Name; 
             description = oli.Description;
             productCode = oli.Product2.ProductCode;
             quantity = Integer.ValueOf(oli.Quantity);
             totalPrice = oli.TotalPrice;
             unitPrice = oli.UnitPrice;
         }
         
         global Integer compareTo(Object compareTo) {
             LineItemWrapper lineItemCompareTo = (LineItemWrapper)compareTo;
             Integer thisSortOrderRank = getGLCodeRankForLineItemSorting(this.productCode);
             Integer compareToSortOrderRank = getGLCodeRankForLineItemSorting(lineItemCompareTo.productCode);
             if (thisSortOrderRank > compareToSortOrderRank) return 1;
             if (thisSortOrderRank < compareToSortOrderRank) return -1;
             return 0;
         }
     }
     
    
    private static String getExamType(String code) {
        if(code == FRMExamPart1Early || code == FRMExamPart2Early || code == ERPExamEarly || code == ERPExamPart1Early || code == ERPExamPart2Early)
            return 'early';
        if(code == FRMExamPart1Standard || code == FRMExamPart2Standard || code == ERPExamStandard || code == ERPExamPart1Standard || code == ERPExamPart2Standard)
            return 'standard';
        if(code == FRMExamPart1Late || code == FRMExamPart2Late || code == ERPExamLate || code == ERPExamPart1Late || code == ERPExamPart2Late)
            return 'late';
        return '';
    }
     private static Integer getGLCodeRankForLineItemSorting(String code) {
         if (code != null && code != '') {
             if(code == DEFERAL_FRM_PROD_CODE || code == ERP_PROD_KEY || code == ICBRR_NONMEM_PROD_CODE ||
               code == ICBRR_MEM_PROD_CODE || code == ICBRR_RETAKE_PROD_CODE || 
               code == FBR_MEM_PROD_CODE || code == FBR_NONMEM_PROD_CODE)
                 return 1;
             
             if(code == MEMBER_PROD_CODE || code == MEMBER_STUDENT_PROD_CODE || code == MEMBER_FREE_PROD_CODE)
                 return 2;
             
             if(code == FRMExamPart1Late
               || code == FRMExamPart1Standard
               || code == FRMExamPart1Early
               || code == FRMExamPart2Late
               || code == FRMExamPart2Standard
               || code == FRMExamPart2Early
               || code == ERPExamLate
               || code == ERPExamStandard
               || code == ERPExamEarly)
                 return 3;
             
             if(code == FRMPart2BooksNonCandidate
               || code == FRMPracticeExamsCandidate
               || code == EnergyCertificateCoursePackCandidate
               || code == FRMPart2BooksCandidate
               || code == FRMPart1BooksCandidate
               || code == FoundationHandbook
               || code == ICBRRHandBooks
               || code == ICBRRHandBooksIndividual
               || code == FRMPart1BooksNonCandidate
               || code == FRMPracticeExamsNonCandidate
               || code == EnergyCertificateCoursePackNonCandidate)
                 return 4;
                 
             if(code == SHIP_PROD_CODE)
                 return 5;

             if(code == PAY_DEFERRED_PROD_CODE)
                 return 6;

             if(code == TAX_PROD_CODE)
                 return 7;

             if(code == MISC_PROD_CODE)
                 return 7;
             
             return 99;
         } else return 99;
     }
     
         
    @TestVisible private static final String DEFERAL_FRM_PROD_CODE = 'FRM1';
    @TestVisible private static final String ERP_PROD_KEY = 'ENC';
    @TestVisible private static final String ICBRR_NONMEM_PROD_CODE = 'CBRNM';
    @TestVisible private static final String ICBRR_MEM_PROD_CODE = 'CBR';
    @TestVisible private static final String ICBRR_RETAKE_PROD_CODE = 'CBR2A';
    @TestVisible private static final String FBR_MEM_PROD_CODE = 'FCBR';
    @TestVisible private static final String FBR_NONMEM_PROD_CODE = 'FBRNM';
    @TestVisible private static final String MEMBER_PROD_CODE = 'MEMI';
    @TestVisible private static final String MEMBER_STUDENT_PROD_CODE = 'MEMS';
    @TestVisible private static final String MEMBER_FREE_PROD_CODE = 'MEMF';
    
    @TestVisible private static final String FRMExamPart1Late = 'FRM1L';
    @TestVisible private static final String FRMExamPart1Standard = 'FRM1S';
    @TestVisible private static final String FRMExamPart1Early = 'FRM1E';
    @TestVisible private static final String FRMExamPart2Late = 'FRM2L';
    @TestVisible private static final String FRMExamPart2Standard = 'FRM2S';
    @TestVisible private static final String FRMExamPart2Early = 'FRM2E';

    @TestVisible private static final String ERPExamPart1Late = 'ENC1L';
    @TestVisible private static final String ERPExamPart1Standard = 'ENC1S';
    @TestVisible private static final String ERPExamPart1Early = 'ENC1E';
    @TestVisible private static final String ERPExamPart2Late = 'ENC2L';
    @TestVisible private static final String ERPExamPart2Standard = 'ENC2S';
    @TestVisible private static final String ERPExamPart2Early = 'ENC2E';
    
    @TestVisible private static final String ERPExamLate = 'ENCL';
    @TestVisible private static final String ERPExamStandard = 'ENCS';
    @TestVisible private static final String ERPExamEarly = 'ENCE';
    @TestVisible private static final String FRMPart2BooksNonCandidate = 'FRM2N';
    @TestVisible private static final String FRMPracticeExamsCandidate = 'FRMCP';
    @TestVisible private static final String EnergyCertificateCoursePackCandidate = 'ENCCP';
    @TestVisible private static final String FRMPart2BooksCandidate = 'FRM2H';
    @TestVisible private static final String FRMPart1BooksCandidate = 'FRM1H';
    @TestVisible private static final String FoundationHandbook = 'FBRHB';
    @TestVisible private static final String ICBRRHandBooks = 'CBRHB';
    @TestVisible private static final String ICBRRHandBooksIndividual = 'CBRHI';
    @TestVisible private static final String FRMPart1BooksNonCandidate = 'FRM1N';
    @TestVisible private static final String FRMPracticeExamsNonCandidate = 'FRMCN';
    @TestVisible private static final String EnergyCertificateCoursePackNonCandidate = 'ENCBN';
    @TestVisible private static final String SHIP_PROD_CODE = 'SHIP';
    @TestVisible private static final String PAY_DEFERRED_PROD_CODE = 'PRFEE';
    @TestVisible private static final String TAX_PROD_CODE = 'SLSTX';
    @TestVisible private static final String MISC_PROD_CODE = 'MISC';
    
  
}