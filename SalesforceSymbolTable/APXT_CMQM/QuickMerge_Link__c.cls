// Generated by Illuminated Cloud on Tue Feb 14 12:00:53 IST 2017. Do not edit.

/**
 * <h3>QuickMerge Link</h3>
 * This optional component is used to store a collection of parameters used to launch either Conga Merge's MassMerge or PointMerge tools.
 */
global class /*APXT_CMQM__*/QuickMerge_Link__c extends SObject 
{
    global List<ActivityHistory> ActivityHistories;
    /**
     * <h3>Activity Subject</h3>
     */
    global String Activity_Subject__c;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<Attachment> Attachments;
    /**
     * <h3>Automatic Logging</h3>
     */
    global Boolean Automatic_Logging__c;
    /**
     * <h3>Bypass Wizard</h3>
     */
    global Boolean Bypass_Wizard__c;
    /**
     * <h3>Campaign Id</h3>
     */
    global String Campaign_Id__c;
    global List<CombinedAttachment> CombinedAttachments;
    global PartnerNetworkConnection ConnectionReceived;
    global Id ConnectionReceivedId;
    global PartnerNetworkConnection ConnectionSent;
    global Id ConnectionSentId;
    global List<ContentDocumentLink> ContentDocumentLinks;
    /**
     * <h3>Default to PDF?</h3>
     */
    global Boolean Default_to_PDF__c;
    /**
     * <h3>Description</h3>
     */
    global String Description__c;
    /**
     * <h3>Template Id</h3>
     * Use the Template Id to identify the 15-character id of the document template
     */
    global String Document_Template_Id__c;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EmailMessage> Emails;
    /**
     * <h3>Envelope Template Id</h3>
     */
    global String Envelope_Template_Id__c;
    global List<Event> Events;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global ContentVersion FirstPublishLocation;
    /**
     * <h3>Follow-up Interval</h3>
     */
    global Decimal Follow_up_Interval__c;
    /**
     * <h3>Force Output as PDF?</h3>
     */
    global Boolean Force_Output_as_PDF__c;
    /**
     * <h3>Label Template Id</h3>
     */
    global String Label_Template_Id__c;
    global Date LastActivityDate;
    global Datetime LastReferencedDate;
    global Datetime LastViewedDate;
    /**
     * <h3>Launch</h3>
     */
    global String Launch__c;
    /**
     * <h3>Link Type</h3>
     */
    global String Link_Type__c;
    global PartnerNetworkRecordConnection LocalRecord;
    /**
     * <h3>Store Body Text?</h3>
     */
    global Boolean LogWordBody__c;
    global List<Note> Notes;
    global List<NoteAndAttachment> NotesAndAttachments;
    global List<OpenActivity> OpenActivities;
    /**
     * <h3>Other Parameters</h3>
     */
    global String Other_Parameters__c;
    global SObject Owner;
    global Id OwnerId;
    global FeedComment Parent;
    global PartnerNetworkRecordConnection ParentRecord;
    global PartnerNetworkRecordConnection PartnerRecord;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    /**
     * <h3>Query Id 1</h3>
     */
    global String Query_Id_1__c;
    /**
     * <h3>Query Id</h3>
     */
    global String Query_Id__c;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global RecordType RecordType;
    global Id RecordTypeId;
    global ContentDistribution RelatedRecord;
    /**
     * <h3>Report Id(s)</h3>
     * This field contains a list of Salesforce Report Ids, separated by commas.
     */
    global String Report_Id__c;
    global SObjectType SObjectType;
    global Datetime SystemModstamp;
    global List<Task> Tasks;
    /**
     * <h3>Title</h3>
     */
    global String Title__c;
    global List<TopicAssignment> TopicAssignments;

    global QuickMerge_Link__c()
    {
    }
}