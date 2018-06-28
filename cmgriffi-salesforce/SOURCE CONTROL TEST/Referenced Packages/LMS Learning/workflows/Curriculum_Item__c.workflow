<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UpdateSequence</fullName>
        <field>Sequence__c</field>
        <formula>1</formula>
        <name>Update Sequence</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Sequence</fullName>
        <actions>
            <name>UpdateSequence</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>OR(ISNULL(Sequence__c ), Sequence__c &lt; 1)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
