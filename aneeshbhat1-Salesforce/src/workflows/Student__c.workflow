<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Poor_Performance</fullName>
        <description>Some description</description>
        <protected>false</protected>
        <recipients>
            <field>Parentt_MailID__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Poor_performance</template>
    </alerts>
    <fieldUpdates>
        <fullName>InformedParentStatus</fullName>
        <field>InformParent__c</field>
        <literalValue>1</literalValue>
        <name>InformedParentStatus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Poor Performance</fullName>
        <actions>
            <name>Poor_Performance</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>InformedParentStatus</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Blah_Blah_Blah</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Student__c.Aggregate__c</field>
            <operation>lessThan</operation>
            <value>60</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>Blah_Blah_Blah</fullName>
        <assignedTo>aneesh.bhat@ef.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>hk[pcogj[n;</description>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Blah Blah Blah!</subject>
    </tasks>
</Workflow>
