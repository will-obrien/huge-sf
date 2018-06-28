<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Atualiza_campo_cpf_validado</fullName>
        <field>CPF_validado__c</field>
        <literalValue>0</literalValue>
        <name>Atualiza campo cpf validado</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Atualiza_campo_status_integracao</fullName>
        <field>Status_integracao_ometznet__c</field>
        <name>Atualiza campo status integração</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Atualiza_data_nascimento_padrao_campo</fullName>
        <field>PersonBirthdate</field>
        <formula>Data_nascimento__pc</formula>
        <name>Atualiza data nascimento padrão - campo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Atualiza_id_conta_com_id_conta_campo</fullName>
        <field>Id_meu_sucesso__pc</field>
        <formula>Id_meu_sucesso__c</formula>
        <name>Atualiza id conta com id conta campo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Atualiza_personbirthdate_field</fullName>
        <field>PersonBirthdate</field>
        <formula>Data_nascimento__pc</formula>
        <name>Atualiza personbirthdate_field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Bairro_entrega_Bairro_cobranca</fullName>
        <field>Bairro_endereco_entrega__c</field>
        <formula>Bairro_endereco_cobranca__c</formula>
        <name>Bairro entrega: Bairro cobrança</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Cidade_entrega_Cidade_cobranca</fullName>
        <field>Cidade_endereco_entrega__c</field>
        <formula>Cidade_endereco_cobranca__c</formula>
        <name>Cidade entrega: Cidade cobrança</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Complemento_entrega_Complemento_cobranc</fullName>
        <field>Complemento_endereco_entrega__c</field>
        <formula>Complemento_endereco_cobranca__c</formula>
        <name>Complemento entrega: Complemento cobranç</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Numero_Entrega_Numero_cobranca</fullName>
        <field>Numero_endereco_entrega__c</field>
        <formula>Numero_endereco_cobranca__c</formula>
        <name>Número Entrega: Número cobrança</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rua_entrega_Rua_cobran_a</fullName>
        <field>Rua_endereco_entrega__c</field>
        <formula>Rua_endereco_cobranca__c</formula>
        <name>Rua entrega: Rua cobrança</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>atualiza_cpf_validado_contato</fullName>
        <field>CPF_contato_validado__pc</field>
        <literalValue>1</literalValue>
        <name>atualiza cpf validado contato</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Atualiza data nascimento padrão</fullName>
        <actions>
            <name>Atualiza_data_nascimento_padrao_campo</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IsPersonAccount &amp;&amp; isChanged(Data_nascimento__pc)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Atualiza id externo meu sucesso</fullName>
        <actions>
            <name>Atualiza_id_conta_com_id_conta_campo</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>(ISNEW() || ISCHANGED(Id_meu_sucesso__c) ) &amp;&amp; IsPersonAccount</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Atualiza personbirthdate</fullName>
        <actions>
            <name>Atualiza_personbirthdate_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>IsPersonAccount</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Endereço de entrega vazio</fullName>
        <actions>
            <name>Bairro_entrega_Bairro_cobranca</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Cidade_entrega_Cidade_cobranca</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Complemento_entrega_Complemento_cobranc</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Numero_Entrega_Numero_cobranca</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Rua_entrega_Rua_cobran_a</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>OR (ISBLANK( Rua_endereco_entrega__c ),
   ISBLANK(  Cidade_endereco_entrega__c ),
   ISPICKVAL(  Estado_endereco_entrega__c ,&apos;&apos; )
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Preenche CPF do contato validado</fullName>
        <actions>
            <name>atualiza_cpf_validado_contato</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>isChanged(CPF_validado__c) &amp;&amp; CPF_validado__c = true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Validação de cpf na edição do campo</fullName>
        <actions>
            <name>Atualiza_campo_cpf_validado</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Atualiza_campo_status_integracao</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>isChanged(CPF__pc)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
