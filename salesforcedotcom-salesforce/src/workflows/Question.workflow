<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>X01RE00000001CTz</fullName>
        <description>Priority</description>
        <field>Priority</field>
        <literalValue>high</literalValue>
        <name>chatter_answers_num_subscriptions_above_</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>chatter_answers_no_best_reply_within_time_limit_wf</fullName>
        <active>false</active>
        <formula>NOT(ISPICKVAL(Priority,&apos;high&apos;)) &amp;&amp; ISBLANK(BestReplyId)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>X01RE00000001CTz</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Question.CreatedDate</offsetFromField>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>chatter_answers_num_subscriptions_above_limit_wf</fullName>
        <actions>
            <name>X01RE00000001CTz</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>NOT(ISPICKVAL(Priority,&apos;high&apos;)) &amp;&amp; ISBLANK(BestReplyId) &amp;&amp; NumSubscriptions &gt;= 20</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
