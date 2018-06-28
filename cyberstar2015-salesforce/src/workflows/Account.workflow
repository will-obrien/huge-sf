<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UpdateOwner</fullName>
        <field>OwnerId</field>
        <lookupValue>mehdi@eisos.fr</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>UpdateOwner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>testNadia</fullName>
        <field>AccountSource</field>
        <literalValue>Web</literalValue>
        <name>testNadia</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <tasks>
        <fullName>test</fullName>
        <assignedTo>mehdi@eisos.fr</assignedTo>
        <assignedToType>user</assignedToType>
        <description>OK</description>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>test</subject>
    </tasks>
</Workflow>
