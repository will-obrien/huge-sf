<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Preenche_Valor_Cobranca_Oportunidade</fullName>
        <field>Valor_Cobranca_Cartao__c</field>
        <formula>Amount</formula>
        <name>Preenche Valor de Cobrança - Oportunidad</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Preenche Valor de Cobrança</fullName>
        <actions>
            <name>Preenche_Valor_Cobranca_Oportunidade</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ISNEW() || ISCHANGED(Amount)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
