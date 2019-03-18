<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>holdingssymbolupdate</fullName>
        <description>When Holdings.Symbol is updated Holdings.Symbol_workflow is updated.</description>
        <field>Symbol_Workflow__c</field>
        <formula>Symbol__r.Name</formula>
        <name>Holdings Symbol Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Symbol_Workflow Update</fullName>
        <actions>
            <name>holdingssymbolupdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Holding.Symbol_Workflow is updated with Holding.Symbol</description>
        <formula>NOT(ISNULL(Symbol__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
