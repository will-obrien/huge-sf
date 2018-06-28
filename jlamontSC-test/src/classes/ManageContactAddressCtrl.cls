//*********************************************************************
// (c) 2014 Appirio, Inc.
//
//  Class for ManageContactAddress Edit Existing address and Create new Address on Contact 
//	19 March 2014    Pitamber (Appirio)     Original
//**********************************************************************/
public class ManageContactAddressCtrl {
  public Contact contact {get;set;}
  public List<ContactAddressWrapper> lstAddress{get;set;}
  private Map<Id, rC_Bios__Address__c> mapCntAddresses;
  public rC_Bios__Contact_Address__c contactAddressToInsert{get;set;}
  public Boolean hasError{get;set;} 
  public Boolean isOverride{get;set;}
  public Boolean isStateBlank{get;set;}
  public Boolean isStreetBlank{get;set;}
  public Boolean isCityBlank{get;set;}
  public Boolean isStateWrong{get;set;}
  public Boolean nameError{get;set;}
  public boolean isInvalidTestAddress;
  public boolean isServiceDown;
  private Boolean isAddressInvalid;
  private Boolean isSaved;
  public String errorMsg {get;set;}
  
  //============================================//
  //Constructor
  //============================================//
  public ManageContactAddressCtrl(ApexPages.StandardController stdController) {
    System.debug('@@@@@ In Constructor');
    queryContact();
    queryContactAddress();
    contactAddressToInsert = new rc_Bios__Contact_Address__c();
    isInvalidTestAddress = false;
    isServiceDown = false;
    hasError = false;
    isOverride = false;
    nameError = false;
    isSaved = false;
    errorMsg = '';
  } 
  
