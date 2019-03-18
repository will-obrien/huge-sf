<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Acct_Scorecard_Name</fullName>
        <field>Name</field>
        <formula>Account_Name__r.Name + &quot; &quot; +  &quot;Scorecard&quot; + &quot; &quot; +  TEXT(Scorecard_Month__c) + &quot; &quot; + Scorecard_Year__c</formula>
        <name>GCS_Set Acct Scorecard Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>GCS_Set Acct Scorecard Name</fullName>
        <actions>
            <name>Set_Acct_Scorecard_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Acct_Scorecard__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
