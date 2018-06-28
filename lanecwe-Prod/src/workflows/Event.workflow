<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Copy_Activity_Type_over</fullName>
        <field>Copy_of_Activity_Type__c</field>
        <formula>TEXT(Type)</formula>
        <name>Copy Activity Type over</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Last_Mod_Date_by_Non_Admin</fullName>
        <field>Last_modified_Date_by_non_admin__c</field>
        <formula>NOW()</formula>
        <name>Set Last Mod Date by Non-Admin</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Copy Type</fullName>
        <actions>
            <name>Copy_Activity_Type_over</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(        ISNEW(),        ISCHANGED(Type) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Channel</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Event.OwnerId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Sets the event channel to the user&apos;s channel</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Last Mod Date by Non-Admin</fullName>
        <actions>
            <name>Set_Last_Mod_Date_by_Non_Admin</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>PGi Admin Lite,System Administrator,System Administrator (No Expires)</value>
        </criteriaItems>
        <description>Sets the Last Modified Date by Non-Admin Functions</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
