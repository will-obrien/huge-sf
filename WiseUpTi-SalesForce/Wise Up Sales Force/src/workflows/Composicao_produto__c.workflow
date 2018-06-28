<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Prenche_Id_Unico</fullName>
        <field>Id_Unico__c</field>
        <formula>Produto_pai__c &amp; Produto_filho__c</formula>
        <name>Prenche Id Único</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Preenche Id Unico</fullName>
        <actions>
            <name>Prenche_Id_Unico</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TRUE</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
