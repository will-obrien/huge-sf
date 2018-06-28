<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>A_Altera_fila_lead</fullName>
        <field>OwnerId</field>
        <lookupValue>Meu_Sucesso</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>A_Altera fila do lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Atualiza_proprietario_lead</fullName>
        <field>OwnerId</field>
        <lookupValue>integracao@wiseup.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Atualiza proprietário do lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>B_Limpar_data_reatribuicao</fullName>
        <field>Data_para_reatribuir_lead__c</field>
        <name>B_Limpar data reatribuição</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Duplicidade_email_email</fullName>
        <field>Duplicidade_email__c</field>
        <formula>Email</formula>
        <name>Duplicidade email: email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Limpa_motivo_do_arquivamento</fullName>
        <field>Motivo_arquivamento__c</field>
        <name>Limpa motivo do arquivamento</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Enviar_ometznet</fullName>
        <field>Status</field>
        <literalValue>Enviar para Ometznet</literalValue>
        <name>Status: Enviar para ometznet</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_devolvido_omtznet</fullName>
        <field>Status</field>
        <literalValue>Enviar para Ometznet</literalValue>
        <name>Status devolvido omtznet</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WF_WUP_Atribuir_diretor_comercial</fullName>
        <field>WF_WUP_Atribuir_diretor_comercial__c</field>
        <literalValue>1</literalValue>
        <name>#WF: WUP - Atribuir diretor comercial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WF_WUP_Devolver_lead_OmetzNet</fullName>
        <field>WF_WUP_Devolver_lead_OmetzNet__c</field>
        <literalValue>1</literalValue>
        <name>#WF: WUP - Devolver lead OmetzNet</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WF_WUP_Integrar_lead_criado_SF</fullName>
        <field>WF_WUP_Integrar_lead_criado_SF__c</field>
        <literalValue>1</literalValue>
        <name>#WF: WUP - Integrar lead criado SF</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Brave Club</fullName>
        <actions>
            <name>Atualiza_proprietario_lead</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Leads com o tipo Brave Club serão atribuídos para o usuário Admin Integração</description>
        <formula>TEXT(LeadSource) == &apos;Brave Club&apos;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Duplicidade de email</fullName>
        <actions>
            <name>Duplicidade_email_email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Email</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Esta regra está desativada pois é necessário receber leads que já tenham sido cadastrados por conta das campanhas de marketing.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead na lista de espera</fullName>
        <active>true</active>
        <formula>AND( ISPICKVAL(Negocio__c,&apos;meusucesso.com&apos;),  RecordType.Name = &apos;meuSucesso.com&apos;,   ISPICKVAL(Status,&apos;Novo&apos;),  Owner:Queue.QueueName = &apos;meuSucesso Lista de espera&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>A_Altera_fila_lead</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Lead.CreatedDate</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Limpa motivo do arquivamento</fullName>
        <actions>
            <name>Limpa_motivo_do_arquivamento</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>notEqual</operation>
            <value>Não qualificado</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Reatribuir Lead - Limite da fila excedido</fullName>
        <active>true</active>
        <formula>AND( ISPICKVAL(Negocio__c,&apos;meusucesso.com&apos;), RecordType.Name = &apos;meuSucesso.com&apos;, ISPICKVAL(Status,&apos;Novo&apos;), Owner:Queue.QueueName = &apos;meuSucesso Lista de espera&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>A_Altera_fila_lead</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>B_Limpar_data_reatribuicao</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Lead.Data_para_reatribuir_lead__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>WUP - Atribuir diretor comercial</fullName>
        <actions>
            <name>WF_WUP_Atribuir_diretor_comercial</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($User.Department &lt;&gt; &apos;Comercial&apos;, RecordType.Name = &apos;Wise Up&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WUP - Devolver lead OmetzNet</fullName>
        <actions>
            <name>WF_WUP_Devolver_lead_OmetzNet</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(Status__c = &apos;Novo&apos;, Owner:Queue.DeveloperName = &apos;Wise_Up_OmetzNet&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WUP - Integrar lead criado SF</fullName>
        <actions>
            <name>WF_WUP_Integrar_lead_criado_SF</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($Profile.Name != &apos;Integração&apos;,  RecordType.Name = &apos;Wise Up&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
