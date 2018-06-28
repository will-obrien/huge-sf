<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Contract_Requires_Dev_Work</fullName>
        <description>Sets the field to TRUE when the Opportunity Requires Dev Work field it&apos;s checked.</description>
        <field>Requires_Developer_Work__c</field>
        <literalValue>1</literalValue>
        <name>Set Contract Requires Dev Work</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Contract__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Contract from Opportunity</fullName>
        <actions>
            <name>Set_Contract_Requires_Dev_Work</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Requires_Developer_Work__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set field values of Contract created from Opportunities.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
