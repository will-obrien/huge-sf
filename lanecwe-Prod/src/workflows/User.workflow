<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Approaching_Contract_End</fullName>
        <description>Approaching Contract End</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Approaching_Contract_End_Anniversary_Date</template>
    </alerts>
    <alerts>
        <fullName>Approaching_Contract_End_Managers</fullName>
        <description>Approaching Contract End - Managers</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Approaching_Contract_End_Anniversary_Date_Manager</template>
    </alerts>
    <alerts>
        <fullName>Reminder_Canada_Anti_Spam</fullName>
        <ccEmails>andrew.davidson@pgi.com</ccEmails>
        <description>Reminder: Canada Anti-Spam</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>User_Notifications/Reminder_Canada_Anti_Spam</template>
    </alerts>
    <fieldUpdates>
        <fullName>Date_for_Next_Report_Trigger_Update</fullName>
        <field>Date_for_Next_Report_Trigger__c</field>
        <formula>DATE( 
YEAR(Date_for_report_trigger__c), MONTH(Date_for_report_trigger__c) + 1, DAY(Date_for_report_trigger__c)
)</formula>
        <name>Date for Next Report Trigger Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Report_Trigger_Start_Always_1st_of_Prev</fullName>
        <field>Report_Trigger_Start__c</field>
        <formula>IF(
    
    MONTH(Report_Trigger_Start__c)=1,
        
    DATE(
        YEAR(Report_Trigger_Start__c)-1,
        MONTH(Report_Trigger_Start__c)-1,
        DAY(Report_Trigger_Start__c) - DAY(Report_Trigger_Start__c)+1),
        
    DATE(
        YEAR(Report_Trigger_Start__c),
        MONTH(Report_Trigger_Start__c)-1,
        DAY(Report_Trigger_Start__c) - DAY(Report_Trigger_Start__c)+1)
)</formula>
        <name>Report Trigger Start Always 1st of Prev</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TTrigDate_for_Next_Report_Trigger_Update</fullName>
        <field>Date_for_report_trigger__c</field>
        <formula>Date_for_Next_Report_Trigger__c</formula>
        <name>TTrigDate for Next Report Trigger Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Date_for_Report_Trigger</fullName>
        <field>Date_for_report_trigger__c</field>
        <formula>DATE(
YEAR(Report_Trigger_Start__c), MONTH(Report_Trigger_Start__c) + 1, DAY(Report_Trigger_Start__c)
)</formula>
        <name>Update Date for Report Trigger</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Email reminder to set permission set for Canada user</fullName>
        <actions>
            <name>Reminder_Canada_Anti_Spam</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Channel__c</field>
            <operation>equals</operation>
            <value>Canada</value>
        </criteriaItems>
        <description>reminds if they didnt add the permission set for Canada Anti-Spam to add it to this user</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Report Trigger Start Always 1st of Prev Month</fullName>
        <actions>
            <name>Report_Trigger_Start_Always_1st_of_Prev</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>User.Business_Role__c</field>
            <operation>equals</operation>
            <value>1st Level Management,2nd Level Management,Rep</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Report_Trigger_Start__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Report Trigger Update</fullName>
        <active>false</active>
        <description>Working on logic currently.</description>
        <formula>AND( OR(  Date_for_report_trigger__c = TODAY(),   !ISBLANK(Report_Trigger_Start__c)  ),  ISPICKVAL(Business_Role__c, &quot;Rep&quot;)  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Approaching_Contract_End</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Date_for_Next_Report_Trigger_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>User.Date_for_report_trigger__c</offsetFromField>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>TTrigDate_for_Next_Report_Trigger_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>User.Date_for_Next_Report_Trigger__c</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Report Trigger Update - Managers</fullName>
        <active>false</active>
        <description>Working on logic currently.</description>
        <formula>AND( OR(  Date_for_report_trigger__c = TODAY(),   !ISBLANK(Report_Trigger_Start__c)  ), OR(  ISPICKVAL(Business_Role__c, &quot;1st Level Management&quot;),   ISPICKVAL(Business_Role__c, &quot;2nd Level Management&quot;)  )  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>TTrigDate_for_Next_Report_Trigger_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>User.Date_for_Next_Report_Trigger__c</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Approaching_Contract_End_Managers</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Date_for_Next_Report_Trigger_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>User.Date_for_report_trigger__c</offsetFromField>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
