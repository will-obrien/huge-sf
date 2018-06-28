<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Exam_Site_Name</fullName>
        <field>Name</field>
        <formula>Exam__r.Name &amp; &quot; &quot;&amp; Site__r.Name</formula>
        <name>Update Exam Site Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Site Exam Name Update</fullName>
        <actions>
            <name>Update_Exam_Site_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( Exam__c !=null, Site__c !=null)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
