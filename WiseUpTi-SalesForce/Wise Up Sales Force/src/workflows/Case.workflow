<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>afinancecielo__Preenche_Valor_Cobranca_Caso</fullName>
        <field>afinancecielo__Valor_Cobranca_Cartao__c</field>
        <formula>afinance__Amount__c</formula>
        <name>Preenche Valor de Cobrança - Caso</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>afinancecielo__Preenche Valor de Cobrança</fullName>
        <actions>
            <name>afinancecielo__Preenche_Valor_Cobranca_Caso</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISNEW() || ISCHANGED(afinance__Amount__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
