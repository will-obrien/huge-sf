<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>datekycapprovalrejection</fullName>
        <description>Date KYC was approved/rejected</description>
        <field>Date_KYC_Approved__c</field>
        <formula>TODAY()</formula>
        <name>Date KYC Approval/Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>dateofkycapprovalrejection</fullName>
        <description>Date KYC was approved/rejected</description>
        <field>Date_KYC_Approved__c</field>
        <formula>TODAY()</formula>
        <name>Date of KYC Approval/Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>dateofkycsubmission</fullName>
        <description>Date KYC was submitted for approval</description>
        <field>Date_KYC_Submitted__c</field>
        <formula>TODAY()</formula>
        <name>Date of KYC submission</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kycapprovalstatusapproved</fullName>
        <description>Updates KYC Approval Status when the KYC form is approved</description>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>KYC Approval Status: Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kycapprovalstatuspendingapproval</fullName>
        <description>Updates KYC Approval Status when the KYC form is submitted</description>
        <field>Status__c</field>
        <literalValue>Pending Approval</literalValue>
        <name>KYC Approval Status: Pending Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kycapprovalstatusrejected</fullName>
        <description>Updates KYC Approval Status when the KYC form is rejected</description>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>KYC Approval Status: Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <tasks>
        <fullName>followuponkyc</fullName>
        <assignedToType>owner</assignedToType>
        <description>A KYC form was submitted 6 months ago. Please follow up with the Client to make sure all information is still accurate.</description>
        <dueDateOffset>180</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Follow-up on KYC</subject>
    </tasks>
</Workflow>
