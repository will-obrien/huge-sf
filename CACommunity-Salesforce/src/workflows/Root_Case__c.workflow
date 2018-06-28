<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>FUSetDateTimeOpened</fullName>
        <field>Date_Time_Opened__c</field>
        <formula>CreatedDate</formula>
        <name>FUSetDateTimeOpened</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>WFSetDateTimeOpened</fullName>
        <actions>
            <name>FUSetDateTimeOpened</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set Date/Time Opened for Root Cases</description>
        <formula>Date_Time_Opened__c  &lt;&gt;  CreatedDate</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
