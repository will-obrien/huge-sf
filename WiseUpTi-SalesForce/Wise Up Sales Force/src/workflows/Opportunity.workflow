<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Conf_pgto_wise_up</fullName>
        <description>Conf pgto Wise Up</description>
        <protected>false</protected>
        <recipients>
            <field>email_responsavel__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WU_Fluxos_automaticos/wu_confirmacao_pagamento</template>
    </alerts>
    <alerts>
        <fullName>Email_confirmacao_matricula_paga_wise_up</fullName>
        <description>E-mail de confirmação de matrícula paga</description>
        <protected>false</protected>
        <recipients>
            <field>email_responsavel__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WU_Fluxos_automaticos/wu_confirmacao_pagamento</template>
    </alerts>
    <alerts>
        <fullName>Email_confirmacao_matricula_paga_you_move</fullName>
        <description>E-mail de confirmação de matrícula paga</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WU_Fluxos_automaticos/ym_confirma_o_pagamento</template>
    </alerts>
    <alerts>
        <fullName>Email_wise_up_link_pagamento</fullName>
        <ccEmails>dsv@atile.com.br</ccEmails>
        <description>Email Wise UP - Link para pagamento</description>
        <protected>false</protected>
        <recipients>
            <field>email_responsavel__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WU_Fluxos_automaticos/wu_link_para_pagamento</template>
    </alerts>
    <alerts>
        <fullName>Email_wise_up_link_para_pagamento</fullName>
        <ccEmails>dsv@atile.com.br</ccEmails>
        <description>Email Wise UP - Link para pagamento</description>
        <protected>false</protected>
        <recipients>
            <field>email_responsavel__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WU_Fluxos_automaticos/wu_link_para_pagamento</template>
    </alerts>
    <alerts>
        <fullName>Email_you_move_link_para_pagamento</fullName>
        <ccEmails>dsv@atile.com.br</ccEmails>
        <description>Email You Move - Link para pagamento</description>
        <protected>false</protected>
        <recipients>
            <field>email_responsavel__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WU_Fluxos_automaticos/ym_link_para_pagamento</template>
    </alerts>
    <alerts>
        <fullName>Wise_up_email_confirmacao</fullName>
        <description>Wise Up E-mail de confirmação</description>
        <protected>false</protected>
        <recipients>
            <field>email_responsavel__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WU_Fluxos_automaticos/wu_confirmacao_pagamento</template>
    </alerts>
    <alerts>
        <fullName>You_move_email_confirmacao</fullName>
        <description>You Move E-mail de confirmação</description>
        <protected>false</protected>
        <recipients>
            <field>email_responsavel__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WU_Fluxos_automaticos/ym_confirma_o_pagamento</template>
    </alerts>
    <alerts>
        <fullName>ms_envia_email_link_pagamento</fullName>
        <description>ms - envia email link pagamento</description>
        <protected>false</protected>
        <recipients>
            <field>email_responsavel__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MS_Fluxos_automaticos/ms_aguardando_pagamento1</template>
    </alerts>
    <fieldUpdates>
        <fullName>Atualiza_data_hora_aux</fullName>
        <field>Data_hora_aux__c</field>
        <formula>NOW()+ 0.007</formula>
        <name>Atualiza data hora aux</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Atualiza_dt_hr_aux</fullName>
        <field>Data_hora_aux__c</field>
        <formula>NOW()</formula>
        <name>Atualiza data hora aux</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Atualiza_id_externo_meu_sucesso_opp_camp</fullName>
        <field>Id_meu_sucesso__c</field>
        <formula>Account.Id_meu_sucesso__c</formula>
        <name>Atualiza id externo meu sucesso opp camp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Atualiza_link_pagamento</fullName>
        <field>Link_pagamento__c</field>
        <formula>&apos;https://checkout.wiseup.com/?idOpp=&apos;&amp;Id</formula>
        <name>Atualiza link pagamento</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Atualiza_valor_matricula</fullName>
        <field>afinancecielo__Valor_Unico_Cartao__c</field>
        <formula>Valor_investimento_unico__c</formula>
        <name>Atualiza valor matrícula</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Atualiza_valor_mensalidade</fullName>
        <field>afinancecielo__Valor_Cobranca_Cartao__c</field>
        <formula>Valor_mensal__c</formula>
        <name>Atualiza valor mensalidade</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Id_Ometznet_email</fullName>
        <field>Id_Ometznet__c</field>
        <formula>Account.PersonContact.Email</formula>
        <name>Id Ometznet: email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Nome_oportunidade</fullName>
        <field>Name</field>
        <formula>Name + &apos; Venda&apos;</formula>
        <name>Nome da oportunidade</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>afinancecielo__Preenche_Valor_Cobranca_Oportunidade</fullName>
        <field>afinancecielo__Valor_Cobranca_Cartao__c</field>
        <formula>Amount</formula>
        <name>Preenche Valor de Cobrança - Oportunidad</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>atualiza_status_conta</fullName>
        <description>atualiza status da conta para arquivada</description>
        <field>Status__c</field>
        <literalValue>Arquivado</literalValue>
        <name>atualiza status conta</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>email_respons_vel_Conta</fullName>
        <field>email_responsavel__c</field>
        <formula>Account.PersonContact.Email</formula>
        <name>email responsável Conta</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>email_responsavel</fullName>
        <field>email_responsavel__c</field>
        <formula>Responsavel__r.Email</formula>
        <name>email responsável</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Atualiza critério data hora aux</fullName>
        <actions>
            <name>Atualiza_dt_hr_aux</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Matrícula paga</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Atualiza data hora auxiliar</fullName>
        <actions>
            <name>Atualiza_data_hora_aux</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ISPICKVAL(StageName,&apos;Matrícula paga&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Atualiza id externo meu sucesso na opp</fullName>
        <actions>
            <name>Atualiza_id_externo_meu_sucesso_opp_camp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ISNEW() || ISCHANGED(Id_meu_sucesso__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Completa nome oportunidade</fullName>
        <actions>
            <name>Nome_oportunidade</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Adiciona a palavra &quot;Venda&quot; após o nome da oportunidade</description>
        <formula>Name != &apos;&apos;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Link de pagamento</fullName>
        <actions>
            <name>Atualiza_link_pagamento</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Pré-matriculado</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Preenche valores</fullName>
        <actions>
            <name>Atualiza_valor_matricula</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Atualiza_valor_mensalidade</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ischanged(Amount) &amp;&amp; not(IsClosed)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Responsável maior de idade</fullName>
        <actions>
            <name>email_respons_vel_Conta</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( Account.IsPersonAccount = TRUE,
 Account.PersonContact.Idade__c &gt; 18)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Responsável menor de idade</fullName>
        <actions>
            <name>email_responsavel</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( Account.IsPersonAccount = TRUE,
 Account.PersonContact.Idade__c &lt; 18,
NOT(ISBLANK(Responsavel__c)))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tempo de avaliação</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Termino_periodo_avaliacao__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.IsWon</field>
            <operation>equals</operation>
            <value>Falso</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Fim_periodo_avaliacao</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Opportunity.Termino_periodo_avaliacao__c</offsetFromField>
            <timeLength>-1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>WIse Up - Confirmação de pagamento</fullName>
        <active>false</active>
        <formula>ISPICKVAL(StageName, &apos;Matrícula paga&apos;) &amp;&amp; CONTAINS(TEXT(Unidade_curso__r.Bandeira__c), &apos;Wise Up&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Wise_up_email_confirmacao</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Data_hora_aux__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>You Move - Confirmação de pagamento</fullName>
        <active>false</active>
        <formula>ISPICKVAL(StageName, &apos;Matrícula paga&apos;) &amp;&amp; ISPICKVAL(Unidade_curso__r.Bandeira__c, &apos;You Move&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>You_move_email_confirmacao</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Data_hora_aux__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>afinancecielo__Preenche Valor de Cobrança</fullName>
        <actions>
            <name>afinancecielo__Preenche_Valor_Cobranca_Oportunidade</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ISNEW() || ISCHANGED(Amount)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ms - Sempre que criado</fullName>
        <actions>
            <name>email_respons_vel_Conta</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>RecordType.Name = &apos;Assinatura meusucesso.com&apos;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>ms - aguardando pagamento</fullName>
        <actions>
            <name>ms_envia_email_link_pagamento</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Aguardando pagamento</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Assinatura meusucesso.com</value>
        </criteriaItems>
        <description>Quando uma oportunidade de meu sucesso mudar para fase aguardando pagamento, enviar um email com link de pagamento para o cliente</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ms - pagamento falhou</fullName>
        <actions>
            <name>Pagamento_da_assinatura_falhou</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Pagamento falhou</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>oportunidade perdida</fullName>
        <actions>
            <name>atualiza_status_conta</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Fechado e perdido</value>
        </criteriaItems>
        <description>Quando perder a oportunidade, deve mudar o status da conta para arquivada</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>wu - confirmação de pagamento</fullName>
        <actions>
            <name>Conf_pgto_wise_up</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Envia um e-mail ao cliente qnd o status da oportunidade muda para matrícula paga. (Wise Up)</description>
        <formula>ISPICKVAL(StageName, &apos;Matrícula paga&apos;) &amp;&amp; CONTAINS(TEXT(Unidade_curso__r.Bandeira__c), &apos;Wise Up&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_confirmacao_matricula_paga_wise_up</name>
                <type>Alert</type>
            </actions>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>wu - pré matriculado</fullName>
        <actions>
            <name>Email_wise_up_link_pagamento</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Quando mudar o status para pre-matriculado, enviar email com link para pagamento ao aluno</description>
        <formula>ISPICKVAL(StageName,&apos;Pré-matriculado&apos;) 
&amp;&amp; CONTAINS(TEXT(Unidade_curso__r.Bandeira__c), &apos;Wise Up&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ym - confirmação de pagamento</fullName>
        <actions>
            <name>Email_confirmacao_matricula_paga_you_move</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Envia um e-mail ao cliente qnd o status da oportunidade muda para matrícula paga. (You Move)</description>
        <formula>ISPICKVAL(StageName, &apos;Matrícula paga&apos;) &amp;&amp; ISPICKVAL(Unidade_curso__r.Bandeira__c, &apos;You Move&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ym - pré matriculado</fullName>
        <actions>
            <name>Email_you_move_link_para_pagamento</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Quando mudar o status para pre-matriculado, enviar email com link para pagamento ao aluno do you move</description>
        <formula>ISPICKVAL(StageName,&apos;Pré-matriculado&apos;)
&amp;&amp; ISPICKVAL(Unidade_curso__r.Bandeira__c,&apos;You Move&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Fim_periodo_avaliacao</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Alto</priority>
        <protected>false</protected>
        <status>Não iniciado</status>
        <subject>Fim do período de avaliação</subject>
    </tasks>
    <tasks>
        <fullName>Pagamento_da_assinatura_falhou</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Não iniciado</status>
        <subject>Pagamento da assinatura falhou</subject>
    </tasks>
</Workflow>
