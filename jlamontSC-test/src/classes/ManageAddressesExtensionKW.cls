public with sharing class ManageAddressesExtensionKW {
    
  public Account account {get;set;}
  public ManageAddressService maservice {get;set;}
  
  //MM Begin
  private static Id householdRTId;
  private String defaultAddressType;
  //MM End
  
  //============================================//
  //Constructor
  //============================================//
  public ManageAddressesExtensionKW(ApexPages.StandardController stdController) {
    account = (Account)stdController.getRecord();
    //queryAccount();
    maservice = new ManageAddressService();
    maservice.sObjectName = 'rC_Bios__Account_Address__c';
    maservice.ParentFieldName = 'rC_Bios__Account__c';
    maservice.SourceId = account.Id;
    maservice.PrimaryPreferredField = 'rC_Bios__Preferred_Billing__c';
    maservice.SecondaryPreferredField  = 'rC_Bios__Preferred_Shipping__c';

    maservice.queryAddress();
    maservice.addressToInsert = new rC_Bios__Account_Address__c();
    householdRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
    
    
    if(account.RecordTypeId == householdRTId) {
        maservice.defaultAddressType = 'Home';
    }
      
    maservice.addressToInsert.put('rC_Bios__Type__c', defaultAddressType);
    
  } 
    
	public List<SelectOption> getItems() {
    	List<SelectOption> options = new List<SelectOption>();
        	options.add(new SelectOption('','--None--'));
        	options.add(new SelectOption('AL','AL (Alabama)'));
			options.add(new SelectOption('AK','AK (Alaska)'));
			options.add(new SelectOption('AZ','AZ (Arizona)'));
			options.add(new SelectOption('AR','AR (Arkansas)'));
			options.add(new SelectOption('CA','CA (California)'));
			options.add(new SelectOption('CO','CO (Colorado)'));
			options.add(new SelectOption('CT','CT (Connecticut)'));
			options.add(new SelectOption('DE','DE (Delaware)'));
			options.add(new SelectOption('DC','DC (District of Columbia)'));
			options.add(new SelectOption('FL','FL (Florida)'));
			options.add(new SelectOption('GA','GA (Georgia)'));
			options.add(new SelectOption('HI','HI (Hawaii)'));
			options.add(new SelectOption('ID','ID (Idaho)'));
			options.add(new SelectOption('IL','IL (Illinois)'));
			options.add(new SelectOption('IN','IN (Indiana)'));
			options.add(new SelectOption('IA','IA (Iowa)'));
			options.add(new SelectOption('KS','KS (Kansas)'));
			options.add(new SelectOption('KY','KY (Kentucky)'));
			options.add(new SelectOption('LA','LA (Louisiana)'));
			options.add(new SelectOption('ME','ME (Maine)'));
			options.add(new SelectOption('MD','MD (Maryland)'));
			options.add(new SelectOption('MA','MA (Massachusetts)'));
			options.add(new SelectOption('MI','MI (Michigan)'));
			options.add(new SelectOption('MN','MN (Minnesota)'));
			options.add(new SelectOption('MS','MS (Mississippi)'));
			options.add(new SelectOption('MO','MO (Missouri)'));
			options.add(new SelectOption('MT','MT (Montana)'));
			options.add(new SelectOption('NE','NE (Nebraska)'));
			options.add(new SelectOption('NV','NV (Nevada)'));
			options.add(new SelectOption('NH','NH (New Hampshire)'));
			options.add(new SelectOption('NJ','NJ (New Jersey)'));
			options.add(new SelectOption('NM','NM (New Mexico)'));
			options.add(new SelectOption('NY','NY (New York)'));
			options.add(new SelectOption('NC','NC (North Carolina)'));
			options.add(new SelectOption('ND','ND (North Dakota)'));
			options.add(new SelectOption('OH','OH (Ohio)'));
			options.add(new SelectOption('OK','OK (Oklahoma)'));
			options.add(new SelectOption('OR','OR (Oregon)'));
			options.add(new SelectOption('PA','PA (Pennsylvania)'));
			options.add(new SelectOption('RI','RI (Rhode Island)'));
			options.add(new SelectOption('SC','SC (South Carolina)'));
			options.add(new SelectOption('SD','SD (South Dakota)'));
			options.add(new SelectOption('TN','TN (Tennessee)'));
			options.add(new SelectOption('TX','TX (Texas)'));
			options.add(new SelectOption('UT','UT (Utah)'));
			options.add(new SelectOption('VT','VT (Vermont)'));
			options.add(new SelectOption('VA','VA (Virginia)'));
			options.add(new SelectOption('WA','WA (Washington)'));
			options.add(new SelectOption('WV','WV (West Virginia)'));
			options.add(new SelectOption('WI','WI (Wisconsin)'));
			options.add(new SelectOption('WY','WY (Wyoming)'));
        	options.add(new SelectOption('AA','AA (Armed Forces-Americas)'));
        	options.add(new SelectOption('AE','AE (Armed Forces-Europe)'));
        	options.add(new SelectOption('AP','AP (Armed Forces-Pacific)'));
        	options.add(new SelectOption('AS','AS (American Samoa)'));
        	options.add(new SelectOption('GU','GU (Guam)'));
        	options.add(new SelectOption('MP','MP (N. Mariana Islands)'));
			options.add(new SelectOption('PR','PR (Puerto Rico)'));
			options.add(new SelectOption('VI','VI (Virgin Islands)'));        
			options.add(new SelectOption('AB','AB (Alberta)'));
			options.add(new SelectOption('BC','BC (British Columbia)'));
			options.add(new SelectOption('MB','MB (Manitoba)'));
			options.add(new SelectOption('NB','NB (New Brunswick)'));
			options.add(new SelectOption('NL','NL (Newfoundland/Labrador)'));
			options.add(new SelectOption('NS','NS (Nova Scotia)'));
        	options.add(new SelectOption('NT','NT (Northwest Territories)'));
        	options.add(new SelectOption('NU','NU (Nunavut)'));
			options.add(new SelectOption('ON','ON (Ontario)'));
			options.add(new SelectOption('PE','PE (Prince Edward Island)'));
			options.add(new SelectOption('QC','QC (Quebec)'));
			options.add(new SelectOption('SK','SK (Saskatchewan)'));
        	options.add(new SelectOption('YT','YT (Yukon)'));
        	
            return options;
        }
    
public PageReference upsertAccountAddressList() {
  maservice.rcAddressList = new List<rC_Bios__Account_Address__c>();
return maservice.upsertAccountAddressList();
}

public PageReference upsertAccountAddressListAndReturn() {
  maservice.rcAddressList = new List<rC_Bios__Account_Address__c>();
return maservice.upsertAccountAddressListAndReturn();
}
 

}