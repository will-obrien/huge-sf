public with sharing class Dnc{
    public class Credentials{
        public String endpoint = 'https://www.donotcall.gov.au/dncrtelem/rtw/washing.cfc';
        public String telemarketerId;
        public String washOnlyUserId;
        public String telemarketerPassword;
    }
    
    public class MetadataLookupResult{
        public Id id;
        public String error;
    }
    public class MetadataLookupField{
        public Schema.DescribeFieldResult field;
        public Schema.DescribeFieldResult status;
        public Schema.DescribeFieldResult checked;
        
        public boolean isValid(){
            return field != null && status != null && checked != null;
        }
    }
    public class MetadataLookup{
        public sObjectType objectType;
        public Map<String, MetadataLookupField> fields = new Map<String, MetadataLookupField>();
        public List<MetadataLookupField> fieldList = new List<MetadataLookupField>();
    }
    
    public class ApiException extends Exception{
    }
    
    public class WashNumbersResult{
        public integer errorCode;
        public Integer accountBalance;
        public Map<String, boolean> results;
    }
    
    public static string checkCountryPrefix(String num){
        num = num.replace(' ', '').replace('(', '').replace(')', '').replace('-', '');
        if ( num.length() > 4 && num.substring(0, 4) == '+610' ){
            return num.substring(3);
        }else if ( num.substring(0, 3) == '+61' && num.length() > 3 ){
            return '0' + num.substring(3);
            
        }else if ( num.length() == 12 && num.substring(0, 3) == '610' ){
            return num.substring(2);
        }else if ( num.length() == 11 && num.substring(0, 2) == '61' ){
            return '0' + num.substring(2);
        }
        return num;
    }
    
    public static string isValidNumber(String num){
        num = num.replace(' ', '').replace('(', '').replace(')', '').replace('-', '');
        for ( integer i=0;i<num.length();i++ ){
            if ( !'0123456789'.contains(num.substring(i,i+1)) ){
                return '\'' + num.substring(i,i+1) + '\' is an invalid character';
            }
        }
        if ( num.substring(0,1) == '1' ){
            return 'Phone number begins with 1';
        }
        if ( num.length() != 10 ){
            return 'phone number contains ' + num.length() + ' digits';
        }
        
        
        //TODO: debatable...
        if ( num.substring(0,1) != '0' ){
            return 'Phone number does not begin with 0';
        }
        
        return '';
    }
    
    
    public static String getErrorDescription(Integer errorCode){
        if ( errorCode == 0 )
            return 'Success';
        else if ( errorCode == 1 )
            return 'Missing telemarketer Id, password or numbers to wash or telemarketer Id not numeric';
        else if ( errorCode == 3 )
            return 'admin or wash-only user account does not exist or not active or suspended by ACMA';
        else if ( errorCode == 4 )
            return 'current subscription does not exist or expired';
        else if ( errorCode == 5 )
            return 'insufficient account balance left to do the wash';
        else
            return 'unknown error';
    }
    
    
    public static Integer getAccountBalance(Credentials creds){
        String requestXml = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><ns1:GetAccountBalance soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns1="http://rtw.dncrtelem"><TelemarketerId xsi:type="xsd:string">' + creds.TelemarketerId.escapeXml() + '</TelemarketerId><WashOnlyUserId xsi:type="xsd:string">' + creds.WashOnlyUserId.escapeXml() + '</WashOnlyUserId><TelemarketerPassword xsi:type="xsd:string">' + creds.TelemarketerPassword.escapeXml() + '</TelemarketerPassword></ns1:GetAccountBalance></soapenv:Body></soapenv:Envelope>';
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(creds.endpoint);
        req.setMethod('POST');
        //FAILS: req.setCompressed(true);
        req.setBody(requestXml);
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');
        req.setHeader('SOAPAction', '');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        
        Xmlstreamreader reader = new Xmlstreamreader(res.getBody());
        while(reader.hasNext())
        {
            if ( reader.getLocalName() == 'AccountBalance' && reader.getEventType() == XmlTag.START_ELEMENT ){
                if ( !'0'.equals(reader.getAttributeValue(null, 'ErrorCode')) ){
                    throw new ApiException(getErrorDescription(Integer.valueOf(reader.getAttributeValue(null, 'ErrorCode'))));
                }
                reader.next();
                return Integer.valueOf(reader.getText());
            }
            reader.next();
        }
        return 0;
    }
    
    /** updates, and returns updated items */
    public static List<sObject> recalculate(List<sObject> scope, MetadataLookup lookup, MetadataLookupField[] fields, boolean keepValuesOnFailure, Date recheckItemsBefore){
        List<String> numList = new List<String>();
        Map<String, Map<String, List<sObject>>> nums = new Map<String, Map<String, List<sObject>>>();
        List<sObject> ret = new List<sObject>();
        for ( sObject obj : scope ){
            for ( MetadataLookupField field : fields ){
                if ( recheckItemsBefore != null ){
                    //skip this field if recheck date (other fields on this object may be checked still!)
                    DateTime fieldDate = (DateTime)obj.get(field.checked.name);
                    String currentStatus = (String)obj.get(field.status.name);
                    if ( currentStatus != null && fieldDate != null && fieldDate >= recheckItemsBefore ){
                        continue;
                    }
                }
                String num = (String)obj.get(field.field.name);
                if ( num == null || num == '' )
                    continue;
                num = DNC.checkCountryPrefix(num);
                String status = DNC.isValidNumber(num);
                if ( status == '' ){
                    if ( !nums.containsKey(num) ){
                        nums.put(num, new Map<String, List<sObject>>());
                        numList.add(num);
                    }
                    if ( !nums.get(num).containsKey(field.field.name) ){
                        nums.get(num).put(field.field.name, new List<sObject>());
                    }
                    nums.get(num).get(field.field.name).add(obj);
                }else{
                    //pre-validation check failed...
                    obj.put(field.status.name, 'Invalid Number');
                    obj.put(field.checked.name, System.now());
                    ret.add(obj);
                }
            }
        }
        
        if ( !nums.isEmpty() ){
            DNC.WashNumbersResult res = DNC.washNumbers(DNC.getCredentials(), numList, '');
            if ( res.errorCode == 0 ){
                for ( String num : res.results.keySet() ){
                    String result = res.results.get(num) ? 'Do not call' : 'Can call';
                    Map<String, List<sObject>> fieldObjs = nums.get(num);
                    for ( MetadataLookupField field : fields ){
                        List<sObject> objs = fieldObjs.get(field.field.name);
                        if ( objs != null ){
                            for ( sObject obj : objs ){
                                obj.put(field.status.name, result);
                                obj.put(field.checked.name, System.now());
                                ret.add(obj);
                            }
                        }
                    }
                }
            }else{
                for ( Map<String, List<sObject>> fieldObjs : nums.values() ){
                    for ( MetadataLookupField field : fields ){
                        List<sObject> objs = fieldObjs.get(field.field.name);
                        if ( objs != null ){
                            for ( sObject Obj : objs ){
                                String num = (String)obj.get(field.field.name);
                                if ( num == null || num == '' )
                                    continue;
                                String status = (String)obj.get(field.status.name);
                                if ( keepValuesOnFailure || status == ''  || status == 'Invalid Number' )
                                    continue; 
                                if ( obj.get(field.status.name) != 'Retryable Error' ){
                                    obj.put(field.status.name, 'Retryable Error');
                                    ret.add(obj);
                                }
                            }
                        }
                    }
                }
            }
        }
        return ret;
    }
    
    public static WashNumbersResult washNumbers(Credentials creds, List<String> numbers, String id){
        String requestXml = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><ns1:WashNumbers soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns1="http://rtw.dncrtelem"><TelemarketerId xsi:type="xsd:string">' + creds.TelemarketerId.escapeXml() + '</TelemarketerId><WashOnlyUserId xsi:type="xsd:string">' + creds.WashOnlyUserId.escapeXml() + '</WashOnlyUserId><TelemarketerPassword xsi:type="xsd:string">' + creds.TelemarketerPassword.escapeXml() + '</TelemarketerPassword><ClientReferenceId xsi:type="xsd:string">' + id.escapeXml() + '</ClientReferenceId><NumbersToWash soapenc:arrayType="xsd:anyType[' + numbers.size() + ']" xsi:type="soapenc:Array" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/">\n';
        for ( String num : numbers ){
            requestXml += '<NumbersToWash xsi:type="soapenc:string">' + num.escapeXml() + '</NumbersToWash>\n';
        }
        requestXml += '</NumbersToWash></ns1:WashNumbers></soapenv:Body></soapenv:Envelope>';
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(creds.endpoint);
        req.setMethod('POST');
        //FAILS: req.setCompressed(true);
        req.setBody(requestXml);
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');
        req.setHeader('SOAPAction', '');
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        String body = res.getBody();
        
        /*body = '<?xml version="1.0" encoding="utf-8"?>' +
            '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
            ' <soapenv:Body>' +
            '  <ns1:WashNumbersResponse soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns1="http://rtw.dncrtelem">' +
            '   <WashNumbersReturn xsi:type="ns2:Document" xmlns:ns2="http://xml.apache.org/xml-soap">' +
            '    <NumbersSubmitted AccountBalance="500" ClientReferenceId="1234" ErrorCode="0" FinishDate="{ts 2013-10-12 00:00:00}" TelemarketerId="18363" TransactionId="9075319" WashOnlyUserId="7587">' +
            '     <Number Result="Y">0733513847</Number>' +
            '     <Number Result="N">04123</Number>' +
            '    </NumbersSubmitted>' +
            '   </WashNumbersReturn>' +
            '  </ns1:WashNumbersResponse>' +
            ' </soapenv:Body>' +
            '</soapenv:Envelope>';*/
        
        Xmlstreamreader reader = new Xmlstreamreader(body);
        WashNumbersResult ret = new WashNumbersResult();
        ret.results = new Map<String, boolean>();
        while(reader.hasNext())
        {
            if ( reader.getLocalName() == 'NumbersSubmitted' && reader.getEventType() == XmlTag.START_ELEMENT ){
                ret.errorCode = Integer.valueOf(reader.getAttributeValue(null, 'ErrorCode'));
                if ( ret.errorCode != 0 ){
                    return ret;
                }
                ret.accountBalance = Integer.valueOf(reader.getAttributeValue(null, 'AccountBalance'));
                
                reader.next();
                while ( reader.hasNext() ){
                    if ( reader.getLocalName() == 'Number' && reader.getEventType() == XmlTag.START_ELEMENT ){
                        //result
                        String result = reader.getAttributeValue(null, 'Result');
                        //get text
                        reader.next();
                        ret.results.put(reader.getText(), result == 'Y');
                    }else if ( reader.getLocalName() == 'NumbersSubmitted' && reader.getEventType() == XmlTag.END_ELEMENT ){
                        //end of list
                        return ret;
                    }
                    reader.next();
                }
            }
        
            reader.next();
        }
        return ret;
    }
    
    public static Credentials getCredentials(){
        Config__c settings = Config__c.getOrgDefaults();
        system.assert(settings != null && settings.telemarketerId__c != null, 'Default Settings have not been configured. Please configure your org');
        Credentials creds = new Credentials();
        creds.telemarketerId = settings.telemarketerId__c;
        creds.washOnlyUserId = settings.washOnlyUserId__c;
        creds.telemarketerPassword = settings.telemarketerPassword__c;
        return creds;
    }
    public static String getRecordPrefix(String fieldApiNameValue){
        string prefix = fieldApiNameValue;
        if ( prefix.endsWith('__c'))
            prefix = prefix.substring(0, prefix.length() -3 );
        return prefix;
    }
    
    public static MetadataLookup getMetadataLookup(String objectApiNameValue, String[] fieldApiNameValues){
        MetadataLookup ret = new MetadataLookup();
        ret.objectType = Schema.getGlobalDescribe().get(objectApiNameValue);
        if ( ret.objectType == null ){
            return ret;
        }
        Schema.DescribeSObjectResult objectTypeDescribe = ret.objectType.getDescribe();
        if ( !objectTypeDescribe.isUpdateable() ){
            return ret;
        }
        
        Map<String, Schema.sObjectField> fields = objectTypeDescribe.fields.getMap();
        for ( String fieldApiNameValue : fieldApiNameValues ){
            string prefix = getRecordPrefix(String.escapeSingleQuotes(fieldApiNameValue));
            MetadataLookupField field = new MetadataLookupField();
            ret.fields.put(fieldApiNameValue, field);
            ret.fieldList.add(field);
        
            SObjectField t;
            
            t = fields.get(fieldApiNameValue);
            if ( t != null ) field.field = t.getDescribe();
            t = fields.get(prefix + '_DNC_Status__c');
            if ( t != null ) field.status = t.getDescribe();
            t = fields.get(prefix + '_DNC_Checked__c');
            if ( t != null ) field.checked = t.getDescribe();
        }
        
        return ret;
    }
    
    
    
    /**
    * returns a single element with an error if the user globally does not have access
    * returns an array of equal size for each id, containing:
    *  - error string
    *  - error is blank on writable
    * if no ids are given, an empty array is given if the fields are all writable.
    */
    public static MetadataLookupResult[] checkCurrentUserWriteAccess(String objectApiNameValue, String[] fieldApiNameValues, Id[] ids){
        MetadataLookup mdl = getMetadataLookup(objectApiNameValue, fieldApiNameValues);
        List<MetadataLookupResult> ret = new List<MetadataLookupResult>();
        MetadataLookupResult dummy = new MetadataLookupResult();
        ret.add(dummy);
        
        if ( mdl.objectType == null ){
            dummy.error = 'sObjectType ' + objectApiNameValue + ' does not exist';
            return ret;
        }
        Schema.DescribeSObjectResult objectTypeDescribe = mdl.objectType.getDescribe();
        if ( !objectTypeDescribe.isUpdateable() ){
            dummy.error = 'You do not have suffient privileges to update this object type';
            return ret;
        }
        
        string error = null;
        for ( String fieldApiNameValue : fieldApiNameValues ){
            string prefix = getRecordPrefix(String.escapeSingleQuotes(fieldApiNameValue));
            MetadataLookupField field = mdl.fields.get(fieldApiNameValue);
            
            if ( field.field == null ){ error = 'Field ' + fieldApiNameValue + ' does not exist on ' + objectApiNameValue; break; }
            if ( !field.field.isUpdateable() ){ error = 'You do not have suffient privileges to update the field: ' + fieldApiNameValue; break; }
            
            if ( field.status == null ){ error = 'Required field ' + prefix + '_DNC_Status__c does not exist on ' + objectApiNameValue; break; }
            if ( !field.status.isUpdateable() ){ error = 'You do not have suffient privileges to update the related DNC field: ' + prefix + '_DNC_Status__c'; break; }
            
            if ( field.checked == null ){ error = 'Required field ' + prefix + '_DNC_Checked__c does not exist on ' + objectApiNameValue; break; }
            if ( !field.checked.isUpdateable() ){ error = 'You do not have suffient privileges to update the related DNC field: ' + prefix + '_DNC_Checked__c'; break; }
        }
        
        //return an error, else the size of ids.
        if ( error != null ){
            dummy.error = error;
            return ret;
        }
        ret.clear();
        
        if ( ids.size() > 0 ){
            Map<Id, UserRecordAccess> mapUserRecordAccess = new Map<Id, UserRecordAccess>();
            for ( UserRecordAccess ura : [SELECT RecordId, HasReadAccess, HasEditAccess, HasDeleteAccess FROM UserRecordAccess WHERE UserId=:UserInfo.getUserId() AND RecordId IN :ids] ){
                mapUserRecordAccess.put(ura.RecordId, ura);
            }
            for ( Id id : ids ){
                UserRecordAccess ura = mapUserRecordAccess.get(id);
                MetadataLookupResult item = new MetadataLookupResult();
                ret.add(item);
                
                if ( ura == null ){
                    item.error = 'The record does not exist';
                }else if ( ura.HasReadAccess && ura.HasEditAccess ){
                    item.error = null;
                    item.id = ura.RecordId;
                }else{
                    item.error = 'You do not have suffient privileges to update this record';
                }
            }
        }
        
        return ret;
    }
    
    public static sObject[] getRecords(MetadataLookup mdl, MetadataLookupField field, Id[] recordIdValues){
        string soql = 'Select Id, ' + field.field.name + ', ' + field.status.name + ', ' + field.checked.name + ' From ' +  mdl.objectType + ' Where Id in :recordIdValues';
        return Database.query(soql);
    }
    
    public static sObject[] getRecords(MetadataLookup mdl, String[] recordIdValues){
        string soql = 'Select Id';
        for ( MetadataLookupField field : mdl.fieldList ){
            soql += ', ' + field.field.name + ', ' + field.status.name + ', ' + field.checked.name;
        }
        soql += ' From ' + mdl.objectType + ' Where Id in :recordIdValues';
        return Database.query(soql);
    }
    
    
    /*public static Integer getWashResult(Credentials creds, String id){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'getWashResult...'));
        String requestXml = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><ns1:GetWashResult soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns1="http://rtw.dncrtelem"><TelemarketerId xsi:type="xsd:string">' + creds.TelemarketerId.escapeXml() + '</TelemarketerId><WashOnlyUserId xsi:type="xsd:string">' + creds.WashOnlyUserId.escapeXml() + '</WashOnlyUserId><TelemarketerPassword xsi:type="xsd:string">' + creds.TelemarketerPassword.escapeXml() + '</TelemarketerPassword><ClientReferenceId xsi:type="xsd:string">' + id.escapeXml() + '</ClientReferenceId></ns1:GetWashResult></soapenv:Body></soapenv:Envelope>';
        
        /*
        HttpRequest req = new HttpRequest();
        req.setEndpoint(creds.endpoint);
        req.setMethod('POST');
        //FAILS: req.setCompressed(true);
        req.setBody(requestXml);
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');
        re<?xml version="1.0" encoding="utf-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> <soapenv:Body> <ns1:WashNumbersResponse soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns1="http://rtw.dncrtelem"> <WashNumbersReturn xsi:type="ns2:Document" xmlns:ns2="http://xml.apache.org/xml-soap"> <NumbersSubmitted AccountBalance="" ClientReferenceId="A5BF" ErrorCode="1" FinishDate="" TelemarketerId="18363" TransactionId="" WashOnlyUserId="7587">0733513847</NumbersSubmitted> </WashNumbersReturn> </ns1:WashNumbersResponse> </soapenv:Body> </soapenv:Envelope>q.setHeader('SOAPAction', '');
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'BODY: ' + res.getBody()));

        String body = '<?xml version="1.0" encoding="utf-8"?>' +
            '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
            ' <soapenv:Body>' +
            '  <ns1:GetWashResultResponse soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns1="http://rtw.dncrtelem">' +
            '   <GetWashResultReturn xsi:type="ns2:Document" xmlns:ns2="http://xml.apache.org/xml-soap">' +
            '    <NumbersSubmitted AccountBalance="" ClientReferenceId="1234" ErrorCode="0" FinishDate="2013-10-12 13:38:42.0" TelemarketerId="18363" TransactionId="9075319" WashOnlyUserId="7587">' +
            '     <Number Result="Y">0733513847</Number>' +
            '     <Number Result="N">04123</Number>' +
            '    </NumbersSubmitted>' +
            '   </GetWashResultReturn>' +
            '  </ns1:GetWashResultResponse>' +
            ' </soapenv:Body>' +
            '</soapenv:Envelope>';
        
        Xmlstreamreader reader = new Xmlstreamreader(body);
        WashNumbersResult ret = new WashNumbersResult();
        ret.results = new Map<String, boolean>();
        integer c = 0;
        while(reader.hasNext())
        {
            if ( reader.getLocalName() == 'NumbersSubmitted' && reader.getEventType() == XmlTag.START_ELEMENT ){
                ret.accountBalance = Integer.valueOf(reader.getAttributeValue(null, 'AccountBalance'));
                
                reader.next();
                while ( reader.hasNext() ){
                    if ( reader.getLocalName() == 'Number' && reader.getEventType() == XmlTag.START_ELEMENT ){
                        //result
                        String result = reader.getAttributeValue(null, 'Result');
                        //get text
                        reader.next();
                        ret.results.put(reader.getText(), result == 'Y');
                    }else if ( reader.getLocalName() == 'NumbersSubmitted' && reader.getEventType() == XmlTag.END_ELEMENT ){
                        //end of list
                        return ret;
                    }
                    reader.next();
                }
            }
        
            reader.next();
        }
        return ret;
    }*/
    
    public static void handleTriggerUpdate(Map<Id, sObject> oldMap, Map<Id, sObject> newMap, String[] fieldApiNames){
        for ( String fieldApiName : fieldApiNames ){
            String prefix = DNC.getRecordPrefix(String.escapeSingleQuotes(fieldApiName));
            for ( sObject obj : newMap.values() ){
                sObject prev = oldMap.get(obj.id);
                if ( obj.get(fieldApiName) != prev.get(fieldApiName) ){
                    obj.put(prefix + '_DNC_Status__c', null);
                }
            }
        }
    }
}