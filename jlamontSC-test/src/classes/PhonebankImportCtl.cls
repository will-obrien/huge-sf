public with sharing class PhonebankImportCtl {
	public List<EntryRow> rowList;
 	public Blob fileBody;
	public String fileBodyString {get; set;}
	public Campaign camp;
	public Integer rowsProcessed {get; set;}
	private Integer errorCount=0;
	private static final String invalidBooleanMsg = ' value not affirmative (Yes, Y, True, T, X) or negative (No, N, False, F, "blank")';
	private static final Set<String> trueValues = new Set<String>{'yes','y','true','t','x'}; 
	private static final Set<String> falseValues = new Set<String>{'no','n','false','f',''}; 
   
	public class EntryRow {
		public Integer rowNumber {get; set;}
		public String id {get; set;}
    	public String firstName {get; set;}
    	public String lastName {get; set;}
    	public String phone {get; set;}
    	public String eventRSVP {get; set;}
    	public String question1 {get; set;}
    	public String question2 {get; set;}
    	public String question3 {get; set;}
    	public String question4 {get; set;}
    	public String question5 {get; set;}
    	public String noAnswer {get; set;}
    	public String leftMessage {get; set;}
    	public String badPhone {get; set;}
    	public String updatePhone {get; set;}
    	public String noPhone {get; set;}
    	public String nonEnglish {get; set;}
    	public String contactAttempts {get; set;}
    	public String interest1 {get; set;}
    	public String interest2 {get; set;}
    	public String interest3 {get; set;}

	}
	public PageReference processFileContents() {
		rowsProcessed = null;
		if(fileBody == null) {
			addError('Please choose a file first');
			return null;
		}
		String[] csvLines = fileBody.toString().split('\n');
		rowList = new List<EntryRow>();
		Integer lineNo = 0;
		Set<Id> idSet = new Set<Id>();
		for(String line : csvLines) {
			if(lineNo > 0) {
				String[] recordData = line.split(',', -1);
				EntryRow row = new EntryRow();
				row.rowNumber = lineNo;
				for(Integer i=0; i < recordData.size(); i++) {
					if(i == 0) {
						row.id = recordData[i];
						if( ! String.isEmpty(row.Id)) {
							try {
								idSet.add(row.id);
							}
							catch(Exception e){
								row.id = 'BAD';
							}
						}
					}
					else if(i == 1) {
						row.firstName = recordData[i];
					}
					else if(i == 2) {
						row.lastName = recordData[i];
					}
					else if(i == 3) {
						row.phone = recordData[i];
					}
					else if(i == 4) {
						row.eventRSVP = recordData[i];
					}
					else if(i == 5) {
						row.question1 = recordData[i];
					}
					else if(i == 6) {
						row.question2 = recordData[i];
					}
					else if(i == 7) {
						row.question3 = recordData[i];
					}
					else if(i == 8) {
						row.question4 = recordData[i];
					}
					else if(i == 9) {
						row.question5 = recordData[i];
					}
					else if(i == 10) {
						row.noAnswer = recordData[i];
					}
					else if(i == 11) {
						row.leftMessage = recordData[i];
					}
					else if(i == 12) {
						row.badPhone = recordData[i];
					}
					else if(i == 13) {
						row.updatePhone = recordData[i];
					}
					else if(i == 14) {
						row.noPhone = recordData[i];
					}
					else if(i == 15) {
						row.nonEnglish = recordData[i];
					}
					else if(i == 16) {
						row.contactAttempts = recordData[i];
						if(String.isEmpty(row.contactAttempts)) {
							row.contactAttempts = '0';
						}
					}
					else if(i == 17) {
						row.interest1 = recordData[i];
					}
					else if(i == 18) {
						row.interest2 = recordData[i];
					}
					else if(i == 19) {
						row.interest3 = recordData[i];
					}
				}
				if( ! String.isEmpty(row.interest3)) {
					if(row.interest3.endsWith('\r')) {
						row.interest3 = row.interest3.substring(0,row.interest3.length()-1);
					}
				}
				rowList.add(row);
			}
			lineNo ++;
		}

		List<CampaignMember> mbrList = [
			select Id from CampaignMember where Id in :idSet
		];
		Set<Id> campMbrSet = new Set<Id>();
		for(CampaignMember mbr : mbrList) {
			campMbrSet.add(mbr.Id);
		}
		
		errorCount = 0;
		for(EntryRow row : rowList) {
			if(String.isEmpty(row.Id)) {
				addError('Row ' + (row.rowNumber+1) + ': CORE Campaign Member ID not present');
			}
			else if(row.Id == 'BAD') {
				addError('Row ' + (row.rowNumber+1) + ': Invalid CORE Campaign Member ID');
			}
			else if( ! campMbrSet.contains(row.Id)) {
				addError('Row ' + (row.rowNumber+1) + ': Invalid CORE Campaign Member ID');
			}
			if(String.isEmpty(row.firstName)) {
				addError('Row ' + (row.rowNumber+1) + ': First Name not present');
			}
			if(String.isEmpty(row.lastName)) {
				addError('Row ' + (row.rowNumber+1) + ': Last Name not present');
			}
			if(String.isEmpty(row.phone)) {
				addError('Row ' + (row.rowNumber+1) + ': Phone Number not present');
			}
			else if( ! isValidPhone(row.phone) ) {
				addError('Row ' + (row.rowNumber+1) + ': Improper Phone Number format');
			}
			if( ! isValidYesNoResponse(row.badPhone)) {
				addError('Row ' + (row.rowNumber+1) + ': Bad Phone' + invalidBooleanMsg);
			}
			if( ! isValidYesNoResponse(row.leftMessage)) {
				addError('Row ' + (row.rowNumber+1) + ': Bad Phone' + invalidBooleanMsg);
			}
			if( ! isValidYesNoResponse(row.nonEnglish)) {
				addError('Row ' + (row.rowNumber+1) + ': Bad Phone' + invalidBooleanMsg);
			}
			if( ! isValidYesNoResponse(row.updatePhone)) {
				addError('Row ' + (row.rowNumber+1) + ': Update Phone' + invalidBooleanMsg);
			}
			if( ! isValidYesNoResponse(row.noAnswer)) {
				addError('Row ' + (row.rowNumber+1) + ': No Answer' + invalidBooleanMsg);
			}
			if( ! isValidYesNoResponse(row.noPhone)) {
				addError('Row ' + (row.rowNumber+1) + ': No Fundraising Calls Wanted' +  + invalidBooleanMsg);
			}
			if( ! isValidYesNoResponse(row.interest1)) {
				addError('Row ' + (row.rowNumber+1) + ': ' + getInterest1() + invalidBooleanMsg);
			}
			if( ! isValidYesNoResponse(row.interest2)) {
				addError('Row ' + (row.rowNumber+1) + ': ' + getInterest2() + invalidBooleanMsg);
			}
			if( ! isValidYesNoResponse(row.interest3)) {
				addError('Row ' + (row.rowNumber+1) + ': ' + getInterest3()  + invalidBooleanMsg);
			}
			try {
				Integer x = Integer.valueOf(row.contactAttempts);
				if(x > 99) {
					addError('Row ' + (row.rowNumber+1) + ': Number of Call Attempts Made is not a one or two digit number');
				}
			}
			catch(Exception e) {
				addError('Row ' + (row.rowNumber+1) + ': Number of Call Attempts Made is not a one or two digit number');
			}
			if( (! String.isEmpty(row.question1)) && row.question1.length() > 255) {
				addError('Row ' + (row.rowNumber+1) + ': ' + getCustomField1() + ' has more than 255 characters');
			}
			if( (! String.isEmpty(row.question2)) && row.question2.length() > 255) {
				addError('Row ' + (row.rowNumber+1) + ': ' + getCustomField2() + ' has more than 255 characters');
			}
			if( (! String.isEmpty(row.question3)) && row.question3.length() > 255) {
				addError('Row ' + (row.rowNumber+1) + ': ' + getCustomField3() + ' has more than 255 characters');
			}
			if( (! String.isEmpty(row.question4)) && row.question4.length() > 255) {
				addError('Row ' + (row.rowNumber+1) + ': ' + getCustomField4() + ' has more than 255 characters');
			}
			if( (! String.isEmpty(row.question5)) && row.question5.length() > 255) {
				addError('Row ' + (row.rowNumber+1) + ': ' + getCustomField5() + ' has more than 255 characters');
			}
		}
		
		if(errorCount > 0) {
			return null;
		}
		updateCampaignMembers();
		rowsProcessed = rowList.size();
		return null;
	}
	private void updateCampaignMembers() {
		List<CampaignMember> mbrList = new List<CampaignMember>();
		for(EntryRow row : rowList) {
			CampaignMember mbr = new CampaignMember(
				Id = row.Id,
				rC_Event__Phone__c = row.phone,
				Bad_Phone__c = yesNo(row.badPhone),
				Update_Phone__c = yesNo(row.updatePhone),
				Contact_Attempts_Made__c = Integer.valueOf(row.contactAttempts),
				Custom_Field_1_Response__c = row.question1,
				Custom_Field_2_Response__c = row.question2,
				Custom_Field_3_Response__c = row.question3,
				Custom_Field_4_Response__c = row.question4,
				Custom_Field_5_Response__c = row.question5
			);
			if(		
				yesNo(row.interest1) ||
				yesNo(row.interest2) ||
				yesNo(row.interest3) ||
				row.question1.length() > 0 ||
				row.question2.length() > 0 ||
				row.question3.length() > 0 ||
				row.question4.length() > 0 ||
				row.question5.length() > 0 ||
				yesNo(row.updatePhone)
			) {
				mbr.Status = 'Contacted';					
			}
			else if(yesNo(row.badPhone)) {
				mbr.Status = 'Wrong Number/Disconnected';
			}
			else if(yesNo(row.leftMessage)) {
				mbr.Status = 'Left Message';
			}
			else if(yesNo(row.noAnswer)) {
				mbr.Status = 'No Answer';
			}
			else if(yesNo(row.nonEnglish)) {
				mbr.Status = 'Non-English Speaker';
			}
			else {
				mbr.Status = 'To Contact';   //Should there be a default?
			}
			if(yesNo(row.noPhone)) {
				mbr.No_Phone__c = true;
			}
			if(yesNo(row.eventRSVP)) {
				mbr.Event_RSVP__c = 'Yes';
			}
			if(yesNo(row.interest1)) {
				mbr.Interest_One__c = true;
			}
			if(yesNo(row.interest2)) {
				mbr.Interest_Two__c = true;
			}
			if(yesNo(row.interest3)) {
				mbr.Interest_Three__c = true;
			}
			mbrList.add(mbr);
		}
		update mbrList;		
	}
	public Campaign getCamp() {
		if(camp == null) {
			Id id = ApexPages.currentPage().getParameters().get('id');
			if(id != null) {
				List<Campaign> campList = [
					select
						Id,
						Event_Form__r.Event_Name__c,
						Interest_One__c,
						Interest_Two__c,
						Interest_Three__c,
						Custom_Field_1_Label__c,
						Custom_Field_2_Label__c,
						Custom_Field_3_Label__c,
						Custom_Field_4_Label__c,
						Custom_Field_5_Label__c
					from Campaign
					where Id = :id
				];
				if( ! campList.isEmpty() ) {
					camp = campList.get(0);
				}
			}
		}
		return camp;
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
	private String getHeader(String filledValue, String defaultValue) {
		if(String.isEmpty(filledValue)) {
			return defaultValue;
		}
		return filledValue;
	}
	private void addError(String message) {
        ApexPages.addmessage(
        	new ApexPages.message(
        		ApexPages.severity.ERROR, message)
        	);
        errorCount++;
	}
	private static Boolean isValidPhone(String phone) {
		Boolean res = true;
		String phoneRegex = '\\D*?(\\d\\D*?){10}';
		Pattern MyPattern = Pattern.compile(phoneRegex);
		Matcher MyMatcher = MyPattern.matcher(phone);
		return MyMatcher.matches();
	}
	private static Boolean isValidYesNoResponse(String input) {
		return yesNo(input) != null;
	}
	private static Boolean yesNo(String input) {
		if(! String.isEmpty(input)) {
			input = input.toLowerCase();
		}
		if(trueValues.contains(input)) {
			return true;
		}	
		else if(falseValues.contains(input)) {
			return false;
		}
		return null;
	}
	public String getEventName() {
		return getHeader(getCamp().Event_Form__r.Event_Name__c, 'Event: N/A');
	}
	public String getInterest1() {
		return getHeader(getCamp().Interest_One__c, 'Interest: N/A');
	}
	public String getInterest2() {
		return getHeader(getCamp().Interest_Two__c, 'Interest: N/A');
	}
	public String getInterest3() {
		return getHeader(getCamp().Interest_Three__c, 'Interest: N/A');
	}
	public String getCustomField1() {
		return getHeader(getCamp().Custom_Field_1_Label__c , 'Custom Question One');
	}
	public String getCustomField2() {
		return getHeader(getCamp().Custom_Field_2_Label__c , 'Custom Question Two');
	}
	public String getCustomField3() {
		return getHeader(getCamp().Custom_Field_3_Label__c , 'Custom Question Three');
	}
	public String getCustomField4() {
		return getHeader(getCamp().Custom_Field_4_Label__c , 'Custom Question Four');
	}
	public String getCustomField5() {
		return getHeader(getCamp().Custom_Field_5_Label__c , 'Custom Question Five');
	}
}