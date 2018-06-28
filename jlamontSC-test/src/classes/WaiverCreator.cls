public without sharing class WaiverCreator implements Queueable, Database.AllowsCallouts {
    private List<String> registrationIds;
    
    public WaiverCreator(List<String> idList) {
        this.registrationIds = idList;
    }
    public void execute(QueueableContext context) {
        Folder eventFolder =[select id from Folder where DeveloperName ='Event_Waivers'];
        Id folderId = eventFolder.Id;
        PageReference pdf = new PageReference(getSiteBaseURL() + '/WaiverGenerator');
        List<Event_Registration__c> regList = [
            select Id, Full_Name__c, Waiver_Id__c
            from Event_Registration__c
            where Id in :registrationIds
        ];

        List<Document> waiverList = new List<Document>();       
        for(Event_Registration__c reg : regList) {
            if(String.isEmpty(reg.Waiver_Id__c)) {
                pdf.getParameters().put('id', reg.Id);
            
                Document waiver = new Document();
                waiver.FolderId = folderId;
                waiver.ContentType = 'application/pdf';
                waiver.Type = 'pdf';
                waiver.Name = 'Event Waiver for ' + reg.Full_Name__c;
            
                Blob body;
            
                try {
            
                    // returns the output of the page as a PDF
                    body = pdf.getContent();
            
                // need to pass unit test -- current bug    
                } catch (VisualforceException e) {
                    body = Blob.valueOf('Error:' + e.getMessage());
                }
            
                waiver.Body = body;
                waiverList.add(waiver);
            }
        }
        
        Database.SaveResult[] srList = Database.insert(waiverList, false);
        System.debug('srList: ' + srList);
        
        Integer i=0;
        for(Database.SaveResult sr : srList) {
            if(sr.isSuccess()) {
                Event_Registration__c reg = regList.get(i);
                reg.Waiver_Id__c = sr.getId();
                reg.Waiver_Submitted__c = true;
                reg.Waiver_is_Digital__c = true;
            }
            i++;
        }
        update regList;
        sendWaivers();
    }

    private void sendWaivers() {
        List<Event_Registration__c> regList = [
            select 
                Id, 
                First_Name__c, 
                Last_Name__c, 
                Contact__c, 
                Email__c, 
                Waiver_Id__c,
                Status__c,
                Club_Event__r.Event_Title__c,
                Is_Minor__c,
                Guardian_First_Name__c,
                Guardian_Last_Name__c,
                Guardian_Email__c
            from Event_Registration__c
            where Id in :registrationIds
        ];
        
        Integer counter = 0;
        JSONGenerator gen = JSON.createGenerator(false);
        gen.writeStartArray();
        for(Event_Registration__c reg : regList) {
        	String emailAddr = reg.Email__c;
        	if(reg.Is_Minor__c) {
        		emailAddr = reg.Guardian_Email__c;
        	}
            gen.writeStartObject();
            gen.writeFieldName('To');
            gen.writeStartObject();
            gen.writeStringField('Address', emailAddr);
            gen.writeStringField('SubscriberKey', String.isEmpty(reg.Contact__c) ? reg.Email__c : reg.Contact__c);
            gen.writeFieldName('ContactAttributes');
            gen.writeStartObject();
            gen.writeFieldName('SubscriberAttributes');
            gen.writeStartObject();
            gen.writeStringField('FirstName', reg.First_Name__c);
            gen.writeStringField('LastName', reg.Last_Name__c);
            gen.writeStringField('Status', reg.Status__c == 'Attended' ? 'attending' : 'registering for');
            gen.writeStringField('EventName', reg.Club_Event__r.Event_Title__c);
            gen.writeStringField('AttachmentURL', getDocumentUrl(reg.Waiver_Id__c));
            gen.writeEndObject();
            gen.writeEndObject();
            gen.writeEndObject();
            gen.writeEndObject();
        }
        gen.writeEndArray();

        TriggeredSendEmail__c msg = new TriggeredSendEmail__c (
            RequestBody__c = gen.getAsString(),
            SendId__c = 'event-waiver'
        );
        insert msg;
    }

    private static String getDocumentUrl(String waiverId) {
        String baseURL = getSiteBaseURL();
        String documentBase = '/servlet/servlet.FileDownload?file=';
        String url = baseUrl + documentBase + waiverId + '&oid=' + UserInfo.getOrganizationId();
        return url;
    }
    private static String getSiteBaseURL() {
        Map<String, SiteURL__c> urlMap = SiteURL__c.getAll();
        SiteURL__c siteURL = urlMap.get('BaseSite');
        return siteURL.BaseURL__c;
    }
}