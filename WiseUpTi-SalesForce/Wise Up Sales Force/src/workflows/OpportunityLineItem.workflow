<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Atualiza_preco_unitario</fullName>
        <field>UnitPrice</field>
        <formula>IF( Forma_cobranca__c = &apos;Recorrente&apos;,  IF(ISBLANK(Valor_unitario_periodo__c), PricebookEntry.UnitPrice , Valor_unitario_periodo__c) * Product2.Duracao_contrato__c,
 IF(ISBLANK(Valor_unitario_periodo__c), PricebookEntry.UnitPrice , Valor_unitario_periodo__c)
 
)</formula>
        <name>Atualiza preço unitario</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calcula_valor_bolsista</fullName>
        <field>Valor_minimo__c</field>
        <formula>PricebookEntry.Valor_minimo__c</formula>
        <name>Calcula valor bolsista</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calcula_valor_periodo</fullName>
        <field>Valor_unitario_periodo__c</field>
        <formula>ListPrice</formula>
        <name>Calcula valor no período</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calcula_valor_periodo_lista</fullName>
        <field>Valor_periodo_lista__c</field>
        <formula>ListPrice</formula>
        <name>Calcula valor no período (lista)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Forma_Cobranca</fullName>
        <description>Copia a forma de cobrança do produto</description>
        <field>Forma_cobranca__c</field>
        <formula>TEXT( PricebookEntry.Product2.Forma_cobranca__c )</formula>
        <name>Forma de Cobrança</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Produto_exclusivo_oportunidade</fullName>
        <description>Pacote - Produto exclusivo na oportunidade</description>
        <field>Exclusivo__c</field>
        <formula>OpportunityId + PricebookEntryId</formula>
        <name>Produto exclusivo oportunidade</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Preco unitario vazio</fullName>
        <actions>
            <name>Calcula_valor_periodo</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Valor_unitario_periodo__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Atualiza o campo somente se o valor unitário no perído não for preenchido na inclusão</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Produto exclusivo na oportunidade</fullName>
        <actions>
            <name>Produto_exclusivo_oportunidade</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Pacote - Produto exclusivo na oportunidade</description>
        <formula>TRUE</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Quando alterado o preço</fullName>
        <actions>
            <name>Atualiza_preco_unitario</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Valor_unitario_periodo__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Sempre que criado</fullName>
        <actions>
            <name>Atualiza_preco_unitario</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calcula_valor_bolsista</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calcula_valor_periodo_lista</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Forma_Cobranca</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TRUE</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
