/**
 * Batch class used to fetch MALT tables from HQ each month and calculate Wam
 */
public class HqMaltTablesBatch implements Database.Batchable<Integer>, Database.AllowsCallouts, Database.Stateful {

    private CommcareToSalesforceSettings__c serverSettings;
    private Integer successfullyLoadedRecords;
    private Integer apiLimitParameter;
    private List<String> nextServers;
    private String serverCode;
    private Date monthDate;
    private String endPoint;
    private String startDate;
    private String endDate;
    private Map<String, Decimal> domainsWam;
    private Map<String, Decimal> domainsFormsForPeriod;
    private Boolean withDomainUpdate;

    public HqMaltTablesBatch(String serverCode, List<String> nextServers, Date monthDate, Boolean withDomainUpdate) {
        this.withDomainUpdate = withDomainUpdate;
        this.domainsWam = new Map<String, Decimal>();
        this.domainsFormsForPeriod = new Map<String, Decimal>();
        this.serverCode = serverCode;
        this.nextServers = nextServers;
        this.serverSettings = CommcareToSalesforceSettings__c.getInstance(serverCode);
        this.successfullyLoadedRecords = 0;
        this.monthDate = monthDate;

        if (this.serverSettings == null || monthDate == null) {
            Commcare_Job_Settings__c settings = Commcare_Job_Settings__c.getOrgDefaults();
            EmailHelper.sendEmail(settings.Error_Emails__c.split(','), 'Commcare sync Error', 'Cannot find server settings/month date with name : ' + this.serverCode);
            NoDataFoundException ex = new NoDataFoundException();
            ex.setMessage('Cannot find settings for server with given code : ' + serverCode);
            throw ex;
        }
        this.startDate = this.monthDate.year() + '-' + this.monthDate.month() + '-' + this.monthDate.day();
        this.monthDate.addDays(1);
        this.endDate = this.monthDate.year() + '-' + this.monthDate.month() + '-' + this.monthDate.day();
        this.endPoint = this.serverSettings.Server_URL__c + 'malt_tables/?format=json&limit=';
        this.apiLimitParameter = 30; //this object is small so we can fetch 30 records in one time 
        //this.serverSettings.API_Limit_Parameter__c != null ? Integer.valueOf(this.serverSettings.API_Limit_Parameter__c)
                            //: 10;
    }

    public Iterable<Integer> start(Database.BatchableContext BC) {
        Integer totalCount = this.getTotalCount();

        if (totalCount == null) {
            return new List<Integer>();
        }

        List <Integer> listOffset = new List <Integer>();
        for(Integer i = 0; i <= totalCount / this.apiLimitParameter; i++) {
            listOffset.add(i * this.apiLimitParameter);
        }
        if(Test.isRunningTest()) {
            listOffset = new List<Integer> {0};
        }

        System.debug('listOffset: ' + listOffset);

        return listOffset;
    }

    public void execute(Database.BatchableContext info, List<Integer> offsetList) {
        Boolean success = false;
        Integer requests = 0;
        Exception e; // we just neeed info that there was an error
        while (!success && requests < 3) { // we want fetch a few times if there was an error
            try {
                this.successfullyLoadedRecords += this.processMaltTables(offsetList[0]);
                success = true;
            } catch(Exception ex) {
                e = ex;
                requests++;
            }
        }

        if (success == false && e != null) {
            System.debug('Failed at offset with limit param ' + this.apiLimitParameter);
            System.debug(e.getMessage());
            hqInt_BatchErrorLogger.logError(info.getJobId(), '\n failed at offset with limit param ' + this.apiLimitParameter
                            + ' : ' + String.valueOf(offsetList[0]), e.getMessage(), e.getStackTraceString());
        }
    }

    public void finish(Database.BatchableContext info) {
        System.debug('this.domainsWam ' + this.domainsWam);
        if (this.withDomainUpdate && hqInt_BatchErrorLogger.checkErrorsLogged(info.getJobId()) == false && this.successfullyLoadedRecords > 0) {
            // we don't want update this if there was and error (History for fields is enabled)
            System.debug('No errors');
            Database.executeBatch(new UpdateMaltTablesStatisticsBatch(this.serverCode, this.domainsWam, this.domainsFormsForPeriod));
        }

        if(!Test.IsRunningTest()) {
            String subject = this.serverCode + ' - CommCare Salesforce Job Run Report - MALT TABLES';
            String emailBody = 'Total Successfully loaded malt records = ' + this.successfullyLoadedRecords + '\n\n';
            hqInt_BatchErrorLogger.sendErrorEmails(info.getJobId(), subject, emailBody);
        }

        if (nextServers.size() > 0) {
            String nextServer = this.nextServers.get(0);
            this.nextServers.remove(0);
            Database.executeBatch(new HqMaltTablesBatch(nextServer, this.nextServers, this.monthDate, this.withDomainUpdate), 1);
        }
    }

    private Integer processMaltTables(Integer offset) {
        HTTPResponse res = request(this.apiLimitParameter, offset);
        JSONParser parser = JSON.createParser(res.getBody());
        Integer size = 0;
        MaltTablesModel objModel;
        System.debug('res.getBody() ' + res.getBody());
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'objects') {
                while (parser.nextToken() != null) {
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        objModel = (MaltTablesModel) parser.readValueAs(MaltTablesModel.class);
                        System.debug('malt table : ' + objModel);
                        if (objModel.domain_name != null) {
                            if (objModel.domain_name.length() > 80) {
                                objModel.domain_name = objModel.domain_name.subString(0, 80);
                            }
                            Decimal value = 0;
                            if (objModel.wam == 'true' || objModel.wam == 'True' ) {
                                value = 1;
                            }
                            if (this.domainsWam.containsKey(objModel.domain_name)) {
                                this.domainsWam.put(objModel.domain_name, domainsWam.get(objModel.domain_name) + value);
                            } else {
                                this.domainsWam.put(objModel.domain_name, value);
                            }

                            if (this.domainsFormsForPeriod.containsKey(objModel.domain_name)) {
                                this.domainsFormsForPeriod.put(objModel.domain_name, this.domainsFormsForPeriod.get(objModel.domain_name) +
                                                (objModel.num_of_forms != null ? objModel.num_of_forms : 0));
                            } else {
                                this.domainsFormsForPeriod.put(objModel.domain_name, objModel.num_of_forms != null ? objModel.num_of_forms : 0);
                            }
                            size++;
                        }
                        parser.skipChildren();
                    }
                }
            }
        }
        return size;
    }

    private Integer getTotalCount() {
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
            EmailHelper.sendEmailFromException(settings.Error_Emails__c.split(','), 'Commcare sync Error', 'Cannot fetch total count for Malt tables : '
                                                                                                + this.serverSettings.Name, e);
        }

        return totalCount;
    }

    private HTTPResponse request(Integer size, Integer offset) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(this.endPoint + String.valueOf(size) + '&offset=' + String.valueOf(offset) + '&month__gte='
                                + this.startDate + '&month__lte=' + this.endDate);
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
            e.setMessage('Http request error, cannot fetch Malt data. Http status : ' + res.getStatusCode() + ' Body : ' + res.getBody());
            throw e;
        }

        return res;
    }

    public class MaltTablesModel {
        public Decimal id;
        public String app_id;
        public String device_id;
        public String domain_name;
        public String email;
        public Integer experienced_threshold;
        public Boolean is_app_deleted;
        public Date month;
        public Integer num_of_forms;
        public String pam;
        public String wam;
        public Integer use_threshold;
        public String user_id;
        public String user_type;
        public String username;
    }
}