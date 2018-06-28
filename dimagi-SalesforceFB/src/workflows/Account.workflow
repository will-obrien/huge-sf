<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Keep_Warm_Date_Disapears</fullName>
        <description>When you uncheck the keep warm box the date disapears</description>
        <field>Keep_Warm_Date__c</field>
        <name>Keep Warm Date Disapears</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Keep_Warm_Equals_Today_Plus_90</fullName>
        <description>When you check the Keep Warm box the Keep Warm Date will default to 90 days from today</description>
        <field>Keep_Warm_Date__c</field>
        <formula>Today()+90</formula>
        <name>Keep Warm Equals Today Plus 90</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Account_Status_Passive</fullName>
        <field>Status__c</field>
        <literalValue>Passive</literalValue>
        <name>Set Account Status Passive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Account%3A Status Change</fullName>
        <active>true</active>
        <formula>ISCHANGED( Status__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Default the Keep Warm Date</fullName>
        <actions>
            <name>Keep_Warm_Equals_Today_Plus_90</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Keep_Warm__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This rule defaults the keep warm date to 90 days when you check the keep warm box</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Revert Keep Warm Date</fullName>
        <actions>
            <name>Keep_Warm_Date_Disapears</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Keep_Warm__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>when the keep warm box is unchecked the date to keep warm disapears</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
