<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Active_to_False</fullName>
        <field>IsActive</field>
        <literalValue>0</literalValue>
        <name>Set Active to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Active_to_True</fullName>
        <field>IsActive</field>
        <literalValue>1</literalValue>
        <name>Set Active to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
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
    <fieldUpdates>
        <fullName>Set_Status_to_Completed</fullName>
        <field>Status</field>
        <literalValue>Completed</literalValue>
        <name>Set Status to Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_to_In_Progress</fullName>
        <field>Status</field>
        <literalValue>In Progress</literalValue>
        <name>Set Status to In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set Active to True and Status to In Progress</fullName>
        <actions>
            <name>Set_Active_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Status_to_In_Progress</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>IF( StartDate  &lt;=  TODAY(), True, False)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Active to True and Status to In Progress Future</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.EndDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.StartDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Set_Active_to_False</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Set_Status_to_Completed</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Campaign.EndDate</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Set_Active_to_True</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Set_Status_to_In_Progress</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Campaign.StartDate</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
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
