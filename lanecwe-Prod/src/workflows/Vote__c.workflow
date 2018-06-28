<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Voter_ID</fullName>
        <field>Name</field>
        <formula>Name_Voter_Contact__r.FirstName + &quot; &quot;  + Name_Voter_Contact__r.LastName + &quot; &quot;   + &quot;(&quot; +   Opportunity__r.Name + &quot;)&quot;</formula>
        <name>Set Voter ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>GCS_Set Voter Name</fullName>
        <actions>
            <name>Set_Voter_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Vote__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
