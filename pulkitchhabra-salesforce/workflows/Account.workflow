<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Select_Type_of_Client</fullName>
        <description>Selects type of client depending on the Record type of the account</description>
        <field>Type_Of_Client__c</field>
        <formula>IF( RecordType.Id = &apos;01228000000PK9P&apos;, &quot;Advertiser&quot;,  (IF(RecordType.Id = &apos;01228000000PK9U&apos;, &quot;Agency&quot;, Null)))</formula>
        <name>Select Type of Client</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uni</fullName>
        <field>Account_Owner_Email__c</field>
        <formula>$User.Email</formula>
        <name>Uni</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Message_to_IC</fullName>
        <apiVersion>34.0</apiVersion>
        <description>Outbond Message to Informatica Cloud on record Upsert for updating the MySQL database on real time</description>
        <endpointUrl>https://app2.informaticacloud.com/saas/api/1/salesforceoutboundmessage/MnhEZHtsYGW1uZGFtJGkqwDQRFm3CjHL</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>pkrchhabra@hotmail.com</integrationUser>
        <name>Message to IC</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Msg_to_IC</fullName>
        <apiVersion>34.0</apiVersion>
        <endpointUrl>https://app2.informaticacloud.com/saas/api/1/salesforceoutboundmessage/MnhEZHtsYGW1uZGFtJGkqwDQRFm3CjHL</endpointUrl>
        <fields>AccountNumber</fields>
        <fields>Id</fields>
        <fields>Name</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>pkrchhabra@hotmail.com</integrationUser>
        <name>Msg to IC</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Email Sending</fullName>
        <actions>
            <name>Uni</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.CreatedDate</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Outbond msg rule</fullName>
        <actions>
            <name>Msg_to_IC</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Select Type of Client</fullName>
        <actions>
            <name>Select_Type_of_Client</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Advertiser,Agency</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
