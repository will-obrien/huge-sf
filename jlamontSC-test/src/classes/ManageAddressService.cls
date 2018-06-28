// *************************************************************************/
// ManageAddressService Class
//
//  2015/06/22      Mark Maslow         Replace Country USA, US or United States with empty string
//  2017/03/09      Vernon Baas         Adding support for USPS Deliverable?
//  2017/04/25      Vernon Baas         Removing requirement of a preferred billing address
// *************************************************************************/
public with sharing class ManageAddressService {

    
  public List<AddressWrapper> lstAddress{get;set;}
  private Map<Id, rC_Bios__Address__c> mapAddresses;
  
  public sObject addressToInsert{get;set;}

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
  public String PrimaryPreferredField;
  public String SecondaryPreferredField;
  public String ParentFieldName;
  
  
  //MM Begin
  public String defaultAddressType;
  private KnowWhoAccountAddressService kws;
  //MM End
  public List<sObject> rcAddressList;
  public String sObjectName;
  public String SourceId;
    //MM Begin
    // Look up the Record Types    
    
    public ManageAddressService() {
        defaultAddressType = 'Business';
        hasError = false;
        isOverride = false;
        nameError = false;
        isSaved = false;
        errorMsg = '';
    }
    
    //addressToInsert.put('rC_Bios__Type__c', defaultAddressType);
    
    
  
public PageReference upsertAccountAddressList() {
    isAddressInvalid = false;
    //rcAddressList = new List<sObject>();
    Boolean isValidSeasonalDates = false;
    Boolean isValidActiveDates = false;

    //kwzd.KWD_SingleRecordUpdate kws = new kwzd.KWD_SingleRecordUpdate();

    nameError = false;

for(AddressWrapper aaw : lstAddress) {
    
    isValidSeasonalDates = false;
    isValidActiveDates = false;
    aaw.nameError = false;

    String sCheck =  bCheckValidAddressInformation (aaw.rcAddress);
        if (sCheck != 'Success' ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info, sCheck));
            return null;
        }

    //If Override, add and move on
    if(aaw.isOverride) {
        system.debug('Overridden Address = ' + aaw.rcAddress);
        rcAddressList.add(aaw.rcAddress);
        aaw.hasError = false;
        isAddressInvalid = false;
        break;
    }

    else {
        if(isAddressEdited(fetchAddress(aaw.rcAddress), mapAddresses.get(aaw.rcAddress.Id))) {
            system.debug('Updated  ::' );

    //Process Address Change for USA addresses (assume NULL = USA)
            String sCountryString = (String)aaw.rcAddress.get('rC_Bios__Original_Country__c');
            if(sCountryString == null || KnowWhoAccountAddressService.bCheckUSA(sCountryString)) {
                
                if(!isEmptyAddress(aaw.rcAddress)) {
                    aaw.isStreetBlank = false;
                    aaw.isStateBlank = false;
                    aaw.isCityBlank = false;
                    String sStateValue = (String)aaw.rcAddress.get('rC_Bios__Original_State__c');
                        if (KnowWhoAccountAddressService.bCheckUSA(sCountryString) && sStateValue.length() > 2) {
                            aaw.isStateWrong = true;
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Please enter two letter state abbreviation'));
                            return null;
                        }

                    aaw.isStateWrong = false;

                    //Valid Address, so process
                    try{
                        kws = new KnowWhoAccountAddressService();
                        kws.getAddressInfo(aaw.rcAddress);
                    } 

                    catch(Exception e) {
                    
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info, 'Error with Address Validate Service.'));
                        aaw.hasError = true;
                        return null;
                    }

                    //Now Process Response    
                    if (kws.bError) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info, kws.sErrorMessage));
                        aaw.hasError = true;
                        return null;
                    }

                    else {
                        // ZDM did not return an error
                        rcAddressList.add(aaw.rcAddress);
                        aaw.hasError = false;
                    }

                } //end is empty check  

                //address was empty
            } //end USA check
            else { //if no USA just save
                //First remove any ZDM fields, since not valid for Non USA
                aaw.rcAddress = removeZDMData(aaw.rcAddress);
                rcAddressList.add(aaw.rcAddress);
                isAddressInvalid = false;
                aaw.hasError = false;
            }
    }//end edited
  else {
  //Even if address details were not edited, we include in save in case other details were
          rcAddressList.add(aaw.rcAddress);
          aaw.hasError = false;
  }
  

}//end override

}//end loop

