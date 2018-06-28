// Generated by Illuminated Cloud on Tue Feb 14 12:00:53 IST 2017. Do not edit.

/**
 * <h3>Conga Email Template</h3>
 * Email template manager for use with Conga Composer
 */
global class /*APXTConga4__*/Conga_Email_Template__c extends SObject 
{
    global List<ActivityHistory> ActivityHistories;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<Attachment> Attachments;
    global List<CombinedAttachment> CombinedAttachments;
    global List<Conga_Solution_Email_Template__c> Conga_Solution_Email_Templates__r;
    global PartnerNetworkConnection ConnectionReceived;
    global Id ConnectionReceivedId;
    global PartnerNetworkConnection ConnectionSent;
    global Id ConnectionSentId;
    global List<ContentDocumentLink> ContentDocumentLinks;
    /**
     * <h3>Description</h3>
     */
    global String Description__c;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EmailMessage> Emails;
    global List<Event> Events;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global ContentVersion FirstPublishLocation;
    /**
     * <h3>HTML Body</h3>
     */
    global String HTMLBody__c;
    /**
     * <h3>Use attachment for template body</h3>
     */
    global Boolean Is_Body_Attachment__c;
    global Date LastActivityDate;
    global Datetime LastReferencedDate;
    global Datetime LastViewedDate;
    global PartnerNetworkRecordConnection LocalRecord;
    /**
     * <h3>Name</h3>
     */
    global String Name__c;
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
     * <h3>Product</h3>
     */
    global String Product__c;
    /**
     * <h3>Program</h3>
     */
    global String Program__c;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global ContentDistribution RelatedRecord;
    global SObjectType SObjectType;
    /**
     * <h3>Subject</h3>
     */
    global String Subject__c;
    global Datetime SystemModstamp;
    global List<Task> Tasks;
    /**
     * <h3>Template Group</h3>
     */
    global String Template_Group__c;
    /**
     * <h3>Text Body</h3>
     */
    global String TextBody__c;
    global List<TopicAssignment> TopicAssignments;

    global Conga_Email_Template__c()
    {
    }
}