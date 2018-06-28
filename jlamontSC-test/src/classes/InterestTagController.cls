public with sharing class InterestTagController {
	public BulkEntryController pageController { get;
		set {
			if(value != null) {
				pageController = value;
			}
		}
	}
	public Interest__c interest {get; set;} {interest = new Interest__c();}
   	public Boolean hasErrors {get; set;} {hasErrors = false;}
	
    public void saveTag() {
    	hasErrors = false;
    	if(String.isEmpty(interest.Interest_Type__c)) {
    		addError('Interest Type is Required');
    		hasErrors = true;
    	}
    	if(String.isEmpty(interest.Interest_Description__c)) {
    		addError('Interest Description is Required');
    		hasErrors = true;
    	}
    	if(! hasErrors) {
    		pageController.selectedInterest = interest;
    		interest = pageController.selectedInterest.clone();
    	}
    }
    public void cancelTag() {
    	if(pageController.selectedInterest != null) {
    		interest = pageController.selectedInterest.clone();
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