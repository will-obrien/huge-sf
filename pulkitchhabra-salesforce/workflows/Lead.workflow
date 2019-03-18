<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>FlagChange</fullName>
        <field>Python_Api_Flag__c</field>
        <literalValue>1</literalValue>
        <name>FlagChange</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LeadApiCounterUpdate</fullName>
        <field>Python_Api_Counter__c</field>
        <formula>Python_Api_Counter__c + 1</formula>
        <name>LeadApiCounterUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OwnerUpdate</fullName>
        <field>NumberofLocations__c</field>
        <formula>11111111</formula>
        <name>OwnerUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>LeadAssignmentCheck</fullName>
        <actions>
            <name>LeadApiCounterUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Python_Api_Flag__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
