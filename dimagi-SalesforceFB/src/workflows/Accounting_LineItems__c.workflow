<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>update_feature_type</fullName>
        <field>Feature_Type1__c</field>
        <formula>Accounting_FeatureRate__r.feature__r.feature_type__c</formula>
        <name>update feature_type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>update Featuretype</fullName>
        <actions>
            <name>update_feature_type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
