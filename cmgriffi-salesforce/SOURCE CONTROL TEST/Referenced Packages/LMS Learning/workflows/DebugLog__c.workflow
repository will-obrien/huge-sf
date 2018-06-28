<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Test_email</fullName>
        <description>Test email</description>
        <protected>false</protected>
        <recipients>
            <field>Recipient__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LMS/Debug_Log</template>
    </alerts>
    <rules>
        <fullName>Send Debug Email</fullName>
        <actions>
            <name>Test_email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>DebugLog__c.Recipient__c</field>
            <operation>contains</operation>
            <value>@</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
