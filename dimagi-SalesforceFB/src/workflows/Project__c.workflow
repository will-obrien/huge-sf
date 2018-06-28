<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>tresting</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Project__c.Area__c</field>
            <operation>equals</operation>
            <value>Health</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
