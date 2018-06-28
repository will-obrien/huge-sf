<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Stop_Duplicate_on_the_Exam_Refgistration</fullName>
        <description>When a User registers for the Exam and if he tries to make an other registration .This workflow Fires to stop the Duplicate record he is trying to make and gives back the error with the current record Id so that Admin can click and see through</description>
        <field>Unique__c</field>
        <formula>Section__c + Member__r.Id  + text(Exam_Site__r.Exam__r.Exam_Date__c)</formula>
        <name>Stop Duplicate on the Exam Refgistration</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Candidate_Requirement_Status</fullName>
        <description>Update Candidate Requirement : Status to</description>
        <field>Status__c</field>
        <literalValue>Completed</literalValue>
        <name>Update Candidate Requirement:Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Candidate_Requirement__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_the_Name_of_the_Exam_Registration</fullName>
        <field>Name</field>
        <formula>Exam_Site__r.Exam__r.Name+&quot;-&quot;+Member__r.FirstName+&quot;,&quot;+ Member__r.LastName</formula>
        <name>Update the Name of the Exam Registration</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Prevent the Duplicate of the Exam Registration</fullName>
        <actions>
            <name>Stop_Duplicate_on_the_Exam_Refgistration</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Exam_Sites__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Propagate Exam Result</fullName>
        <actions>
            <name>Update_Candidate_Requirement_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Exam_Attempt__c.Result__c</field>
            <operation>equals</operation>
            <value>Pass</value>
        </criteriaItems>
        <description>If exam result is set to &quot;PASSED&quot; update Candidate Requirement :Status to complete</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update the name on the Exam Registations</fullName>
        <actions>
            <name>Update_the_Name_of_the_Exam_Registration</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Exam_Attempt__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
