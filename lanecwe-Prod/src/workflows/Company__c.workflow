<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_NZL_to_True</fullName>
        <field>NZL__c</field>
        <literalValue>1</literalValue>
        <name>Set NZL to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>*Update* Set NZL Flag %28Company%29</fullName>
        <actions>
            <name>Set_NZL_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3 OR 4</booleanFilter>
        <criteriaItems>
            <field>Company__c.TESLA_CountryCode__c</field>
            <operation>equals</operation>
            <value>NZL,New Zealand</value>
        </criteriaItems>
        <criteriaItems>
            <field>Company__c.TESLA_Territory_Code__c</field>
            <operation>equals</operation>
            <value>AP001,APA000,APA116,APN230,APN250,APN251,APN252,APN256,APN257,APN260</value>
        </criteriaItems>
        <criteriaItems>
            <field>Company__c.TESLA_Territory_Code__c</field>
            <operation>equals</operation>
            <value>APN262,D0964</value>
        </criteriaItems>
        <criteriaItems>
            <field>Company__c.TESLA_Enterprise__c</field>
            <operation>equals</operation>
            <value>Premiere Customers (NZL),Digital Island NZExternal,NZL Global Accounts</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
