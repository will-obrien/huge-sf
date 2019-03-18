public class UpgradeQuoteWizardController {

     public Zuora.zApi.AmendResult responce{get;set;}
     public class billingWrapper{
        public string BillingAccountName {get; set;}
        public string billingId {get;set;}
        public List<subscriptionWrapper> subList{get; set;}
        
        public billingWrapper(){
           subList = new List<subscriptionWrapper>();
        }
     }
     public class subscriptionWrapper{
        public string subscriptionId {get;set;}
        public string name {get; set;}
        public string termStartDate {get; set;} 
        public string termEndDate {get; set;}
        public string billingAccntID {get; set;}
        public List<ratePlanWrapper> ratePlanList {get; set;}
        
        public subscriptionWrapper(){
           ratePlanList = new List<ratePlanWrapper>();
        }
     }
     public class ratePlanWrapper{
        public string ratePlanId {get;set;}
        public string ratePlanName {get; set;}
        public string subId{get; set;} 
        public string productRatePlanId{get; set;}
        public string additionalUsers {get; set;}
        public List<ratePlanChargeWrapper> ratePlanCharge {get;set;}
        
        public ratePlanWrapper(){
           ratePlanCharge = new List<ratePlanChargeWrapper>();
           additionalUsers = null; 
        }
     }
     public class ratePlanChargeWrapper{
        public string ratePlanChargeName{get;set;}
        public string productRatePlanChargeId{get;set;}        
        public decimal price{get;set;}        
        public decimal quantity{get;set;}
        public string rpId{get;set;}
     } 
     public UpgradeQuoteWizardController(){
        
     }
    
    
    Id acountId = System.currentPagereference().getParameters().get('Id');
    List<ratePlanWrapper> ratePlanWrapperList = new List<ratePlanWrapper>();
    
    public List<billingWrapper> getListFromZoura() { 
        
        List<billingWrapper> billingList = new List<billingWrapper>();  
        List<subscriptionWrapper> subscriptionWrapperList = new List<subscriptionWrapper>();
        
        List<ratePlanChargeWrapper> ratePlanChargeWrapperList = new List<ratePlanChargeWrapper>();
        
        Map<string,billingWrapper> billingMap = new  Map<string,billingWrapper>();
        Map<string,subscriptionWrapper> subscriptionMap = new Map<string,subscriptionWrapper>();
        Map<string,ratePlanWrapper> ratePlanMap = new Map<string,ratePlanWrapper>();
        
        List<Account> accnt= [select Id from account where Id = :acountId];
        for(Account a : accnt){
           acountId = a.Id;
        }  
        try{                                                                           
            //Instantiate zApiInstance and invoke login method  
            Zuora.zApi zApiInstance = new Zuora.zApi();
            zApiInstance.zlogin();
            
            String accountQuery  = 'select Id, Name from Account where CrmId = \'' + acountId + '\'';
            List<Zuora.zObject> accountResult= zApiInstance.zquery(accountQuery);
            //system.debug('##accountResult##'+accountResult);
            List<string> billingAccntID = new List<string>();
            for (Zuora.zObject o : accountResult) {
                billingAccntID.add((string)o.getValue('Id'));
                billingWrapper bwObj = new billingWrapper();
                bwObj.billingId = (string)o.getValue('Id');
                bwObj.BillingAccountName = (string)o.getValue('Name');
                billingList.add(bwObj);
                billingMap.put(bwObj.billingId, bwObj);
                
            }
            //system.debug('##billingAccntID ##'+billingAccntID);            
            string queryStrBil = '';  
            for(string b : billingAccntID){
                queryStrBil = queryStrBil + 'AccountId =' + '\'' + b + '\' or ';
            }
            
            String subscriptionQuery  = 'select Id, Name, TermStartDate, TermEndDate, AccountId from Subscription where '+queryStrBil.subString(0,queryStrBil.length()-3);
            system.debug('##subscriptionQuery  ##'+subscriptionQuery);
            List<Zuora.zObject> subscriptionResult = zApiInstance.zquery(subscriptionQuery);
            //system.debug('##subscriptionResult##'+subscriptionResult);
            List<string> subscriptionID = new List<string>();
            for (Zuora.zObject s : subscriptionResult) {
                subscriptionID.add((string)s.getValue('Id'));
                subscriptionWrapper swObj = new subscriptionWrapper(); 
                swObj.subscriptionId = (string)s.getValue('Id'); 
                swObj.name = (string)s.getValue('Name');
                swObj.billingAccntID = (string)s.getValue('AccountId');
                datetime startDate = (datetime)s.getValue('TermStartDate');
                datetime endDate = (datetime)s.getValue('TermEndDate');
                swObj.termStartDate = string.valueof(startDate.date());
                swObj.termEndDate = string.valueof(endDate.date());
                subscriptionWrapperList.add(swObj);
                subscriptionMap.put(swObj.subscriptionId, swObj);
                
            }       
             
            for(subscriptionWrapper sub : subscriptionWrapperList){
                if(billingMap.containsKey(sub.billingAccntID)){
                    billingMap.get(sub.billingAccntID).subList.add(sub);
                }
            }
            
                 
            string queryStrSub = '';
            for(string b : subscriptionID){
                queryStrSub = queryStrSub + 'SubscriptionId =' + '\'' + b + '\' or ';
            }
            
            String ratePlanQuery  = 'select Id, Name, ProductRatePlanId, SubscriptionId from RatePlan where '+queryStrSub.subString(0,queryStrSub.length()-3);
            List<Zuora.zObject> ratePlanQueryResult = zApiInstance.zquery(ratePlanQuery);
            system.debug('##ratePlanQueryResult ##'+ratePlanQueryResult);
            List<string> ratePlanID = new List<string>();
            for (Zuora.zObject r : ratePlanQueryResult) {
                ratePlanID.add((string)r.getValue('Id'));
                ratePlanWrapper ratePanObj = new ratePlanWrapper();
                ratePanObj.ratePlanId = (string)r.getValue('Id');
                ratePanObj.ratePlanName = (string)r.getValue('Name');
                ratePanObj.subId= (string)r.getValue('SubscriptionId');
                ratePanObj.productRatePlanId = (string)r.getValue('ProductRatePlanId');
                ratePlanWrapperList.add(ratePanObj); 
                ratePlanMap.put(ratePanObj.ratePlanId, ratePanObj);           
            }
            
            for(ratePlanWrapper ratePlan : ratePlanWrapperList){
                if(subscriptionMap.containsKey(ratePlan.subId)){
                   subscriptionMap.get(ratePlan.subId).ratePlanList.add(ratePlan);
                }
            }
            
            string queryStrRateId = '';
            for(string b : ratePlanID){
                queryStrRateId = queryStrRateId + 'RatePlanId =' + '\'' + b + '\' or ';
            }
            
            String ratePlanChargeQuery  = 'select Name, ProductRatePlanChargeId, Price, Quantity, RatePlanId from RatePlanCharge where '+queryStrRateId.subString(0,queryStrRateId.length()-3);
            List<Zuora.zObject> ratePlanChargeResult = zApiInstance.zquery(ratePlanChargeQuery);
            //system.debug('##ratePlanChargeResult##'+ratePlanChargeResult);
            for (Zuora.zObject r : ratePlanChargeResult) {                
                ratePlanChargeWrapper ratePanChargeObj = new ratePlanChargeWrapper();
                ratePanChargeObj.ratePlanChargeName = (string)r.getValue('Name');
                ratePanChargeObj.productRatePlanChargeId = (string)r.getValue('ProductRatePlanChargeId');
                ratePanChargeObj.price = (decimal)r.getValue('Price');
                ratePanChargeObj.quantity = (decimal)r.getValue('Quantity');
                ratePanChargeObj.rpId = (string)r.getValue('RatePlanId');
                ratePlanChargeWrapperList.add(ratePanChargeObj);                 
            }
            
            for(ratePlanChargeWrapper ratePlanCharge : ratePlanChargeWrapperList){
                if(ratePlanMap.containsKey(ratePlanCharge.rpId)){
                   ratePlanMap.get(ratePlanCharge.rpId).ratePlanCharge.add(ratePlanCharge);
                }
            }
            
        }catch(Exception ex){          
            System.debug('Exception:'+ex);
            //SendErrorNotificationEmail('\nError Message: '+ex.getMessage()+'\nStack Trace: '+ex.getStackTraceString());
        }
        
        return billingMap.values();
    }
    
   
    
  public PageReference processSelected() {
        string subId;
        string additionalUser;
        string productRatePlanChargeId;
        string amendmentSubscriptionRatePlanId ;
        string selectedRatePlanId = ApexPages.currentPage().getParameters().get('selectedProduct');
        system.debug('##selectedRatePlanId '+selectedRatePlanId);
        
        for(ratePlanWrapper r : ratePlanWrapperList){
            if(r.ratePlanId == selectedRatePlanId && r.additionalUsers!=null){
                system.debug('##selected value'+r.additionalUsers);
                additionalUser = r.additionalUsers;
                subId = r.subId;                    
            }
        }
        System.debug('additionalUser :'+additionalUser);
        try{                                                                           
            //Instantiate zApiInstance and invoke login method  
            Zuora.zApi zApiInstance = new Zuora.zApi();
            zApiInstance.zlogin();            
            
            
            String ratePlanChargeQuery  = 'select ProductRatePlanChargeId, RatePlanId from RatePlanCharge where RatePlanId = \'' + selectedRatePlanId + '\'';
            List<Zuora.zObject> ratePlanChargeResult = zApiInstance.zquery(ratePlanChargeQuery);
            system.debug('##ratePlanChargeResult##'+ratePlanChargeResult);
            for (Zuora.zObject r : ratePlanChargeResult) {                
                productRatePlanChargeId =  (String)r.getValue('ProductRatePlanChargeId');
                amendmentSubscriptionRatePlanId = (String)r.getValue('RatePlanId');
            }
            //system.debug('@@ '+amendmentSubscriptionRatePlanId);
            //system.debug('##productRatePlanId  '+productRatePlanId);
            
            /*String productRatePlanChargeQuery = 'select Id from ProductRatePlanCharge where productRatePlanId= \'' + productRatePlanId  + '\'';
            List<Zuora.zObject> productRatePlanChargeResult= zApiInstance.zquery(productRatePlanChargeQuery);
            
            string productRatePlanChargeId;
            for (Zuora.zObject o : productRatePlanChargeResult) {
                productRatePlanChargeId =  (String)o.getValue('Id');
            }*/
            //system.debug('##productRatePlanChargeResult##'+productRatePlanChargeResult);
            Zuora.zObject ratePlan = new Zuora.zObject('RatePlan');
            ratePlan.setValue('AmendmentSubscriptionRatePlanId', amendmentSubscriptionRatePlanId);      
            
            Zuora.zObject ratePlanCharge = new Zuora.zObject('RatePlanCharge');
            ratePlanCharge.setValue('ProductRatePlanChargeId', productRatePlanChargeId);
            ratePlanCharge.setValue('Quantity', additionalUser);
            
            Zuora.zObject ratePlanChargeData = new Zuora.zObject('RatePlanChargeData');
            ratePlanChargeData.setValue('RatePlanCharge', ratePlanCharge);
            
            Zuora.zObject ratePlanData = new Zuora.zObject('RatePlanData');
            ratePlanData.setValue('RatePlanChargeData', new Zuora.zObject[]{ratePlanChargeData});
            ratePlanData.setValue('RatePlan', ratePlan);
            
            Zuora.zObject amend = new Zuora.zObject('Amendment');
            amend.setValue('Name', 'Update Product');
            amend.setValue('Description', 'Update Product Quantity');
            amend.setValue('Type', 'UpdateProduct');
            amend.setValue('SubscriptionId', subId);
            amend.setValue('ContractEffectiveDate', Datetime.now().format('yyyy-MM-dd\'T\'HH:mm:ss', 'GMT' ));
            amend.setValue('CustomerAcceptanceDate', Datetime.now().format('yyyy-MM-dd\'T\'HH:mm:ss', 'GMT' ));
            amend.setValue('EffectiveDate', Datetime.now().format('yyyy-MM-dd\'T\'HH:mm:ss', 'GMT' ));
            amend.setValue('ServiceActivationDate', Datetime.now().format('yyyy-MM-dd\'T\'HH:mm:ss', 'GMT' ));
            amend.setValue('Status', 'Completed');
            amend.setValue('RatePlanData', ratePlanData);
            
                        
            Zuora.zObject[] amendList = new List<Zuora.zObject>{amend};
            
            Zuora.zApi.AmendOptions amendOptions = new Zuora.zApi.AmendOptions();
            amendOptions.GenerateInvoice= False;
            amendOptions.ProcessPayments= False;
            
            Zuora.zApi.PreviewOptions previewOptions = new Zuora.zApi.PreviewOptions();
            previewOptions.EnablePreviewMode = True;
            
            Zuora.zApi.AmendRequest amendRequest = new Zuora.zApi.AmendRequest();
            amendRequest.amendments = amendList;
            amendRequest.amendOptions = amendOptions;
            //amendRequest.previewOptions = previewOptions;
            
           /* System.debug('amendRequest: '+amendRequest);
            List<Zuora.zApi.AmendRequest> amendRequestList = new List<Zuora.zApi.AmendRequest>();
            amendRequestList.add(amendRequest);
            System.debug('amendRequestList: '+amendRequestList);
            Zuora.zApi.AmendResult amendResult =  zApiInstance.zamend(amendRequestList);  
            responce = amendResult;
            System.debug( 'SOAP Request = ' + Zuora.zApi.currentLogger.request );
            System.debug( 'SOAP Response = ' + Zuora.zApi.currentLogger.response );
            System.debug('amendResult: '+amendResult );*/
            
            System.debug('amendRequest: '+amendRequest);
            Zuora.zApi.AmendResult result = zApiInstance.zamend(new List < Zuora.zApi.AmendRequest > {
                amendRequest
            });
            System.debug( 'SOAP Request = ' + Zuora.zApi.currentLogger.request );
            System.debug(result);
           
        }catch(Exception ex){          
            System.debug( 'SOAP Request = ' + Zuora.zApi.currentLogger.request );
            System.debug('Exception:'+ex);
            //SendErrorNotificationEmail('\nError Message: '+ex.getMessage()+'\nStack Trace: '+ex.getStackTraceString());
        }
        
        //subscriptionList =  getSubsciptions();
        return null;
    } 
    
    
}