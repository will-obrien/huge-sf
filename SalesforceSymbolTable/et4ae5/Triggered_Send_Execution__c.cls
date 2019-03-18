// Generated by Illuminated Cloud on Tue Feb 14 12:00:53 IST 2017. Do not edit.

/**
 * <h3>Triggered Send Execution</h3>
 * Stores information about triggered send executions such as scheduled time and status.
 */
global class /*et4ae5__*/Triggered_Send_Execution__c extends SObject 
{
    global List<ActivityHistory> ActivityHistories;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<Attachment> Attachments;
    /**
     * <h3>Business Unit ID</h3>
     */
    global String Business_Unit_ID__c;
    global List<CombinedAttachment> CombinedAttachments;
    global PartnerNetworkConnection ConnectionReceived;
    global Id ConnectionReceivedId;
    global PartnerNetworkConnection ConnectionSent;
    global Id ConnectionSentId;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EmailMessage> Emails;
    global List<Event> Events;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global ContentVersion FirstPublishLocation;
    /**
     * <h3>From Name</h3>
     */
    global String FromName__c;
    global Date LastActivityDate;
    global PartnerNetworkRecordConnection LocalRecord;
    /**
     * <h3>Message</h3>
     */
    global String Message__c;
    global List<Note> Notes;
    global List<NoteAndAttachment> NotesAndAttachments;
    global List<OpenActivity> OpenActivities;
    global SObject Owner;
    global Id OwnerId;
    global FeedComment Parent;
    global PartnerNetworkRecordConnection ParentRecord;
    global PartnerNetworkRecordConnection PartnerRecord;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    /**
     * <h3>RecipientId</h3>
     */
    global String RecipientId__c;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global ContentDistribution RelatedRecord;
    /**
     * <h3>Retry Count</h3>
     */
    global Decimal Retry_Count__c;
    /**
     * <h3>Scheduled Date/Time</h3>
     */
    global Datetime Scheduled_Date_Time__c;
    global SObjectType SObjectType;
    /**
     * <h3>Status</h3>
     */
    global String Status__c;
    global Datetime SystemModstamp;
    global List<Task> Tasks;
    global List<TopicAssignment> TopicAssignments;
    /**
     * <h3>Triggered Send</h3>
     */
    global Id Triggered_Send__c;
    /**
     * <h3>Triggered Send</h3>
     */
    global Automated_Send__c Triggered_Send__r;
    /**
     * <h3>Triggering Object</h3>
     */
    global String Triggering_Object__c;
    /**
     * <h3>Triggering Record Id</h3>
     */
    global String Triggering_Record_Id__c;

    global Triggered_Send_Execution__c()
    {
    }
}