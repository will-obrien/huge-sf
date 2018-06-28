public with sharing class CreateDraftContractFromContract {


 contract cont;
 String products = '';
   	
    public CreateDraftContractFromContract(ApexPages.StandardController stdController) { 
        cont = (Contract)stdController.getRecord();     
       
    }

    public PageReference Create() {
        PageReference pageRef = null;
        try{
            
       		Decimal EuroConversionRate = 0;
			Decimal PoundsConversionRate=0;     
            CurrencyRates__c mc = CurrencyRates__c.getOrgDefaults();			
					EuroConversionRate	= mc.EuroConversionRate__c;
					PoundsConversionRate= mc.BritishPoundConversionRate__c;	
           
			Contract cont = [Select Date_EagleEye_User_Count_Updated__c, Contract_Term_Length_Yrs__c, Year_1_Maintenance_Amount_EagleEye__c, Year_1_Maintenance_Amount_DocXtools__c,Year_1_Maintenance_Amount_3BClean__c,contractNumber, original_contract_name__c, original_contract_date__c, startdate, enddate, account.industry, account.Client_Relations_Account_Owner__c,Id,AccountId,OwnerExpirationNotice,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,ContractTerm,OwnerId,Status,CompanySignedId,CompanySignedDate,CustomerSignedId,CustomerSignedTitle,CustomerSignedDate,SpecialTerms,ActivatedById,ActivatedDate,StatusCode,Description,Name,LastApprovedDate,LastActivityDate,Contract_Type__c,Contract_Sub_Type__c,Budget_Letter_Sent__c,Budget_Letter_Sent_Date__c,Addendum_Sent__c,Addendum_Sent_Date__c,In_Negotiation__c,In_Negotiation_Date__c,Customer_Signed__c,Agreement_Termination_Notice_Sent__c,Agreement_Termination_Notice_Sent_Date__c,Software_Removal_Acknowledgement_Recd__c,Software_Removal_Acknowledgement_Date__c,Legacy_Contract_ID__c,Out_Clause__c,Annual_Renewal__c,Billing_Contact__c,Legacy_Client_ID__c,Maintenance_Letter__c,DocXchange_with_KP__c,Number_of_Documents__c,Year1_Billing_Date__c,Year2_Billing_Date__c,Year3_Billing_Date__c,Previous_Term_Contract__c,Originating_Opportunity__c,SF_Migration_Id__c,Enterprise_License__c,InSituSCV__Billing_Address_ISO__c,InSituSCV__Billing_Address_Status__c,InSituSCV__Shipping_Address_ISO__c,InSituSCV__Shipping_Address_Status__c,Annual_True_Up__c,US_3BClean_Users__c,UK_3BClean_Users__c,X3BClean_User_Counts_Date__c,Number_of_PS_Days_Provided_at_No_Charge__c,Pre_purchased_PS_Days_Total_Billing__c,Number_of_offices__c,Year_1_Billing_Amount_Services__c,Year_2_Billing_Amount_Services__c,Year_3_Billing_Amount_Services__c,Year_4_Billng_Amount_Services__c,Year_4_Services_of_Days_del__c,Year_1_Billing_Amount_Software__c,Year_2_Billing_Amount_Software__c,Year_3_Billing_Amount_Software__c,Year_4_Billing_Amount_Software__c,NDA__c,EagleEye_Users__c,Increase_Cap__c,Currency_Type__c,Red_Yellow_Green__c,Total_Number_of_Pre_Purchased_Svc_Days__c,Services_of_Pre_purchased_Days__c,Average_Billing_Amount_Services__c,Average_Billing_Amount_Software__c,Primary_Agreement_Recipient__c,Secondary_Agreement_Recipient__c,Year_1_Billing_Amount_EagleEye__c,Year_2_Billing_Amount_EagleEye__c,Year_4_Billing_Amount_EagleEye__c,Year_3_Billing_Amount_EagleEye__c,Year_1_Billing_Amount_3BClean__c,Year_2_Billing_Amount_3BClean__c,Year_3_Billing_Amount_3BClean__c,Year_4_Billing_Amount_3BClean__c,Average_Billing_Amount_EagleEye__c,Average_Billing_Amount_3BClean__c,Fiscal_Year_End__c,Pre_purchased_PS_Days_Discounted_Dai__c,PS_Days_Total_Actual_Value__c,Total_PS_Days_Used__c,Billing_Term_Net_Days__c,Previous_Contract_ID__c from Contract WHERE Id=:cont.Id];
			
			
				
			
			for (contract_product__c cp : [select product__c, contract__r.account.industry, contract__r.account.BillingCountry from contract_product__c where contract__r.id =:cont.Id and product__c != 'Services' ])
				{
						if (products == '')
						{
							products = cp.product__c;
						}
						else if (products != '')
						{
							products = products + ',' + cp.product__c;
						
						}
			
				}
			
			integer term = cont.Contract_Term_Length_Yrs__c.intValue();
			//Process contract products

			
			
			DraftContractPercentIncrease__c draftIncrease = DraftContractPercentIncrease__c.getOrgDefaults();
			Decimal IncreasePercent = draftIncrease.Percent_Increase__c;
			Decimal OneYearPercentIncrease = draftIncrease.One_Year_Percent_Increase__c;
			system.debug('increasepercent = ' + IncreasePercent);
						
            //Create the new contract
     
            Contract newContract = cont.clone(false,true,false,false);
            
            newContract.Contract_Type__c = 'Renewal';
            newContract.Previous_Term_Contract__c = cont.Id;
			newContract.Previous_Contract_ID__c = cont.Id;
			newContract.StartDate = cont.EndDate + 1;
            newcontract.Prior_Contract_Start_Date__c = cont.StartDate;
            newcontract.Prior_Contract_End_Date__c = cont.EndDate;
            newContract.status = 'Draft';
            system.debug('checking some cont fields');
            system.debug(cont.Contract_Sub_Type__c);
            
            //Check LexisDraft checkbox if one of the CPs is LexisDraft
            if (products.containsIgnoreCase('Lexis')) {
			newContract.Lexis_Draft_EagleEye__c = True;
			}
            
            
            
            
            //Perpetual specific logic
            if (cont.Contract_Sub_Type__c == 'Perpetual'){  
           				 newContract.EndDate = cont.EndDate + 366;
           				 newContract.Activation_End_Date_WF__c = cont.EndDate + 366;
            				
            
                                If (cont.Contract_Term_Length_Yrs__c == 1)
                                {
                                    If (cont.Year_1_Maintenance_Amount_3BClean__c != null) {
                                        newcontract.Year_1_Maintenance_Amount_3BClean__c = roundMe(((cont.Year_1_Maintenance_Amount_3BClean__c * IncreasePercent) + cont.Year_1_Maintenance_Amount_3BClean__c), 250);
                                        newcontract.Year_1_Billing_Amount_3BClean__c = roundMe(((cont.Year_1_Maintenance_Amount_3BClean__c * IncreasePercent) + cont.Year_1_Maintenance_Amount_3BClean__c), 250);
                                        
                                   		 }	


                                    If (cont.Year_1_Maintenance_Amount_DocXtools__c != null) {
                                        newcontract.Year_1_Maintenance_Amount_DocXtools__c = roundMe(((cont.Year_1_Maintenance_Amount_DocXtools__c * IncreasePercent) + cont.Year_1_Maintenance_Amount_DocXtools__c), 250);
                                        newcontract.Year_1_Billing_Amount_Software__c = roundMe(((cont.Year_1_Maintenance_Amount_DocXtools__c * IncreasePercent) + cont.Year_1_Maintenance_Amount_DocXtools__c), 250);
                                        
                                    }


                                    If (cont.Year_1_Maintenance_Amount_EagleEye__c != null) {
                                        newcontract.Year_1_Maintenance_Amount_EagleEye__c = roundMe(((cont.Year_1_Maintenance_Amount_EagleEye__c * IncreasePercent) + cont.Year_1_Maintenance_Amount_EagleEye__c), 250);
                                        newcontract.Year_1_Billing_Amount_EagleEye__c = roundMe(((cont.Year_1_Maintenance_Amount_EagleEye__c * IncreasePercent) + cont.Year_1_Maintenance_Amount_EagleEye__c), 250);
                                        
                                    }
                                }


                                
            	}
            	//non perpetual (subscription) logic
             else {
             	
             	system.debug('term=');
             	system.debug(term);
            	newcontract.EndDate = cont.endDate.AddYears(term);
            	newcontract.Activation_End_Date_WF__c = cont.endDate.AddYears(term);
            	
            	If (cont.Contract_Term_Length_Yrs__c == 1)
            	{

                                    If (cont.Year_1_Billing_Amount_Software__c != null)
                                    		{
                                        Integer newYear1Software = RoundMe(((cont.Year_1_Billing_Amount_Software__c * 	oneYearPercentIncrease) + cont.Year_1_Billing_Amount_Software__c), 500);
                                        newcontract.Year_1_Billing_Amount_Software__c = newYear1Software;
                                            }

                                    //Next, do EagleEye
                                    If (cont.Year_1_Billing_Amount_EagleEye__c != null )
                                    			{
                                    				system.debug('one uear contract - EE year 1 amount =' + cont.Year_1_Billing_Amount_EagleEye__c);
                                       Integer newYear1EagleEye  = RoundMe(((cont.Year_1_Billing_Amount_EagleEye__c * oneYearPercentIncrease) + cont.Year_1_Billing_Amount_EagleEye__c), 500);
                                        newcontract.Year_1_Billing_Amount_EagleEye__c = newYear1EagleEye;
                                        system.debug('newYear1EagleEye=' + newYear1EagleEye);
                                        		}

                                    //Next, do 3BClean
                                    If (cont.Year_1_Billing_Amount_3BClean__c != null)
                                    				{
                                        Integer newYear13BClean = RoundMe(((cont.Year_1_Billing_Amount_3BClean__c * oneYearPercentIncrease) + cont.Year_1_Billing_Amount_3BClean__c), 500);
                                        newcontract.Year_1_Billing_Amount_3BClean__c = newYear13BClean;
                                     				 }
            	}
            	
            	
            	If (cont.Contract_Term_Length_Yrs__c == 2)
            	{

                                    If (cont.Year_2_Billing_Amount_Software__c != null)
                                    		{
                                        Integer newYear1Software = RoundMe(((cont.Year_2_Billing_Amount_Software__c * 	IncreasePercent) + cont.Year_2_Billing_Amount_Software__c), 500);
                                        newcontract.Year_1_Billing_Amount_Software__c = newYear1Software;
                                        Integer newYear2Software = RoundMe((newYear1Software * IncreasePercent) + newYear1Software, 500);
										newcontract.Year_2_Billing_Amount_Software__c = newYear2Software;
                                            }

                                    //Next, do EagleEye
                                    If (cont.Year_2_Billing_Amount_EagleEye__c != null )
                                    			{
                                       Integer newYear1EagleEye  = RoundMe(((cont.Year_2_Billing_Amount_EagleEye__c * IncreasePercent) + cont.Year_2_Billing_Amount_EagleEye__c), 500);
                                        newcontract.Year_1_Billing_Amount_EagleEye__c = newYear1EagleEye;
                                        Integer newYear2EagleEye = RoundMe((newYear1EagleEye * IncreasePercent) + newYear1EagleEye, 500);
										newcontract.Year_2_Billing_Amount_EagleEye__c = newYear2EagleEye;
                                        		}

                                    //Next, do 3BClean
                                    If (cont.Year_2_Billing_Amount_3BClean__c != null)
                                    				{
                                        Integer newYear13BClean = RoundMe(((cont.Year_2_Billing_Amount_3BClean__c * IncreasePercent) + cont.Year_2_Billing_Amount_3BClean__c), 500);
                                        newcontract.Year_1_Billing_Amount_3BClean__c = newYear13BClean;
                                        Integer newYear23BClean = RoundMe((newYear13BClean * IncreasePercent) + newYear13BClean, 500);
										newcontract.Year_2_Billing_Amount_3BClean__c = newYear23BClean;
                                     				 }
            	}            	
            	
            	system.debug('checking to see if we are in a 3 year term');
            	        	If (cont.Contract_Term_Length_Yrs__c == 3)
            	        	{
            		system.debug('we are in a 3 year term');
					system.debug('checking to see if we year 3 docx is null');
                                    If (cont.Year_3_Billing_Amount_Software__c != null)
                                    		{
                                        Integer newYear1Software = RoundMe(((cont.Year_3_Billing_Amount_Software__c * 	IncreasePercent) + cont.Year_3_Billing_Amount_Software__c), 500);
                                        newcontract.Year_1_Billing_Amount_Software__c = newYear1Software;
                                        system.debug(newYear1Software);
                                        Integer newYear2Software = RoundMe((newYear1Software * IncreasePercent) + newYear1Software, 500);
                                        system.debug(newYear2Software);
										newcontract.Year_2_Billing_Amount_Software__c = newYear2Software;
										Integer newYear3Software  = RoundMe((newYear2Software * IncreasePercent) + newYear2Software, 500);
										system.debug(newYear3Software);
                                        newcontract.Year_3_Billing_Amount_Software__c = newYear3Software;
                                        Integer newyear4Software  = RoundMe((newYear3Software * IncreasePercent) + newYear3Software, 500);
                                        system.debug(newYear4Software);
                                        newcontract.Year_4_Billing_Amount_Software__c = newyear4Software;
                                            }

                                    //Next, do EagleEye
                                    system.debug('checking to see if we year 3 EE is null');
                                    If (cont.Year_3_Billing_Amount_EagleEye__c != null )
                                    			{
                                    				
                                       Integer newYear1EagleEye  = RoundMe(((cont.Year_3_Billing_Amount_EagleEye__c * IncreasePercent) + cont.Year_3_Billing_Amount_EagleEye__c), 500);
                                        newcontract.Year_1_Billing_Amount_EagleEye__c = newYear1EagleEye;
                                        Integer newYear2EagleEye = RoundMe((newYear1EagleEye * IncreasePercent) + newYear1EagleEye, 500);
										newcontract.Year_2_Billing_Amount_EagleEye__c = newYear2EagleEye;
										Integer newYear3EagleEye  = RoundMe((newYear2EagleEye * IncreasePercent) + newYear2EagleEye, 500);
                                        newcontract.Year_3_Billing_Amount_EagleEye__c = newYear3EagleEye;
                                        Integer newYear4EagleEye  = RoundMe((newYear3EagleEye * IncreasePercent) + newYear3EagleEye, 500);
                                        newcontract.Year_4_Billing_Amount_EagleEye__c = newYear4EagleEye;
                                        		}

                                    //Next, do 3BClean
                                    system.debug('checking to see if we year 3 3b is null');
                                    If (cont.Year_3_Billing_Amount_3BClean__c != null)
                                    				{
                                        Integer newYear13BClean = RoundMe(((cont.Year_3_Billing_Amount_3BClean__c * IncreasePercent) + cont.Year_3_Billing_Amount_3BClean__c), 500);
                                        newcontract.Year_1_Billing_Amount_3BClean__c = newYear13BClean;
                                        Integer newYear23BClean = RoundMe((newYear13BClean * IncreasePercent) + newYear13BClean, 500);
										newcontract.Year_2_Billing_Amount_3BClean__c = newYear23BClean;
										Integer newYear33BClean  = RoundMe((newYear23BClean * IncreasePercent) + newYear23BClean, 500);
                                        newcontract.Year_3_Billing_Amount_3BClean__c = newYear33BClean;
                                        Integer newYear43BClean  = RoundMe((newYear33BClean * IncreasePercent) + newYear33BClean, 500);
                                        newcontract.Year_4_Billing_Amount_3BClean__c = newYear43BClean;
                                     				 }
            	}   
            	
            	system.debug('checking to see if we are in a 4 year contract');
            	If (cont.Contract_Term_Length_Yrs__c == 4)
            	{

                                    If (cont.Year_4_Billing_Amount_Software__c != null)
                                    		{
                                        Integer newYear1Software = RoundMe(((cont.Year_4_Billing_Amount_Software__c * 	IncreasePercent) + cont.Year_4_Billing_Amount_Software__c), 500);
                                        newcontract.Year_1_Billing_Amount_Software__c = newYear1Software;
                                        Integer newYear2Software = RoundMe((newYear1Software * IncreasePercent) + newYear1Software, 500);
										newcontract.Year_2_Billing_Amount_Software__c = newYear2Software;
										Integer newYear3Software  = RoundMe((newYear2Software * IncreasePercent) + newYear2Software, 500);
                                        newcontract.Year_3_Billing_Amount_Software__c = newYear3Software;
                                        Integer newyear4Software  = RoundMe((newYear3Software * IncreasePercent) + newYear3Software, 500);
                                        newcontract.Year_4_Billing_Amount_Software__c = newyear4Software;
                                            }

                                    //Next, do EagleEye
                                    If (cont.Year_4_Billing_Amount_EagleEye__c != null )
                                    			{
                                       Integer newYear1EagleEye  = RoundMe(((cont.Year_3_Billing_Amount_EagleEye__c * IncreasePercent) + cont.Year_4_Billing_Amount_EagleEye__c), 500);
                                        newcontract.Year_1_Billing_Amount_EagleEye__c = newYear1EagleEye;
                                        Integer newYear2EagleEye = RoundMe((newYear1EagleEye * IncreasePercent) + newYear1EagleEye, 500);
										newcontract.Year_2_Billing_Amount_EagleEye__c = newYear2EagleEye;
										Integer newYear3EagleEye  = RoundMe((newYear2EagleEye * IncreasePercent) + newYear2EagleEye, 500);
                                        newcontract.Year_3_Billing_Amount_EagleEye__c = newYear3EagleEye;
                                        Integer newYear4EagleEye  = RoundMe((newYear3EagleEye * IncreasePercent) + newYear3EagleEye, 500);
                                        newcontract.Year_4_Billing_Amount_EagleEye__c = newYear4EagleEye;
                                        		}

                                    //Next, do 3BClean
                                    If (cont.Year_4_Billing_Amount_3BClean__c != null)
                                    				{
                                        Integer newYear13BClean = RoundMe(((cont.Year_4_Billing_Amount_3BClean__c * IncreasePercent) + cont.Year_4_Billing_Amount_3BClean__c), 500);
                                        newcontract.Year_1_Billing_Amount_3BClean__c = newYear13BClean;
                                        Integer newYear23BClean = RoundMe((newYear13BClean * IncreasePercent) + newYear13BClean, 500);
										newcontract.Year_2_Billing_Amount_3BClean__c = newYear23BClean;
										Integer newYear33BClean  = RoundMe((newYear23BClean * IncreasePercent) + newYear23BClean, 500);
                                        newcontract.Year_3_Billing_Amount_3BClean__c = newYear33BClean;
                                        Integer newYear43BClean  = RoundMe((newYear33BClean * IncreasePercent) + newYear33BClean, 500);
                                        newcontract.Year_4_Billing_Amount_3BClean__c = newYear43BClean;
                                     				 }
            	}
            	system.debug('done with 4 year logic');   
            	system.debug('starting services work if us or canada');
            					//Next, do services, if it's US or Canada
                                //populate the services billing amounts for subscription contracts that are legal US or legal canada.
                                If (cont.Contract_Term_Length_Yrs__c == 3 || cont.Contract_Term_Length_Yrs__c == 4){
                                	
                                
                                    If ((cont.Account.Industry == 'Law Firm - USA'  || cont.Account.Industry == 'Law Firm - Canada') &&  (cont.Year_1_Billing_Amount_Software__c != null &&  cont.Year_1_Billing_Amount_Software__c != 0)) {
                                        newcontract.Year_1_Billing_Amount_Services__c = 2000;
                                        
                                        newcontract.Year_2_Billing_Amount_Services__c = 2000;
                                        newcontract.Year_3_Billing_Amount_Services__c = 2000;
                                        newcontract.Services_of_Pre_purchased_Days__c = 5;
                                        newcontract.Pre_purchased_PS_Days_Total_Billing__c = 6000;
                                        newcontract.Pre_purchased_PS_Days_Discounted_Dai__c = 1200;
                                        newcontract.PS_Days_Total_Actual_Value__c = 8500;



                                }
                                }
            	
       
                                    
                                
            	
            	
            	
            	//End subscription logic
            	}
            	
            	
            	     	
            	//Fill out Prior year 3 contract, based on how many years this term is. First do 3B, then EE, then DocX
            	 			If (cont.Contract_Term_Length_Yrs__c == 1) {
                                    newcontract.Prior_Contract_Year_3_3BClean__c = cont.Year_1_Billing_Amount_3BClean__c;
                                    newcontract.Prior_Contract_Year_3_EagleEye__c = cont.Year_1_Billing_Amount_EagleEye__c;
                                    newcontract.Prior_Contract_Year_3_Services__c = cont.Year_1_Billing_Amount_Services__c;
                                    newcontract.Prior_Contract_Year_3_DocXtools__c = cont.Year_1_Billing_Amount_Software__c;
            	 			}
            	 			else if (cont.Contract_Term_Length_Yrs__c == 4){
                                    newcontract.Prior_Contract_Year_3_3BClean__c = cont.Year_4_Billing_Amount_3BClean__c;
                                    newcontract.Prior_Contract_Year_3_EagleEye__c = cont.Year_4_Billing_Amount_EagleEye__c;
                                    newcontract.Prior_Contract_Year_3_Services__c = cont.Year_4_Billng_Amount_Services__c;
                                    newcontract.Prior_Contract_Year_3_DocXtools__c = cont.Year_4_Billing_Amount_Software__c;
                                    
            	 			} else if (cont.Contract_Term_Length_Yrs__c == 2){
                                    newcontract.Prior_Contract_Year_3_3BClean__c = cont.Year_2_Billing_Amount_3BClean__c;
                                    newcontract.Prior_Contract_Year_3_EagleEye__c = cont.Year_2_Billing_Amount_EagleEye__c;
                                    newcontract.Prior_Contract_Year_3_Services__c = cont.Year_2_Billing_Amount_Services__c;
                                    newcontract.Prior_Contract_Year_3_DocXtools__c = cont.Year_2_Billing_Amount_Software__c;
                                    
            	 			} else {
                                	newcontract.Prior_Contract_Year_3_3BClean__c = cont.Year_3_Billing_Amount_3BClean__c;
                                	newcontract.Prior_Contract_Year_3_EagleEye__c = cont.Year_3_Billing_Amount_EagleEye__c;
                                 	newcontract.Prior_Contract_Year_3_Services__c = cont.Year_3_Billing_Amount_Services__c;
                                 	newcontract.Prior_Contract_Year_3_DocXtools__c = cont.Year_3_Billing_Amount_Software__c;
            	 			}
            	 			
            	//Fill out year 1 - year 4 contract start and end dates.
            		Date endDateForCalculations = cont.Enddate + 1;
            	
            		newContract.year_1_start_date__c = endDateForCalculations;
            		newContract.year_1_end_date__c =  endDateForCalculations.AddYears(1).AddDays(-1);
            		
            		if (term > 1 ){
					newContract.year_2_start_date__c = endDateForCalculations.AddYears(1);
					newContract.year_2_end_date__c =  endDateForCalculations.AddYears(2).AddDays(-1);
            		}
            		if (term > 2)  {
					newContract.year_3_start_date__c = endDateForCalculations.AddYears(2);
					newContract.year_3_end_date__c =  endDateForCalculations.AddYears(3).AddDays(-1);
            		}
					  	if (term > 3)
					  {
					newContract.year_4_start_date__c = endDateForCalculations.AddYears(3);
					newContract.year_4_end_date__c =  endDateForCalculations.AddYears(4).AddDays(-1);           	
					  } 
					  
				                            
                            


                        insert newContract;    

 //Fill out previous (original) contract "new contract year 1" field
				 cont.Next_Contract_Yr_1_Software_Amount__c = (decimalZeroIfNull(newContract.Year_1_Billing_Amount_Software__c) + decimalZeroIfNull(newContract.Year_1_Billing_Amount_EagleEye__c) + decimalZeroIfNull(newContract.Year_1_Billing_Amount_3BClean__c) + decimalZeroIfNull(newContract.Year_1_Billing_Amount_Patent_Companion__c));
				 
						update cont;




//create contract products
			for (contract_product__c cpcon : [Select Id,OwnerId,IsDeleted,Name,RecordTypeId,Licenses_Year1__c,Licenses_Year2__c,Licenses_Year3__c,Service_Days_Year1__c,Service_Days_Year2__c,Service_Days_Year3__c,Service_Days_Used_Year1__c,Service_Days_Used_Year2__c,Service_Days_Used_Year3__c,Service_Days_Remaining_Year1_f__c,Service_Days_Remaining_Year2_f__c,Service_Days_Remaining_Year3_f__c,Product__c,Contract__c,Licenses_Year4__c,Service_Days_Year4__c,Service_Days_Used_Year4__c,Service_Days_Remaining_Year4_f__c,Product_Description__c,Legacy_Product_Id__c,Legacy_ProductSite_Id__c,SF_Migration_Id__c,Year_1_Licensing_Fee__c,Year_2_Licensing_Fee__c,Year_3_Licensing_Fee__c,Year_4_Licensing_Fee__c,Total_Number_of_Service_Days_Used__c from Contract_Product__c where contract__c  =:cont.Id ])
				{
					
						contract_product__c contractproduct = new contract_product__c();
		
								contractProduct.Contract__c = newContract.id;
                                contractProduct.RecordTypeId = cpcon.RecordTypeId;
                                contractProduct.Licenses_Year1__c = cpcon.Licenses_Year1__c;
                                contractProduct.Licenses_Year2__c = cpcon.Licenses_Year2__c;
                                contractProduct.Licenses_Year3__c = cpcon.Licenses_Year3__c;
                                contractProduct.Service_Days_Year1__c = cpcon.Service_Days_Year1__c;
                                contractProduct.Service_Days_Year2__c = cpcon.Service_Days_Year2__c;
                                contractProduct.Service_Days_Year3__c = cpcon.Service_Days_Year3__c;
                                contractProduct.Service_Days_Used_Year1__c = cpcon.Service_Days_Used_Year1__c;
                                contractProduct.Service_Days_Used_Year2__c = cpcon.Service_Days_Used_Year2__c;
                                contractProduct.Service_Days_Used_Year3__c = cpcon.Service_Days_Used_Year3__c;
								contractProduct.Product__c = cpcon.Product__c;
                                contractProduct.Licenses_Year4__c = cpcon.Licenses_Year4__c;
                                contractProduct.Service_Days_Year4__c = cpcon.Service_Days_Year4__c;
                                contractProduct.Service_Days_Used_Year4__c = cpcon.Service_Days_Used_Year4__c;
                                contractProduct.Product_Description__c = cpcon.Product_Description__c;
                                contractProduct.Year_1_Licensing_Fee__c = cpcon.Year_1_Licensing_Fee__c;
                                contractProduct.Year_2_Licensing_Fee__c = cpcon.Year_2_Licensing_Fee__c;
                                contractProduct.Year_3_Licensing_Fee__c = cpcon.Year_3_Licensing_Fee__c;
                                contractProduct.Year_4_Licensing_Fee__c = cpcon.Year_4_Licensing_Fee__c;
                                
        				insert contractproduct;                        				
				
				}
				
//create sites
			for (Contract_Site__c siteList : [Select contract__c, site__c from contract_site__c where contract__c =:cont.Id ])
				{

				contract_site__c contractsite = new contract_site__c();
					contractsite.contract__c = newcontract.id;
					contractsite.site__c = sitelist.site__c;
					insert contractSite;

				}
           
//Redirect to new contract           

           pageRef = new PageReference ('/'+newcontract.id);
           pageRef.setRedirect(true);
           
       }catch(QueryException e){
          
           

       }catch(DMLException e){
           
           system.debug('DML query did not work');
       }

       return pageRef;
    }    
    
integer roundMe(decimal i, integer v){
	if(i == null) return 0;
    integer i2 = i.intValue();
    return (((i2+ 499)/v) * v);
}
 public Decimal decimalZeroIfNull(Decimal num )
				{
			if (num == null) num = 0;
			return num;
				}
				
			public Integer integerZeroIfNull(Integer num )
				{
			if (num == null) num = 0;
			return num;
				}


}