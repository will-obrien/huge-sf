<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Remind_Day_Before_a_Task_is_due</fullName>
        <ccEmails>nnestle@dimagi.com</ccEmails>
        <description>Remind Day Before a Task is due</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/ContactFollowUpSAMPLE</template>
    </alerts>
    <alerts>
        <fullName>Thank_you_for_your_submission_email</fullName>
        <description>Thank you for your submission email</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Dimagi_Emails/Contact_Us_Immediate_Response</template>
    </alerts>
    <fieldUpdates>
        <fullName>Lead_Status_Downgrade_TEST</fullName>
        <field>Status</field>
        <literalValue>Passive &amp; Friendly</literalValue>
        <name>Lead Status Downgrade TEST</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Lead%3A Contact Us - CCHQ</fullName>
        <actions>
            <name>Thank_you_for_your_submission_email</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Contact Us</value>
        </criteriaItems>
        <description>Email the list when a lead comes in from the Contact Us form on CCHQ.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>lead downgrade</fullName>
        <actions>
            <name>Lead_Status_Downgrade_TEST</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>LastActivityDate &gt;  timestamp_test__c - 90</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>testing lead</fullName>
        <active>false</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Lead.Ryan_Lead_Status_do_not_use__c</field>
            <operation>equals</operation>
            <value>Call #1 Held</value>
        </criteriaItems>
        <description>this is a test</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
