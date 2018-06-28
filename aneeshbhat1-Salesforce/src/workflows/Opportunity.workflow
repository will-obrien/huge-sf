<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>SendBrochure with Program</fullName>
        <actions>
            <name>SendBrochure</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <formula>ISNEW()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>SendBrochure</fullName>
        <assignedTo>arjun.mohan1@ef.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>SendBrochure</subject>
    </tasks>
</Workflow>
