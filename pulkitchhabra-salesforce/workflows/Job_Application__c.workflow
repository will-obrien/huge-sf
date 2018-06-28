<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Extend an Offer</fullName>
        <actions>
            <name>Extend_an_Offer</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Job_Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Extend an Offer</value>
        </criteriaItems>
        <description>Make an offer when a hiring manager changes the status of a job
application to Extend Offer.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Rejection Letter</fullName>
        <actions>
            <name>Send_Rejection_Letter</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Job_Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <description>Send a rejection letter when a hiring manager changes the status of a job application to Rejected.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Extend_an_Offer</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Extend an Offer</subject>
    </tasks>
    <tasks>
        <fullName>Send_Rejection_Letter</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Send Rejection Letter</subject>
    </tasks>
</Workflow>
