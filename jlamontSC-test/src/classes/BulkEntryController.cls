public without sharing class BulkEntryController implements CampaignSetter {
	public List<EntryRow> rowList;
	public List<EntryRow> rowsMatched = new List<EntryRow>();
	public List<EntryRow> rowsNotMatched = new List<EntryRow>();
	public List<EntryRow> rowsRemoved {get; set;}
	public Integer rowsToAdd = 10;
	public String entryMode = 'None';
	public Blob fileBody;
	public String fileBodyString {get; set;}
	public String csvLines;
	public String selectedTag;
	public Campaign selectedEvent {get; set;}
	public Interest__c selectedInterest {get; set;}
	public rC_Bios__Preference__c selectedPreference {get; set;}
	public String selectedEventRegistrationStatus {get; set;}
	public Campaign selectedCampaign {get; set;}
	public Campaign selectedActionCampaign {get; set;}
    public Campaign selectedListCampaign {get; set;}
	public kweos__EOCS_Data__c selectedAction {get; set;}
		
	private EventTagController evTagController;
	public EventTagController getEventTagController() {
		return evTagController;
	}
	public void setEvTagController(EventTagController controller) {
		evTagController = controller;
	}

	private ActionTagController acTagController;
	public ActionTagController getActionTagController() {
		return acTagController;
	}
	public void setAcTagController(ActionTagController controller) {
		acTagController = controller;
	}
    
	private ListTagController liTagController;			
	public ListTagController getListTagController() {			
    	return liTagController;
    }			
	public void setLiTagController(ListTagController controller) {			
		liTagController = controller;			
	}    

	public BulkEntryController getThis() {
		return this;
	}

	public class EntryRow {
		public Integer rowNumber {get; set;}
		public String id {get; set;}
    	public String firstName {get; set;}
    	public String lastName {get; set;}
    	public String street {get; set;}
    	public String city {get; set;}
    	public String state {get; set;}
    	public String postalCode {get; set;}
    	public String email {get; set;}
    	public String phone {get; set;}
    	public Boolean emailError {get; set;}
    	public Contact matchedContact {get; set;}
    	public Boolean updateAddress {get; set;}
    	public Boolean updateEmail {get; set;}
    	public Boolean updatePhone {get; set;}
    	public Boolean wrongMatch {get; set;}
    	public Boolean remove {get; set;}
    	public Boolean hasData() {
    		if(
    			String.isEmpty(id) &&
    			String.isEmpty(firstName) &&
    			String.isEmpty(lastName) &&
    			String.isEmpty(street) &&
    			String.isEmpty(city) &&
    			String.isEmpty(state) &&
    			String.isEmpty(postalCode) &&
    			String.isEmpty(email) &&
    			String.isEmpty(phone) 
    		) {
    			return false;
    		}
    		return true;
    	}
    	public Boolean hasAddress() {
    		if( String.isEmpty(street) || String.isEmpty(city) || String.isEmpty(state) || String.isEmpty(postalCode) ) {
    			return false;
    		}
    		return true;
    	}
	}
	public List<EntryRow> getRowList() {
		if(rowList == null) {
			rowList = new List<EntryRow>();
			for(Integer i=0; i < rowsToAdd; i++) {
				EntryRow row = new EntryRow();
				row.rowNumber = i+1;
				rowList.add(row);
			}
		}
		return rowList;
	}
	public void addRows() {
		Integer startRow = getRowList().size();
		Integer endRow = startRow + rowsToAdd; 
		for(Integer i = startRow; i < endRow; i++) {
			EntryRow row = new EntryRow();
			row.rowNumber = i + 1;
			rowList.add(row);
		}
	}
	public void setNumRowsToAdd(String inputRows) {
		rowsToAdd = Integer.valueOf(inputRows);
	}
	public String getNumRowsToAdd() {
		return String.valueOf(rowsToAdd);
	}
	public void setEntryMode(String mode) {
		entryMode = mode;
	}
	public String getEntryMode() {
		return entryMode;
	}
	public void processFileContents() {
		if(fileBody == null) {
			addError('Please choose a file first');
			return;
		}
		String[] csvLines = fileBody.toString().split('\n');
		rowList = new List<EntryRow>();
		Integer lineNo = 0;
		for(String line : csvLines) {
			if(lineNo > 0) {
				String[] recordData = line.split(',');
				EntryRow row = new EntryRow();
				row.rowNumber = lineNo;
				for(Integer i=0; i < recordData.size(); i++) {
					if(i == 0) {
						row.id = recordData[i];
					}
					else if(i == 1) {
						row.firstName = recordData[i];
					}
					else if(i == 2) {
						row.lastName = recordData[i];
					}
					else if(i == 3) {
						row.street = recordData[i];
					}
					else if(i == 4) {
						row.city = recordData[i];
					}
					else if(i == 5) {
						row.state = recordData[i];
					}
					else if(i == 6) {
						row.postalCode = recordData[i];
					}
					else if(i == 7) {
						row.email = recordData[i];
					}
					else if(i == 8) {
						row.phone = recordData[i];
					}
				}
				if( ! String.isEmpty(row.phone)) {
					if(row.phone.endsWith('\r')) {
						row.phone = row.phone.substring(0,row.phone.length()-1);
					}
				}
				rowList.add(row);
			}
			lineNo ++;
		}
		entryMode = 'manual';
	}
	public void setFileBody(Blob body) {
		fileBody = body;
	}
	public Blob getFileBody() {
		return fileBody;
	}
	public Boolean getHasFileBody() {
		if(fileBody != null) {
			if(fileBody.size() > 0) {
				return true;
			}
		}
		return false;
	}
	public PageReference processInputData() {
		boolean hasErrors = false;
		Set<String> idSet = new Set<String>();
		for(EntryRow row : rowList) {
			if(row.hasData()) {
				if(String.isEmpty(row.firstName) || String.isEmpty(row.lastName)) {
					addError('Row ' + row.rowNumber + ': First and Last Names are Required');
					hasErrors = true;
				}
				if( ! String.isEmpty(row.email)) {
					if( ! isValidEmail(row.email)) {
						addError('Row ' + row.rowNumber + ': Invalid Email - ' + row.email);
						hasErrors = true;
					}
				}
				if( ! String.isEmpty(row.phone)) {
					row.phone = row.phone.trim();
					if( ! isValidPhone(row.phone)) {
						addError('Row ' + row.rowNumber + ': Invalid Phone - ' + row.phone);
						hasErrors = true;
					}
					else {
						if(row.phone.isNumeric() && row.phone.length() == 10) {
							row.phone = '(' + row.phone.substring(0,3) + ')' + row.phone.substring(3,6) + '-' + row.phone.substring(6,10);
						}
					}
				}
				if(row.state.length() > 2) {
                    addError('Row ' + row.rowNumber + ': Invalid State');
                    hasErrors = true;					
				}  
				if(row.postalCode.length() > 10) {
                    addError('Row ' + row.rowNumber + ': Invalid Zip');
                    hasErrors = true;					
				} 
                if (!String.isEmpty(row.street) && (String.isEmpty(row.city) || String.isEmpty(row.state) || String.isEmpty(row.postalCode))) {
                    addError('Row ' + row.rowNumber + ': City, State, and Zip Required if entering an address');
                    hasErrors = true;                    
                }
				if(String.isEmpty(row.email) && String.isEmpty(row.phone)) {
					if( ! row.hasAddress()) {
						addError('Row ' + row.rowNumber + ': Insufficient Contact Information');
						hasErrors = true;
					}
				}
				if(! String.isEmpty(row.Id)) {
					idSet.add(row.Id);
				}
			}
		}
		if(hasErrors) {
			return null;
		}
		Map<String, Contact> idToContact = new Map<String, Contact>([
			select
				Id,
				External_ID__c,
				FirstName,
				LastName,
				MailingStreet,
				MailingCity,
				MailingState,
				MailingPostalCode,
				Email,
				Phone,
				AccountId
			from Contact
			where Id in :idSet
		]);
		for(EntryRow row : rowList) {
			if(row.hasData()) {
				row.emailError = false;
				row.updateAddress = false;
				row.updateEmail = false;
				row.updatePhone = false;
				row.wrongMatch = false;
				row.remove = false;
				Contact ctct = null;
				if( ! String.isEmpty(row.Id)) {
					ctct = idToContact.get(row.Id);
				}
				if(ctct == null) {
					rowsNotMatched.add(row);
				}
				else {
					row.matchedContact = ctct;
					rowsMatched.add(row);
				}
			} 
		}
		if(rowsMatched.size() + rowsNotMatched.size() == 0) {
			addError('No rows to process');
			return null;
		}
		return Page.BulkEntryProcessing;
	}
	public Integer getNumRowsMatched() {
		return rowsMatched.size();
	}
	public Integer getNumRowsNotMatched() {
		return rowsNotMatched.size();
	}
	public PageReference finalProcessing() {
		if(
			selectedInterest == null &&
			selectedAction == null &&
			selectedEvent == null &&
			selectedPreference == null &&
			selectedCampaign == null &&	
			selectedListCampaign == null
		) {
			addError('At least one tag must be added');
			return null;			
		}

		BulkEntryProcessor processor = new BulkEntryProcessor(this);
		processor.processRows();
		rowsRemoved = new List<BulkEntryController.EntryRow>();
		for(BulkEntryController.EntryRow row : rowsMatched) {
			if(row.remove) {
				rowsRemoved.add(row);
			}
		}
		for(BulkEntryController.EntryRow row : rowsNotMatched) {
			if(row.remove) {
				rowsRemoved.add(row);
			}
		}
		return Page.BulkEntryRemoved;
	}
	public String getSelectedTag() {
		if(String.isEmpty(selectedTag)) {
			selectedTag = 'Event';
		}
		return selectedTag;
	}
	public void setSelectedTag(String tag) {
		selectedTag = tag;
	}
	public PageReference startNewBatch() {
		PageReference pageRef = new PageReference('/apex/BulkEntry');
		pageRef.setRedirect(true);
		return pageRef;
	}
	public List<EntryRow> getRowsMatched() {
		return rowsMatched;
	}
	public List<EntryRow> getRowsNotMatched() {
		return rowsNotMatched;
	}
    private static Boolean isValidEmail(String email) {
		String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
		Pattern MyPattern = Pattern.compile(emailRegex);
		Matcher MyMatcher = MyPattern.matcher(email);
		return MyMatcher.matches();
	}
	private static Boolean isValidPhone(String phone) {
		Boolean res = true;
		String phoneRegex = '\\D*?(\\d\\D*?){10}';
		Pattern MyPattern = Pattern.compile(phoneRegex);
		Matcher MyMatcher = MyPattern.matcher(phone);
		return MyMatcher.matches();
	}
	private static void addError(String message) {
        ApexPages.addmessage(
        	new ApexPages.message(
        		ApexPages.severity.ERROR, message)
        	);
	}
	private CampaignSearchController campSearchController;
	public CampaignSearchController getCampSearchController() {
		return campSearchController;
	}
	public void setCampSearchController(CampaignSearchController controller) {
		campSearchController = controller;
	}
	public void setSelectedCampaign(Campaign camp) {
		selectedCampaign = camp;
	}
	public void cancelActionTag() {
		acTagController.campList = null;
		acTagController.selectedCampaign = null;
	}
	public void deleteEventTag() {
    	selectedEvent = null;
    	selectedEventRegistrationStatus = null;
	}
	public void deleteInterestTag() {
		selectedInterest = null;
	}
	public void deletePreferenceTag() {
		selectedPreference = null;
	}
	public void deleteCampaignTag() {
		selectedCampaign = null;
	}
	public void deleteActionTag() {
		selectedAction = null;
    }
	public void deleteListTag() {			
		selectedListCampaign = null;
	}
	public void setEventTag() {
		selectedTag = 'Event';
	}
	public void setInterestTag() {
		selectedTag = 'Interest';
	}
	public void setPreferenceTag() {
		selectedTag = 'Preference';
	}
	public void setActionTag() {
		selectedTag = 'Action';
	}
	public void setCampaignTag() {
		selectedTag = 'OriginalCampaign';
	}
	public void setListTag() {	
		selectedTag = 'ListCampaign';			
	}     
}