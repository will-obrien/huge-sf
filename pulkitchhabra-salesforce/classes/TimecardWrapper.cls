public class TimecardWrapper {
    public List<cTimecard> timecardList {get; set;}
	 public List<cTimecard> getTimecard() {
	       if(timecardList == null) {
	            timecardList = new List<cTimecard>();
	            for(Timecard__c tc: [Select Id, Name, Timecard_Status__c, Hours_Logged__c, Entered_By__c from Timecard__c]) {
	                // As each tc is processed we create a new cTimecard object and add it to the contactList
	                timecardList.add(new cTimecard(tc));
	            }
	        }
	        return timecardList;
	    }
		public PageReference approve() {
	        //We create a new list of Contacts that we be populated only with Contacts if they are selected
	        List<Timecard__c> selectedTymcrd = new List<Timecard__c>();
	        //We will cycle through our list of cContacts and will check to see if the selected property is set to true, if it is we add the Contact to the selectedContacts list
	        for(cTimecard cTymcrd: getTimecard()) {
	            if(cTymcrd.selected == true) {
	                selectedTymcrd.add(cTymcrd.tymcrd);
	            }
	        }
	        // Now we have our list of selected contacts and can perform any type of logic we want, sending emails, updating a field on the Contact, etc
	        List<Timecard__c> upTymcrd = new List<Timecard__c>();
            for(Timecard__c t: selectedTymcrd) {
	            if(t.Timecard_Status__c == 'Submitted'){
					t.Timecard_Status__c = 'Approved';
                    upTymcrd.add(t);
				}
	        }
            System.debug(upTymcrd+'List');
            update upTymcrd;
	        timecardList=null; // we need this line if we performed a write operation  because getContacts gets a fresh list now
	        return null;
	    }
        public PageReference reject() {
            //We create a new list of Contacts that we be populated only with Contacts if they are selected
            List<Timecard__c> selectedTymcrd = new List<Timecard__c>();
            //We will cycle through our list of cContacts and will check to see if the selected property is set to true, if it is we add the Contact to the selectedContacts list
            for(cTimecard cTymcrd: getTimecard()) {
                if(cTymcrd.selected == true) {
                    selectedTymcrd.add(cTymcrd.tymcrd);
                }
            }
            // Now we have our list of selected contacts and can perform any type of logic we want, sending emails, updating a field on the Contact, etc
            List<Timecard__c> upTymcrd = new List<Timecard__c>();
            for(Timecard__c t: selectedTymcrd) {
                if(t.Timecard_Status__c == 'Submitted'){
                    t.Timecard_Status__c = 'Rejected';
                    upTymcrd.add(t);
                }
            }
            System.debug(upTymcrd+'List');
            update upTymcrd;
            timecardList=null; // we need this line if we performed a write operation  because getContacts gets a fresh list now
            return null;
        }
		    // This is our wrapper/container class. A container class is a class, a data structure, or an abstract data type whose instances are collections of other objects. In this example a wrapper class contains both the standard salesforce object Contact and a Boolean value
	public class cTimecard {
		public Timecard__c tymcrd {get; set;}
		public Boolean selected {get; set;}
		//This is the contructor method. When we create a new cContact object we pass a Contact that is set to the con property. We also set the selected value to false
		public cTimecard(Timecard__c tc) {
			tymcrd = tc;
			selected = false;
		}
	}
}