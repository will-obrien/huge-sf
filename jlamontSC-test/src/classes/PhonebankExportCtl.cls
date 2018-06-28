/*********************************************************************************************************
Name              : PhonebankImportCtl
Created By        : Mark Maslow & Justin LaMont
Created Date      : April 2017
Description       : Controller for Phonebank Export
Last Updated      : 
*********************************************************************************************************/

public with sharing class PhonebankExportCtl {
    private static final Id eventsId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Events').getRecordTypeId();
    private static final Id listsId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Lists').getRecordTypeId();
	private List<CampaignMember> memberList;
	private Campaign camp;
	public Integer segmentSize {
		get {
				if(segmentSize == null || segmentSize == 0) {
					return 50;
				}
				return segmentSize;
		}
		set{
				segmentSize = value;
		}
	}
	private Id folderId =[select id from Folder where DeveloperName ='Phone_Bank_Export'].Id;

	public Campaign getCamp() {
		if(camp == null) {
			Id id = ApexPages.currentPage().getParameters().get('id');
			if(id != null) {
				List<Campaign> campList = [
					select
						Id,
						RecordTypeId,
						Promo_Description__c,
						Event_Name__c,
						Custom_Field_1_Label__c,
						Custom_Field_2_Label__c,
						Custom_Field_3_Label__c,
						Custom_Field_4_Label__c,
						Custom_Field_5_Label__c,
						Interest_One__c,
						Interest_Two__c,
						Interest_Three__c
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
	public List<CampaignMember> getMemberList() {
		if(memberList == null) {
			Id campaignId = getCamp().id;
			if(campaignId != null) {
				memberList = [
					select
						Id,
						CORE_Campaign_Member_ID__c,
						FirstName,
						LastName,
						rC_Event__Phone__c,
						Event_RSVP__c,
						Custom_Field_1_Response__c,
						Custom_Field_2_Response__c,
						Custom_Field_3_Response__c,
						Custom_Field_4_Response__c,
						Custom_Field_5_Response__c,
						Interest_One__c,
						Interest_Two__c,
						Interest_Three__c
					from CampaignMember
					where CampaignId = :campaignId AND CampaignMember.HasResponded != true
				];
			}			
		}
		return memberList;
	}
	public pageReference export() {
        String exportName;
		if(getCamp().RecordTypeId == listsId) {
			exportName = getCamp().Promo_Description__c;
		}
		else {
			exportName = getCamp().Event_Name__c;
		}
		Zippex csvZip = new Zippex();
		List<Blob> csvList = new List<Blob>();
		Integer numSegments = (Integer) Math.ceil(getMemberList().size() / Decimal.valueOf(segmentSize));
		for(Integer i=0; i < numSegments; i++) {
			csvList.add(createOneCSV(i));
		}

		for(Integer i=0; i < csvList.size(); i++) {
			String fileName = exportName + ' Phonebank Export Segment ' + (i + 1) + '.csv';
			csvZip.addFile(fileName, csvList.get(i), null);
		}

        Document csvExport = new Document();
        csvExport.FolderId = folderId;
        csvExport.ContentType = 'application/zip';
        csvExport.Type = 'zip';
        if(getCamp().RecordTypeId == listsId) {
        	exportName = getCamp().Promo_Description__c + ' Phonebank Export All'; 
        }
        else {
        	exportName = getCamp().Event_Name__c + ' Phonebank Export All'; 
        }
        
        csvExport.Name = exportName;
        csvExport.body = csvZip.getZipArchive();
        insert csvExport;
        
        return new PageReference('/servlet/servlet.FileDownload?file=' + csvExport.Id);
	}
	public String getHeaderLine() {
		return
			'CORE Campaign Member Id,' +
			'First Name,' +
			'Last Name,' +
			'Phone Number,' +
			getHeader(getCamp().Event_Name__c, 'Event: N/A') + ',' +
			getHeader(getCamp().Custom_Field_1_Label__c , 'Question One: N/A') + ',' +
			getHeader(getCamp().Custom_Field_2_Label__c , 'Question Two: N/A') + ',' +
			getHeader(getCamp().Custom_Field_3_Label__c , 'Question Three: N/A') + ',' +
			getHeader(getCamp().Custom_Field_4_Label__c , 'Question Four: N/A') + ',' +
			getHeader(getCamp().Custom_Field_5_Label__c , 'Question Five: N/A') + ',' +
			'No Answer,' +
			'Left Message,' +
			'Bad Phone,' +
			'Update Phone,' +
			'Do Not Call,' +
			'Non-English Speaker,' +
			'# Call Attempts,' +
			getHeader(getCamp().Interest_One__c, 'Interest One: N/A') + ',' +
			getHeader(getCamp().Interest_Two__c, 'Interest Two: N/A') + ',' +
			getHeader(getCamp().Interest_Three__c, 'Interest Three: N/A')
			;
	}
	private String getHeader(String filledValue, String defaultValue) {
		if(String.isEmpty(filledValue)) {
			return defaultValue;
		}
		return filledValue;
	}
	public List<CampaignMember> getSegment() {
		String segmentNumString = ApexPages.currentPage().getParameters().get('segmentNumber');
		Integer requestedSegment = Integer.valueOf(segmentNumString);

		List<CampaignMember> campList = new List<CampaignMember>();
		
		Integer segmentNumber = 0;
		Integer segmentCount = 0;
		Integer start = 0;
		while(start < getMemberList().size() && segmentNumber <= requestedSegment) {
			while(segmentCount < segmentSize && start < getMemberList().size()) {
				if(segmentNumber == requestedSegment) {
					campList.add(getMemberList().get(start));
				}
				start++;
				segmentCount++;
			}
			segmentNumber++;
			segmentCount = 0;
		}
		return campList;
	}
	
	private Blob createOneCSV(Integer segmentNumber) {
        PageReference csv = Page.PhonebankExport;
        csv.setRedirect(false);
        csv.getParameters().put('segmentNumber', String.valueOf(segmentNumber));
        Blob body;
        try {
            // returns the output of the page as a CSV
            body = csv.getContent();
        // need to pass unit test -- current bug    
        } catch (VisualforceException e) {
            body = Blob.valueOf('Error:' + e.getMessage());
            System.debug('Exception creating blob: ' + e.getMessage());
        }

		return body;        
	}
}