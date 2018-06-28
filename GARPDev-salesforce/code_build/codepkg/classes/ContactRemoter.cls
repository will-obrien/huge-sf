global without sharing class ContactRemoter {
      
    public String accountName { get; set; }
    public static Account account { get; set; }
    public String Examattemptid {get; set;}
    
 public class productList {
    public String GLCode { get; set; }
    public String price { get; set; }
    public String prodCode { get; set; }
    public String description { get; set; }
}
  
  public class searchResults {
        public List<Contact> lstContact { get; set; }
        public Integer pages  { get; set; }
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
        public boolean bFRM1UnDeffered{get;set;}
        public boolean bFRM2UnDeffered{get;set;}
        public boolean bERPUnDeffered{get;set;}
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
  

 

    public class getUserReturnData {
        public List<User> userData { get; set; }
        public List<Contact> contactData { get; set; }
        public List<Account> accountData { get; set; }
        public List<Opportunity> opportunityData { get; set; }
        public List<Exam_Attempt__c> examAttemptData { get; set; }
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
    
    public class productsAndQuantities {
        public string productcode {get;set;}
        public integer quantity {get;set;}
    }
   
   public class tempOrder {
        public decimal TotalPrice {get;set;}
        public string Name {get;set;}
        public string MailingStreet {get;set;}
        public string MailingCountry {get;set;}
        public string MailingState {get;set;}
        public string MailingCity {get;set;}
        public string MailingPostalCode {get;set;}
        public string email {get;set;}
        public list<string> productcodes {get;set;}
     public decimal tax {get; set;}
     public string ups {get; set;}
    }
       
    @RemoteAction
     public static string Deferred(String Examattemptid,String strProdCode,String strGlCode){
        //return PortalClass.checkExamAttempts(Examattemptid,strProdCode,strGlCode);
        return '';
      } 
      
    @RemoteAction
     public static set<String> getAccountName(){
        return PortalClass.getAccountName();    
      } 
       
    @RemoteAction
     public static id getParentId(){
        return PortalClass.getParentId();    
      } 
      
    //@RemoteAction
    //public static List<Exam_Attempt__c> getFRMData(String recordId) {
    //    List<Exam_Attempt__c> EA = [SELECT Id, Name FROM Exam_Attempt__c where Id =  :recordId];
    //    return EA;
    //}
      
   @RemoteAction
    public static boolean GetMember(TempAccount userData){
        return Registration.GetMember(userData);
       
        }   
  @RemoteAction
    public static Id SetLead(TempAccount userData){
        ID lld = Registration.SetLead(userData);
        return lld;
        }
  
  //@RemoteAction
  //  public static id CreateOrder(TempAccount userData){
  //      ID lld= Registration.CreateOrder(userData);
  //      return lld;
  //     }
  @RemoteAction
    public static set<String> getActiveSites(){
        return Registration.getActiveSites();   
      }
  
  @RemoteAction
     public static Decimal getProduct(String productcode){
        return Registration.getPrice(productcode);
      }
  
  @RemoteAction
     public static Date Registrationdate(){
        return Registration.registrationDate();
      }
   
  @RemoteAction
     public static Date testDate(){
        return Registration.testDate();
      }
      
  //@RemoteAction
  //   public static id createOrdersForPortalUsers(TempAccount userData){
  //      return Registration.createOrderForPortalUsers(userData);
  //    } 
         
  @RemoteAction
     public static Map < String, Registration.wrapperProductInfo > getProductCodes(){
       return  Registration.getProductCodes();
      }
  @RemoteAction
     public static string getUnDefferedExams(id eaID,String strProdCode,String strGlCode){
        //return PortalClass.unDeferrExamAttempts(eaID,strProdCode,strGlCode);
       return '';
     }
  @RemoteAction
     public static List<wrapperUtils.wrapperProductInfo> getSwitchDetails(){
        return SwitchLayer.swithcLogic();
        }
        

        
   
    @RemoteAction
    public static ChargentSFA__Payment_Request__c createcontractextension(String strProductCode){
        return PortalClass.extendMembership(strProductCode);
    }
        
 
      
   @RemoteAction
   public static Map<String,Registration.wrapperProductInfo> getExamProducts(String strExamName){
     return Registration.getProductCodes1(strExamName);
   }
  
    
   @RemoteAction
     public static LIST<PricebookEntry>  getStoreProducts() {
    LIST<PricebookEntry>  pb = [SELECT UnitPrice, ProductCode, Name FROM PricebookEntry];
        return pb;
    }
    
   @RemoteAction
   public static LIST<Product2>  getStoreDescriptions() {
    LIST<Product2>  products = [SELECT Action__c, IsActive, Bookstore__c, CreatedById, CreatedDate, CurrencyIsoCode, IsDeleted, ERP_Study_Center__c, FRM_Study_Center__c, GL_Code__c, Image__c, GARP_Category__c, Garp_Product_Type__c, Program_Name__c, Program_Type__c, Requirement_Name__c, Scheduled_Date__c, VersionNo__c, hasProgram__c,LastModifiedById, LastModifiedDate,ProductCode, Description, Family, Product_ID__c, Id, Name, Weight__c, Test__c, SystemModstamp,(SELECT UnitPrice FROM PricebookEntries WHERE UnitPrice > 0 AND isActive = true) FROM Product2 WHERE Bookstore__c = true AND isActive=true AND Book_for_everybody__c = true];
        return products;
    }
    
    @RemoteAction
   public static LIST<Product2>  getStoreForFrm() {
    LIST<Product2>  products = [SELECT Action__c, IsActive, Bookstore__c, CreatedById, CreatedDate, CurrencyIsoCode, IsDeleted, ERP_Study_Center__c, FRM_Study_Center__c, GL_Code__c, Image__c, GARP_Category__c, Garp_Product_Type__c, Program_Name__c, Program_Type__c, Requirement_Name__c, Scheduled_Date__c, VersionNo__c, hasProgram__c,LastModifiedById, LastModifiedDate,ProductCode, Description, Family, Product_ID__c, Id, Name, Weight__c, Test__c, SystemModstamp,(SELECT UnitPrice FROM PricebookEntries WHERE UnitPrice > 0 AND isActive = true) FROM Product2 WHERE (Book_for_everybody__c = true AND Bookstore__c = true AND isActive=true)];
        return products;
    }
    
    @RemoteAction
   public static LIST<Product2>  getStoreForErp() {
    LIST<Product2>  products = [SELECT Action__c, IsActive, Bookstore__c, CreatedById, CreatedDate, CurrencyIsoCode, IsDeleted, ERP_Study_Center__c, FRM_Study_Center__c, GL_Code__c, Image__c, GARP_Category__c, Garp_Product_Type__c, Program_Name__c, Program_Type__c, Requirement_Name__c, Scheduled_Date__c, VersionNo__c, hasProgram__c, LastModifiedById, LastModifiedDate,ProductCode, Description, Family, Product_ID__c, Id, Name, Weight__c, Test__c, SystemModstamp,(SELECT UnitPrice FROM PricebookEntries WHERE UnitPrice > 0 AND isActive = true) FROM Product2 WHERE (Book_for_everybody__c = true AND Bookstore__c = true AND isActive=true)];
        return products;
    }


 
    @RemoteAction
    public static List<Contact> getFRMCandidate () {
         String currentUserId = UserInfo.getUserId();
         User activeUser = [SELECT Email FROM User WHERE Id = :currentUserId LIMIT 1];
         String userEmail = activeUser.Email;
         return [SELECT KPI_FRM_Candidate__c FROM Contact WHERE Contact.Email = :activeUser.Email];

    }
    @RemoteAction
    public static List<Contact> getERPCandidate () {
         String currentUserId = UserInfo.getUserId();
         User activeUser = [SELECT Email FROM User WHERE Id = :currentUserId LIMIT 1];
         String userEmail = activeUser.Email;
         return [SELECT KPI_ERP_Candidate__c FROM Contact WHERE Contact.Email = :activeUser.Email];

    }
   @RemoteAction
     public static set<String> getActiveExamsWithContracts(){
        return PortalClass.getActiveExams();
   } 
   @RemoteAction
     public static List<wrapperUtils.upsWrapper> getUPSPrice(string strAddress1,string strAddress2,string strCity,string strCountry,string strStateCode,string strZip,List<String> lstProdCodes) {         
         
            system.debug('* * * getUPSPrice ...'+ lstProdCodes);
         
           return UPSServices.getUPSPrice(strAddress1,strAddress2,strCity,strCountry,strStateCode,strZip, lstProdCodes);
       }
      
  @RemoteAction
     public static decimal taxCalculation() {       
            return 0.007;
        }
        
  @RemoteAction
     public static void autoRenewOff(boolean bAutoOff) {          
           MemberShipAutoRenew.autoRenewOff(bAutoOff);
        }
        
  @RemoteAction
     public static ChargentSFA__Payment_Request__c  autoRenew(boolean bIsCurrentDay,string strProductCode) {       
           return MemberShipAutoRenew.autorenew(bIsCurrentDay,strProductCode);
        }
     
  @RemoteAction
     public static wrapperProductInfo getDefferedExams(){
        PortalClass.getDefferedExams();
        wrapperProductInfo obj = new wrapperProductInfo();
        obj.bFRM1Deffered  = PortalClass.bFRM1Deffered;
        obj.bFRM2Deffered  = PortalClass.bFRM2Deffered;
        obj.bERPDeffered  = PortalClass.bERPDeffered;
        obj.bFRM1UnDeffered  = PortalClass.bFRM1UnDeffered;
        obj.bFRM2UnDeffered  = PortalClass.bFRM2UnDeffered;
        obj.bERPUnDeffered  = PortalClass.bERPUnDeffered;
        obj.bFRMSwitch= PortalClass.bFRMCanSwitch;
        obj.bERPSwitch= PortalClass.bERPCanSwitch;
        return obj;
     } 
    @RemoteAction
    global static void sendContactUs(string fromAddress, string[] toContact, string msgBody){
        Messaging.reserveSingleEmailCapacity(2);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] ccAddresses = new String[] {'duane.robinson@garp.com'};
        mail.setToAddresses(toContact);
        mail.setCcAddresses(ccAddresses);
        mail.setReplyTo('support@garp.com');
        mail.setSenderDisplayName('Salesforce Support');
        mail.setSubject('From Contact Us on Website');
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setPlainTextBody(msgBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
  @RemoteAction
     public static List<String> getContactDetails()
        {
           return PortalClass.getContactDetails();  
        }
        
  @RemoteAction
     public static List<SObject> getChapters() {
            String query = 'SELECT Active__c, Name, CreatedById, CreatedDate, CurrencyIsoCode, IsDeleted, LastActivityDate, LastModifiedById, LastModifiedDate, Location__c, OwnerId, Id, Status__c, SystemModstamp, Type__c, Region__c, (SELECT Contact__c,Name,Chapter_Director_Bio__c,Associate_Director__c,Director__c FROM Chapter_Members__r) FROM Chapter__c WHERE Active__c = true';
            List<SObject> result = database.query(query);
            return result;
        }
  @RemoteAction
  public static ID createStoreOrder(TempOrder data)

        {
              decimal dShipPrice = 0;
              String strUPSDesc = '';
            Contact con = new Contact();
            Account acc = new Account();
            Decimal dExamFee = 0;
            List<String> setProductCodes = new List<String>();
            Map<String,Integer> mapProdCount = new Map<String,Integer>();
            for(String str : data.productcodes)
            {
                if(mapProdCount.containsKey(str))
                    mapProdCount.put(str,mapProdCount.get(str) + 1);
                else
                    mapProdCount.put(str,1);
            }
            Integer iCount = (Data.productcodes == null ? 0 : Data.productcodes.size());
            setProductCodes.addAll(Data.productcodes);
            acc.Name = data.Name;
            insert acc;
            con.LastName = data.Name.split(' ')[1];
            con.FirstName = data.Name.split(' ')[0];
            con.MailingStreet = data.MailingStreet;
            con.MailingCountry = data.MailingCountry;
            con.MailingState = data.MailingState;
            con.MailingPostalCode = data.MailingPostalCode;
            con.MailingCity = data.MailingCity;
            insert con;
            opportunity opp = new opportunity();
            opp.accountId = con.Accountid;
            opp.Name = acc.Name;
            opp.StageName = 'New From Store';
            opp.CloseDate = system.today();
            insert opp;
            if(Data.tax != null)
            {
                setProductCodes.add('SLSTX');
            }

            if(dShipPrice != 0)
            {
                setProductCodes.add('SHIP');
                OpportunityLineItem oppLineItem = new OpportunityLineItem();
                oppLineItem.OpportunityId = 'SHIP';
                
            }
             List<OpportunityLineItem> lstOppLineItems = new List<OpportunityLineItem>();
            for(PriceBookEntry PricebookEntryId : [select unitprice,productcode from PriceBookEntry where Pricebook2.IsActive = true and productcode in: setProductCodes and isActive = true]) 
            { decimal dTaxPrice = 0;
                   
             dExamFee = 0;
             OpportunityLineItem oppLineItem = new OpportunityLineItem();
                oppLineItem.OpportunityId = opp.id;
                oppLineItem.PricebookEntryId = PricebookEntryId.Id;
                oppLineItem.Quantity = mapProdCount.get(PricebookEntryId.productcode);
                 oppLineItem.UnitPrice = dExamFee;
                  if (PriceBookEntryId.productcode == 'SHIP'){
                     oppLineItem.UnitPrice = dShipPrice;
                 }
                    if (PriceBookEntryId.productcode == 'SLSTX'){
                     oppLineItem.UnitPrice = data.tax;
                 }
               dExamFee = PricebookEntryId.unitprice;
                
            system.debug(setproductcodes);
            lstOppLineItems.add(oppLineItem);
              
            }
            
           
            insert lstOppLineItems;
            
            ChargentSFA__Payment_Request__c objPayment = new ChargentSFA__Payment_Request__c();
            objPayment.ChargentSFA__Opportunity__c = opp.ID;
            objPayment.ChargentSFA__Status__c = 'Manually Sent';
            objpayment.ChargentSFA__Billing_Contact__c= con.Id;
            insert objPayment;
            return objPayment.Id;
        
        }
    @RemoteAction
  public static ID createStoreOrderPortal(TempOrder data)

        {
              decimal dShipPrice = 0;
              String strUPSDesc = '';
            Id currentUSer = userInfo.getuserId();
            User objUSer = [select id,Email,contactId from user where id =: currentUSer];
            Contact con = [select id,Name,Accountid,MailingCity,ID_Number__c, ID_Type__c,Name_As_it_Appears_On_ID__c,MailingCountry,MailingPostalCode,MailingState,MailingStreet from contact where id =: objUSer.contactId];
            Decimal dExamFee = 0;
            List<String> setProductCodes = new List<String>();
            Map<String,Integer> mapProdCount = new Map<String,Integer>();
            for(String str : data.productcodes)
            {
                if(mapProdCount.containsKey(str))
                    mapProdCount.put(str,mapProdCount.get(str) + 1);
                else
                    mapProdCount.put(str,1);
            }
            Integer iCount = (Data.productcodes == null ? 0 : Data.productcodes.size());
            setProductCodes.addAll(Data.productcodes);
            opportunity opp = new opportunity();
            opp.accountId = con.Accountid;
            opp.Name = con.Name;
            opp.StageName = 'New From Store';
            opp.CloseDate = system.today();
            opp.Has_Books__c = true;
            insert opp;
            if(data.ups != '' && data.ups != null)
            {
                    String[] arrShippingInfo = data.ups.split(',');
                    if(arrShippingInfo != null && arrShippingInfo.size() > 0)
                    {
                        String[] arrPriceInfo = arrShippingInfo[0].split(':');
                        dShipPrice = decimal.valueOf(arrPriceInfo[1]);
                        String[] arrUPSDesc = arrShippingInfo[1].split(':');
                        strUPSDesc = arrUPSDesc[1];
                        strUPSDesc = strUPSDesc.replace('"','').replace('{','').replace('}','');
                    }
            }
            decimal dTaxPrice = 0;
            if(Data.tax != null)
            {
                dTaxPrice = Data.tax;
            }
             List<OpportunityLineItem> lstOppLineItems = new List<OpportunityLineItem>();
            for(PriceBookEntry PricebookEntryId : [select unitprice,productcode from PriceBookEntry where Pricebook2.IsActive = true and productcode in: setProductCodes and isActive = true]) 
            {
             
             OpportunityLineItem oppLineItem = new OpportunityLineItem();
                oppLineItem.OpportunityId = opp.id;
                oppLineItem.PricebookEntryId = PricebookEntryId.Id;
                oppLineItem.Quantity = mapProdCount.get(PricebookEntryId.productcode);
                 oppLineItem.UnitPrice = PriceBookEntryId.unitprice;
                 if (PriceBookEntryId.productcode == 'SHIP'){
                     oppLineItem.UnitPrice = dShipPrice;
                 }
                 if (PriceBookEntryId.productcode == 'SLSTX'){
                     oppLineItem.UnitPrice = dTaxPrice;
                 }
               dExamFee = PricebookEntryId.unitprice;
                
            system.debug(setproductcodes);
            lstOppLineItems.add(oppLineItem);
              
            }
            
            insert lstOppLineItems;
            
            ChargentSFA__Payment_Request__c objPayment = new ChargentSFA__Payment_Request__c();
            objPayment.ChargentSFA__Opportunity__c = opp.ID;
            objPayment.ChargentSFA__Status__c = 'Manually Sent';
            objpayment.ChargentSFA__Billing_Contact__c= con.Id;
            insert objPayment;
            return objPayment.Id;
        
        }
        
    @RemoteAction
      public static searchResults findOne(String garpID){
        String query = 'SELECT Id, Name, Email, MailingCity, MailingState, MailingPostalCode, MailingCountry, AccountId, GARP_ID__c, Membership_Type__c, Area_of_Concentration__c, GARP_Directory_Opt_In__c, GARP_Directory_Invite_Opt_Out__c, GARP_Dir_Privacy_Additional_Detail__c, GARP_Dir_Privacy_Job_Information__c, GARP_Dir_Privacy_Prof_Background__c, GARP_Directory_Connect_Feature__c, KPI_FRM_Certified__c, KPI_FRM_Certified_Year__c, KPI_ERP_Certified__c, KPI_ERP_Certified_Year__c, KPI_Membership_Since__c, KPI_CPE_Requirement_Status__c, Professional_Designation_CA__c, Professional_Designation_CFA__c, Professional_Designation_CMA__c, Professional_Designation_CPA__c, Professional_Designation_Other__c, Professional_Designation_PMP__c, Professional_Designation_ACCA__c, Company_Type__c, Corporate_Title__c, Company__c FROM Contact';
        String whereClause = 'WHERE GARP_ID__c =' + ':garpID'; 
        String querystr = query + ' ' + whereClause;
        List<Contact> lstContact = database.query(querystr); 
        List<Contact> returnListContact = new List<Contact>();
        system.debug('querystr>>>'+querystr);
       system.debug('garpID>>>'+garpID);
        if(lstContact.size() > 1) {
            Integer count = 1;
            Integer page = 1;
            for(Contact con :lstContact){
                if(page == 1) {
                    returnListContact.add(con);
                }
                count++;
                if(count >1) {
                    count=1;
                    page++;
                }
            }
        } 
        else {
            returnListContact = lstContact;
        }
        Decimal myDecimal = lstContact.size();
        Decimal divDec = myDecimal.divide(1, 0, System.RoundingMode.UP); 
        searchResults results = new searchResults();
        results.lstContact = returnListContact;
        results.pages = divDec.intValue();
        return results;
    }       
       
  @RemoteAction
     public static searchResults searchDirectory(String searchText, String searchType, String sortField, String sortOrder, Integer pageSize, Integer pageCurrent){
        String likeClause = '%'+searchText+'%';
        String query = 'SELECT Id, Name, Email, MailingCity, MailingState, MailingPostalCode, MailingCountry, AccountId, GARP_ID__c, Membership_Type__c, Area_of_Concentration__c, GARP_Directory_Opt_In__c, GARP_Directory_Invite_Opt_Out__c, GARP_Dir_Privacy_Additional_Detail__c, GARP_Dir_Privacy_Job_Information__c, GARP_Dir_Privacy_Prof_Background__c, GARP_Directory_Connect_Feature__c, KPI_FRM_Certified__c, KPI_FRM_Certified_Year__c, KPI_ERP_Certified__c, KPI_ERP_Certified_Year__c, KPI_Membership_Since__c, KPI_CPE_Requirement_Status__c, Professional_Designation_CA__c, Professional_Designation_CFA__c, Professional_Designation_CMA__c, Professional_Designation_CPA__c, Professional_Designation_Other__c, Professional_Designation_PMP__c, Professional_Designation_ACCA__c, Company_Type__c, Corporate_Title__c, Company__c FROM Contact';
        String whereClause = 'WHERE GARP_Directory_Opt_In__c = true and (KPI_FRM_Certified__c = true or KPI_ERP_Certified__c = true) and ' + searchType + ' like :likeClause'; 
        String sortClause = 'ORDER BY ' + sortField + ' ' + sortOrder + ' NULLS LAST';
        String querystr = query + ' ' + whereClause + ' ' + sortClause;
        if(test.isRunningTest())
        querystr = 'SELECT Id, Name, Email, MailingCity, MailingState, MailingPostalCode, MailingCountry, AccountId, GARP_ID__c, Membership_Type__c, Area_of_Concentration__c, GARP_Directory_Opt_In__c, GARP_Directory_Invite_Opt_Out__c, GARP_Dir_Privacy_Additional_Detail__c, GARP_Dir_Privacy_Job_Information__c, GARP_Dir_Privacy_Prof_Background__c, GARP_Directory_Connect_Feature__c, KPI_FRM_Certified__c, KPI_FRM_Certified_Year__c, KPI_ERP_Certified__c, KPI_ERP_Certified_Year__c, KPI_Membership_Since__c, KPI_CPE_Requirement_Status__c, Professional_Designation_CA__c, Professional_Designation_CFA__c, Professional_Designation_CMA__c, Professional_Designation_CPA__c, Professional_Designation_Other__c, Professional_Designation_PMP__c, Professional_Designation_ACCA__c, Company_Type__c, Corporate_Title__c, Company__c FROM Contact';
        system.debug('querystr>>>'+querystr);
        List<Contact> lstContact = database.query(querystr);      
        List<Contact> returnListContact = new List<Contact>();
        if(lstContact.size() > pageSize) {
            Integer count = 1;
            Integer page = 1;
            for(Contact con :lstContact){
                if(page == pageCurrent) {
                    returnListContact.add(con);
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
        Decimal myDecimal = lstContact.size();
        Decimal divDec = myDecimal.divide(pageSize, 0, System.RoundingMode.UP);         
        searchResults results = new searchResults();
        results.lstContact = returnListContact;
        results.pages = divDec.intValue();
        return results; 
    } 
    
  @RemoteAction
    public static getUserReturnData  fetchUserData() {    
        String userId = UserInfo.getUserId();        
        getUserReturnData rd = new getUserReturnData ();
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        if( lstUser != null && lstUser.size() > 0 ) {
            rd.userData = lstUser;        
            String recordId = lstUser[0].ContactId;
            List<Contact> lstContact = Database.query('SELECT Id, Name, Email, MailingStreet,ID_Number__c, ID_Type__c,Name_As_it_Appears_On_ID__c, MailingCity , MailingCountry  , MailingPostalCode , MailingState, AccountId, GARP_ID__c FROM Contact WHERE Id = :recordId');
        
            if( lstContact != null && lstContact.size() > 0 ) {
                rd.contactData = lstContact;
                String accountId = lstContact[0].AccountId;
                List<Account> lstAccount = [SELECT Id, Name FROM Account where Id =  :accountId];
            if( lstAccount != null && lstAccount.size() > 0 ) {
                    rd.accountData = lstAccount;
                    List<Exam_Attempt__c> lstExamAttempt = [SELECT Id, Name, Checked_In__c, Result__c, Exam_Site__r.Exam__r.Exam__c, Exam_Site__r.Exam_Date__c, Session__c, Member__r.GARP_ID__c, Member__r.name, Exam_Site__r.Site__r.Site_Code__c, Exam_Site__r.Site__r.Display_Address__c, Room__r.name, Seat_No__c FROM Exam_Attempt__c where Member__C =  :recordId];
            if( lstExamAttempt!= null && lstExamAttempt.size() > 0 ) {     
                        rd.examAttemptData = lstExamAttempt;
                    }

                    List<Opportunity> lstOpportunity = [SELECT Id, Name, StageName, Amount, CreatedDate FROM Opportunity where AccountId = :accountId];
                    
            if( lstOpportunity != null && lstOpportunity.size() > 0 ) {
                    
                   rd.opportunityData = lstOpportunity;
                    
                    }}}}
        return rd;               
    }}