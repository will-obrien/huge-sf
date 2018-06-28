global with sharing class BulkUploadController {

	private List<String> mediaDetail;
	public String mediaDetailValues;
	private List<String> mediaType;
	public String mediaTypeValues;
	private List<String> scopeStatus;
	public String scopeStatusValues;

	private List<String> projectType;
	public String projectTypeValues;

	private List<String> complexity;
	public String complexityValues;

	public BulkUploadController() {
		mediaDetail = new List<String>();
		Schema.DescribeFieldResult fr = Deliverable__c.Media_Detail__c.getDescribe();
		List<Schema.PickListEntry> ple = fr.getPicklistValues();
		for (Schema.PickListEntry e : ple) {
			mediaDetail.add(e.getLabel());
		}

		mediaType = new List<String>();
		fr = Deliverable__c.Media_Type__c.getDescribe();
		ple = fr.getPicklistValues();
		for (Schema.PickListEntry e : ple) {
			mediaType.add(e.getLabel());
		}

		scopeStatus = new List<String>();
		fr = Deliverable__c.Scope_Status__c.getDescribe();
		ple = fr.getPicklistValues();
		for (Schema.PickListEntry e : ple) {
			scopeStatus.add(e.getLabel());
		}

		projectType = new List<String>();
		fr = Deliverable__c.Project_Type__c.getDescribe();
		ple = fr.getPicklistValues();
		for (Schema.PicklistEntry e : ple) {
			projectType.add(e.getLabel());
		}

		complexity = new List<String>();
		fr = Deliverable__c.Complexity__c.getDescribe();
		ple = fr.getPicklistValues();
		for (Schema.PicklistEntry e : ple) {
			complexity.add(e.getLabel());
		}
	}

	public String getMediaDetailValues() {
		return stringify(mediaDetail);
	}

	public String getMediaTypeValues() {
		return stringify(mediaType);
	}

	public String getScopeStatusValues() {
		return stringify(scopeStatus);
	}

	public String getProjectTypeValues() {
		return stringify(projectType);
	}

	public String getComplexityValues() {
		return stringify(complexity);
	}

	private String stringify(List<String> lst) {
		String ret = '';
		for (String s : lst) {
			ret += s + ',';
		}
		return ret.removeEnd(',');
	}
	
	@RemoteAction 
	global static String campaignLookupByName(String cname) {
		System.debug('campaignLookupByName called with: ' + cname);
		String id = '';
		try {
			id = [SELECT Id FROM Campaign__c WHERE Name = :cname].Id;
			System.debug('**** id is: ' + id);	
		}
		catch (QueryException e) {
			System.debug('**** ' + e);
		}
		return id;
	}

	@RemoteAction
	global static String createCampaign(String cname /*, String budgetId */) {

		try {
			Campaign__c campaign = new Campaign__c(Name = cname /*, Budget__c = budgetId */);
			insert campaign;
			return campaign.id;
		}
		catch (StringException e) {
			System.debug('StringException in createCampaign: ' + e.getMessage());
			return 'error';
		}
		catch (DmlException de) {
			System.debug('DmlException in createCampaign: ' + de.getMessage());
			return 'error';
		}
	}

	// createDeilverable
	@RemoteAction
	global static String createDeliverable(String deliverableId, String campaignId,
		String deliverableName, String scopeStatus, String mediaType, String mediaDetail,
		String projectType, String complexity, String percentComplete, 
		// String creativeRounds, 
		String element1, String element2, String versions// , 
		// String targetCompletion
		) {

		System.debug('***** createDeliverable called with : ' + deliverableId);
		System.debug('*****      campaign id: ' + campaignId);


		try {

			Deliverable__c deliverable = new Deliverable__c(// Id = deliverableId,
				Campaign__c = campaignId,
				Name = deliverableName,
				Scope_Status__c = scopeStatus,
				Media_Type__c = mediaType,
				Media_Detail__c = mediaDetail,
				Project_Type__c = projectType,
				Complexity__c = complexity,
				Percent_Complete__c = Decimal.valueOf(percentComplete),
				// Creative_Rounds__c = creativeRounds,
				Element_1__c = Decimal.valueOf(element1),
				Element_2__c = Decimal.valueOf(element2), 
				Versions__c = Decimal.valueOf(versions) // ,
				// Target_Completion__c = targetCompletion
				);

			if (!String.isBlank(deliverableId)) {
				deliverable.Id = deliverableId;
			}
			System.debug('***** ' + deliverable);

			upsert deliverable;
			return deliverable.Id;
		}
		catch (TypeException te) {
			System.debug('Caught type exception: ' + te.getMessage());
			return 'error'; 
		}
		catch (DmlException de) {
			System.debug('DmlException in createDeliverable: ' + de.getMessage());
			return 'error';
		}
	}

	@RemoteAction
	global static String lookupCampaignNameById(String id, Integer row) {

		try {
			String cname = [SELECT Name FROM Campaign__c WHERE Id = :id].Name;
			return cname + '?' + row;
		}
		catch (QueryException e) {
			System.debug('**** Unable to locate Campaign for id: ' + id);
			return 'error?' + row;
		}
		return 'error?' + row;
	}

	@RemoteAction
	global static String lookupCampaignByName(String cname, Integer row) {

		String result = '';
		try {
			String id = [SELECT Id FROM Campaign__c WHERE Name = :cname].Id;
			result = cname + '?' + row + '?' + id;
		}
		catch (QueryException e) {
			System.debug('**** Unable to locate Campaign for name: ' + cname);
			result = 'error?' + row;
		}
		return result;
	}


	@RemoteAction
	global static String validateItem(Integer row, String data) {

		System.debug('***** RemoteAction validateItem called with : ' + data);

		List<String> errors = new List<String>();
		List<String> changes = new List<String>();
		Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(data);

		// Get the id out of the object
		String id = (String)m.get('ID');
		System.debug('**** found the id: ' + id);

		JSONGenerator gen = JSON.createGenerator(true);
		gen.writeStartObject();
		gen.writeNumberField('row', row);

		try {
			// Get the Deliverable and Campaign Name for this object
			Deliverable__c deliv = [SELECT Id, Name, Campaign__c, Campaign__r.Name, Media_Type__c, Media_Detail__c, 
				Project_Type__c, Complexity__c, Scope_Status__c,
				Percent_Complete__c, 
				Element_1__c, Element_2__c, Versions__c 
			 FROM Deliverable__c WHERE Id = :id];


			System.debug('***** deliv: ' + deliv);

			// Before we set this to 'updating', we need to validate all the fields to see if they 
			// differ between what we were passed in and what is in the DB

			String val = '';

			if (String.isBlank((String)m.get('NAME'))) {
				errors.add('NAME');
			} else if ((String)m.get('NAME') != deliv.Name) {
				System.debug('***** Name does not match');
				changes.add('NAME');
			}

			String cname = (String)m.get('CAMPAIGN_NAME');
			String cid = '';
			if (String.isBlank(cname)) {
				errors.add('CAMPAIGN_NAME');
			} else if (cname != deliv.Campaign__r.Name) {
				System.debug('***** Campaign name does not match');
				// This is an error. You can't reassign a deliverable to another campaign
				// changes.add('CAMPAIGN_NAME');
				// Ethan decided we should be able to reparent Deliverables to Campaigns.
				// This is not an error but a change.

				// Let's lookup the campaign name to determine if it is existing or new
				try {
					cid = [SELECT Id FROM Campaign__c WHERE Name = :cname].Id;
					System.debug('***** the id is: ' + cid);
				}
				catch (QueryException qe) {
					System.debug('**** cant find that campaign');
				}
				changes.add('CAMPAIGN_NAME');
			} else {
				cid = deliv.Campaign__c;
			}

			if (String.isBlank((String)m.get('MEDIA_TYPE__C'))) {
				errors.add('MEDIA_TYPE__C');
			} else if ((String)m.get('MEDIA_TYPE__C') != deliv.Media_Type__c) {
				System.debug('***** Media_Type__c does not match');
				changes.add('MEDIA_TYPE__C');
			}

			if (String.isBlank((String)m.get('MEDIA_DETAIL__C'))) {
				errors.add('MEDIA_DETAIL__C');
			} else if ((String)m.get('MEDIA_DETAIL__C') != deliv.Media_Detail__c) {
				System.debug('***** Media_Detail__c does not match');
				changes.add('MEDIA_DETAIL__C');
			}

			if (String.isBlank((String)m.get('PROJECT_TYPE__C'))) {
				errors.add('PROJECT_TYPE__C');
			} else if ((String)m.get('PROJECT_TYPE__C') != deliv.Project_Type__c) {
				System.debug('***** Project_Type__c does not match');
				changes.add('PROJECT_TYPE__C');
			}

			if (String.isBlank((String)m.get('COMPLEXITY__C'))) {
				errors.add('COMPLEXITY__C');
			} else if ((String)m.get('COMPLEXITY__C') != deliv.Complexity__c) {
				System.debug('***** Complexity__c does not match');
				changes.add('COMPLEXITY__C');
			}

			if (String.isBlank((String)m.get('SCOPE_STATUS__C'))) {
				errors.add('SCOPE_STATUS__C');
			} else if ((String)m.get('SCOPE_STATUS__C') != deliv.Scope_Status__c) {
				System.debug('***** Scope_Status__c does not match');
				changes.add('SCOPE_STATUS__C');
			}

			val = (String)m.get('PERCENT_COMPLETE__C');
			if (String.isBlank(val)) {
				errors.add('PERCENT_COMPLETE__C');
			} else if (val != null && Integer.valueOf(val) != deliv.Percent_Complete__c) {
				System.debug('***** Percent_Complete__c does not match');
				changes.add('PERCENT_COMPLETE__C');
			}

			val = (String)m.get('ELEMENT_1__C');
			if (val != null && Integer.valueOf(val) != deliv.Element_1__c) {
				System.debug('***** Element_1__c does not match');
				changes.add('ELEMENT_1__C');
			}
			val = (String)m.get('ELEMENT_2__C');
			if (val != null && Integer.valueOf(val) != deliv.Element_2__c ) {
				System.debug('***** Element_2__c does not match');
				changes.add('ELEMENT_2__C');
			}
			val = (String)m.get('VERSIONS__C');
			if (val != null && Integer.valueOf(val) != deliv.Versions__c) {
				System.debug('***** Versions__c does not match');
				changes.add('VERSIONS__C');
			}

			if (errors.size() > 0) {
				gen.writeStringField('status', 'error');
			}
			else if (changes.size() > 0) {
				gen.writeStringField('status', 'updating');
			}
			else {
				gen.writeStringField('status', 'unchanged');
			}
			
			// Now write out all the other fields
			// NOTE: This is probably not necessary. We can return the stored values
			//       or we could return indices of invalid or updated fields. 
			//       It is probably best to return the stored values and let the JavaScript
			//       code handle what to do about it.

			gen.writeStringField('ID', deliv.Id);
			gen.writeStringField('NAME', deliv.Name);
			//gen.writeStringField('CAMPAIGN__C', deliv.Campaign__c);
			gen.writeStringField('CAMPAIGN__C', cid);
			// gen.writeStringField('CAMPAIGN_NAME', deliv.Campaign__r.Name);
			gen.writeStringField('CAMPAIGN_NAME', cname);
			gen.writeStringField('MEDIA_TYPE__C', deliv.Media_Type__c);
			gen.writeStringField('MEDIA_DETAIL__C', deliv.Media_Detail__c);
			gen.writeStringField('PROJECT_TYPE__C', deliv.Project_Type__c);
			gen.writeStringField('COMPLEXITY__C', deliv.Complexity__c);
			gen.writeStringField('SCOPE_STATUS__C', deliv.Scope_Status__c);
			gen.writeNumberField('PERCENT_COMPLETE__C', deliv.Percent_Complete__c);

			// gen.writeNumberField('CREATIVE_ROUNDS__C', (deliv.Creative_Rounds__c != null) ? deliv.Creative_Rounds__c : 0);
			// gen.writeNumberField('PRODUCTION_ROUNDS__C', (deliv.Production_Rounds__c != null) ? deliv.Production_Rounds__c : 0);
			gen.writeNumberField('ELEMENT_1__C', (deliv.Element_1__c == null) ? 0 : deliv.Element_1__c);
			gen.writeNumberField('ELEMENT_2__C', (deliv.Element_2__c == null) ? 0 : deliv.Element_2__c);
			gen.writeNumberField('VERSIONS__C', (deliv.Versions__c == null) ? 0 : deliv.Versions__c);
			// gen.writeStringField('DESCRIPTION__C', (deliv.Description__c != null) ? deliv.Description__c : '');
			// gen.writeNumberField('TARGET_COMPLETION__C', deliv.Target_Completion__c);

		}
		catch (System.QueryException e) {
			gen.writeStringField('status', 'error');
			gen.writeStringField('ID', id);

			// If we had an error getting the record, the ID is invalid
			errors.add('ID');
		}

		gen.writeFieldName('changes');
		gen.writeStartArray();
		for(String change : changes) {
			gen.writeString(change);
		}
		gen.writeEndArray();


		gen.writeFieldName('errors');
		gen.writeStartArray();
		for(String err : errors) {
			System.debug('***** err: ' + err);
			System.debug('***** id: ' + id);
			gen.writeString(err);
		}
		gen.writeEndArray();

		gen.writeEndObject();
		String jout = gen.getAsString();
		System.debug('**** jout:' + jout);
		return jout;
	}
}