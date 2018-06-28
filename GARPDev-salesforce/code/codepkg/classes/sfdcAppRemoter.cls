global without sharing class sfdcAppRemoter {
  
    public String accountName { get; set; }
    public String accountEmail { get; set; }
    public static Account account { get; set; }
    public String startURL { get; set; }
    public String Examattemptid {get; set;}

    public String contactIdLoad { get; set; }


    public sfdcAppRemoter() { 
        String userId = UserInfo.getUserId();            
        List<User> lstUser = [Select u.Id,u.ContactId,Email from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) {
            
            List<Contact> lstContact = [select Id, Name, KPI_FRM_Certified__c, KPI_ERP_Certified__c,Email from Contact where Id = :lstUser[0].ContactId];
            if( lstContact != null && lstContact.size() > 0 ) {            
                accountEmail = lstContact[0].Email;
            }
        }        
    }
    
    global class appData { 
        public string name { get; set; }
        public string phone { get; set; }
    }
    
    global class fieldInfo {
        public string name { get; set; }
        public string type { get; set; }        
        public string label { get; set; }  
        public string description { get; set; }  
        public List<String> pickList { get; set; }   
        public string value { get; set; }  
        public Long epochValue { get; set; } 
        public string refValue { get; set; }  
        public string refOtherField { get; set; }  
        public integer order { get; set; }  
        public integer maxLength { get; set; }
        public boolean isCalculated { get; set; }
        public boolean isNillable { get; set; }
        public boolean readOnly { get; set; }
        public boolean hidden { get; set; }
        public boolean multiSelect { get; set; }
        
    }
    
    global class returnData {
        public List<sObject> recordData { get; set; }
        public Map<string,fieldInfo > fields { get; set; }
    }    

    global class getUserReturnData {
        public List<User> userData { get; set; }
        public List<Contact> contactData { get; set; }
        public List<Experience__c> experienceData { get; set; }
        public List<Account> accountData { get; set; }
        public List<Opportunity> opportunityData { get; set; }
        public List<ChargentSFA__Payment_Request__c> paymentRequestData  { get; set; }
        public List<ChargentSFA__Transaction__c> transactionData  { get; set; }        
        public List<ChargentSFA__Email_Notification__c> emailNoteData  { get; set; }        
        public List<PricebookEntry> priceBookEntryData { get; set; }
        public List<Product2> productData { get; set; }
        public List<Exam_Attempt__c> examAttemptData { get; set; }
        public List<Room__c> examRoomData { get; set; }
        public List<Venue__c> venueData { get; set; }
        public List<Exam_Result__c> examResultsData { get; set; }
        public List<Contract> contractData { get; set; }
        public List<Candidate_Requirement__c> candidateRequirementData { get; set; }                                
        public List<RecordType> candidateRequirementRecordTypes { get; set; }
        public List<RecordType> contractRecordTypes { get; set; }
        public List<CPE_Claim__c> claimsData { get; set; }
        public List<CPE_Activity_Type__c> activityTypeData { get; set; }
        public List<Account> providerData { get; set; }
        public List<CollaborationGroup> collaborationGroupsData { get; set; }
        public List<Chapter__c> chaptersData { get; set; }
        public List<Chapter_Member__c> chapterDirectorData { get; set; }
        public List<Chapter_Member__c> chapterMemberData { get; set; }
        public List<Chapter_Meeting__c> chapterMeetingData { get; set; }
        public List<Chapter_Meeting_Speaker__c> chapterMeetingSpeakerData { get; set; }        
        public List<Exam_Group__c> examGroupData { get; set; }   
        public List<Exam_Sites__c> examSitesData { get; set; }   
        public List<Proctor_Registration__c> proctorRegistrationData { get; set; }
        public Board_Election__c boardElectionData { get; set; }
        public List<RecordType> contentRecordTypeData { get; set; }
    }    

    public  class getExperienceData {
        public id contactid { get; set; }
        public id Accountid { get; set; }
        public string Accountname { get; set; }
        public string ExperienceType { get; set; }
        public string Title { get; set; }
        public string JobDescription { get; set; }
        public Date Enddate { get; set; }
        public Date StateDate { get; set; }
        
    }

    public class wrapperProductInfo
    {
        public string strProductCode {get;set;}
        public string strProductName {get;set;}
        public string strGLCode {get;set;}
        public string strDisplayName{get;set;}
        public boolean bFRMActivated{get;set;}
        public boolean bERPActivated{get;set;}
        public boolean bFRM1Deffered{get;set;}
        public boolean bFRM2Deffered{get;set;}
        public boolean bERPDeffered{get;set;}
        public boolean bERP1Deffered{get;set;}
        public boolean bERP2Deffered{get;set;}
        public boolean bFRM1UnDeffered{get;set;}
        public boolean bFRM2UnDeffered{get;set;}
        public boolean bERPUnDeffered{get;set;}
        public boolean bERP1UnDeffered{get;set;}
        public boolean bERP2UnDeffered{get;set;}
        public boolean bFRMSwitch{get;set;}
        public boolean bERPSwitch{get;set;}
        public String strFRMOneBookProdCode{get;set;}
        public String strFRMOneBookGLCode{get;set;}
        public decimal dFRMOneBookAmount{get;set;}
        public String strFRMTwoBookProdCode{get;set;}
        public String strFRMTwoBookGLCode{get;set;}
        public decimal dFRMTwoBookAmount{get;set;}
        public String strFRMOneEnrollmentProdCode{get;set;}
        public String strFRMOneEnrollmentGLCode{get;set;}
        public decimal dFRMOneEnrollmentAmount{get;set;}
        public decimal examPrice{get;set;}
        public String strERPBookProdCode{get;set;}
        public String strERPBookGLCode{get;set;}
        public decimal dERPBookAmount{get;set;}
        public String strERPEnrollmentProdCode{get;set;}
        public String strERPEnrollmentGLCode{get;set;}
        public decimal dERPEnrollmentAmount{get;set;}
        public string strFCBRMemberProdCode{get;set;}
        public string strFCBRNonMemberProdCode{get;set;}
        public string strFCBRMemberGlCode{get;set;}
        public string strFCBRNonMemberGlCode{get;set;} 
        public decimal dFCBRMemberExamAmt{get;set;}
        public decimal dFCBRNonMemberExamAmt{get;set;}
        public string strCBRMemberProdCode{get;set;}
        public string strCBRNonMemberProdCode{get;set;}
        public string strCBRMemberGlCode{get;set;}
        public string strCBRNonMemberGlCode{get;set;}
        public decimal dCBRMemberExamAmt{get;set;}
        public decimal dCBRNonMemberExamAmt{get;set;}
        public string strMemberProdCode{get;set;}
        public string strMemberGLCode{get;set;}
        public decimal dMemberAmt{get;set;}
        public string strWileyProdCode{get;set;}
        public string strWileyGLCode{get;set;}
        public string strIndividualProdCode{get;set;}
        public string strIndividualGLCode{get;set;}        
        public string strAffiliateGLCode{get;set;}
        public string strAffiliateProdCode{get;set;}
        public string strTaxGLCode{get;set;}
        public string strTaxProdCode{get;set;}
        public string strCanadianTaxGLCode{get;set;}
        public string strCanadianTaxProdCode{get;set;}
        public string strShippingGLCode{get;set;}
        public string strShippingProdCode{get;set;}
        public string strFreeIndividualProdCode{get;set;}
        public string strFreeIndividualGLCode{get;set;} 
        public string strDeferredPaymentGLCode{get;set;}
        public string strDeferrePaymentProdCode{get;set;}
    }
 
    global class productData {
        public List<Product2> product { get; set; }
        public List<PricebookEntry> price { get; set; }
    }

    global class productItems {
        public Product2 product { get; set; }
        public PricebookEntry price { get; set; }
    }
    
    global class contentData {
        public Content__c content { get; set; }
        public Attachment attachment { get; set; }
        public List<Related_Content__c> related_content { get; set; }
        public String memberTypeRequiredForAccess { get; set; }
    }    
               
    global class purchaseData {
        public String Id { get; set; }
        public String Price { get; set; }
    }

    global class purchaseCodeData {
        public String prodCode { get; set; }
        public String glCode { get; set; }
        public String price { get; set; }
        public String description { get; set; }
        public Integer months { get; set; }
        public Integer quantity { get; set; }
    }
    
    
    global class addressData {
        public String Address_1 { get; set; }
        public String Address_2 { get; set; }
        public String Address_3 { get; set; }
        public String City { get; set; }
        public String State_Provence { get; set; }
        public String Postal_Code { get; set; }
        public String Country { get; set; }
    }

    global class searchResults {
        public List<Contact> lstContact { get; set; }
        public List<User> lstUser { get; set; }        
        public Integer pages  { get; set; }
    }
    
    public class wrapperChapterMemberDetails
    {
        public Chapter_Member__c chapterMember { get; set; }
        public User user { get; set; }
    }
    
    public class wrapperChapterMeetingDetails
    {
        public Chapter_Meeting__c chapterMeeting { get; set; }
        public Integer registrationCount { get; set; }
        public List<wrapperChapterMemberDetails> chapterMembers { get; set; }
        public List<Chapter_Meeting_Speaker__c> speakers { get; set; }
    }
    
    public class productList {
        public String GLCode { get; set; }
        public String price { get; set; }
        public String ProductCode { get; set; }
        public String description { get; set; }
    }

    public class CPEActivitiesWrapper {
        public List<CPE_Activity__c> activities { get; set; }
        public List<Account> accounts { get; set; }
    }
    
    @RemoteAction
    public static List<Study_App_Lesson_Plan__c> getStudyTopics(String examName, String yearName) {
        List<Study_App_Lesson_Plan__c> lis =  [Select Id, Name, Description__c, Week__c, (Select Id, Name, Year__c, Description__c, Is_Online__c, URL__c, Chapter__c, Pages__c, Book__c, Study_Guide_Domain__r.Name from Study_Guide_Readings__r) 
         from Study_App_Lesson_Plan__c where Exam__c =: examName and Year__c = :yearName order by Week__c];
         return lis;
        
    
    }
    
    
    @RemoteAction
    public static getUserReturnData getOppData(string OppId) {
        
        List<Opportunity> lstOpportunity = [SELECT Id, Name, StageName, Amount, CreatedDate, Alternate_Method_of_Payment__c, Purchase_Date__c, LEGACY_Purchase_Date__c, Company__c, Shipping_First_Name__c, Shipping_Last_Name__c, Shipping_Street__c, Shipping_City__c, Shipping_State__c, Shipping_Postal_Code__c, Shipping_Country__c, Shipping_E_mail__c, Shipping_Phone_No__c, Shipping_Company_Name__c,  Display_Invoice_Number__c, Renew_Membership__c, ChargentSFA__Payment_Method__c, ChargentSFA__Payment_Received__c, ChargentSFA__Billing_First__c, ChargentSFA__Billing_Last__c, ChargentSFA__Billing_Phone__c, ChargentSFA__Billing_Email__c, ChargentSFA__Billing_Company__c, ChargentSFA__Billing_Address__c, ChargentSFA__Billing_City__c, ChargentSFA__Billing_State__c, ChargentSFA__Billing_Zip__c, ChargentSFA__Billing_Country__c, ChargentSFA__Billing_Postcode__c, Switch_to_erp__c, Switch_to_frm__c, Purchase_Date_Time__c, (SELECT Id,Description,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice FROM OpportunityLineItems) FROM Opportunity where Id = :OppId order by Purchase_Date__c];
        getUserReturnData rd = new getUserReturnData();
        if( lstOpportunity != null && lstOpportunity.size() > 0 ) {
            
            rd.opportunityData = lstOpportunity;
            set<id> opportunityIds = new set<id>();
            set<id> productIds = new set<id>();
            for(Opportunity o :lstOpportunity){
                opportunityIds.add(o.id); 
                
                for(OpportunityLineItem ol :o.OpportunityLineItems){
                    productIds.add(ol.PricebookEntryId);
                }
            }
            List<PricebookEntry> lstPriceBookEntry = [SELECT Id, Name, Product2Id, ProductCode from PriceBookEntry where Id in :productIds];
            
            rd.priceBookEntryData = lstPriceBookEntry;
            List<Id> prods = new List<Id>();
            for(PricebookEntry pe : lstPriceBookEntry) {
                prods.add(pe.Product2Id);
            }

            List<Product2> lstProducts = [select Id, Name, ProductCode, GL_Code__c, Description, Image__c from Product2 where Id in :prods];
            rd.productData = lstProducts;
            
        }
        return rd;
    }    
    
    @RemoteAction
    public static Boolean restoreAMPFee(String oppId) {
        
        if(oppId == null || oppId == '' || oppId == 'null')
            return false;
    
        Opportunity opp = [select Id, Name, Amount, ChargentSFA__Tokenization__c, (SELECT Id,Description,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice FROM OpportunityLineItems) from Opportunity where id = :oppId];
           if(opp != null) {
                PriceBookEntry pricebookEntry = [select Id, unitprice, productcode, product2.Gl_Code__c from PriceBookEntry where Pricebook2.IsActive = true and product2.productcode = 'PRFEE' and product2.Gl_Code__c = '6110' and isActive = true];
                if(pricebookEntry != null) {

                    List<OpportunityLineItem> lis = new List<OpportunityLineItem>();
                    for(OpportunityLineItem ol :opp.OpportunityLineItems){
                        if(ol.PricebookEntryId == pricebookEntry.Id) {
                            ol.TotalPrice = 50;
                            lis.add(ol);
                        }
                    }
                    update lis;
                    return true;
                }
           }            
           return false;
    }
    
    @RemoteAction
    public static List<RecordType> getContentRecordTypes() {
        List<RecordType> lstRecordTypes = [select Id, sobjectType, Name, DeveloperName from RecordType where sobjectType = 'Content__c'];
        return lstRecordTypes;
    }

    @RemoteAction
    public static List<Exam_Sites__c> getChangeExamSites(String examAttemptId) {

        Exam_Attempt__c ea = [select Id, Name, Exam_Site__r.Site__c, Exam_Site__r.Site__r.Name, Exam_Site__c,Exam_Site__r.Exam__r.Name, Exam_Site__r.Exam__r.Exam__c, Exam_Site__r.Exam_Date__c, Exam_Site__r.Exam__r.Exam_Date__c, Exam_Site__r.Exam__r.Exam_Group__c, Exam_Site__r.Exam__r.Exam_Group__r.Active__c from Exam_Attempt__c where Id = :examAttemptId];
        if(ea != null) {            
            List<Exam_Sites__c> lstEs = [select Id, Name, Site__c, Site__r.Active__c, Site__r.Name, Exam__c, Exam__r.Exam__c from Exam_Sites__c where Exam__r.Exam__c = :ea.Exam_Site__r.Exam__r.Exam__c and Exam__c = :ea.Exam_Site__r.Exam__c and Site__r.Active__c = true];
            return lstEs;
        }
        return null;
    }


    @RemoteAction
    public static Boolean setCVSubmission(String progReqId) {            
        String userId = UserInfo.getUserId(); 
        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        if( lstUser != null && lstUser.size() > 0 ) {
            List<Contact> lstContact = [select Id, Name, KPI_FRM_Certified__c, KPI_ERP_Certified__c from Contact where Id = :lstUser[0].ContactId];
            if( lstContact != null && lstContact.size() > 0 ) { 
                Date now = date.today();
                Candidate_Requirement__c cr = [select Id, Name, Date_of_Ready_for_Review__c, Status__c from Candidate_Requirement__c where Id=:progReqId];
                if(cr != null) {
                    cr.Date_of_Ready_for_Review__c = now;
                    cr.Status__c = 'Ready For Review';
                    update cr;
                    return true;
                }
            }
        }
        return false;
    }
    
    @RemoteAction
    public static Boolean setNoTwoyears(String progReqId) {            
        String userId = UserInfo.getUserId(); 
        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        if( lstUser != null && lstUser.size() > 0 ) {
            List<Contact> lstContact = [select Id, Name, KPI_FRM_Certified__c, KPI_ERP_Certified__c from Contact where Id = :lstUser[0].ContactId];
            if( lstContact != null && lstContact.size() > 0 ) { 
                Date now = date.today();
                Candidate_Requirement__c cr = [select Id, Name, Date_No_Two_Years__c from Candidate_Requirement__c where Id=:progReqId];
                if(cr != null) {
                    cr.Date_No_Two_Years__c = now;
                    update cr;
                    return true;
                }
            }
        }
        return false;
    }
    
    @RemoteAction
    public static Boolean changeExamSite(String examAttemptId, String newExamSiteId) {
        
        String userId = UserInfo.getUserId(); 
        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        if( lstUser != null && lstUser.size() > 0 ) {
            List<Contact> lstContact = [select Id, Name, KPI_FRM_Certified__c, KPI_ERP_Certified__c from Contact where Id = :lstUser[0].ContactId];
            if( lstContact != null && lstContact.size() > 0 ) {            

                                
                //List<Exam_Attempt__c> eas = [select Id, Name, Member__c, Defered__c, Exam_Site__r.Site__c, Exam_Site__r.Site__r.Name, Exam_Site__c,Exam_Site__r.Exam__r.Name, Exam_Site__r.Exam__r.Exam__c, Exam_Site__r.Exam_Date__c, Exam_Site__r.Exam__r.Exam_Date__c, Exam_Site__r.Exam__r.Exam_Group__c, Exam_Site__r.Exam__r.Exam_Group__r.Active__c from Exam_Attempt__c where Member__c = :lstContact[0].Id and Defered__c != 'Pending'];
                List<Exam_Attempt__c> eas = [select Id, Name, Member__c, Defered__c, Exam_Site__r.Site__c, Exam_Site__r.Site__r.Name, Exam_Site__c,Exam_Site__r.Exam__r.Name, Exam_Site__r.Exam__r.Exam__c, Exam_Site__r.Exam_Date__c, Exam_Site__r.Exam__r.Exam_Date__c, Exam_Site__r.Exam__r.Exam_Group__c, Exam_Site__r.Exam__r.Exam_Group__r.Active__c from Exam_Attempt__c where Member__c = :lstContact[0].Id];
                Id examGroupId = null;
                Exam_Attempt__c inEA = null;
                for(Exam_Attempt__c ea: eas) {
                    if(ea.Id == examAttemptId) {
                        examGroupId = ea.Exam_Site__r.Exam__r.Exam_Group__c;
                        inEA = ea;
                    }
                }
                
                List<Exam_Sites__c> lstEs = [select Id, Name, Site__c, Site__r.Active__c, Site__r.Name, Exam__c, Exam__r.Exam__c from Exam_Sites__c where Exam__r.Exam__c = :inEA.Exam_Site__r.Exam__r.Exam__c and Exam__c = :inEA.Exam_Site__r.Exam__c and Site__r.Active__c = true];
                String siteName = '';                
                for(Exam_Sites__c es :lstEs) {
                    if(es.Id == newExamSiteId)
                        siteName = es.Site__r.Name;
                }
                
                system.debug('* * * examGroupId ...'+ examGroupId);
                
                if(siteName!='') {
                    for(Exam_Attempt__c ea: eas) {
                        if(ea.Exam_Site__r.Exam__r.Exam_Group__c == examGroupId) {
                            
                            system.debug('* * * In examGroupId ...'+ ea.Id + ':');
                            
                            if(ea.Id == examAttemptId) {
                                ea.Exam_Site__c = newExamSiteId;
                            } else {                            
                                List<Exam_Sites__c> lstOtherEs = [select Id, Name, Site__c, Site__r.Active__c, Site__r.Name, Exam__c, Exam__r.Exam__c from Exam_Sites__c where Exam__r.Exam__c = :ea.Exam_Site__r.Exam__r.Exam__c and Exam__c = :ea.Exam_Site__r.Exam__c and Site__r.Active__c = true];
                                for(Exam_Sites__c es :lstOtherEs) {
                                    if(es.Site__r.Name == siteName)
                                        ea.Exam_Site__c = es.Id;
                                }
                            }
                        }
                    }
                }
                update eas;
                return true;
            }
        }        
        return false;
    }
    
    public static Registration.wrapperCreateOrder prepareWCO(Registration.wrapperCreateOrder wco, ID oppID) {
        if(oppID != null) {
            getUserReturnData ird = getOppData(oppID);
            if(ird != null && ird.opportunityData != null && ird.priceBookEntryData != null &&
               ird.opportunityData.size() > 0 && ird.priceBookEntryData.size() > 0) {
                wco.invoiceNumber = ird.opportunityData[0].Display_Invoice_Number__c;
                wco.company = ird.opportunityData[0].Company__c;
                
                Map<ID,String> mapPrice = new Map<ID,String>();
                Map<ID,ID> mapPriceID = new Map<ID,ID>();
                for(PriceBookEntry pe :ird.priceBookEntryData) {
                    mapPrice.put(pe.Id, pe.ProductCode);
                    mapPriceID.put(pe.Id,pe.Product2Id);
                }
                system.debug('mapPrice:' + mapPrice);
                system.debug('mapPriceID:' + mapPriceID);
    
                Map<ID,Product2 > mapProd = new Map<ID,Product2 >();
                for(Product2 prod :ird.productData) {
                    mapProd.put(prod.Id, prod);
                }
                system.debug('mapProd:' + mapProd);
                       
                String productDetails = '';
                wco.totalCost=0;
                for(OpportunityLineItem ol :ird.opportunityData[0].OpportunityLineItems){
                    String prodCode = mapPrice.get(ol.PricebookEntryId);
                    ID prodId = mapPriceID.get(ol.PricebookEntryId);
                    if(prodCode != null && prodId != null) {
                        Product2 prod = mapProd.get(prodId);
                        if(prod != null) {
                            system.debug('prodCode:' + prodCode);
                            system.debug('prod:' + prod);
                            system.debug('ol.TotalPrice:' + ol.TotalPrice);
                            
                            wco.totalCost += ol.TotalPrice;
                            
                            if(prodCode != NULL && prodCode == 'SLSTX')
                                wco.tax = ol.TotalPrice;
                            if(prodCode != NULL && prodCode == 'SHIP')
                                wco.shipping = ol.TotalPrice;
    
                            if(productDetails == '') {
                                productDetails = prodCode + '~' + prod.GL_Code__c + '~' + prod.Name + '~' + ol.TotalPrice + '~' + ol.Quantity;
                            } else {
                                productDetails = productDetails + '!' + prodCode + '~' + prod.GL_Code__c + '~' + prod.Name + '~' + ol.TotalPrice + '~' + ol.Quantity;
                            }
                            
                            system.debug('productDetails:' + productDetails);
                        }
                    }
                }
                wco.productDetails = productDetails;
        }                   
        }
        return wco;
    }
    
    @RemoteAction
    public static Registration.wrapperCreateOrder createOtherexams(List<productList> lstProdCodeWithAmount, TempAccount tempAccount){
        system.debug('lstProdCodeWithAmount == '+lstProdCodeWithAmount);
        Map<String,string[]> mapProdDetails = new Map<String,string[]>();
        for(productList objProd : lstProdCodeWithAmount)
        {
            string[] arrayGLPrice = new string[3];
            arrayGLPrice[0] = objProd.GLCode;
            if(objProd.price != null)
                arrayGLPrice[1] = objProd.price;
            if(objProd.description != null)
                arrayGLPrice[2] = objProd.description;
            mapProdDetails.put(objProd.ProductCode,arrayGLPrice);
        }
        system.debug('mapProdDetails == '+mapProdDetails);
        Registration.wrapperCreateOrder wco = FBRICBRUtils.generateOrders(mapProdDetails, tempAccount);
        if(wco != null && wco.opportunityId != null)
            wco = prepareWCO(wco, wco.opportunityId);
        return wco;
    }    

    @RemoteAction
    public static Boolean deleteOrder(String oppId){
        return Registration.removeOrder(oppId, true);   
    }
    
    // For Registration
    @RemoteAction
    public static Boolean removeOrder(String oppId){
        return Registration.removeOrder(oppId, true);   
    }
    
    @RemoteAction
    public static Contact setContactInfo(TempAccount tempAccount){
        return Registration.setContactInfo(tempAccount);   
    }
        
    @RemoteAction
    public static Registration.wrapperGetContact getContactInfo(String contactId){
        return Registration.getContactInfo(contactId);   
    }
                   
    
    @RemoteAction
    public static Registration.wrapperCreateOrder createOrderForPortalUsers(TempAccount objData){
        Registration.wrapperCreateOrder wco = Registration.createOrderForPortalUsers(objData); 
        if(wco != null && wco.opportunityId != null)
            wco = prepareWCO(wco, wco.opportunityId);
        return wco;
    }
    
        
    @RemoteAction
    public static Registration.wrapperCreateOrder createOrder(TempAccount objData){
        Registration.wrapperCreateOrder wco = Registration.CreateOrder(objData);    
        if(wco != null && wco.opportunityId != null)
            wco = prepareWCO(wco, wco.opportunityId);
        return wco;
    }
        
    @RemoteAction
    public static Id setLead(String email, String firstName, String LastName, String garpMembershipType){
        return Registration.setLead(email, firstName, lastName, garpMembershipType);   
    }

    @RemoteAction
    public static Registration.wrapperCheckExistingMember CheckExistingMember(String email){
        return Registration.CheckExistingMember(email);   
    }
        
    @RemoteAction
    public static Date getTestDate(){
        return Registration.testDate();   
    }

    @RemoteAction
    public static Date getRegistrationDate(){
        return Registration.registrationDate();   
    }
    
    @RemoteAction
    public static set<String> getActiveSites(){
        return Registration.getActiveSites();   
    }
    
    @RemoteAction
    public static Map<String,Registration.wrapperProductInfo> getExamProducts(String strExamName) {            
      return Registration.getProductCodes1(strExamName);
    }
    
    @RemoteAction
    public static void autoRenewOff(boolean bAutoOff) {            
      MemberShipAutoRenew.autoRenewOff(bAutoOff);
    }
 
    @RemoteAction
    public static Registration.wrapperCreateOrder autoRenew(boolean bIsCurrentDay,string strProductCode,string AMP,Boolean wiley) {        
        Registration.wrapperCreateOrder wco = MemberShipAutoRenew.autorenew(bIsCurrentDay,strProductCode,AMP,wiley);
        if(wco != null && wco.opportunityId != null)
            wco = prepareWCO(wco, wco.opportunityId);
        return wco;        
    }

    @RemoteAction
    public static String VoidRecurring(String oppid){
        return MemberShipAutoRenew.VoidRecurring(oppid);
    }
        
    @RemoteAction
    public static ID createoppRecurring(String strProductCode){
        return MemberShipAutoRenew.createoppRecurring(strProductCode);
    }
          
    @RemoteAction
    public static String RecurringFuture(id oppid,String cardMonth,String cardYear,String paymentType,String cardType,String cardSecurity,String cardNumber){
        return MembershipAutoRenew.RecurringFuture(oppid,cardMonth, cardYear, paymentType, cardType, cardSecurity, cardNumber);
    }
 
    @RemoteAction
    public static List<wrapperUtils.wrapperProductDetails> renewContractcheck(){
        return PortalClass.checkrenewMemberShip();
    }

    @RemoteAction
    public static Registration.wrapperCreateOrder createcontractextension(String strProductCode, String AMP, Boolean Wiley){
        Registration.wrapperCreateOrder wco = PortalClass.extendMembership(strProductCode, AMP, Wiley);
        if(wco != null && wco.opportunityId != null)
            wco = prepareWCO(wco, wco.opportunityId);
        return wco;        
    }

    @RemoteAction 
    public static List<wrapperUtils.upsWrapper> getUPSPrice(string strAddress1,string strAddress2,string strCity,string strCountry,string strStateCode,string strZip,LIST<String> products) {        
        return UPSServices.getUPSPrice(strAddress1,strAddress2,strCity,strCountry,strStateCode,strZip,products);
    }
    
    @RemoteAction
    public static List<User> verifyAuth() {            
        String userId = UserInfo.getUserId(); 
        Boolean found = false;
        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        if( lstUser != null && lstUser.size() > 0 ) {
            List<Contact> lstContact = [select Id, Name, KPI_FRM_Certified__c, KPI_ERP_Certified__c from Contact where Id = :lstUser[0].ContactId];
            if( lstContact != null && lstContact.size() > 0 ) {            
                found=true;
            }
        }
        return lstUser;
    }
 
    @RemoteAction
    public static void logError(String errorObject, String msg, String file, String method) {            
        String userId = UserInfo.getUserId();            
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) {
            
            List<Contact> lstContact = [select Id, Name, KPI_FRM_Certified__c, KPI_ERP_Certified__c from Contact where Id = :lstUser[0].ContactId];
            if( lstContact != null && lstContact.size() > 0 ) {            
                AppError__c appError = new AppError__c();
                appError.Error__c = errorObject;
                appError.Contact__c = lstContact[0].Id;
                appError.Message__c = msg;
                appError.File__c = file;
                appError.Method__c = method;
                insert appError;
            }            
        }
    }
        
    public List<contentData> filterContentDocs(List<Content__c> lstDocs, Integer maxReturn) {
        
        List<Attachment> lstAttachments;
        List<Related_Content__c> lstRelated;
        List<contentData> lstContentData = new List<contentData>();

        Boolean bFRMCandidate = false;
        Boolean bFRMHolder = false;
        Boolean bFRMCertified = false;
        Boolean bERPCandidate = false;
        Boolean bERPHolder = false;
        Boolean bERPCertified = false;
        String memberType = '';
        String frmStatus;
        String erpStatus;
        String memStatus;
        Integer cnt=0;
        String userId = UserInfo.getUserId();        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) {
        
            String contactId = lstUser[0].ContactId;
 
            system.debug('* * * contactId ...'+ contactId);
            
            List<Contact> lstContact = [SELECT Id, Name, KPI_FRM_Candidate_Payment_Status__c, KPI_ERP_Candidate_Payment_Status__c, KPI_Membership_Payment_Status__c, KPI_FRM_Candidate__c, KPI_FRM_Holder__c, KPI_FRM_Certified__c, KPI_ERP_Candidate__c, KPI_ERP_Holder__c, KPI_ERP_Certified__c,Membership_Type__c  FROM Contact WHERE Id = :contactId];
            
            if( lstContact != null && lstContact.size() > 0 ) {
                Contact cont = lstContact[0];
                bFRMCandidate = cont.KPI_FRM_Candidate__c;
                bFRMHolder = cont.KPI_FRM_Holder__c;
                bFRMCertified = cont.KPI_FRM_Certified__c;
                bERPCandidate = cont.KPI_ERP_Candidate__c;
                bERPHolder = cont.KPI_ERP_Holder__c;
                bERPCertified = cont.KPI_ERP_Certified__c;
                memberType = cont.Membership_Type__c;
                frmStatus = cont.KPI_FRM_Candidate_Payment_Status__c;
                erpStatus = cont.KPI_ERP_Candidate_Payment_Status__c;
                memStatus = cont.KPI_membership_Payment_Status__c;
            }
        }
        
        if( lstDocs != null && lstDocs.size() > 0 ) {           
            lstAttachments = [Select Id, Name, ParentId from Attachment where ParentId in :lstDocs order by LastModifiedDate];
            
            for(Content__c doc :lstDocs){    
                contentData contentData = new contentData();
                contentData.content = doc;
                datetime nowDateTime = datetime.now();
                Boolean addContent = false;
                if(doc.End_Date__c == null && doc.Start_Date__c != null && nowDateTime >= doc.Start_Date__c) {
                    addContent = true;
                } else if(doc.Start_Date__c == null && doc.End_Date__c != null && nowDateTime < doc.End_Date__c) {
                    addContent = true;
                } else if(doc.Start_Date__c != null && doc.End_Date__c != null && nowDateTime >= doc.Start_Date__c && nowDateTime < doc.End_Date__c) {
                    addContent = true;
                } else if(doc.Start_Date__c == null && doc.End_Date__c == null){
                    addContent = true;
                }
                
                Boolean addVisContent = false;
                if(doc.Visibility_FRM__c != null) {
                    if((doc.Visibility_FRM__c == 'Certified' && bFRMCertified) ||
                       (doc.Visibility_FRM__c == 'Holder' && (bFRMCertified || bFRMHolder)) ||
                       (doc.Visibility_FRM__c == 'Candidate' && bFRMCandidate)) {
                           if(frmStatus != null && frmStatus == 'In Good Standing') {
                               addVisContent = true;    
                           }
                       }
                }
                if(doc.Visibility_ERP__c != null) {
                    if((doc.Visibility_ERP__c == 'Certified' && bERPCertified) ||
                       (doc.Visibility_ERP__c == 'Holder' && (bERPCertified || bERPHolder)) ||
                       (doc.Visibility_ERP__c == 'Candidate' && bERPCandidate)) {
                           if(erpStatus != null && erpStatus == 'In Good Standing') {
                               addVisContent = true;
                           }
                       }
                }
                if(doc.Visibility_Membership__c != null) {
                    if(doc.Visibility_Membership__c == 'Paid' && (memberType == 'Individual' || memberType == 'Student')) {
                        //Membership has lapsed 
                        if(memStatus != null && memStatus == 'In Good Standing') {
                            contentData.memberTypeRequiredForAccess = 'N/A';   
                        }
                        else {
                            contentData.memberTypeRequiredForAccess = doc.Visibility_Membership__c;    
                        }
                    }  
                    else {
                        //Does not have the Requisite permissions to view the article
                        contentData.memberTypeRequiredForAccess = doc.Visibility_Membership__c;   
                    }  
                }
                if(doc.Visibility_FRM__c == null && doc.Visibility_ERP__c == null && doc.Visibility_Membership__c == null) {
                    contentData.memberTypeRequiredForAccess = 'N/A'; 
                }
                
                if(addContent == true) {
                    for(Attachment att :lstAttachments){
                        if(att.ParentId == doc.Id) {
                            contentData.attachment = att;
                            break;
                        }
                    }
                    
                    lstContentData.add(contentData);
                    cnt++;
                    if(maxReturn != null && cnt >= maxReturn)
                        break;
                }    
            }                
        }                
        return lstContentData;
        
    }
    
    @RemoteAction    
    public static String Charge(Id oppId,String cardMonth,String cardYear,String paymentType,String cardType,String cardSecurity,String cardNumber) {
        return Registration.Charge(oppId, cardMonth, cardYear, paymentType, cardType, cardSecurity, cardNumber);
    }

        
    @RemoteAction    
    public static List<ChargentSFA__Transaction__c> getInvoicePayments(String oppId) {
        
        List<ChargentSFA__Transaction__c> lstPay = [select Id, Name, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c from ChargentSFA__Transaction__c where ChargentSFA__Opportunity__c = :oppId];
        return lstPay;
        
    }
    
    @RemoteAction
    public static List<contentData> getContentRegistrations(List<String> productCodes){
        List<Content__c> lstDocs;
        List<Attachment> lstAttachments;
        List<Related_Content__c> lstRelated;
        List<contentData> lstContentData = new List<contentData>();

        sfdcAppRemoter sr = new sfdcAppRemoter();

        lstDocs = [Select Id, Name, Content_Name__c, RecordTypeId, Description__c, SKU__c, Is_advertisement__c, Image__c, Third_Party_Author__c, Author__r.Name, Content_Type__c, Published_Date__c, Story__c, Topic__c, Start_Date__c, End_Date__c, Third_Party_URL__c, Duration_in_Minutes__c, Event_Date_Time__c, Is_On_Demand__c, Moderators__c, Presenters__c, Visibility_ERP__c, Visibility_FRM__c, Visibility_Membership__c, Location__c from Content__c where Status__c = 'Active' and Is_advertisement__c != true and 
                   SKU__c in :productCodes];
        
        lstContentData = sr.filterContentDocs(lstDocs, null); 
        return lstContentData;
    }
        
    
    @RemoteAction
    public static List<contentData> getEventContentDocs(Integer month, Integer year, Boolean upcoming){
        
        List<Content__c> lstDocs;
        List<contentData> lstContentData = new List<contentData>();

        sfdcAppRemoter sr = new sfdcAppRemoter();
        
        Date today = Date.Today();
        Integer queryMonth = 0;
        Integer queryYear = today.Month();

        Id webcastRecordTypeId = RecordTypeHelper.GetRecordTypeId('Content__c','Webcast');
        Id eventRecordTypeId = RecordTypeHelper.GetRecordTypeId('Content__c','Event');
        
        //System.assert(false, 'BOOM!' + eventRecordTypeId);
        
        if(upcoming) {
            lstDocs = [Select Id, Name, Content_Name__c, RecordTypeId, Description__c, SKU__c, Is_advertisement__c, Image__c, Third_Party_Author__c, Author__r.Name, Content_Type__c, Published_Date__c, Story__c, Topic__c, Start_Date__c, End_Date__c, Third_Party_URL__c, Duration_in_Minutes__c, Event_Date_Time__c, Is_On_Demand__c, Moderators__c, Presenters__c, Visibility_ERP__c, Visibility_FRM__c, Visibility_Membership__c, Location__c from Content__c where 
                       Status__c = 'Active' and Is_advertisement__c != true and (Published_Date__c >= :today or Event_Date_Time__c>= :today) and 
                       (RecordTypeId = :webcastRecordTypeId OR RecordTypeId = :eventRecordTypeId)];
        } else if((month > -1 && year > -1) || (month > -1 && year == -1)) {
            if(month > -1)
                queryMonth = month;
            if(year > -1)
                queryYear = year;
            lstDocs = [Select Id, Name, Content_Name__c, RecordTypeId, Description__c, SKU__c, Is_advertisement__c, Image__c, Third_Party_Author__c, Author__r.Name, Content_Type__c, Published_Date__c, Story__c, Topic__c, Start_Date__c, End_Date__c, Third_Party_URL__c, Duration_in_Minutes__c, Event_Date_Time__c, Is_On_Demand__c, Moderators__c, Presenters__c, Visibility_ERP__c, Visibility_FRM__c, Visibility_Membership__c, Location__c from Content__c where 
                       Status__c = 'Active' and Is_advertisement__c != true and ((CALENDAR_MONTH(Published_Date__c) = :queryMonth and CALENDAR_MONTH(Published_Date__c) = :queryMonth) or (CALENDAR_MONTH(Event_Date_Time__c) = :queryMonth and CALENDAR_MONTH(Event_Date_Time__c) = :queryMonth)) and
                       ((CALENDAR_YEAR(Published_Date__c) = :queryYear and CALENDAR_YEAR(Published_Date__c) = :queryYear) or (CALENDAR_YEAR(Event_Date_Time__c) = :queryYear and CALENDAR_YEAR(Event_Date_Time__c) = :queryYear)) and
                      (RecordTypeId = :webcastRecordTypeId OR RecordTypeId = :eventRecordTypeId)];
        } else {                
            lstDocs = [Select Id, Name, Content_Name__c, RecordTypeId, Description__c, SKU__c, Is_advertisement__c, Image__c, Third_Party_Author__c, Author__r.Name, Content_Type__c, Published_Date__c, Story__c, Topic__c, Start_Date__c, End_Date__c, Third_Party_URL__c, Duration_in_Minutes__c, Event_Date_Time__c, Is_On_Demand__c, Moderators__c, Presenters__c, Visibility_ERP__c, Visibility_FRM__c, Visibility_Membership__c, Location__c from Content__c where Status__c = 'Active' and Is_advertisement__c != true and 
                       (RecordTypeId = :webcastRecordTypeId OR RecordTypeId = :eventRecordTypeId)];
        }
        
        lstContentData = sr.filterContentDocs(lstDocs, null); 
        return lstContentData;
    }     
    
    
    @RemoteAction
    public static wrapperChapterMeetingDetails getChapterMeetingDetail(String meetingId){
        
        List<Chapter_Meeting__c> lstChapterMeeting = [select Id, Name, Chapter_Meeting_Name__c, Synopsis__c, Start__c, End__c, Time_Zone__r.Abbreviation__c, Time_Zone__r.Name, Time_Zone__r.Add_This_Event_Zone__c, Status__c, Chapter__c, Chapter__r.Name, Chapter_Meeting_Location__r.Address_Street_1__c, Chapter_Meeting_Location__r.Address_Street_2__c, Chapter_Meeting_Location__r.Venue_Location__c, Chapter_Meeting_Location__r.Address_City__c, Chapter_Meeting_Location__r.Address_State_Provence__c , Chapter_Meeting_Location__r.Name, Chapter_Meeting_Location__r.Address_Postal_Code__c, Presentation__c, Ceremony__c, Group_Formation__c from Chapter_Meeting__c where Id = :meetingId];    
        
        if(lstChapterMeeting != null && lstChapterMeeting.size() > 0) {
            
            Chapter_Meeting__c chapterMeeting = lstChapterMeeting[0];
            
            if(chapterMeeting.Status__c == 'Active') {
                List<aggregateResult> chaptReg = [select count(Id) total, Chapter_Meeting__c from Chapter_Meeting_Registration__c where Chapter_Meeting__c = :meetingId group by Chapter_Meeting__c];
        
                List<Chapter_Member__c> lstChaptMem = [select Id, Name, Title__c, Chapter_Director_Bio__c, Contact__c, Contact__r.Name, Contact__r.Email, Director__c, Committee_Member__c from Chapter_Member__c where Chapter__c = :chapterMeeting.Chapter__c];
                Map<Id,Chapter_Member__c> chaptMemMap = new Map<Id,Chapter_Member__c>();
                for(Chapter_Member__c cm : lstChaptMem) {
                    if(cm.Contact__c != null)
                        chaptMemMap.put(cm.Contact__c, cm);
                }   
                  
                //System.assert(false, '* * * chaptMemMap: ' + chaptMemMap.keySet());
                
                List<User> lstUser = [Select ContactId, SmallPhotoUrl, FullPhotoUrl From User where ContactId in :chaptMemMap.keySet()];
                
                List<wrapperChapterMemberDetails> lstChaptMemDetails = new List<wrapperChapterMemberDetails>();
                for(User u : lstUser) {
                    wrapperChapterMemberDetails wcmd = new wrapperChapterMemberDetails();
                    wcmd.chapterMember = chaptMemMap.get(u.ContactId);
                    wcmd.user = u;
                    lstChaptMemDetails.add(wcmd);
                }
                
                List<Chapter_Meeting_Speaker__c> lstChapterMeetingSpeakers = [select Id, Name, Chapter_Meeting__c, Chapter_Speaker__r.Name, Chapter_Speaker__r.First_Name__c, Chapter_Speaker__r.Last_Name__c, Chapter_Speaker__r.Qualifications__c, Chapter_Speaker__r.Biography__c, Chapter_Speaker__r.Contact__c from Chapter_Meeting_Speaker__c where Chapter_Meeting__c = :meetingId];
                
                wrapperChapterMeetingDetails wcm = new wrapperChapterMeetingDetails();
                wcm.chapterMembers = lstChaptMemDetails;
                wcm.speakers = lstChapterMeetingSpeakers;
                if(chapterMeeting != null) {
                    wcm.chapterMeeting = chapterMeeting;
                    if(chaptReg != null && chaptReg.size() > 0) {
                        wcm.registrationCount = (Integer)chaptReg[0].get('total');
                    } else {
                        wcm.registrationCount = 0;            
                    }
                    return wcm;
                } else {
                    return null;
                }
            } else {
                return null;
            }
            
        } else {
            return null;
        }

    }
    
    @RemoteAction
    public static List<wrapperChapterMeetingDetails> getChapterMeetingDetails(Integer month, Integer year, Boolean upcoming){

        Date today = Date.Today();
        Integer queryMonth = 0;
        Integer queryYear = today.Month();
        List<Chapter_Meeting__c> lstChapterMeetings;
        
        if(upcoming) {
            lstChapterMeetings = [select Id, Name, Chapter_Meeting_Name__c, Synopsis__c, Start__c, End__c, Time_Zone__r.Abbreviation__c, Time_Zone__r.Name, Status__c, Chapter__c, Chapter__r.Name, Chapter_Meeting_Location__r.Address_Street_1__c, Chapter_Meeting_Location__r.Address_Street_2__c, Chapter_Meeting_Location__r.Address_Country__c, Chapter_Meeting_Location__r.Venue_Location__c, Chapter_Meeting_Location__r.Address_City__c, Chapter_Meeting_Location__r.Address_State_Provence__c , Chapter_Meeting_Location__r.Name, Chapter_Meeting_Location__r.Address_Postal_Code__c, Presentation__c, Ceremony__c, Group_Formation__c from Chapter_Meeting__c where Chapter__r.Status__c = 'Active' and Status__c = 'Active' and Start__c >= :today];    
        } else if((month > -1 && year > -1) || (month > -1 || year == -1)) {
            if(month > -1)
                queryMonth = month;
            if(year > -1)
                queryYear = year;
            lstChapterMeetings = [select Id, Name, Chapter_Meeting_Name__c, Synopsis__c, Start__c, End__c, Time_Zone__r.Abbreviation__c, Time_Zone__r.Name, Status__c, Chapter__c, Chapter__r.Name, Chapter_Meeting_Location__r.Address_Street_1__c, Chapter_Meeting_Location__r.Address_Street_2__c, Chapter_Meeting_Location__r.Address_Country__c, Chapter_Meeting_Location__r.Venue_Location__c, Chapter_Meeting_Location__r.Address_City__c, Chapter_Meeting_Location__r.Address_State_Provence__c , Chapter_Meeting_Location__r.Name, Chapter_Meeting_Location__r.Address_Postal_Code__c, Presentation__c, Ceremony__c, Group_Formation__c from Chapter_Meeting__c where 
                                  Status__c = 'Active' and CALENDAR_YEAR(Start__c) = :queryYear and CALENDAR_MONTH(Start__c) = :queryMonth];    
        } else if(year > -1 && month== -1) {
            lstChapterMeetings = [select Id, Name, Chapter_Meeting_Name__c, Synopsis__c, Start__c, End__c, Time_Zone__r.Abbreviation__c, Time_Zone__r.Name, Status__c, Chapter__c, Chapter__r.Name, Chapter_Meeting_Location__r.Address_Street_1__c, Chapter_Meeting_Location__r.Address_Street_2__c, Chapter_Meeting_Location__r.Address_Country__c, Chapter_Meeting_Location__r.Venue_Location__c, Chapter_Meeting_Location__r.Address_City__c, Chapter_Meeting_Location__r.Address_State_Provence__c , Chapter_Meeting_Location__r.Name, Chapter_Meeting_Location__r.Address_Postal_Code__c, Presentation__c, Ceremony__c, Group_Formation__c from Chapter_Meeting__c where 
                                  Status__c = 'Active' and CALENDAR_YEAR(Start__c) = :queryYear];    
        } else {
            lstChapterMeetings = [select Id, Name, Chapter_Meeting_Name__c, Synopsis__c, Start__c, End__c, Time_Zone__r.Abbreviation__c, Time_Zone__r.Name, Status__c, Chapter__c, Chapter__r.Name, Chapter_Meeting_Location__r.Address_Street_1__c, Chapter_Meeting_Location__r.Address_Street_2__c, Chapter_Meeting_Location__r.Address_Country__c, Chapter_Meeting_Location__r.Venue_Location__c, Chapter_Meeting_Location__r.Address_City__c, Chapter_Meeting_Location__r.Address_State_Provence__c , Chapter_Meeting_Location__r.Name, Chapter_Meeting_Location__r.Address_Postal_Code__c, Presentation__c, Ceremony__c, Group_Formation__c from Chapter_Meeting__c where 
                                  Status__c = 'Active' and CALENDAR_YEAR(Start__c) = :queryYear and CALENDAR_MONTH(Start__c) = :queryMonth];    
        }
        
        List<aggregateResult> lstChaptReg = [select count(Id) total, Chapter_Meeting__c from Chapter_Meeting_Registration__c where Chapter_Meeting__c in :lstChapterMeetings group by Chapter_Meeting__c];
        Map<ID, Integer> chaptRegMap = new Map<ID, Integer>();
        for (AggregateResult ar : lstChaptReg) {
            ID id = (ID)ar.get('Chapter_Meeting__c');
            Integer val = (Integer)ar.get('total');
            chaptRegMap.put(id, val);
        }
        
        List<wrapperChapterMeetingDetails> lstChaptDetails = new List<wrapperChapterMeetingDetails>();
        for (Chapter_Meeting__c cm : lstChapterMeetings) {
            wrapperChapterMeetingDetails wcm = new wrapperChapterMeetingDetails();
            wcm.chapterMeeting = cm;
            wcm.registrationCount = chaptRegMap.get(cm.Id);
            lstChaptDetails.add(wcm);
        }
            
        return lstChaptDetails;
    }    
    
    @RemoteAction
    public static Contact getUserContactDetails(){
        
        String userId = UserInfo.getUserId();            
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) {
            
            List<Contact> lstContact = [SELECT Id, Name, FirstName, LastName, Email, HomePhone, OtherPhone, GARP_Member_ID__c, 
                                        MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet,KPI_CPE_Current_Cycle__c,KPI_CPE_Last_Completed_Cycle__c,
                                        AccountId, GARP_ID__c, Membership_Type__c, Name_As_it_Appears_On_ID__c, Job_Function__c, Company__c, 
                                        ID_Number__c, ID_Type__c, GARP_Directory_Opt_In__c, KPI_Membership_Payment_Status__c, KPI_CPE_Requirement_Status__c,
                                        KPI_CPE_Participation__c, KPI_Chapter_Director__c,KPI_ERP_Candidate__c, KPI_ERP_Certified_Date__c, KPI_FRM_Certified_Year__c, KPI_ERP_Certified_Year__c,
                                        KPI_Current_Exam_Registration__c, KPI_FRM_Candidate__c, KPI_FRM_Certified_Date__c, KPI_Last_Exam_Registration__c,
                                        KPI_Membership_Since__c, KPI_FRM_Certified__c, KPI_ERP_Certified__c,Professional_Designation_CA__c,Professional_Designation_CFA__c,
                                        Professional_Designation_CMA__c, Professional_Designation_CPA__c, Professional_Designation_PMP__c, Professional_Designation_ACCA__c,
                                        Professional_Designation_Other__c, Other_Qualifications__c, Area_of_Concentration__c, Corporate_Title__c, GARP_Directory_Invite_Opt_Out__c,
                                        GARP_Directory_Connect_Feature__c,GARP_Dir_Privacy_Additional_Detail__c,GARP_Dir_Privacy_Job_Information__c,GARP_Dir_Privacy_Prof_Background__c
                                        FROM Contact WHERE Id = :lstUser[0].ContactId];
            
            if( lstContact != null && lstContact.size() > 0 ) {            
                return lstContact[0];
            }
        }
        return null;
        
    }
    
  @RemoteAction
  public static Boolean unsubscribe(String contactId){

          
          List<Contact> lstContact = [select Id, Name, Email_GARP_Updates__c,Email_Daily_News__c,Email_Chapter_Meetings__c,Email_Information_Exchange__c ,
                                      Email_Member_Update__c,Email_The_Week_in_Risk__c,Email_Career_Center_Job_Board__c from Contact where Id = :contactId];
          if( lstContact != null && lstContact.size() > 0 ) {            
              lstContact[0].Email_GARP_Updates__c=false;
              lstContact[0].Email_Daily_News__c=false;
              lstContact[0].Email_Chapter_Meetings__c=false;
              lstContact[0].Email_Information_Exchange__c=false;
              lstContact[0].Email_Member_Update__c=false;
              lstContact[0].Email_The_Week_in_Risk__c=false;
              lstContact[0].Email_Career_Center_Job_Board__c=false;
              update lstContact[0];
              return true;      
          }
      return false;

  }
    
  @RemoteAction
  public static Boolean createContract(String status, String accountId, String opportunityId, Integer term, String recordType){

        Contract objContract = new Contract();
        objContract.status = status;
        objContract.accountId = accountId;
        
        List<Opportunity> lstOpp = [select Id, Name from Opportunity where Id = :opportunityId];
        if( lstOpp != null && lstOpp.size() > 0 ) {
        
            objContract.Opportunity__c = lstOpp[0].Id;
            
            Date now = date.today();
            objContract.StartDate = now;
            
            objContract.ContractTerm  = term;
            
            Id recordTypeID = RecordTypeHelper.GetRecordTypeId('Contract',recordType);
    
            objContract.recordTypeID = recordTypeID;
            insert objContract;
        
          return true; 
        } else {
            return false;
        }
    } 
    
    @RemoteAction
    public static string Deferred(String examAttemptId, String productCode){
        
        system.debug('* * * Deferred ...'+ examAttemptId);
        return 'Bye';
        
        //return PortalClass.checkExamAttempts(examAttemptId,productCode);
        // Extend membership return opportunityTriggerUtils.updateContracts(x,y);
    } 

    @RemoteAction
    public static string deferExam2(String examAttemptId, String productCode){
        return 'Hello';
    }
    
    @RemoteAction
    public static Registration.wrapperCreateOrder deferExams(String examAttemptId, String productCode, String glCode, Boolean bWire){
        Registration.wrapperCreateOrder wco = PortalClass.checkExamAttempts(examAttemptId,productCode,glCode,bWire);
        if(wco != null && wco.opportunityId != null)
            wco = prepareWCO(wco, wco.opportunityId);
        return wco;        
        
        //return '';
    }
    
    @RemoteAction
    public static productData getProduct2(String productcode, String glCode){
        
        productData pd = new productData();
        
        List<Product2> lstProducts = [select Id, Name, Description, Image__c from Product2 where ProductCode = :productcode and GL_Code__c = :glCode];
        if( lstProducts != null && lstProducts.size() > 0 ) {
            pd.product = lstProducts;
            List<PricebookEntry> lstPrice = [select Id, Name, UnitPrice, Product2Id, ProductCode from PriceBookEntry where Pricebook2.IsActive = true and Product2Id in :lstProducts and IsActive=true];
            pd.price = lstPrice;
        }            
        return pd;
    }
    
    @RemoteAction
    public static List<productItems> getProductsById(List<String> productIds){
        
        List<Product2> lstProducts = 
            [select Id, Name, Description, Image__c, GL_Code__c, Weight__c,Taxable__c,
                 (select Id, Name, UnitPrice, Product2Id, ProductCode from PriceBookEntries where Pricebook2.IsActive = true)
             from Product2 where Id in :productIds];

        List<ProductItems> productWrappers = new List<sfdcAppRemoter.ProductItems>();
        MAP<ID,Product2> mapProds = new MAP<ID,Product2>();
        for (Product2 product : lstProducts) {
            mapProds.put(product.Id, product);
        }
       
            
        for(String prod :productIds) {
            Product2 product = mapProds.get(Id.valueOf(prod));
            if(product != null) {
                sfdcAppRemoter.ProductItems productWrapper = new sfdcAppRemoter.ProductItems();
                productWrapper.Product = product;
                PriceBookEntry [] priceBookEntries = product.PriceBookEntries;
                productWrapper.Price = priceBookEntries[0];
                productWrappers.add(productWrapper);
            }
        }
        
        return productWrappers;
    }
    
    @RemoteAction
    public static productData getProduct(String productcode, String glCode){
        
        productData pd = new productData();
        
        List<Product2> lstProducts = [select Id, Name, Description, Image__c from Product2 where ProductCode = :productcode and GL_Code__c = :glCode];
        if( lstProducts != null && lstProducts.size() > 0 ) {
            pd.product = lstProducts;
            List<PricebookEntry> lstPrice = [select Id, Name, UnitPrice, Product2Id, ProductCode from PriceBookEntry where Pricebook2.IsActive = true and Product2Id in :lstProducts and IsActive=true];
            pd.price = lstPrice;
        }            
        return pd;
    }

    
    @RemoteAction
    public static String encodeString(String before) {            
     Blob beforeblob = Blob.valueOf(before);
      string paramvalue = EncodingUtil.base64Encode(beforeblob);    
        return paramvalue;
    }

    @RemoteAction
    public static Boolean setLastLoginDate(){
        
        String userId = UserInfo.getUserId();            
        List<User> lstUser = [Select Id,ContactId from User where Id = :userId];
                
        if( lstUser != null && lstUser.size() > 0 ) {
            String contactId = lstUser[0].ContactId;
            List<Contact> lstContact = [select Id, Name from Contact where Id = :lstUser[0].ContactId];
            if( lstContact != null && lstContact.size() > 0 ) {                
                lstContact[0].Last_Day_of_Login__c = datetime.now();
                
                //system.assert(false, 'BOOM!'+ lstContact[0]);
                
                update lstContact;
            }
        }
        return true;
    }
    
    
    @RemoteAction
    public static List<Contact> getBoardCandidates(){
        
        String userId = UserInfo.getUserId();            
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) {
        
            String contactId = lstUser[0].ContactId;
            List<Contact> lstContact = [select Id, Name from Contact where KPI_GARP_Board_Member__c = true];
            if( lstContact != null && lstContact.size() > 0 ) {
                return lstContact;
            }
        }
        return null;
    }


    @RemoteAction
    public static Boolean voteBoardCandidates(String contactId, String electionId){
        
        String userId = UserInfo.getUserId();            
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) {
        
      List<Contact> lstContact = [select Id, Name from Contact where Id = :contactId];
            if( lstContact != null && lstContact.size() > 0 ) {
                
                List<Board_Election__c> lstElection = [select Id, Name from Board_Election__c where Id = :electionId];
              if( lstElection != null && lstElection.size() > 0 ) {
                    Board_Vote__c bv = new Board_Vote__c();
                    
                    bv.Board_Election__c = electionId;
                    bv.Board_Member__c = contactId;
                    insert bv;
                }
            }
        }
        return true;
    }
   @RemoteAction
    public static boolean updateId(String idName, String idType, String idNumber){
        
        String userId = UserInfo.getUserId();            
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) {
        
            String contactId = lstUser[0].ContactId;
      List<Contact> lstContact = [select Id, Name,Name_As_it_Appears_On_ID__c, ID_Number__c, ID_Type__c from Contact where id = :contactId];
            if( lstContact != null && lstContact.size() > 0 ) {
                lstContact[0].Name_As_it_Appears_On_ID__c = idName;
                lstContact[0].ID_Type__c = idType;
                lstContact[0].ID_Number__c = idNumber;
        update lstContact[0];           
            }
        }
        return true;
    }
                        
    @RemoteAction
    public static boolean sendDirectoryMessage(String templateName, String text, String recptContactId){
        
        String userId = UserInfo.getUserId();            
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) {
        
            String contactId = lstUser[0].ContactId;
 
            List<Contact> srcContactlst = [SELECT Id, Name, FirstName, LastName, Email_URL__c, Email_WebSite_URL__c, Email, MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet, AccountId, GARP_ID__c, Membership_Type__c, GARP_Directory_Connect_Send_Count__c FROM Contact WHERE Id = :contactId];
            List<Contact> rcptContactlst = [SELECT Id, Name, FirstName, LastName, Email_URL__c, Email_WebSite_URL__c, Email, MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet, AccountId, GARP_ID__c, Membership_Type__c, GARP_Directory_Connect_Recieve_Count__c FROM Contact WHERE Id = :recptContactId];
            
            //System.assert(false, 'BOOM!'+ srcContactlst);
            
            if( srcContactlst != null && srcContactlst.size() > 0 && rcptContactlst != null && rcptContactlst.size() > 0 ) {

                Contact srcContact = srcContactlst[0];
                Contact rcptContact = rcptContactlst[0];
                
                
                // grab the email template
                EmailTemplate emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where DeveloperName = :templateName];
                        
                // process the merge fields
                String subject = emailTemplate.Subject;
                subject = subject.replace('{!Account.Name}', rcptContact.Name);

                String htmlBody = emailTemplate.HtmlValue;
                
                system.debug('* * * HtmlValue Before ...'+ htmlBody);

                htmlBody = htmlBody.replace('{!Contact.GARP_ID__c}', rcptContact.GARP_ID__c);
                htmlBody = htmlBody.replace('{!Contact.FirstName}', rcptContact.FirstName);
                htmlBody = htmlBody.replace('{!Contact.LastName}', rcptContact.LastName);

                htmlBody = htmlBody.replace('{!srcContact.FirstName}', srcContact.FirstName);
                htmlBody = htmlBody.replace('{!srcContact.LastName}', srcContact.LastName);
                htmlBody = htmlBody.replace('{!srcContact.Email}', srcContact.Email);
                
                htmlBody = htmlBody.replace('{!Contact.Email_URL__c}', rcptContact.Email_URL__c);
                htmlBody = htmlBody.replace('{!Contact.Email_WebSite_URL__c}', rcptContact.Email_WebSite_URL__c);
                    
                htmlBody = htmlBody.replace('{!Contact.Id}', rcptContact.Id);
                htmlBody = htmlBody.replace('{!CustomText}', text);
                
                htmlBody = htmlBody.replace('<![CDATA[', '');
                htmlBody = htmlBody.replace(']]>', '');
                

                system.debug('* * * HtmlValue After ...'+ htmlBody);

                String plainBody = emailTemplate.Body;
                
                system.debug('* * * plainBody Before ...'+ plainBody);
                
                plainBody = plainBody.replace('{!Contact.GARP_ID__c}', rcptContact.GARP_ID__c);
                plainBody = plainBody.replace('{!Contact.FirstName}', rcptContact.FirstName);
                plainBody = plainBody.replace('{!Contact.LastName}', rcptContact.LastName);

                plainBody = plainBody.replace('{!srcContact.FirstName}', srcContact.FirstName);
                plainBody = plainBody.replace('{!srcContact.LastName}', srcContact.LastName);
                plainBody = plainBody.replace('{!srcContact.Email}', srcContact.Email);
                
                plainBody = plainBody.replace('{!Contact.Email_URL__c}', rcptContact.Email_URL__c);
                plainBody = plainBody.replace('{!Contact.Email_WebSite_URL__c}', rcptContact.Email_WebSite_URL__c);
                    
                plainBody = plainBody.replace('{!Contact.Id}', rcptContact.Id);
                plainBody = plainBody.replace('{!CustomText}', text);
                
                system.debug('* * * plainBody After ...'+ plainBody);

                //build the email message
                Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
           
                email.setReplyTo(rcptContact.Email);
                email.setSenderDisplayName(rcptContact.Name);
                email.setTargetObjectId(rcptContact.Id);
                email.setSaveAsActivity(false);
            
                email.setSubject(subject);
                email.setHtmlBody(htmlBody);
                email.setPlainTextBody(plainBody);
            
                Messaging.sendEmail(new Messaging.SingleEmailmessage[] {email});
                
                if(rcptContactlst[0].GARP_Directory_Connect_Recieve_Count__c == null)
                    rcptContactlst[0].GARP_Directory_Connect_Recieve_Count__c=1;
                else rcptContactlst[0].GARP_Directory_Connect_Recieve_Count__c++;
                
                update rcptContactlst;
                
                if(srcContactlst[0].GARP_Directory_Connect_Send_Count__c == null)
                    srcContactlst[0].GARP_Directory_Connect_Send_Count__c=1;
                else srcContactlst[0].GARP_Directory_Connect_Send_Count__c++;

                update srcContactlst;
            }
        }
        
        return true;
    }

    @RemoteAction
    public static searchResults searchDirectory(String searchText, String searchType, String industries, String jobFunctions, String corporateTitles, String company, String sortField, String sortOrder, Integer pageSize, Integer pageCurrent){

        String querystr = '';
        String likeClause = '%'+searchText+'%';
        if(company == '' && industries == '' && jobFunctions == '' && corporateTitles == '') {
            String query = 'SELECT Id, Name, Email, MailingCity, MailingState, MailingPostalCode, MailingCountry, KPI_CPE_Current_Cycle__c, KPI_CPE_Last_Completed_Cycle__c, Job_Function__c, AccountId, GARP_ID__c, Membership_Type__c, Area_of_Concentration__c, GARP_Directory_Opt_In__c, GARP_Directory_Invite_Opt_Out__c, GARP_Dir_Privacy_Additional_Detail__c, GARP_Dir_Privacy_Job_Information__c, GARP_Dir_Privacy_Prof_Background__c, GARP_Directory_Connect_Feature__c, KPI_Membership_Payment_Status__c, KPI_FRM_Certified__c, KPI_FRM_Certified_Year__c, KPI_ERP_Certified__c, KPI_ERP_Certified_Year__c, KPI_Membership_Since__c, KPI_CPE_Requirement_Status__c, Professional_Designation_CA__c, Professional_Designation_CFA__c, Professional_Designation_CMA__c, Professional_Designation_CPA__c, Professional_Designation_Other__c, Professional_Designation_PMP__c, Professional_Designation_ACCA__c, Company_Type__c, Corporate_Title__c, Company__c FROM Contact';
            String whereClause = 'WHERE GARP_Directory_Opt_In__c = true and (KPI_FRM_Certified__c = true or KPI_ERP_Certified__c = true) and ' + searchType + ' like :likeClause'; 
            String sortClause = 'ORDER BY ' + sortField + ' ' + sortOrder + ' NULLS LAST';
            querystr = query + ' ' + whereClause + ' ' + sortClause;
            
            system.debug('* * * query ...'+ querystr);
            
        } else {
            
            String industriesInClause = '';
            if(industries != '') {
                String[] arrText = industries.split('; ');
                for(String s :arrText) {
                    if(industriesInClause == '') {
                        industriesInClause = '\'' + s + '\'';
                    } else {
                        industriesInClause = industriesInClause + ',' + '\'' + s + '\'';
                    }
                }
            }

            String jobFunctionsInClause = '';
            if(jobFunctions != '') {
                String[] arrText = jobFunctions.split('; ');
                for(String s :arrText) {
                    if(jobFunctionsInClause == '') {
                        jobFunctionsInClause = '\'' + s + '\'';
                    } else {
                        jobFunctionsInClause = jobFunctionsInClause + ',' + '\'' + s + '\'';
                    }
                }
            }

            String corporateTitlesInClause = '';
            if(corporateTitles != '') {
                String[] arrText = corporateTitles.split('; ');
                for(String s :arrText) {
                    if(corporateTitlesInClause == '') {
                        corporateTitlesInClause = '\'' + s + '\'';
                    } else {
                        corporateTitlesInClause = corporateTitlesInClause + ',' + '\'' + s + '\'';
                    }
                }
            }
            
            //String likeClause = searchText;
            String query = 'SELECT Id, Name, Email, MailingCity, MailingState, MailingPostalCode, MailingCountry, KPI_CPE_Current_Cycle__c, KPI_CPE_Last_Completed_Cycle__c, Job_Function__c, AccountId, GARP_ID__c, Membership_Type__c, Area_of_Concentration__c, GARP_Directory_Opt_In__c, GARP_Directory_Invite_Opt_Out__c, GARP_Dir_Privacy_Additional_Detail__c, GARP_Dir_Privacy_Job_Information__c, GARP_Dir_Privacy_Prof_Background__c, GARP_Directory_Connect_Feature__c, KPI_Membership_Payment_Status__c, KPI_FRM_Certified__c, KPI_FRM_Certified_Year__c, KPI_ERP_Certified__c, KPI_ERP_Certified_Year__c, KPI_Membership_Since__c, KPI_CPE_Requirement_Status__c, Professional_Designation_CA__c, Professional_Designation_CFA__c, Professional_Designation_CMA__c, Professional_Designation_CPA__c, Professional_Designation_Other__c, Professional_Designation_PMP__c, Professional_Designation_ACCA__c, Company_Type__c, Corporate_Title__c, Company__c FROM Contact';
            String whereClause = 'WHERE GARP_Directory_Opt_In__c = true and (KPI_FRM_Certified__c = true or KPI_ERP_Certified__c = true)';
            if(industries != '') {
                whereClause +=  ' and Area_of_Concentration__c in (' + industriesInClause + ')'; 
            }
            if(jobFunctions != '') {
                whereClause +=  ' and Job_Function__c in (' + jobFunctionsInClause + ')'; 
            }
            if(corporateTitles != '') {
                whereClause +=  ' and Corporate_Title__c in (' + corporateTitlesInClause + ')'; 
            }
            if(company != '') {
                String companyLikeClause = '%'+company+'%';
                whereClause +=  ' and Company__c like :companyLikeClause'; 
            }
            whereClause +=  ' and ' + searchType + ' like :likeClause'; 
            String sortClause = 'ORDER BY ' + sortField + ' ' + sortOrder + ' NULLS LAST';
            querystr = query + ' ' + whereClause + ' ' + sortClause;
            
            system.debug('* * * query ...'+ querystr);
            
        }
        
        List<Contact> lstContact = database.query(querystr);            
        
        List<Contact> returnListContact = new List<Contact>();
        List<Id> ids = new List<Id>();
        if(lstContact.size() > pageSize) {
            Integer count = 1;
            Integer page = 1;
            for(Contact con :lstContact){
                if(page == pageCurrent) {
                    returnListContact.add(con);
                    ids.add(con.Id);
                }
                count++;
                if(count > pageSize) {
                    count=1;
                    page++;
                }
            }
        } else {
            returnListContact = lstContact;
        }
        
        searchResults results = new searchResults();
        
        if(lstContact.size() > pageSize) {
            results.lstUser = [select Id, Name, FullPhotoUrl, ContactId from User where ContactId in :ids];    
        } else {
           for(Contact c :lstContact)
               ids.add(c.Id);
           results.lstUser = [select Id, Name, FullPhotoUrl, ContactId from User where ContactId in :ids];
        }
        
        Decimal myDecimal = lstContact.size();
        Decimal divDec = myDecimal.divide(pageSize, 0, System.RoundingMode.UP);
        results.lstContact = returnListContact;
        results.pages = divDec.intValue();
        
        return results; 
    }
    
   
    @RemoteAction 
    public static List<wrapperUtils.wrapperProductInfo> getSwitchDetails(){
    return SwitchLayer.swithcLogic();  
    }
 
    @RemoteAction
    public static List<wrapperUtils.wrapperProductDetails> getOtherexamcodes(){
        List<wrapperUtils.wrapperProductDetails> lstDetails = FBRICBRUtils.getProductCodes();
        return lstDetails;
    }
           
    @RemoteAction
    public static Registration.wrapperCreateOrder getUnDefferedExams(id eaID, String prodCode, String glCode, Boolean bWire){
        Registration.wrapperCreateOrder wco = PortalClass.unDeferrExamAttempts(eaID,prodCode,glCode,bWire);
        if(wco != null && wco.opportunityId != null)
            wco = prepareWCO(wco, wco.opportunityId);
        return wco;
        //return '';
    }

    @RemoteAction
    public static wrapperProductInfo getDefferedExams(){
        PortalClass.getDefferedExams();
        wrapperProductInfo obj = new wrapperProductInfo();
        obj.bFRM1Deffered  = PortalClass.bFRM1Deffered;
        obj.bFRM2Deffered  = PortalClass.bFRM2Deffered;
        obj.bFRM1UnDeffered  = PortalClass.bFRM1UnDeffered;
        obj.bFRM2UnDeffered  = PortalClass.bFRM2UnDeffered;
        obj.bERPDeffered  = PortalClass.bERPDeffered;
        obj.bERP1Deffered  = PortalClass.bERP1Deffered;
        obj.bERP2Deffered  = PortalClass.bERP2Deffered;
        obj.bERP1UnDeffered  = PortalClass.bERP1UnDeffered;
        obj.bERP2UnDeffered  = PortalClass.bERP2UnDeffered;
        obj.bFRMSwitch= PortalClass.bFRMCanSwitch;
        obj.bERPSwitch= PortalClass.bERPCanSwitch;
        return obj;
     } 

    @RemoteAction
    public static Map<String,Registration.wrapperProductInfo> getProductCodes(){
        return Registration.getProductCodes(); 
    }    

    @RemoteAction
    public static set<String> getAccountName(){
        return PortalClass.getAccountName();
    } 

    @RemoteAction
    public static id getParentId(){
        return PortalClass.getParentId();
    } 

    @RemoteAction
    public static boolean confirmProctorDownload(String proctorApplicationId){

        String userId = UserInfo.getUserId();        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) { 
            List<Proctor_Registration__c> lstProctorRegistration = [select Id, Name, Roster_Downloaded_Date__c from Proctor_Registration__c where Id = :proctorApplicationId];
            
            if( lstProctorRegistration != null && lstProctorRegistration.size() > 0 ) { 
                Date now = date.today();
                lstProctorRegistration[0].put('Roster_Downloaded_Date__c',now);                
                update lstProctorRegistration[0];
            }             
        }
        return true;
    }

    @RemoteAction
    public static boolean selectProctorRole(String siteId, String contactId, String role){

        String userId = UserInfo.getUserId();        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) { 
            List<Proctor_Registration__c> lstProctorRegistration = [select Id, Name, Selected__c, Type__c from Proctor_Registration__c where Test_Site__c = :siteId and Contact__c = :contactId];
            
            if( lstProctorRegistration != null && lstProctorRegistration.size() > 0 ) { 
                lstProctorRegistration[0].put('Type__c',role);               
                update lstProctorRegistration[0];
            }             
        }
        return true;
    }
    
    @RemoteAction
    public static boolean confirmExamAttestation(String examAttemptId){
        
        String userId = UserInfo.getUserId();        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) { 
            
            List<Exam_Attempt__c> lstExamAttempts = [select Id, Ticket_Download_Date__c from Exam_Attempt__c where Id = :examAttemptId];
            
            if( lstExamAttempts != null && lstExamAttempts.size() > 0 ) { 
                Datetime now = Datetime.now();
                Exam_Attempt__c examAttempt = lstExamAttempts[0];
                examAttempt.put('Ticket_Download_Date__c', now);
                update examAttempt;
            }
            return true;             
        }
        else { 
            return false;
        }
    }
    
    @RemoteAction
    public static boolean confirmExamResultsViewed(String examAttemptId){
        
        String userId = UserInfo.getUserId();        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) { 
            
            List<Exam_Attempt__c> lstExamAttempts = [select Id, Results_Viewed_Date__c from Exam_Attempt__c where Id = :examAttemptId];
            
            if( lstExamAttempts != null && lstExamAttempts.size() > 0 ) { 
                Datetime now = Datetime.now();
                Exam_Attempt__c examAttempt = lstExamAttempts[0];
                examAttempt.put('Results_Viewed_Date__c', now);
                update examAttempt;
            }
            return true;             
        }
        else { 
            return false;
        }
    }
    
    @RemoteAction
    public static boolean confirmProctor(String proctorApplicationId){

        String userId = UserInfo.getUserId();        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) { 
            List<Proctor_Registration__c> lstProctorRegistration = [select Id, Name, Selected__c, Confirmed__c from Proctor_Registration__c where Id = :proctorApplicationId];
            
            if( lstProctorRegistration != null && lstProctorRegistration.size() > 0 ) { 
                lstProctorRegistration[0].put('Confirmed__c',true);                
                update lstProctorRegistration[0];
            }             
        }
        return true;
    }

    @RemoteAction
    public static boolean selectProctor(String siteId, String contactId, Boolean selected){

        String userId = UserInfo.getUserId();        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) { 
            List<Proctor_Registration__c> lstProctorRegistration = [select Id, Name, Selected__c, Confirmed__c from Proctor_Registration__c where Test_Site__c = :siteId and Contact__c = :contactId];
            
            if( lstProctorRegistration != null && lstProctorRegistration.size() > 0 ) { 
                lstProctorRegistration[0].put('Selected__c',selected);                
                lstProctorRegistration[0].put('Confirmed__c',false);                
                update lstProctorRegistration[0];
            }             
        }
        return true;
    }

    @RemoteAction
    public static boolean workedProctor(String siteId, String contactId, Boolean worked){

        String userId = UserInfo.getUserId();        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) { 
            List<Proctor_Registration__c> lstProctorRegistration = [select Id, Name, Worked__c, Selected__c, Confirmed__c from Proctor_Registration__c where Test_Site__c = :siteId and Contact__c = :contactId];
            
            if( lstProctorRegistration != null && lstProctorRegistration.size() > 0 ) { 
                lstProctorRegistration[0].put('Worked__c',worked);                       
                update lstProctorRegistration[0];
            }             
        }
        return true;
    }

    @RemoteAction
    public static List<Proctor_Registration__c> getProctorsBySite(String siteId){

        String userId = UserInfo.getUserId();        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        List<Proctor_Registration__c> lstProctorRegistration;
        
        if( lstUser != null && lstUser.size() > 0 ) { 
            String contactId = lstUser[0].ContactId;
             
            lstProctorRegistration = [select Id, Name, Worked__c, Selected__c, Confirmed__c, Type__c, Status__c, Contact__c, Contact__r.Name, Contact__r.Email from Proctor_Registration__c where Test_Site__c = :siteId and Type__c != 'Supervisor'];
        }
        return lstProctorRegistration;
    }

    
    @RemoteAction
    public static boolean attestProctorApplication(String proctorApplicationId){

        String userId = UserInfo.getUserId();        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) { 
            String contactId = lstUser[0].ContactId;
             
            List<Proctor_Registration__c> lstProctorRegistration = [select Id, Name, Status__c from Proctor_Registration__c where Id = :proctorApplicationId];                        
            if( lstProctorRegistration != null && lstProctorRegistration.size() > 0 ) { 
                lstProctorRegistration[0].put('Status__c','Approved');
                
                update lstProctorRegistration[0];
            }             
        }
        return true;
    }

    @RemoteAction
    public static List<Exam_Attempt__c> getProctorSiteRoster(String proctorApplicationId){

        String userId = UserInfo.getUserId();        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) { 
            String contactId = lstUser[0].ContactId;
             
            List<Proctor_Registration__c> lstProctorRegistration = [select Id, Name, Test_Site__c from Proctor_Registration__c where Id = :proctorApplicationId];            
            if( lstProctorRegistration != null && lstProctorRegistration.size() > 0 ) { 
                List<Exam_Attempt__c> lstExamAttempt = [SELECT Id, Name, Cancelled__c, Candidate_Commitment__c, Candidate_Commitment__r.Opportunity__c, hasViolation__c, Checked_In__c, Result__c, Defered__c, Exam_Site__r.Exam__r.Name, Exam_Site__r.Exam__r.Exam__c, Exam_Site__r.Exam_Date__c, Exam_Site__r.Exam__r.Exam_Date__c, Exam_Site__r.Exam__r.Exam_Group__c, Exam_Site__r.Exam__r.Exam_Group__r.Active__c, Session__c, Member__r.GARP_ID__c, Member__r.name, Exam_Site__r.Site__r.Site_Code__c, Exam_Site__r.Site__r.Display_Address__c, Room__r.name, Seat_No__c, Ticket_Download_Date__c FROM Exam_Attempt__c where Exam_Site__c = :lstProctorRegistration[0].Test_Site__c];
                if( lstExamAttempt != null && lstExamAttempt.size() > 0 ) { 
                    return lstExamAttempt;
                }
            }             
        }
        return null;
    }
    
    @RemoteAction
    public static boolean attestCPE(String contractReqId){

        String userId = UserInfo.getUserId();        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) { 
            String contactId = lstUser[0].ContactId;
             
            List<Candidate_Requirement__c> lstContractReq = [select Id, Name, Status__c from Candidate_Requirement__c where Id = :contractReqId];                        
            if( lstContractReq != null && lstContractReq.size() > 0 ) { 
                lstContractReq[0].put('Status__c','Completed');
                lstContractReq[0].put('Date_of_Completion__c',system.today());
                
                update lstContractReq[0];
            }             
        }
        return true;
    }


    @RemoteAction
    public static List<Chapter_Meeting_Registration__c> fetchChapterMeetingRegister(String chapterMeetingId){        
        List<Chapter_Meeting_Registration__c> lstChapterMeetingRegistrations = [select Id, Name, Status__c, Attended__c, Contact__r.FirstName, Contact__r.LastName, 
                Contact__r.Corporate_Title__c, Contact__r.Company__c from Chapter_Meeting_Registration__c where Chapter_Meeting__c = :chapterMeetingId];
        return lstChapterMeetingRegistrations;
    }


    @RemoteAction
    public static Boolean submitClaimFromMeeting(String meetingId, String contactId, String cpeActivityTypeId, String providerId, Boolean attended) {

        List<Chapter_Meeting__c> lstChapMeetings = [select Id, Name, Topic__c from Chapter_Meeting__c where Id = :meetingId];
        if( lstChapMeetings != null && lstChapMeetings.size() > 0) {
            Chapter_Meeting__c meeting = lstChapMeetings[0];
            List<Contact> lstContact = [select Id,Name,CPE_Current_Program_Requirement__c, KPI_FRM_Certified__c,KPI_ERP_Certified__c from Contact where Id = :contactId];
            if( lstContact != null && lstContact.size() > 0 && lstContact[0].CPE_Current_Program_Requirement__c != Null) {
                if(attended) {
                    CPE_Claim__c newClaim = new CPE_Claim__c();
                    newClaim.Candidate_Requirement__c = lstContact[0].CPE_Current_Program_Requirement__c;
                    newClaim.CPE_Activity_Type__c = cpeActivityTypeId;
                    newClaim.Date_of_Completion__c = system.today();
                    newClaim.Credits_Earned__c = 1;
                    newClaim.EventTitle__c = meeting.Name;
                    newClaim.Provider__c = providerId;
                    newClaim.Area_of_Study__c = meeting.Topic__c;
                    newClaim.Member__c = contactId;
                    newClaim.FRM__c = lstContact[0].KPI_FRM_Certified__c;
                    newClaim.ERP__c = lstContact[0].KPI_ERP_Certified__c;
                    insert newClaim;                
                } else {
                    List<CPE_Claim__c> lstClaims = [select Id, Name, EventTitle__c, Member__c, Candidate_Requirement__c from CPE_Claim__c where Member__c = :contactId and EventTitle__c = :meeting.Name and Candidate_Requirement__c = :lstContact[0].CPE_Current_Program_Requirement__c];
                    if( lstClaims != null && lstClaims.size() > 0) {
                        delete lstClaims;
                    }        
                }
            }        
        }
        return true;
    }    
    
    @RemoteAction
    public static List<Chapter_Meeting_Registration__c> toggelAttendance(String chapterMeetingId, String registrationId){        
        List<Chapter_Meeting_Registration__c> lstChapterMeetingRegistrations = [select Id, Name, Status__c, Attended__c, Contact__r.Name from Chapter_Meeting_Registration__c where Id=:registrationId];
        if(lstChapterMeetingRegistrations != null && lstChapterMeetingRegistrations.size() > 0) {
            if(lstChapterMeetingRegistrations[0].Attended__c == false) {
                lstChapterMeetingRegistrations[0].Attended__c=true;
            }else{
                lstChapterMeetingRegistrations[0].Attended__c=false;
            }
            update lstChapterMeetingRegistrations;
        }
        lstChapterMeetingRegistrations = [select Id, Name, Status__c, Attended__c, Contact__r.FirstName, Contact__r.LastName, Contact__r.Corporate_Title__c, Contact__r.Company__c from Chapter_Meeting_Registration__c where Chapter_Meeting__c = :chapterMeetingId];
        return lstChapterMeetingRegistrations;
    }
    
    @RemoteAction
    public static boolean chapterMeetingRegister(String chapterMeetingId, Boolean isComing){

        String userId = UserInfo.getUserId();        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) { 
            String contactId = lstUser[0].ContactId;
            
            List<Chapter_Meeting_Registration__c> lstChapterMeetingRegistrations = [select Id, Name, Status__c from Chapter_Meeting_Registration__c where Chapter_Meeting__c = :chapterMeetingId and Contact__c = :contactId];
            if( lstChapterMeetingRegistrations != null && lstChapterMeetingRegistrations.size() > 0 ) { 
                
                if(!isComing) {
                    delete lstChapterMeetingRegistrations[0];
                }
    
            } else if(isComing) {

                Chapter_Meeting_Registration__c newChapterMeetingRegistration = new Chapter_Meeting_Registration__c();
                newChapterMeetingRegistration.put('Status__c','Confirmed');
                newChapterMeetingRegistration.put('Role__c','Registrant');
                newChapterMeetingRegistration.put('Chapter_Meeting__c',chapterMeetingId);
                newChapterMeetingRegistration.put('Contact__c',contactId);
                insert newChapterMeetingRegistration;

            }        
        }
        return true;
        
    }
    
    @RemoteAction
    public static boolean setChapterMeetingConfirm(String registrationId){

        String userId = UserInfo.getUserId();        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        List<Chapter_Meeting_Registration__c> lstChapterMeetingRegistrations;
        
        if( lstUser != null && lstUser.size() > 0 ) {
            String contactId = lstUser[0].ContactId;
            lstChapterMeetingRegistrations = [select Id, Name, Status__c from Chapter_Meeting_Registration__c where Id = :registrationId];
            if( lstChapterMeetingRegistrations != null && lstChapterMeetingRegistrations.size() > 0 ) {
                lstChapterMeetingRegistrations[0].put('Status__c','Confirmed');
                update lstChapterMeetingRegistrations;
            }        
        }
        return true;
    }     
        
    @RemoteAction
    public static List<Chapter_Meeting_Registration__c> getChapterMeetingRegistrations(){

        String userId = UserInfo.getUserId();        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        List<Chapter_Meeting_Registration__c> lstChapterMeetingRegistrations;
        
        if( lstUser != null && lstUser.size() > 0 ) {
            String contactId = lstUser[0].ContactId;
            lstChapterMeetingRegistrations = [select Id, Name, Role__c, Status__c, Ticket_QR__c, Chapter_Meeting__c, Chapter_Meeting__r.Name, Chapter_Meeting__r.Chapter_Meeting_Name__c, Chapter_Meeting__r.Synopsis__c, Chapter_Meeting__r.Start__c, Chapter_Meeting__r.End__c, Chapter_Meeting__r.Status__c, Chapter_Meeting__r.Chapter_Meeting_Location__r.Address_Street_1__c, Chapter_Meeting__r.Chapter_Meeting_Location__r.Address_Street_2__c, Chapter_Meeting__r.Chapter_Meeting_Location__r.Venue_Location__c, Chapter_Meeting__r.Chapter_Meeting_Location__r.Address_City__c, Chapter_Meeting__r.Chapter_Meeting_Location__r.Address_State_Provence__c , Chapter_Meeting__r.Chapter_Meeting_Location__r.Name, Chapter_Meeting__r.Chapter_Meeting_Location__r.Address_Postal_Code__c from Chapter_Meeting_Registration__c where Contact__c = :contactId];
        }
        return lstChapterMeetingRegistrations;
    }     
    
    @RemoteAction
    public static boolean signDirectorCode(String chapterId){

        String userId = UserInfo.getUserId();        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) {

            String contactId = lstUser[0].ContactId;

            List<Chapter_Member__c> lstChapterMember = [select Id, Name, Chapter_Director_Agreement_Signed_Date__c, Director__c from Chapter_Member__c where Contact__c = :contactId and Chapter__c = :chapterId];
            if( lstChapterMember != null && lstChapterMember.size() > 0 ) {
                datetime myDateTime = datetime.now();
                lstChapterMember[0].Chapter_Director_Agreement_Signed_Date__c=myDateTime;
                lstChapterMember[0].Director__c=true;
                update lstChapterMember[0];
            }
        }
        return true;
    } 

    @RemoteAction
    public static Registration.wrapperCreateOrder buyProductsByCode(LIST<purchaseCodeData> products, String opportunityName){

        String paymentId;        
        String userId = UserInfo.getUserId();        
        String ampProductCode = 'PRFEE';

        getUserReturnData rd = new getUserReturnData ();
        
        system.debug('* * * products: '+ products);
        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) {
        
            rd.userData = lstUser;        
            String contactId = lstUser[0].ContactId;
 
            List<Contact> lstContact = [SELECT Id, Name, FirstName, LastName, Email, HomePhone, Company__c, Mailing_Address_Company__c, MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet, AccountId, GARP_Member_ID__c, Membership_Type__c FROM Contact WHERE Id = :contactId];
            
            if( lstContact != null && lstContact.size() > 0 ) {

                Registration.wrapperCreateOrder wco = new Registration.wrapperCreateOrder();
                wco.contactId = lstContact[0].Id;
                wco.garpId = lstContact[0].GARP_Member_ID__c;
                
                rd.contactData = lstContact;
                String accountId = lstContact[0].AccountId;        
                List<Account> lstAcct = [select Id, Name, Billing_Address_Company__c, BillingCity, BillingCountry, BillingPostalCode, BillingState, BillingStreet from Account where Id = :lstContact[0].AccountId];

                Id recordTypeID = RecordTypeHelper.GetRecordTypeId('Opportunity','Automated');                
                List<OpportunityLineItem> lstOppLineItems = new List<OpportunityLineItem>();
                
                Opportunity opp = new Opportunity();
                opp.Name=opportunityName;                    
                opp.StageName='New Lead';
                opp.CloseDate = system.today();
                opp.AccountId=accountId;
                //opp.Amount=totalCost;
                opp.RecordTypeId = recordTypeID;
                
                opp.ChargentSFA__Billing_Email__c = lstContact[0].Email;
                opp.ChargentSFA__Billing_First__c = lstContact[0].FirstName;
                opp.ChargentSFA__Billing_Last__c = lstContact[0].LastName;
                opp.ChargentSFA__Billing_Phone__c = lstContact[0].HomePhone;

                
                opp.ChargentSFA__Billing_Address__c = lstAcct[0].BillingStreet;
                opp.ChargentSFA__Billing_City__c = lstAcct[0].BillingCity;
                opp.ChargentSFA__Billing_State__c = lstAcct[0].BillingState;
                opp.ChargentSFA__Billing_Zip__c = lstAcct[0].BillingPostalCode;
                opp.ChargentSFA__Billing_Country__c = lstAcct[0].BillingCountry;
                opp.ChargentSFA__Billing_Company__c = lstAcct[0].Billing_Address_Company__c;
                
                opp.Shipping_First_Name__c = lstContact[0].FirstName;
                opp.Shipping_Last_Name__c = lstContact[0].LastName;
                opp.Shipping_E_mail__c = lstContact[0].Email;
                opp.Shipping_Company_Name__c = lstContact[0].Company__c;
                opp.Shipping_Phone_No__c = lstContact[0].HomePhone;
                opp.Shipping_Street__c = lstContact[0].MailingStreet;
                opp.Shipping_City__c = lstContact[0].MailingCity;
                opp.Shipping_State__c = lstContact[0].MailingState;
                opp.Shipping_Postal_Code__c = lstContact[0].MailingPostalCode;
                opp.Shipping_Country__c = lstContact[0].MailingCountry;
                opp.Shipping_Company_Name__c = lstContact[0].Mailing_Address_Company__c;
                
                
                // Chargent Data
                //opp.ChargentSFA__Charge_Amount__c = totalCost;
                insert opp;                
                wco.opportunityId = opp.Id;
                
                OpportunityContactRole contactRole = new OpportunityContactRole(OpportunityId=opp.id, ContactId=lstContact[0].Id, Role='Decision Maker');
                insert contactRole;
                                             
                Decimal totalCost = 0;
                List<ID> idList = new List<ID>();
                List<String> prodCodes = new List<String>();
                List<PricebookEntry> lstPrice;
                
                for(purchaseCodeData pc :products) {
                    prodCodes.add(pc.prodCode);
                }
                
              
                List<PricebookEntry> lstPricebookEntry = [select Product2.Id, Product2.FRM_Exam__c, Product2.ERP_Exam__c, Product2.Name, Product2.ProductCode, Product2.GL_Code__c, Product2.Description, Product2.Image__c, Product2.IsActive, Product2.Weight__c, Product2.FRM_1_Book__c, Product2.FRM_2_Book__c, Product2.ERP_Study_Center__c, Product2.FBR_Study_Center__c, Product2.ICBRR_Study_Center__c, pricebook2.IsActive, UnitPrice, UseStandardPrice from PriceBookEntry where Pricebook2.IsActive = true and Product2.IsActive = true and pricebook2.IsActive = true];
                Integer months=0;
                String productDetails='';
                for(purchaseCodeData pur :products){

                    system.debug('* * * pur: '+ pur);
                    
                    PricebookEntry foundProd=null;    
                    for(PricebookEntry prod :lstPricebookEntry){
                        if(prod.Product2.ProductCode == pur.prodCode && prod.Product2.GL_Code__c == pur.glCode) {
                            foundProd = prod;
                            break;
                        }
                    }
                    
                    system.debug('* * * foundProd: '+ foundProd);
                    
                    //opp.Product_Names__c = '';
                    //opp.Total_Package_Weight__c = 0;
                    if(foundProd != null) {

                        if(foundProd.Product2.FRM_Exam__c==true) {
                            opp.Books_FRM_Practice_Exams__c=true;
                        }

                        if(foundProd.Product2.ERP_Exam__c==true) {
                            opp.Books_ERP_Practice_Exams__c=true;
                        }
                        
                        if(foundProd.Product2.FRM_1_Book__c==true) {
                            opp.Books_FRM_I__c=true;
                            if(foundProd.Product2.Weight__c > 0)
                                opp.Has_Books__c =true;
                        }
                            
                        if(foundProd.Product2.FRM_2_Book__c==true) {
                            opp.Books_FRM_II__c=true;
                            if(foundProd.Product2.Weight__c > 0)
                                opp.Has_Books__c =true;
                        }
                            
                        if(foundProd.Product2.ERP_Study_Center__c==true) {
                            opp.Books_ERP__c=true;
                            if(foundProd.Product2.Weight__c > 0)
                                opp.Has_Books__c =true;
                        }
                            
                        if(foundProd.Product2.ICBRR_Study_Center__c==true) {
                            opp.Books_ICBRR__c=true;
                            opp.Has_Books__c =true;
                        }
                            
                        if(foundProd.Product2.FBR_Study_Center__c==true) {
                            opp.Books_FBR__c=true;
                            if(foundProd.Product2.Weight__c > 0)                            
                                opp.Has_Books__c =true;
                        }
                            
                        OpportunityLineItem oppLineItem = new OpportunityLineItem();
                        oppLineItem.OpportunityId = opp.Id;
                        oppLineItem.PricebookEntryId = foundProd.Id;   
                        if(pur.price != null) {
                            oppLineItem.UnitPrice = Decimal.valueOf(pur.price);
                        } else {
                            oppLineItem.UnitPrice = foundProd.UnitPrice;    
                        }
                        if(pur.description != null) {
                            oppLineItem.Description = pur.description;
                        }
                        //if(pur.months != null) {
                        //    if(oppLineItem.Description != null)
                        //        oppLineItem.Description=oppLineItem.Description + ' ' + pur.months + ' months';
                        //    else oppLineItem.Description= pur.months + ' months';
                        //}                        
                        Decimal cost = oppLineItem.UnitPrice;
                        //if(pur.months != null) {
                        //    months = pur.months;
                        //    cost = (oppLineItem.UnitPrice/12)*pur.months;
                        //}
                        //oppLineItem.UnitPrice = cost;
                        if(pur.quantity != null) {
                            oppLineItem.Quantity=pur.quantity;
                            cost = cost * pur.quantity;
                        } else {
                            oppLineItem.Quantity=1;
                        }                        
                        totalCost+=cost;
                        lstOppLineItems.add(oppLineItem);
                        
                        if(foundProd.Product2.ProductCode == ampProductCode) {
                            opp.Alternate_Method_of_Payment__c = pur.description;
                        }
                        
                        if(foundProd.Product2.ProductCode != NULL && foundProd.Product2.ProductCode == 'SLSTX')
                            wco.tax = cost;
                        if(foundProd.Product2.ProductCode != NULL && foundProd.Product2.ProductCode == 'SHIP')
                            wco.shipping = cost;

                        if(productDetails == '') {
                            productDetails = foundProd.Product2.ProductCode + '~' + foundProd.Product2.GL_Code__c + '~' + foundProd.Product2.Name + '~' + cost + '~' + oppLineItem.Quantity;
                        } else {
                            productDetails = productDetails + '!' + foundProd.Product2.ProductCode + '~' + foundProd.Product2.GL_Code__c + '~' + foundProd.Product2.Name + '~' + cost + '~' + oppLineItem.Quantity;
                        }
                        
                    }                    
                }
                //System.assert(false, 'BOOM!'+ lstOppLineItems);

                insert lstOppLineItems;
                
                opp.Amount=totalCost;
                opp.ChargentSFA__Charge_Amount__c = totalCost;
                if(months != 0) {
                    Date now = date.today();
                    Date myDate = Date.newInstance(now.year(), now.month(), 1);
                    myDate = myDate.addMonths(months+1);
                    opp.Contract_End_Date__c = myDate;
                }
                update opp;
                
                opp = [select Id, Name, Display_Invoice_Number__c, Company__c from Opportunity where ID = :opp.Id];
                wco.invoiceNumber = opp.Display_Invoice_Number__c;
                wco.company = opp.Company__c;
                wco.totalCost = totalCost;
                wco.productDetails = productDetails;
                
                ChargentSFA__Payment_Request__c objPayment = new ChargentSFA__Payment_Request__c();
                objPayment.ChargentSFA__Billing_Contact__c = contactId;
                objPayment.ChargentSFA__Opportunity__c = opp.Id;
                insert objPayment;
                
                objPayment = [select id, name, ChargentSFA__Pay_Link__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Amount, ChargentSFA__Opportunity__r.Display_Invoice_Number__c from ChargentSFA__Payment_Request__c where id = :objPayment.Id];
                wco.payRequest = objPayment;
                
                return wco;
            }
        }
        
        return null;
    }

    @RemoteAction
    public static ChargentSFA__Payment_Request__c payPendingOpportunity(String oppId, String contactId){
        
        if(oppId == null || contactId == null || contactId == '')
            return null;
            
        Opportunity opp = [select Id, Name, Amount, ChargentSFA__Tokenization__c, ChargentSFA__Manual_Charge__c, ChargentSFA__Charge_Amount__c, (SELECT Id,Description,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice FROM OpportunityLineItems) 
                           from Opportunity where id = :oppId and StageName != 'Closed'];
        if(opp != null) {
            
            if(opp.Amount == 0) {
                opp.StageName = 'Closed';
                update opp;
                return null;                
            } else {
                
                LIST<ChargentSFA__Transaction__c> lstTrans = [Select id ,Name, ChargentSFA__Amount__c, ChargentSFA__Opportunity__r.CloseDate , ChargentSFA__Opportunity__c,ChargentSFA__Opportunity__r.GARP_Member_ID__c,
                                                        ChargentSFA__Opportunity__r.StageName , ChargentSFA__Type__c, ChargentSFA__Payment_Method__c, ChargentSFA__Response_Status__c, ChargentSFA__Gateway_Date__c
                                                        FROM ChargentSFA__Transaction__c  where ChargentSFA__Amount__c!= NULL and ChargentSFA__Opportunity__c = :oppId and ChargentSFA__Opportunity__r.StageName != 'Recurring Intent' AND (ChargentSFA__Type__c = 'Cedit') AND (ChargentSFA__Response_Status__c = 'Approved' OR ChargentSFA__Response_Status__c = '' OR ChargentSFA__Response_Status__c = NULL) 
                                                        ORDER BY ChargentSFA__Gateway_Date__c ASC];            
                
                if(lstTrans != null && lstTrans.size() > 0) {
                    Decimal amt = opp.Amount;
                    system.debug('amt:' + amt);
                    for(ChargentSFA__Transaction__c ct :lstTrans) {
                        amt-= ct.ChargentSFA__Amount__c;
                        system.debug('amt:' + amt + ':' + ct.ChargentSFA__Amount__c);
                    }
                    opp.ChargentSFA__Manual_Charge__c = true;
                    opp.ChargentSFA__Charge_Amount__c = amt;
                } else {
                    opp.ChargentSFA__Manual_Charge__c = false;
                }
                opp.ChargentSFA__Tokenization__c = null;
                update opp;
                
                PriceBookEntry pricebookEntry = [select Id, unitprice, productcode, product2.Gl_Code__c from PriceBookEntry where Pricebook2.IsActive = true and Pricebook2.IsActive = true and productcode = 'PRFEE' and product2.Gl_Code__c = '6110' and isActive = true];
                if(pricebookEntry != null) {
                    
                    
                    
                    List<OpportunityLineItem> lis = new List<OpportunityLineItem>();
                    for(OpportunityLineItem ol :opp.OpportunityLineItems){
                        if(ol.PricebookEntryId == pricebookEntry.Id) {
                            ol.TotalPrice = 0;
                            lis.add(ol);
                        }
                    }
                    update lis;
                    
                    ChargentSFA__Payment_Request__c objPayment;
                    List<ChargentSFA__Payment_Request__c> objPaymentList = [select id, name, ChargentSFA__Pay_Link__c from ChargentSFA__Payment_Request__c where ChargentSFA__Opportunity__c = :oppId and ChargentSFA__Status__c != 'Cancelled'];
                    
                    if(objPaymentList != null && objPaymentList.size() > 0) {
                        for(ChargentSFA__Payment_Request__c pr :objPaymentList) {
                            pr.ChargentSFA__Status__c = 'Cancelled';
                        }
                        update objPaymentList;
                    }
                    ChargentSFA__Payment_Request__c objPaymentNew = new ChargentSFA__Payment_Request__c();
                    objPaymentNew.ChargentSFA__Billing_Contact__c = contactId;
                    objPaymentNew.ChargentSFA__Opportunity__c = opp.Id;                    
                    insert objPaymentNew;
                    objPayment = [select id, name, ChargentSFA__Pay_Link__c from ChargentSFA__Payment_Request__c where id = :objPaymentNew.Id];
                    
                    return objPayment;
    
                }             
            }
        }
        return null;
        
    }
    
    
    @RemoteAction
    public static ChargentSFA__Payment_Request__c buyProducts(LIST<purchaseData> products){

        String paymentId;        
        String userId = UserInfo.getUserId();        

        getUserReturnData rd = new getUserReturnData ();
        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) {
        
            rd.userData = lstUser;        
            String contactId = lstUser[0].ContactId;
 
            List<Contact> lstContact = Database.query('SELECT Id, Name, FirstName, LastName, Email, HomePhone, Company__c, MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet, AccountId, GARP_ID__c, Membership_Type__c FROM Contact WHERE Id = :contactId');

            if( lstContact != null && lstContact.size() > 0 ) {

                rd.contactData = lstContact;
                String accountId = lstContact[0].AccountId;
        
                List<Account> lstAcct = [select Id, Name, BillingCity, BillingCountry, BillingPostalCode, BillingState, BillingStreet from Account where Id = :lstContact[0].AccountId];

                if( lstAcct != null && lstAcct.size() > 0 ) {
                    
                    Integer totalCost = 0;
                    List<ID> idList = new List<ID>();
                    for(purchaseData pur :products){
                        totalCost+= integer.valueof(pur.price);
                        idList.add(pur.Id);
                    }
    
                    Id recordTypeID = RecordTypeHelper.GetRecordTypeId('Opportunity','Automated');
                    Opportunity opp = new Opportunity();
                    opp.Name='Purchase';
                    opp.StageName='New Lead';
                    opp.CloseDate = system.today();
                    opp.AccountId=accountId;
                    opp.Amount=totalCost;
                    opp.RecordTypeId = recordTypeID;
                  
                    opp.ChargentSFA__Billing_Email__c = lstContact[0].Email;
                    opp.ChargentSFA__Billing_First__c = lstContact[0].FirstName;
                    opp.ChargentSFA__Billing_Last__c = lstContact[0].LastName;
                    opp.ChargentSFA__Billing_Phone__c = lstContact[0].HomePhone;
                    opp.ChargentSFA__Billing_Company__c = lstContact[0].Company__c;
                    
                    opp.ChargentSFA__Billing_Address__c = lstAcct[0].BillingStreet;
                    opp.ChargentSFA__Billing_City__c = lstAcct[0].BillingCity;
                    opp.ChargentSFA__Billing_State__c = lstAcct[0].BillingState;
                    opp.ChargentSFA__Billing_Zip__c = lstAcct[0].BillingPostalCode;
                    opp.ChargentSFA__Billing_Country__c = lstAcct[0].BillingCountry;

                    opp.Shipping_First_Name__c = lstContact[0].FirstName;
                    opp.Shipping_Last_Name__c = lstContact[0].LastName;
                    opp.Shipping_E_mail__c = lstContact[0].Email;
                    opp.Shipping_Company_Name__c = lstContact[0].Company__c;
                    opp.Shipping_Phone_No__c = lstContact[0].HomePhone;
                    opp.Shipping_Street__c = lstContact[0].MailingStreet;
                    opp.Shipping_City__c = lstContact[0].MailingCity;
                    opp.Shipping_State__c = lstContact[0].MailingState;
                    opp.Shipping_Postal_Code__c = lstContact[0].MailingPostalCode;
                    opp.Shipping_Country__c = lstContact[0].MailingCountry;
                    
                    // Chargent Data
                    opp.ChargentSFA__Charge_Amount__c = totalCost;
                    insert opp;

                    OpportunityContactRole contactRole = new OpportunityContactRole(OpportunityId=opp.id, ContactId=lstContact[0].Id, Role='Decision Maker');
                    insert contactRole;
                        
                    List<OpportunityLineItem> lstOppLineItems = new List<OpportunityLineItem>();
                    for(PriceBookEntry PricebookEntryId : [select unitprice,productcode from PriceBookEntry where Pricebook2.IsActive = true and Product2Id in: idList and isActive = true]) 
                    {
                        OpportunityLineItem oppLineItem = new OpportunityLineItem();
                        oppLineItem.OpportunityId = opp.Id;
                        oppLineItem.PricebookEntryId = PricebookEntryId.Id;   
                        oppLineItem.UnitPrice = totalCost;
                        oppLineItem.Quantity=1;
                        lstOppLineItems.add(oppLineItem);
                    }
                    insert lstOppLineItems;             
                    
                    
    
                    ChargentSFA__Payment_Request__c objPayment = new ChargentSFA__Payment_Request__c();
                    
                    objPayment.ChargentSFA__Billing_Contact__c = contactId;
                    objPayment.ChargentSFA__Opportunity__c = opp.Id;                    
                    insert objPayment;
                    
                    objPayment = [select id, name, ChargentSFA__Pay_Link__c from ChargentSFA__Payment_Request__c where id = :objPayment.Id];
    
                    return objPayment;
                }
            }
        }
        
        return null; 
    }

    @RemoteAction
    public static productData getStudyProducts(String mode){
             
        productData prodData = new productData();
        List<Product2> lstProducts;
        if(mode == 'FRM')
            lstProducts = [select Id, Name, Description, Image__c, Weight__c, Inventory__c, Pre_Order_Date__c from Product2 where FRM_Study_Center__c = true];
        if(mode == 'ERP')
            lstProducts = [select Id, Name, Description, Image__c, Weight__c, Inventory__c, Pre_Order_Date__c from Product2 where ERP_Study_Center__c = true];
        if(mode == 'FBR')
            lstProducts = [select Id, Name, Description, Image__c, Weight__c, Inventory__c, Pre_Order_Date__c from Product2 where FBR_Study_Center__c = true];
        if(mode == 'ICBRR')
            lstProducts = [select Id, Name, Description, Image__c, Weight__c, Inventory__c, Pre_Order_Date__c from Product2 where ICBRR_Study_Center__c = true];
        
        if( lstProducts != null && lstProducts.size() > 0 ) {
            prodData.product = lstProducts;
            List<PricebookEntry> lstPrice = [select Id, Name, UnitPrice, Product2Id, ProductCode, Product2.Weight__c, Product2.Display_Sort_Order__c from PriceBookEntry where Pricebook2.IsActive = true and Product2Id in :lstProducts and IsActive=true order by Product2.Display_Sort_Order__c];
            prodData.price = lstPrice;
        }            
        return prodData;
    } 

    
    @RemoteAction
    public static productData getFRMStudyProducts(){
        
        productData prodData = new productData();
        List<Product2> lstProducts = [select Id, Name, Description, Image__c from Product2 where FRM_Study_Center__c = true];
        if( lstProducts != null && lstProducts.size() > 0 ) {
            prodData.product = lstProducts;
            List<PricebookEntry> lstPrice = [select Id, Name, UnitPrice, Product2Id, ProductCode from PriceBookEntry where Pricebook2.IsActive = true and Product2Id in :lstProducts and IsActive=true];
            prodData.price = lstPrice;
        }            
        return prodData;
    } 
        
    @RemoteAction
    public static productData getERPStudyProducts(){
        
        productData prodData = new productData();
        List<Product2> lstProducts = [select Id, Name, Description, Image__c from Product2 where ERP_Study_Center__c = true];
        if( lstProducts != null && lstProducts.size() > 0 ) {
            prodData.product = lstProducts;
            List<PricebookEntry> lstPrice = [select Id, Name, UnitPrice, Product2Id, ProductCode from PriceBookEntry where Pricebook2.IsActive = true and Product2Id in :lstProducts and IsActive=true];
            prodData.price = lstPrice;
        }            
        return prodData;
    } 

    @RemoteAction
    public static List<ContentVersion> getLibraryDocs(String name){
        
        List<ContentVersion> lstDocs;
        List<ContentWorkspace> lstfolder = [select id,name from ContentWorkspace where Name = :name];
        if( lstfolder != null && lstfolder.size() > 0 ) {
            lstDocs = [Select Id, Title, Description, Image__c from ContentVersion where ContentDocumentId in (select id from ContentDocument where parentId =:lstfolder[0].Id ) ];
        }
        return lstDocs;
    } 
    
    @RemoteAction
    public static List<Document> getFolderDocs(String name){
        
        List<Document> lstDocs;
        List<Folder> lstfolder = [Select Id from folder where Name = :name];
        if( lstfolder != null && lstfolder.size() > 0 ) {
            lstDocs = [Select Id, Name, ContentType, Description from Document where folderId = :lstfolder[0].Id];
        }
        return lstDocs;
    }  

        
    @RemoteAction
    global static Boolean requestNewChapter(String name, String type, String loction) { 
        
        String userId = UserInfo.getUserId();        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) {
        
            String contactId = lstUser[0].ContactId;
 
            system.debug('* * * contactId ...'+ contactId);
            //System.assert(false, 'BOOM!');
            
            List<Contact> lstContact = [SELECT Id, Name FROM Contact WHERE Id = :contactId];
            if( lstContact != null && lstContact.size() > 0 ) {
    
                Chapter__c ch = new Chapter__c();
                ch.put('Name',name);
                ch.put('Type__c',type);
                ch.put('Location__c',loction);
                ch.put('Status__c','Requested');
                insert ch;
                
                if(ch != null) {
                    Chapter_Member__c cm = new Chapter_Member__c();
                    cm.put('Chapter__c',ch.id);
                    cm.put('Contact__c',contactId);
                    cm.put('Director_Application_Status__c','Upload');
                    insert cm;
                }
            }
        }
        return true;
    }
    
    @RemoteAction
    public static CPEActivitiesWrapper getCPEActivities(){
        CPEActivitiesWrapper saw = new CPEActivitiesWrapper();
            
        List<CPE_Activity__c> ca = [select Id, Name, Title__c, Description__c, Status__c, Start_Date__c, End_Date__c, CPE_Activity_Type__r.Name, Area_of_Study__c, Credit__c, Date_Description__c, Organization__c, Provider__c, Account__c, Publication__c, URL__c from CPE_Activity__c where Status__c = 'Active'];
        if(ca != null && ca.size() > 0) {
            
            List<Id> aids = new List<Id>();
            List<CPE_Activity__c> cpdActReturn = new List<CPE_Activity__c>();
            
            for(CPE_Activity__c c : ca) {
            
                datetime nowDateTime = datetime.now();
                Boolean addContent = false;
                if(c.End_Date__c == null && c.Start_Date__c != null && nowDateTime >= c.Start_Date__c) {
                    addContent = true;
                } else if(c.Start_Date__c == null && c.End_Date__c != null && nowDateTime < c.End_Date__c) {
                    addContent = true;
                } else if(c.Start_Date__c != null && c.End_Date__c != null && nowDateTime >= c.Start_Date__c && nowDateTime < c.End_Date__c) {
                    addContent = true;
                } else if(c.Start_Date__c == null && c.End_Date__c == null){
                    addContent = true;
                }       
                if(addContent == true) {
                    cpdActReturn.add(c);
                    aids.add(c.Account__c);
                }

            }
            List<Account> acct = [select Id, Name, CPE_Provider_Logo__c from Account where Id in :aids];
            saw.accounts = acct;
            saw.activities = cpdActReturn;
        }
        return saw;
    }
    
    @RemoteAction 
    public static Boolean submitCreditContent(String activityTypeId, String cpeCandidateRequirementId) {

        String userId = UserInfo.getUserId();            
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) {
        
            List<Contact> lstContact = [select Id, Name, KPI_FRM_Certified__c, KPI_ERP_Certified__c from Contact where Id = :lstUser[0].ContactId];
            if( lstContact != null && lstContact.size() > 0 ) {

                List<CPE_Activity__c> lstDocs = [select Id, Name, Title__c, Description__c, CPE_Activity_Type__c, Activity_Type_Description__c, Area_of_Study__c, Credit__c, Date_Description__c, Organization__c, Provider__c, Account__c, Publication__c, URL__c from CPE_Activity__c where Id = :activityTypeId];
        
                if( lstDocs != null && lstDocs.size() > 0 && lstDocs[0].CPE_Activity_Type__c != null && lstDocs[0].Credit__c != null && lstDocs[0].Title__c != null) {
        
                    CPE_Activity__c doc = lstDocs[0];
                    Date now = date.today();

                    CPE_Claim__c newClaim = new CPE_Claim__c();
                    newClaim.Candidate_Requirement__c = cpeCandidateRequirementId;
                    newClaim.CPE_Activity_Type__c = doc.CPE_Activity_Type__c;
                    newClaim.Date_of_Completion__c = now;
                    newClaim.Credits_Earned__c = doc.Credit__c;
                    newClaim.EventTitle__c = doc.Title__c;
                    if(doc.Organization__c != null) {
                        newClaim.OrganizationName__c = doc.Organization__c;
                    }
                    if(doc.Account__c != null) {
                        newClaim.Provider__c = doc.Account__c;
                    }
                    if(doc.Area_of_Study__c != null) {
                        newClaim.Area_of_Study__c = doc.Area_of_Study__c;
                    }
                    if(doc.Publication__c != null) {
                        newClaim.Publication__c = doc.Publication__c;
                    }
                    if(doc.URL__c != null) {
                        newClaim.URL__c = doc.URL__c;
                    }
                    if(doc.Description__c != null) {
                        if(doc.Description__c.length() > 255) {
                            newClaim.Comment__c = doc.Description__c.substring(0, 255);        
                        } else {
                            newClaim.Comment__c = doc.Description__c;        
                        }
                        
                    }
                    
                    newClaim.Member__c = lstContact[0].Id;
                    newClaim.FRM__c = lstContact[0].KPI_FRM_Certified__c;
                    newClaim.ERP__c = lstContact[0].KPI_ERP_Certified__c;
                    insert newClaim;
                    return true;
                }
            }
        }
        return false;
    }
    
    @RemoteAction
    public static List<Content__c> getAds() {
        List<Content__c> ads = [ Select Id, Name, Is_advertisement__c, Ad_Format__c, Content_Name__c, Image__c, Third_Party_URL__c, Raw_HTML__c, Story__c from Content__c where Is_advertisement__c = True and Status__c = 'Active' and Suppress_Ad_in_Portal__c = False];
        return ads;
    }
    
    
    @RemoteAction
    public static List<contentData> getContentDoc(String docId){
        
        List<contentData> lstContentData = new List<contentData>();
        String userId = UserInfo.getUserId();            
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) {
        
            List<Contact> lstContact = [select Id, Name, Content_Viewed_Count__c, Content_Viewed__c, Content_Types_Viewed__c, Content_Topics_Viewed__c from Contact where Id = :lstUser[0].ContactId];
            if( lstContact != null && lstContact.size() > 0 ) {
        
        		List<Content_Analytic__c> lstContactContenyAnalytics = [Select Id, Name, Type__c, Count__c, Bucket1__c, Bucket2__c, Trend__c from Content_Analytic__c where Contact__c = :lstContact[0].Id];
                
                List<Content__c> lstAll = new List<Content__c>();
        
                Map<String,Integer> ctCountMap = new Map<String,Integer>();
                lstAll = [Select Id, Name, Content_Name__c, View_Count__c, RecordTypeId, Description__c, SKU__c, Is_advertisement__c, Image__c, Third_Party_Author__c, Author__r.Name, primary_author__r.Name, primary_author__r.Email__c, primary_author__r.twitter_handle__c, primary_author__r.image__c, Content_Type__c,Featured__c, Published_Date__c, Story__c, Raw_HTML__c, Topic__c, Start_Date__c, End_Date__c, Third_Party_URL__c, Duration_in_Minutes__c, Event_Date_Time__c, Is_On_Demand__c, Moderators__c, Presenters__c, Visibility_ERP__c, Visibility_FRM__c, Visibility_Membership__c, Location__c, Bucket1__c, Bucket2__c from Content__c where Status__c = 'Active' and Is_advertisement__c != true and Id = :docId];
                    
                if( lstAll != null && lstAll.size() > 0 ) {
                    
                    //To Make the currentdate
                    datetime myDateTime = datetime.now();
                    Integer  mydtstring = Integer.valueof(mydatetime.format('yyyy')); 
                    //To Make a date of 1st of jan of year 
                    datetime myDate = datetime.newInstance(mydtstring , 1, 1); 
                    //To find what the weekday of the 1st jan
                    String st = myDate.format('EEEE');
                    //Function To calculate the week Number of the year
                    integer weekNum = integer.valueof(System.Now().Format('w'));
                    
                    integer bucketNumber = 2;
                    if(Math.mod(weekNum, 2) == 0)
                        bucketNumber = 1;
                    
                        
                    sfdcAppRemoter sr = new sfdcAppRemoter();        
                    lstContentData = sr.filterContentDocs(lstAll, null); 
                    
                    Decimal cnt = lstAll[0].View_Count__c;
                    if(cnt == null)
                        cnt=1;
                    else cnt++;
                    lstAll[0].View_Count__c = cnt;
                    if(bucketNumber==1) {
                        if(lstAll[0].Bucket1__c == null)
                            lstAll[0].Bucket1__c=1;
                        else lstAll[0].Bucket1__c = Integer.valueOf(lstAll[0].Bucket1__c)+1;
                    } else {
                        if(lstAll[0].Bucket2__c == null)
                            lstAll[0].Bucket2__c=1;
                        else lstAll[0].Bucket2__c = Integer.valueOf(lstAll[0].Bucket2__c)+1;                
                    }
                    
                    if(lstContact[0].Content_Viewed_Count__c == null)
                        lstContact[0].Content_Viewed_Count__c=1;
                    else lstContact[0].Content_Viewed_Count__c = Integer.valueOf(lstContact[0].Content_Viewed_Count__c)+1;
                    
                    // Content Viewed
                    //131,072 max                        
                    if(lstContact[0].Content_Viewed__c != null) {
                        String[] arrText = lstContact[0].Content_Viewed__c.split('~');
                        Boolean found=false;
                        for(String s :arrText) {
                            if(s == lstAll[0].Id)
                                found=true;
                        }
                        if(found == false) {
                            if(arrText.size() == 6553) {
                                Integer idx = lstContact[0].Content_Viewed__c.indexOf('~');
                                String ads = lstContact[0].Content_Viewed__c;
                                lstContact[0].Content_Viewed__c = ads.substring(idx+1, ads.length());
                            } 
                            lstContact[0].Content_Viewed__c+='~'+String.valueOf(lstAll[0].Id);
                        }
                            
                    } else {
                        lstContact[0].Content_Viewed__c = String.valueOf(lstAll[0].Id);
                    }

                    
                    // Content Types
                    if(lstAll[0].Content_Type__c != null) {
                        MAP<String,Integer> mapContType = new MAP<String,Integer>();
                        if(lstContact[0].Content_Types_Viewed__c != null) {
                            String[] arrText = lstContact[0].Content_Types_Viewed__c.split('~');
                            Boolean found=false;
                            for(String s :arrText) {
                                String[] arrValues = s.split('!');
                                if(arrValues.size() > 1) {
                                    mapContType.put(arrValues[0],Integer.valueOf(arrValues[1]));
                                }
                            }
                        }
                        
                        system.debug('Content_Type__c:' + lstAll[0].Content_Type__c);
                        
                        if(lstAll[0].Content_Type__c != null) {
                            Integer ctc = mapContType.get(lstAll[0].Content_Type__c);
                            if(ctc == null) {
                                mapContType.put(lstAll[0].Content_Type__c,1);
                            } else {
                                ctc++;
                                mapContType.put(lstAll[0].Content_Type__c,ctc);
                            }
                        }
                        
                        system.debug('mapContType:' + mapContType);
                        
                        String vct = '';
                        for(String key :mapContType.keySet()) {
                            Integer val = mapContType.get(key);
                            if(vct=='')
                                vct = key+'!'+val;
                            else vct+='~'+key+'!'+val;
                        }
                        
                        system.debug('vct:' + vct); 
                        
                        lstContact[0].Content_Types_Viewed__c = vct;                        
                    }                    
                    
                    // Topics
                    if(lstAll[0].Topic__c != null) {
                        MAP<String,Integer> mapContTopic = new MAP<String,Integer>();
                        if(lstContact[0].Content_Topics_Viewed__c != null) {
                            String[] arrText = lstContact[0].Content_Topics_Viewed__c.split('~');
                            Boolean found=false;
                            for(String s :arrText) {
                                String[] arrValues = s.split('!');
                                if(arrValues.size() > 1) {
                                    mapContTopic.put(arrValues[0],Integer.valueOf(arrValues[1]));
                                }
                            }
                        }
                        
                        system.debug('mapContTopic:' + mapContTopic);  
                        
                        String[] arrTopText = lstAll[0].Topic__c.split(';');                    
                        for(String s :arrTopText) {  
                            Integer ct = mapContTopic.get(s);    
                            if(ct == null) {
                                mapContTopic.put(s,1);
                            } else {
                                ct++;
                                mapContTopic.put(s,ct);
                            }                        
                        }
                        
                        system.debug('mapContTopic1:' + mapContTopic);
                        
                        String vct = '';
                        for(String key :mapContTopic.keySet()) {
                            Integer val = mapContTopic.get(key);
                            if(vct=='')
                                vct = key+'!'+val;
                            else vct+='~'+key+'!'+val;
                        }
                        system.debug('vct:' + vct); 
                        
                        lstContact[0].Content_Topics_Viewed__c = vct;                           
                    }
                 
                    
                    update lstContact;
                    
                    update lstAll;
                     
                    List<Content_Analytic__c> lstContenyAnalytics = [Select Id, Name, Type__c, Count__c, Bucket1__c, Bucket2__c, Trend__c from Content_Analytic__c where Contact__c = null];
                    
                    system.debug('lstContenyAnalytics:' + lstContenyAnalytics);
                    
                    Integer contentTypeCount = 0;
                    Integer topicCount = 0;
                    
                    system.debug('bucketNumber:' + bucketNumber);
                    
                    Map<String,Content_Analytic__c> mapTopics = new Map<String,Content_Analytic__c>(); 
                    Map<String,Content_Analytic__c> mapContentTypes = new Map<String,Content_Analytic__c>(); 
                    
                    List<Content_Analytic__c> addCA = new List<Content_Analytic__c>();
                    List<Content_Analytic__c> updateCA = new List<Content_Analytic__c>();
                    
                    if(lstContenyAnalytics != Null) {
                        for(Content_Analytic__c ca :lstContenyAnalytics) {
                            
                            system.debug('ca:' + ca);
                            
                            if(ca.Type__c == 'Content-Type') {
                                mapContentTypes.put(ca.Name, ca);
                            }                        
                            if(ca.Type__c == 'Topic') {
                                mapTopics.put(ca.Name, ca);
                            }
                        }
        
                        system.debug('contentTypeCount:' + contentTypeCount);
                        system.debug('mapTopics:' + mapTopics);
                        
                        if(lstAll[0].Content_Type__c != null) {
                            Content_Analytic__c ct = mapContentTypes.get(lstAll[0].Content_Type__c);    
                            if(ct != null) {
                                contentTypeCount = Integer.valueOf(ct.Count__c)+1;
                                ct.Count__c = contentTypeCount;
                                if(bucketNumber==1)
                                    ct.Bucket1__c = Integer.valueOf(ct.Bucket1__c)+1;
                                else ct.Bucket2__c = Integer.valueOf(ct.Bucket2__c)+1;
                                updateCA.add(ct);                        
                            }
                            if(contentTypeCount == 0) {
                                Content_Analytic__c cm = new Content_Analytic__c();
                                cm.Name=lstAll[0].Content_Type__c;
                                cm.Type__c='Content-Type';
                                cm.Count__c=1;
                                cm.Trend__c=0;
                                if(bucketNumber==1) {
                                    cm.Bucket1__c=1;
                                    cm.Bucket2__c=0;
                                } else {
                                    cm.Bucket1__c=0;
                                    cm.Bucket2__c=1;                        
                                }
                                addCA.add(cm);                
                            }
                        }
        
                        if(lstAll[0].Topic__c != null) {
                            String[] arrText = lstAll[0].Topic__c.split(';');                    
                            for(String s :arrText) {  
                                Content_Analytic__c ca = mapTopics.get(s);
                                if(ca == null) {
                                    Content_Analytic__c cm = new Content_Analytic__c();
                                    cm.Name=s;
                                    cm.Type__c='Topic';
                                    cm.Count__c=1;
                                    cm.Trend__c=0;
                                    if(bucketNumber==1) {
                                        cm.Bucket1__c=1;
                                        cm.Bucket2__c=0;
                                    } else {
                                        cm.Bucket1__c=0;
                                        cm.Bucket2__c=1;                        
                                    }
                                    addCA.add(cm);                    
                                } else {
                                    ca.Count__c++;
                                    if(bucketNumber==1)
                                        ca.Bucket1__c = Integer.valueOf(ca.Bucket1__c)+1;
                                    else ca.Bucket2__c = Integer.valueOf(ca.Bucket2__c)+1;                        
                                    updateCA.add(ca);
                                }
                            }
                        }
                        insert addCA;
                        update updateCA;
                    }
                }        
            }
        }
        return lstContentData;
    } 

    @RemoteAction
    public static List<contentData> getContentPopularDocs(String name){
        
        List<Content_Folders__c> lstFolderDocs;
        List<Id> lstFolderDocIds = new List<Id>();
        List<Content__c> lstDocs;
        List<Content__c> lstAll = new List<Content__c>();
            
            
        List<contentData> lstContentData = new List<contentData>();
        List<contentData> lstContentDataFinal = new List<contentData>();

        Map<String,Integer> ctCountMap = new Map<String,Integer>();
        
        List<Folder__c> lstfolder = [Select Id from Folder__c where Name = :name];
        if( lstfolder != null && lstfolder.size() > 0 ) {

            lstFolderDocs = [select Content__c from Content_Folders__c where Folder__c = :lstfolder[0].Id];    
            for(Content_Folders__c cf : lstFolderDocs) {
                if(cf.Content__c != null)
                    lstFolderDocIds.add(cf.Content__c);
            }
                
            
            lstDocs = [Select Id, Name, Content_Name__c, View_Count__c, RecordTypeId, Description__c, SKU__c, Is_advertisement__c, Image__c, Third_Party_Author__c, Author__r.Name, Content_Type__c,Featured__c, Published_Date__c, Story__c, Topic__c, Start_Date__c, End_Date__c, Third_Party_URL__c, Duration_in_Minutes__c, Event_Date_Time__c, Is_On_Demand__c, Moderators__c, Presenters__c, Visibility_ERP__c, Visibility_FRM__c, Visibility_Membership__c, Location__c from Content__c where Status__c = 'Active' and Is_advertisement__c != true and (Content_Type__c = 'News' or Id in :lstFolderDocIds) and View_Count__c != null order by View_Count__c DESC];
            
            if( lstDocs != null && lstDocs.size() > 0 ) {
                
                sfdcAppRemoter sr = new sfdcAppRemoter();        
                lstContentData = sr.filterContentDocs(lstDocs, 4); 
                
                integer cnt = 0;
                for(contentData cd :lstContentData) {
                    if(cnt<5)
                        lstContentDataFinal.add(cd);
                    else break;
                    cnt++;
                }
            }
        }        
        return lstContentDataFinal;
    } 

    @RemoteAction
    public static List<Content__c> fetchFeatured(String folderName, String contentType) {

        //List<Folder__c> lstfolder = [Select Id from Folder__c where Name = :folderName];
        //if( lstfolder != null && lstfolder.size() > 0 ) {
            List<Content__c> lstFeatured = [select Id, Name, Content_Name__c, RecordTypeId, Description__c, SKU__c, Is_advertisement__c, Image__c, Third_Party_Author__c, Author__r.Name, Content_Type__c,Featured__c, Published_Date__c, Story__c, Topic__c, Start_Date__c, End_Date__c, Third_Party_URL__c, Duration_in_Minutes__c, Event_Date_Time__c, Is_On_Demand__c, Moderators__c, Presenters__c, Visibility_ERP__c, Visibility_FRM__c, Visibility_Membership__c, Location__c from Content__c where Status__c = 'Active' and Is_advertisement__c != true and Featured_Order__c != null order by Featured_Order__c ASC limit 3];
            if(lstFeatured != null) {            
                return lstFeatured;
            }
        //}
        return null;
    }

    
    @RemoteAction
    public static List<contentData> getContentOverviewDocs(String name, String contentType){
        
        List<Content__c> lstDocs;
        List<Content__c> lstAll = new List<Content__c>();
        List<Content__c> lstFeatures = new List<Content__c>();
            
            
        List<contentData> lstContentData = new List<contentData>();
        List<contentData> lstFeaturesContentData = new List<contentData>();
        List<contentData> lstContentDataFinal = new List<contentData>();
        

        Map<String,Integer> ctCountMap = new Map<String,Integer>();
        
        List<Folder__c> lstfolder = [Select Id from Folder__c where Name = :name];
        if( lstfolder != null && lstfolder.size() > 0 ) {
            
            if(contentType == 'News')
                lstAll = [Select Id, Name, Content_Name__c, RecordTypeId, Description__c, SKU__c, Is_advertisement__c, Image__c, Third_Party_Author__c, Author__r.Name, Content_Type__c,Featured__c, Published_Date__c, Story__c, Topic__c, Start_Date__c, End_Date__c, Third_Party_URL__c, Duration_in_Minutes__c, Event_Date_Time__c, Is_On_Demand__c, Moderators__c, Presenters__c, Visibility_ERP__c, Visibility_FRM__c, Visibility_Membership__c, Location__c from Content__c where Content_Type__c = 'News' order by Published_Date__c DESC limit 10];
            else lstAll = [Select Id, Name, Content_Name__c, RecordTypeId, Description__c, SKU__c, Is_advertisement__c, Image__c, Third_Party_Author__c, Author__r.Name, Content_Type__c,Featured__c, Published_Date__c, Story__c, Topic__c, Start_Date__c, End_Date__c, Third_Party_URL__c, Duration_in_Minutes__c, Event_Date_Time__c, Is_On_Demand__c, Moderators__c, Presenters__c, Visibility_ERP__c, Visibility_FRM__c, Visibility_Membership__c, Location__c from Content__c where Status__c = 'Active' and Is_advertisement__c != true and Content_Type__c = :contentType and Id in (select Content__c from Content_Folders__c where Folder__c = :lstfolder[0].Id) order by Published_Date__c DESC limit 10];

            if(contentType == 'News')
                lstFeatures = [Select Id, Name, Content_Name__c, RecordTypeId, Description__c, SKU__c, Is_advertisement__c, Image__c, Third_Party_Author__c, Author__r.Name, Content_Type__c,Featured__c, Published_Date__c, Story__c, Topic__c, Start_Date__c, End_Date__c, Third_Party_URL__c, Duration_in_Minutes__c, Event_Date_Time__c, Is_On_Demand__c, Moderators__c, Presenters__c, Visibility_ERP__c, Visibility_FRM__c, Visibility_Membership__c, Location__c from Content__c where Content_Type__c = 'News' and Featured__c = true order by Published_Date__c DESC limit 10];
            else lstFeatures = [Select Id, Name, Content_Name__c, RecordTypeId, Description__c, SKU__c, Is_advertisement__c, Image__c, Third_Party_Author__c, Author__r.Name, Content_Type__c,Featured__c, Published_Date__c, Story__c, Topic__c, Start_Date__c, End_Date__c, Third_Party_URL__c, Duration_in_Minutes__c, Event_Date_Time__c, Is_On_Demand__c, Moderators__c, Presenters__c, Visibility_ERP__c, Visibility_FRM__c, Visibility_Membership__c, Location__c from Content__c where Status__c = 'Active' and Is_advertisement__c != true and Featured__c = true and Content_Type__c = :contentType and Id in (select Content__c from Content_Folders__c where Folder__c = :lstfolder[0].Id) order by Published_Date__c DESC limit 10];
            
            //System.assert(false, 'BOOM!!!!' + lstFeatures);

            sfdcAppRemoter sr = new sfdcAppRemoter();     
            lstContentDataFinal = sr.filterContentDocs(lstAll, 6); 
            
            if(lstFeatures != null && lstFeatures.size() > 0) {
                lstFeaturesContentData = sr.filterContentDocs(lstFeatures, 1); 
                lstContentDataFinal.add(lstFeaturesContentData[0]);
            } 
            
        }        
        return lstContentDataFinal;
    } 

    @RemoteAction
    public static List<contentData> getContentBrowseDocs(String name, List<String> contentTypes, List<String> topics, List<String> recordTypes, Integer limitParam, Integer offset){
        return getContentBrowseDocsInternal(name, contentTypes, topics, recordTypes, limitParam, offset);
    }
    
    public static List<contentData> getContentBrowseDocsInternal(String name, List<String> contentTypes, List<String> topics, List<String> recordTypes, Integer limitParam , Integer offset){
        
        List<Content__c> lstDocs;
        List<contentData> lstContentData = new List<contentData>();

        
        System.debug('In Params:' + contentTypes + ':' + topics + ':' + recordTypes);
            
       //System.assert(false, 'BOOM!' + contentTypes + ':' + topics + ':' + recordTypes + ':' + limitParam + ':' + offset);
        
        List<Folder__c> lstfolder = [Select Id from Folder__c where Name = :name];
        if( lstfolder != null && lstfolder.size() > 0 ) {
            
            Boolean found=false;
            Boolean allTopics=false;
            Boolean allContTypes=false;
            Boolean allRecordTypes=false;
            String sContTypes = null;
            for(String s : contentTypes) {
                if(s == 'all') {
                    allContTypes=true;
                    found=true;
                } else {
                    if(sContTypes == null)
                        sContTypes = '\'' + s + '\'';
                    else sContTypes = sContTypes + ',\'' + s + '\'';
                }                
            }            
            if(found)
                contentTypes.add(null);

            found=false;
            String sTopics = null;
            for(String s : topics) {
                if(s == 'all') {
                    allTopics=true;
                    found=true;
                } else {
                    if(sTopics == null)
                        sTopics = '\'' + s + '\'';
                    else sTopics = sTopics + ',\'' + s + '\'';
                }                
            }            
            if(found)
                topics.add(null);

            List<Id> rcTypes = new List<Id>();
            String sRecTypes = null;
            for(String s :recordTypes) {
                if(s == 'all') {
                     allRecordTypes=true;
                     rcTypes.add(null);
                } else {
                    //Id rcId = RecordTypeHelper.GetRecordTypeId('Content__c',s);
                    if(sRecTypes == null)
                        sRecTypes = '\'' + s + '\'';
                    else sRecTypes = sRecTypes + ',\'' + s + '\'';
                    //rcTypes.add(rcId);
                }
            }

            System.debug('Out Params:' + sContTypes + ':' + sTopics + ':' + sRecTypes);
                    
            if(allTopics && !allContTypes && !allRecordTypes) {
        
                lstDocs = Database.query('Select Id, Name, Content_Name__c, RecordTypeId, Description__c, SKU__c, Is_advertisement__c, Image__c, Third_Party_Author__c, Author__r.Name, Content_Type__c,Featured__c, Published_Date__c, Story__c, Topic__c, Start_Date__c, End_Date__c, Third_Party_URL__c, Duration_in_Minutes__c, Event_Date_Time__c, Is_On_Demand__c, Moderators__c, Presenters__c, Visibility_ERP__c, Visibility_FRM__c, Visibility_Membership__c, Location__c from Content__c where Status__c = \'Active\' and Is_advertisement__c != true and Id in (select Content__c from Content_Folders__c where Folder__c = \'' + lstfolder[0].Id + '\') and Content_Type__c in (' + sContTypes + ') and RecordTypeId in (' + sRecTypes + ') order by Published_Date__c DESC  limit :limitParam offset :offset');
        
            } else if(!allTopics && allContTypes && !allRecordTypes) {
        
                lstDocs = Database.query('Select Id, Name, Content_Name__c, RecordTypeId, Description__c, SKU__c, Is_advertisement__c, Image__c, Third_Party_Author__c, Author__r.Name, Content_Type__c,Featured__c, Published_Date__c, Story__c, Topic__c, Start_Date__c, End_Date__c, Third_Party_URL__c, Duration_in_Minutes__c, Event_Date_Time__c, Is_On_Demand__c, Moderators__c, Presenters__c, Visibility_ERP__c, Visibility_FRM__c, Visibility_Membership__c, Location__c from Content__c where Status__c = \'Active\' and Is_advertisement__c != true and Id in (select Content__c from Content_Folders__c where Folder__c = \'' + lstfolder[0].Id + '\') and RecordTypeId in (' + sRecTypes + ') and Topic__c includes (' + sTopics + ') order by Published_Date__c DESC  limit :limitParam offset :offset');
        
            } else if(!allTopics && !allContTypes && allRecordTypes) {
        
                lstDocs = Database.query('Select Id, Name, Content_Name__c, RecordTypeId, Description__c, SKU__c, Is_advertisement__c, Image__c, Third_Party_Author__c, Author__r.Name, Content_Type__c,Featured__c, Published_Date__c, Story__c, Topic__c, Start_Date__c, End_Date__c, Third_Party_URL__c, Duration_in_Minutes__c, Event_Date_Time__c, Is_On_Demand__c, Moderators__c, Presenters__c, Visibility_ERP__c, Visibility_FRM__c, Visibility_Membership__c, Location__c from Content__c where Status__c = \'Active\' and Is_advertisement__c != true and Id in (select Content__c from Content_Folders__c where Folder__c = \'' + lstfolder[0].Id + '\') and Content_Type__c in (' + sContTypes + ') and Topic__c includes (' + sTopics + ') order by Published_Date__c DESC  limit :limitParam offset :offset');
        
            } else if(allTopics && allContTypes && !allRecordTypes) {
        
                lstDocs = Database.query('Select Id, Name, Content_Name__c, RecordTypeId, Description__c, SKU__c, Is_advertisement__c, Image__c, Third_Party_Author__c, Author__r.Name, Content_Type__c,Featured__c, Published_Date__c, Story__c, Topic__c, Start_Date__c, End_Date__c, Third_Party_URL__c, Duration_in_Minutes__c, Event_Date_Time__c, Is_On_Demand__c, Moderators__c, Presenters__c, Visibility_ERP__c, Visibility_FRM__c, Visibility_Membership__c, Location__c from Content__c where Status__c = \'Active\' and Is_advertisement__c != true and Id in (select Content__c from Content_Folders__c where Folder__c = \'' + lstfolder[0].Id + '\') and RecordTypeId in (' + sRecTypes + ') order by Published_Date__c DESC  limit :limitParam offset :offset');
        
            } else if(!allTopics && allContTypes && allRecordTypes) {
        
                lstDocs = Database.query('Select Id, Name, Content_Name__c, RecordTypeId, Description__c, SKU__c, Is_advertisement__c, Image__c, Third_Party_Author__c, Author__r.Name, Content_Type__c,Featured__c, Published_Date__c, Story__c, Topic__c, Start_Date__c, End_Date__c, Third_Party_URL__c, Duration_in_Minutes__c, Event_Date_Time__c, Is_On_Demand__c, Moderators__c, Presenters__c, Visibility_ERP__c, Visibility_FRM__c, Visibility_Membership__c, Location__c from Content__c where Status__c = \'Active\' and Is_advertisement__c != true and Id in (select Content__c from Content_Folders__c where Folder__c = \'' + lstfolder[0].Id + '\') and Topic__c includes (' + sTopics + ') order by Published_Date__c DESC  limit :limitParam offset :offset');
        
            } else if(allTopics && !allContTypes && allRecordTypes) {
        
                lstDocs = Database.query('Select Id, Name, Content_Name__c, RecordTypeId, Description__c, SKU__c, Is_advertisement__c, Image__c, Third_Party_Author__c, Author__r.Name, Content_Type__c,Featured__c, Published_Date__c, Story__c, Topic__c, Start_Date__c, End_Date__c, Third_Party_URL__c, Duration_in_Minutes__c, Event_Date_Time__c, Is_On_Demand__c, Moderators__c, Presenters__c, Visibility_ERP__c, Visibility_FRM__c, Visibility_Membership__c, Location__c from Content__c where Status__c = \'Active\' and Is_advertisement__c != true and Id in (select Content__c from Content_Folders__c where Folder__c = \'' + lstfolder[0].Id + '\') and Content_Type__c in (' + sContTypes + ') order by Published_Date__c DESC  limit :limitParam offset :offset');
        
            } else if(!allTopics && !allContTypes && !allRecordTypes) {
              
                lstDocs = Database.query('Select Id, Name, Content_Name__c, RecordTypeId, Description__c, SKU__c, Is_advertisement__c, Image__c, Third_Party_Author__c, Author__r.Name, Content_Type__c,Featured__c, Published_Date__c, Story__c, Topic__c, Start_Date__c, End_Date__c, Third_Party_URL__c, Duration_in_Minutes__c, Event_Date_Time__c, Is_On_Demand__c, Moderators__c, Presenters__c, Visibility_ERP__c, Visibility_FRM__c, Visibility_Membership__c, Location__c from Content__c where Status__c = \'Active\' and Is_advertisement__c != true and Id in (select Content__c from Content_Folders__c where Folder__c = \'' + lstfolder[0].Id + '\') and Content_Type__c in (' + sContTypes + ') and RecordTypeId in (' + sRecTypes + ') and Topic__c includes (' + sTopics + ') order by Published_Date__c DESC  limit :limitParam offset :offset');
        
            } else if(allTopics && allContTypes && allRecordTypes) {
              
                lstDocs = Database.query('Select Id, Name, Content_Name__c, RecordTypeId, Description__c, SKU__c, Is_advertisement__c, Image__c, Third_Party_Author__c, Author__r.Name, Content_Type__c,Featured__c, Published_Date__c, Story__c, Topic__c, Start_Date__c, End_Date__c, Third_Party_URL__c, Duration_in_Minutes__c, Event_Date_Time__c, Is_On_Demand__c, Moderators__c, Presenters__c, Visibility_ERP__c, Visibility_FRM__c, Visibility_Membership__c, Location__c from Content__c where Status__c = \'Active\' and Is_advertisement__c != true and Id in (select Content__c from Content_Folders__c where Folder__c = \'' + lstfolder[0].Id + '\') order by Published_Date__c DESC  limit :limitParam offset :offset');
                
            }            
                    
            if( lstDocs != null && lstDocs.size() > 0 ) {
            
                sfdcAppRemoter sr = new sfdcAppRemoter();        
                lstContentData = sr.filterContentDocs(lstDocs, null); 
                
            }
        }        
        return lstContentData;
    } 
    
    @RemoteAction
    public static List<contentData> getContentDocs(String name){
        
        List<Content__c> lstDocs;
        List<contentData> lstContentData = new List<contentData>();

        List<Folder__c> lstfolder = [Select Id from Folder__c where Name = :name];
        if( lstfolder != null && lstfolder.size() > 0 ) {
            lstDocs = [Select Id, Name, Content_Name__c, RecordTypeId, Description__c, SKU__c, Is_advertisement__c, Image__c, Third_Party_Author__c, Author__r.Name, Content_Type__c,Featured__c, Published_Date__c, Story__c, Topic__c, Start_Date__c, End_Date__c, Third_Party_URL__c, Duration_in_Minutes__c, Event_Date_Time__c, Is_On_Demand__c, Moderators__c, Presenters__c, Visibility_ERP__c, Visibility_FRM__c, Visibility_Membership__c, Location__c, Display_Sort_Order__c from Content__c where Status__c = 'Active' and Is_advertisement__c != true and Id in (select Content__c from Content_Folders__c where Folder__c = :lstfolder[0].Id) order by Display_Sort_Order__c];

            if( lstDocs != null && lstDocs.size() > 0 ) {
                
                sfdcAppRemoter sr = new sfdcAppRemoter();        
                lstContentData = sr.filterContentDocs(lstDocs, null); 
                
            }
        }        
        return lstContentData;
    } 

    @RemoteAction
    global static Boolean requestChapterDirector(String chapterId) {  
        
        String userId = UserInfo.getUserId();        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) {
        
            String contactId = lstUser[0].ContactId;
 
            system.debug('* * * contactId ...'+ contactId);
            
            List<Contact> lstContact = [SELECT Id, Name FROM Contact WHERE Id = :contactId];
            if( lstContact != null && lstContact.size() > 0 ) {
    
                List<Chapter_Member__c> lstchapterMember = [SELECT Id, Name, Chapter__c, Contact__c FROM Chapter_Member__c WHERE Chapter__c = :chapterId and Contact__c = :contactId];
                if( lstchapterMember != null && lstchapterMember.size() > 0 ) {             
                    lstchapterMember[0].put('Director_Application_Status__c','Upload');
                    update lstchapterMember[0];
                } else {
                    Chapter_Member__c cm = new Chapter_Member__c();
                    cm.Contact__c=contactId;
                    cm.chapter__c=chapterId;
                    cm.Director_Application_Status__c='Upload';
                    insert cm;
                }
            }
        }
        return true;
    }
    
    @RemoteAction
    global static Boolean setChapters(String chapId1, String chapId2) { 
        
        String userId = UserInfo.getUserId();        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) {
        
            String contactId = lstUser[0].ContactId;
 
            system.debug('* * * contactId ...'+ contactId);
            
            List<Contact> lstContact = [SELECT Id, Name FROM Contact WHERE Id = :contactId];
            if( lstContact != null && lstContact.size() > 0 ) {
                List<Chapter_Member__c> lstChapterMember = [select Id, Name, Director__c, Chapter__c, Can_Manage_Attendance__c, Can_Request_Meetings__c, Can_View_Resources__c, IsPrimary__c, IsSecondary__c from Chapter_Member__c where Contact__c = :contactId AND (IsPrimary__c = true OR IsSecondary__c = true)];
                boolean everFound1=false;
                boolean everFound2=false;
                
                boolean everFoundDirector=false;
                boolean everFoundView=false;
                boolean everFoundRequest=false;
                boolean everFoundAttendance=false;

                for(Chapter_Member__c cm: lstChapterMember) {
                    
                    String id = cm.Chapter__c;
                    boolean found1=false;
                    boolean found2=false;
                                        
                    if(id.compareTo(chapId1) == 0){
                        everFound1=found1=true;                        
                    } else if(id.compareTo(chapId2) == 0) {
                        everFound2=found2=true;
                    } else {
                        if(cm.Director__c != null && cm.Director__c==true)
                            everFoundDirector=true;
                        if(cm.Can_View_Resources__c != null && cm.Can_View_Resources__c==true)
                            everFoundView=true;
                        if(cm.Can_View_Resources__c != null && cm.Can_Manage_Attendance__c==true)
                            everFoundAttendance=true;
                        if(cm.Can_View_Resources__c != null && cm.Can_Request_Meetings__c==true)
                            everFoundRequest=true;                        
                    }
                    
                        
                    system.debug('* * * Loop ...'+id + ':' + chapId1 + ':' + chapId2 + ':');
                    system.debug('* * * Loop ...'+found1 + ':' + everFound1 + ':' + found2 + ':' + everFound2);
                    
                    if(!found1 && !found2) {
                        if(everFoundView || everFoundAttendance || everFoundRequest || everFoundDirector) {
                            cm.IsPrimary__c=false;
                            cm.IsSecondary__c=false;
                            update cm;
                        } else {
                            delete cm;     
                        }
                    }
                }
                
                system.debug('* * * Loop Done ...'+ everFound1 + ':' + everFound2);
                
                if(!everFound1 && chapId1.length() > 0){
                     Chapter_Member__c cm = new Chapter_Member__c();
                     cm.Contact__c=contactId;
                     cm.chapter__c=chapId1;
                     cm.IsPrimary__c=true;
                     insert cm;
                }
                if(!everFound2 && chapId2.length() > 0){
                     Chapter_Member__c cm = new Chapter_Member__c();
                     cm.Contact__c=contactId;
                     cm.chapter__c=chapId2;
                     cm.IsSecondary__c=true;
                     insert cm;
                }
            }
        }
        
        return true;
    }
    
    @RemoteAction
    global static List<Exam_Attempt__c> changeCycle(String contractId) {
    
        List<Exam_Attempt__c> EA = [SELECT Id, Name FROM Exam_Attempt__c where Id =  :contractId];
        List<Contract> lstContract = [Select Id, Name, RecordTypeId, StartDate, EndDate, Status from Contract where Id=:contractId];                      

        if( lstContract != null && lstContract.size() > 0 ) {
            Contract contract = lstContract[0];
            date startDate = contract.StartDate.addYears(1);
            contract.put('StartDate',startDate);
            update contract;
        }
        
        return EA;
    }
    
    @RemoteAction
    global static List<Exam_Attempt__c> getFRMData(String recordId) {
    
        List<Exam_Attempt__c> EA = [SELECT Id, Name FROM Exam_Attempt__c where Id =  :recordId];
    
        return EA;
    }
    
    @RemoteAction
    global static List<Account> getChapters() {
    
        id recordTypeId = RecordTypeHelper.GetRecordTypeId('Account','Chapter');
        List<Account> EA = [select Id, Name from Account where recordTypeId = :recordTypeId];
    
        return EA;
    }
    
    @RemoteAction
    global static List<AccountContactRole> getChapterMembers(String groupId) {
          
        List<AccountContactRole> ar = [select AccountId, ContactId, Id, IsPrimary, Role from AccountContactRole where Role = 'Chapter Member'];

        return ar;
    }
    
    @RemoteAction
    global static Boolean addRefData(String objectType, String Name) {

        

        List<RecordType> rtypes = [Select Name, Id From RecordType 
                  where sObjectType='Account' and isActive=true];

        Map<String,String> accountRecordTypes = new Map<String,String>{};
        for(RecordType rt: rtypes)
            accountRecordTypes.put(rt.Name,rt.Id);
            
        String recordTypeId = accountRecordTypes.get('Business');
        
        system.debug('* * * In addRefData ...'+Name);
        
        Account objNewAccount = new Account();
        objNewAccount.Name = 'Bob';
        objNewAccount.RecordTypeId = recordTypeId;
        insert objNewAccount;        
        
        return true;
    }

    @RemoteAction
    global static List<Account>  fetchAcademicInstitutions() {        
        Id AcademicRecordTypeId = RecordTypeHelper.GetRecordTypeId('Account','Academic Institution');
        
        List<Account> lstAcct = [select Id, Name from Account where recordTypeId = :AcademicRecordTypeId];
        
        return lstAcct;
    }
    
    @RemoteAction
    global static List<Account>  fetchCompanies() {
        List<Account> lstAccount = [Select Id, Name from Account where Customer_Company_List__c = true];
        return lstAccount;
    }
    
    public static Contact fetchContactData() {
        String userId = UserInfo.getUserId();        
    List<Contact> lstContact = new List<Contact>();
            
        getUserReturnData rd = new getUserReturnData ();
        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) {
        
            rd.userData = lstUser;        
            String contactId = lstUser[0].ContactId;
 
            lstContact = [SELECT Id, Name, FirstName, LastName, Email, GARP_Member_ID__c, MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet, AccountId, GARP_ID__c, Membership_Type__c, Name_As_it_Appears_On_ID__c, ID_Number__c, ID_Type__c, GARP_Directory_Opt_In__c FROM Contact WHERE Id = :contactId];
          
            if( lstContact != null && lstContact.size() > 0 ) {
        return lstContact[0];
            }
        } else {
            return null;
        }
        return null;
  }
            
    public static getUserReturnData fetchUserDataInside(String contactID) {
        return fetchUserDataInternal(contactID);
    }
    
    @RemoteAction
    public static getUserReturnData fetchUserData() {
        return fetchUserDataInternal(null);
    }
    
    public static getUserReturnData fetchUserDataInternal(String contactInputID) {

        getUserReturnData rd = new getUserReturnData ();
        String contactId = null;
        
        if(contactInputID != null) {
            rd.userData = null;
            contactId = contactInputID;
            List<User> lstUser = [Select u.Id,u.ContactId, FullPhotoUrl from User u where u.ContactId = :contactId];
            if( lstUser != null && lstUser.size() > 0 ) {
                rd.userData = lstUser;        
            }
            
        } else {

            String userId = UserInfo.getUserId();        
            List<User> lstUser = [Select u.Id,u.ContactId, FullPhotoUrl from User u where u.Id = :userId];
            if( lstUser != null && lstUser.size() > 0 ) {
                rd.userData = lstUser;        
                contactId = lstUser[0].ContactId;
            }
        }
 
        if(contactId != null) {
                        
            List<Contact> lstContact = [SELECT Id, Name, FirstName, LastName, Email, HomePhone, OtherPhone, GARP_Member_ID__c, Date_Joined__c, 
                                        MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet, Mailing_Address_Company__c, Account.BillingCountry,
                                        KPI_CPE_Current_Cycle__c,KPI_CPE_Last_Completed_Cycle__c,
                                        AccountId, GARP_ID__c, Membership_Type__c, Name_As_it_Appears_On_ID__c, Job_Function__c, Company__c, 
                                        ID_Number__c, ID_Type__c, GARP_Directory_Opt_In__c, KPI_Membership_Payment_Status__c, KPI_CPE_Requirement_Status__c,
                                        KPI_CPE_Participation__c, KPI_Chapter_Director__c,KPI_ERP_Candidate__c, KPI_ERP_Certified_Date__c, 
                                        KPI_Current_Exam_Registration__c, KPI_FRM_Candidate__c, KPI_FRM_Certified_Date__c, KPI_FRM_Certified_Year__c, KPI_ERP_Certified_Year__c,
                                        KPI_Last_Exam_Registration__c,KPI_Membership_Since__c, KPI_FRM_Certified__c, KPI_ERP_Certified__c,Professional_Designation_CA__c,Professional_Designation_CFA__c,
                                        Professional_Designation_CMA__c, Professional_Designation_CPA__c, Professional_Designation_PMP__c, Professional_Designation_ACCA__c,
                                        Professional_Designation_Other__c, Other_Qualifications__c, Area_of_Concentration__c, Corporate_Title__c, GARP_Directory_Invite_Opt_Out__c,
                                        GARP_Directory_Connect_Feature__c,GARP_Dir_Privacy_Additional_Detail__c,GARP_Dir_Privacy_Job_Information__c,GARP_Dir_Privacy_Prof_Background__c, Exam_Prep_Provider_Outreach__c,
                                        KPI_FRM_Resume_Certificate_Sent_Date__c, KPI_ERP_Resume_Certificate_Sent_Date__c, Years_of_Experience__c, Currently_in_School__c, Currently_Working__c,
                                        School_Name__c, Degree_Program_Name__c
                                        FROM Contact WHERE Id = :contactId];

            if( lstContact != null && lstContact.size() > 0 ) {

                rd.contactData = lstContact;
                String accountId = lstContact[0].AccountId;

                List<Account> lstAccount = [SELECT Id, Name, BillingCity, BillingCountry, BillingPostalCode, BillingState, BillingStreet, Billing_Address_Company__c, Phone  FROM Account where Id =  :accountId];
                
                if( lstAccount != null && lstAccount.size() > 0 ) {
                
                    rd.accountData = lstAccount;
                    
                    List<Experience__c> lstExperience = [SELECT Id, Name, Company__c, Type_of_Experience__c from Experience__c  where Contact__c = :contactId];
                    rd.experienceData = lstExperience;

                    List<Exam_Attempt__c> lstExamAttempt = [SELECT Id, Name, Icbrr_Exam_Date__c, CreatedDate, Cancelled__c, Candidate_Requirement__c, Opportunity__c, Section__c, Opportunity__r.StageName, Opportunity__r.CloseDate, Candidate_Commitment__c, Candidate_Commitment__r.EndDate, Candidate_Commitment__r.Opportunity__c, Candidate_Commitment__r.Opportunity__r.CloseDate, Candidate_Commitment__r.Status, hasViolation__c, Checked_In__c, Result__c, Defered__c, Exam_Site__r.Exam__r.Name, Exam_Site__r.Exam__r.Exam__c, Exam_Site__r.Exam_Date__c, Exam_Site__r.Exam__r.Exam_Date__c, Exam_Site__r.Exam__r.Exam_Group__c, Exam_Site__r.Exam__r.Exam_Group__r.Exam_Date__c, Exam_Site__r.Exam__r.Exam_Group__r.Exam_Ticket_Available_Date__c, Exam_Site__r.Exam__r.Exam_Group__r.Exam_Results_Available_Date__c, Exam_Site__r.Exam__r.Exam_Group__r.Active__c, Session__c, Member__r.GARP_ID__c, Member__r.name, Exam_Site__r.Site__r.Name, Exam_Site__r.Site__r.Site_Code__c, Exam_Site__r.Site__r.Display_Address__c, Room__r.name, Seat_No__c, Ticket_Download_Date__c,Registered_On__c FROM Exam_Attempt__c where Member__C =  :contactId and Cancelled__c != true];
                    
                    if( lstExamAttempt!= null && lstExamAttempt.size() > 0 ) {
                    
                        rd.examAttemptData = lstExamAttempt;

                        MAP<ID,ID> mapSites = new MAP<ID,ID>();
                        for(Exam_Attempt__c ea :lstExamAttempt) {
                            mapSites.put(ea.Exam_Site__r.Site__c,ea.Exam_Site__r.Site__c);
                        }

                        List<Venue__c> lstVenue = [select Id, Site__c, Name, Location_Special_Instructions__c, Institution_Name__c, Building_Name__c, Address1__c, Address2__c, City__c, State__c, Zipcode__c, Country__c, (SELECT Id, Name FROM Attachments) from Venue__c where Site__c in :mapSites.keyset() and Active__c = True];
                        rd.venueData = lstVenue;

                        List<Room__c> lstRoom = [select Id, Name, Venue__r.Id, Venue__r.Location_Special_Instructions__c, Venue__r.Building_Name__c, Venue__r.Address1__c, Venue__r.Address2__c, Venue__r.City__c, Venue__r.State__c, Venue__r.Zipcode__c, Venue__r.Country__c from Room__c where Id in (select room__c from Exam_Attempt__c where id in :lstExamAttempt) and Active__c = True];
                        rd.examRoomData = lstRoom;
                        
                        List<Exam_Result__c> lstResults = [select Id, Name, CreatedDate, Quartile__c, Exam_Registrations__c, Exam_Category__r.Name from Exam_Result__c where Exam_Registrations__c in :lstExamAttempt];
                        rd.examResultsData = lstResults;
                        
                    }
                    
                    List<Proctor_Registration__c> lstproctorRegistration = [select Id, Name, Status__c, Selected__c, Confirmed__c, Exam_Group__r.Name, Exam_Group__c, Test_Site__c, Box_Shipping_Address_1__c, Box_Shipping_Address_2__c, Box_Shipping_Address_3__c, Box_Shipping_City__c, Box_Shipping_Country__c, Box_Shipping_Postal_Code__c, Box_Shipping_State_Provence__c, Exam_Shipping_Address_1__c, Exam_Shipping_Address_2__c, Exam_Shipping_Address_3__c, Exam_Shipping_City__c, Exam_Shipping_Country__c, Exam_Shipping_Postal_Code__c, Exam_Shipping_State_Provence__c, Exam_Group__r.Active__c, Exam_Group__r.Exam_Date__c, Test_Site__r.Name, Test_Site__r.Display_Address__c, Type__c, Proctor_Type__c from Proctor_Registration__c where Contact__c = :contactId];
                    if( lstproctorRegistration != null && lstproctorRegistration.size() > 0 ) {
                        rd.proctorRegistrationData = lstproctorRegistration;
                        
                        List<Id> sites = new List<Id>();
                        for(Proctor_Registration__c pr : lstproctorRegistration) {
                            sites.add(pr.Test_Site__c);
                        }
                        
                        List<Venue__c> lstVenue = [select Id, Site__c, Name, Location_Special_Instructions__c, Institution_Name__c, Building_Name__c, Address1__c, Address2__c, City__c, State__c, Zipcode__c, Country__c, (SELECT Id, Name FROM Attachments) 
                                                   from Venue__c where Site__c in :sites];
                        rd.venueData = lstVenue;

                        List<Room__c> lstRoom = [select Id, Name, Venue__r.Id, Venue__r.Location_Special_Instructions__c, Venue__r.Building_Name__c, Venue__r.Address1__c, Venue__r.Address2__c, Venue__r.City__c, Venue__r.State__c, Venue__r.Zipcode__c, Venue__r.Country__c 
                                                 from Room__c where Venue__c in :lstVenue];
                        rd.examRoomData = lstRoom;
                        
                    }        
                    
                    List<Opportunity> lstOpportunity = [SELECT Id, Name, StageName, Amount, CreatedDate, Alternate_Method_of_Payment__c, Purchase_Date__c, LEGACY_Purchase_Date__c, Company__c, Shipping_First_Name__c, Shipping_Last_Name__c, Shipping_Street__c, Shipping_City__c, Shipping_State__c, Shipping_Postal_Code__c, Shipping_Country__c, Shipping_E_mail__c, Shipping_Phone_No__c, Shipping_Company_Name__c,  Display_Invoice_Number__c, Renew_Membership__c, ChargentSFA__Payment_Method__c, ChargentSFA__Payment_Received__c, ChargentSFA__Billing_First__c, ChargentSFA__Billing_Last__c, ChargentSFA__Billing_Phone__c, ChargentSFA__Billing_Email__c, ChargentSFA__Billing_Company__c, ChargentSFA__Billing_Address__c, ChargentSFA__Billing_City__c, ChargentSFA__Billing_State__c, ChargentSFA__Billing_Zip__c, ChargentSFA__Billing_Postcode__c, Switch_to_erp__c, Switch_to_frm__c, Event_Order__c, Purchase_Date_Time__c, (SELECT Id,Description,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice FROM OpportunityLineItems) FROM Opportunity where AccountId = :accountId and StageName != 'Recurring Intent' and StageName != 'Closed Lost'];
                     
                    if( lstOpportunity != null && lstOpportunity.size() > 0 ) {
                    
                        rd.opportunityData = lstOpportunity;
                        set<id> opportunityIds = new set<id>();
                        set<id> productIds = new set<id>();
                        for(Opportunity o :lstOpportunity){
                            opportunityIds.add(o.id); 
                            
                            for(OpportunityLineItem ol :o.OpportunityLineItems){
                                productIds.add(ol.PricebookEntryId);
                            }
                        }
                        List<PricebookEntry> lstPriceBookEntry = [SELECT Id, Name, Product2Id, ProductCode from PriceBookEntry where Id in :productIds];
                        
                        rd.priceBookEntryData = lstPriceBookEntry;
                        List<Id> prods = new List<Id>();
                        for(PricebookEntry pe : lstPriceBookEntry) {
                            prods.add(pe.Product2Id);
                        }
                                                
                        List<ChargentSFA__Payment_Request__c> lstPayRequest = [Select Id, Name, ChargentSFA__Opportunity__c, ChargentSFA__Pay_Link__c from ChargentSFA__Payment_Request__c where ChargentSFA__Opportunity__c in :opportunityIds];
                        rd.paymentRequestData = lstPayRequest;
                        
                        List<Product2> lstProducts = [select Id, Name, ProductCode, GL_Code__c, Description, Image__c from Product2 where Id in :prods];
                        rd.productData = lstProducts;
                        
                        List<ChargentSFA__Transaction__c> tres = [select Id, Name, ChargentSFA__Response_Message__c, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c from ChargentSFA__Transaction__c where ChargentSFA__Opportunity__c in :opportunityIds];
                        rd.transactionData = tres;
                        
                        rd.emailNoteData = [Select Id, ChargentSFA__Opportunity__c from ChargentSFA__Email_Notification__c where ChargentSFA__Opportunity__c in :opportunityIds];

                    }
                    
                    List<CPE_Claim__c> lstCanReq = [Select id,Name,EventTitle__c, Approved__c, Description__c, Credits_Earned__c,Date_of_Completion__c,ApprovedCredits__c,ApprovalComments__c, Candidate_Requirement__r.Candidate_Commitment__c, Candidate_Requirement__r.Name, Candidate_Requirement__r.Candidate_Commitment__r.AccountId from CPE_Claim__c where Candidate_Requirement__r.Candidate_Commitment__r.AccountId=:accountId];
                    
                    if( lstCanReq != null && lstCanReq.size() > 0 ) {                                                                            
                        rd.claimsData = lstCanReq;
                    }
                    
                    List<Contract> lstContract = [Select Id, Name, ContractNumber, RecordTypeId, StartDate, EndDate, ContractTerm, Membership_Type__c, Status, All_Requirements_Completed__c, All_Requirements_Completed_Date__c, Opportunity__c, Opportunity__r.StageName, ( SELECT id, name, Status__c, Date_of_Completion__c, Date_of_Ready_for_Review__c, Approved_Credits__c, Candidate_Commitment__c, Exam__c, RecordTypeID FROM Candidate_Requirements__r ) from Contract where AccountId=:accountId and Status != 'Canceled'];                        
                    if( lstContract != null && lstContract.size() > 0 ) {                                                                            
                        rd.contractData = lstContract;
                    }
                    
                    List<Candidate_Requirement__c> lstContractReq = [select Id, Name, Approved_Credits__c, Candidate_Commitment__c, Date_No_Two_Years__c, (SELECT Id,Name FROM Attachments) from Candidate_Requirement__c where Candidate_Commitment__c in :lstContract];
                    if( lstContractReq != null && lstContractReq.size() > 0 ) {                                                                             
                        rd.candidateRequirementData = lstContractReq; 
                    }
                    List<RecordType> rtypes = [Select Name, Id From RecordType 
                                               where sObjectType='Candidate_Requirement__c' and isActive=true];
                    
                    rd.candidateRequirementRecordTypes = rtypes;
                    
                    rtypes = [Select Name, Id From RecordType 
                              where sObjectType='Contract' and isActive=true];
                    
                    rd.contractRecordTypes = rtypes;
                    
                    List<CPE_Activity_Type__c> lstCPEActivity = [Select Id, Name, Organization_Label_Text__c, Provider_Label_Text__c, Publication_Label_Text__c, Title_Label_Text__c, Contact_Email_Label_Text__c from CPE_Activity_Type__c where Active__c = true];                        
                    if( lstCPEActivity != null && lstCPEActivity.size() > 0 ) {                                                                            
                        rd.activityTypeData = lstCPEActivity;
                    }
                    
                    rtypes = [Select Name, Id From RecordType 
                              where sObjectType='Account' and isActive=true];
                    
                    Map<String,String> accountRecordTypes = new Map<String,String>{};
                        for(RecordType rt: rtypes)
                        accountRecordTypes.put(rt.Name,rt.Id);
                    
                    String AcademicRecordTypeId = accountRecordTypes.get('Academic Institution');
                    String BusinessRecordTypeId = accountRecordTypes.get('Business');
                    
                    List<Account> lstCPEProviders = [SELECT Id, Name, RecordTypeId, (SELECT CPE_Activity_Type__c, Start_Date__c, End_Date__c FROM CPE_Provider_Activities__r) FROM Account where CPD_Provider__c=true];
                    rd.providerData = lstCPEProviders;                        
                    
                    
                    List<CollaborationGroup> lstCollaborationGroups = [select Id, Name from CollaborationGroup];
                    rd.collaborationGroupsData = lstCollaborationGroups;
                    
                    List<Chapter__c> lstChapters = [select Id, Name, Type__c from Chapter__c where Status__c = 'Active'];
                    rd.chaptersData = lstChapters;
                    
                    system.debug('* * * lstChapters: ' + lstChapters);
                    
                    List<Chapter_Member__c> lstChapterDirectors = [select Id, Name, CreatedDate, Director__c, Contact__r.Name, Contact__r.Email, Chapter_Director_Bio__c, Chapter__c from Chapter_Member__c where Director__c = true and Chapter__c in :lstChapters];
                    rd.chapterDirectorData = lstChapterDirectors;
                    
                    system.debug('* * * lstChapterDirectors: ' + lstChapterDirectors);
                    
                    List<Chapter_Member__c> lstChapterMember = [select Id, Name, IsPrimary__c, IsSecondary__c, CreatedDate, Director__c, Committee_Member__c, Can_Request_Meetings__c, Can_Manage_Attendance__c, Can_View_Resources__c, Chapter_Director_Bio__c, Chapter__c, Chapter__r.Name, Chapter__r.Location__c, Chapter__r.Status__c, Director_Application_Status__c, Chapter_Director_Agreement_Signed_Date__c, (SELECT Id,Name FROM Attachments) from Chapter_Member__c where Contact__c = :contactId];
                    rd.chapterMemberData = lstChapterMember;
                    
                    list<Id> lstMyChapters = new list<Id>();
                    
                    for (Chapter_Member__c  cm : lstChapterMember) {
                        if(cm.Chapter__r.Status__c == 'Active') {
                            lstMyChapters.add(cm.Chapter__c);
                        }
                    }
                    //and Chapter__c in :lstMyChapters
                    //
                    datetime myDateTime = datetime.now();
                    
                    List<Chapter_Meeting__c> lstChapterMeetings = [select Id, Name, Synopsis__c, Start__c, End__c, Time_Zone__r.Abbreviation__c, Time_Zone__r.Name, Status__c, Chapter__c, Chapter__r.Name, Chapter_Meeting_Location__r.Address_Street_1__c, Chapter_Meeting_Location__r.Address_Street_2__c, Chapter_Meeting_Location__r.Venue_Location__c, Chapter_Meeting_Location__r.Address_City__c, Chapter_Meeting_Location__r.Address_State_Provence__c , Chapter_Meeting_Location__r.Name, Chapter_Meeting_Location__r.Address_Postal_Code__c, Presentation__c, Ceremony__c, Group_Formation__c from Chapter_Meeting__c where Status__c = 'Active' and Start__c >= :myDateTime];
                    rd.chapterMeetingData = lstChapterMeetings;
                    //System.assert(false, 'BOOM!' + lstChapterMeetings);
                    
                    
                    List<Chapter_Meeting_Speaker__c> lstChapterMeetingSpeakers = [select Id, Name, Chapter_Meeting__c, Chapter_Speaker__r.Name, Chapter_Speaker__r.Qualifications__c, Chapter_Speaker__r.Biography__c, Chapter_Speaker__r.Contact__c from Chapter_Meeting_Speaker__c where Chapter_Meeting__c in :lstChapterMeetings];
                    rd.chapterMeetingSpeakerData = lstChapterMeetingSpeakers;
                    
                    Date now = date.today();
                    
                    List<Board_Election__c> lstElection = [select Id, Name from Board_Election__c where Start_Date__c <= :now and End_Date__c >= :now];
                    
                    if( lstElection != null && lstElection.size() > 0 ) {       
                        rd.boardElectionData = lstElection[0];
                    }
                    
                    List<RecordType> lstRecordTypes = [select Id, sobjectType, Name, DeveloperName from RecordType where sobjectType = 'Content__c'];
                    if( lstRecordTypes != null && lstRecordTypes.size() > 0 ) {       
                        rd.contentRecordTypeData = lstRecordTypes;
                    }                        
          
                    List<Exam_Group__c> lstexamGroup = [select Id, Name, Active__c, Exam_Date__c, Exam_Ticket_Available_Date__c, Proctor_Website_Open_Date__c, Registration_Start_Date__c, Last_Date_For_Late_Registration__c, Last_Date_For_ADA__c, Last_Date_For_Scholarship__c, Religious_Alternative_Last_Date__c, Last_Date_For_Location_Change__c, Last_Date_To_Apply_For_Deferral__c, Weekly_Study_Plan_Start_Date__c from Exam_Group__c where Active__c = true];
                    if( lstexamGroup != null && lstexamGroup.size() > 0 ) {
                        rd.examGroupData = lstexamGroup;
                        
                        List<Exam__c> lstexams = [select Id, Name from Exam__c where Exam_Group__c in :lstexamGroup];
                        if( lstexams != null && lstexams.size() > 0 ) {
                            
                            List<Exam_Sites__c> lstexamSites = [select Id, Name from Exam_Sites__c where Exam__c in :lstexams];
                            if( lstexamSites != null && lstexamSites.size() > 0 ) {
                                rd.examSitesData = lstexamSites;
                            }
                            
                        }
                        
                    }
                   
                    
                }        
            }
        } 
        return rd;        
        
    }
     
    @RemoteAction
    global static Boolean deleteFormData(String objectType, String recordId) {
    
        sObject s;
        s = Database.query('SELECT Id FROM ' + objectType + ' WHERE Id = :recordId');
        delete s;
        
        return true;
    
    }

    @RemoteAction
    global static Boolean saveFormData(String objectType, String recordId, List<fieldInfo> fields) {

        String query;
        Integer cnt=0;
        for (fieldInfo field : fields) {
            System.debug('field name is ' + field.name);  
            System.debug('field value is ' + field.value);
            System.debug('refValue is ' + field.refValue);
            if(cnt == 0) {
                query = field.name;
            } else {
                query = query + ',' + field.name;
            }     
            cnt++;
        }
        
        sObject s;
        if(String.isEmpty(recordId)) {
        
            Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectType);
            s =  targetType.newSObject();
            
        } else {
                    
            s = Database.query('SELECT ' + query + ' FROM ' + objectType + ' WHERE Id = :recordId');
        }

        for (fieldInfo field : fields) {
            System.debug('field name is ' + field.name);  
            System.debug('field value is ' + field.value);
            
            if(field.value == null || field.readOnly == true) {
                continue;
            }
            
            System.debug('field type is ' + field.type);
            
            if(field.type.toLowerCase().compareTo('boolean')== 0) {
            
                if(field.value != null) {     
                    if(field.value.toLowerCase().compareTo('true')== 0) {
                        s.put(field.name, true);  
                    } else {
                        s.put(field.name, false);  
                    }
                } else {
                    s.put(field.name, false);  
                }
            } else if(field.type.toLowerCase().compareTo('double')== 0) {
                
                if(!String.isEmpty(field.value)) {
                    s.put(field.name, decimal.valueOf(field.value));
                }
                
            } else if(field.type.toLowerCase().compareTo('currency')== 0) {
                
                if(!String.isEmpty(field.value)) {
                    s.put(field.name, decimal.valueOf(field.value));
                }
                
            } else if(field.type.toLowerCase().compareTo('reference')== 0) {
                String refVal = field.refValue;
                
                System.debug('reference ' + refVal);
                
                String refOtherField = field.refOtherField;
                System.debug('reference other ' + refOtherField);
                
                //System.assert(false, 'BOOM!' + eventRecordTypeId);
                System.debug('refOtherField ' + refOtherField);
                
                if(!String.isEmpty(refVal)) {
                    s.put(field.name, refVal);
                    if(!String.isEmpty(refOtherField)) {
                        s.put(refOtherField, null);
                    }                    
                } else {    
                    if(!String.isEmpty(refOtherField)) {
                        s.put(refOtherField, field.value);
                    }
                    s.put(field.name, null);
                }
            } else if(field.type.toLowerCase().compareTo('date')== 0) {
                
                //datetime setDate = datetime.newInstance(field.epochValue);
                //Date myDate = date.newinstance(setDate.year(), setDate.month(), setDate.day());                
                Date myDate = Date.parse(field.Value); 
                s.put(field.name, myDate);
                
            } else if(field.type.toLowerCase().compareTo('datetime')== 0 ) {                
    
                datetime setDate = datetime.newInstance(field.epochValue);                
                s.put(field.name, setDate);
                
            } else {
                s.put(field.name, field.value);  
            }
        }

        if(String.isEmpty(recordId)) {
            insert s;
        } else {
            update s;
        }        
        
        return true;
    }
    
    @RemoteAction
    global static returnData fetchFormList(String objectType, String parentField, String parentId, List<String> fields) {

        returnData rd = new returnData();
        Schema.DescribeSObjectResult DR_SObject;
        Map<String, Schema.sObjectField> mapToken_Fields;
        Map<String, Schema.sObjectType> mapToken_SObjects;
        
        Map<string,fieldInfo > resultObject = new Map<String,fieldInfo >();    
        mapToken_SObjects = Schema.getGlobalDescribe();
        
        DR_SObject = mapToken_SObjects.get(objectType).getDescribe();
        
        mapToken_Fields = DR_SObject.fields.getMap();
        
        System.debug('fields ' + DR_SObject.fields);
        
        String userId = UserInfo.getUserId();        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) {

            String contactId = lstUser[0].ContactId;
            String query;
            Integer cnt=0;
            for (String field : fields) {
                if(cnt == 0) {
                    query = field;
                } else {
                    query = query + ',' + field;
                }     
                cnt++;
            }        
            
            String fname;
            for (String fieldName : mapToken_Fields.keySet()){
                System.debug('field name is ' + fieldName);   
                
                Integer found=0;
                for (String field : fields) {
                    
                    if(field.toLowerCase().compareTo(fieldName.toLowerCase()) == 0) {
                        found = 1;
                    }
                }
                
                if(found == 0) {
                    continue;
                }
                
                fname = fieldName;
                
                Schema.DescribeFieldResult dfr = mapToken_Fields.get(fieldName).getDescribe();
                System.debug(dfr.getName() + ' >> ' + dfr.getLabel());    
                
                fieldInfo fd = new fieldInfo();
                fd.name = dfr.getName();
                fd.label = dfr.getLabel(); 
                fd.type = String.valueOf(dfr.getType()); 
                
                fd.maxLength = dfr.getLength();
                fd.isCalculated = dfr.isCalculated();
                fd.isNillable = dfr.isNillable();
                fd.description = dfr.getInlineHelpText();
                
                List<String> lstPickvals=new List<String>();
                
                List<Schema.PicklistEntry>pick_list_values = dfr.getPickListValues();
                for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
                    lstPickvals.add(a.getValue());//add the value  to our final list
                }             
                
                fd.pickList = lstPickvals;
                
                resultObject.put(dfr.getName(), fd);     
                
            }   
            List<sObject> L;
            if(parentId == null || parentId.length() == 0) { 
                L = Database.query('SELECT ' + query + ' FROM ' + objectType + ' WHERE ' + parentField + ' = :contactId');    
            } else {
                L = Database.query('SELECT ' + query + ' FROM ' + objectType + ' WHERE ' + parentField + ' = :parentId');
            }
            
            system.debug('* * * Query fetchFormData Remoter ...'+query);            
            rd.recordData  = L;
            rd.fields= resultObject;
        }
        
        return rd;
    }
    
    @RemoteAction
    global static returnData fetchFormData(String objectType, String recordId, List<String> fields) {
    
        Schema.DescribeSObjectResult DR_SObject;
        Map<String, Schema.sObjectField> mapToken_Fields;
        Map<String, Schema.sObjectType> mapToken_SObjects;
        
        Map<string,fieldInfo > resultObject = new Map<String,fieldInfo >();    
        mapToken_SObjects = Schema.getGlobalDescribe();
        
        DR_SObject = mapToken_SObjects.get(objectType).getDescribe();
        
        mapToken_Fields = DR_SObject.fields.getMap();
        
        System.debug('fields ' + DR_SObject.fields);
        
        String query;
        Integer cnt=0;
        for (String field : fields) {
            if(cnt == 0) {
                query = field;
            } else {
                query = query + ',' + field;
            }     
            cnt++;
        }        
        
        String fname;
        for (String fieldName : mapToken_Fields.keySet()){
             //System.debug('field name is ' + fieldName);   
             
             Integer found=0;
             for (String field : fields) {
                 
                 if(field.toLowerCase().compareTo(fieldName.toLowerCase()) == 0) {
                     found = 1;
                 }
             }
                 
             if(found == 0) {
                 continue;
             }
                       
             fname = fieldName;
             
             Schema.DescribeFieldResult dfr = mapToken_Fields.get(fieldName).getDescribe();
             //System.debug(dfr.getName() + ' >> ' + dfr.getLabel());    
            
             fieldInfo fd = new fieldInfo();
             fd.name = dfr.getName();
             fd.label = dfr.getLabel(); 
             fd.type = String.valueOf(dfr.getType()); 
             
             fd.maxLength = dfr.getLength();
             fd.isCalculated = dfr.isCalculated();
             fd.isNillable = dfr.isNillable();
             fd.description = dfr.getInlineHelpText();
            
             List<String> lstPickvals=new List<String>();
             
             List<Schema.PicklistEntry>pick_list_values = dfr.getPickListValues();
             for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
                  lstPickvals.add(a.getValue());//add the value  to our final list
             }             
                         
             fd.pickList = lstPickvals;
             
             resultObject.put(dfr.getName(), fd);     

        }    
                    
        List<sObject> L = Database.query('SELECT Id, ' + query + ' FROM ' + objectType + ' WHERE Id = :recordId');
        system.debug('* * * Query fetchFormData Remoter ...'+query);
                
        returnData rd = new returnData();
        
        rd.recordData  = L;
        rd.fields= resultObject;
        
        return rd;
    }

    @RemoteAction
    public static String uploadAttachment(String filename, String fileData, Id record) {
        String user = UserInfo.getUserID();

        if(fileData==null)
            return String.valueOf('Invalid file data.');

        String base64 = fileData.substring(fileData.indexOf(',')+1);
        Blob actualdata = EncodingUtil.base64Decode(base64);

        if(actualdata.size()<=0)
            return String.valueOf('File size cannot be greater then 10MB.');

        Attachment att = new Attachment(ParentId=record, Body=actualdata);
        att.Name = filename;
        insert(att);

        return String.valueOf('Upload Successful!');
    }
    
    @RemoteAction
    public static void updateSite(Id examAttemptID, Id examSiteID) {
        PortalClass.updateExamSite(examAttemptID,examSiteID);
    }

}
