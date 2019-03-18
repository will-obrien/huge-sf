<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>BRD_Request</fullName>
        <ccEmails>andrew.davidson@pgi.com</ccEmails>
        <description>BRD Request</description>
        <protected>false</protected>
        <recipients>
            <field>Business_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cases/BRD_Request</template>
    </alerts>
    <alerts>
        <fullName>Email_alert_for_Service_Support_Cases</fullName>
        <description>Email alert for Service/Support Cases</description>
        <protected>false</protected>
        <recipients>
            <recipient>andrew.davidson@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>iMeet_Cares_Templates/New_Case_Notification</template>
    </alerts>
    <alerts>
        <fullName>Email_alert_of_Emergency_Request</fullName>
        <description>Email alert of Emergency Request</description>
        <protected>false</protected>
        <recipients>
            <recipient>andrew.davidson@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>carmen.legrange@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>margot.mosley@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mike.coon@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cases/Emergency_Request_Notification</template>
    </alerts>
    <alerts>
        <fullName>Email_alert_of_Emergency_Request_Completed</fullName>
        <description>Email alert of Emergency Request Completed</description>
        <protected>false</protected>
        <recipients>
            <recipient>andrew.davidson@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>carmen.legrange@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>margot.mosley@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mike.coon@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cases/Emergency_Request_Completed_Notification</template>
    </alerts>
    <alerts>
        <fullName>Email_alert_of_Ready_for_IT_QC</fullName>
        <description>Email alert of Ready for IT QC</description>
        <protected>false</protected>
        <recipients>
            <recipient>andrew.davidson@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cases/New_WFR_Notification</template>
    </alerts>
    <alerts>
        <fullName>Email_alert_to_inform_of_password_reset_needed</fullName>
        <description>Email alert to inform of password reset needed.</description>
        <protected>false</protected>
        <recipients>
            <recipient>andrew.davidson@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>carmen.legrange@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SFDC_Reset_Password</template>
    </alerts>
    <alerts>
        <fullName>Email_any_updates_to_relevant_case_fields</fullName>
        <ccEmails>reporting@pgi.com</ccEmails>
        <description>Email any updates to relevant case fields</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>bisupport@pgi.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cases/PGiBI_Case_Fields_Update</template>
    </alerts>
    <alerts>
        <fullName>Email_closed_Case</fullName>
        <ccEmails>andrew.davidson@pgi.com</ccEmails>
        <description>Email closed Case</description>
        <protected>false</protected>
        <recipients>
            <field>Submitted_By_Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>salesforcecrmsupport@pgi.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Workflow_Emails/Automated_Case_Closed_Email</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_of_New_Feature_Request</fullName>
        <description>Email notification of New Feature Request</description>
        <protected>false</protected>
        <recipients>
            <recipient>Sales_Engineers</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>Sales_Engineers_APAC</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>Sales_Engineers_EMEA</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>andrew.davidson@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>joe.yang@pgi.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>iMeet_Cares_Templates/New_Feature_Request</template>
    </alerts>
    <alerts>
        <fullName>Email_notifying_of_Priority_change</fullName>
        <description>Email notifying of Priority change</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>andrew.davidson@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforcecrmsupport@pgi.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cases/SFDC_Notify_of_Priority_Change</template>
    </alerts>
    <alerts>
        <fullName>PGiBI_Email_closed_Case_No_Contact_Email</fullName>
        <description>PGiBI-Email closed Case (No Contact Email)</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>bisupport@pgi.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Workflow_Emails/Automated_Case_Closed_Email</template>
    </alerts>
    <alerts>
        <fullName>PGiBI_Send_Email_when_case_closed</fullName>
        <description>PGiBI-Send Email when case closed</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>bisupport@pgi.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Workflow_Emails/SFDC_NA_Automated_Case_Closed_Email_Contacts</template>
    </alerts>
    <alerts>
        <fullName>SFDC_EMEA_Email_on_case_closed</fullName>
        <ccEmails>andrew.davidson@pgi.com</ccEmails>
        <description>SFDC EMEA - Email on case closed</description>
        <protected>false</protected>
        <recipients>
            <field>Submitted_By_Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_Emails/Automated_Case_Closed_Email</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_when_case_closed</fullName>
        <description>Send Email when case closed</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>andrew.davidson@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforcecrmsupport@pgi.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Workflow_Emails/SFDC_NA_Automated_Case_Closed_Email_Contacts</template>
    </alerts>
    <alerts>
        <fullName>Send_auto_response_to_submitter</fullName>
        <description>Send auto-response to submitter</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>salesforcecrmsupport@pgi.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Auto_Response_Templates/SFDC_Auto_Response</template>
    </alerts>
    <alerts>
        <fullName>Send_email_when_case_escalated</fullName>
        <description>Send email when case escalated</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SUPPORTCaseescalationnotificationSAMPLE</template>
    </alerts>
    <fieldUpdates>
        <fullName>Assign_to_APAC_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>APAC_SFDC_Support</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to APAC Queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_EMEA_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>EMEA_SFDC_Support</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to EMEA Queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_NA_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>NA_SFDC_Support</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to NA Queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_SFDC_Tier_2_queue</fullName>
        <field>OwnerId</field>
        <lookupValue>SFDCSupport_Tier_2</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to SFDC Tier 2 queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Tier_3_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>SFDCSupport_Tier_3</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to Tier 3 Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_Accepted_to_Scheduled_Release</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Scheduled_Release</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>CRM Accepted to Scheduled Release</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Owner_to_Sys_Admin_Test_User</fullName>
        <field>OwnerId</field>
        <lookupValue>test.user@pgi.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Change Owner to Sys Admin Test User</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Case_Number</fullName>
        <field>NS_Case_Number__c</field>
        <formula>MID(Description, 7, 7)</formula>
        <name>Copy Case Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Web_Email_to_Submitted_by_User</fullName>
        <field>Submitted_By_Contact_Email__c</field>
        <formula>SuppliedEmail</formula>
        <name>Copy Web Email to Submitted by User</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_Time_Accepted_by_CRM_Team</fullName>
        <field>Date_Time_Accepted_by_CRM_Team__c</field>
        <formula>NOW()</formula>
        <name>Date/Time Accepted by CRM Team</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Enhancement_Request_False</fullName>
        <description>Iif you change the owner away from an owner thats not the *SFDC Support* Escalation Request queue to the *SFDC Support* Escalation Request queue. Service/Support Request = True, Enhancement Request = False</description>
        <field>Enhancement_Request__c</field>
        <literalValue>0</literalValue>
        <name>Enhancement Request False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Enhancement_Request_True</fullName>
        <field>Enhancement_Request__c</field>
        <literalValue>1</literalValue>
        <name>Enhancement Request True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>On_Hold_Update</fullName>
        <field>Most_Recent_On_Hold_Date__c</field>
        <formula>TODAY()</formula>
        <name>On Hold Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ready_For_Sales_Ops_QC_Date</fullName>
        <field>Ready_for_Sales_Ops_QC_Date__c</field>
        <formula>TODAY()</formula>
        <name>Ready For Sales Ops QC Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reassign_Ownership_to_the_Queue</fullName>
        <description>Set Case owner to *SFDC Support* Ready for Release queue</description>
        <field>OwnerId</field>
        <lookupValue>SFDC_Support_Ready_for_Release</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Reassign Case owner  to Ready for Rel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Service_Support_Request_False</fullName>
        <field>Service_Support__c</field>
        <literalValue>0</literalValue>
        <name>Service/Support Request False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Assigned_to_True</fullName>
        <field>Assigned__c</field>
        <literalValue>1</literalValue>
        <name>Set Assigned to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_Assignment_Date</fullName>
        <field>Case_Assignment_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Set Case Assignment Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_Reason_to_Feedback</fullName>
        <description>Used for Post GO LIVE Feedback requests Globally.</description>
        <field>Reason</field>
        <literalValue>Feedback</literalValue>
        <name>Set Case Reason to Feedback</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_Support_Type_to_Bug_Fix</fullName>
        <field>Case_Support_Type__c</field>
        <literalValue>Bug/Fix</literalValue>
        <name>Set Case Support Type to Bug/Fix</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_Support_Type_to_Enhancement</fullName>
        <field>Case_Support_Type__c</field>
        <literalValue>Enhancement Request</literalValue>
        <name>Set Case Support Type to Enhancement</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_DS_Sign_URL</fullName>
        <field>DS_Sign_URL__c</field>
        <formula>LEFT(
RIGHT(Description, LEN(Description) - FIND(&quot;Change Signer&lt;&quot;, Description)-21), 
FIND(&quot;&gt;&quot;, RIGHT(Description, LEN(Description) - FIND(&quot;Change Signer&lt;&quot;, Description)-21))-1
)</formula>
        <name>Set DS Sign URL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Dev_Tier_Owner</fullName>
        <field>Dev_Tier_Owner__c</field>
        <formula>Case_Owner_Copy__r.FirstName + &quot; &quot; +  Case_Owner_Copy__r.LastName</formula>
        <name>Set Dev Tier Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Enhancement_Request_to_False</fullName>
        <field>Enhancement_Request__c</field>
        <literalValue>0</literalValue>
        <name>Set Enhancement Request to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Escalated_to_False</fullName>
        <description>Resets the Escalated button</description>
        <field>IsEscalated</field>
        <literalValue>0</literalValue>
        <name>Set Escalated to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Est_Resolution_Week1</fullName>
        <description>DATE(

VALUE(MID(Description, (FIND(&quot;#&quot;,Description)+1),4)),

VALUE(MID(Description, (FIND(&quot;#&quot;,Description)+1),2)),

VALUE(MID(Description, (FIND(&quot;#&quot;,Description)+1),2))

)</description>
        <field>Estimated_Resolution_Date__c</field>
        <formula>DATE(

VALUE(MID(Description, (FIND(&quot;#&quot;,Description)+3),4)),

VALUE(MID(Description, (FIND(&quot;#&quot;,Description)+7),2)),

VALUE(MID(Description, (FIND(&quot;#&quot;,Description)+9),2))

)</formula>
        <name>Set Est Resolution Week</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Latest_Escalation_Date</fullName>
        <description>Sets the latest escalation Date/Time</description>
        <field>Latest_Escalation_Date__c</field>
        <formula>NOW()</formula>
        <name>Set Latest Escalation Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Owner_to_Dev_Tier</fullName>
        <field>OwnerId</field>
        <lookupValue>SFDCSupport_Dev_Tier</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Set Owner to Dev Tier</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Owner_to_Enhancement_Review</fullName>
        <field>OwnerId</field>
        <lookupValue>SFDCSupport_Tier_2</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Set Owner to Enhancement Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Owner_to_Ready_for_Release_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>SFDC_Support_Ready_for_Release</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Set Owner to Ready for Release Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Owner_to_Service_Support_queue</fullName>
        <field>OwnerId</field>
        <lookupValue>SFDC_Support_Escalate</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Set Owner to Service/Support queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Region_to_APAC</fullName>
        <description>Sets the Region to APAC whenever Subject contains APAC</description>
        <field>Region__c</field>
        <literalValue>EMEA</literalValue>
        <name>Set Region to APAC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Region_to_NA</fullName>
        <description>Sets the Region to NA whenever subject contains NA.</description>
        <field>Region__c</field>
        <literalValue>NA</literalValue>
        <name>Set Region to NA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Service_Support_Request_to_True</fullName>
        <field>Service_Support__c</field>
        <literalValue>1</literalValue>
        <name>Set Service/Support Request to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Short_Description</fullName>
        <field>Short_Description__c</field>
        <formula>LEFT(Description, 150)</formula>
        <name>Set Short Description</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_to_Closed</fullName>
        <description>Sets Status to Closed whenever the Subject contains Issue</description>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Set Status to Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Support_Level_to_Dev_Tier</fullName>
        <field>Support_Level__c</field>
        <literalValue>Dev Tier</literalValue>
        <name>Set Support Level to Dev Tier</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Support_Level_to_Tier_1</fullName>
        <field>Support_Level__c</field>
        <literalValue>Tier 1</literalValue>
        <name>Set Support Level to Tier 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Support_Level_to_Tier_2</fullName>
        <field>Support_Level__c</field>
        <literalValue>Tier 2</literalValue>
        <name>Set Support Level to Tier 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Support_Level_to_Tier_3</fullName>
        <field>Support_Level__c</field>
        <literalValue>Tier 3</literalValue>
        <name>Set Support Level to Tier 3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Tier_1_Owner_Name</fullName>
        <description>Used to set the Tier 1 Owner&apos;s Name for Support Case purposes</description>
        <field>Tier_1_Owner__c</field>
        <formula>Case_Owner_Copy__r.FirstName + &quot; &quot; +  Case_Owner_Copy__r.LastName</formula>
        <name>Set Tier 1 Owner Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_assigned_to_Tier_2_field</fullName>
        <field>z_Assigned_to_Tier_2__c</field>
        <literalValue>1</literalValue>
        <name>Set assigned to Tier 2 field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_the_Case_Reason_to_Early_Issues</fullName>
        <description>Sets the Case Reason to Early Issues for Subjects containing Issue.  **Likely to turn off within 2 weeks of go live**</description>
        <field>Reason</field>
        <literalValue>Early Issues</literalValue>
        <name>Set the Case Reason to Early Issues</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_to_Contact_Us_Page</fullName>
        <field>Origin</field>
        <literalValue>iMeet.com Contact Us Page</literalValue>
        <name>Set to Contact Us Page</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_to_UserVoice</fullName>
        <field>Origin</field>
        <literalValue>Live Help/Uservoice</literalValue>
        <name>Set to UserVoice</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Test_Set_Date</fullName>
        <field>Case_Notes_255__c</field>
        <formula>MID(Description, (FIND(&quot;#&quot;,Description)+1),4) +

MID(Description, (FIND(&quot;#&quot;,Description)+5),2) +

MID(Description, (FIND(&quot;#&quot;,Description)+7),2)</formula>
        <name>Test Set Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Timestamp_Case_Assignment_Date</fullName>
        <field>Case_Assignment_Date_Time__c</field>
        <formula>Now()</formula>
        <name>Timestamp Case Assignment Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Under_Consideration</fullName>
        <description>Reassign ownership automatically to the Queue called &quot;*SFDCSupport* - NA Under Consideration&quot;</description>
        <field>OwnerId</field>
        <lookupValue>SFDCSupport_NA_Under_Consideration</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Under Consideration</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_to_Closed</fullName>
        <field>Ticket_Stage__c</field>
        <literalValue>Closed</literalValue>
        <name>Update Stage to Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_to_Enhancement_Request</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Enhancement_Request</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update to Enhancement Request</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_to_Enhancement_Request_Sales_Op</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Enhancement_Request_Sales_Ops_Accepted</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update to Enhancement Request - CRM Team</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ALL-Copy Web Email to Submitted by User</fullName>
        <actions>
            <name>Copy_Web_Email_to_Submitted_by_User</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>iMeet</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Submitted_By_Contact_Email__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ALL-Set Assigned Flag %26 Set Assignment Time</fullName>
        <actions>
            <name>Set_Assigned_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Case_Assignment_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  ISCHANGED(OwnerId),  CONTAINS(PRIORVALUE(OwnerId), &quot;00G&quot;)   )   /*   AND( ISCHANGED(OwnerId), OR( PRIORVALUE(OwnerId) = &quot;00G30000002yc2O&quot;, PRIORVALUE(OwnerId) = &quot;00G30000002yc2T&quot;, PRIORVALUE(OwnerId) = &quot;00G30000002yc2Y&quot;) ) */</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Email notify of Emergency Request</fullName>
        <actions>
            <name>Email_alert_of_Emergency_Request</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Emergency_Request__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>used to email Matt/Andy whenever a new Emergency Request is identified in SFDC</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email notify of Emergency Request Closed</fullName>
        <actions>
            <name>Email_alert_of_Emergency_Request_Completed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Emergency_Request__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>used to email Carmen/David whenever a new Emergency Request is closed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email notify of Ready for IT QC</fullName>
        <actions>
            <name>Email_alert_of_Ready_for_IT_QC</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Ready for IT QC</value>
        </criteriaItems>
        <description>used to email Andy whenever a newReady for IT QC  Request is identified in SFDC</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>FR-Email notify all TAM%27s%2FSE%27s</fullName>
        <actions>
            <name>Email_notification_of_New_Feature_Request</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Feature Requests</value>
        </criteriaItems>
        <description>Need to add new users to this email workflow rule when they are created.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>PGI-Assign to Escalation Request queue</fullName>
        <actions>
            <name>Email_alert_for_Service_Support_Cases</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Case_Support_Type_to_Bug_Fix</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Owner_to_Service_Support_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>SFDC Support,Scheduled Release</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Service_Support__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Enhancement_Request__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Assigns to Service/Support queue, send an email notification, and updates the Case Support Type field.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PGI-Assign to Sales Ops Rev%2E queue</fullName>
        <actions>
            <name>Set_Case_Support_Type_to_Enhancement</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Owner_to_Enhancement_Review</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>SFDC Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Enhancement_Request__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Support_Type__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Assigns to sales ops review queue, will eventually send an email notification?, and updates the Case Support Type field.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PGI-BRD Email to Business Owner</fullName>
        <actions>
            <name>BRD_Request</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Enhancement Request - Sales Ops Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Business_Owner_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Enhancement_Lifecycle__c</field>
            <operation>equals</operation>
            <value>Long</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Business_Requirements_Attached__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Email to the business owner asking for a completed BRD.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PGI-CRM Team Accepts Enhancement Request</fullName>
        <actions>
            <name>CRM_Accepted_to_Scheduled_Release</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.CRM_Team_Accepted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PGI-Change Out of Office Owner</fullName>
        <actions>
            <name>Change_Owner_to_Sys_Admin_Test_User</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>SFDC Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>startsWith</operation>
            <value>Out of Office</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>equals</operation>
            <value>Delivery Final Failure Notice</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>startsWith</operation>
            <value>Automatic reply</value>
        </criteriaItems>
        <description>Change the Out of Office Owner to Test User for eventual deletion</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>PGI-Enhancement Request %26 Sales Ops Accepted %3D True</fullName>
        <actions>
            <name>Update_to_Enhancement_Request_Sales_Op</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Sales_Ops_Accepted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Enhancement_Request__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Accepted</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PGI-Enhancement Request %3D True</fullName>
        <actions>
            <name>Update_to_Enhancement_Request</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Enhancement_Request__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PGI-Escalate to Dev Tier</fullName>
        <actions>
            <name>Send_email_when_case_escalated</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Owner_to_Dev_Tier</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Support_Level_to_Dev_Tier</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>SFDC Support,Enhancement Request - CRM Team Review,Scheduled Release</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Code_Development_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PGI-Password Reset Email</fullName>
        <actions>
            <name>Email_alert_to_inform_of_password_reset_needed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>password</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>password</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>SFDC Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>NA - SFDC Support,VF Ticket</value>
        </criteriaItems>
        <description>Sends an email notification whenever a case is created where the Description or Subject contains Password</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PGI-Set SL to Tier 1 %26 auto reponse on new case</fullName>
        <actions>
            <name>Send_auto_response_to_submitter</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Support_Level_to_Tier_1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>SFDC Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>Out of Office Reply,Delivery Final Failure Notice,Automatic Reply</value>
        </criteriaItems>
        <description>Sets the Support Level to be Tier 1 on new VF page submissions, does an autoresponse to the submitter as well.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>PGI-Set Tier 2 support level</fullName>
        <actions>
            <name>Set_Support_Level_to_Tier_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Enhancement Request - Sales Ops Review,Enhancement Request - CRM Team Review,Scheduled Release</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Support_Level__c</field>
            <operation>notEqual</operation>
            <value>Tier 2</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PGI-Test</fullName>
        <actions>
            <name>Set_Owner_to_Ready_for_Release_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>SFDC Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.CreatedById</field>
            <operation>equals</operation>
            <value>Carmen Wong</value>
        </criteriaItems>
        <description>Test for Case # 00049303</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PGI-Update Date%2FTime Accepted by CRM Team</fullName>
        <actions>
            <name>Date_Time_Accepted_by_CRM_Team</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.CRM_Team_Accepted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PGi-Set Dev Tier Owner</fullName>
        <active>true</active>
        <formula>AND(              Code_Development_Required__c = True, !            ISPICKVAL(Support_Level__c, &quot;Tier 1&quot;),               RecordTypeId = &quot;01230000001ElQa&quot; )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Set_Dev_Tier_Owner</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Ready For Sales Ops QC Date</fullName>
        <actions>
            <name>Ready_For_Sales_Ops_QC_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Ready for Sales Ops QC</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SFDC EMEA - Closed Case Email</fullName>
        <actions>
            <name>SFDC_EMEA_Email_on_case_closed</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>SFDC Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Resolution_Notes__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Do_not_email_on_Case_Closed__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Region__c</field>
            <operation>equals</operation>
            <value>EMEA</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SFDC NA - Closed Case Email</fullName>
        <actions>
            <name>Send_Email_when_case_closed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Projects,iMeet,PGiBI,Feature Requests</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Resolution_Notes__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Do_not_email_on_Case_Closed__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Region__c</field>
            <operation>equals</operation>
            <value>NA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>,davidson,carmen,peter morgan</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SFDC NA - Closed Case Email %28No Contact Email%29</fullName>
        <actions>
            <name>Email_closed_Case</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>iMeet,PGiBI,Feature Requests,Projects</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Resolution_Notes__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Do_not_email_on_Case_Closed__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Region__c</field>
            <operation>equals</operation>
            <value>NA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SFDC NA - Email when Priority Changes</fullName>
        <actions>
            <name>Email_notifying_of_Priority_change</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( IsClosed = False, 
RecordType.Id = &quot;01230000001ElQa&quot;, 
ISCHANGED(Priority), 
$User.Id &lt;&gt;  OwnerId,
NOT(
BEGINS(OwnerId, &quot;00G&quot; )
)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SFDCSupport - NA Under Consideration Rule</fullName>
        <actions>
            <name>Under_Consideration</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Under Consideration</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>contains</operation>
            <value>system administrator</value>
        </criteriaItems>
        <description>Assign a case to *SFDCSupport* - NA Under Consideration when the Status picklist = &quot;Under Consideration&quot;</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Enhancement Request to True</fullName>
        <actions>
            <name>Set_Enhancement_Request_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Service_Support_Request_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(
OwnerId = &quot;00Ga0000003d8it&quot; , 
PRIORVALUE (  OwnerId  ) &lt;&gt; &quot;00Ga0000003d8it&quot;,
IsClosed = False
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Service%2FSupport Request to False</fullName>
        <actions>
            <name>Enhancement_Request_True</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Service_Support_Request_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(
OwnerId = &quot;00G30000002zgdH&quot; , 
PRIORVALUE (  OwnerId  ) &lt;&gt; &quot;00G30000002zgdH&quot;,
IsClosed = False
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Short Description</fullName>
        <actions>
            <name>Set_Short_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Description) || ISNEW()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set assigned to Tier 2 field</fullName>
        <actions>
            <name>Set_assigned_to_Tier_2_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>contains</operation>
            <value>tier 2,sharma</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update On Hold Date</fullName>
        <actions>
            <name>On_Hold_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(
AND(
ISCHANGED(Status) = True, 
ISPICKVAL(Status, &quot;On Hold&quot;),
!ISPICKVAL(PRIORVALUE(Status),&quot;On Hold&quot;), 
!ISPICKVAL(PRIORVALUE(Status), &quot;Awaiting Response&quot;)
),
AND(
ISCHANGED(Status) = True, 
ISPICKVAL(Status, &quot;Awaiting Response&quot;),
!ISPICKVAL(PRIORVALUE(Status),&quot;On Hold&quot;), 
!ISPICKVAL(PRIORVALUE(Status), &quot;Awaiting Response&quot;)
)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>x-Closed Tier 2 Cases</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Escalation to Tier 2</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>x-Fill in Est%2E Resolution Date</fullName>
        <actions>
            <name>Set_Est_Resolution_Week1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>#RD</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>SFDC Support</value>
        </criteriaItems>
        <description>looks for #RD in the Description Line in format of xxxx/xx/xx ; actual format should be #RD20130724   for setting to July 24th 2013</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>x-PGI-Escalate to Tier 2</fullName>
        <actions>
            <name>Send_email_when_case_escalated</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Assign_to_SFDC_Tier_2_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Escalated_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Latest_Escalation_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Support_Level_to_Tier_2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Tier_1_Owner_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>SFDC Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsEscalated</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Support_Level__c</field>
            <operation>equals</operation>
            <value>Tier 1</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>x-PGI-Escalate to Tier 3</fullName>
        <actions>
            <name>Send_email_when_case_escalated</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Assign_to_Tier_3_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Escalated_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Latest_Escalation_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Support_Level_to_Tier_3</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>SFDC Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsEscalated</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Support_Level__c</field>
            <operation>equals</operation>
            <value>Tier 2</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>x-PGiBI - Closed Case Email %28No Contact Email%29</fullName>
        <actions>
            <name>PGiBI_Email_closed_Case_No_Contact_Email</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>PGiBI</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Resolution_Notes__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Do_not_email_on_Case_Closed__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Region__c</field>
            <operation>equals</operation>
            <value>NA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>x-PGiBI Notify of updates to Case</fullName>
        <actions>
            <name>Email_any_updates_to_relevant_case_fields</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>AND(              OR(          ISCHANGED(Status),          ISCHANGED(Case_Resolution_Notes__c),          ISCHANGED(Priority),          ISCHANGED(Estimated_Resolution_Date__c) ), NOT(           ISNEW() ), NOT( ISPICKVAL(Status, &quot;Closed&quot;) ),  RecordTypeId = &apos;01230000001EuYu&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>x-PGiBI- Closed Case Email</fullName>
        <actions>
            <name>PGiBI_Send_Email_when_case_closed</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>PGiBI</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Resolution_Notes__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Do_not_email_on_Case_Closed__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Region__c</field>
            <operation>equals</operation>
            <value>NA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>,davidson,carmen,peter morgan</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>x-PGi_Set Tier 1 Owner</fullName>
        <actions>
            <name>Set_Tier_1_Owner_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(              ISCHANGED(IsEscalated),              ISPICKVAL(Support_Level__c, &quot;Tier 1&quot;),               RecordTypeId = &quot;01230000001ElQa&quot; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>x-Reassign case ownership to the Ready for Release queue</fullName>
        <actions>
            <name>Reassign_Ownership_to_the_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Ready for Release</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>x-Set Case Reason to Feedback</fullName>
        <actions>
            <name>Set_Case_Reason_to_Feedback</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>Feedback</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>EMEA - SFDC Support,NA - SFDC Support,APAC - SFDC Support</value>
        </criteriaItems>
        <description>Used for setting the Case Reason to Feedback for Post GO LIVE Feedback requests Globally.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>x-Set Initial Issues Requests to Closed Automatically</fullName>
        <actions>
            <name>Set_Status_to_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_the_Case_Reason_to_Early_Issues</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>Issue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>contains</operation>
            <value>SFDC Support</value>
        </criteriaItems>
        <description>Used to Set the Case Reason to Early Issues and Status to Closed for all early issues received as a Case</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>x-Set Region to APAC</fullName>
        <actions>
            <name>Set_Region_to_APAC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>APAC</value>
        </criteriaItems>
        <description>Used for setting the Region to APAC whenever the Subject contains APAC.  **Could add additional criteria if we ever start using the Cases for support stuff**</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>x-Set Region to EMEA</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>EMEA</value>
        </criteriaItems>
        <description>Used for setting the Region to EMEA whenever the Subject contains EMEA.  **Could add additional criteria if we ever start using the Cases for support stuff**</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>x-Set Region to NA</fullName>
        <actions>
            <name>Set_Region_to_NA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>NA</value>
        </criteriaItems>
        <description>Used for setting the Region to NA whenever the Subject contains NA.  **Could add additional criteria if we ever start using the Cases for support stuff**</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>x-Set to Contact Us Page</fullName>
        <actions>
            <name>Set_to_Contact_Us_Page</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>iMeet.com Contact Inquiry</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>x-Set to UserVoice</fullName>
        <actions>
            <name>Set_to_UserVoice</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>User feedback</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>x-Test NS Case Number</fullName>
        <actions>
            <name>Copy_Case_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Escalation to Tier 2</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>x-Update Ticket Stage</fullName>
        <actions>
            <name>Update_Stage_to_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