  public void queryContactAddress() {
    this.lstAddress = new List<ContactAddressWrapper>();
    mapCntAddresses = new Map<Id, rc_Bios__Address__c>();
      for(rC_Bios__Contact_Address__c cnAdd : [SELECT    rC_Bios__Active__c,
								                                         rC_Bios__Type__c, 
								                                         rC_Bios__Seasonal_Start_Month__c,
								                                         rC_Bios__Seasonal_End_Month__c,
								                                         rC_Bios__Seasonal_Start_Day__c,
								                                         rC_Bios__Seasonal_End_Day__c,
								                                         rC_Bios__Start_Date__c,
								                                         rC_Bios__End_Date__c,
								                                         rC_Bios__Preferred_Other__c, 
								                                         rC_Bios__Preferred_Mailing__c,
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
                                                         OrgName2__c,OrgName__c
					                                       FROM rC_Bios__Contact_Address__c WHERE   
					                                       rC_Bios__Contact__c = :this.contact.ID]) {
            
            lstAddress.add(new ContactAddressWrapper(cnAdd));
            mapCntAddresses.put(cnAdd.Id, fetchAddress(cnAdd));
                                                                    
    }
  }
  
  
  //=============================================//
  //Query Contact
  //=============================================// 
  private void queryContact() {
    List<Contact> lstContact = [SELECT Id,Name FROM Contact 
                               WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
    if(lstContact.size() == 0) {
      this.contact = new Contact();
      return;
    }        
    this.contact = lstContact[0];                    
  }
  
  public PageReference upsertContactAddressList() {
    isAddressInvalid = false;
    List<rC_Bios__Contact_Address__c> cntAddList = new List<rC_Bios__Contact_Address__c>();
    Boolean isValidSeasonalDates = false;
    Boolean isValidActiveDates = false;
    AddressService.AddressServiceResult addressResult;
    nameError = false;
    
    for(ContactAddressWrapper caw : lstAddress) {
    	isValidSeasonalDates = false;
    	isValidActiveDates = false;
    	caw.nameError = false;
            if((caw.cntAddress.rC_Bios__Preferred_Other__c || caw.cntAddress.rC_Bios__Preferred_Mailing__c) && !caw.cntAddress.rC_Bios__Active__c) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Address can not be inactive if it is selected as preferred'));
                return null;
            } 
            if(caw.cntAddress.rC_Bios__Seasonal_Start_Month__c == null && caw.cntAddress.rC_Bios__Seasonal_Start_Day__c == null 
                    && caw.cntAddress.rC_Bios__Seasonal_End_Day__c == null  && caw.cntAddress.rC_Bios__Seasonal_End_Day__c == null ) {
                isValidSeasonalDates = true;
            }
            if(caw.cntAddress.rC_Bios__Seasonal_Start_Month__c != null && caw.cntAddress.rC_Bios__Seasonal_Start_Day__c != null 
                    && caw.cntAddress.rC_Bios__Seasonal_End_Day__c != null  && caw.cntAddress.rC_Bios__Seasonal_End_Day__c != null) {
                isValidSeasonalDates = true;
            }
            
            if(!isValidSeasonalDates) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Please either complete or clear out seasonal address information'));
                return null;
            }
            
            if(caw.cntAddress.rC_Bios__Start_Date__c == null && caw.cntAddress.rC_Bios__End_Date__c == null) {
				    	isValidActiveDates = true;
				    }
				    if(caw.cntAddress.rC_Bios__Start_Date__c != null && caw.cntAddress.rC_Bios__End_Date__c != null) {
				    	isValidActiveDates = true;
				    }
				    
				    if(!isValidActiveDates) {
				        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Please either complete or clear out active address information'));
				        return null;
				    }
				    
				    if(caw.cntAddress.rC_Bios__Start_Date__c > caw.cntAddress.rC_Bios__End_Date__c) {
				    	ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Active End Date can not be less then Start Date'));
				        return null;
				    }
            
        if(caw.isOverride || isAddressEdited(fetchAddress(caw.cntAddress), mapCntAddresses.get(caw.cntAddress.Id))) {
            system.debug(':: is Override and Updated  ::'+caw.isOverride);
            if(!caw.isOverride && (caw.cntAddress.rC_Bios__Original_Country__c == null || caw.cntAddress.rC_Bios__Original_Country__c.equalsIgnoreCase('USA')
                                                            || caw.cntAddress.rC_Bios__Original_Country__c.equalsIgnoreCase('US') || caw.cntAddress.rC_Bios__Original_Country__c.equalsIgnoreCase('United States'))) {
                if(!isEmptyAddress(caw.cntAddress)) {
                    caw.isStreetBlank = false;
                    caw.isStateBlank = false;
                    caw.isCityBlank = false;
                    if((caw.cntAddress.rC_Bios__Original_Country__c.equalsIgnoreCase('USA') || caw.cntAddress.rC_Bios__Original_Country__c.equalsIgnoreCase('US') ||
                            caw.cntAddress.rC_Bios__Original_Country__c.equalsIgnoreCase('United States')) && caw.cntAddress.rC_Bios__Original_State__c.length() > 2) {
                        caw.isStateWrong = true;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Please enter two letter state abbreviation'));
                        if(caw.cntAddress.rC_Bios__Original_Postal_Code__c.equals('00000')) {
                            caw.cntAddress.rC_Bios__Original_Postal_Code__c = '';
                        }
                            return null;
                    }
                    caw.isStateWrong = false;
                    if(!Test.isRunningTest()){
					 	   				try{
					 	   					addressResult = AddressService.Validate(fetchAddress(caw.cntAddress));
					 	   				} catch(Exception e) {
	 	   									ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info, 'The time limit to validate the address has been exceeded, please refine the address entered or override the validation.'));
                        caw.hasError = true;
                        if(caw.cntAddress.rC_Bios__Original_Postal_Code__c.equals('00000')) {
                          caw.cntAddress.rC_Bios__Original_Postal_Code__c = '';
                        }
					 	   				}
					  	 		 	}else{
					  	 		 		if(isInvalidTestAddress){
					  	 		 			addressResult = AddressService.validateForTest(fetchAddress(caw.cntAddress), false,false);
					  	 		 		}else if (isServiceDown) {
					  	 		 			addressResult = AddressService.validateForTest(fetchAddress(caw.cntAddress), false,true);
					  	 		 		}else{
					  	 		 		  addressResult = AddressService.validateForTest(fetchAddress(caw.cntAddress), true,false);
					  	 		 		}
					  	 		 	}
                    
                    if(addressResult.statusCode.equals('503')) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info, 'Address can not be validated now, Please check Override if you still want to save this.'));
                        caw.hasError = true;
                        if(caw.cntAddress.rC_Bios__Original_Postal_Code__c.equals('00000')) {
                            caw.cntAddress.rC_Bios__Original_Postal_Code__c = '';
                        }
                    }
        
                    if(addressResult.isValid) {
                        copyValidatedAddress(addressResult.addressOutput[0], caw.cntAddress);
                        
                        cntAddList.add(caw.cntAddress);
                        caw.hasError = false;
                    } else {
                        isAddressInvalid = true;
                        caw.hasError = true;
                        if(caw.cntAddress.rC_Bios__Original_Postal_Code__c.equals('00000')) {
                            caw.cntAddress.rC_Bios__Original_Postal_Code__c = '';
                        }
                    }
                } else {
                    if(String.isBlank(caw.cntAddress.rC_Bios__Original_Street_Line_1__c) && String.isBlank(caw.cntAddress.rC_Bios__Original_State__c) && String.isBlank(caw.cntAddress.rC_Bios__Original_City__c)) {
                        continue;
                    }
                    if(caw.cntAddress.rC_Bios__Original_Street_Line_1__c == null) {
                        caw.isStreetBlank = true;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Street Line 1 field is required to validate the address'));
                    } else {
                        caw.isStreetBlank = false;
                    }
                    if(caw.cntAddress.rC_Bios__Original_State__c == null) {
                        caw.isStateBlank = true;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'State field is required to validate the address'));
                    } else {
                        caw.isStateBlank = false;
                    }
                    if(caw.cntAddress.rC_Bios__Original_City__c == null) {
                        caw.isCityBlank = true;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'City field is required to validate the address'));
                    } else {
                        caw.isCityBlank = false;
                    }
                    return null;
                }
            } else {
                cntAddList.add(caw.cntAddress);
                caw.hasError = false;
            }
        } else {
            cntAddList.add(caw.cntAddress);
        }
        
    }
    
    if(isOverride  || (contactAddressToInsert.rC_Bios__Original_Country__c != null && !(contactAddressToInsert.rC_Bios__Original_Country__c.equalsIgnoreCase('USA')
                                    || contactAddressToInsert.rC_Bios__Original_Country__c.equalsIgnoreCase('US') || contactAddressToInsert.rC_Bios__Original_Country__c.equalsIgnoreCase('United States')))) {
        contactAddressToInsert.rC_Bios__Contact__c = contact.Id;
        cntAddList.add(contactAddressToInsert);
        hasError = false;
    } else {
        if(!isEmptyAddress(contactAddressToInsert)) {
            isStreetBlank = false;
            isStateBlank = false;
            isCityBlank = false;
            if((contactAddressToInsert.rC_Bios__Original_Country__c.equalsIgnoreCase('USA')|| contactAddressToInsert.rC_Bios__Original_Country__c.equalsIgnoreCase('US')) && contactAddressToInsert.rC_Bios__Original_State__c.length() > 2) {
                isStateWrong = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Please enter two letter state abbreviation'));
                if(contactAddressToInsert.rC_Bios__Original_Postal_Code__c.equals('00000')) {
                    contactAddressToInsert.rC_Bios__Original_Postal_Code__c = '';
                }
                    return null;
            }
            isStateWrong = false;
            
            //  aaddressResult = AddressService.Validate(contactAddressToInsert); 
            if(!Test.isRunningTest()){
			 	   		try {
			 	   			addressResult = AddressService.Validate(fetchAddress(contactAddressToInsert));
			 	   		} catch(Exception e) {
 	   						ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info, 'The time limit to validate the address has been exceeded, please refine the address entered or override the validation.'));
                hasError = true;
                if(contactAddressToInsert.rC_Bios__Original_Postal_Code__c.equals('00000')) {
                  contactAddressToInsert.rC_Bios__Original_Postal_Code__c = '';
                }
                return null;
				 	   	}
		  	  	} else{
					 		if(isInvalidTestAddress){
					 			addressResult = AddressService.validateForTest(fetchAddress(contactAddressToInsert), false,false);
			 		 		}else{
			 		 		  addressResult = AddressService.validateForTest(fetchAddress(contactAddressToInsert), true,false);
			 		 		}
			 		 	}
            if(addressResult.statusCode.equals('503')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info, 'Address can not be validated now, Please check Override if you still want to save this.'));
                hasError = true;
                if(contactAddressToInsert.rC_Bios__Original_Postal_Code__c.equals('00000')) {
                    contactAddressToInsert.rC_Bios__Original_Postal_Code__c = '';
                }
                return null;
            }
            if(addressResult.isValid) {
                copyValidatedAddress(addressResult.addressOutput[0], contactAddressToInsert);
                contactAddressToInsert.rC_Bios__Contact__c = contact.Id;
                
                cntAddList.add(contactAddressToInsert);
                hasError = false;
            } else {
                isAddressInvalid = true;
                hasError = true;
                if(contactAddressToInsert.rC_Bios__Original_Postal_Code__c.equals('00000')) {
                    contactAddressToInsert.rC_Bios__Original_Postal_Code__c = '';
                }
            }
        } else {
            if(!String.isBlank(contactAddressToInsert.rC_Bios__Original_Street_Line_1__c) || !String.isBlank(contactAddressToInsert.rC_Bios__Original_State__c) || !String.isBlank(contactAddressToInsert.rC_Bios__Original_City__c)) {
                if(contactAddressToInsert.rC_Bios__Original_Street_Line_1__c == null) {
                    isStreetBlank = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Street Line 1 field is required to validate the address'));
                } else {
                    isStreetBlank = false;
                }
                if(contactAddressToInsert.rC_Bios__Original_State__c == null) {
                    isStateBlank = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'State field is required to validate the address'));
                } else {
                    isStateBlank = false;
                }
                if(contactAddressToInsert.rC_Bios__Original_City__c == null) {
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
    
    if((contactAddressToInsert.rC_Bios__Preferred_Other__c || contactAddressToInsert.rC_Bios__Preferred_Other__c) && !contactAddressToInsert.rC_Bios__Active__c) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Address can not be inactive if it is selected as preferred'));
        return null;
    } 
    if(contactAddressToInsert.rC_Bios__Seasonal_Start_Month__c == null && contactAddressToInsert.rC_Bios__Seasonal_Start_Day__c == null 
            && contactAddressToInsert.rC_Bios__Seasonal_End_Month__c == null  && contactAddressToInsert.rC_Bios__Seasonal_End_Day__c == null ) {
        isValidSeasonalDates = true;
    }
    if(contactAddressToInsert.rC_Bios__Seasonal_Start_Month__c != null && contactAddressToInsert.rC_Bios__Seasonal_Start_Day__c != null 
            && contactAddressToInsert.rC_Bios__Seasonal_End_Month__c != null  && contactAddressToInsert.rC_Bios__Seasonal_End_Day__c != null) {
        isValidSeasonalDates = true;
    }
    
    if(!isValidSeasonalDates) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Please either complete or clear out seasonal address information'));
        return null;
    }
    
    if(contactAddressToInsert.rC_Bios__Start_Date__c == null && contactAddressToInsert.rC_Bios__End_Date__c == null) {
    	isValidActiveDates = true;
    }
    if(contactAddressToInsert.rC_Bios__Start_Date__c != null && contactAddressToInsert.rC_Bios__End_Date__c != null) {
    	isValidActiveDates = true;
    }
    
    if(!isValidActiveDates) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Please either complete or clear out active address information'));
        return null;
    }
    
    if(contactAddressToInsert.rC_Bios__Start_Date__c > contactAddressToInsert.rC_Bios__End_Date__c) {
    	ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Active End Date can not be less then Start Date'));
    	return null;
    } 
    
    if(!checkSameTypeActiveDatesConflicts(cntAddList)) {
      if(cntAddList.size() > 0) {
        cntAddList.remove(cntAddList.size() - 1);
      }
      ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Active Dates of Same Type of addresses are overlapping'));
      return null;
    }
    
    if(!velidateMultiplePreference(cntAddList)) {
      if(cntAddList.size() > 0) {
        cntAddList.remove(cntAddList.size() - 1);
      }
      ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Seasonal dates of preferred addresses are overlapping'));
      return null;
    }
    
    if(!checkPreferencesConflicts(cntAddList)) {
      if(cntAddList.size() > 0) {
        cntAddList.remove(cntAddList.size() - 1);
      }
      ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Seasonal dates of preferred addresses are overlapping'));
      return null;
    }
    
    if(!checkAtLeastOnePreferredBilling(cntAddList)) {
      if(cntAddList.size() > 0) {
        cntAddList.remove(cntAddList.size() - 1);
      }
      ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'An Address must be selected as the Preferred Mailing Address'));
      return null;
    }

    if(isAddressInvalid) {
	    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Address(es) not Validated.'));
	    return null;
		}
    
    if(cntAddList.size() > 0) {
        List<Database.Upsertresult> upsertResults = database.upsert(cntAddList, false);
        integer cnt = 0;
        Boolean errorFound = false;
        for(Database.Upsertresult ur : upsertResults) {
            if(!ur.isSuccess()) {
            	errorFound = true;
                String errMessage = ur.getErrors().get(0).getMessage();
//                system.debug('ERR :::: ' + errMessage + ' ' + lstAddress.get(cnt).cntAddress.rC_Bios__Original_Street_Line_1__c);
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
                    mapCntAddresses.put(lstAddress.get(cnt).cntAddress.Id, fetchAddress(lstAddress.get(cnt).cntAddress));
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
        
        for(rC_Bios__Contact_Address__c cntAdd : cntAddList) {
            if(!mapCntAddresses.containsKey(cntAdd.Id)) {
                lstAddress.add(new ContactAddressWrapper(cntAdd));
            }
            mapCntAddresses.put(cntAdd.Id, fetchAddress(cntAdd));
        }
    }
    
    contactAddressToInsert = new rC_Bios__Contact_Address__c(rC_Bios__Type__c = 'Business',rC_Bios__Active__c=true);
    hasError = false;
    //isOverride = false;
    isSaved = true;
    return null;
  }
  
  public PageReference upsertContactAddressListAndReturn() {
  	isSaved = false;
		upsertContactAddressList();
		if(isSaved) {
	    return new PageReference('/'+contact.Id);
		}
		return null;
  }
  
  private rC_Bios__Address__c fetchAddress(rC_Bios__Contact_Address__c cntAdd) {
    rC_Bios__Address__c address = new rC_Bios__Address__c();
    address.Id = cntAdd.rC_Bios__Address__c;
    address.rC_Bios__Street_Line_1__c = cntAdd.rC_Bios__Original_Street_Line_1__c;
    address.rC_Bios__Street_Line_2__c = cntAdd.rC_Bios__Original_Street_Line_2__c;
    address.rC_Bios__State__c = cntAdd.rC_Bios__Original_State__c;
    address.rC_Bios__Country__c = cntAdd.rC_Bios__Original_Country__c;
    address.rC_Bios__City__c = cntAdd.rC_Bios__Original_City__c;
    address.rC_Bios__ZIP__c = cntAdd.rC_Bios__Original_Postal_Code__c;
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
  
  private Boolean isEmptyAddress(rC_Bios__Contact_Address__c cntAddress) {
    if(String.isBlank(cntAddress.rC_Bios__Original_Street_Line_1__c) || String.isBlank(cntAddress.rC_Bios__Original_State__c) || String.isBlank(cntAddress.rC_Bios__Original_City__c)) {
        return true;
    } else {
            if(cntAddress.rC_Bios__Original_Country__c == null) {cntAddress.rC_Bios__Original_Country__c = 'USA';}
            if(cntAddress.rC_Bios__Original_Postal_Code__c == null) {cntAddress.rC_Bios__Original_Postal_Code__c = '00000';}
    }
    return false;
  }
  
  public class ContactAddressWrapper {
    public rC_Bios__Contact_Address__c cntAddress{get;set;}
    public Boolean hasError{get;set;}
    public Boolean isOverride{get;set;}
    public Boolean isStateBlank{get;set;}
    public Boolean isStreetBlank{get;set;}
    public Boolean isCityBlank{get;set;}
    public Boolean isStateWrong{get;set;}
    public Boolean nameError{get;set;}
    public String errorMsg{get;set;}
    
    public ContactAddressWrapper() {
    }
    
    public ContactAddressWrapper(rC_Bios__Contact_Address__c cntAddress) {
        this.cntAddress = cntAddress;
        hasError = false;
        isOverride = false;
        isStateBlank = false;
        isStreetBlank = false;
        isStateWrong = false;
        errorMsg = '';
    }
  }
  
	private Boolean checkSameTypeActiveDatesConflicts(List<rC_Bios__Contact_Address__c> contactAddresses) {
  	Map<String, List<String>> datesMap = new Map<String, List<String>>();
  	Set<String> nullDatedActiveAddressSet = new Set<String>();
    Date eStartDate, eEndDate, cStartDate, cEndDate;
    String cYear;
    for(rC_Bios__Contact_Address__c cntAdd : contactAddresses) {
	    if(cntAdd.rC_Bios__Active__c) {
	        if(!datesMap.containsKey(cntAdd.rC_Bios__Type__c)) {
	        	datesMap.put(cntAdd.rC_Bios__Type__c, new List<String>()) ;
	        } else {
	            if(cntAdd.rC_Bios__Seasonal_Start_Month__c != null) {
	                cStartDate = System.Date.newInstance(Date.Today().Year(), Integer.valueOf(cntAdd.rC_Bios__Seasonal_Start_Month__c), Integer.valueOf(cntAdd.rC_Bios__Seasonal_Start_Day__c));
	                cYear = String.valueOf(cntAdd.rC_Bios__End_Date__c == null ? Date.Today().Year() : cntAdd.rC_Bios__End_Date__c.Year());
	                for(String val : datesMap.get(cntAdd.rC_Bios__Type__c)) {
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
	      datesMap.get(cntAdd.rC_Bios__Type__c).add(cntAdd.rC_Bios__Seasonal_Start_Day__c + '-' + cntAdd.rC_Bios__Seasonal_Start_Month__c + 
	                                                                                '@' + cntAdd.rC_Bios__Seasonal_End_Day__c + '-' + cntAdd.rC_Bios__Seasonal_End_Month__c + 
	                                                                                '@' + (cntAdd.rC_Bios__End_Date__c == null ? Date.Today().Year() : cntAdd.rC_Bios__End_Date__c.Year()));
	    }
    }
    return true;
  }
  
  private Boolean checkPreferencesConflicts(List<rC_Bios__Contact_Address__c> contactAddresses) {
    Map<String, List<String>> datesMap = new Map<String, List<String>>();
    Date eStartDate, eEndDate, cStartDate, cEndDate;
    String cYear;
    for(rC_Bios__Contact_Address__c cntAdd : contactAddresses) {
        if(cntAdd.rC_Bios__Preferred_Other__c) {
            if(!datesMap.containsKey('Preferred Other')) {
                datesMap.put('Preferred Other', new List<String>()) ;
            } else {
                if(cntAdd.rC_Bios__Seasonal_Start_Month__c != null) {
                    cStartDate = System.Date.newInstance(Date.Today().Year(), Integer.valueOf(cntAdd.rC_Bios__Seasonal_Start_Month__c), Integer.valueOf(cntAdd.rC_Bios__Seasonal_Start_Day__c));
                    cYear = String.valueOf(cntAdd.rC_Bios__End_Date__c == null ? Date.Today().Year() : cntAdd.rC_Bios__End_Date__c.Year());
                    for(String val : datesMap.get('Preferred Other')) {
                        String[] temp = val.split('@');
                        eStartDate = System.Date.newInstance(Date.Today().Year(), Integer.valueOf(temp[0].substring(temp[0].indexOf('-') + 1)), Integer.valueOf(temp[0].substring(0, temp[0].indexOf('-'))));
                        eEndDate = System.Date.newInstance(Date.Today().Year(), Integer.valueOf(temp[1].substring(temp[1].indexOf('-') + 1)), Integer.valueOf(temp[1].substring(0, temp[1].indexOf('-'))));
                        if(cStartDate >= eStartDate && cStartDate <= eEndDate && cYear.equals(temp[2])) {
                            return false;
                        }
                    }
                }
          }
            datesMap.get('Preferred Other').add(cntAdd.rC_Bios__Seasonal_Start_Day__c + '-' + cntAdd.rC_Bios__Seasonal_Start_Month__c + 
                                                                                    '@' + cntAdd.rC_Bios__Seasonal_End_Day__c + '-' + cntAdd.rC_Bios__Seasonal_End_Month__c + 
                                                                                    '@' + (cntAdd.rC_Bios__End_Date__c == null ? Date.Today().Year() : cntAdd.rC_Bios__End_Date__c.Year()));
        }
        if(cntAdd.rC_Bios__Preferred_Mailing__c) {
            if(!datesMap.containsKey('Preferred Mailing')) {
                datesMap.put('Preferred Mailing', new List<String>()) ;
            } else {
                if(cntAdd.rC_Bios__Seasonal_Start_Month__c != null) {
                    cStartDate = System.Date.newInstance(Date.Today().Year(), Integer.valueOf(cntAdd.rC_Bios__Seasonal_Start_Month__c), Integer.valueOf(cntAdd.rC_Bios__Seasonal_Start_Day__c));
                    cYear = String.valueOf(cntAdd.rC_Bios__End_Date__c == null ? Date.Today().Year() : cntAdd.rC_Bios__End_Date__c.Year());
                    for(String val : datesMap.get('Preferred Mailing')) {
                        String[] temp = val.split('@');
                        eStartDate = System.Date.newInstance(Date.Today().Year(), Integer.valueOf(temp[0].substring(temp[0].indexOf('-') + 1)), Integer.valueOf(temp[0].substring(0, temp[0].indexOf('-'))));
                        eEndDate = System.Date.newInstance(Date.Today().Year(), Integer.valueOf(temp[1].substring(temp[1].indexOf('-') + 1)), Integer.valueOf(temp[1].substring(0, temp[1].indexOf('-'))));
                        if(cStartDate >= eStartDate && cStartDate <= eEndDate && cYear.equals(temp[2])) {
                            return false;
                        }
                    }
                }
            }
            datesMap.get('Preferred Mailing').add(cntAdd.rC_Bios__Seasonal_Start_Day__c + '-' + cntAdd.rC_Bios__Seasonal_Start_Month__c + 
                                                                                    '@' + cntAdd.rC_Bios__Seasonal_End_Day__c + '-' + cntAdd.rC_Bios__Seasonal_End_Month__c + 
                                                                                    '@' + (cntAdd.rC_Bios__End_Date__c == null ? Date.Today().Year() : cntAdd.rC_Bios__End_Date__c.Year()));
        }
    }
    return true;
  }
  
  private Boolean velidateMultiplePreference(List<rC_Bios__Contact_Address__c> contactAddresses) {
    Set<Id> preferredBillingSet = new Set<Id>();
    Set<Id> preferredShippingSet = new Set<Id>();
    
    for(rC_Bios__Contact_Address__c cntAdd : contactAddresses) {
        if(cntAdd.rC_Bios__Seasonal_Start_Month__c == null && cntAdd.rC_Bios__Preferred_Other__c) {
            preferredBillingSet.add(cntAdd.Id);
        }
        if(cntAdd.rC_Bios__Seasonal_Start_Month__c == null && cntAdd.rC_Bios__Preferred_Mailing__c) {
            preferredShippingSet.add(cntAdd.Id);
        }
        
        if(preferredBillingSet.size() > 1 || preferredShippingSet.size() > 1) {
            return false;
        }
    }
    return true;
  }
  
  private Boolean checkAtLeastOnePreferredBilling(List<rC_Bios__Contact_Address__c> contactAddresses) {
    if(contactAddresses.size() <= 1) {
      return true;        //If there is only one address, we allow it to be saved as non preferred billing address. As per I-111987
    }

    for(rC_Bios__Contact_Address__c cntAdd : contactAddresses) {
      if(cntAdd.rC_Bios__Preferred_Mailing__c) {
        return true;
      }
    }
    return false;
  }

  private void copyValidatedAddress(rC_Bios__Address__c srcAdd, rC_Bios__Contact_Address__c destAdd) {
    destAdd.rC_Bios__Original_City__c = srcAdd.rC_Bios__City__c;   
    destAdd.rC_Bios__Original_Country__c = srcAdd.rC_Bios__Country__c;
    destAdd.rC_Bios__Original_Postal_Code__c = srcAdd.rC_Bios__ZIP__c;
    destAdd.rC_Bios__Original_State__c  = srcAdd.rC_Bios__State__c;
    destAdd.rC_Bios__Original_Street_Line_1__c = srcAdd.rC_Bios__Street_Line_1__c;
    destAdd.rC_Bios__Original_Street_Line_2__c = srcAdd.rC_Bios__Street_Line_2__c;
  }

}