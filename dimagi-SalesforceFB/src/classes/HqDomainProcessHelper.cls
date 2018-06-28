/**
 * Helper used to call Http request and process Domains JSON.
 */
public class HqDomainProcessHelper {

    private CommcareToSalesforceSettings__c serverSettings;
    private Integer limitParameter;
    private String endPoint;

    public HqDomainProcessHelper (CommcareToSalesforceSettings__c serverSettings) {
        this.serverSettings = serverSettings;
        this.limitParameter = this.serverSettings.API_Limit_Parameter__c != null ? Integer.valueOf(serverSettings.API_Limit_Parameter__c)
                                : 10;
        this.endPoint = this.serverSettings.Server_URL__c + 'project_space_metadata/?limit=';
    }

    /**
     * Returns total Domains number from HQ server.
     */
    public Integer getTotalCount() {
        Integer totalCount = null;

        try {
            HTTPResponse res = request(1, 0);
            JSONParser parser = JSON.createParser(res.getBody());
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'total_count') {
                    parser.nextToken();
                    totalCount = parser.getIntegerValue();
                    break;
                }
            }
        } catch(Exception e) {
            Commcare_Job_Settings__c settings = Commcare_Job_Settings__c.getOrgDefaults();
            EmailHelper.sendEmailFromException(settings.Error_Emails__c.split(','), 'Commcare sync Error', 'Cannot fetch total count for Domains : ' + this.serverSettings.Name, e);
        }

        return totalCount;
    }

    /**
     * Fetchs data from HQ and saves in DB.
     */
    public Integer processDomains(Integer offsetParameter) {
        HTTPResponse res = request(offsetParameter);
        String response = res.getBody();
        response = replaceReservedWords(response);
        return processJson(response, offsetParameter);
    }

    public HTTPResponse request(Integer offset) {
        return request(this.limitParameter, offset);
    }

    private HTTPResponse request(Integer size, Integer offset) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(this.endPoint + String.valueOf(size) + '&offset=' + String.valueOf(offset));
        req.setMethod('GET');

        String username = this.serverSettings.CommCare_User_Name__c;
        String password = this.serverSettings.CommCare_Password__c;

        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        req.setTimeout(120000);

        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug('--- status --' + res.getStatusCode());
        if(res.getStatusCode() != 200) {
            Exception e = new CalloutException();
            e.setMessage('Http request error, cannot fetch Domains data. Http status : ' + res.getStatusCode() + ' Body : ' + res.getBody());
            throw e;
        }

        return res;
    }

    private Integer processJson(String jsonString, Integer offset) {
        List <HqIntModelProjectSpaceMetadata> projectSpaceMetadataList = new List <HqIntModelProjectSpaceMetadata>();
        List <Domain__c> listDomainRec = new List <Domain__c>();
        List <Internal_Properties__c> listInternalPropRec = new List <Internal_Properties__c>();

        //Process Response
        JSONParser parser = JSON.createParser(jsonString);
        // Skip meta
        while (parser.nextToken() != null) {
            // Start at the array of invoices.
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'objects') {
                // Objects array
                while (parser.nextToken() != null) {
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        HqIntModelProjectSpaceMetadata projectSpaceMetadata = (HqIntModelProjectSpaceMetadata)parser.readValueAs(HqIntModelProjectSpaceMetadata.class);
                        projectSpaceMetadataList.add(projectSpaceMetadata);
                   }
                }
            }
        }

        //Set for holding the external id field for domain object. It is used to fetch existing internal prop rec & delete those.
        Set<String> setDomainId = new Set<String>();
        //Below for loop is used to create sobject out of model object
        for (HqIntModelProjectSpaceMetadata projectSpaceMetadata : projectSpaceMetadataList) {
            Domain__c domainRec = projectSpaceMetadata.domain_properties.createDbObject(projectSpaceMetadata.calculated_properties, this.serverSettings.Name);
            domainRec.offset__c = offset;
            listDomainRec.add(domainRec);
            setDomainId.add(domainRec.id__c);

            Internal_Properties__c InternalPropRec = projectSpaceMetadata.domain_properties.internal.createDbObject(this.serverSettings.Name);
            listInternalPropRec.add(InternalPropRec);
        }

        insert listInternalPropRec;


        List <Internal_Properties__c> listInternalPropToBeDeleted = new List <Internal_Properties__c>();
        //fetch exisiting sf id of internal prop for deletion.
        Map<String, Id> externalIdMap = new Map<String, Id>();
        for (Domain__c domain : [SELECT Id, Internal_Properties__c, id__c FROM Domain__c WHERE id__c in :setDomainId AND Server_Name__c =: this.serverSettings.Name]) {
            if(domain.Internal_Properties__c != null) {
                Internal_Properties__c InternalPropRec = new Internal_Properties__c(Id = domain.Internal_Properties__c);
                listInternalPropToBeDeleted.add(InternalPropRec);
            }
            externalIdMap.put(domain.id__c, domain.Id);
        }

        //delete existing int prop records
        delete listInternalPropToBeDeleted;

        //populate the lookup fields on domain obect
        for (Integer i = 0; i < listInternalPropRec.size(); i++) {
            listDomainRec[i].Internal_Properties__c = listInternalPropRec[i].Id;
            if (externalIdMap.containsKey(listDomainRec[i].id__c)) {
                listDomainRec[i].Id = externalIdMap.get(listDomainRec[i].id__c);
            }
        }

        //Finally do an upsert on the domain record list
        upsert listDomainRec;
        return listDomainRec.size();
    }

    private String replaceReservedWords(String body) {
       body = body.replaceAll('"_id"\\s*:', '"x_id":');
       body = body.replaceAll('"public"\\s*:', '"x_Public":');
       body = body.replaceAll('"date"\\s*:', '"x_date":');
       return body;
    }
}