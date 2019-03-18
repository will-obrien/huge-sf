/**** This class is REST API used by sales gateway to update existing Account,Opportunity,Contract,Licenseset,Opportunity Product and contact.
Salesgateway scenario: If customer request For any changes in old contract beFore accepting the contract then SG will modIfy old contract and 
sends to customer, this API will be invoked during this process to update SFDC objects.
****/
@RestResource(urlMapping='/SGAccountUpdate/*')
global with sharing class SGAccountUpdateREST {

 	Global class successresponse {
    	public string Message;
    	public String contractId;
    }	  
    
    /*** This method updates Account, contact and deletes Licenseset and Opportunity Products***/
    @HttpPost
    global static String SGAccountUpdate(){
        Logs__c logerror 										= new Logs__c();
        successresponse successresponse							= new successresponse();
        string Response;
        try {
        /*** recieving data from salesgateway and deserializing into local data class(SGAccountUpdateRequest) Format. ***/
        SGAccountUpdateRequest SGReqData 						= (SGAccountUpdateRequest)JSON.deserialize(
                       											   RestContext.request.requestbody.tostring(),SGAccountUpdateRequest.class);

        logerror.Class_Name__c 									= 'SGAccountUpdateREST';    
	    logerror.Method_Name__c 								= 'SGAccountUpdate';
        logerror.Object_Name__c 								= 'Account';
        logerror.Record_ID__c									= SGReqData.accountId;
		logerror.Request__c										= string.valueOf(SGReqData);
        logerror.Z_Source__c									= SGReqData.source;    
        logerror.Status__c										= 'Success';    
        logerror.Error_Message__c								= 'NA';
        logerror.Exception_Cause__c								= 'NA';
        logerror.Exception_Message__c							= 'NA';
        logerror.EndPoint_Url__c								= 'NA';
        logerror.Exception_Type__c								= 'NA';
       
        /*** Update Account ***/  
        Account UpdateAcct	 									= [select Name,OwnerId,Phone,BillingStreet,BillingCity,BillingPostalCode,
                                           						   BillingState,BillingCountry,SlesgatewayID__c,Legal_Name_Indicator__c,Z_Source__c 
                                                                   from Account where Id = :SGReqData.accountId];
        User userdata                   						= [select Id from user where LastName = :SGReqData.RepLastName 
                                                                   and FirstName = :SGReqData.RepFirstName];
        if(UpdateAcct.Legal_Name_Indicator__c <> true){
           UpdateAcct.Name 			    						= SGReqData.Company;
        }
        UpdateAcct.Phone 			    						= SGReqData.Phone;
        UpdateAcct.BillingStreet 								= SGReqData.Street;
        UpdateAcct.BillingCity 									= SGReqData.City;
        UpdateAcct.BillingPostalCode 							= SGReqData.PostalCode;
        UpdateAcct.BillingState 								= SGReqData.State;
        UpdateAcct.BillingCountry 								= SGReqData.Country;
        UpdateAcct.SlesgatewayID__c 							= SGReqData.SlesgatewayID;
        UpdateAcct.OwnerId 										= userdata.Id;
        UpdateAcct.Z_Source__c									= SGReqData.source;    
            
        Update UpdateAcct;

         /*** Update Opportunity ***/  
        Opportunity UpdateOppty	 								= [select SlesgatewayID__c,ownerid,Z_Source__c
                                                                   from Opportunity where Id = :SGReqData.opportunityId];
        UpdateOppty.SlesgatewayID__c 							= SGReqData.SlesgatewayID;
        UpdateOppty.OwnerId 									= userdata.Id;
        UpdateOppty.Z_Source__c									= SGReqData.source;    
        Update UpdateOppty;

            
        /*** Update Contact ***/  
        logerror.Object_Name__c 								= 'Contact';
        logerror.Record_ID__c									= SGReqData.contactId;
        Contact UpsertCntct 									= new Contact(); 
        If(SGReqData.contactId <> null){
        UpsertCntct	 											= [select Id,FirstName,LastName,Email,Phone,OwnerId,MailingStreet,MailingCity,
                                                                   MailingPostalCode,MailingState,MailingCountry,z_Source__c 
                                                                   from Contact where Id = :SGReqData.contactId];
        } 
        UpsertCntct.FirstName 									= SGReqData.CustomerFirstName;
        UpsertCntct.LastName 									= SGReqData.CustomerLastName;
        UpsertCntct.Email 										= SGReqData.Email;
        UpsertCntct.Phone 										= SGReqData.Phone;
        UpsertCntct.OwnerId 									= userdata.Id;
        UpsertCntct.MailingStreet 								= SGReqData.Street;
        UpsertCntct.MailingCity 								= SGReqData.City;
        UpsertCntct.MailingPostalCode 							= SGReqData.PostalCode;
        UpsertCntct.MailingState 								= SGReqData.State;
        UpsertCntct.MailingCountry 								= SGReqData.Country;
        UpsertCntct.OwnerId 									= userdata.Id;
        UpsertCntct.z_Source__c 								= SGReqData.source;
        Upsert UpsertCntct;
            
        /*** Delete Licensesets and Products ***/ 
        try{
        Opportunity Opptylicset	 								= [select Name,(Select Id from LicenseSets__r ),(Select Id from OpportunityLineItems)
                                               						from Opportunity where Id = :SGReqData.opportunityId];
        If(Opptylicset.LicenseSets__r <> null){
	       logerror.Object_Name__c 								= 'Licenseset__c';
	       logerror.Record_ID__c								= 'NA';
           List<LicenseSet__c> deletelicset						= Opptylicset.LicenseSets__r;

           Delete deletelicset;
        }
        
        If(Opptylicset.OpportunityLineItems <> null){}    
	       logerror.Object_Name__c 								= 'OpportunityLineItems';
	       logerror.Record_ID__c								= 'NA';
 	       List<OpportunityLineItem> deleteprdcts				= Opptylicset.OpportunityLineItems;
           Delete deleteprdcts;     
        } catch(QueryException e){
        /*** no action needed as the flow needs to continue ***/  
        }
         catch(exception e){
    	  logerror.Record_ID__c									= 'NA';
	      logerror.Status__c									= 'Failure';    
	      logerror.Method_Name__c 								= 'SGAccountUpdate';
          logerror.Error_Message__c								= e.getMessage();
          logerror.Exception_Cause__c							= string.valueof(e.getcause());
          logerror.Exception_Message__c							= e.getStackTraceString();
	      logerror.Exception_Type__c							= e.getTypeName();
          logerror.Response__c									= e.getMessage();
	      Insert logerror;
          
          Response = e.getMessage();      
          return Response;        
        }
            
        /*** Update Contract ***/ 
	    logerror.Object_Name__c 								= 'CONMAN_Contract__c';
	    logerror.Record_ID__c									= SGReqData.contractId;
            
        CONMAN_Contract__c InsertContrct 						= new CONMAN_Contract__c();  
        If(SGReqData.contractId <> null){
           CONMAN_Contract__c UpdateContrct 					= [select z_Source__c,Contract_URL__c,ownerid,SlesgatewayID__c
                                                                   from CONMAN_Contract__c where Id = :SGReqData.contractId];
		   UpdateContrct.Contract_URL__c						= SGReqData.ContractURL;
		   UpdateContrct.SlesgatewayID__c						= SGReqData.SlesgatewayID;
		   UpdateContrct.ownerid								= userdata.Id;
	       UpdateContrct.z_Source__c 							= SGReqData.source;
		   Update UpdateContrct;
        }else{
           InsertContrct.Account_Name__c 						= SGReqData.accountId;
           InsertContrct.Opportunity__c 						= SGReqData.opportunityId;
           InsertContrct.Contract_URL__c 						= SGReqData.ContractURL;
           InsertContrct.Date_Submitted__c 						= date.today();
           InsertContrct.Legal_Approval_Status__c 				= 'Not Required';
           InsertContrct.Pricing_Approval_Status__c 			= 'Not Required';
           InsertContrct.Contract_Status__c 					= 'Sent To Customer';
           InsertContrct.SlesgatewayID__c 						= SGReqData.SlesgatewayID;
           InsertContrct.Ownerid 								= userdata.Id;
           InsertContrct.z_Source__c 							= SGReqData.source;
           insert InsertContrct;  
        }    

       /*** Insert Licensesets and Products ***/ 
        List<SGAccountUpdateRequest.Products> ProductDetails 	= new List<SGAccountUpdateRequest.Products>(SGReqData.ProductsOfInterest);
        logerror.Method_Name__c 								= 'InsertLicset';
    	logerror.Record_ID__c									= 'NA';
        InsertLicset(ProductDetails, SGReqData.opportunityId);
        logerror.Method_Name__c 								= 'InsertProducts';
        InsertProducts(ProductDetails, SGReqData.opportunityId);
		successresponse.message									= 'Status updated successfully'; 
        If(SGReqData.contractId <> null)
        	successresponse.contractId 							= SGReqData.contractId;  
        else
        	successresponse.contractId 							= InsertContrct.ID;  
            
        logerror.Method_Name__c 								= 'SGAccountUpdate';
        logerror.Response__c									= string.valueof(successresponse);
        Insert logerror;
        return json.serialize(successresponse);        
        } catch(Exception e){
        /*** setting error message back to SG ***/  
          Response = e.getMessage();      

	      logerror.Status__c									= 'Failure';    
          logerror.Error_Message__c								= e.getMessage();
          logerror.Exception_Cause__c							= string.valueof(e.getcause());
          logerror.Exception_Message__c							= e.getStackTraceString();
          logerror.Response__c									= response;
	      logerror.Exception_Type__c							= e.getTypeName();
	      Insert logerror;

          return Response;        
        }
    }

    /*** This method inserts license sets and relates them to opportunity ***/   
    public static Void InsertLicset(List<SGAccountUpdateRequest.Products> ProductDetails1, id opptyId){
        List<LicenseSet__c> LicsetToInsert1 					= new List<LicenseSet__c>();

        For(SGAccountUpdateRequest.Products PrdctsToInsert : ProductDetails1){
            LicenseSet__c LicsetToInsert 						= new LicenseSet__c();

            If (LicsetToInsert.Enterprise_Name__c <> null)
            LicsetToInsert.Enterprise_Name__c               	= PrdctsToInsert.EnterpriseName;
            LicsetToInsert.Product_Name__c						= PrdctsToInsert.ProductName;
            LicsetToInsert.Number_of_Licensed_Named_Users__c    = PrdctsToInsert.Quantity;
            LicsetToInsert.Subscription_License_Term_Months__c  = PrdctsToInsert.Contractterm;
            LicsetToInsert.Start_Date__c                        = date.valueof(PrdctsToInsert.StartDate);
            LicsetToInsert.End_Date__c                          = date.valueof(PrdctsToInsert.EndDate);
            LicsetToInsert.Opportunity__c                       = opptyId;
            LicsetToInsert.z_Source__c                       	= 'Salesgateway';
            LicsetToInsert.Price__c								= PrdctsToInsert.UnitPrice;
               
            If (PrdctsToInsert.Mincommitment == 'true' && PrdctsToInsert.UnitType == 'Minutes'){
    	        LicsetToInsert.Number_of_Licensed_Named_Users__c = PrdctsToInsert.mincmmtamount/PrdctsToInsert.UnitPrice;
            }
            else{
            If (PrdctsToInsert.Mincommitment == 'false' && PrdctsToInsert.UnitType == 'Minutes'){
    	        LicsetToInsert.Number_of_Licensed_Named_Users__c  = 300;
            }else{
    	        LicsetToInsert.Number_of_Licensed_Named_Users__c  = PrdctsToInsert.Quantity;
            }
            }
            LicsetToInsert1.add(LicsetToInsert);    
        }
        Insert LicsetToInsert1;
    }

    /*** This method inserts opportunity line items (opportunity products) ***/   
    public static Void InsertProducts(List<SGAccountUpdateRequest.Products> Opptyproducts, id opptyId){
        List<OpportunityLineItem> Insertproducts 					= new List<OpportunityLineItem >();
		system.debug('Insertproducts:'+Insertproducts);
        For(SGAccountUpdateRequest.Products PrdctsToInsert : Opptyproducts){
            If(PrdctsToInsert.UnitType == 'Licenses'){
 	            OpportunityLineItem opptyproducts1 					= new OpportunityLineItem();
                Product_Mappings__c productmappings = [select SFDC_Product_ID__c,SFDC_PB_Entry_ID__c from Product_Mappings__c 
                                                       where Source_Product_Name__c = :PrdctsToInsert.ProductName];
                opptyproducts1.OpportunityId						= opptyId;
                opptyproducts1.PricebookEntryId						= productmappings.SFDC_PB_Entry_ID__c;
                opptyproducts1.New_Sales_Price__c					= PrdctsToInsert.UnitPrice;
                opptyproducts1.Billing_Frequency__c    				= PrdctsToInsert.BillingFrequency;
                opptyproducts1.Contract_Term__c						= PrdctsToInsert.Contractterm;
                opptyproducts1.Min_Commit__c  						= boolean.valueof(PrdctsToInsert.mincommitment);
                opptyproducts1.New_Quantity__c				        = PrdctsToInsert.Quantity;
                opptyproducts1.Unit_Type__c				        	= PrdctsToInsert.UnitType;
                opptyproducts1.z_Source__c				        	= 'Salesgateway';
                Insertproducts.add(opptyproducts1);
            } 
            else{
                OpportunityLineItem opptyproducts2 					= new OpportunityLineItem();
                Product_Mappings__c productmappings = [select SFDC_Product_ID__c,SFDC_PB_Entry_ID__c from Product_Mappings__c 
                                                       where Source_Product_Name__c = :PrdctsToInsert.ProductName];
                opptyproducts2.OpportunityId						= opptyId;
                opptyproducts2.PricebookEntryId						= productmappings.SFDC_PB_Entry_ID__c;
                opptyproducts2.New_Sales_Price__c					= PrdctsToInsert.UnitPrice;
                opptyproducts2.Billing_Frequency__c    				= PrdctsToInsert.BillingFrequency;
                opptyproducts2.Contract_Term__c						= PrdctsToInsert.Contractterm;
                opptyproducts2.Min_Commit__c  						= boolean.valueof(PrdctsToInsert.mincommitment);
                opptyproducts2.Unit_Type__c				        	= PrdctsToInsert.UnitType;
                opptyproducts2.z_Source__c				        	= 'Salesgateway';
               
                If (opptyproducts2.Min_Commit__c == true && PrdctsToInsert.UnitType == 'Minutes'){
    	            opptyproducts2.New_Quantity__c				    = PrdctsToInsert.mincmmtamount/PrdctsToInsert.UnitPrice;
                }
                else{
                If (opptyproducts2.Min_Commit__c == false && PrdctsToInsert.UnitType == 'Minutes'){
    	            opptyproducts2.New_Quantity__c				    = 300;
                }else{
    	            opptyproducts2.New_Quantity__c				    = PrdctsToInsert.Quantity;
                }
                }
                Insertproducts.add(opptyproducts2);
            }
        }
        Insert Insertproducts;
    }
}