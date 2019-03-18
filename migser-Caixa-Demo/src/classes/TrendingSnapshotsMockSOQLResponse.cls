public class TrendingSnapshotsMockSOQLResponse {
    
    public static boolean isJson;
    
    //=========================================================================================//
    //Create SOQL JSON For Testing 
    //=========================================================================================//
    public static String getSOQLJSON() {

		return  '{' +
		'  "actionOverrides" : [ {' +
		'    "isAvailableInTouch" : false,' +
		'    "name" : "Edit",' +
		'    "pageId" : "066B0000000IwaHIAS",' +
		'    "url" : "https://c.gus.visual.force.com/apex/createextract?id=ENTITY_ID"' +
		'  }, {' +
		'    "isAvailableInTouch" : false,' +
		'    "name" : "New",' +
		'    "pageId" : "066B0000000IwaHIAS",' +
		'    "url" : "https://c.gus.visual.force.com/apex/createextract?id=ENTITY_ID"' +
		'  } ],' +
		'  "activateable" : false,' +
		'  "childRelationships" : [ {' +
		'    "cascadeDelete" : true,' +
		'    "childSObject" : "AttachedContentDocument",' +
		'    "deprecatedAndHidden" : false,' +
		'    "field" : "LinkedEntityId",' +
		'    "junctionIdListName" : null,' +
		'    "junctionReferenceTo" : [ ],' +
		'    "relationshipName" : "AttachedContentDocuments",' +
		'    "restrictedDelete" : false' +
		'  }, {' +
		'    "cascadeDelete" : true,' +
		'    "childSObject" : "Attachment",' +
		'    "deprecatedAndHidden" : false,' +
		'    "field" : "ParentId",' +
		'    "junctionIdListName" : null,' +
		'    "junctionReferenceTo" : [ ],' +
		'    "relationshipName" : "Attachments",' +
		'    "restrictedDelete" : false' +
		'  }, {' +
		'    "cascadeDelete" : true,' +
		'    "childSObject" : "CollaborationGroupRecord",' +
		'    "deprecatedAndHidden" : false,' +
		'    "field" : "RecordId",' +
		'    "junctionIdListName" : null,' +
		'    "junctionReferenceTo" : [ ],' +
		'    "relationshipName" : "RecordAssociatedGroups",' +
		'    "restrictedDelete" : false' +
		'  }, {' +
		'    "cascadeDelete" : true,' +
		'    "childSObject" : "CombinedAttachment",' +
		'    "deprecatedAndHidden" : false,' +
		'    "field" : "ParentId",' +
		'    "junctionIdListName" : null,' +
		'    "junctionReferenceTo" : [ ],' +
		'    "relationshipName" : "CombinedAttachments",' +
		'    "restrictedDelete" : false' +
		'  }, {' +
		'    "cascadeDelete" : true,' +
		'    "childSObject" : "ContentDistribution",' +
		'    "deprecatedAndHidden" : false,' +
		'    "field" : "RelatedRecordId",' +
		'    "junctionIdListName" : null,' +
		'    "junctionReferenceTo" : [ ],' +
		'    "relationshipName" : null,' +
		'    "restrictedDelete" : false' +
		'  }, {' +
		'    "cascadeDelete" : true,' +
		'    "childSObject" : "ContentDocumentLink",' +
		'    "deprecatedAndHidden" : false,' +
		'    "field" : "LinkedEntityId",' +
		'    "junctionIdListName" : null,' +
		'    "junctionReferenceTo" : [ ],' +
		'    "relationshipName" : null,' +
		'    "restrictedDelete" : false' +
		'  }, {' +
		'    "cascadeDelete" : false,' +
		'    "childSObject" : "ContentVersion",' +
		'    "deprecatedAndHidden" : false,' +
		'    "field" : "FirstPublishLocationId",' +
		'    "junctionIdListName" : null,' +
		'    "junctionReferenceTo" : [ ],' +
		'    "relationshipName" : null,' +
		'    "restrictedDelete" : false' +
		'  }, {' +
		'    "cascadeDelete" : true,' +
		'    "childSObject" : "DuplicateRecordItem",' +
		'    "deprecatedAndHidden" : false,' +
		'    "field" : "RecordId",' +
		'    "junctionIdListName" : null,' +
		'    "junctionReferenceTo" : [ ],' +
		'    "relationshipName" : "DuplicateRecordItems",' +
		'    "restrictedDelete" : false' +
		'  }, {' +
		'    "cascadeDelete" : true,' +
		'    "childSObject" : "EntitySubscription",' +
		'    "deprecatedAndHidden" : false,' +
		'    "field" : "ParentId",' +
		'    "junctionIdListName" : null,' +
		'    "junctionReferenceTo" : [ ],' +
		'    "relationshipName" : "FeedSubscriptionsForEntity",' +
		'    "restrictedDelete" : false' +
		'  }, {' +
		'    "cascadeDelete" : false,' +
		'    "childSObject" : "FeedComment",' +
		'    "deprecatedAndHidden" : false,' +
		'    "field" : "ParentId",' +
		'    "junctionIdListName" : null,' +
		'    "junctionReferenceTo" : [ ],' +
		'    "relationshipName" : null,' +
		'    "restrictedDelete" : false' +
		'  }, {' +
		'    "cascadeDelete" : true,' +
		'    "childSObject" : "FeedItem",' +
		'    "deprecatedAndHidden" : false,' +
		'    "field" : "ParentId",' +
		'    "junctionIdListName" : null,' +
		'    "junctionReferenceTo" : [ ],' +
		'    "relationshipName" : null,' +
		'    "restrictedDelete" : false' +
		'  }, {' +
		'    "cascadeDelete" : true,' +
		'    "childSObject" : "Note",' +
		'    "deprecatedAndHidden" : false,' +
		'    "field" : "ParentId",' +
		'    "junctionIdListName" : null,' +
		'    "junctionReferenceTo" : [ ],' +
		'    "relationshipName" : "Notes",' +
		'    "restrictedDelete" : false' +
		'  }, {' +
		'    "cascadeDelete" : true,' +
		'    "childSObject" : "NoteAndAttachment",' +
		'    "deprecatedAndHidden" : false,' +
		'    "field" : "ParentId",' +
		'    "junctionIdListName" : null,' +
		'    "junctionReferenceTo" : [ ],' +
		'    "relationshipName" : "NotesAndAttachments",' +
		'    "restrictedDelete" : false' +
		'  }, {' +
		'    "cascadeDelete" : true,' +
		'    "childSObject" : "ProcessInstance",' +
		'    "deprecatedAndHidden" : false,' +
		'    "field" : "TargetObjectId",' +
		'    "junctionIdListName" : null,' +
		'    "junctionReferenceTo" : [ ],' +
		'    "relationshipName" : "ProcessInstances",' +
		'    "restrictedDelete" : false' +
		'  }, {' +
		'    "cascadeDelete" : false,' +
		'    "childSObject" : "ProcessInstanceHistory",' +
		'    "deprecatedAndHidden" : false,' +
		'    "field" : "TargetObjectId",' +
		'    "junctionIdListName" : null,' +
		'    "junctionReferenceTo" : [ ],' +
		'    "relationshipName" : "ProcessSteps",' +
		'    "restrictedDelete" : false' +
		'  }, {' +
		'    "cascadeDelete" : true,' +
		'    "childSObject" : "TopicAssignment",' +
		'    "deprecatedAndHidden" : false,' +
		'    "field" : "EntityId",' +
		'    "junctionIdListName" : null,' +
		'    "junctionReferenceTo" : [ ],' +
		'    "relationshipName" : "TopicAssignments",' +
		'    "restrictedDelete" : false' +
		'  } ],' +
		'  "compactLayoutable" : true,' +
		'  "createable" : true,' +
		'  "custom" : true,' +
		'  "customSetting" : false,' +
		'  "deletable" : true,' +
		'  "deprecatedAndHidden" : false,' +
		'  "feedEnabled" : false,' +
		'  "fields" : [ {' +
		'    "autoNumber" : false,' +
		'    "byteLength" : 765,' +
		'    "calculated" : false,' +
		'    "calculatedFormula" : null,' +
		'    "cascadeDelete" : false,' +
		'    "caseSensitive" : false,' +
		'    "controllerName" : null,' +
		'    "createable" : true,' +
		'    "custom" : true,' +
		'    "defaultValue" : null,' +
		'    "defaultValueFormula" : null,' +
		'    "defaultedOnCreate" : false,' +
		'    "dependentPicklist" : false,' +
		'    "deprecatedAndHidden" : false,' +
		'    "digits" : 0,' +
		'    "displayLocationInDecimal" : false,' +
		'    "encrypted" : false,' +
		'    "externalId" : false,' +
		'    "extraTypeInfo" : null,' +
		'    "filterable" : true,' +
		'    "filteredLookupInfo" : null,' +
		'    "groupable" : true,' +
		'    "highScaleNumber" : false,' +
		'    "htmlFormatted" : false,' +
		'    "idLookup" : false,' +
		'    "inlineHelpText" : null,' +
		'    "label" : "Type",' +
		'    "length" : 255,' +
		'    "mask" : null,' +
		'    "maskType" : null,' +
		'    "name" : "Type__c",' +
		'    "nameField" : false,' +
		'    "namePointing" : false,' +
		'    "nillable" : true,' +
		'    "permissionable" : true,' +
		'    "picklistValues" : [ ],' +
		'    "precision" : 0,' +
		'    "queryByDistance" : false,' +
		'    "referenceTargetField" : null,' +
		'    "referenceTo" : [ ],' +
		'    "relationshipName" : null,' +
		'    "relationshipOrder" : null,' +
		'    "restrictedDelete" : false,' +
		'    "restrictedPicklist" : false,' +
		'    "scale" : 0,' +
		'    "soapType" : "xsd:double",' +
		'    "sortable" : true,' +
		'    "type" : "double",' +
		'    "unique" : false,' +
		'    "updateable" : true,' +
		'    "writeRequiresMasterRead" : false' +
		'  },{' +
		'    "autoNumber" : false,' +
		'    "byteLength" : 765,' +
		'    "calculated" : false,' +
		'    "calculatedFormula" : null,' +
		'    "cascadeDelete" : false,' +
		'    "caseSensitive" : false,' +
		'    "controllerName" : null,' +
		'    "createable" : true,' +
		'    "custom" : true,' +
		'    "defaultValue" : null,' +
		'    "defaultValueFormula" : null,' +
		'    "defaultedOnCreate" : false,' +
		'    "dependentPicklist" : false,' +
		'    "deprecatedAndHidden" : false,' +
		'    "digits" : 0,' +
		'    "displayLocationInDecimal" : false,' +
		'    "encrypted" : false,' +
		'    "externalId" : false,' +
		'    "extraTypeInfo" : null,' +
		'    "filterable" : true,' +
		'    "filteredLookupInfo" : null,' +
		'    "groupable" : true,' +
		'    "highScaleNumber" : false,' +
		'    "htmlFormatted" : false,' +
		'    "idLookup" : false,' +
		'    "inlineHelpText" : null,' +
		'    "label" : "Type",' +
		'    "length" : 255,' +
		'    "mask" : null,' +
		'    "maskType" : null,' +
		'    "name" : "Id",' +
		'    "nameField" : false,' +
		'    "namePointing" : false,' +
		'    "nillable" : true,' +
		'    "permissionable" : true,' +
		'    "picklistValues" : [ {' +
		'      "active" : true,' +
		'      "defaultValue" : false,' +
		'      "label" : "SOQL",' +
		'      "validFor" : null,' +
		'      "value" : "SOQL"' +
		'    }, {' +
		'      "active" : true,' +
		'      "defaultValue" : false,' +
		'      "label" : "Report",' +
		'      "validFor" : null,' +
		'      "value" : "Report"' +
		'    } ],' +
		'    "precision" : 0,' +
		'    "queryByDistance" : false,' +
		'    "referenceTargetField" : null,' +
		'    "referenceTo" : [ ],' +
		'    "relationshipName" : null,' +
		'    "relationshipOrder" : null,' +
		'    "restrictedDelete" : false,' +
		'    "restrictedPicklist" : false,' +
		'    "scale" : 0,' +
		'    "soapType" : "xsd:string",' +
		'    "sortable" : true,' +
		'    "type" : "multipicklist",' +
		'    "unique" : false,' +
		'    "updateable" : true,' +
		'    "writeRequiresMasterRead" : false' +
		'  },{' +
		'    "autoNumber" : false,' +
		'    "byteLength" : 0,' +
		'    "calculated" : false,' +
		'    "calculatedFormula" : null,' +
		'    "cascadeDelete" : false,' +
		'    "caseSensitive" : false,' +
		'    "controllerName" : null,' +
		'    "createable" : true,' +
		'    "custom" : true,' +
		'    "defaultValue" : null,' +
		'    "defaultValueFormula" : null,' +
		'    "defaultedOnCreate" : false,' +
		'    "dependentPicklist" : false,' +
		'    "deprecatedAndHidden" : false,' +
		'    "digits" : 0,' +
		'    "displayLocationInDecimal" : false,' +
		'    "encrypted" : false,' +
		'    "externalId" : false,' +
		'    "extraTypeInfo" : null,' +
		'    "filterable" : true,' +
		'    "filteredLookupInfo" : null,' +
		'    "groupable" : false,' +
		'    "highScaleNumber" : false,' +
		'    "htmlFormatted" : false,' +
		'    "idLookup" : false,' +
		'    "inlineHelpText" : null,' +
		'    "label" : "Last Run",' +
		'    "length" : 0,' +
		'    "mask" : null,' +
		'    "maskType" : null,' +
		'    "name" : "Last_Run__c",' +
		'    "nameField" : false,' +
		'    "namePointing" : false,' +
		'    "nillable" : true,' +
		'    "permissionable" : true,' +
		'    "picklistValues" : [ ],' +
		'    "precision" : 0,' +
		'    "queryByDistance" : false,' +
		'    "referenceTargetField" : null,' +
		'    "referenceTo" : [ ],' +
		'    "relationshipName" : null,' +
		'    "relationshipOrder" : null,' +
		'    "restrictedDelete" : false,' +
		'    "restrictedPicklist" : false,' +
		'    "scale" : 0,' +
		'    "soapType" : "xsd:dateTime",' +
		'    "sortable" : true,' +
		'    "type" : "datetime",' +
		'    "unique" : false,' +
		'    "updateable" : true,' +
		'    "writeRequiresMasterRead" : false' +
		'  } ],' +
		'    "precision" : 0,' +
		'    "queryByDistance" : false,' +
		'    "referenceTargetField" : null,' +
		'    "referenceTo" : [ ],' +
		'    "relationshipName" : null,' +
		'    "relationshipOrder" : null,' +
		'    "restrictedDelete" : false,' +
		'    "restrictedPicklist" : false,' +
		'    "scale" : 0,' +
		'    "soapType" : "xsd:string",' +
		'    "sortable" : true,' +
		'    "type" : "picklist",' +
		'    "unique" : false,' +
		'    "updateable" : true,' +
		'    "writeRequiresMasterRead" : false' +
		'  } ],' +
		'  "keyPrefix" : "a0C",' +
		'  "label" : "Data Extract",' +
		'  "labelPlural" : "Data Extracts",' +
		'  "layoutable" : true,' +
		'  "listviewable" : null,' +
		'  "lookupLayoutable" : null,' +
		'  "mergeable" : false,' +
		'  "name" : "Data_Extract__c",' +
		'  "namedLayoutInfos" : [ ],' +
		'  "queryable" : true,' +
		'  "recordTypeInfos" : [ {' +
		'    "available" : true,' +
		'    "defaultRecordTypeMapping" : true,' +
		'    "name" : "Master",' +
		'    "recordTypeId" : "012000000000000AAA",' +
		'    "urls" : {' +
		'      "layout" : "/services/data/v34.0/sobjects/Data_Extract__c/describe/layouts/012000000000000AAA"' +
		'    }' +
		'  } ],' +
		'  "replicateable" : true,' +
		'  "retrieveable" : true,' +
		'  "searchLayoutable" : true,' +
		'  "searchable" : true,' +
		'  "triggerable" : true,' +
		'  "undeletable" : true,' +
		'  "updateable" : true,' +
		'  "urls" : {' +
		'    "compactLayouts" : "/services/data/v34.0/sobjects/Data_Extract__c/describe/compactLayouts",' +
		'    "rowTemplate" : "/services/data/v34.0/sobjects/Data_Extract__c/{ID}",' +
		'    "approvalLayouts" : "/services/data/v34.0/sobjects/Data_Extract__c/describe/approvalLayouts",' +
		'    "uiDetailTemplate" : "https://gs0.salesforce.com/{ID}",' +
		'    "uiEditTemplate" : "https://gs0.salesforce.com/{ID}/e",' +
		'    "describe" : "/services/data/v34.0/sobjects/Data_Extract__c/describe",' +
		'    "uiNewRecord" : "https://gs0.salesforce.com/a0C/e",' +
		'    "quickActions" : "/services/data/v34.0/sobjects/Data_Extract__c/quickActions",' +
		'    "layouts" : "/services/data/v34.0/sobjects/Data_Extract__c/describe/layouts",' +
		'    "sobject" : "/services/data/v34.0/sobjects/Data_Extract__c"' +
		'  }' +
		'}';	
		
    }
    
    //=========================================================================================//
    //Create Report JSON For Testing 
    //=========================================================================================//
    public static String getReportJSON() {

		return '{' +
				'"attributes" : {' +
				'  "describeUrl" : "/services/data/v34.0/analytics/reports/00OB0000000sQyoMAE/describe",' +
				'  "instancesUrl" : "/services/data/v34.0/analytics/reports/00OB0000000sQyoMAE/instances",' +
				'  "reportId" : "00OB0000000sQyoMAE",' +
				'  "reportName" : "Test Data Extract Report",' +
				'  "type" : "Report"' +
				'},' +
				'"allData" : true,' +
				'"factMap" : {' +
				'  "T!T" : {' +
				'    "aggregates" : [ ],' +
				'    "rows" : [ {' +
				'      "dataCells" : [ {' +
				'        "label" : 15,' +
				'        "value" : 15' +
				'      }, {' +
				'        "label" : "a0CB0000001PAh9",' +
				'        "value" : "a0CB0000001PAh9MAG"' +
				'      }, {' +
				'        "label" : "false",' +
				'        "value" : false' +
				'      }, {' +
				'        "label" : "-",' +
				'        "value" : null' +
				'      }, {' +
				'        "label" : "-",' +
				'        "value" : null' +
				'      }, {' +
				'        "label" : "-",' +
				'        "value" : null' +
				'      }, {' +
				'        "label" : "-",' +
				'        "value" : null' +
				'      }, {' +
				'        "label" : "-",' +
				'        "value" : null' +
				'      }, {' +
				'        "label" : "-",' +
				'        "value" : null' +
				'      }, {' +
				'        "label" : "-",' +
				'        "value" : null' +
				'      }, {' +
				'        "label" : "-",' +
				'        "value" : null' +
				'      }, {' +
				'        "label" : "-",' +
				'        "value" : null' +
				'      }, {' +
				'        "label" : "-",' +
				'        "value" : null' +
				'      }, {' +
				'        "label" : "-",' +
				'        "value" : null' +
				'      }, {' +
				'        "label" : "-",' +
				'        "value" : null' +
				'      }, {' +
				'        "label" : "SOQL",' +
				'        "value" : "SOQL"' +
				'      }, {' +
				'        "label" : "Harshit Jain",' +
				'        "value" : "005B0000001LJngIAG"' +
				'      }, {' +
				'        "label" : "hj",' +
				'        "value" : "005B0000001LJngIAG"' +
				'      }, {' +
				'        "label" : "-",' +
				'        "value" : null' +
				'      }, {' +
				'        "label" : "Harshit Jain",' +
				'        "value" : "005B0000001LJngIAG"' +
				'      }, {' +
				'        "label" : "hj",' +
				'        "value" : "005B0000001LJngIAG"' +
				'      }, {' +
				'        "label" : "8/12/2015",' +
				'        "value" : "2015-08-12"' +
				'      }, {' +
				'        "label" : "Harshit Jain",' +
				'        "value" : "005B0000001LJngIAG"' +
				'      }, {' +
				'        "label" : "hj",' +
				'        "value" : "005B0000001LJngIAG"' +
				'      }, {' +
				'        "label" : "8/12/2015",' +
				'        "value" : "2015-08-12"' +
				'      } ]' +
				'    }]' +
				'  }' +
				'},' +
				'"groupingsAcross" : {' +
				'  "groupings" : [ ]' +
				'},' +
				'"groupingsDown" : {' +
				'  "groupings" : [ ]' +
				'},' +
				'"hasDetailRows" : true,' +
				'"reportExtendedMetadata" : {' +
				'  "aggregateColumnInfo" : { },' +
				'  "detailColumnInfo" : {' +
				'    "CUST_NAME" : {' +
				'      "dataType" : "Double",' +
				'      "label" : "Data Extract: Extract Name"' +
				'    },' +
				'    "CUST_ID" : {' +
				'      "dataType" : "id",' +
				'      "label" : "Data Extract: ID"' +
				'    },' +
				'    "Data_Extract__c.Active__c" : {' +
				'      "dataType" : "boolean",' +
				'      "label" : "Active"' +
				'    },' +
				'    "Data_Extract__c.Apex_Job_Id__c" : {' +
				'      "dataType" : "string",' +
				'      "label" : "Apex Job Id"' +
				'    },' +
				'    "Data_Extract__c.Batch_Job_Id__c" : {' +
				'      "dataType" : "string",' +
				'      "label" : "Batch Job Id"' +
				'    },' +
				'    "Data_Extract__c.Dataset_Name__c" : {' +
				'      "dataType" : "string",' +
				'      "label" : "Dataset Name"' +
				'    },' +
				'    "Data_Extract__c.Day_Date_Selector__c" : {' +
				'      "dataType" : "picklist",' +
				'      "label" : "Day/Date Selector"' +
				'    },' +
				'    "Data_Extract__c.Last_Run__c" : {' +
				'      "dataType" : "datetime",' +
				'      "label" : "Last Run"' +
				'    },' +
				'    "Data_Extract__c.Metadata__c" : {' +
				'      "dataType" : "textarea",' +
				'      "label" : "Metadata"' +
				'    },' +
				'    "Data_Extract__c.Operation__c" : {' +
				'      "dataType" : "picklist",' +
				'      "label" : "Operation"' +
				'    },' +
				'    "Data_Extract__c.Report_Id__c" : {' +
				'      "dataType" : "string",' +
				'      "label" : "Report Id"' +
				'    },' +
				'    "Data_Extract__c.Report_Name__c" : {' +
				'      "dataType" : "string",' +
				'      "label" : "Report Name"' +
				'    },' +
				'    "Data_Extract__c.Schedule__c" : {' +
				'      "dataType" : "picklist",' +
				'      "label" : "Schedule"' +
				'    },' +
				'    "Data_Extract__c.SOQL_Query__c" : {' +
				'      "dataType" : "textarea",' +
				'      "label" : "SOQL Query"' +
				'    },' +
				'    "Data_Extract__c.Time_Interval__c" : {' +
				'      "dataType" : "picklist",' +
				'      "label" : "Time Interval"' +
				'    },' +
				'    "Data_Extract__c.Type__c" : {' +
				'      "dataType" : "picklist",' +
				'      "label" : "Type"' +
				'    },' +
				'    "CUST_OWNER_NAME" : {' +
				'      "dataType" : "string",' +
				'      "label" : "Data Extract: Owner Name"' +
				'    },' +
				'    "CUST_OWNER_ALIAS" : {' +
				'      "dataType" : "string",' +
				'      "label" : "Data Extract: Owner Alias"' +
				'    },' +
				'    "CUST_OWNER_ROLE" : {' +
				'      "dataType" : "string",' +
				'      "label" : "Data Extract: Owner Role"' +
				'    },' +
				'    "CUST_CREATED_NAME" : {' +
				'      "dataType" : "string",' +
				'      "label" : "Data Extract: Created By"' +
				'    },' +
				'    "CUST_CREATED_ALIAS" : {' +
				'      "dataType" : "string",' +
				'      "label" : "Data Extract: Created Alias"' +
				'    },' +
				'    "CUST_CREATED_DATE" : {' +
				'      "dataType" : "datetime",' +
				'      "label" : "Data Extract: Created Date"' +
				'    },' +
				'    "CUST_LAST_UPDATE_NAME" : {' +
				'      "dataType" : "string",' +
				'      "label" : "Data Extract: Last Modified By"' +
				'    },' +
				'    "CUST_LAST_UPDATE_ALIAS" : {' +
				'      "dataType" : "string",' +
				'      "label" : "Data Extract: Last Modified Alias"' +
				'    },' +
				'    "CUST_LAST_UPDATE" : {' +
				'      "dataType" : "datetime",' +
				'      "label" : "Data Extract: Last Modified Date"' +
				'    }' +
				'  },' +
				'  "groupingColumnInfo" : { }' +
				'},' +
				'"reportMetadata" : {' +
				'  "aggregates" : [ ],' +
				'  "currency" : null,' +
				'  "detailColumns" : [ "CUST_NAME", "CUST_ID", "Data_Extract__c.Active__c", "Data_Extract__c.Apex_Job_Id__c", "Data_Extract__c.Batch_Job_Id__c", "Data_Extract__c.Dataset_Name__c", "Data_Extract__c.Day_Date_Selector__c", "Data_Extract__c.Last_Run__c", "Data_Extract__c.Metadata__c", "Data_Extract__c.Operation__c", "Data_Extract__c.Report_Id__c", "Data_Extract__c.Report_Name__c", "Data_Extract__c.Schedule__c", "Data_Extract__c.SOQL_Query__c", "Data_Extract__c.Time_Interval__c", "Data_Extract__c.Type__c", "CUST_OWNER_NAME", "CUST_OWNER_ALIAS", "CUST_OWNER_ROLE", "CUST_CREATED_NAME", "CUST_CREATED_ALIAS", "CUST_CREATED_DATE", "CUST_LAST_UPDATE_NAME", "CUST_LAST_UPDATE_ALIAS", "CUST_LAST_UPDATE" ],' +
				'  "developerName" : "Test_Data_Extract_Report",' +
				'  "division" : null,' +
				'  "folderId" : "005B0000001LJngIAG",' +
				'  "groupingsAcross" : [ ],' +
				'  "groupingsDown" : [ ],' +
				'  "hasDetailRows" : true,' +
				'  "hasRecordCount" : false,' +
				'  "historicalSnapshotDates" : [ ],' +
				'  "id" : "00OB0000000sQyoMAE",' +
				'  "name" : "Test Data Extract Report",' +
				'  "reportBooleanFilter" : null,' +
				'  "reportFilters" : [ ],' +
				'  "reportFormat" : "TABULAR",' +
				'  "reportType" : {' +
				'    "label" : "Custom Object",' +
				'    "type" : "CustomEntity$Data_Extract__c"' +
				'  },' +
				'  "scope" : "user",' +
				'  "sortBy" : [ ],' +
				'  "standardDateFilter" : {' +
				'    "column" : "Data_Extract__c.Last_Run__c",' +
				'    "durationValue" : "CUSTOM",' +
				'    "endDate" : null,' +
				'    "startDate" : null' +
				'  },' +
				'  "standardFilters" : null' +
				'}' +
				'}';
		
    }
    
    //=========================================================================================//
    //Create Dummy Metadata JSON For Testing 
    //=========================================================================================//
    public static String getDummyMedataJSON(){
    	
    	return '{' +
				'   "fileFormat": {' +
				'   	"charsetName": "UTF-8",' +
				'   	"fieldsDelimitedBy": ",",' +
				'   	"fieldsEnclosedBy": "\\"",' +
				'   	"linesTerminatedBy": "\\n",' +
				'   	"numberOfLinesToIgnore": 1' +
				'   },' +
				'   "objects": [' +
				'   	{' +
				'   		"name": "data_extract__c",' +
				'   		"fullyQualifiedName": "data_extract__c",' +
				'   		"connector": "ScheduledConnector",' +
				'   		"label": "Data Extract",' +
				'   		"description": "",' +
				'   		"fields": [' +
				'   			{' +
				'   				"type": "Text",' +
				'   				"name": "Id",' +
				'   				"label": "Record ID",' +
				'   				"isUniqueId": true,' +
				'   				"isSystemField": true,' +
				'   				"isMultiValue": false,' +
				'   				"fullyQualifiedName": "data_extract__c.Id",' +
				'   				"description": "",' +
				'   				"defaultValue": ""' +
				'   			},' +
				'   			{' +
				'   				"type": "Date",' +
				'   				"name": "Last_Run__c",' +
				'   				"label": "Last Run",' +
				'   				"isUniqueId": false,' +
				'   				"isSystemField": false,' +
				'   				"fullyQualifiedName": "data_extract__c.Last_Run__c",' +
				'   				"format": "MM/dd/yyyy",' +
				'   				"fiscalMonthOffset": 0,' +
				'   				"description": ""' +
				'   			},' +
				'   			{' +
				'   				"type": "Text",' +
				'   				"name": "Type__c",' +
				'   				"label": "Type",' +
				'   				"isUniqueId": false,' +
				'   				"isSystemField": false,' +
				'   				"isMultiValue": false,' +
				'   				"fullyQualifiedName": "data_extract__c.Type__c",' +
				'   				"description": "",' +
				'   				"defaultValue": ""' +
				'   			}' +
				'   		]' +
				'   	}' +
				'   ]' +
				'}';
		
    }
    
    //=========================================================================================//
    //Create Dummy Metadata JSON For JSON oData Testing 
    //=========================================================================================//
    public static String getDummyJSONoDataMedataJSON(){
    	
    	return '{' +
				'  \"fileFormat\": {' +
				'  	\"charsetName\": \"UTF-8\",' +
				'  	\"fieldsDelimitedBy\": \",\",' +
				'  	\"fieldsEnclosedBy\": \"\\\"\",' +
				'  	\"linesTerminatedBy\": \"\\n\",' +
				'  	\"numberOfLinesToIgnore\": 1' +
				'  },' +
				'  \"objects\": [' +
				'  	{' +
				'  		\"name\": \"Invoices\",' +
				'  		\"fullyQualifiedName\": \"Invoices\",' +
				'  		\"connector\": \"ScheduledConnector\",' +
				'  		\"label\": \"Invoices\",' +
				'  		\"description\": \"\",' +
				'  		\"fields\": [' +
				'  			{' +
				'  				\"type\": \"Text\",' +
				'  				\"name\": \"ShipName\",' +
				'  				\"label\": \"ShipName\",' +
				'  				\"isUniqueId\": false,' +
				'  				\"isSystemField\": false,' +
				'  				\"isMultiValue\": false,' +
				'  				\"fullyQualifiedName\": \"Invoices.ShipName\",' +
				'  				\"description\": \"\",' +
				'  				\"defaultValue\": \"\"' +
				'  			},' +
				'  			{' +
				'  				\"type\": \"Text\",' +
				'  				\"name\": \"ShipAddress\",' +
				'  				\"label\": \"ShipAddress\",' +
				'  				\"isUniqueId\": false,' +
				'  				\"isSystemField\": false,' +
				'  				\"isMultiValue\": false,' +
				'  				\"fullyQualifiedName\": \"Invoices.ShipAddress\",' +
				'  				\"description\": \"\",' +
				'  				\"defaultValue\": \"\"' +
				'  			},' +
				'  			{' +
				'  				\"type\": \"Text\",' +
				'  				\"name\": \"ShipCity\",' +
				'  				\"label\": \"ShipCity\",' +
				'  				\"isUniqueId\": false,' +
				'  				\"isSystemField\": false,' +
				'  				\"isMultiValue\": false,' +
				'  				\"fullyQualifiedName\": \"Invoices.ShipCity\",' +
				'  				\"description\": \"\",' +
				'  				\"defaultValue\": \"\"' +
				'  			},' +
				'  			{' +
				'  				\"type\": \"Text\",' +
				'  				\"name\": \"ShipRegion\",' +
				'  				\"label\": \"ShipRegion\",' +
				'  				\"isUniqueId\": false,' +
				'  				\"isSystemField\": false,' +
				'  				\"isMultiValue\": false,' +
				'  				\"fullyQualifiedName\": \"Invoices.ShipRegion\",' +
				'  				\"description\": \"\",' +
				'  				\"defaultValue\": \"\"' +
				'  			},' +
				'  			{' +
				'  				\"type\": \"Text\",' +
				'  				\"name\": \"ShipPostalCode\",' +
				'  				\"label\": \"ShipPostalCode\",' +
				'  				\"isUniqueId\": false,' +
				'  				\"isSystemField\": false,' +
				'  				\"isMultiValue\": false,' +
				'  				\"fullyQualifiedName\": \"Invoices.ShipPostalCode\",' +
				'  				\"description\": \"\",' +
				'  				\"defaultValue\": \"\"' +
				'  			},' +
				'  			{' +
				'  				\"type\": \"Text\",' +
				'  				\"name\": \"ShipCountry\",' +
				'  				\"label\": \"ShipCountry\",' +
				'  				\"isUniqueId\": false,' +
				'  				\"isSystemField\": false,' +
				'  				\"isMultiValue\": false,' +
				'  				\"fullyQualifiedName\": \"Invoices.ShipCountry\",' +
				'  				\"description\": \"\",' +
				'  				\"defaultValue\": \"\"' +
				'  			},' +
				'  			{' +
				'  				\"type\": \"Text\",' +
				'  				\"name\": \"CustomerID\",' +
				'  				\"label\": \"CustomerID\",' +
				'  				\"isUniqueId\": false,' +
				'  				\"isSystemField\": false,' +
				'  				\"isMultiValue\": false,' +
				'  				\"fullyQualifiedName\": \"Invoices.CustomerID\",' +
				'  				\"description\": \"\",' +
				'  				\"defaultValue\": \"\"' +
				'  			},' +
				'  			{' +
				'  				\"type\": \"Text\",' +
				'  				\"name\": \"CustomerName\",' +
				'  				\"label\": \"CustomerName\",' +
				'  				\"isUniqueId\": false,' +
				'  				\"isSystemField\": false,' +
				'  				\"isMultiValue\": false,' +
				'  				\"fullyQualifiedName\": \"Invoices.CustomerName\",' +
				'  				\"description\": \"\",' +
				'  				\"defaultValue\": \"\"' +
				'  			},' +
				'  			{' +
				'  				\"type\": \"Text\",' +
				'  				\"name\": \"Address\",' +
				'  				\"label\": \"Address\",' +
				'  				\"isUniqueId\": false,' +
				'  				\"isSystemField\": false,' +
				'  				\"isMultiValue\": false,' +
				'  				\"fullyQualifiedName\": \"Invoices.Address\",' +
				'  				\"description\": \"\",' +
				'  				\"defaultValue\": \"\"' +
				'  			},' +
				'  			{' +
				'  				\"type\": \"Text\",' +
				'  				\"name\": \"City\",' +
				'  				\"label\": \"City\",' +
				'  				\"isUniqueId\": false,' +
				'  				\"isSystemField\": false,' +
				'  				\"isMultiValue\": false,' +
				'  				\"fullyQualifiedName\": \"Invoices.City\",' +
				'  				\"description\": \"\",' +
				'  				\"defaultValue\": \"\"' +
				'  			},' +
				'  			{' +
				'  				\"type\": \"Text\",' +
				'  				\"name\": \"Region\",' +
				'  				\"label\": \"Region\",' +
				'  				\"isUniqueId\": false,' +
				'  				\"isSystemField\": false,' +
				'  				\"isMultiValue\": false,' +
				'  				\"fullyQualifiedName\": \"Invoices.Region\",' +
				'  				\"description\": \"\",' +
				'  				\"defaultValue\": \"\"' +
				'  			},' +
				'  			{' +
				'  				\"type\": \"Text\",' +
				'  				\"name\": \"PostalCode\",' +
				'  				\"label\": \"PostalCode\",' +
				'  				\"isUniqueId\": false,' +
				'  				\"isSystemField\": false,' +
				'  				\"isMultiValue\": false,' +
				'  				\"fullyQualifiedName\": \"Invoices.PostalCode\",' +
				'  				\"description\": \"\",' +
				'  				\"defaultValue\": \"\"' +
				'  			},' +
				'  			{' +
				'  				\"type\": \"Text\",' +
				'  				\"name\": \"Country\",' +
				'  				\"label\": \"Country\",' +
				'  				\"isUniqueId\": false,' +
				'  				\"isSystemField\": false,' +
				'  				\"isMultiValue\": false,' +
				'  				\"fullyQualifiedName\": \"Invoices.Country\",' +
				'  				\"description\": \"\",' +
				'  				\"defaultValue\": \"\"' +
				'  			},' +
				'  			{' +
				'  				\"type\": \"Text\",' +
				'  				\"name\": \"Salesperson\",' +
				'  				\"label\": \"Salesperson\",' +
				'  				\"isUniqueId\": false,' +
				'  				\"isSystemField\": false,' +
				'  				\"isMultiValue\": false,' +
				'  				\"fullyQualifiedName\": \"Invoices.Salesperson\",' +
				'  				\"description\": \"\",' +
				'  				\"defaultValue\": \"\"' +
				'  			},' +
				'  			{' +
				'  				\"type\": \"Numeric\",' +
				'  				\"scale\": 2,' +
				'  				\"precision\": 18,' +
				'  				\"name\": \"OrderID\",' +
				'  				\"label\": \"OrderID\",' +
				'  				\"isUniqueId\": false,' +
				'  				\"isSystemField\": false,' +
				'  				\"fullyQualifiedName\": \"Invoices.OrderID\",' +
				'  				\"description\": \"\",' +
				'  				\"defaultValue\": \"0\"' +
				'  			},' +
				'  			{' +
				'  				\"type\": \"Date\",' +
				'  				\"name\": \"OrderDate\",' +
				'  				\"label\": \"OrderDate\",' +
				'  				\"isUniqueId\": false,' +
				'  				\"isSystemField\": false,' +
				'  				\"fullyQualifiedName\": \"Invoices.OrderDate\",' +
				'  				\"format\": \"MM/dd/yyyy\",' +
				'  				\"fiscalMonthOffset\": 0,' +
				'  				\"description\": \"\"' +
				'  			},' +
				'  			{' +
				'  				\"type\": \"Date\",' +
				'  				\"name\": \"RequiredDate\",' +
				'  				\"label\": \"RequiredDate\",' +
				'  				\"isUniqueId\": false,' +
				'  				\"isSystemField\": false,' +
				'  				\"fullyQualifiedName\": \"Invoices.RequiredDate\",' +
				'  				\"format\": \"MM/dd/yyyy\",' +
				'  				\"fiscalMonthOffset\": 0,' +
				'  				\"description\": \"\"' +
				'  			},' +
				'  			{' +
				'  				\"type\": \"Date\",' +
				'  				\"name\": \"ShippedDate\",' +
				'  				\"label\": \"ShippedDate\",' +
				'  				\"isUniqueId\": false,' +
				'  				\"isSystemField\": false,' +
				'  				\"fullyQualifiedName\": \"Invoices.ShippedDate\",' +
				'  				\"format\": \"MM/dd/yyyy\",' +
				'  				\"fiscalMonthOffset\": 0,' +
				'  				\"description\": \"\"' +
				'  			},' +
				'  			{' +
				'  				\"type\": \"Text\",' +
				'  				\"name\": \"ShipperName\",' +
				'  				\"label\": \"ShipperName\",' +
				'  				\"isUniqueId\": false,' +
				'  				\"isSystemField\": false,' +
				'  				\"isMultiValue\": false,' +
				'  				\"fullyQualifiedName\": \"Invoices.ShipperName\",' +
				'  				\"description\": \"\",' +
				'  				\"defaultValue\": \"\"' +
				'  			},' +
				'  			{' +
				'  				\"type\": \"Numeric\",' +
				'  				\"scale\": 2,' +
				'  				\"precision\": 18,' +
				'  				\"name\": \"ProductID\",' +
				'  				\"label\": \"ProductID\",' +
				'  				\"isUniqueId\": false,' +
				'  				\"isSystemField\": false,' +
				'  				\"fullyQualifiedName\": \"Invoices.ProductID\",' +
				'  				\"description\": \"\",' +
				'  				\"defaultValue\": \"0\"' +
				'  			},' +
				'  			{' +
				'  				\"type\": \"Text\",' +
				'  				\"name\": \"ProductName\",' +
				'  				\"label\": \"ProductName\",' +
				'  				\"isUniqueId\": false,' +
				'  				\"isSystemField\": false,' +
				'  				\"isMultiValue\": false,' +
				'  				\"fullyQualifiedName\": \"Invoices.ProductName\",' +
				'  				\"description\": \"\",' +
				'  				\"defaultValue\": \"\"' +
				'  			},' +
				'  			{' +
				'  				\"type\": \"Numeric\",' +
				'  				\"scale\": 2,' +
				'  				\"precision\": 18,' +
				'  				\"name\": \"UnitPrice\",' +
				'  				\"label\": \"UnitPrice\",' +
				'  				\"isUniqueId\": false,' +
				'  				\"isSystemField\": false,' +
				'  				\"fullyQualifiedName\": \"Invoices.UnitPrice\",' +
				'  				\"description\": \"\",' +
				'  				\"defaultValue\": \"0\"' +
				'  			},' +
				'  			{' +
				'  				\"type\": \"Numeric\",' +
				'  				\"scale\": 2,' +
				'  				\"precision\": 18,' +
				'  				\"name\": \"Quantity\",' +
				'  				\"label\": \"Quantity\",' +
				'  				\"isUniqueId\": false,' +
				'  				\"isSystemField\": false,' +
				'  				\"fullyQualifiedName\": \"Invoices.Quantity\",' +
				'  				\"description\": \"\",' +
				'  				\"defaultValue\": \"0\"' +
				'  			},' +
				'  			{' +
				'  				\"type\": \"Numeric\",' +
				'  				\"scale\": 2,' +
				'  				\"precision\": 18,' +
				'  				\"name\": \"Discount\",' +
				'  				\"label\": \"Discount\",' +
				'  				\"isUniqueId\": false,' +
				'  				\"isSystemField\": false,' +
				'  				\"fullyQualifiedName\": \"Invoices.Discount\",' +
				'  				\"description\": \"\",' +
				'  				\"defaultValue\": \"0\"' +
				'  			},' +
				'  			{' +
				'  				\"type\": \"Numeric\",' +
				'  				\"scale\": 2,' +
				'  				\"precision\": 18,' +
				'  				\"name\": \"ExtendedPrice\",' +
				'  				\"label\": \"ExtendedPrice\",' +
				'  				\"isUniqueId\": false,' +
				'  				\"isSystemField\": false,' +
				'  				\"fullyQualifiedName\": \"Invoices.ExtendedPrice\",' +
				'  				\"description\": \"\",' +
				'  				\"defaultValue\": \"0\"' +
				'  			},' +
				'  			{' +
				'  				\"type\": \"Numeric\",' +
				'  				\"scale\": 2,' +
				'  				\"precision\": 18,' +
				'  				\"name\": \"Freight\",' +
				'  				\"label\": \"Freight\",' +
				'  				\"isUniqueId\": false,' +
				'  				\"isSystemField\": false,' +
				'  				\"fullyQualifiedName\": \"Invoices.Freight\",' +
				'  				\"description\": \"\",' +
				'  				\"defaultValue\": \"0\"' +
				'  			}' +
				'  		]' +
				'  	}' +
				'  ]' +
				'}';
    }
    
    //=========================================================================================//
    //Create Dummy Metadata Details For JSON oData Testing 
    //=========================================================================================//
    public static String getDummyJSONoDataMedataDetails(){
    	
    	return' <edmx:Edmx xmlns:edmx=\"http://docs.oasis-open.org/odata/ns/edmx\" Version=\"4.0\">' +
				'<edmx:DataServices>' +
				'<Schema xmlns=\"http://docs.oasis-open.org/odata/ns/edm\" Namespace=\"NorthwindModel\">' +
				'<EntityType Name=\"Category\">' +
				'<Key>' +
				'<PropertyRef Name=\"CategoryID\"/>' +
				'</Key>' +
				'<Property xmlns:p5=\"http://schemas.microsoft.com/ado/2009/02/edm/annotation\" Name=\"CategoryID\" Type=\"Edm.Int32\" Nullable=\"false\" p5:StoreGeneratedPattern=\"Identity\"/>' +
				'<Property Name=\"CategoryName\" Type=\"Edm.String\" Nullable=\"false\" MaxLength=\"15\"/>' +
				'<Property Name=\"Description\" Type=\"Edm.String\" MaxLength=\"max\"/>' +
				'<Property Name=\"Picture\" Type=\"Edm.Binary\" MaxLength=\"max\"/>' +
				'<NavigationProperty Name=\"Products\" Type=\"Collection(NorthwindModel.Product)\" Partner=\"Category\"/>' +
				'</EntityType>' +
				'<EntityType Name=\"CustomerDemographic\">' +
				'<Key>' +
				'<PropertyRef Name=\"CustomerTypeID\"/>' +
				'</Key>' +
				'<Property Name=\"CustomerTypeID\" Type=\"Edm.String\" Nullable=\"false\" MaxLength=\"10\"/>' +
				'<Property Name=\"CustomerDesc\" Type=\"Edm.String\" MaxLength=\"max\"/>' +
				'<NavigationProperty Name=\"Customers\" Type=\"Collection(NorthwindModel.Customer)\" Partner=\"CustomerDemographics\"/>' +
				'</EntityType>' +
				'<EntityType Name=\"Customer\">' +
				'<Key>' +
				'<PropertyRef Name=\"CustomerID\"/>' +
				'</Key>' +
				'<Property Name=\"CustomerID\" Type=\"Edm.String\" Nullable=\"false\" MaxLength=\"5\"/>' +
				'<Property Name=\"CompanyName\" Type=\"Edm.String\" Nullable=\"false\" MaxLength=\"40\"/>' +
				'<Property Name=\"ContactName\" Type=\"Edm.String\" MaxLength=\"30\"/>' +
				'<Property Name=\"ContactTitle\" Type=\"Edm.String\" MaxLength=\"30\"/>' +
				'<Property Name=\"Address\" Type=\"Edm.String\" MaxLength=\"60\"/>' +
				'<Property Name=\"City\" Type=\"Edm.String\" MaxLength=\"15\"/>' +
				'<Property Name=\"Region\" Type=\"Edm.String\" MaxLength=\"15\"/>' +
				'<Property Name=\"PostalCode\" Type=\"Edm.String\" MaxLength=\"10\"/>' +
				'<Property Name=\"Country\" Type=\"Edm.String\" MaxLength=\"15\"/>' +
				'<Property Name=\"Phone\" Type=\"Edm.String\" MaxLength=\"24\"/>' +
				'<Property Name=\"Fax\" Type=\"Edm.String\" MaxLength=\"24\"/>' +
				'<NavigationProperty Name=\"Orders\" Type=\"Collection(NorthwindModel.Order)\" Partner=\"Customer\"/>' +
				'<NavigationProperty Name=\"CustomerDemographics\" Type=\"Collection(NorthwindModel.CustomerDemographic)\" Partner=\"Customers\"/>' +
				'</EntityType>' +
				'<EntityType Name=\"Employee\">' +
				'<Key>' +
				'<PropertyRef Name=\"EmployeeID\"/>' +
				'</Key>' +
				'<Property xmlns:p5=\"http://schemas.microsoft.com/ado/2009/02/edm/annotation\" Name=\"EmployeeID\" Type=\"Edm.Int32\" Nullable=\"false\" p5:StoreGeneratedPattern=\"Identity\"/>' +
				'<Property Name=\"LastName\" Type=\"Edm.String\" Nullable=\"false\" MaxLength=\"20\"/>' +
				'<Property Name=\"FirstName\" Type=\"Edm.String\" Nullable=\"false\" MaxLength=\"10\"/>' +
				'<Property Name=\"Title\" Type=\"Edm.String\" MaxLength=\"30\"/>' +
				'<Property Name=\"TitleOfCourtesy\" Type=\"Edm.String\" MaxLength=\"25\"/>' +
				'<Property Name=\"BirthDate\" Type=\"Edm.DateTimeOffset\"/>' +
				'<Property Name=\"HireDate\" Type=\"Edm.DateTimeOffset\"/>' +
				'<Property Name=\"Address\" Type=\"Edm.String\" MaxLength=\"60\"/>' +
				'<Property Name=\"City\" Type=\"Edm.String\" MaxLength=\"15\"/>' +
				'<Property Name=\"Region\" Type=\"Edm.String\" MaxLength=\"15\"/>' +
				'<Property Name=\"PostalCode\" Type=\"Edm.String\" MaxLength=\"10\"/>' +
				'<Property Name=\"Country\" Type=\"Edm.String\" MaxLength=\"15\"/>' +
				'<Property Name=\"HomePhone\" Type=\"Edm.String\" MaxLength=\"24\"/>' +
				'<Property Name=\"Extension\" Type=\"Edm.String\" MaxLength=\"4\"/>' +
				'<Property Name=\"Photo\" Type=\"Edm.Binary\" MaxLength=\"max\"/>' +
				'<Property Name=\"Notes\" Type=\"Edm.String\" MaxLength=\"max\"/>' +
				'<Property Name=\"ReportsTo\" Type=\"Edm.Int32\"/>' +
				'<Property Name=\"PhotoPath\" Type=\"Edm.String\" MaxLength=\"255\"/>' +
				'<NavigationProperty Name=\"Employees1\" Type=\"Collection(NorthwindModel.Employee)\" Partner=\"Employee1\"/>' +
				'<NavigationProperty Name=\"Employee1\" Type=\"NorthwindModel.Employee\" Partner=\"Employees1\">' +
				'<ReferentialConstraint Property=\"ReportsTo\" ReferencedProperty=\"EmployeeID\"/>' +
				'</NavigationProperty>' +
				'<NavigationProperty Name=\"Orders\" Type=\"Collection(NorthwindModel.Order)\" Partner=\"Employee\"/>' +
				'<NavigationProperty Name=\"Territories\" Type=\"Collection(NorthwindModel.Territory)\" Partner=\"Employees\"/>' +
				'</EntityType>' +
				'<EntityType Name=\"Order_Detail\">' +
				'<Key>' +
				'<PropertyRef Name=\"OrderID\"/>' +
				'<PropertyRef Name=\"ProductID\"/>' +
				'</Key>' +
				'<Property Name=\"OrderID\" Type=\"Edm.Int32\" Nullable=\"false\"/>' +
				'<Property Name=\"ProductID\" Type=\"Edm.Int32\" Nullable=\"false\"/>' +
				'<Property Name=\"UnitPrice\" Type=\"Edm.Decimal\" Nullable=\"false\" Precision=\"19\" Scale=\"4\"/>' +
				'<Property Name=\"Quantity\" Type=\"Edm.Int16\" Nullable=\"false\"/>' +
				'<Property Name=\"Discount\" Type=\"Edm.Single\" Nullable=\"false\"/>' +
				'<NavigationProperty Name=\"Order\" Type=\"NorthwindModel.Order\" Nullable=\"false\" Partner=\"Order_Details\">' +
				'<ReferentialConstraint Property=\"OrderID\" ReferencedProperty=\"OrderID\"/>' +
				'</NavigationProperty>' +
				'<NavigationProperty Name=\"Product\" Type=\"NorthwindModel.Product\" Nullable=\"false\" Partner=\"Order_Details\">' +
				'<ReferentialConstraint Property=\"ProductID\" ReferencedProperty=\"ProductID\"/>' +
				'</NavigationProperty>' +
				'</EntityType>' +
				'<EntityType Name=\"Order\">' +
				'<Key>' +
				'<PropertyRef Name=\"OrderID\"/>' +
				'</Key>' +
				'<Property xmlns:p5=\"http://schemas.microsoft.com/ado/2009/02/edm/annotation\" Name=\"OrderID\" Type=\"Edm.Int32\" Nullable=\"false\" p5:StoreGeneratedPattern=\"Identity\"/>' +
				'<Property Name=\"CustomerID\" Type=\"Edm.String\" MaxLength=\"5\"/>' +
				'<Property Name=\"EmployeeID\" Type=\"Edm.Int32\"/>' +
				'<Property Name=\"OrderDate\" Type=\"Edm.DateTimeOffset\"/>' +
				'<Property Name=\"RequiredDate\" Type=\"Edm.DateTimeOffset\"/>' +
				'<Property Name=\"ShippedDate\" Type=\"Edm.DateTimeOffset\"/>' +
				'<Property Name=\"ShipVia\" Type=\"Edm.Int32\"/>' +
				'<Property Name=\"Freight\" Type=\"Edm.Decimal\" Precision=\"19\" Scale=\"4\"/>' +
				'<Property Name=\"ShipName\" Type=\"Edm.String\" MaxLength=\"40\"/>' +
				'<Property Name=\"ShipAddress\" Type=\"Edm.String\" MaxLength=\"60\"/>' +
				'<Property Name=\"ShipCity\" Type=\"Edm.String\" MaxLength=\"15\"/>' +
				'<Property Name=\"ShipRegion\" Type=\"Edm.String\" MaxLength=\"15\"/>' +
				'<Property Name=\"ShipPostalCode\" Type=\"Edm.String\" MaxLength=\"10\"/>' +
				'<Property Name=\"ShipCountry\" Type=\"Edm.String\" MaxLength=\"15\"/>' +
				'<NavigationProperty Name=\"Customer\" Type=\"NorthwindModel.Customer\" Partner=\"Orders\">' +
				'<ReferentialConstraint Property=\"CustomerID\" ReferencedProperty=\"CustomerID\"/>' +
				'</NavigationProperty>' +
				'<NavigationProperty Name=\"Employee\" Type=\"NorthwindModel.Employee\" Partner=\"Orders\">' +
				'<ReferentialConstraint Property=\"EmployeeID\" ReferencedProperty=\"EmployeeID\"/>' +
				'</NavigationProperty>' +
				'<NavigationProperty Name=\"Order_Details\" Type=\"Collection(NorthwindModel.Order_Detail)\" Partner=\"Order\"/>' +
				'<NavigationProperty Name=\"Shipper\" Type=\"NorthwindModel.Shipper\" Partner=\"Orders\">' +
				'<ReferentialConstraint Property=\"ShipVia\" ReferencedProperty=\"ShipperID\"/>' +
				'</NavigationProperty>' +
				'</EntityType>' +
				'<EntityType Name=\"Product\">' +
				'<Key>' +
				'<PropertyRef Name=\"ProductID\"/>' +
				'</Key>' +
				'<Property xmlns:p5=\"http://schemas.microsoft.com/ado/2009/02/edm/annotation\" Name=\"ProductID\" Type=\"Edm.Int32\" Nullable=\"false\" p5:StoreGeneratedPattern=\"Identity\"/>' +
				'<Property Name=\"ProductName\" Type=\"Edm.String\" Nullable=\"false\" MaxLength=\"40\"/>' +
				'<Property Name=\"SupplierID\" Type=\"Edm.Int32\"/>' +
				'<Property Name=\"CategoryID\" Type=\"Edm.Int32\"/>' +
				'<Property Name=\"QuantityPerUnit\" Type=\"Edm.String\" MaxLength=\"20\"/>' +
				'<Property Name=\"UnitPrice\" Type=\"Edm.Decimal\" Precision=\"19\" Scale=\"4\"/>' +
				'<Property Name=\"UnitsInStock\" Type=\"Edm.Int16\"/>' +
				'<Property Name=\"UnitsOnOrder\" Type=\"Edm.Int16\"/>' +
				'<Property Name=\"ReorderLevel\" Type=\"Edm.Int16\"/>' +
				'<Property Name=\"Discontinued\" Type=\"Edm.Boolean\" Nullable=\"false\"/>' +
				'<NavigationProperty Name=\"Category\" Type=\"NorthwindModel.Category\" Partner=\"Products\">' +
				'<ReferentialConstraint Property=\"CategoryID\" ReferencedProperty=\"CategoryID\"/>' +
				'</NavigationProperty>' +
				'<NavigationProperty Name=\"Order_Details\" Type=\"Collection(NorthwindModel.Order_Detail)\" Partner=\"Product\"/>' +
				'<NavigationProperty Name=\"Supplier\" Type=\"NorthwindModel.Supplier\" Partner=\"Products\">' +
				'<ReferentialConstraint Property=\"SupplierID\" ReferencedProperty=\"SupplierID\"/>' +
				'</NavigationProperty>' +
				'</EntityType>' +
				'<EntityType Name=\"Region\">' +
				'<Key>' +
				'<PropertyRef Name=\"RegionID\"/>' +
				'</Key>' +
				'<Property Name=\"RegionID\" Type=\"Edm.Int32\" Nullable=\"false\"/>' +
				'<Property Name=\"RegionDescription\" Type=\"Edm.String\" Nullable=\"false\" MaxLength=\"50\"/>' +
				'<NavigationProperty Name=\"Territories\" Type=\"Collection(NorthwindModel.Territory)\" Partner=\"Region\"/>' +
				'</EntityType>' +
				'<EntityType Name=\"Shipper\">' +
				'<Key>' +
				'<PropertyRef Name=\"ShipperID\"/>' +
				'</Key>' +
				'<Property xmlns:p5=\"http://schemas.microsoft.com/ado/2009/02/edm/annotation\" Name=\"ShipperID\" Type=\"Edm.Int32\" Nullable=\"false\" p5:StoreGeneratedPattern=\"Identity\"/>' +
				'<Property Name=\"CompanyName\" Type=\"Edm.String\" Nullable=\"false\" MaxLength=\"40\"/>' +
				'<Property Name=\"Phone\" Type=\"Edm.String\" MaxLength=\"24\"/>' +
				'<NavigationProperty Name=\"Orders\" Type=\"Collection(NorthwindModel.Order)\" Partner=\"Shipper\"/>' +
				'</EntityType>' +
				'<EntityType Name=\"Supplier\">' +
				'<Key>' +
				'<PropertyRef Name=\"SupplierID\"/>' +
				'</Key>' +
				'<Property xmlns:p5=\"http://schemas.microsoft.com/ado/2009/02/edm/annotation\" Name=\"SupplierID\" Type=\"Edm.Int32\" Nullable=\"false\" p5:StoreGeneratedPattern=\"Identity\"/>' +
				'<Property Name=\"CompanyName\" Type=\"Edm.String\" Nullable=\"false\" MaxLength=\"40\"/>' +
				'<Property Name=\"ContactName\" Type=\"Edm.String\" MaxLength=\"30\"/>' +
				'<Property Name=\"ContactTitle\" Type=\"Edm.String\" MaxLength=\"30\"/>' +
				'<Property Name=\"Address\" Type=\"Edm.String\" MaxLength=\"60\"/>' +
				'<Property Name=\"City\" Type=\"Edm.String\" MaxLength=\"15\"/>' +
				'<Property Name=\"Region\" Type=\"Edm.String\" MaxLength=\"15\"/>' +
				'<Property Name=\"PostalCode\" Type=\"Edm.String\" MaxLength=\"10\"/>' +
				'<Property Name=\"Country\" Type=\"Edm.String\" MaxLength=\"15\"/>' +
				'<Property Name=\"Phone\" Type=\"Edm.String\" MaxLength=\"24\"/>' +
				'<Property Name=\"Fax\" Type=\"Edm.String\" MaxLength=\"24\"/>' +
				'<Property Name=\"HomePage\" Type=\"Edm.String\" MaxLength=\"max\"/>' +
				'<NavigationProperty Name=\"Products\" Type=\"Collection(NorthwindModel.Product)\" Partner=\"Supplier\"/>' +
				'</EntityType>' +
				'<EntityType Name=\"Territory\">' +
				'<Key>' +
				'<PropertyRef Name=\"TerritoryID\"/>' +
				'</Key>' +
				'<Property Name=\"TerritoryID\" Type=\"Edm.String\" Nullable=\"false\" MaxLength=\"20\"/>' +
				'<Property Name=\"TerritoryDescription\" Type=\"Edm.String\" Nullable=\"false\" MaxLength=\"50\"/>' +
				'<Property Name=\"RegionID\" Type=\"Edm.Int32\" Nullable=\"false\"/>' +
				'<NavigationProperty Name=\"Region\" Type=\"NorthwindModel.Region\" Nullable=\"false\" Partner=\"Territories\">' +
				'<ReferentialConstraint Property=\"RegionID\" ReferencedProperty=\"RegionID\"/>' +
				'</NavigationProperty>' +
				'<NavigationProperty Name=\"Employees\" Type=\"Collection(NorthwindModel.Employee)\" Partner=\"Territories\"/>' +
				'</EntityType>' +
				'<EntityType Name=\"Alphabetical_list_of_product\">' +
				'<Key>' +
				'<PropertyRef Name=\"CategoryName\"/>' +
				'<PropertyRef Name=\"Discontinued\"/>' +
				'<PropertyRef Name=\"ProductID\"/>' +
				'<PropertyRef Name=\"ProductName\"/>' +
				'</Key>' +
				'<Property Name=\"ProductID\" Type=\"Edm.Int32\" Nullable=\"false\"/>' +
				'<Property Name=\"ProductName\" Type=\"Edm.String\" Nullable=\"false\" MaxLength=\"40\"/>' +
				'<Property Name=\"SupplierID\" Type=\"Edm.Int32\"/>' +
				'<Property Name=\"CategoryID\" Type=\"Edm.Int32\"/>' +
				'<Property Name=\"QuantityPerUnit\" Type=\"Edm.String\" MaxLength=\"20\"/>' +
				'<Property Name=\"UnitPrice\" Type=\"Edm.Decimal\" Precision=\"19\" Scale=\"4\"/>' +
				'<Property Name=\"UnitsInStock\" Type=\"Edm.Int16\"/>' +
				'<Property Name=\"UnitsOnOrder\" Type=\"Edm.Int16\"/>' +
				'<Property Name=\"ReorderLevel\" Type=\"Edm.Int16\"/>' +
				'<Property Name=\"Discontinued\" Type=\"Edm.Boolean\" Nullable=\"false\"/>' +
				'<Property Name=\"CategoryName\" Type=\"Edm.String\" Nullable=\"false\" MaxLength=\"15\"/>' +
				'</EntityType>' +
				'<EntityType Name=\"Category_Sales_for_1997\">' +
				'<Key>' +
				'<PropertyRef Name=\"CategoryName\"/>' +
				'</Key>' +
				'<Property Name=\"CategoryName\" Type=\"Edm.String\" Nullable=\"false\" MaxLength=\"15\"/>' +
				'<Property Name=\"CategorySales\" Type=\"Edm.Decimal\" Precision=\"19\" Scale=\"4\"/>' +
				'</EntityType>' +
				'<EntityType Name=\"Current_Product_List\">' +
				'<Key>' +
				'<PropertyRef Name=\"ProductID\"/>' +
				'<PropertyRef Name=\"ProductName\"/>' +
				'</Key>' +
				'<Property xmlns:p5=\"http://schemas.microsoft.com/ado/2009/02/edm/annotation\" Name=\"ProductID\" Type=\"Edm.Int32\" Nullable=\"false\" p5:StoreGeneratedPattern=\"Identity\"/>' +
				'<Property Name=\"ProductName\" Type=\"Edm.String\" Nullable=\"false\" MaxLength=\"40\"/>' +
				'</EntityType>' +
				'<EntityType Name=\"Customer_and_Suppliers_by_City\">' +
				'<Key>' +
				'<PropertyRef Name=\"CompanyName\"/>' +
				'<PropertyRef Name=\"Relationship\"/>' +
				'</Key>' +
				'<Property Name=\"City\" Type=\"Edm.String\" MaxLength=\"15\"/>' +
				'<Property Name=\"CompanyName\" Type=\"Edm.String\" Nullable=\"false\" MaxLength=\"40\"/>' +
				'<Property Name=\"ContactName\" Type=\"Edm.String\" MaxLength=\"30\"/>' +
				'<Property Name=\"Relationship\" Type=\"Edm.String\" Nullable=\"false\" MaxLength=\"9\" Unicode=\"false\"/>' +
				'</EntityType>' +
				'<EntityType Name=\"Invoice\">' +
				'<Key>' +
				'<PropertyRef Name=\"CustomerName\"/>' +
				'<PropertyRef Name=\"Discount\"/>' +
				'<PropertyRef Name=\"OrderID\"/>' +
				'<PropertyRef Name=\"ProductID\"/>' +
				'<PropertyRef Name=\"ProductName\"/>' +
				'<PropertyRef Name=\"Quantity\"/>' +
				'<PropertyRef Name=\"Salesperson\"/>' +
				'<PropertyRef Name=\"ShipperName\"/>' +
				'<PropertyRef Name=\"UnitPrice\"/>' +
				'</Key>' +
				'<Property Name=\"ShipName\" Type=\"Edm.String\" MaxLength=\"40\"/>' +
				'<Property Name=\"ShipAddress\" Type=\"Edm.String\" MaxLength=\"60\"/>' +
				'<Property Name=\"ShipCity\" Type=\"Edm.String\" MaxLength=\"15\"/>' +
				'<Property Name=\"ShipRegion\" Type=\"Edm.String\" MaxLength=\"15\"/>' +
				'<Property Name=\"ShipPostalCode\" Type=\"Edm.String\" MaxLength=\"10\"/>' +
				'<Property Name=\"ShipCountry\" Type=\"Edm.String\" MaxLength=\"15\"/>' +
				'<Property Name=\"CustomerID\" Type=\"Edm.String\" MaxLength=\"5\"/>' +
				'<Property Name=\"CustomerName\" Type=\"Edm.String\" Nullable=\"false\" MaxLength=\"40\"/>' +
				'<Property Name=\"Address\" Type=\"Edm.String\" MaxLength=\"60\"/>' +
				'<Property Name=\"City\" Type=\"Edm.String\" MaxLength=\"15\"/>' +
				'<Property Name=\"Region\" Type=\"Edm.String\" MaxLength=\"15\"/>' +
				'<Property Name=\"PostalCode\" Type=\"Edm.String\" MaxLength=\"10\"/>' +
				'<Property Name=\"Country\" Type=\"Edm.String\" MaxLength=\"15\"/>' +
				'<Property Name=\"Salesperson\" Type=\"Edm.String\" Nullable=\"false\" MaxLength=\"31\"/>' +
				'<Property Name=\"OrderID\" Type=\"Edm.Int32\" Nullable=\"false\"/>' +
				'<Property Name=\"OrderDate\" Type=\"Edm.DateTimeOffset\"/>' +
				'<Property Name=\"RequiredDate\" Type=\"Edm.DateTimeOffset\"/>' +
				'<Property Name=\"ShippedDate\" Type=\"Edm.DateTimeOffset\"/>' +
				'<Property Name=\"ShipperName\" Type=\"Edm.String\" Nullable=\"false\" MaxLength=\"40\"/>' +
				'<Property Name=\"ProductID\" Type=\"Edm.Int32\" Nullable=\"false\"/>' +
				'<Property Name=\"ProductName\" Type=\"Edm.String\" Nullable=\"false\" MaxLength=\"40\"/>' +
				'<Property Name=\"UnitPrice\" Type=\"Edm.Decimal\" Nullable=\"false\" Precision=\"19\" Scale=\"4\"/>' +
				'<Property Name=\"Quantity\" Type=\"Edm.Int16\" Nullable=\"false\"/>' +
				'<Property Name=\"Discount\" Type=\"Edm.Single\" Nullable=\"false\"/>' +
				'<Property Name=\"ExtendedPrice\" Type=\"Edm.Decimal\" Precision=\"19\" Scale=\"4\"/>' +
				'<Property Name=\"Freight\" Type=\"Edm.Decimal\" Precision=\"19\" Scale=\"4\"/>' +
				'</EntityType>' +
				'<EntityType Name=\"Order_Details_Extended\">' +
				'<Key>' +
				'<PropertyRef Name=\"Discount\"/>' +
				'<PropertyRef Name=\"OrderID\"/>' +
				'<PropertyRef Name=\"ProductID\"/>' +
				'<PropertyRef Name=\"ProductName\"/>' +
				'<PropertyRef Name=\"Quantity\"/>' +
				'<PropertyRef Name=\"UnitPrice\"/>' +
				'</Key>' +
				'<Property Name=\"OrderID\" Type=\"Edm.Int32\" Nullable=\"false\"/>' +
				'<Property Name=\"ProductID\" Type=\"Edm.Int32\" Nullable=\"false\"/>' +
				'<Property Name=\"ProductName\" Type=\"Edm.String\" Nullable=\"false\" MaxLength=\"40\"/>' +
				'<Property Name=\"UnitPrice\" Type=\"Edm.Decimal\" Nullable=\"false\" Precision=\"19\" Scale=\"4\"/>' +
				'<Property Name=\"Quantity\" Type=\"Edm.Int16\" Nullable=\"false\"/>' +
				'<Property Name=\"Discount\" Type=\"Edm.Single\" Nullable=\"false\"/>' +
				'<Property Name=\"ExtendedPrice\" Type=\"Edm.Decimal\" Precision=\"19\" Scale=\"4\"/>' +
				'</EntityType>' +
				'<EntityType Name=\"Order_Subtotal\">' +
				'<Key>' +
				'<PropertyRef Name=\"OrderID\"/>' +
				'</Key>' +
				'<Property Name=\"OrderID\" Type=\"Edm.Int32\" Nullable=\"false\"/>' +
				'<Property Name=\"Subtotal\" Type=\"Edm.Decimal\" Precision=\"19\" Scale=\"4\"/>' +
				'</EntityType>' +
				'<EntityType Name=\"Orders_Qry\">' +
				'<Key>' +
				'<PropertyRef Name=\"CompanyName\"/>' +
				'<PropertyRef Name=\"OrderID\"/>' +
				'</Key>' +
				'<Property Name=\"OrderID\" Type=\"Edm.Int32\" Nullable=\"false\"/>' +
				'<Property Name=\"CustomerID\" Type=\"Edm.String\" MaxLength=\"5\"/>' +
				'<Property Name=\"EmployeeID\" Type=\"Edm.Int32\"/>' +
				'<Property Name=\"OrderDate\" Type=\"Edm.DateTimeOffset\"/>' +
				'<Property Name=\"RequiredDate\" Type=\"Edm.DateTimeOffset\"/>' +
				'<Property Name=\"ShippedDate\" Type=\"Edm.DateTimeOffset\"/>' +
				'<Property Name=\"ShipVia\" Type=\"Edm.Int32\"/>' +
				'<Property Name=\"Freight\" Type=\"Edm.Decimal\" Precision=\"19\" Scale=\"4\"/>' +
				'<Property Name=\"ShipName\" Type=\"Edm.String\" MaxLength=\"40\"/>' +
				'<Property Name=\"ShipAddress\" Type=\"Edm.String\" MaxLength=\"60\"/>' +
				'<Property Name=\"ShipCity\" Type=\"Edm.String\" MaxLength=\"15\"/>' +
				'<Property Name=\"ShipRegion\" Type=\"Edm.String\" MaxLength=\"15\"/>' +
				'<Property Name=\"ShipPostalCode\" Type=\"Edm.String\" MaxLength=\"10\"/>' +
				'<Property Name=\"ShipCountry\" Type=\"Edm.String\" MaxLength=\"15\"/>' +
				'<Property Name=\"CompanyName\" Type=\"Edm.String\" Nullable=\"false\" MaxLength=\"40\"/>' +
				'<Property Name=\"Address\" Type=\"Edm.String\" MaxLength=\"60\"/>' +
				'<Property Name=\"City\" Type=\"Edm.String\" MaxLength=\"15\"/>' +
				'<Property Name=\"Region\" Type=\"Edm.String\" MaxLength=\"15\"/>' +
				'<Property Name=\"PostalCode\" Type=\"Edm.String\" MaxLength=\"10\"/>' +
				'<Property Name=\"Country\" Type=\"Edm.String\" MaxLength=\"15\"/>' +
				'</EntityType>' +
				'<EntityType Name=\"Product_Sales_for_1997\">' +
				'<Key>' +
				'<PropertyRef Name=\"CategoryName\"/>' +
				'<PropertyRef Name=\"ProductName\"/>' +
				'</Key>' +
				'<Property Name=\"CategoryName\" Type=\"Edm.String\" Nullable=\"false\" MaxLength=\"15\"/>' +
				'<Property Name=\"ProductName\" Type=\"Edm.String\" Nullable=\"false\" MaxLength=\"40\"/>' +
				'<Property Name=\"ProductSales\" Type=\"Edm.Decimal\" Precision=\"19\" Scale=\"4\"/>' +
				'</EntityType>' +
				'<EntityType Name=\"Products_Above_Average_Price\">' +
				'<Key>' +
				'<PropertyRef Name=\"ProductName\"/>' +
				'</Key>' +
				'<Property Name=\"ProductName\" Type=\"Edm.String\" Nullable=\"false\" MaxLength=\"40\"/>' +
				'<Property Name=\"UnitPrice\" Type=\"Edm.Decimal\" Precision=\"19\" Scale=\"4\"/>' +
				'</EntityType>' +
				'<EntityType Name=\"Products_by_Category\">' +
				'<Key>' +
				'<PropertyRef Name=\"CategoryName\"/>' +
				'<PropertyRef Name=\"Discontinued\"/>' +
				'<PropertyRef Name=\"ProductName\"/>' +
				'</Key>' +
				'<Property Name=\"CategoryName\" Type=\"Edm.String\" Nullable=\"false\" MaxLength=\"15\"/>' +
				'<Property Name=\"ProductName\" Type=\"Edm.String\" Nullable=\"false\" MaxLength=\"40\"/>' +
				'<Property Name=\"QuantityPerUnit\" Type=\"Edm.String\" MaxLength=\"20\"/>' +
				'<Property Name=\"UnitsInStock\" Type=\"Edm.Int16\"/>' +
				'<Property Name=\"Discontinued\" Type=\"Edm.Boolean\" Nullable=\"false\"/>' +
				'</EntityType>' +
				'<EntityType Name=\"Sales_by_Category\">' +
				'<Key>' +
				'<PropertyRef Name=\"CategoryID\"/>' +
				'<PropertyRef Name=\"CategoryName\"/>' +
				'<PropertyRef Name=\"ProductName\"/>' +
				'</Key>' +
				'<Property Name=\"CategoryID\" Type=\"Edm.Int32\" Nullable=\"false\"/>' +
				'<Property Name=\"CategoryName\" Type=\"Edm.String\" Nullable=\"false\" MaxLength=\"15\"/>' +
				'<Property Name=\"ProductName\" Type=\"Edm.String\" Nullable=\"false\" MaxLength=\"40\"/>' +
				'<Property Name=\"ProductSales\" Type=\"Edm.Decimal\" Precision=\"19\" Scale=\"4\"/>' +
				'</EntityType>' +
				'<EntityType Name=\"Sales_Totals_by_Amount\">' +
				'<Key>' +
				'<PropertyRef Name=\"CompanyName\"/>' +
				'<PropertyRef Name=\"OrderID\"/>' +
				'</Key>' +
				'<Property Name=\"SaleAmount\" Type=\"Edm.Decimal\" Precision=\"19\" Scale=\"4\"/>' +
				'<Property Name=\"OrderID\" Type=\"Edm.Int32\" Nullable=\"false\"/>' +
				'<Property Name=\"CompanyName\" Type=\"Edm.String\" Nullable=\"false\" MaxLength=\"40\"/>' +
				'<Property Name=\"ShippedDate\" Type=\"Edm.DateTimeOffset\"/>' +
				'</EntityType>' +
				'<EntityType Name=\"Summary_of_Sales_by_Quarter\">' +
				'<Key>' +
				'<PropertyRef Name=\"OrderID\"/>' +
				'</Key>' +
				'<Property Name=\"ShippedDate\" Type=\"Edm.DateTimeOffset\"/>' +
				'<Property Name=\"OrderID\" Type=\"Edm.Int32\" Nullable=\"false\"/>' +
				'<Property Name=\"Subtotal\" Type=\"Edm.Decimal\" Precision=\"19\" Scale=\"4\"/>' +
				'</EntityType>' +
				'<EntityType Name=\"Summary_of_Sales_by_Year\">' +
				'<Key>' +
				'<PropertyRef Name=\"OrderID\"/>' +
				'</Key>' +
				'<Property Name=\"ShippedDate\" Type=\"Edm.DateTimeOffset\"/>' +
				'<Property Name=\"OrderID\" Type=\"Edm.Int32\" Nullable=\"false\"/>' +
				'<Property Name=\"Subtotal\" Type=\"Edm.Decimal\" Precision=\"19\" Scale=\"4\"/>' +
				'</EntityType>' +
				'</Schema>' +
				'<Schema xmlns=\"http://docs.oasis-open.org/odata/ns/edm\" Namespace=\"ODataWebExperimental.Northwind.Model\">' +
				'<EntityContainer xmlns:p4=\"http://schemas.microsoft.com/ado/2009/02/edm/annotation\" Name=\"NorthwindEntities\" p4:LazyLoadingEnabled=\"true\">' +
				'<EntitySet Name=\"Categories\" EntityType=\"NorthwindModel.Category\">' +
				'<NavigationPropertyBinding Path=\"Products\" Target=\"Products\"/>' +
				'</EntitySet>' +
				'<EntitySet Name=\"CustomerDemographics\" EntityType=\"NorthwindModel.CustomerDemographic\">' +
				'<NavigationPropertyBinding Path=\"Customers\" Target=\"Customers\"/>' +
				'</EntitySet>' +
				'<EntitySet Name=\"Customers\" EntityType=\"NorthwindModel.Customer\">' +
				'<NavigationPropertyBinding Path=\"CustomerDemographics\" Target=\"CustomerDemographics\"/>' +
				'<NavigationPropertyBinding Path=\"Orders\" Target=\"Orders\"/>' +
				'</EntitySet>' +
				'<EntitySet Name=\"Employees\" EntityType=\"NorthwindModel.Employee\">' +
				'<NavigationPropertyBinding Path=\"Employees1\" Target=\"Employees\"/>' +
				'<NavigationPropertyBinding Path=\"Employee1\" Target=\"Employees\"/>' +
				'<NavigationPropertyBinding Path=\"Orders\" Target=\"Orders\"/>' +
				'<NavigationPropertyBinding Path=\"Territories\" Target=\"Territories\"/>' +
				'</EntitySet>' +
				'<EntitySet Name=\"Order_Details\" EntityType=\"NorthwindModel.Order_Detail\">' +
				'<NavigationPropertyBinding Path=\"Order\" Target=\"Orders\"/>' +
				'<NavigationPropertyBinding Path=\"Product\" Target=\"Products\"/>' +
				'</EntitySet>' +
				'<EntitySet Name=\"Orders\" EntityType=\"NorthwindModel.Order\">' +
				'<NavigationPropertyBinding Path=\"Customer\" Target=\"Customers\"/>' +
				'<NavigationPropertyBinding Path=\"Employee\" Target=\"Employees\"/>' +
				'<NavigationPropertyBinding Path=\"Order_Details\" Target=\"Order_Details\"/>' +
				'<NavigationPropertyBinding Path=\"Shipper\" Target=\"Shippers\"/>' +
				'</EntitySet>' +
				'<EntitySet Name=\"Products\" EntityType=\"NorthwindModel.Product\">' +
				'<NavigationPropertyBinding Path=\"Category\" Target=\"Categories\"/>' +
				'<NavigationPropertyBinding Path=\"Order_Details\" Target=\"Order_Details\"/>' +
				'<NavigationPropertyBinding Path=\"Supplier\" Target=\"Suppliers\"/>' +
				'</EntitySet>' +
				'<EntitySet Name=\"Regions\" EntityType=\"NorthwindModel.Region\">' +
				'<NavigationPropertyBinding Path=\"Territories\" Target=\"Territories\"/>' +
				'</EntitySet>' +
				'<EntitySet Name=\"Shippers\" EntityType=\"NorthwindModel.Shipper\">' +
				'<NavigationPropertyBinding Path=\"Orders\" Target=\"Orders\"/>' +
				'</EntitySet>' +
				'<EntitySet Name=\"Suppliers\" EntityType=\"NorthwindModel.Supplier\">' +
				'<NavigationPropertyBinding Path=\"Products\" Target=\"Products\"/>' +
				'</EntitySet>' +
				'<EntitySet Name=\"Territories\" EntityType=\"NorthwindModel.Territory\">' +
				'<NavigationPropertyBinding Path=\"Employees\" Target=\"Employees\"/>' +
				'<NavigationPropertyBinding Path=\"Region\" Target=\"Regions\"/>' +
				'</EntitySet>' +
				'<EntitySet Name=\"Alphabetical_list_of_products\" EntityType=\"NorthwindModel.Alphabetical_list_of_product\"/>' +
				'<EntitySet Name=\"Category_Sales_for_1997\" EntityType=\"NorthwindModel.Category_Sales_for_1997\"/>' +
				'<EntitySet Name=\"Current_Product_Lists\" EntityType=\"NorthwindModel.Current_Product_List\"/>' +
				'<EntitySet Name=\"Customer_and_Suppliers_by_Cities\" EntityType=\"NorthwindModel.Customer_and_Suppliers_by_City\"/>' +
				'<EntitySet Name=\"Invoices\" EntityType=\"NorthwindModel.Invoice\"/>' +
				'<EntitySet Name=\"Order_Details_Extendeds\" EntityType=\"NorthwindModel.Order_Details_Extended\"/>' +
				'<EntitySet Name=\"Order_Subtotals\" EntityType=\"NorthwindModel.Order_Subtotal\"/>' +
				'<EntitySet Name=\"Orders_Qries\" EntityType=\"NorthwindModel.Orders_Qry\"/>' +
				'<EntitySet Name=\"Product_Sales_for_1997\" EntityType=\"NorthwindModel.Product_Sales_for_1997\"/>' +
				'<EntitySet Name=\"Products_Above_Average_Prices\" EntityType=\"NorthwindModel.Products_Above_Average_Price\"/>' +
				'<EntitySet Name=\"Products_by_Categories\" EntityType=\"NorthwindModel.Products_by_Category\"/>' +
				'<EntitySet Name=\"Sales_by_Categories\" EntityType=\"NorthwindModel.Sales_by_Category\"/>' +
				'<EntitySet Name=\"Sales_Totals_by_Amounts\" EntityType=\"NorthwindModel.Sales_Totals_by_Amount\"/>' +
				'<EntitySet Name=\"Summary_of_Sales_by_Quarters\" EntityType=\"NorthwindModel.Summary_of_Sales_by_Quarter\"/>' +
				'<EntitySet Name=\"Summary_of_Sales_by_Years\" EntityType=\"NorthwindModel.Summary_of_Sales_by_Year\"/>' +
				'</EntityContainer>' +
				'</Schema>' +
				'</edmx:DataServices>' +
				'</edmx:Edmx>';
    }
    
    //=========================================================================================//
    //Create Dummy Data For JSON oData Testing 
    //=========================================================================================//
    public static String getDummyJSONoData(){
    	
    	return '{\"@odata.context\":\"http://services.odata.org/V4/Northwind/Northwind.svc/$metadata#Invoices\",\"value\":[{\"ShipName\":\"Alfred\'s Futterkiste\",\"ShipAddress\":\"Obere Str. 57\",\"ShipCity\":\"Berlin\",\"ShipRegion\":null,\"ShipPostalCode\":\"12209\",\"ShipCountry\":\"Germany\",\"CustomerID\":\"ALFKI\",\"CustomerName\":\"Alfreds Futterkiste\",\"Address\":\"Obere Str. 57\",\"City\":\"Berlin\",\"Region\":null,\"PostalCode\":\"12209\",\"Country\":\"Germany\",\"Salesperson\":\"Margaret Peacock\",\"OrderID\":10692,\"OrderDate\":\"1997-10-03T00:00:00Z\",\"RequiredDate\":\"1997-10-31T00:00:00Z\",\"ShippedDate\":\"1997-10-13T00:00:00Z\",\"ShipperName\":\"United Package\",\"ProductID\":63,\"ProductName\":\"Vegie-spread\",\"UnitPrice\":43.9000,\"Quantity\":20,\"Discount\":0,\"ExtendedPrice\":878.0000,\"Freight\":61.0200}],\"@odata.nextLink\":\"Invoices?$skiptoken=\'Familia%20Arquibaldo\',0.05,10650,53,\'Perth%20Pasties\',25,\'Steven%20Buchanan\',\'Federal%20Shipping\',32.8000\"}';
    }
    
    //=========================================================================================//
    //Create Dummy Data For XML oData Testing 
    //=========================================================================================//
    public static String getDummyXMLoData(){
    	
    	return '<?xml version=\"1.0\" encoding=\"utf-8\"?>' +
				'<feed xml:base=\"http://odata.research.microsoft.com/odata.svc/\" xmlns=\"http://www.w3.org/2005/Atom\" xmlns:d=\"http://schemas.microsoft.com/ado/2007/08/dataservices\" xmlns:m=\"http://schemas.microsoft.com/ado/2007/08/dataservices/metadata\" xmlns:georss=\"http://www.georss.org/georss\" xmlns:gml=\"http://www.opengis.net/gml\">' +
				'   <id>http://schemas.datacontract.org/2004/07/</id>' +
				'   <title />' +
				'   <updated>2015-09-06T08:50:07Z</updated>' +
				'   <link rel=\"self\" href=\"http://odata.research.microsoft.com/odata.svc/Users\" />' +
				'   <entry>' +
				'    <id>http://odata.research.microsoft.com/odata.svc/Users(47230)</id>' +
				'    <category term=\"OData.Models.User\" scheme=\"http://schemas.microsoft.com/ado/2007/08/dataservices/scheme\" />' +
				'    <link rel=\"edit\" href=\"http://odata.research.microsoft.com/odata.svc/Users(47230)\" />' +
				'    <link rel=\"self\" href=\"http://odata.research.microsoft.com/odata.svc/Users(47230)\" />' +
				'    <link rel=\"http://schemas.microsoft.com/ado/2007/08/dataservices/related/Downloads\" type=\"application/atom+xml;type=feed\" title=\"Downloads\" href=\"http://odata.research.microsoft.com/odata.svc/Users(47230)/Downloads\" />' +
				'    <link rel=\"http://schemas.microsoft.com/ado/2007/08/dataservices/related/Events\" type=\"application/atom+xml;type=feed\" title=\"Events\" href=\"http://odata.research.microsoft.com/odata.svc/Users(47230)/Events\" />' +
				'    <link rel=\"http://schemas.microsoft.com/ado/2007/08/dataservices/related/Groups\" type=\"application/atom+xml;type=feed\" title=\"Groups\" href=\"http://odata.research.microsoft.com/odata.svc/Users(47230)/Groups\" />' +
				'    <link rel=\"http://schemas.microsoft.com/ado/2007/08/dataservices/related/Headlines\" type=\"application/atom+xml;type=feed\" title=\"Headlines\" href=\"http://odata.research.microsoft.com/odata.svc/Users(47230)/Headlines\" />' +
				'    <link rel=\"http://schemas.microsoft.com/ado/2007/08/dataservices/related/Labs\" type=\"application/atom+xml;type=feed\" title=\"Labs\" href=\"http://odata.research.microsoft.com/odata.svc/Users(47230)/Labs\" />' +
				'    <link rel=\"http://schemas.microsoft.com/ado/2007/08/dataservices/related/Projects\" type=\"application/atom+xml;type=feed\" title=\"Projects\" href=\"http://odata.research.microsoft.com/odata.svc/Users(47230)/Projects\" />' +
				'    <link rel=\"http://schemas.microsoft.com/ado/2007/08/dataservices/related/Publications\" type=\"application/atom+xml;type=feed\" title=\"Publications\" href=\"http://odata.research.microsoft.com/odata.svc/Users(47230)/Publications\" />' +
				'    <link rel=\"http://schemas.microsoft.com/ado/2007/08/dataservices/related/Videos\" type=\"application/atom+xml;type=feed\" title=\"Videos\" href=\"http://odata.research.microsoft.com/odata.svc/Users(47230)/Videos\" />' +
				'    <title type=\"text\">Abdulaziz Mohammed</title>' +
				'    <summary type=\"html\"></summary>' +
				'    <updated>2015-05-24T12:11:57Z</updated>' +
				'    <author>' +
				'    <name />' +
				'    </author>' +
				'    <content type=\"application/xml\">' +
				'    <m:properties>' +
				'        <d:FirstName>Abdulaziz</d:FirstName>' +
				'        <d:LastName>Mohammed</d:LastName>' +
				'        <d:MasAuthorId m:type=\"Edm.Int32\">0</d:MasAuthorId>' +
				'        <d:Title>SENIOR ENGINEERING LEAD</d:Title>' +
				'        <d:Views m:type=\"Edm.Int64\">364</d:Views>' +
				'        <d:Id m:type=\"Edm.Int32\">47230</d:Id>' +
				'        <d:DateUpdated m:type=\"Edm.DateTime\">2015-05-24T12:11:57.347Z</d:DateUpdated>' +
				'        <d:Description m:null=\"true\" />' +
				'        <d:Name>Abdulaziz Mohammed</d:Name>' +
				'        <d:Picture m:null=\"true\" />' +
				'        <d:ResearchAreas></d:ResearchAreas>' +
				'        <d:Tags></d:Tags>' +
				'        <d:Url m:null=\"true\" />' +
				'    </m:properties>' +
				'    </content>' +
				'   </entry>' +
				'   <link rel=\"next\" href=\"http://odata.research.microsoft.com/odata.svc/Users?$skip=100\" />' +
				'</feed>';
		
    }
    
    //=========================================================================================//
    //Create Dummy Data For oData object XML Testing 
    //=========================================================================================//
    public static String getDummyObjectXMLoData(){
    	
    	return '<service xmlns=\"http://www.w3.org/2007/app\" xmlns:atom=\"http://www.w3.org/2005/Atom\" xmlns:m=\"http://docs.oasis-open.org/odata/ns/metadata\" xml:base=\"http://services.odata.org/V4/Northwind/Northwind.svc/\" m:context=\"http://services.odata.org/V4/Northwind/Northwind.svc/$metadata\">'  +
				'<workspace>'  +
				'<atom:title type=\"text\">Default</atom:title>'  +
				'<collection href=\"Categories\">'  +
				'<atom:title type=\"text\">Categories</atom:title>'  +
				'</collection>'  +
				'<collection href=\"CustomerDemographics\">'  +
				'<atom:title type=\"text\">CustomerDemographics</atom:title>'  +
				'</collection>'  +
				'<collection href=\"Customers\">'  +
				'<atom:title type=\"text\">Customers</atom:title>'  +
				'</collection>'  +
				'<collection href=\"Employees\">'  +
				'<atom:title type=\"text\">Employees</atom:title>'  +
				'</collection>'  +
				'<collection href=\"Order_Details\">'  +
				'<atom:title type=\"text\">Order_Details</atom:title>'  +
				'</collection>'  +
				'<collection href=\"Orders\">'  +
				'<atom:title type=\"text\">Orders</atom:title>'  +
				'</collection>'  +
				'<collection href=\"Products\">'  +
				'<atom:title type=\"text\">Products</atom:title>'  +
				'</collection>'  +
				'<collection href=\"Regions\">'  +
				'<atom:title type=\"text\">Regions</atom:title>'  +
				'</collection>'  +
				'<collection href=\"Shippers\">'  +
				'<atom:title type=\"text\">Shippers</atom:title>'  +
				'</collection>'  +
				'<collection href=\"Suppliers\">'  +
				'<atom:title type=\"text\">Suppliers</atom:title>'  +
				'</collection>'  +
				'<collection href=\"Territories\">'  +
				'<atom:title type=\"text\">Territories</atom:title>'  +
				'</collection>'  +
				'<collection href=\"Alphabetical_list_of_products\">'  +
				'<atom:title type=\"text\">Alphabetical_list_of_products</atom:title>'  +
				'</collection>'  +
				'<collection href=\"Category_Sales_for_1997\">'  +
				'<atom:title type=\"text\">Category_Sales_for_1997</atom:title>'  +
				'</collection>'  +
				'<collection href=\"Current_Product_Lists\">'  +
				'<atom:title type=\"text\">Current_Product_Lists</atom:title>'  +
				'</collection>'  +
				'<collection href=\"Customer_and_Suppliers_by_Cities\">'  +
				'<atom:title type=\"text\">Customer_and_Suppliers_by_Cities</atom:title>'  +
				'</collection>'  +
				'<collection href=\"Invoices\">'  +
				'<atom:title type=\"text\">Invoices</atom:title>'  +
				'</collection>'  +
				'<collection href=\"Order_Details_Extendeds\">'  +
				'<atom:title type=\"text\">Order_Details_Extendeds</atom:title>'  +
				'</collection>'  +
				'<collection href=\"Order_Subtotals\">'  +
				'<atom:title type=\"text\">Order_Subtotals</atom:title>'  +
				'</collection>'  +
				'<collection href=\"Orders_Qries\">'  +
				'<atom:title type=\"text\">Orders_Qries</atom:title>'  +
				'</collection>'  +
				'<collection href=\"Product_Sales_for_1997\">'  +
				'<atom:title type=\"text\">Product_Sales_for_1997</atom:title>'  +
				'</collection>'  +
				'<collection href=\"Products_Above_Average_Prices\">'  +
				'<atom:title type=\"text\">Products_Above_Average_Prices</atom:title>'  +
				'</collection>'  +
				'<collection href=\"Products_by_Categories\">'  +
				'<atom:title type=\"text\">Products_by_Categories</atom:title>'  +
				'</collection>'  +
				'<collection href=\"Sales_by_Categories\">'  +
				'<atom:title type=\"text\">Sales_by_Categories</atom:title>'  +
				'</collection>'  +
				'<collection href=\"Sales_Totals_by_Amounts\">'  +
				'<atom:title type=\"text\">Sales_Totals_by_Amounts</atom:title>'  +
				'</collection>'  +
				'<collection href=\"Summary_of_Sales_by_Quarters\">'  +
				'<atom:title type=\"text\">Summary_of_Sales_by_Quarters</atom:title>'  +
				'</collection>'  +
				'<collection href=\"Summary_of_Sales_by_Years\">'  +
				'<atom:title type=\"text\">Summary_of_Sales_by_Years</atom:title>'  +
				'</collection>'  +
				'</workspace>'  +
				'</service>';
    }
}