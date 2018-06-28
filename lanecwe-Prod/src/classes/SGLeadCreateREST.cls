/**** This class is REST API used by sales gateway to create Lead. Once Lead is created succesfully trigger logic will convert this Lead.
 Salesgateway scenario: This API will be executed when contract is send to customer.
****/
@RestResource(urlMapping='/SGLeadCreate/*')
global with sharing class SGLeadCreateREST {
  	public static boolean sendemail = false;
    /*** this is the data class used to serialize error message back to SG ***/
    global class SGErrorResponse{
        string errormessage;
    }
    
    /*** This method upserts Lead based on the LeadID passed from SG ***/
    @HttpPost
    global static String SGLeadCreate(){
        string response;
        string errormessage;
        Logs__c logerror 				= new Logs__c();   
        try {
        /*** Recieving data from salesgateway and deserializing into local data class(SGLeadRequest) Format. ***/
        SGLeadRequest SGReqData =  (SGLeadRequest)JSON.deserialize(
                        RestContext.request.requestbody.tostring(),SGLeadRequest.class);
		system.debug('SGReqData:'+SGReqData);
        logerror.Class_Name__c 			= 'SGLeadCreateREST';    
        logerror.Method_Name__c 		= 'SGLeadCreate';
        logerror.Object_Name__c 		= 'Lead';
		logerror.Request__c				= string.valueOf(SGReqData);
        logerror.Z_Source__c			= SGReqData.source;    
        logerror.Status__c				= 'Success';    
        logerror.Error_Message__c		= 'NA';
        logerror.Exception_Cause__c		= 'NA';
        logerror.Exception_Message__c	= 'NA';
        logerror.EndPoint_Url__c		= 'NA';
        logerror.Record_ID__c			= 'NA';
        logerror.Exception_Type__c		= 'NA';
            
        Lead Insertld = setLeadRecord(SGReqData);
        upsert Insertld;
        
        SGSuccessResponse resp 			= new SGSuccessResponse();
        
        Lead ldRespData = [select id, convertedaccountid, convertedcontactid, convertedopportunityid from lead where id = :Insertld.id];

        /*** Invoke method to insert license sets ***/
        List<SGLeadRequest.Products> ProductDetails1 = new List<SGLeadRequest.Products>(SGReqData.ProductsOfInterest);
        logerror.Object_Name__c 		= 'Lead';
        logerror.Method_Name__c 		= 'InsertLicset';
        InsertLicset(ProductDetails1, ldRespData.convertedopportunityid);
        logerror.Object_Name__c 		= 'OpportunityLineItem';
        logerror.Method_Name__c 		= 'Insertproducts';
        Insertproducts(ProductDetails1, ldRespData.convertedopportunityid);
        
        /*** Setting data For success response back to SG ***/
        Account AcctData = [select SFDC_Account_ID__c,(select Id from CONMAN_Contracts__r) from Account where id=:ldRespData.convertedaccountid];
        List<CONMAN_Contract__c> CntractData = new list<CONMAN_Contract__c>(AcctData.CONMAN_Contracts__r);
        //updating just trigger email trigger
        sendemail = true;
        update CntractData;
        sendemail = false;    
            
        resp.SFDCAccountID  			= AcctData.SFDC_Account_ID__c;
        resp.contractId     			= CntractData[0].Id;
        resp.accountId      			= ldRespData.convertedaccountid;
        resp.opportunityId  			= ldRespData.convertedopportunityid;
        resp.contactId  				= ldRespData.convertedcontactid;

        response 						= JSON.serialize(resp);
        Insert logerror;
        return response;
        }
        catch(Exception e){ 
        /*** Setting data For error response back to SG ***/
            SGErrorResponse ErrorData = new SGErrorResponse();
            ErrorData.errormessage =e.getMessage();
            response = JSON.serialize(ErrorData);       

	        logerror.Status__c				= 'Failure';    
	        //logerror.Method_Name__c 		= 'SGLeadCreate';
            logerror.Error_Message__c		= e.getMessage();
            logerror.Exception_Cause__c		= string.valueof(e.getcause());
            logerror.Exception_Message__c	= e.getStackTraceString();
	        logerror.Exception_Type__c		= e.getTypeName();
            logerror.Response__c			= response;
	        Insert logerror;
    
            return response;        
        }
    }

    /*** This method inserts license sets and relates them to opportunity ***/   
    public static Void InsertLicset(List<SGLeadRequest.Products> ProductDetails1, id opptyId){
        List<LicenseSet__c> LicsetToInsert1 = new List<LicenseSet__c>();

        For(SGLeadRequest.Products PrdctsToInsert : ProductDetails1){
            LicenseSet__c LicsetToInsert = new LicenseSet__c();

            If (LicsetToInsert.Enterprise_Name__c <> null)
            	LicsetToInsert.Enterprise_Name__c               = PrdctsToInsert.EnterpriseName;
           
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
    	        LicsetToInsert.Number_of_Licensed_Named_Users__c = 300;
            }else{
    	        LicsetToInsert.Number_of_Licensed_Named_Users__c = PrdctsToInsert.Quantity;
            }
            }
            LicsetToInsert1.add(LicsetToInsert);    
      }
      Insert LicsetToInsert1;
    }

    /*** This method inserts opportunity line items (opportunity products) ***/   
    public static Void Insertproducts(List<SGLeadRequest.Products> Opptyproducts, id opptyId){
        List<OpportunityLineItem> Insertproducts = new List<OpportunityLineItem>();
        For(SGLeadRequest.Products PrdctsToInsert : Opptyproducts){
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

    /*** This method prepares data For lead insert ***/   
    public static lead setLeadRecord(SGLeadRequest SGReqData){
       Lead ldInsertData = new Lead();
       /*** Data from Salesgateway ***/
       If(SGReqData.LeadID<> null){
          ldInsertData.ID    			= SGReqData.LeadID;
       }    
       ldInsertData.SlesgatewayID__c    = SGReqData.SlesgatewayID;
       ldInsertData.Company             = SGReqData.Company;
       ldInsertData.FirstName           = SGReqData.CustomerFirstName;
       ldInsertData.LastName            = SGReqData.CustomerLastName;
       ldInsertData.Phone               = SGReqData.Phone;
       ldInsertData.Email               = SGReqData.Email;
       ldInsertData.Street              = SGReqData.Street;
       ldInsertData.City                = SGReqData.City;
       ldInsertData.State               = SGReqData.State;
       ldInsertData.PostalCode          = SGReqData.PostalCode;
       ldInsertData.Country             = SGReqData.Country;
       ldInsertData.ContractURL__c      = SGReqData.ContractURL;
       ldInsertData.z_Source__c			= SGReqData.Source;
       /*** Retrieving rep uer id from user object to set as owner of Lead ***/
       User userdata                    = [select Id from user where LastName = :SGReqData.RepLastName and FirstName = :SGReqData.RepFirstName];
       ldInsertData.OwnerId             = userdata.Id;
       /*** Data from custom Labels ***/
       if(ldInsertData.LeadSource  != null){
       		ldInsertData.LeadSource = System.Label.LeadSource;
       }
       ldInsertData.ChannelType__c      = System.Label.ChannelType;
       ldInsertData.Status              = System.Label.LeadStatus;
       ldInsertData.DoNotCall           = Boolean.valueof(System.Label.DoNotSolicit);
       ldInsertData.Business_Type__c    = integer.valueof(System.Label.BusinessType);
        
        if(ldInsertData.Omniture_Campaign_Code__c != null){
            ldInsertData.Omniture_Campaign_Code__c = System.Label.OmnitureCampaignCode;
        }
       return ldInsertData;
    }
}