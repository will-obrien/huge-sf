/**
 * Copyright (c) 2013, Apex Tooling API
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice,
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice,
 *      this list of conditions and the following disclaimer in the documentation
 *      and/or other materials provided with the distribution.
 * - Neither the name of the Apex Tooling API, inc nor the names of its contributors
 *      may be used to endorse or promote products derived from this software without
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/
public with sharing class ToolingAPI {

    /**
     * Complete list of all Tooling API objects (as per those in WSDL that extend tns:sObject)
     **/
    public enum SObjectType {
        CustomObject,
        CustomField,
        User
    }

    // The API version used relates to the types and structures defined here
    private static final String TOOLING_API_URI = '/services/data/v30.0/tooling';

    // Session Id can be resovled automatically depending on consturctor used
    private String sessionId;

    // Interface used to implement customi serialization on SObject based types
    private interface ISerialize {
        void serialize(JSONGenerator generator);
    }

    /**
     * Uses the current users Session Id, only compatible in a interactive context
     * @throws ToolingAPIException if no Session Id can be resolved (e.g. in a batch context)
     **/
    public ToolingAPI() {
        this.sessionId = UserInfo.getSessionId();
        if(this.sessionId==null)
            throw new ToolingAPIException('Unable to obtain Session Id');
    }

    /**
     * Uses the given Session Id, useful when using the API in a batch context
     **/
    public ToolingAPI(String sessionId) {
        this.sessionId = sessionId;
    }

    /**
     * Using this query as an example for calling the private static helper method.
     * query
     * @description Uses the queryString to issue a query via the Tooling API
     * @param The query string to use
     * @return a ToolingAPI Query Result
     * @throws ToolingAPIException if an an exception was encountered.
     */
    public QueryResult query(String queryString) {
        HttpResponse response = submitRestCall('/query/?q=' + EncodingUtil.urlEncode(queryString, 'UTF-8'));
        return parseQueryResult(response.getBody());
    }

    //Public Inner Classes for Handling Tooling API Requests

    public class CustomField extends SObject_x implements ISerialize {
        public String              fullName;
        public String              developerName;
        public CustomFieldMetadata metadata;
        public String              namespacePrefix;
        public String              tableEnumOrId;
        public CustomField() {
            super(SObjectType.CustomField);
        }
        public override void serialize(JSONGenerator jsonGen) {
            super.serialize(jsonGen);
            if(fullName!=null)
                jsonGen.writeStringField('fullName', fullName);
            if(developerName!=null)
                jsonGen.writeStringField('developerName', developerName);
            if(metadata!=null)
                jsonGen.writeObjectField('metadata', metadata);
            if(namespacePrefix!=null)
                jsonGen.writeStringField('namespacePrefix', namespacePrefix);
            if(tableEnumOrId!=null)
                jsonGen.writeStringField('tableEnumOrId', tableEnumOrId);
        }        
    }
    
    public class CustomFieldMetadata {
        public boolean      caseSensitive;
        public String       customDataType;
        public String       defaultValue;
        public String       deleteConstraint;
        public boolean      deprecated;
        public String       description;
        public String       displayFormat;
        public boolean      escapeMarkup;
        public String       externalDeveloperName;
        public boolean      externalId;
        public String       formula;
        public String       formulaTreatBlanksAs;
        public String       inlineHelpText;
        public boolean      isFilteringDisabled;
        public boolean      isNameField;
        public boolean      isSortingDisabled;
        public String       label;
        public Integer      length;
        public String       maskChar;
        public String       maskType;
        public Picklist     picklist;
        public boolean      populateExistingRows;
        public Integer      precision;
        public String       referenceTo;
        public String       relationshipLabel;
        public String       relationshipName;
        public Integer      relationshipOrder;
        public boolean      reparentableMasterDetail;
        public boolean      required;
        public boolean      restrictedAdminField;
        public Integer      scale;
        public Integer      startingNumber;
        public boolean      stripMarkup;
        public String       summarizedField;
        public FilterItem[] summaryFilterItems;
        public String       summaryForeignKey;
        public String       summaryOperation;
        public boolean      trackFeedHistory;
        public boolean      trackHistory;
        public boolean      trackTrending;
        public String       type_x;
        public boolean      unique;
        public Integer      visibleLines;
        public boolean      writeRequiresMasterRead;
    }    

    public class CustomObject extends SObject_x implements ISerialize {
        public String developerName;
        public String externalDataSourceId;
        public String namespacePrefix;
        public CustomObject() {
            super(SObjectType.CustomObject);
        }
        public override void serialize(JSONGenerator jsonGen) {
            super.serialize(jsonGen);
            if(developerName!=null)
                jsonGen.writeStringField('developerName', developerName);
            if(externalDataSourceId!=null)
                jsonGen.writeStringField('externalDataSourceId', externalDataSourceId);
            if(namespacePrefix!=null)
                jsonGen.writeStringField('namespacePrefix', namespacePrefix);
        }        
    }
    
    public class Error {
        public String[] fields;
        public String   message;
        public String   statusCode;
    }

    public class ErrorResponse{
        public List<String> fields;
        public String errorCode;
        public String message;
    }

    public class FilterItem {
        public String field;
        public String operation;
        public String value;
        public String valueField;
    }
    
    public class InvalidateSessionsResult {
        public Error[] errors;
        public Boolean success;
    }

    public class LogInfo {
        public String category;
        public String level;
    }

    public class Picklist {
        public String controllingField;
        public Boolean sorted;
    }

    public class QueryResult {
        public boolean              done;
        public String               entityTypeName;
        public String               nextRecordsUrl;
        public SObject_x[]          records;
        public Integer              size;
        public Integer              totalSize;
        public String               queryLocator;
    }

    public virtual class SObject_x {
        public transient SObjectType type_x {get; private set;}
        public transient String[]    fieldsToNull;
        public Id                    id;
        public Id                    createdById;
        public User_x                createdBy;
        public DateTime              createdDate;
        public boolean               isDeleted;
        public Id                    lastModifiedById;
        public User_x                lastModifiedBy;
        public Datetime              lastModifiedDate;
        public DateTime              systemModstamp;
        public SObject_x(SObjectType sObjectType){
            type_x = sObjectType;
        }
        public virtual void serialize(JSONGenerator jsonGen) {
            if(id!=null)
                jsonGen.writeStringField('id', id);
            if(fieldsToNull!=null)
                for(String fieldToNull : fieldsToNull)
                    jsonGen.writeNullField(fieldToNull);
        }
    }

    public class ToolingAPIException extends Exception{
        public ToolingAPIException(List<ErrorResponse> errorResponses){
            this(errorResponses[0].errorCode + ' : ' + errorResponses[0].message);
        }
    }

    public class ToolingAPIAuthorizationException extends Exception
    {
    	
    }
    
    public class User_x extends SObject_x implements ISerialize {
        public QueryResult delegatedUsers;
        public QueryResult userPreferences;
        public Id          workspaceId;
        public User_x() {
        	super(SObjectType.User);
        }
        public override void serialize(JSONGenerator jsonGen) {
            super.serialize(jsonGen);
            if(delegatedUsers!=null)
                jsonGen.writeObjectField('delegatedUsers', delegatedUsers);
            if(userPreferences!=null)
                jsonGen.writeObjectField('userPreferences', userPreferences);
            if(workspaceId!=null)
                jsonGen.writeIdField('workspaceId', workspaceId);
        }                
    }    

    //Private helper methods go here
    //

    /*
     * Helper method for submitting the REST HTTP GET request.
     *
     * @throws ToolingAPIAuthorizationException if the remote site is not authorized.
     */
    private HttpResponse submitRestCall(String relativeUrl){
        return submitRestCall(relativeUrl, 'GET');
    }
    /*
     * Helper method for submitting the REST request using the given method.
     *
     * @throws ToolingAPIAuthorizationException if the remote site is not authorized.
     */
    private HttpResponse submitRestCall(String relativeUrl, String method){
        return submitRestCall(relativeUrl, method, null);
    }

    /*
     * Helper method for submitting the REST request using the given method and data.
     *
     * @throws ToolingAPIAuthorizationException if the remote site is not authorized.
     */
    private HttpResponse submitRestCall(String relativeUrl, String method, Object data){
        Http h = new Http();
        HttpRequest queryReq = new HttpRequest();
        queryReq.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + TOOLING_API_URI + relativeUrl);
        queryReq.setHeader('Authorization', 'OAuth ' + this.sessionId);
        queryReq.setHeader('Content-Type', 'application/json');
        queryReq.setMethod(method);
        if(data!=null)
        {
            // Custom serializer?
            if(data instanceof ISerialize)
            {
                ISerialize dataToserialize = (ISerialize) data;
                JSONGenerator jsonGen = JSON.createGenerator(false);
                jsonGen.writeStartObject();
                dataToserialize.serialize(jsonGen);
                jsonGen.writeEndObject();
                queryReq.setBody(jsonGen.getAsString());
            }
            else
            {
                // Standard JSON serializer emits null values, 
                //    which are generally not tolerated by Tooling API
                queryReq.setBody(JSON.serialize(data));
            }
        }

        HttpResponse queryRes = null;
        try
        {
            queryRes = h.send(queryReq);
        }
        catch (System.CalloutException ce)
        {
            if (ce.getMessage().containsIgnoreCase('unauthorized endpoint'))
            {
                throw new ToolingAPIAuthorizationException(ce);
            }
            else
            {
                throw ce;
            }
        }

        Integer successCode = 200;
        if(method.equals('POST'))
            successCode = 201;
        else if(method.equals('DELETE'))
            successCode = 204;
        if(queryRes.getStatusCode() != successCode)
            if(queryRes.getBody().length()>0)
                throw new ToolingAPIException((List<ErrorResponse>) JSON.deserialize(queryRes.getBody(), List<ErrorResponse>.class));
            else
                throw new ToolingAPIException('Unexpected HTTP Status ' + queryRes.getStatusCode());
        return queryRes;
    }

    /**
     * Helper method for parsing query results
     **/
    private QueryResult parseQueryResult(String jsonStr){
        QueryResult queryResult = (QueryResult)JSON.deserialize(jsonStr, ToolingAPI.QueryResult.class);
        queryResult.records = getQueryResultRecords(jsonStr);
        return queryResult;
    }

    /**
     * Helper method for parsing the QueryResult response and determining
     * which instance of sObject_x to use
     */
    private List<SObject_x> getQueryResultRecords(String jsonStr){

        String recordType = getRecordType(jsonStr);

        if(recordType != null){
            JSONParser parser = JSON.createParser(jsonStr);

            while (parser.nextToken() != null) {
                if ((parser.getText() == 'records')) {
                    parser.nextToken();
                    return (List<SObject_x>)parser.readValueAs(Type.forName('List<ToolingAPI.'+recordType+'>'));
                }
            }
        }

        return null;
    }

    /**
     * Helper method for parsing type attribute from query result records in JSON response
     */
    private String getRecordType(String jsonStr){
        JSONParser parser = JSON.createParser(jsonStr);

        while (parser.nextToken() != null) {
            if ((parser.getText() == 'records')) {
                while(parser.nextToken() != null) {
                    if(parser.getText() == 'attributes'){
                        while(parser.nextToken() != null){
                            if(parser.getText() == 'type'){
                                //Value of type attribute
                                parser.nextToken();
                                return parser.getText();
                            }
                        }
                    }
                }
            }
        }
        return null;
    }
}