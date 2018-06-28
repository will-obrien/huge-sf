// **************************************************************************
// ManageAddressExtension                (c) 2014 Appirio, Inc.
//
//  Class for ManageAddress Edit Existing address and Create new  
//		Address on Account 
//
//  2014/02/15		Pitamber Sharma (Appirio) - Original ()
//	20??			MM
//  2017/04/25		VB    Adding Header/Comments.  Also adding function to 
//							allow multiple addresses to be inactive.
// **************************************************************************
public class ManageAddressExtension {
	 
  public Account account {get;set;}
  public List<AccountAddressWrapper> lstAddress{get;set;}
  private Map<Id, rC_Bios__Address__c> mapAcctAddresses;
  public rC_Bios__Account_Address__c accountAddressToInsert{get;set;}
  public Boolean hasError{get;set;} 
  public Boolean isOverride{get;set;}
  public Boolean isStateBlank{get;set;}
  public Boolean isStreetBlank{get;set;}
  public Boolean isCityBlank{get;set;}
  public Boolean isStateWrong{get;set;}
  public Boolean nameError{get;set;}
  public boolean isInvalidTestAddress;
  private Boolean isAddressInvalid;
  private Boolean isSaved;
  public String errorMsg {get;set;}
  //MM Begin
  private static Id householdRTId;
  private String defaultAddressType;
  //MM End
  
  //============================================//
  //Constructor
  //============================================//
  public ManageAddressExtension(ApexPages.StandardController stdController) {
  	
    System.debug('@@@@@ In Constructor');
    queryAccount();
    queryAccountAddress();
    accountAddressToInsert = new rc_Bios__Account_Address__c();
    isInvalidTestAddress = false;
    hasError = false;
    isOverride = false;
    nameError = false;
    isSaved = false;
    errorMsg = '';
	//MM Begin
    // Look up the Record Types    
    householdRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
    if(account.RecordTypeId == householdRTId) {
        defaultAddressType = 'Home';
    }
    else {
        defaultAddressType = 'Business';
    }
    accountAddressToInsert.rC_Bios__Type__c = defaultAddressType;
    //MM End
  } 
  
