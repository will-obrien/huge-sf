public with sharing class QuoteStatusUtilities {

	public static Boolean isTest = false;
	public static String QUOTE_OWNER_REGION = null;
        public  static boolean updateQuoteStatus(Id quoteId, string status,string approvalLevel){
            Boolean statusflag= false;   
               
            try{    
                Quote updateQuote=[Select Status,Is_Approval_Required__c,Approval_Level__c,IsValidBidPrice__c  From Quote where Id=:quoteId];
                updateQuote.Is_Approval_Required__c= (approvalLevel !='None'?true:false);
                updateQuote.Approval_Level__c =approvalLevel;
                if (QCStatusValues__c.getInstance(PGIQuoteStatusEnum.QuoteInProgress.name()).StatusValue__c.equals(status))
                {
                	updateQuote.OverallApprovalStatus__c = '';
                }
                updateQuote.IsValidBidPrice__c =QuoteStatusUtilities.bidPriceValidation(quoteId);
                // check if current user profile is not "PGI Contract Manager"
				if ((PGIAppStaticResources.currentUserProfile != null 
					&& !PGIAppConstants.PROFILES_CANNOT_UPDATE_CONTRACT_TYPES.contains(PGIAppStaticResources.currentUserProfile.Name))
					|| isTest)
				{
                	updateQuote.Status = status;
				}
                update updateQuote;     
                statusflag = true;
                
            }
            catch (Exception ex){
            PGIErrorUtilities.logPgiError('QuoteStatusUtilities:updateQuoteStatus()',ex.getMessage(),PGIErrorUtilities.LoggingLevel.DEBUG);
            system.debug(LoggingLevel.ERROR,'Error When updating quote status'+ex.getMessage());
            }               
            return statusflag;
        } 
        
    public  static boolean updateQuoteStatus(Id quoteId, string status){
            Boolean statusflag= false;          
            try{
            	// check if current user profile is not "PGI Contract Manager"
				if ((PGIAppStaticResources.currentUserProfile != null 
					&& !PGIAppConstants.PROFILES_CANNOT_UPDATE_CONTRACT_TYPES.contains(PGIAppStaticResources.currentUserProfile.Name))
					|| isTest)
				{
	                Quote updateQuote = [Select q.Status, (Select Approval_Status__c From QuoteLineItems) From Quote q   where Id=:quoteId];                        
	                updateQuote.Status = status;
	                
	                statusflag = true;
	                string approvalStatus;
	                if(status ==QCStatusValues__c.getInstance(PGIQuoteStatusEnum.SubmittedPriceApproval.name()).StatusValue__c){
	                    approvalStatus = 'Pending for Approval';
	                } 
	                else if(status ==QCStatusValues__c.getInstance(PGIQuoteStatusEnum.PricingApproved.name()).StatusValue__c){
	                    approvalStatus = 'Approved';
	                }
	                 else if(status == QCStatusValues__c.getInstance(PGIQuoteStatusEnum.QuoteInProgress.name()).StatusValue__c)
	                {
	                    approvalStatus = 'Approval Required';
	                }
	                if(approvalStatus != ''){
	                    list<quoteLineItem> updateQuoteLineItem= new list<quoteLineItem>();
	                    for(quoteLineItem lineItem:updateQuote.QuoteLineItems){ 
	                            
	                            if(lineItem.Approval_Status__c == 'Approval Required' || lineItem.Approval_Status__c =='Pending for Approval')  {           
	                        
	                                lineItem.Approval_Status__c=approvalStatus;
	                                updateQuoteLineItem.add(lineItem);
	                            }
	                    }
	                    update updateQuoteLineItem;         
	                }                   
	                update updateQuote;
            	}
            }
            catch (Exception ex){
            PGIErrorUtilities.logPgiError('QuoteSelectionUtilities:updateQuoteStatus()',ex.getMessage(),PGIErrorUtilities.LoggingLevel.DEBUG);
            system.debug(LoggingLevel.ERROR,'Error When updating quote status '+ex.getMessage());
            }
            return statusflag;
    }
    public  static void updateQuoteApproval(Id quoteId){
    Quote approvalquote= [Select q.isapprovedtrue__c,q.Is_Approval_Required__c from Quote q   where Id=:quoteId];                        
    approvalquote.isapprovedtrue__c= true;
    approvalquote.Is_Approval_Required__c =false;
    update approvalquote;
       
        }
    
        public static void updateQuoteApprovalCommentandUser (Id quoteId,string Comment,Id UserId){
            try{
                Quote updateQuote=[select Comment_For_Approver__c,Approver_Name__c from quote where id=:quoteId];
                updateQuote.Comment_For_Approver__c=Comment;
                updateQuote.Approver_Name__c=UserId;
                update updateQuote;
            }catch(exception e){
                system.debug('Exception'+e);
            }
        }
       
        public  static void updateApprovalStatus(Id quoteId,string approvalstatus){
    try{    
          system.debug('approvalstatus');
           Quote updateQuote=[select OverallApprovalStatus__c,Is_Approval_Required__c from quote where id=:quoteId];
           updateQuote.OverallApprovalStatus__c=approvalstatus;
           if(approvalstatus == 'Approved'){
            updateQuote.Is_Approval_Required__c=false;
           }
           update updatequote;
            }
            catch (Exception ex){
            PGIErrorUtilities.logPgiError('QuoteStatusUtilities:updateQuoteStatus()',ex.getMessage(),PGIErrorUtilities.LoggingLevel.DEBUG);
            system.debug(LoggingLevel.ERROR,'Error When updating quote status'+ex.getMessage());
            }               
            
        } 
     
    
    public static Boolean bidPriceValidation(Id QuoteId){
        Boolean isBidPriceSame = true;
        Map<Id,Decimal>  lineIdMap = new Map<Id, Decimal>();
        
        for(QuotelineItem lineItem:[Select QuoteId,Product__c,BidPrice__c From QuoteLineItem where QuoteId=:quoteId and Product__r.ProductType__c !='Service']){ 
                system.debug('#### Raj'+lineItem);
                if(lineIdMap.get(lineItem.Product__c)!=null && lineIdMap.get(lineItem.Product__c)!=lineItem.BidPrice__c){
                    isBidPriceSame = false;
                    break;           
                } else{
                    lineIdMap.put(lineItem.Product__c, lineItem.BidPrice__c);
                }
            
        }               
    
        return isBidPriceSame ;
    }
    public static string getApprovalRequiredStatus(Id QuoteId){     
            string requiredLevel='None';
            Integer LevelNo=0;
            PGIAppStaticResources staticResources = PGIAppStaticResources.getInstance();
            Map<String, Map<String, String>> regionWiseApprovalLevelMap = staticResources.regionWiseApprovalLevelMap;
            Map<String, String> approvalLevelMap;
            if (regionWiseApprovalLevelMap != null)
            {
	            approvalLevelMap = regionWiseApprovalLevelMap.get(QUOTE_OWNER_REGION);
            }
            // update the approval level for all line items, service and non-service.
            for(QuotelineItem lineItem:[Select QuoteId,Approval_Level__c From QuoteLineItem where QuoteId=:quoteId and Approval_Level__c !='None']){                
               if((lineItem.Approval_Level__c == 'Level 1' || lineItem.Approval_Level__c == approvalLevelMap.get('Level 1')) && LevelNo< 2){
                    LevelNo=1;
                    requiredLevel = approvalLevelMap.get('Level 1');
                } else if((lineItem.Approval_Level__c == 'Level 2' || lineItem.Approval_Level__c  == approvalLevelMap.get('Level 2')) && LevelNo< 3 ){
                    LevelNo=2;
                    requiredLevel = approvalLevelMap.get('Level 2');
                } else if((lineItem.Approval_Level__c == 'Level 3' || lineItem.Approval_Level__c  == approvalLevelMap.get('Level 3')) && LevelNo< 4){
                    LevelNo=3;                  
                    requiredLevel = approvalLevelMap.get('Level 3');
                } else if((lineItem.Approval_Level__c == 'Level 4' || lineItem.Approval_Level__c  == approvalLevelMap.get('Level 4'))  && LevelNo< 5){
                    LevelNo=4;                  
                    requiredLevel = approvalLevelMap.get('Level 4');
                } else if((lineItem.Approval_Level__c == 'Level 5' || lineItem.Approval_Level__c == approvalLevelMap.get('Level 5')) && LevelNo< 6){
                    LevelNo=5;              
                    requiredLevel = approvalLevelMap.get('Level 5');
                } else if((lineItem.Approval_Level__c == 'Level 6' || lineItem.Approval_Level__c == approvalLevelMap.get('Level 6')) && LevelNo< 7){
                    LevelNo=6;  
                    requiredLevel = approvalLevelMap.get('Level 6');
                } else if(lineItem.Approval_Level__c == 'Not Defined'){                      
                    requiredLevel ='Not Defined';
                    break;
                }
            } 
        
        return requiredLevel; 
    }   
    public static list<QuoteLineItem> updateQuoteLineItemApprovalStatus(list<QuoteLineItem> lstQuoteLineItem, list<ServiceCategory__c> serviceCategorylist, string levelAuthority){
        
        map<Id,QuotelineItem>prodMap= new map<Id,QuotelineItem>();
        list<QuoteLineItem> updatedQuoteLineItem = new list<QuoteLineItem>(); 
        map<Id,Double>levelMap =new map<Id,Double>();
        map<Id,Product__c> ProductMap =new map<Id,Product__c>(); 
        Boolean isRequiredApproval = false;
        for(ServiceCategory__c aServiceCat:serviceCategorylist){
           ProductMap.put(aServiceCat.Product__r.Id,aServiceCat.Product__r);
         }   
       
       string requiredLevel='';
       integer LevelNo =0;
       PGIAppStaticResources staticResources = PGIAppStaticResources.getInstance();
        Map<String, Map<String, String>> regionWiseApprovalLevelMap = staticResources.regionWiseApprovalLevelMap;
        Map<String, String> approvalLevelMap;
        if (regionWiseApprovalLevelMap != null)
        {
            approvalLevelMap = regionWiseApprovalLevelMap.get(QUOTE_OWNER_REGION);
        }
        for(QuotelineItem quotelineInfo:lstQuoteLineItem ){  
         
            if(ProductMap.get(quotelineInfo.Product__c)!=null){
                product__c productDetails=ProductMap.get(quotelineInfo.Product__c);                
                if(quotelineInfo.BidPrice__c <productDetails.List_Rate__c){
                    if(productDetails.Auth_Rate1__c !=null && quotelineInfo.BidPrice__c>= productDetails.Auth_Rate1__c ){
                        requiredLevel ='Level 1';    
                    } else if( productDetails.Auth_Rate2__c !=null  && quotelineInfo.BidPrice__c >= productDetails.Auth_Rate2__c ){
                        requiredLevel ='Level 2';   
                    } else if( productDetails.Auth_Rate3__c !=null  && quotelineInfo.BidPrice__c >= productDetails.Auth_Rate3__c ){                         
                        requiredLevel ='Level 3';
                    } else if( productDetails.Auth_Rate4__c !=null  && quotelineInfo.BidPrice__c >= productDetails.Auth_Rate4__c ){                              
                        requiredLevel ='Level 4'; 
                    } else if( productDetails.Auth_Rate5__c !=null  && quotelineInfo.BidPrice__c >= productDetails.Auth_Rate5__c ){                          
                        requiredLevel ='Level 5';       
                    }  else if( productDetails.Auth_Rate6__c !=null  && quotelineInfo.BidPrice__c >= productDetails.Auth_Rate6__c){                             
                        requiredLevel ='Level 6';       
                    } else if(productDetails.Auth_Rate1__c !=null || productDetails.Auth_Rate2__c !=null || productDetails.Auth_Rate3__c !=null || productDetails.Auth_Rate4__c !=null
                        || productDetails.Auth_Rate5__c !=null || productDetails.Auth_Rate6__c !=null){                         
                        requiredLevel ='Not Defined';                               
                    }  
                }
           }
           if(levelAuthority== 'Level 1' ){
                if(requiredLevel=='Level 1') {
                     quotelineInfo.Approval_Level__c ='';
                     quotelineInfo.Approval_Status__c ='';
                }else if(requiredLevel=='Level 2' || requiredLevel=='Level 3' || requiredLevel=='Level 4' || requiredLevel=='Level 5' || requiredLevel=='Level 6'){
                	String value = approvalLevelMap.get(requiredLevel);
                    quotelineInfo.Approval_Level__c = value != null ? value : requiredLevel;
                    quotelineInfo.Approval_Status__c ='Approval Required';
                }else{
                    quotelineInfo.Approval_Level__c ='';
                    quotelineInfo.Approval_Status__c ='';
                }
        }else if(levelAuthority== 'Level 2' ){
                if(requiredLevel=='Level 1' || requiredLevel=='Level 2') {
                     quotelineInfo.Approval_Level__c ='';
                     quotelineInfo.Approval_Status__c ='';
                }else if( requiredLevel=='Level 3' || requiredLevel=='Level 4' || requiredLevel=='Level 5' || requiredLevel=='Level 6'){
                	String value = approvalLevelMap.get(requiredLevel);
                    quotelineInfo.Approval_Level__c = value != null ? value : requiredLevel;
                    quotelineInfo.Approval_Status__c ='Approval Required';
                }else{
                    quotelineInfo.Approval_Level__c ='';
                    quotelineInfo.Approval_Status__c ='';
                }
            }else  if(levelAuthority== 'Level 3' ){
                if(requiredLevel=='Level 1' || requiredLevel=='Level 2' || requiredLevel=='Level 3') {
                     quotelineInfo.Approval_Level__c ='';
                     quotelineInfo.Approval_Status__c ='';
                }else if(requiredLevel=='Level 4' || requiredLevel=='Level 5' || requiredLevel=='Level 6'){
                	String value = approvalLevelMap.get(requiredLevel);
                    quotelineInfo.Approval_Level__c = value != null?value:requiredLevel;
                    quotelineInfo.Approval_Status__c ='Approval Required';
                }else{
                    quotelineInfo.Approval_Level__c ='';
                    quotelineInfo.Approval_Status__c ='';
                }
            }else  if(levelAuthority== 'Level 4' ){
                if(requiredLevel=='Level 1' || requiredLevel=='Level 2' || requiredLevel=='Level 3' || requiredLevel=='Level 4') {
                     quotelineInfo.Approval_Level__c ='';
                     quotelineInfo.Approval_Status__c ='';
                }else if( requiredLevel=='Level 5' || requiredLevel=='Level 6'){
                	String value = approvalLevelMap.get(requiredLevel);
                    quotelineInfo.Approval_Level__c = value != null?value:requiredLevel;
                    quotelineInfo.Approval_Status__c ='Approval Required';
                }else{
                    quotelineInfo.Approval_Level__c ='';
                    quotelineInfo.Approval_Status__c ='';
                }
            }else  if(levelAuthority== 'Level 5' ){
                if(requiredLevel=='Level 1' || requiredLevel=='Level 2' || requiredLevel=='Level 3' || requiredLevel=='Level 4' || requiredLevel=='Level 5') {
                     quotelineInfo.Approval_Level__c ='';
                     quotelineInfo.Approval_Status__c ='';
                }else if( requiredLevel=='Level 6'){
                	String value = approvalLevelMap.get(requiredLevel);
                    quotelineInfo.Approval_Level__c = value != null?value:requiredLevel;
                    quotelineInfo.Approval_Status__c ='Approval Required';
                }else{
                    quotelineInfo.Approval_Level__c ='';
                    quotelineInfo.Approval_Status__c ='';
                }
            }
            else  if(levelAuthority== 'Level 6' ){
                if(requiredLevel=='Level 1' || requiredLevel=='Level 2' || requiredLevel=='Level 3' || requiredLevel=='Level 4' || requiredLevel=='Level 5' ||  requiredLevel=='Level 6') {
                     quotelineInfo.Approval_Level__c ='';
                     quotelineInfo.Approval_Status__c ='';
                }else{
                    quotelineInfo.Approval_Level__c ='';
                    quotelineInfo.Approval_Status__c ='';
                }
            }
           requiredLevel = 'None';
           updatedQuoteLineItem.add(quotelineInfo);
        }   
        return  updatedQuoteLineItem;
    }
 //Test Method for test1updateQuoteStatus
    @istest (seeAlldata=true) 
    private static void test1_updateQuoteStatus() {
        Account testAcc= PGITestUtilities.getAccountDetails();
        insert testAcc;
        Opportunity testOpp= PGITestUtilities.getOpportunityDetails(); 
        testOpp.Owner_Region__c = 'NA';
        insert testOpp;
        QUOTE_OWNER_REGION = testOpp.Owner_Region__c;
        Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
        insert cont;
        Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        testQuote.Approval_Level__c='Level 1';
        testQuote.Status='test123';
        insert testQuote;
        //Case1: with valid quoteId
        Boolean test=updateQuoteStatus(testQuote.Id,'test123','Level 2');
        //assert
        system.assertEquals(test,true); 
        //Case1: with Invalid quoteId
        testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id);
        test=updateQuoteStatus(testQuote.Id,'test123','Level 1');
        //assert
        system.assertEquals(test,false); 
    }
     //Test Method for test2updateQuoteStatus
    @istest (seeAlldata=true) 
    private static void test2_updateQuoteStatus() {
    	isTest = true;
    string comment='test';
        Account testAcc= PGITestUtilities.getAccountDetails();
        insert testAcc;
        Opportunity testOpp= PGITestUtilities.getOpportunityDetails();      
        testOpp.Owner_Region__c = 'NA';
        insert testOpp;
        Product2 product = PGITestUtilities.getStdProduct();
        product.Name = 'American Test';
        insert product;
        PricebookEntry pbe2 = PGITestUtilities.CreatePriceBookEntryForProduct(product);
        insert pbe2;
        OpportunityLineItem testOli = PGITestUtilities.getOpportunityLineItemDetails(testOpp.Id, pbe2.Id);
        insert testOli;
        QUOTE_OWNER_REGION = testOpp.Owner_Region__c;
        Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
        insert cont;
        Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        insert testQuote;
        Quote testQuote1= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        insert testQuote1;
        
        Region__c region = PGITestUtilities.getRegionDetails();
        insert region;
        list<Product__c> allProduct= new list<Product__c>();
        Product__c testprod1 = PGITestUtilities.getProductDetails('Add-on','TestAddon','10111111');
        insert testProd1;       
        Product__c testprod2 = PGITestUtilities.getProductDetails('Ancillary','TestAncillary','20111111');
        insert testProd2;
        Product__c testprod3= PGITestUtilities.getProductDetails('Service','testserv','30111111'); 
        insert testProd3;
        Solution__c testSoln = PGITestUtilities.getSolution();
        insert testSoln;
        Service__c testSer= PGITestUtilities.getService(testSoln.Id);
        insert testSer;
        ServiceCategory__c testSc1= PGITestUtilities.getSerCategory(testSer.Id, testProd3.Id, true);
        insert testSc1;
        ServiceCategory__c testSc2= PGITestUtilities.getSerCategory(testSer.Id, testProd2.Id, false);
        insert testSc2;
        ServiceCategory__c testSc3= PGITestUtilities.getSerCategory(testSer.Id, testProd1.Id, false);
        insert testSc3; 
        PriceBook2 pb2Standard = [select Id from Pricebook2 where isStandard=true];
        string standardPriceBookId = pb2Standard.Id;
        
        Product2 testProd= PGITestUtilities.getStdProduct();        
        insert testProd;
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=standardPriceBookId, Product2Id=testProd.Id, UnitPrice=99, isActive=true);
        insert pbe;    
        QuoteLineItem testquoteLineItem1=PGITestUtilities.getServiceQuoteLineItem(testprod1.Id,testSer.Id,testQuote.Id,pbe);
        testquoteLineItem1.Approval_Status__c= 'Approval Required';
        insert testquoteLineItem1;
        QuoteLineItem testquoteLineItem2=PGITestUtilities.getTestQuoteLineItem(testprod2.Id,testSer.Id,testQuote.Id,pbe,testquoteLineItem1.Id);
        testquoteLineItem2.Approval_Status__c= 'Approval Required';
        insert testquoteLineItem2;
        QuoteLineItem testquoteLineItem3=PGITestUtilities.getTestQuoteLineItem(testprod3.Id,testSer.Id,testQuote.Id,pbe,testquoteLineItem1.Id);
        testquoteLineItem3.Approval_Status__c = 'Approval Required'; 
        insert testquoteLineItem3;
        //Case1:+Ve with valid quoteId,Submitted - Price Approval
        Boolean test=updateQuoteStatus(testQuote.Id,QCStatusValues__c.getInstance(PGIQuoteStatusEnum.SubmittedPriceApproval.name()).StatusValue__c);
        system.assertEquals(test,true); 
        list<QuoteLineItem> testquoteLineItem=[Select QuoteId,Approval_Status__c From QuoteLineItem where QuoteId=:testQuote.Id and Approval_Status__c='Pending for Approval'];
        system.assertNotEquals(testquoteLineItem.size(),0); 
        //Case2:+Ve with valid quoteId,Quote- Pricing Rejected
        test=updateQuoteStatus(testQuote.Id,QCStatusValues__c.getInstance(PGIQuoteStatusEnum.QuoteInProgress.name()).StatusValue__c);
        system.assertEquals(test,true); 
        testquoteLineItem=[Select QuoteId,Approval_Status__c From QuoteLineItem where QuoteId=:testQuote.Id and Approval_Status__c='Approval Required'];
        system.assertnotEquals(testquoteLineItem.size(),0); 
        //Case3:+Ve with valid quoteId,Level 1
        test=updateQuoteStatus(testQuote.Id,QCStatusValues__c.getInstance(PGIQuoteStatusEnum.ContractDocumentGenerated.name()).StatusValue__c);
        system.assertEquals(test,true); 
        testquoteLineItem=[Select QuoteId,Approval_Status__c From QuoteLineItem where QuoteId=:testQuote.Id and Approval_Status__c='Approved'];
        //system.assertnotEquals(testquoteLineItem.size(),0);   
        //Case4:-Ve with invalid quoteId 
        testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        test=updateQuoteStatus(testQuote.Id,QCStatusValues__c.getInstance(PGIQuoteStatusEnum.ContractDocumentGenerated.name()).StatusValue__c);
        system.assertEquals(test,false); 
        
   QuoteStatusUtilities.updateQuoteApproval(testQuote1.Id);
   //QuoteStatusUtilities.updateComment(testQuote1.Id,comment);
   QuoteStatusUtilities.updateApprovalStatus(testQuote1.Id,comment);
   //QuoteStatusUtilities.updateUser(testQuote1.Id,comment);
   delete testquote1;
 //  QuoteStatusUtilities.updateComment(testQuote1.Id,'');
    
   QuoteStatusUtilities.updateApprovalStatus(testQuote1.Id,'');
    
   //QuoteStatusUtilities.updateUser(testQuote1.Id,'');
   
    }
   //Test Method for getApprovalRequiredStatus
    @istest (seeAlldata=true) 
    private static void test1_getApprovalRequiredStatus() {
    	User testUser1=PGITestUtilities.getTestUser(PGITestUtilities.getAdminProfile());
        testUser1.firstName='TestUser1';
        testUser1.Level_Of_Authority__c='Level 1';
        insert testUser1;
     	Account testAcc= PGITestUtilities.getAccountDetails();
        insert testAcc;
        Opportunity testOpp= PGITestUtilities.getOpportunityDetails();      
        testOpp.Owner_Region__c = 'NA';
        insert testOpp;
        Product2 product = PGITestUtilities.getStdProduct();
        product.Name = 'American Test';
        insert product;
        PricebookEntry pbe2 = PGITestUtilities.CreatePriceBookEntryForProduct(product);
        insert pbe2;
        OpportunityLineItem testOli = PGITestUtilities.getOpportunityLineItemDetails(testOpp.Id, pbe2.Id);
        insert testOli;
        QUOTE_OWNER_REGION = testOpp.Owner_Region__c;
        Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
        insert cont;
        Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        insert testQuote;
        Region__c region = PGITestUtilities.getRegionDetails();
        insert region;
        list<Product__c> allProduct= new list<Product__c>();
        Product__c testprod1 = PGITestUtilities.getProductDetails('Add-on','TestAddon','10111111');
        allProduct.add(testProd1);
        //insert testProd1;       
        Product__c testprod2 = PGITestUtilities.getProductDetails('Ancillary','TestAncillary','20111111');
        allProduct.add(testprod2);
        //insert testProd2;
        Product__c testprod3= PGITestUtilities.getProductDetails('Service','testserv','30111111'); 
        allProduct.add(testProd3);
        //insert testProd3;
        insert allProduct;
        Solution__c testSoln = PGITestUtilities.getSolution();
        insert testSoln;
        Service__c testSer= PGITestUtilities.getService(testSoln.Id);
        insert testSer;
        List<ServiceCategory__c> serCategoryList = new List<ServiceCategory__c>();
        ServiceCategory__c testSc1= PGITestUtilities.getSerCategory(testSer.Id, allProduct.get(2).Id, true);
        //insert testSc1;
        serCategoryList.add(testSc1);
        ServiceCategory__c testSc2= PGITestUtilities.getSerCategory(testSer.Id, allProduct.get(1).Id, false);
        //insert testSc2;
        serCategoryList.add(testSc2);
        ServiceCategory__c testSc3= PGITestUtilities.getSerCategory(testSer.Id, allProduct.get(0).Id, false);
        //insert testSc3; 
        serCategoryList.add(testSc3);
        insert serCategoryList;
        PriceBook2 pb2Standard = [select Id from Pricebook2 where isStandard=true];
        string standardPriceBookId = pb2Standard.Id;
        
        Product2 testProd= PGITestUtilities.getStdProduct();        
        insert testProd;
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=standardPriceBookId, Product2Id=testProd.Id, UnitPrice=99, isActive=true);
        insert pbe;    
        List<QuoteLineItem> qliList = new List<QuoteLineItem>();
        QuoteLineItem testquoteLineItem1=PGITestUtilities.getServiceQuoteLineItem(testprod1.Id,testSer.Id,testQuote.Id,pbe);
        testquoteLineItem1.Approval_Status__c= 'Approval Required';
        qliList.add(testquoteLineItem1);
        //insert testquoteLineItem1;
        QuoteLineItem testquoteLineItem2=PGITestUtilities.getTestQuoteLineItem(testprod2.Id,testSer.Id,testQuote.Id,pbe,testquoteLineItem1.Id);
        testquoteLineItem2.Approval_Status__c= 'Approval Required';
        qliList.add(testquoteLineItem2);
        //insert testquoteLineItem2;
        QuoteLineItem testquoteLineItem3=PGITestUtilities.getTestQuoteLineItem(testprod3.Id,testSer.Id,testQuote.Id,pbe,testquoteLineItem1.Id);
        testquoteLineItem3.Approval_Status__c = 'Approval Required'; 
        qliList.add(testquoteLineItem3);
        //insert testquoteLineItem3;
        insert qliList;
        //Case1: Level 1
        PGIAppStaticResources staticResources = PGIAppStaticResources.getInstance();
        Map<String, Map<String, String>> regionWiseApprovalLevelMap = staticResources.regionWiseApprovalLevelMap;
        Map<String, String> approvalLevelMap;
        if (regionWiseApprovalLevelMap != null)
        {
            approvalLevelMap = regionWiseApprovalLevelMap.get(QUOTE_OWNER_REGION);
        }
        testquoteLineItem1 = qliList.get(0);
        String levelName = approvalLevelMap.get('Level 1');
        testquoteLineItem1.Approval_Level__c=levelName;
        update testquoteLineItem1;
        String test=getApprovalRequiredStatus(testQuote.Id);
        system.assertEquals(test,levelName);
        //Case2: Level 2
        levelName = approvalLevelMap.get('Level 2');
        testquoteLineItem1.Approval_Level__c=levelName;
        update testquoteLineItem1;
         test=getApprovalRequiredStatus(testQuote.Id);
        system.assertEquals(test,levelName);
        //Case3: Level 3
        levelName = approvalLevelMap.get('Level 3');
        testquoteLineItem1.Approval_Level__c=levelName;
        update testquoteLineItem1;
         test=getApprovalRequiredStatus(testQuote.Id);
        system.assertEquals(test,levelName);
        //Case4: Level 4
        levelName = approvalLevelMap.get('Level 4');
        testquoteLineItem1.Approval_Level__c=levelName;
        update testquoteLineItem1;
        test=getApprovalRequiredStatus(testQuote.Id);
        system.assertEquals(test, levelName);
        //Case5: Level 5
        levelName = approvalLevelMap.get('Level 5');
        testquoteLineItem1.Approval_Level__c=levelName;
        update testquoteLineItem1;
         test=getApprovalRequiredStatus(testQuote.Id);
        system.assertEquals(test,levelName);
        //Case6: Level 6
        levelName = approvalLevelMap.get('Level 6');
        testquoteLineItem1.Approval_Level__c=levelName;
        update testquoteLineItem1;
         test=getApprovalRequiredStatus(testQuote.Id);
        system.assertEquals(test, levelName);
        //Case7:Not Defined
        testquoteLineItem1.Approval_Level__c='Not Defined';
        update testquoteLineItem1;
        test=getApprovalRequiredStatus(testQuote.Id);
        string comment='temp';
        system.assertEquals(test,'Not Defined');    
        QuoteStatusUtilities.updateQuoteApprovalCommentandUser(testQuote.Id,comment,testUser1.id); 
        delete testquote;
        
        QuoteStatusUtilities.updateQuoteApprovalCommentandUser(testQuote.Id,comment,testUser1.id); 
        
        
        
    }
    //Test Method for getApprovalRequiredStatus
    @istest (seeAlldata=true) 
    private static void test1_updateQuoteLineItemApprovalStatus() {
        test.startTest();
       string requiredLevel='Level 1';
        Test.setCurrentPage(Page.PGIQuoteApprovalAction);
        //Testdata 
        User testUser1=PGITestUtilities.getTestUser(PGITestUtilities.getAdminProfile());
        testUser1.firstName='TestUser1';
        testUser1.Level_Of_Authority__c='Level 1';
        insert testUser1;
        
        User testUser2=PGITestUtilities.getTestUser(PGITestUtilities.getAdminProfile()) ;
        testUser2.firstName='TestUser2';
        testUser2.username='hsoni@pgi.com';        
        testUser2.Level_Of_Authority__c='Level 2';
        insert testUser2;
        
        
        
        Account testAcc= PGITestUtilities.getAccountDetails();
        insert testAcc;
        Opportunity testOpp= PGITestUtilities.getOpportunityDetails();      
        testOpp.Owner_Region__c = 'NA';
        insert testOpp;
        Product2 product = PGITestUtilities.getStdProduct();
        product.Name = 'American Test';
        insert product;
        PricebookEntry pbe2 = PGITestUtilities.CreatePriceBookEntryForProduct(product);
        insert pbe2;
        OpportunityLineItem testOli = PGITestUtilities.getOpportunityLineItemDetails(testOpp.Id, pbe2.Id);
        insert testOli;
        QUOTE_OWNER_REGION = testOpp.Owner_Region__c;
        Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
        insert cont;
        Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        insert testQuote;
        
        Region__c region = PGITestUtilities.getRegionDetails();
        insert region;
        list<Product__c> allProduct= new list<Product__c>();
        Product__c testprod1 = PGITestUtilities.getProductDetails('Add-on','TestAddon','10111111');
        insert testProd1;       
        Product__c testprod2 = PGITestUtilities.getProductDetails('Ancillary','TestAncillary','20111111');
        insert testProd2;
        Product__c testprod3= PGITestUtilities.getProductDetails('Service','testserv','30111111'); 
        insert testProd3;
        Product__c testprod4= PGITestUtilities.getProductDetails('Service','testserv','40111111');
        insert testProd4;
        Product__c testprod5= PGITestUtilities.getProductDetails('Service', 'testserv','50111111');
        insert testProd5;
        Product__c testprod6= PGITestUtilities.getProductDetails('Service', 'testserv','60111111');
        insert testProd6;
        Product__c testprod7= PGITestUtilities.getProductDetails('Service','testserv','70111111');
        insert testProd7;
        Solution__c testSoln = PGITestUtilities.getSolution();
        insert testSoln; 
        Service__c testSer= PGITestUtilities.getService(testSoln.Id);
        insert testSer;
        ServiceCategory__c testSc1= PGITestUtilities.getSerCategory(testSer.Id, testProd1.Id, true);
        insert testSc1;
        ServiceCategory__c testSc2= PGITestUtilities.getSerCategory(testSer.Id, testProd2.Id, false);
        insert testSc2;
        ServiceCategory__c testSc3= PGITestUtilities.getSerCategory(testSer.Id, testProd3.Id, false);
        insert testSc3;
        ServiceCategory__c testSc4= PGITestUtilities.getSerCategory(testSer.Id, testProd4.Id, true);
        insert testSc4;
        ServiceCategory__c testSc5= PGITestUtilities.getSerCategory(testSer.Id, testProd5.Id, false);
        insert testSc5;
        ServiceCategory__c testSc6= PGITestUtilities.getSerCategory(testSer.Id, testProd6.Id, false);
        insert testSc6;
        
        PriceBook2 pb2Standard = [select Id from Pricebook2 where isStandard=true];
        string standardPriceBookId = pb2Standard.Id;
        
        Product2 testProd= PGITestUtilities.getStdProduct();        
        insert testProd; 
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=standardPriceBookId, Product2Id=testProd.Id, UnitPrice=99, isActive=true);
        insert pbe;    
        
        QuoteLineItem testquoteLineItem1=PGITestUtilities.getServiceQuoteLineItem(testprod1.Id,testSer.Id,testQuote.Id,pbe);
        testquoteLineItem1.BidPrice__c=55.00;
        insert testquoteLineItem1;
        QuoteLineItem testquoteLineItem2=PGITestUtilities.getTestQuoteLineItem(testprod2.Id,testSer.Id,testQuote.Id,pbe,testquoteLineItem1.Id);
        testquoteLineItem2.BidPrice__c=47.00;
        insert testquoteLineItem2;
        QuoteLineItem testquoteLineItem3=PGITestUtilities.getTestQuoteLineItem(testprod3.Id,testSer.Id,testQuote.Id,pbe,testquoteLineItem1.Id);
        testquoteLineItem3.BidPrice__c=43.00;
        insert testquoteLineItem3;   
        QuoteLineItem testquoteLineItem4=PGITestUtilities.getTestQuoteLineItem(testprod4.Id,testSer.Id,testQuote.Id,pbe,testquoteLineItem1.Id);
        testquoteLineItem4.BidPrice__c=37.00;
        insert testquoteLineItem4;   
        QuoteLineItem testquoteLineItem5=PGITestUtilities.getTestQuoteLineItem(testprod5.Id,testSer.Id,testQuote.Id,pbe,testquoteLineItem1.Id);
        testquoteLineItem5.BidPrice__c=32.00;
        insert testquoteLineItem5;   
        QuoteLineItem testquoteLineItem6=PGITestUtilities.getTestQuoteLineItem(testprod6.Id,testSer.Id,testQuote.Id,pbe,testquoteLineItem1.Id);
        testquoteLineItem6.BidPrice__c=27.00;
        insert testquoteLineItem6;   
        QuoteLineItem testquoteLineItem7=PGITestUtilities.getTestQuoteLineItem(testprod7.Id,testSer.Id,testQuote.Id,pbe,testquoteLineItem1.Id);
        testquoteLineItem7.BidPrice__c=5.00;
        insert testquoteLineItem7;   
        
        list<QuoteLineItem> testquolst=new list<QuoteLineItem>(); 
        testquolst.add(testquoteLineItem1); 
        testquolst.add(testquoteLineItem2);
        testquolst.add(testquoteLineItem3);
        testquolst.add(testquoteLineItem4);
        testquolst.add(testquoteLineItem5);
        testquolst.add(testquoteLineItem6);
        testquolst.add(testquoteLineItem7); 
        QuoteStatusUtilities.getApprovalRequiredStatus(testQuote.id);
        list<ServiceCategory__c> testserlst=[Select s.Service__c, s.Product__r.Bid_Price__c, s.Product__r.Auth_Rate6__c, s.Product__r.Auth_Rate5__c, s.Product__r.Auth_Rate4__c, s.Product__r.Auth_Rate3__c, s.Product__r.Auth_Rate2__c, s.Product__r.Auth_Rate1__c, s.Product__r.List_Rate__c, s.Product__c From ServiceCategory__c s limit 40000];
        list<QuoteLineItem> quolinitemlst=updateQuoteLineItemApprovalStatus(testquolst,testserlst,'Level 1');
         //list<QuoteLineItem> quolinitemlst=updateQuoteLineItemApprovalStatus(testquolst,testserlst,'Level 2');
        
        
        
        quolinitemlst=updateQuoteLineItemApprovalStatus(testquolst,testserlst,'Level 1');
        quolinitemlst=updateQuoteLineItemApprovalStatus(testquolst,testserlst,'Level 2');
         quolinitemlst=updateQuoteLineItemApprovalStatus(testquolst,testserlst,'Level 3');
         
        //Assert:Case1
     /*
       system.assertEquals(quolinitemlst[0].Approval_Level__c,'Level 1');
        //Assert:Case2
        system.assertEquals(quolinitemlst[1].Approval_Level__c,'Level 2');
        //Assert:Case3
        system.assertEquals(quolinitemlst[2].Approval_Level__c,'Level 3');
        //Assert:Case4
        system.assertEquals(quolinitemlst[3].Approval_Level__c,'Level 4');
        //Assert:Case5
        system.assertEquals(quolinitemlst[4].Approval_Level__c,'Level 5');
        //Assert:Case6
        system.assertEquals(quolinitemlst[5].Approval_Level__c,'Level 6');   
   
    */
    }
    @istest (seeAlldata=true) 
    private static void test1_updateQuoteLineItemApprovalStatus1() {
        test.startTest();
       
        Test.setCurrentPage(Page.PGIQuoteApprovalAction);
        //Testdata 
        User testUser1=PGITestUtilities.getTestUser(PGITestUtilities.getAdminProfile());
        testUser1.firstName='TestUser1';
        testUser1.Level_Of_Authority__c='Level 1';
        insert testUser1;
        
        User testUser2=PGITestUtilities.getTestUser(PGITestUtilities.getAdminProfile()) ;
        testUser2.firstName='TestUser2';
        testUser2.username='hsoni@pgi.com';        
        testUser2.Level_Of_Authority__c='Level 2';
        insert testUser2;
        
        
        
        Account testAcc= PGITestUtilities.getAccountDetails();
        insert testAcc;
        Opportunity testOpp= PGITestUtilities.getOpportunityDetails();      
        testOpp.Owner_Region__c = 'NA';
        insert testOpp;
        Product2 product = PGITestUtilities.getStdProduct();
        product.Name = 'American Test';
        insert product;
        PricebookEntry pbe2 = PGITestUtilities.CreatePriceBookEntryForProduct(product);
        insert pbe2;
        OpportunityLineItem testOli = PGITestUtilities.getOpportunityLineItemDetails(testOpp.Id, pbe2.Id);
        insert testOli;
        QUOTE_OWNER_REGION = testOpp.Owner_Region__c;
        Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
        insert cont;
        Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        insert testQuote;
        
        Region__c region = PGITestUtilities.getRegionDetails();
        insert region;
        list<Product__c> allProduct= new list<Product__c>();
        Product__c testprod1 = PGITestUtilities.getProductDetails('Add-on','TestAddon','10111111');
        allProduct.add(testProd1);
        //insert testProd1;       
        Product__c testprod2 = PGITestUtilities.getProductDetails('Ancillary','TestAncillary','20111111');
        allProduct.add(testProd2);
        //insert testProd2;
        Product__c testprod3= PGITestUtilities.getProductDetails('Service','testserv','30111111'); 
        allProduct.add(testProd3);
        //insert testProd3;
        Product__c testprod4= PGITestUtilities.getProductDetails('Service','testserv','40111111');
        allProduct.add(testProd4);
        //insert testProd4;
        Product__c testprod5= PGITestUtilities.getProductDetails('Service', 'testserv','50111111');
        allProduct.add(testProd5);
        //insert testProd5;
        Product__c testprod6= PGITestUtilities.getProductDetails('Service', 'testserv','60111111');
        allProduct.add(testProd6);
        //insert testProd6;
        Product__c testprod7= PGITestUtilities.getProductDetails('Service','testserv','70111111');
        allProduct.add(testProd7);
        //insert testProd7;
        insert allProduct;
        Solution__c testSoln = PGITestUtilities.getSolution();
        insert testSoln; 
        Service__c testSer= PGITestUtilities.getService(testSoln.Id);
        insert testSer;
        List<ServiceCategory__c> serCategoryList = new List<ServiceCategory__c>();
        ServiceCategory__c testSc1= PGITestUtilities.getSerCategory(testSer.Id, allProduct.get(0).Id, true);
        serCategoryList.add(testSc1);
        //insert testSc1;
        ServiceCategory__c testSc2= PGITestUtilities.getSerCategory(testSer.Id, allProduct.get(1).Id, false);
        serCategoryList.add(testSc2);
        //insert testSc2;
        ServiceCategory__c testSc3= PGITestUtilities.getSerCategory(testSer.Id, allProduct.get(2).Id, false);
        serCategoryList.add(testSc3);
        //insert testSc3;
        ServiceCategory__c testSc4= PGITestUtilities.getSerCategory(testSer.Id, allProduct.get(3).Id, true);
        serCategoryList.add(testSc4);
        //insert testSc4;
        ServiceCategory__c testSc5= PGITestUtilities.getSerCategory(testSer.Id, allProduct.get(4).Id, false);
        serCategoryList.add(testSc5);
        //insert testSc5;
        ServiceCategory__c testSc6= PGITestUtilities.getSerCategory(testSer.Id, allProduct.get(5).Id, false);
        serCategoryList.add(testSc6);
        //insert testSc6;
        insert serCategoryList;
        
        PriceBook2 pb2Standard = [select Id from Pricebook2 where isStandard=true];
        string standardPriceBookId = pb2Standard.Id;
        
        Product2 testProd= PGITestUtilities.getStdProduct();        
        insert testProd; 
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=standardPriceBookId, Product2Id=testProd.Id, UnitPrice=99, isActive=true);
        insert pbe;    
        List<QuoteLineItem> qliList = new List<QuoteLineItem>();
        QuoteLineItem testquoteLineItem1=PGITestUtilities.getServiceQuoteLineItem(testprod1.Id,testSer.Id,testQuote.Id,pbe);
        testquoteLineItem1.BidPrice__c=55.00;
        qliList.add(testquoteLineItem1);
        //insert testquoteLineItem1;
        QuoteLineItem testquoteLineItem2=PGITestUtilities.getTestQuoteLineItem(testprod2.Id,testSer.Id,testQuote.Id,pbe,testquoteLineItem1.Id);
        testquoteLineItem2.BidPrice__c=47.00;
        qliList.add(testquoteLineItem2);
        //insert testquoteLineItem2;
        QuoteLineItem testquoteLineItem3=PGITestUtilities.getTestQuoteLineItem(testprod3.Id,testSer.Id,testQuote.Id,pbe,testquoteLineItem1.Id);
        testquoteLineItem3.BidPrice__c=43.00;
        qliList.add(testquoteLineItem3);
        //insert testquoteLineItem3;   
        QuoteLineItem testquoteLineItem4=PGITestUtilities.getTestQuoteLineItem(testprod4.Id,testSer.Id,testQuote.Id,pbe,testquoteLineItem1.Id);
        testquoteLineItem4.BidPrice__c=37.00;
        qliList.add(testquoteLineItem4);
        //insert testquoteLineItem4;   
        QuoteLineItem testquoteLineItem5=PGITestUtilities.getTestQuoteLineItem(testprod5.Id,testSer.Id,testQuote.Id,pbe,testquoteLineItem1.Id);
        testquoteLineItem5.BidPrice__c=32.00;
        qliList.add(testquoteLineItem5);
        //insert testquoteLineItem5;   
        QuoteLineItem testquoteLineItem6=PGITestUtilities.getTestQuoteLineItem(testprod6.Id,testSer.Id,testQuote.Id,pbe,testquoteLineItem1.Id);
        testquoteLineItem6.BidPrice__c=27.00;
        qliList.add(testquoteLineItem6);
        //insert testquoteLineItem6;   
        QuoteLineItem testquoteLineItem7=PGITestUtilities.getTestQuoteLineItem(testprod7.Id,testSer.Id,testQuote.Id,pbe,testquoteLineItem1.Id);
        testquoteLineItem7.BidPrice__c=5.00;
        qliList.add(testquoteLineItem7);
        //insert testquoteLineItem7;   
        insert qliList;
        
        QuoteStatusUtilities.getApprovalRequiredStatus(testQuote.id);
        list<ServiceCategory__c> testserlst=[Select s.Service__c, s.Product__r.Bid_Price__c, s.Product__r.Auth_Rate6__c, s.Product__r.Auth_Rate5__c, s.Product__r.Auth_Rate4__c, s.Product__r.Auth_Rate3__c, s.Product__r.Auth_Rate2__c, s.Product__r.Auth_Rate1__c, s.Product__r.List_Rate__c, s.Product__c From ServiceCategory__c s limit 40000];
        list<QuoteLineItem> quolinitemlst=updateQuoteLineItemApprovalStatus(qliList,testserlst,'Level 1');
         //list<QuoteLineItem> quolinitemlst=updateQuoteLineItemApprovalStatus(testquolst,testserlst,'Level 2');
        
        QuoteStatusUtilities.updateQuoteStatus(testQuote.Id,QCStatusValues__c.getInstance(PGIQuoteStatusEnum.PricingApproved.name()).StatusValue__c);
         QuoteStatusUtilities.updateApprovalStatus(testQuote.Id,'Approved');
        
        
        
        quolinitemlst=updateQuoteLineItemApprovalStatus(qliList,testserlst,'Level 4');
        quolinitemlst=updateQuoteLineItemApprovalStatus(qliList,testserlst,'Level 5');
         quolinitemlst=updateQuoteLineItemApprovalStatus(qliList,testserlst,'Level 6');
         
        //Assert:Case1
     /*
       system.assertEquals(quolinitemlst[0].Approval_Level__c,'Level 1');
        //Assert:Case2
        system.assertEquals(quolinitemlst[1].Approval_Level__c,'Level 2');
        //Assert:Case3
        system.assertEquals(quolinitemlst[2].Approval_Level__c,'Level 3');
        //Assert:Case4
        system.assertEquals(quolinitemlst[3].Approval_Level__c,'Level 4');
        //Assert:Case5
        system.assertEquals(quolinitemlst[4].Approval_Level__c,'Level 5');
        //Assert:Case6
        system.assertEquals(quolinitemlst[5].Approval_Level__c,'Level 6');   
   
    */
    }
}