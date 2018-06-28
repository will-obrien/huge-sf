public with sharing class PreferenceTagController {
	public BulkEntryController pageController { get;
		set {
			if(value != null) {
				pageController = value;
			}
		}
	}
	public rC_Bios__Preference__c preference {get; set;} {preference = new rC_Bios__Preference__c();}
   	public Boolean hasErrors {get; set;} {hasErrors = false;}

    public void saveTag() {
    	hasErrors = false;
    	if(String.isEmpty(preference.rC_Bios__Category__c)) {
    		addError('Category is Required');
    		hasErrors = true;
    	}
    	if(String.isEmpty(preference.rC_Bios__Subcategory__c)) {
    		addError('Subcategory is Required');
    		hasErrors = true;
    	}
    	if(! hasErrors) {
	    	pageController.selectedPreference = preference;
    		preference = pageController.selectedPreference.clone();
    	}
    }
    public void cancelTag() {
    	if(pageController.selectedPreference != null) {
    		preference = pageController.selectedPreference.clone();
    	}
    }
    public String getCloseAction() {
    	if( ! hasErrors) {
    		return 'closeTagModal()'; 
    	}
    	return '';
    }
	private static void addError(String message) {
        ApexPages.addmessage(
        	new ApexPages.message(
        		ApexPages.severity.ERROR, message)
        	);
	}
}