  // Query all Account Addresses for a particular Account
  //		adding them to the lstAddress and mapAcctAddress instance variables
  public void queryAccountAddress() {

    this.lstAddress = new List<AccountAddressWrapper>();
    mapAcctAddresses = new Map<Id, rc_Bios__Address__c>();
    
    for(rC_Bios__Account_Address__c acAdd : [SELECT      rC_Bios__Active__c,
                                                         rC_Bios__Type__c, 
                                                         rC_Bios__Seasonal_Start_Month__c,
                                                         rC_Bios__Seasonal_End_Month__c,
                                                         rC_Bios__Seasonal_Start_Day__c,
                                                         rC_Bios__Seasonal_End_Day__c,
                                                         rC_Bios__Start_Date__c,
                                                         rC_Bios__End_Date__c,
                                                         rC_Bios__Preferred_Billing__c, 
                                                         rC_Bios__Preferred_Shipping__c,
                                                         rC_Bios__Do_Not_Mail__c,
                                                         rC_Bios__Original_Street_Line_1__c,
                                                         rC_Bios__Original_City__c,
                                                         rC_Bios__Original_State__c,
                                                         rC_Bios__Original_Country__c,
                                                         rC_Bios__Original_Postal_Code__c,
                                                         rC_Bios__Original_Street_Line_2__c,
                                                         rC_Bios__Address__c,
                                                         rC_Bios__Address__r.rC_Bios__City__c, 
                                                         rC_Bios__Address__r.rC_Bios__Street_Line_1__c,
                                                         rC_Bios__Address__r.rC_Bios__Street_Line_2__c,
                                                         rC_Bios__Address__r.rC_Bios__State__c,
                                                         rC_Bios__Address__r.rC_Bios__Country__c,
                                                         rC_Bios__Address__r.rC_Bios__ZIP__c,
                                                         OrgName__c,
														 OrgName2__c
													FROM rC_Bios__Account_Address__c 
													WHERE rC_Bios__Account__c = :this.account.ID]) {

            lstAddress.add(new AccountAddressWrapper(acAdd));
            mapAcctAddresses.put(acAdd.Id, fetchAddress(acAdd));
    }
  }
  
  
  //=============================================//
  //Query Acccount
  //=============================================// 
  private void queryAccount() {
  	
    List<Account> lstAccount = [SELECT Id,Name,RecordTypeId 
    									FROM Account 
										WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
    if(lstAccount.size() == 0) {
      this.account = new Account();
      return;
    }        
    this.account = lstAccount[0];                    
  }
  
  public PageReference upsertAccountAddressList() {

    isAddressInvalid = false;
    List<rC_Bios__Account_Address__c> accAddList = new List<rC_Bios__Account_Address__c>();
    Boolean isValidSeasonalDates = false;
    Boolean isValidActiveDates = false;
    AddressService.AddressServiceResult addressResult;
    nameError = false;
    
    for(AccountAddressWrapper aaw : lstAddress) {
    	
    	isValidSeasonalDates = false;
    	isValidActiveDates = false;
    	aaw.nameError = false;
    	
            if((aaw.acctAddress.rC_Bios__Preferred_Billing__c || aaw.acctAddress.rC_Bios__Preferred_Shipping__c) && !aaw.acctAddress.rC_Bios__Active__c) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Address can not be inactive if it is selected as preferred'));
                return null;
            } 
            if(aaw.acctAddress.rC_Bios__Seasonal_Start_Month__c == null && aaw.acctAddress.rC_Bios__Seasonal_Start_Day__c == null 
                    && aaw.acctAddress.rC_Bios__Seasonal_End_Day__c == null  && aaw.acctAddress.rC_Bios__Seasonal_End_Day__c == null ) {
                isValidSeasonalDates = true;
            }
            if(aaw.acctAddress.rC_Bios__Seasonal_Start_Month__c != null && aaw.acctAddress.rC_Bios__Seasonal_Start_Day__c != null 
                    && aaw.acctAddress.rC_Bios__Seasonal_End_Day__c != null  && aaw.acctAddress.rC_Bios__Seasonal_End_Day__c != null) {
                isValidSeasonalDates = true;
            }
            
            if(!isValidSeasonalDates) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Please either complete or clear out seasonal address information'));
                return null;
            }
            
            if(aaw.acctAddress.rC_Bios__Start_Date__c == null && aaw.acctAddress.rC_Bios__End_Date__c == null) {
				    	isValidActiveDates = true;
				    }
				    if(aaw.acctAddress.rC_Bios__Start_Date__c != null && aaw.acctAddress.rC_Bios__End_Date__c != null) {
				    	isValidActiveDates = true;
				    }
				    
				    if(!isValidActiveDates) {
				        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Please either complete or clear out active address information'));
				        return null;
				    }
				    
				    if(aaw.acctAddress.rC_Bios__Start_Date__c > aaw.acctAddress.rC_Bios__End_Date__c) {
				    	ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Active End Date can not be less then Start Date'));
				        return null;
				    }
            
        if(aaw.isOverride || isAddressEdited(fetchAddress(aaw.acctAddress), mapAcctAddresses.get(aaw.acctAddress.Id))) {
            system.debug(':: is Override and Updated  ::'+aaw.isOverride);
            if(!aaw.isOverride && (aaw.acctAddress.rC_Bios__Original_Country__c == null || aaw.acctAddress.rC_Bios__Original_Country__c.equalsIgnoreCase('USA')
                                                            || aaw.acctAddress.rC_Bios__Original_Country__c.equalsIgnoreCase('US') || aaw.acctAddress.rC_Bios__Original_Country__c.equalsIgnoreCase('United States'))) {
                if(!isEmptyAddress(aaw.acctAddress)) {
                    aaw.isStreetBlank = false;
                    aaw.isStateBlank = false;
                    aaw.isCityBlank = false;
                    if((aaw.acctAddress.rC_Bios__Original_Country__c.equalsIgnoreCase('USA') || aaw.acctAddress.rC_Bios__Original_Country__c.equalsIgnoreCase('US') ||
                            aaw.acctAddress.rC_Bios__Original_Country__c.equalsIgnoreCase('United States')) && aaw.acctAddress.rC_Bios__Original_State__c.length() > 2) {
                        aaw.isStateWrong = true;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Please enter two letter state abbreviation'));
                        if(aaw.acctAddress.rC_Bios__Original_Postal_Code__c.equals('00000')) {
                            aaw.acctAddress.rC_Bios__Original_Postal_Code__c = '';
                        }
                            return null;
                    }
                    aaw.isStateWrong = false;
                    if(!Test.isRunningTest()){
					 	   				try{
					 	   					addressResult = AddressService.Validate(fetchAddress(aaw.acctAddress));
					 	   				} catch(Exception e) {
	 	   									ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info, 'The time limit to validate the address has been exceeded, please refine the address entered or override the validation.'));
                        aaw.hasError = true;
                        if(aaw.acctAddress.rC_Bios__Original_Postal_Code__c.equals('00000')) {
                          aaw.acctAddress.rC_Bios__Original_Postal_Code__c = '';
                        }
					 	   				}
					  	 		 	}else{
					  	 		 		if(isInvalidTestAddress){
					  	 		 			addressResult = AddressService.validateForTest(fetchAddress(aaw.acctAddress), false,false);
					  	 		 		}else{
					  	 		 		  addressResult = AddressService.validateForTest(fetchAddress(aaw.acctAddress), true,false);
					  	 		 		}
					  	 		 	}
                    
                    if(addressResult.statusCode.equals('503')) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info, 'Address can not be validated now, Please check Override if you still want to save this.'));
                        aaw.hasError = true;
                        if(aaw.acctAddress.rC_Bios__Original_Postal_Code__c.equals('00000')) {
                            aaw.acctAddress.rC_Bios__Original_Postal_Code__c = '';
                        }
                    }
        
                    if(addressResult.isValid) {
                        copyValidatedAddress(addressResult.addressOutput[0], aaw.acctAddress);
                        
                        accAddList.add(aaw.acctAddress);
                        aaw.hasError = false;
                    } else {
                        isAddressInvalid = true;
                        aaw.hasError = true;
                        if(aaw.acctAddress.rC_Bios__Original_Postal_Code__c.equals('00000')) {
                            aaw.acctAddress.rC_Bios__Original_Postal_Code__c = '';
                        }
                    }
                } else {
                    if(String.isBlank(aaw.acctAddress.rC_Bios__Original_Street_Line_1__c) && String.isBlank(aaw.acctAddress.rC_Bios__Original_State__c) && String.isBlank(aaw.acctAddress.rC_Bios__Original_City__c)) {
                        continue;
                    }
                    if(aaw.acctAddress.rC_Bios__Original_Street_Line_1__c == null) {
                        aaw.isStreetBlank = true;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Street Line 1 field is required to validate the address'));
                    } else {
                        aaw.isStreetBlank = false;
                    }
                    if(aaw.acctAddress.rC_Bios__Original_State__c == null) {
                        aaw.isStateBlank = true;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'State field is required to validate the address'));
                    } else {
                        aaw.isStateBlank = false;
                    }
                    if(aaw.acctAddress.rC_Bios__Original_City__c == null) {
                        aaw.isCityBlank = true;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'City field is required to validate the address'));
                    } else {
                        aaw.isCityBlank = false;
                    }
                    return null;
                }
            } else {
                accAddList.add(aaw.acctAddress);
                aaw.hasError = false;
            }
        } else {
            accAddList.add(aaw.acctAddress);
        }
        
    }
    
    if(isOverride  || (accountAddressToInsert.rC_Bios__Original_Country__c != null && 
    						!(accountAddressToInsert.rC_Bios__Original_Country__c.equalsIgnoreCase('USA') || 
    						accountAddressToInsert.rC_Bios__Original_Country__c.equalsIgnoreCase('US') || 
    						accountAddressToInsert.rC_Bios__Original_Country__c.equalsIgnoreCase('United States')))) {
        accountAddressToInsert.rC_Bios__Account__c = account.Id;
        accAddList.add(accountAddressToInsert);
        hasError = false;
    } else {
        if(!isEmptyAddress(accountAddressToInsert)) {
            isStreetBlank = false;
            isStateBlank = false;
            isCityBlank = false;
            if((accountAddressToInsert.rC_Bios__Original_Country__c.equalsIgnoreCase('USA')|| accountAddressToInsert.rC_Bios__Original_Country__c.equalsIgnoreCase('US')) && accountAddressToInsert.rC_Bios__Original_State__c.length() > 2) {
                isStateWrong = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Please enter two letter state abbreviation'));
                if(accountAddressToInsert.rC_Bios__Original_Postal_Code__c.equals('00000')) {
                    accountAddressToInsert.rC_Bios__Original_Postal_Code__c = '';
                }
                    return null;
            }
            isStateWrong = false;
            
            //  aaddressResult = AddressService.Validate(accountAddressToInsert); 
            if(!Test.isRunningTest()){
			 	   		try {
			 	   			addressResult = AddressService.Validate(fetchAddress(accountAddressToInsert));
			 	   		} catch(Exception e) {
 	   						ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info, 'The time limit to validate the address has been exceeded, please refine the address entered or override the validation.'));
                hasError = true;
                if(accountAddressToInsert.rC_Bios__Original_Postal_Code__c.equals('00000')) {
                  accountAddressToInsert.rC_Bios__Original_Postal_Code__c = '';
                }
                return null;
				 	   	}
		  	  	} else{
					 		if(isInvalidTestAddress){
					 			addressResult = AddressService.validateForTest(fetchAddress(accountAddressToInsert), false,false);
			 		 		}else{
			 		 		  addressResult = AddressService.validateForTest(fetchAddress(accountAddressToInsert), true,false);
			 		 		}
			 		 	}
            if(addressResult.statusCode.equals('503')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info, 'Address can not be validated now, Please check Override if you still want to save this.'));
                hasError = true;
                if(accountAddressToInsert.rC_Bios__Original_Postal_Code__c.equals('00000')) {
                    accountAddressToInsert.rC_Bios__Original_Postal_Code__c = '';
                }
                return null;
            }
            if(addressResult.isValid) {
                copyValidatedAddress(addressResult.addressOutput[0], accountAddressToInsert);
                accountAddressToInsert.rC_Bios__Account__c = account.Id;
                
                accAddList.add(accountAddressToInsert);
                hasError = false;
            } else {
                isAddressInvalid = true;
                hasError = true;
                if(accountAddressToInsert.rC_Bios__Original_Postal_Code__c.equals('00000')) {
                    accountAddressToInsert.rC_Bios__Original_Postal_Code__c = '';
                }
            }
        } else {
            if(!String.isBlank(accountAddressToInsert.rC_Bios__Original_Street_Line_1__c) || !String.isBlank(accountAddressToInsert.rC_Bios__Original_State__c) || !String.isBlank(accountAddressToInsert.rC_Bios__Original_City__c)) {
                if(accountAddressToInsert.rC_Bios__Original_Street_Line_1__c == null) {
                    isStreetBlank = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Street Line 1 field is required to validate the address'));
                } else {
                    isStreetBlank = false;
                }
                if(accountAddressToInsert.rC_Bios__Original_State__c == null) {
                    isStateBlank = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'State field is required to validate the address'));
                } else {
                    isStateBlank = false;
                }
                if(accountAddressToInsert.rC_Bios__Original_City__c == null) {
                    isCityBlank = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'City field is required to validate the address'));
                } else {
                    isCityBlank = false;
                }
                return null;
            } else {
                isStreetBlank = false;
                isStateBlank = false;
                isCityBlank = false;
            }
        }
    }
    
    isValidSeasonalDates = false;
    isValidActiveDates = false;
    
    if((accountAddressToInsert.rC_Bios__Preferred_Billing__c || accountAddressToInsert.rC_Bios__Preferred_Shipping__c) && !accountAddressToInsert.rC_Bios__Active__c) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Address can not be inactive if it is selected as preferred'));
        return null;
    } 
    if(accountAddressToInsert.rC_Bios__Seasonal_Start_Month__c == null && accountAddressToInsert.rC_Bios__Seasonal_Start_Day__c == null 
            && accountAddressToInsert.rC_Bios__Seasonal_End_Month__c == null  && accountAddressToInsert.rC_Bios__Seasonal_End_Day__c == null ) {
        isValidSeasonalDates = true;
    }
    if(accountAddressToInsert.rC_Bios__Seasonal_Start_Month__c != null && accountAddressToInsert.rC_Bios__Seasonal_Start_Day__c != null 
            && accountAddressToInsert.rC_Bios__Seasonal_End_Month__c != null  && accountAddressToInsert.rC_Bios__Seasonal_End_Day__c != null) {
        isValidSeasonalDates = true;
    }
    
    if(!isValidSeasonalDates) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Please either complete or clear out seasonal address information'));
        return null;
    }
    
    if(accountAddressToInsert.rC_Bios__Start_Date__c == null && accountAddressToInsert.rC_Bios__End_Date__c == null) {
    	isValidActiveDates = true;
    }
    if(accountAddressToInsert.rC_Bios__Start_Date__c != null && accountAddressToInsert.rC_Bios__End_Date__c != null) {
    	isValidActiveDates = true;
    }
    
    if(!isValidActiveDates) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Please either complete or clear out active address information'));
        return null;
    }
    
    if(accountAddressToInsert.rC_Bios__Start_Date__c > accountAddressToInsert.rC_Bios__End_Date__c) {
    	ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Active End Date can not be less then Start Date'));
    	return null;
    } 
    
    if(!checkSameTypeActiveDatesConflicts(accAddList)) {
      if(accAddList.size() > 0) {
        accAddList.remove(accAddList.size() - 1);
      }
      ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Active Dates of Same Type of addresses are overlapping'));
      return null;
    }
    
    if(!velidateMultiplePreference(accAddList)) {
      if(accAddList.size() > 0) {
        accAddList.remove(accAddList.size() - 1);
      }
      ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Seasonal dates of preferred addresses are overlapping'));
      return null;
    }
    
    if(!checkPreferencesConflicts(accAddList)) {
      if(accAddList.size() > 0) {
        accAddList.remove(accAddList.size() - 1);
      }
      ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Seasonal dates of preferred addresses are overlapping'));
      return null;
    }

    /* VB: 4/25/17 - Removing this check for a preferred billing address
    // If there is more than one billing address, and none are marked as Preferred
    if(!checkAtLeastOnePreferredBilling(accAddList)) {
    	
      // Remove the last Address from the accAddList?
      //		VB: Unsure what the accAddList value is doing.  
      if(accAddList.size() > 0) {
        accAddList.remove(accAddList.size() - 1);
      }

	  ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'An Address must be selected as the Preferred Billing Address'));
	  return null;
    }
    */
    
    if(isAddressInvalid) {
    	ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Address(es) not Validated.'));
    	return null;
    }
    
    if(accAddList.size() > 0) {
        List<Database.Upsertresult> upsertResults = database.upsert(accAddList, false);
        integer cnt = 0;
        Boolean errorFound = false;
        for(Database.Upsertresult ur : upsertResults) {
            if(!ur.isSuccess()) {
            	errorFound = true;
                String errMessage = ur.getErrors().get(0).getMessage();
                if(errMessage.containsIgnoreCase('short enough name')) {
                    if(cnt < lstAddress.size()) {
                        lstAddress.get(cnt).nameError = true;
                        lstAddress.get(cnt).errorMsg = 'Unable to find a short enough name for this address.';
                    } else {
                        nameError = true;
                        errorMsg = 'Unable to find a short enough name for this address.';
                    }
                } else {
                	if(cnt < lstAddress.size()) {
                    lstAddress.get(cnt).nameError = true;
                    lstAddress.get(cnt).errorMsg = errMessage;
                	} else {
                    nameError = true;
                    errorMsg = errMessage;
                	}	
               }
			   ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, errMessage));
            }else {
                if(cnt < lstAddress.size()) {
                    lstAddress.get(cnt).nameError = false;
                    lstAddress.get(cnt).errorMsg = '';
                    lstAddress.get(cnt).isOverride = false;
                    mapAcctAddresses.put(lstAddress.get(cnt).acctAddress.Id, fetchAddress(lstAddress.get(cnt).acctAddress));
                } else {
                    nameError = false;
                    errorMsg = '';
                    isOverride = false;
                }
            }
            cnt++;
        }
        
        if(errorFound) {
        	return null;
        }

        //Added by MM
        queryAccountAddress();
        //
        
        for(rC_Bios__Account_Address__c accAdd : accAddList) {
            if(!mapAcctAddresses.containsKey(accAdd.Id)) {
                lstAddress.add(new AccountAddressWrapper(accAdd));
            }
            mapAcctAddresses.put(accAdd.Id, fetchAddress(accAdd));
        }
    }
    
    accountAddressToInsert = new rc_Bios__Account_Address__c(rC_Bios__Type__c = defaultAddressType,rC_Bios__Active__c=true);
    hasError = false;
    //isOverride = false;
    isSaved = true;
    return null;
  }
  
  public PageReference upsertAccountAddressListAndReturn() {
    isSaved = false;
		upsertAccountAddressList();
		if(isSaved) {
	    return new PageReference('/'+account.Id);
		}
		return null;
  }
  
  private rC_Bios__Address__c fetchAddress(rC_Bios__Account_Address__c accAdd) {
    rC_Bios__Address__c address = new rC_Bios__Address__c();
    address.Id = accAdd.rC_Bios__Address__c;
    address.rC_Bios__Street_Line_1__c = accAdd.rC_Bios__Original_Street_Line_1__c;
    address.rC_Bios__Street_Line_2__c = accAdd.rC_Bios__Original_Street_Line_2__c;
    address.rC_Bios__State__c = accAdd.rC_Bios__Original_State__c;
    address.rC_Bios__Country__c = accAdd.rC_Bios__Original_Country__c;
    address.rC_Bios__City__c = accAdd.rC_Bios__Original_City__c;
    address.rC_Bios__ZIP__c = accAdd.rC_Bios__Original_Postal_Code__c;
    system.debug('In fetch Address : ' + address);
    return address;
  }
  
  private Boolean isAddressEdited(rC_Bios__Address__c newAdd, rC_Bios__Address__c oldAdd) {
    system.debug('isAddressEdited current :  ' + newAdd);
    system.debug('isAddressEdited old :  ' + oldAdd);
    if(newAdd.rC_Bios__Street_Line_1__c != oldAdd.rC_Bios__Street_Line_1__c ||
            newAdd.rC_Bios__Street_Line_2__c != oldAdd.rC_Bios__Street_Line_2__c || 
            newAdd.rC_Bios__State__c != oldAdd.rC_Bios__State__c ||
            newAdd.rC_Bios__Country__c != oldAdd.rC_Bios__Country__c ||
            newAdd.rC_Bios__City__c != oldAdd.rC_Bios__City__c ||
            newAdd.rC_Bios__ZIP__c != oldAdd.rC_Bios__ZIP__c) {
        return true;
    } 
    return false;
  }
  
  private Boolean isEmptyAddress(rC_Bios__Account_Address__c accAddress) {
    if(String.isBlank(accAddress.rC_Bios__Original_Street_Line_1__c) || String.isBlank(accAddress.rC_Bios__Original_State__c) || String.isBlank(accAddress.rC_Bios__Original_City__c)) {
        return true;
    } else {
            if(accAddress.rC_Bios__Original_Country__c == null) {accAddress.rC_Bios__Original_Country__c = 'USA';}
            if(accAddress.rC_Bios__Original_Postal_Code__c == null) {accAddress.rC_Bios__Original_Postal_Code__c = '00000';}
    }
    return false;
  }
  
  public class AccountAddressWrapper {
    public rC_Bios__Account_Address__c acctAddress{get;set;}
    public Boolean hasError{get;set;}
    public Boolean isOverride{get;set;}
    public Boolean isStateBlank{get;set;}
    public Boolean isStreetBlank{get;set;}
    public Boolean isCityBlank{get;set;}
    public Boolean isStateWrong{get;set;}
    public Boolean nameError{get;set;}
    public String errorMsg{get;set;}
    
    public AccountAddressWrapper() {
    }
    
    public AccountAddressWrapper(rC_Bios__Account_Address__c acctAddress) {
        this.acctAddress = acctAddress;
        hasError = false;
        isOverride = false;
        isStateBlank = false;
        isStreetBlank = false;
        isStateWrong = false;
        nameError = false;
        errorMsg = '';
    }
  }
  
	private Boolean checkSameTypeActiveDatesConflicts(List<rC_Bios__Account_Address__c> accountAddresses) {
  	Map<String, List<String>> datesMap = new Map<String, List<String>>();
  	Set<String> nullDatedActiveAddressSet = new Set<String>();
    Date eStartDate, eEndDate, cStartDate, cEndDate;
    String cYear;
    for(rC_Bios__Account_Address__c accAdd : accountAddresses) {
	    if(accAdd.rC_Bios__Active__c) {
	        if(!datesMap.containsKey(accAdd.rC_Bios__Type__c)) {
	        	datesMap.put(accAdd.rC_Bios__Type__c, new List<String>()) ;
	        } else {
	            if(accAdd.rC_Bios__Seasonal_Start_Month__c != null) {
	                cStartDate = System.Date.newInstance(Date.Today().Year(), Integer.valueOf(accAdd.rC_Bios__Seasonal_Start_Month__c), Integer.valueOf(accAdd.rC_Bios__Seasonal_Start_Day__c));
	                cYear = String.valueOf(accAdd.rC_Bios__End_Date__c == null ? Date.Today().Year() : accAdd.rC_Bios__End_Date__c.Year());
	                for(String val : datesMap.get(accAdd.rC_Bios__Type__c)) {
	                    String[] temp = val.split('@');
	                    if(temp[0].substring(temp[0].indexOf('-') + 1) == 'null' || temp[0].substring(temp[0].indexOf('-') + 1) == null) {
	                    	return false;
	                    }
	                    eStartDate = System.Date.newInstance(Date.Today().Year(), Integer.valueOf(temp[0].substring(temp[0].indexOf('-') + 1)), Integer.valueOf(temp[0].substring(0, temp[0].indexOf('-'))));
	                    eEndDate = System.Date.newInstance(Date.Today().Year(), Integer.valueOf(temp[1].substring(temp[1].indexOf('-') + 1)), Integer.valueOf(temp[1].substring(0, temp[1].indexOf('-'))));
	                    if(cStartDate >= eStartDate && cStartDate <= eEndDate && cYear.equals(temp[2])) {
	                    	return false;
	                    }
	                }
	            } else {
	            	return false;
	            }
	      }
	      datesMap.get(accAdd.rC_Bios__Type__c).add(accAdd.rC_Bios__Seasonal_Start_Day__c + '-' + accAdd.rC_Bios__Seasonal_Start_Month__c + 
	                                                                                '@' + accAdd.rC_Bios__Seasonal_End_Day__c + '-' + accAdd.rC_Bios__Seasonal_End_Month__c + 
	                                                                                '@' + (accAdd.rC_Bios__End_Date__c == null ? Date.Today().Year() : accAdd.rC_Bios__End_Date__c.Year()));
	    }
    }
    return true;
  }
  
  private Boolean checkPreferencesConflicts(List<rC_Bios__Account_Address__c> accountAddresses) {
    Map<String, List<String>> datesMap = new Map<String, List<String>>();
    Date eStartDate, eEndDate, cStartDate, cEndDate;
    String cYear;
    for(rC_Bios__Account_Address__c accAdd : accountAddresses) {
        if(accAdd.rC_Bios__Preferred_Billing__c) {
            if(!datesMap.containsKey('Preferred Billing')) {
                datesMap.put('Preferred Billing', new List<String>()) ;
            } else {
                if(accAdd.rC_Bios__Seasonal_Start_Month__c != null) {
                    cStartDate = System.Date.newInstance(Date.Today().Year(), Integer.valueOf(accAdd.rC_Bios__Seasonal_Start_Month__c), Integer.valueOf(accAdd.rC_Bios__Seasonal_Start_Day__c));
                    cYear = String.valueOf(accAdd.rC_Bios__End_Date__c == null ? Date.Today().Year() : accAdd.rC_Bios__End_Date__c.Year());
                    for(String val : datesMap.get('Preferred Billing')) {
                        String[] temp = val.split('@');
                        eStartDate = System.Date.newInstance(Date.Today().Year(), Integer.valueOf(temp[0].substring(temp[0].indexOf('-') + 1)), Integer.valueOf(temp[0].substring(0, temp[0].indexOf('-'))));
                        eEndDate = System.Date.newInstance(Date.Today().Year(), Integer.valueOf(temp[1].substring(temp[1].indexOf('-') + 1)), Integer.valueOf(temp[1].substring(0, temp[1].indexOf('-'))));
                        if(cStartDate >= eStartDate && cStartDate <= eEndDate && cYear.equals(temp[2])) {
                            return false;
                        }
                    }
                }
          }
            datesMap.get('Preferred Billing').add(accAdd.rC_Bios__Seasonal_Start_Day__c + '-' + accAdd.rC_Bios__Seasonal_Start_Month__c + 
                                                                                    '@' + accAdd.rC_Bios__Seasonal_End_Day__c + '-' + accAdd.rC_Bios__Seasonal_End_Month__c + 
                                                                                    '@' + (accAdd.rC_Bios__End_Date__c == null ? Date.Today().Year() : accAdd.rC_Bios__End_Date__c.Year()));
        }
        if(accAdd.rC_Bios__Preferred_Shipping__c) {
            if(!datesMap.containsKey('Preferred Shipping')) {
                datesMap.put('Preferred Shipping', new List<String>()) ;
            } else {
                if(accAdd.rC_Bios__Seasonal_Start_Month__c != null) {
                    cStartDate = System.Date.newInstance(Date.Today().Year(), Integer.valueOf(accAdd.rC_Bios__Seasonal_Start_Month__c), Integer.valueOf(accAdd.rC_Bios__Seasonal_Start_Day__c));
                    cYear = String.valueOf(accAdd.rC_Bios__End_Date__c == null ? Date.Today().Year() : accAdd.rC_Bios__End_Date__c.Year());
                    for(String val : datesMap.get('Preferred Shipping')) {
                        String[] temp = val.split('@');
                        eStartDate = System.Date.newInstance(Date.Today().Year(), Integer.valueOf(temp[0].substring(temp[0].indexOf('-') + 1)), Integer.valueOf(temp[0].substring(0, temp[0].indexOf('-'))));
                        eEndDate = System.Date.newInstance(Date.Today().Year(), Integer.valueOf(temp[1].substring(temp[1].indexOf('-') + 1)), Integer.valueOf(temp[1].substring(0, temp[1].indexOf('-'))));
                        if(cStartDate >= eStartDate && cStartDate <= eEndDate && cYear.equals(temp[2])) {
                            return false;
                        }
                    }
                }
            }
            datesMap.get('Preferred Shipping').add(accAdd.rC_Bios__Seasonal_Start_Day__c + '-' + accAdd.rC_Bios__Seasonal_Start_Month__c + 
                                                                                    '@' + accAdd.rC_Bios__Seasonal_End_Day__c + '-' + accAdd.rC_Bios__Seasonal_End_Month__c + 
                                                                                    '@' + (accAdd.rC_Bios__End_Date__c == null ? Date.Today().Year() : accAdd.rC_Bios__End_Date__c.Year()));
        }
    }
    return true;
  }
  
  private Boolean velidateMultiplePreference(List<rC_Bios__Account_Address__c> accountAddresses) {
    Set<Id> preferredBillingSet = new Set<Id>();
    Set<Id> preferredShippingSet = new Set<Id>();
    
    for(rC_Bios__Account_Address__c accAdd : accountAddresses) {
        if(accAdd.rC_Bios__Seasonal_Start_Month__c == null && accAdd.rC_Bios__Preferred_Billing__c) {
            preferredBillingSet.add(accAdd.Id);
        }
        if(accAdd.rC_Bios__Seasonal_Start_Month__c == null && accAdd.rC_Bios__Preferred_Shipping__c) {
            preferredShippingSet.add(accAdd.Id);
        }
        
        if(preferredBillingSet.size() > 1 || preferredShippingSet.size() > 1) {
            return false;
        }
    }
    return true;
  }

  // Confirms if there is more than one Account Address, 
  //		that at least one is marked as the Preferred Billing address or return an error.
  //	:WARNING:VB - Odd that it only checks Preferred Billing and not Shipping?
  private Boolean checkAtLeastOnePreferredBilling(List<rC_Bios__Account_Address__c> accountAddresses) {
  	
    if(accountAddresses.size() <= 1) {
      return true;        //If there is only one address, we allow it to be saved as non preferred billing address. As per I-111987
    }

	// If there is more than one Address
    for(rC_Bios__Account_Address__c accAdd : accountAddresses) {
    	
      // If any address is marked as the preferred Billing, then return no error. 
      if(accAdd.rC_Bios__Preferred_Billing__c) {
        return true;
      }
    }
    return false;
  }
  
  private void copyValidatedAddress(rC_Bios__Address__c srcAdd, rC_Bios__Account_Address__c destAdd) {
    destAdd.rC_Bios__Original_City__c = srcAdd.rC_Bios__City__c;   
        destAdd.rC_Bios__Original_Country__c = srcAdd.rC_Bios__Country__c;
        destAdd.rC_Bios__Original_Postal_Code__c = srcAdd.rC_Bios__ZIP__c;
        destAdd.rC_Bios__Original_State__c  = srcAdd.rC_Bios__State__c;
        destAdd.rC_Bios__Original_Street_Line_1__c = srcAdd.rC_Bios__Street_Line_1__c;
        destAdd.rC_Bios__Original_Street_Line_2__c = srcAdd.rC_Bios__Street_Line_2__c;
  }
}