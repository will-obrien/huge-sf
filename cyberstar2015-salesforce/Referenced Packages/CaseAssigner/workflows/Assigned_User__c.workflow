<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_user_for_business_hour</fullName>
        <field>UniqueUserForBusinessHr__c</field>
        <formula>Business_Hour__c +  User__c</formula>
        <name>Update user for business hour</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Populate Unique User for Business hour</fullName>
        <actions>
            <name>Update_user_for_business_hour</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
