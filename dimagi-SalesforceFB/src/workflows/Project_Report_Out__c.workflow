<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Project_Report_Out_Send_Email</fullName>
        <description>Project Report Out: Send Email to Owner</description>
        <protected>false</protected>
        <recipients>
            <field>PM_email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Dimagi_Emails/Project_Report_Out_HTML</template>
    </alerts>
    <alerts>
        <fullName>Project_Report_Out_Send_Email_Dev_Work</fullName>
        <description>Project Report Out: Send Email to Owner Dev Work</description>
        <protected>false</protected>
        <recipients>
            <field>PM_email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Dimagi_Emails/Project_Report_Out_Dev_Work_HTML</template>
    </alerts>
    <fieldUpdates>
        <fullName>Project_Report_Out_Name</fullName>
        <description>Sets the report out name to Contract Name - [date]</description>
        <field>Name</field>
        <formula>Contract__r.Name &amp; &quot; - [&quot; &amp;  TEXT(Report_Out_Date__c) &amp; &quot;]&quot;</formula>
        <name>Project Report Out Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Project Report Out%3A Email Out</fullName>
        <actions>
            <name>Project_Report_Out_Send_Email</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Sends email to everyone on the distribution list for a contract when a report out is created.</description>
        <formula>NOT(Contract__r.Requires_Developer_Work__c)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Project Report Out%3A Email Out Dev Work</fullName>
        <actions>
            <name>Project_Report_Out_Send_Email_Dev_Work</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Sends email to everyone on the distribution list for a contract when a report out is created.</description>
        <formula>Contract__r.Requires_Developer_Work__c</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Project Report Out%3A Name</fullName>
        <actions>
            <name>Project_Report_Out_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Contract__c )   ||  ISCHANGED( Report_Out_Date__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