//now check new account address if populated
//IF override OR Non USA, and country is populated just save    

String sCountrytoInsert =  (String)addressToInsert.get('rC_Bios__Original_Country__c');

if(isOverride  || (sCountrytoInsert != null && KnowWhoAccountAddressService.bCheckUSA(sCountrytoInsert) == FALSE) ) {
	system.debug('AAI Overridden' + addressToInsert);
    addressToInsert.put(ParentFieldName, SourceId);
    rcAddressList.add(addressToInsert);
    hasError = false;
} 

else {
    system.debug('AAI' + addressToInsert);
    //Check address has data in it
    if(!isEmptyAddress(addressToInsert)) {
        isStreetBlank = false;
        isStateBlank = false;
        isCityBlank = false;
        //Check Country if country is US that State = 2 chars 
        String sStatetoInsert = (String)addressToInsert.get('rC_Bios__Original_State__c');
        if( (KnowWhoAccountAddressService.bCheckUSA(sCountrytoInsert) == TRUE) && sStatetoInsert != NULL && sStatetoInsert.length() > 2) {
            isStateWrong = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Please enter two letter state abbreviation'));
            return null;
            }
        isStateWrong = false;
        
                //Valid Address, so process
                    try{
                        kws = new KnowWhoAccountAddressService();
                        kws.getAddressInfo(addressToInsert);
                    } 

                    catch(Exception e) {
                    
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info, 'Error with Address Validate Service.'));
                        hasError = true;
                        return null;
                    }
                    
            //Now Process Response    
            if (kws.bError) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info, kws.sErrorMessage));
                hasError = true;
                IsOverride = true;
        
                return null;
            }

            else {
                // ZDM did not return an error
                addressToInsert.put(ParentFieldName, SourceId);
                rcAddressList.add(addressToInsert);
                hasError = false;
                
            }
            
        }//end empty check 

            
    } //end override check 

        /*
        else {
            if(!String.isBlank(addressToInsert.rC_Bios__Original_Street_Line_1__c) || !String.isBlank(addressToInsert.rC_Bios__Original_State__c) || !String.isBlank(addressToInsert.rC_Bios__Original_City__c)) {
                if(addressToInsert.rC_Bios__Original_Street_Line_1__c == null) {
                    isStreetBlank = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Street Line 1 field is required to validate the address'));
                } else {
                    isStreetBlank = false;
                }
                if(addressToInsert.rC_Bios__Original_State__c == null) {
                    isStateBlank = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'State field is required to validate the address'));
                } else {
                    isStateBlank = false;
                }
                if(addressToInsert.rC_Bios__Original_City__c == null) {
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
    */

    isValidSeasonalDates = false;
    isValidActiveDates = false;
    
    if( ((Boolean)addressToInsert.get(PrimaryPreferredField) || (Boolean)addressToInsert.get(SecondaryPreferredField) ) && (Boolean)addressToInsert.get('rC_Bios__Active__c') == FALSE ){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Address can not be inactive if it is selected as preferred'));
        return null;
    } 
    if(addressToInsert.get('rC_Bios__Seasonal_Start_Month__c') == null && addressToInsert.get('rC_Bios__Seasonal_Start_Day__c') == null 
            && addressToInsert.get('rC_Bios__Seasonal_End_Month__c') == null  && addressToInsert.get('rC_Bios__Seasonal_End_Day__c') == null ) {
        isValidSeasonalDates = true;
    }
    if(addressToInsert.get('rC_Bios__Seasonal_Start_Month__c') != null && addressToInsert.get('rC_Bios__Seasonal_Start_Day__c') != null 
            && addressToInsert.get('rC_Bios__Seasonal_End_Month__c') != null  && addressToInsert.get('rC_Bios__Seasonal_End_Day__c') != null) {
        isValidSeasonalDates = true;
    }
    
    if(!isValidSeasonalDates) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Please either complete or clear out seasonal address information'));
        return null;
    }
    
    if(addressToInsert.get('rC_Bios__Start_Date__c') == null && addressToInsert.get('rC_Bios__End_Date__c') == null) {
        isValidActiveDates = true;
    }
    if(addressToInsert.get('rC_Bios__Start_Date__c') != null && addressToInsert.get('rC_Bios__End_Date__c') != null) {
        isValidActiveDates = true;
    }
    
    if(!isValidActiveDates) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Please either complete or clear out active address information'));
        return null;
    }
    
    if((Date)addressToInsert.get('rC_Bios__Start_Date__c') > (Date)addressToInsert.get('rC_Bios__End_Date__c') ) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Active End Date can not be less then Start Date'));
        return null;
    } 
    
    if(!checkSameTypeActiveDatesConflicts(rcAddressList)) {
      if(rcAddressList.size() > 0) {
        rcAddressList.remove(rcAddressList.size() - 1);
      }
      ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Active Dates of Same Type of addresses are overlapping'));
      return null;
    }
    
    if(!velidateMultiplePreference(rcAddressList)) {
      if(rcAddressList.size() > 0) {
        rcAddressList.remove(rcAddressList.size() - 1);
      }
      ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Only one address can be marked as preferred'));
      return null;
    }
    
    if(!checkPreferencesConflicts(rcAddressList)) {
      if(rcAddressList.size() > 0) {
        rcAddressList.remove(rcAddressList.size() - 1);
      }
      ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Seasonal dates of preferred addresses are overlapping'));
      return null;
    }

    /* VB: 4/25/17 - Removing this check for a preferred billing address
    if(!checkAtLeastOnePreferredBilling(rcAddressList)) {
        if(rcAddressList.size() > 0) {
        rcAddressList.remove(rcAddressList.size() - 1);
      }
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'An Address must be selected as the Preferred Billing Address'));
        return null;
    }
    */
    
    if(isAddressInvalid) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Address(es) not Validated.'));
        return null;
    }
    
    if(rcAddressList.size() > 0) {
        
        //MM Start Change 6/22/2015
        for(sObject addr : rcAddressList) {
            String country = (String)addr.get('rC_Bios__Original_Country__c');
            if(country == 'United States' || country == 'USA' || country == 'US') {
                addr.put('rC_Bios__Original_Country__c', '');
            }
        }
        //MM End Change 6/22/2015
        system.debug ('Save List' + rcAddressList);
        List<Database.Upsertresult> upsertResults = database.upsert(rcAddressList, false);
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
                    } 
                    else {
                        nameError = true;
                        errorMsg = errMessage;
                    }   
               }
               ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, errMessage));
            }
            else {
                if(cnt < lstAddress.size()) {
                    lstAddress.get(cnt).nameError = false;
                    lstAddress.get(cnt).errorMsg = '';
                    lstAddress.get(cnt).isOverride = false;
                    mapAddresses.put(lstAddress.get(cnt).rcAddress.Id, fetchAddress(lstAddress.get(cnt).rcAddress));
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
        queryAddress();
        //
        
        for(sObject rcAdd : rcAddressList) {
            if(!mapAddresses.containsKey(rcAdd.Id)) {
                lstAddress.add(new AddressWrapper(rcAdd));
            }
            mapAddresses.put(rcAdd.Id, fetchAddress(rcAdd));
        }
    }
    
    Schema.SObjectType addressType = Schema.getGlobalDescribe().get(sObjectName);

    addressToInsert = addressType.newSObject(); 
    addressToInsert.put('rC_Bios__Type__c', defaultAddressType);
    addressToInsert.put('rC_Bios__Active__c', true);
    hasError = false;
    //isOverride = false;
    isSaved = true;
    return null;
  }
  
  public PageReference upsertAccountAddressListAndReturn() {
    isSaved = false;
        upsertAccountAddressList();
        if(isSaved) {
        return new PageReference('/'+SourceId);
        }
        return null;
  }
  
  private rC_Bios__Address__c fetchAddress(sObject rcAdd) {
    rC_Bios__Address__c address = new rC_Bios__Address__c();
    address.Id = (Id)rcAdd.get('rC_Bios__Address__c');
    address.rC_Bios__Street_Line_1__c = (String)rcAdd.get('rC_Bios__Original_Street_Line_1__c');
    address.rC_Bios__Street_Line_2__c = (String)rcAdd.get('rC_Bios__Original_Street_Line_2__c');
    address.rC_Bios__State__c = (String)rcAdd.get('rC_Bios__Original_State__c');
    address.rC_Bios__Country__c = (String)rcAdd.get('rC_Bios__Original_Country__c');
    address.rC_Bios__City__c = (String)rcAdd.get('rC_Bios__Original_City__c');
    address.rC_Bios__ZIP__c = (String)rcAdd.get('rC_Bios__Original_Postal_Code__c');
    system.debug('In fetch Address : ' + address);
    return address;
  }
  
  private Boolean isAddressEdited(sObject newAdd, rC_Bios__Address__c oldAdd) {
    system.debug('isAddressEdited current :  ' + newAdd);
    system.debug('isAddressEdited old :  ' + oldAdd);
    
    if(newAdd.get('rC_Bios__Street_Line_1__c') != oldAdd.rC_Bios__Street_Line_1__c ||
            newAdd.get('rC_Bios__Street_Line_2__c') != oldAdd.rC_Bios__Street_Line_2__c || 
            newAdd.get('rC_Bios__State__c') != oldAdd.rC_Bios__State__c ||
            newAdd.get('rC_Bios__Country__c') != oldAdd.rC_Bios__Country__c ||
            newAdd.get('rC_Bios__City__c') != oldAdd.rC_Bios__City__c ||
            newAdd.get('rC_Bios__ZIP__c') != oldAdd.rC_Bios__ZIP__c) {
        return true;
    } 
    return false;
  }
  
  private Boolean isEmptyAddress(sObject rcAddress) {
    if( String.isBlank((String)rcAddress.get('rC_Bios__Original_Street_Line_1__c')) ||
        String.isBlank((String)rcAddress.get('rC_Bios__Original_State__c')) || 
        String.isBlank((String)rcAddress.get('rC_Bios__Original_City__c')) ) {
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Please ensure there is a complete address'));
        return true;
    } else {
            if(rcAddress.get('rC_Bios__Original_Country__c') == null) {
              rcAddress.put('rC_Bios__Original_Country__c', 'USA');
            }
            //if(accAddress.rC_Bios__Original_Postal_Code__c == null) {accAddress.rC_Bios__Original_Postal_Code__c = '00000';}
    }
    return false;
  }
  
  public class AddressWrapper {
    public sObject rcAddress{get;set;}
    public Boolean hasError{get;set;}
    public Boolean isOverride{get;set;}
    public Boolean isStateBlank{get;set;}
    public Boolean isStreetBlank{get;set;}
    public Boolean isCityBlank{get;set;}
    public Boolean isStateWrong{get;set;}
    public Boolean nameError{get;set;}
    public String errorMsg{get;set;}
    
    public AddressWrapper() {
    }
    
    public AddressWrapper(sObject rcAddress) {
        this.rcAddress = rcAddress;
        hasError = false;
        isOverride = false;
        isStateBlank = false;
        isStreetBlank = false;
        isStateWrong = false;
        nameError = false;
        errorMsg = '';
    }
  }
  
    private Boolean checkSameTypeActiveDatesConflicts(List<sObject> rcAddresses) {
    Map<String, List<String>> datesMap = new Map<String, List<String>>();
    Set<String> nullDatedActiveAddressSet = new Set<String>();
    Date eStartDate, eEndDate, cStartDate, cEndDate;
    String cYear;
    for(sObject rcAdd : rcAddresses) {
        system.debug((String)rcAdd.get('rC_Bios__Type__c'));
        if((Boolean)rcAdd.get('rC_Bios__Active__c') ) {
            String srcType = (String)rcAdd.get('rC_Bios__Type__c');
            if(!datesMap.containsKey(srcType) ) {
                datesMap.put(srcType, new List<String>()) ;
            } else {
                if(rcAdd.get('rC_Bios__Seasonal_Start_Month__c') != null) {
                    cStartDate = System.Date.newInstance(Date.Today().Year(), Integer.valueOf(rcAdd.get('rC_Bios__Seasonal_Start_Month__c')), Integer.valueOf(rcAdd.get('rC_Bios__Seasonal_Start_Day__c')) );
                    cYear = String.valueOf(Date.Today().Year()); 
                    if (rcAdd.get('rC_Bios__End_Date__c') != null) {
                      Date dt = (Date)rcAdd.get('rC_Bios__End_Date__c');
                      cYear = String.valueof( dt.Year() );
                    }
                    for(String val : datesMap.get(srcType) ){
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
          Integer iYear = Date.Today().Year();
          if (rcAdd.get('rC_Bios__End_Date__c') != null) {
            Date dt = (date)rcAdd.get('rC_Bios__End_Date__c');
              iYear = dt.Year();
            } 

          datesMap.get(srcType).add((String)rcAdd.get('rC_Bios__Seasonal_Start_Day__c') + '-' + (String)rcAdd.get('rC_Bios__Seasonal_Start_Month__c') + 
                                                                                    '@' + (String)rcAdd.get('rC_Bios__Seasonal_End_Day__c') + '-' + (String)rcAdd.get('rC_Bios__Seasonal_End_Month__c') + '@' + iYear) ;
          }
    }
    return true;
  }
  
  private Boolean checkPreferencesConflicts(List<sObject> rcAddresses) {
  
    Map<String, List<String>> datesMap = new Map<String, List<String>>();
    Date eStartDate, eEndDate, cStartDate, cEndDate;
    String cYear;
    for(sObject rcAdd : rcAddresses) {
        if((Boolean)rcAdd.get(PrimaryPreferredField) ) {
            if(!datesMap.containsKey('Preferred Billing')) {
                datesMap.put('Preferred Billing', new List<String>()) ;
            } else {
                if(rcAdd.get('rC_Bios__Seasonal_Start_Month__c') != null) {
                    cStartDate = System.Date.newInstance(Date.Today().Year(), Integer.valueOf((String)rcAdd.get('rC_Bios__Seasonal_Start_Month__c')), Integer.valueOf((String)rcAdd.get('rC_Bios__Seasonal_Start_Day__c')) );
                    cYear = String.ValueOf(Date.Today().Year());
                    if (rcAdd.get('rC_Bios__End_Date__c') != null) {
                      Date dt = (date)rcAdd.get('rC_Bios__End_Date__c');
                      cYear = String.Valueof(dt.Year()); 
                    }
                    
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
            Integer iYear = Date.Today().Year();
            if (rcAdd.get('rC_Bios__End_Date__c') != null) {
              Date dt = (date)rcAdd.get('rC_Bios__End_Date__c');  
              iYear = dt.Year();
            } 

            datesMap.get('Preferred Billing').add((String)rcAdd.get('rC_Bios__Seasonal_Start_Day__c') + '-' + (String)rcAdd.get('rC_Bios__Seasonal_Start_Month__c') + 
                                                                                    '@' + (String)rcAdd.get('rC_Bios__Seasonal_End_Day__c') + '-' + (String)rcAdd.get('rC_Bios__Seasonal_End_Month__c') + 
                                                                                    '@' + iYear);
        }
        if((Boolean)rcAdd.get(SecondaryPreferredField) ) {
            if(!datesMap.containsKey('Preferred Shipping')) {
                datesMap.put('Preferred Shipping', new List<String>()) ;
            } else {
                if(rcAdd.get('rC_Bios__Seasonal_Start_Month__c') != null) {
                    cStartDate = System.Date.newInstance(Date.Today().Year(), Integer.valueOf((String)rcAdd.get('rC_Bios__Seasonal_Start_Month__c')), Integer.valueOf((String)rcAdd.get('rC_Bios__Seasonal_Start_Day__c')) );
                     cYear = String.ValueOf(Date.Today().Year());
                    if (rcAdd.get('rC_Bios__End_Date__c') != null) {
                      Date dt = (date)rcAdd.get('rC_Bios__End_Date__c');
                      cYear = String.ValueOf(dt.Year()); 
                    }
                    

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
           Integer iYear = Date.Today().Year();
            if (rcAdd.get('rC_Bios__End_Date__c') != null) {
              Date dt = (date)rcAdd.get('rC_Bios__End_Date__c');  
              iYear = dt.Year();
            } 

            datesMap.get('Preferred Shipping').add((String)rcAdd.get('rC_Bios__Seasonal_Start_Day__c') + '-' + (String)rcAdd.get('rC_Bios__Seasonal_Start_Month__c') + 
                                                                                    '@' + (String)rcAdd.get('rC_Bios__Seasonal_End_Day__c') + '-' + (String)rcAdd.get('rC_Bios__Seasonal_End_Month__c') + 
                                                                                    '@' + iYear);
        }
    }
  
    return true;
  }
  
  private Boolean velidateMultiplePreference(List<sObject> rcAddresses) {
    Set<Id> preferredBillingSet = new Set<Id>();
    Set<Id> preferredShippingSet = new Set<Id>();
    
    for(sObject rcAdd : rcAddresses) {
        if( rcAdd.get('rC_Bios__Seasonal_Start_Month__c') == null && (Boolean)rcAdd.get(PrimaryPreferredField) ) {
            preferredBillingSet.add(rcAdd.Id);
        }
        if(rcAdd.get('rC_Bios__Seasonal_Start_Month__c') == null && (Boolean)rcAdd.get(SecondaryPreferredField) ) {
            preferredShippingSet.add(rcAdd.Id);
        }
        
        if(preferredBillingSet.size() > 1 || preferredShippingSet.size() > 1) {
            return false;
        }
    }
    return true;
  }
  
  private Boolean checkAtLeastOnePreferredBilling(List<sObject> rcAddresses) {
    if(rcAddresses.size() <= 1) {
      return true;        //If there is only one address, we allow it to be saved as non preferred billing address. As per I-111987
    }

    for(sObject rcAdd : rcAddresses) {
      if((Boolean)rcAdd.get(PrimaryPreferredField) ) {
        return true;
      }
    }
    return false;
  }
  
  private String bCheckValidAddressInformation (sObject rcAddress) {

    String sResponse = 'Success';
    Boolean isValidSeasonalDates = false;
    Boolean isValidActiveDates = false;

     if( ((Boolean)rcAddress.get(PrimaryPreferredField) || (Boolean)rcAddress.get(SecondaryPreferredField)) && (Boolean)rcAddress.get('rC_Bios__Active__c') == FALSE) {
                sResponse = 'Address can not be inactive if it is selected as preferred';
      return sResponse;
      }


    if(rcAddress.get('rC_Bios__Seasonal_Start_Month__c') == null && rcAddress.get('rC_Bios__Seasonal_Start_Day__c') == null 
            && rcAddress.get('rC_Bios__Seasonal_End_Day__c') == null  && rcAddress.get('rC_Bios__Seasonal_End_Day__c') == null ) {
        isValidSeasonalDates = true;
    }

    if(rcAddress.get('rC_Bios__Seasonal_Start_Month__c') != null && rcAddress.get('rC_Bios__Seasonal_Start_Day__c') != null 
            && rcAddress.get('rC_Bios__Seasonal_End_Day__c') != null  && rcAddress.get('rC_Bios__Seasonal_End_Day__c') != null) {
        isValidSeasonalDates = true;
    }
    
    if(!isValidSeasonalDates) {
        sResponse = 'Please either complete or clear out seasonal address information';
        return sResponse;
    }
        
    if(rcAddress.get('rC_Bios__Start_Date__c') == null && rcAddress.get('rC_Bios__End_Date__c') == null) {
                isValidActiveDates = true;
    }
    
    if(rcAddress.get('rC_Bios__Start_Date__c') != null && rcAddress.get('rC_Bios__End_Date__c') != null) {
        isValidActiveDates = true;
    }
    
    if(!isValidActiveDates) {
        sResponse = 'Please either complete or clear out active address information';
        return sResponse;
    }
    
    if((date)rcAddress.get('rC_Bios__Start_Date__c') > (date)rcAddress.get('rC_Bios__End_Date__c')) {
        sResponse = 'Active End Date can not be less then Start Date';
        return sResponse;
    }
return sResponse;
}

public void queryAddress() {
    this.lstAddress = new List<AddressWrapper>();
    mapAddresses = new Map<Id, rc_Bios__Address__c>();

      String sQuery = 'SELECT ' +
'rC_Bios__Active__c,  ' +
'kwrc__ZTDM_Expiry_Date__c, ' +
'kwrc__KWD_Last_Processed_DT__c, ' +
'kwrc__Latitude__c,  ' +
'kwrc__Longitude__c, ' +
'kwrc__ZDM_Location__c, ' +
'kwrc__PO_Box__c, ' +
'kwrc__Zip_4__c, ' +
'kwrc__KW_USSenateDistrict__c, ' +
'kwrc__KW_USSenateDesc__c, ' +
'kwrc__KW_USHouseDistrict__c, ' +
'kwrc__KW_USHouseDesc__c, ' +
'kwrc__KW_StateSenateDistrict__c, ' +
'kwrc__KW_StateSenateDesc__c, ' +
'kwrc__KW_StateHouseDistrict__c, ' +
'kwrc__KW_StateHouseDesc__c, ' +
'kwrc__KW_CountyCode__c, ' +
'kwrc__KW_CountyName__c, ' +
'kwrc__KW_CountyDistrict__c, ' +
'kwrc__KW_CountyDistrictDesc__c, ' +
'kwrc__KW_MunicipalType__c, ' +
'kwrc__KW_MunicipalCode__c, ' +
'kwrc__KW_MunicipalName__c, ' +
'kwrc__KW_MunicipalDistrict__c, ' +
'kwrc__KW_MunicipalDistrictDesc__c, ' +
'kwrc__Elected_Officials_Ids__c, ' +
'kwrc__ZDM_Location__Longitude__s, ' +
'kwrc__ZDM_Location__Latitude__s, ' +
'rC_Bios__Type__c,  ' +
'rC_Bios__Seasonal_Start_Month__c, ' +
'rC_Bios__Seasonal_End_Month__c, ' +
'rC_Bios__Seasonal_Start_Day__c, ' +
'rC_Bios__Seasonal_End_Day__c, ' +
'rC_Bios__Start_Date__c, ' +
'rC_Bios__End_Date__c, ' +
'rC_Bios__Do_Not_Mail__c, ' +
'rC_Bios__Original_Street_Line_1__c, ' +
'rC_Bios__Original_City__c, ' +
'rC_Bios__Original_State__c, ' +
'rC_Bios__Original_Country__c, ' +
'rC_Bios__Original_Postal_Code__c, ' +
'rC_Bios__Original_Street_Line_2__c, ' +
'rC_Bios__Address__c, ' +
'rC_Bios__Address__r.rC_Bios__City__c, ' + 
'rC_Bios__Address__r.rC_Bios__Street_Line_1__c, ' +
'rC_Bios__Address__r.rC_Bios__Street_Line_2__c, ' +
'rC_Bios__Address__r.rC_Bios__State__c, ' +
'rC_Bios__Address__r.rC_Bios__Country__c, ' +
'rC_Bios__Address__r.rC_Bios__ZIP__c,OrgName__c, ' +
'kwrc__USPS_Verified__c, ' +
'OrgName2__c, ';
sQuery += PrimaryPreferredField + ',' + SecondaryPreferredField;

sQuery += ' FROM ' +  sObjectName + ' WHERE ' + ParentFieldName + ' = :SourceId';
system.debug(sQuery);
    for(sObject rcAdd : database.query(sQuery)) {
                lstAddress.add(new AddressWrapper(rcAdd));
                mapAddresses.put(rcAdd.Id, fetchAddress(rcAdd));
                                                                        
    }
}

private sObject removeZDMData(sObject soaddress) {
    Schema.SObjectType addressType = Schema.getGlobalDescribe().get(sObjectName);
    sObject addressToClean = addressType.newSObject();
    if (soaddress.get('kwrc__ZTDM_Expiry_Date__c') != NULL) {
        addressToClean.put('kwrc__ZTDM_Expiry_Date__c', soaddress.get('kwrc__ZTDM_Expiry_Date__c'));    
    } 
    kwzd.KWD_Process_JSON_Response.updateTargetfromSourceObject(addressToClean, 'kwrc__', soaddress, 'kwrc__');
return soaddress;
}

}