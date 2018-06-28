<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Prevent_the_Duplicate_of_the_Exam</fullName>
        <description>Update the Unique field to stop the duplicate on the Exam object.</description>
        <field>Unique__c</field>
        <formula>Text(Exam__c)+Text(Exam_Date__c)</formula>
        <name>Prevent the Duplicate of the Exam Types</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Prevent_the_duplicate_of_the_Exam_name</fullName>
        <field>Exam_Name__c</field>
        <formula>Name</formula>
        <name>Prevent the duplicate of the Exam name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Prevent the Duplicate of the Exam</fullName>
        <actions>
            <name>Prevent_the_Duplicate_of_the_Exam</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Prevent_the_duplicate_of_the_Exam_name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Exam__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This Workflow will stop the duplicate record in the Exam Object.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
