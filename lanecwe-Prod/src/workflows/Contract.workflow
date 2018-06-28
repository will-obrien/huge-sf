<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_30_Day_Contract_Expiration_Email</fullName>
        <description>Send 30 Day Contract Expiration Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Send_30_60_90</template>
    </alerts>
    <alerts>
        <fullName>Send_60_Day_Contract_Expiration_Email</fullName>
        <description>Send 60 Day Contract Expiration Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Send_30_60_90</template>
    </alerts>
    <alerts>
        <fullName>Send_90_Day_Contract_Expiration_Email</fullName>
        <description>Send 90 Day Contract Expiration Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Send_30_60_90</template>
    </alerts>
    <rules>
        <fullName>Send 30 Day Contract Expiration Email</fullName>
        <actions>
            <name>Send_30_Day_Contract_Expiration_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(ISPICKVAL(OwnerExpirationNotice, &apos;30 Days&apos;),   EndDate - 30 = TODAY() )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send 60 Day Contract Expiration Email</fullName>
        <actions>
            <name>Send_60_Day_Contract_Expiration_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(ISPICKVAL(OwnerExpirationNotice, &apos;60 Days&apos;), EndDate - 60 = TODAY() )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send 90 Day Contract Expiration Email</fullName>
        <actions>
            <name>Send_90_Day_Contract_Expiration_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(ISPICKVAL(OwnerExpirationNotice, &apos;90 Days&apos;), EndDate - 90 = TODAY() )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
