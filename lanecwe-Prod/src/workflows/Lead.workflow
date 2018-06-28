<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Brandon_Johnson_regarding_a_potential_Black_Hole_Lead</fullName>
        <description>Email Brandon Johnson regarding a potential Black Hole Lead</description>
        <protected>false</protected>
        <recipients>
            <recipient>andrew.davidson@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>brandon.johnson@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Marketing/Lead_Grade_Higher_on_DQ_lead</template>
    </alerts>
    <alerts>
        <fullName>Email_alert_on_new_iMeet_Trials_to_the_Owner</fullName>
        <description>Email alert on new iMeet Trials to the Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Assigned_to_Templates/iMeet_Trial_Leads_New_assignment_notification</template>
    </alerts>
    <alerts>
        <fullName>Email_of_new_Lead_that_is_Hot_Warm</fullName>
        <ccEmails>andrew.davidson@pgi.com</ccEmails>
        <description>Email of new Lead that is Hot/Warm</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Assigned_to_Templates/LeadsNewassignmentnotification</template>
    </alerts>
    <alerts>
        <fullName>Email_when_lead_source_is_set_to_empty</fullName>
        <description>Email when lead source is set to empty</description>
        <protected>false</protected>
        <recipients>
            <recipient>andrew.davidson@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Assigned_to_Templates/Leads_New_assignment_notification_No_Lead_Source</template>
    </alerts>
    <alerts>
        <fullName>Rule</fullName>
        <description>Notification when lead is created using dataloader</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Assigned_to_Templates/LeadsNewassignmentnotificationWFRonly</template>
    </alerts>
    <alerts>
        <fullName>Send_email_informing_of_iMeet_Schedule_a_Demo_Request</fullName>
        <description>Send email informing of iMeet Schedule a Demo Request</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>andrew.davidson@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>erik.gabrielson@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Assigned_to_Templates/Inform_of_Scheduled_a_Demo</template>
    </alerts>
    <alerts>
        <fullName>Send_new_lead_notification_to_Lead_Owner</fullName>
        <description>Send new lead notification to Lead Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>salesforcecrmsupport@pgi.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Assigned_to_Templates/LeadsNewassignmentnotification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Copy_RK_Email_if_no_email</fullName>
        <field>Email</field>
        <formula>RK_Email__c</formula>
        <name>Copy RK-Email if no email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_RK_Phone_if_no_phone</fullName>
        <field>Phone</field>
        <formula>RK_Phone__c</formula>
        <name>Copy RK-Phone if no phone #</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reassign_to_Junk_queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Potential_Junk_Leads</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Reassign to Junk queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Annual_Revenue_value</fullName>
        <field>AnnualRevenue</field>
        <formula>CASE( z_m_Annual_Revenue_Range__c,
&quot;0 - 1 Million&quot;, 500000,
&quot;1 - 5 Million&quot;, 2500000, 
&quot;6 - 10 Million&quot;, 7500000,
&quot;11 - 15 Million&quot;, 12500000,
&quot;26 - 50 Million&quot;, 38000000,
&quot;51 - 100 Million&quot;, 75000000,
&quot;101 - 200 Million&quot;, 150000000,
&quot;201 - 250 Million&quot;, 225000000,
&quot;250 - 999 Million&quot;, 625000000,
&quot;1 - 2.5 Billion&quot;, 1750000000,
&quot;2.5 Billion+&quot;, 5000000000,
0
)</formula>
        <name>Set Annual Revenue value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Channel_Type_to_direct</fullName>
        <field>ChannelType__c</field>
        <literalValue>Direct</literalValue>
        <name>Set Channel Type to direct</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Company_Name_to_be_Account_Name</fullName>
        <field>Company</field>
        <formula>Account__r.Name</formula>
        <name>Set Company Name to be Account Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Company_Value</fullName>
        <field>Company</field>
        <formula>co_name__c</formula>
        <name>Set Company Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Description_1st_100</fullName>
        <description>to be used for list views</description>
        <field>Description_1st_100__c</field>
        <formula>LEFT(Description, 100)</formula>
        <name>Set Description (1st 100)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Email_Opt_Out_to_True</fullName>
        <field>HasOptedOutOfEmail</field>
        <literalValue>1</literalValue>
        <name>Set Email Opt Out to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Email_Opt_to_Match_Hspt_one</fullName>
        <field>HasOptedOutOfEmail</field>
        <literalValue>1</literalValue>
        <name>Set Email Opt to Match Hspt one</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Hidden_Checkbox_to_True</fullName>
        <field>Hidden_Checkbox__c</field>
        <literalValue>1</literalValue>
        <name>Set Hidden Checkbox to True</name>
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
        <fullName>Set_Last_mod_by_non_admin</fullName>
        <field>Last_modified_by_non_admin__c</field>
        <formula>LastModifiedBy.FirstName + LastModifiedBy.LastName</formula>
        <name>Set Last mod by (non - admin)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Lead_RT_to_qualified</fullName>
        <description>sets the Lead RT to Qualified whenever the Lead Status changes to be Qualifying</description>
        <field>RecordTypeId</field>
        <lookupValue>Qualified</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Lead RT to qualified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Lead_Routed_by_DB_back_to_False</fullName>
        <description>See the name</description>
        <field>Lead_Routed_by_DB__c</field>
        <literalValue>0</literalValue>
        <name>Set Lead Routed by DB back to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Lead_Status_to_Inquiry</fullName>
        <field>Status</field>
        <literalValue>Inquiry</literalValue>
        <name>Set Lead Status to Inquiry</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Lead_Status_to_Working</fullName>
        <description>when dials is greater than 0, sets the lead status to working, only if the lead status currently is Open Unqualified.</description>
        <field>Status</field>
        <literalValue>Working</literalValue>
        <name>Set Lead Status to Working</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Marketing_Opt_In_Timestamp_Value</fullName>
        <field>Marketing_Opt_In_Timestamp__c</field>
        <formula>NOW()</formula>
        <name>Set Marketing Opt-In Timestamp Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_No_of_Employees_value</fullName>
        <description>converts z_m-Employee Number Range to a number value</description>
        <field>NumberOfEmployees</field>
        <formula>IF(
CONTAINS(TEXT(Employee_Number_Range__c),&quot;+&quot;), 
VALUE(
TRIM(
LEFT(SUBSTITUTE(
TEXT(Employee_Number_Range__c), &quot;,&quot;, &quot;&quot;),
FIND( 
&quot;+&quot;,
SUBSTITUTE(TEXT(Employee_Number_Range__c),&quot;,&quot;,&quot;&quot;))-1

))
),



CEILING(
(
VALUE(
TRIM(
MID(SUBSTITUTE(
TEXT(Employee_Number_Range__c), &quot;,&quot;, &quot;&quot;),(FIND( &quot;-&quot;,
SUBSTITUTE(TEXT(Employee_Number_Range__c),&quot;,&quot;,&quot;&quot;))+1),5)
))

-

VALUE(
TRIM(
LEFT(SUBSTITUTE(
TEXT(Employee_Number_Range__c), &quot;,&quot;, &quot;&quot;),
FIND( 
&quot;-&quot;,
SUBSTITUTE(TEXT(Employee_Number_Range__c),&quot;,&quot;,&quot;&quot;))-1

))
))
/2

+
VALUE(
TRIM(
LEFT(SUBSTITUTE(
TEXT(Employee_Number_Range__c), &quot;,&quot;, &quot;&quot;),
FIND( 
&quot;-&quot;,
SUBSTITUTE(TEXT(Employee_Number_Range__c),&quot;,&quot;,&quot;&quot;))-1

))
))
)</formula>
        <name>Set No. of Employees value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Nurture_TimeStamp</fullName>
        <field>z_Nurture_TimeStamp__c</field>
        <formula>NOW()</formula>
        <name>Set Nurture TimeStamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Opt_In_Date_to_TODAY</fullName>
        <field>Date_of_Opt_in__c</field>
        <formula>TODAY()</formula>
        <name>Set Opt In Date to TODAY()</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Opt_Out_Date_to_TODAY</fullName>
        <field>Date_of_Opt_Out__c</field>
        <formula>TODAY()</formula>
        <name>Set Opt Out Date to TODAY()</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Owner_Name_Copy</fullName>
        <field>z_Copy_Owner_Name__c</field>
        <formula>Owner_Copy__r.FirstName + Owner_Copy__r.LastName</formula>
        <name>Set Owner Name Copy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Owner_Region_for_Davidson_Leads</fullName>
        <description>for S&amp;M Lead Routing purposes</description>
        <field>Owner_Region__c</field>
        <formula>TEXT(Owner:User.Region__c)</formula>
        <name>Set Owner Region for Davidson Leads</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Owner_to_PGi_Integration</fullName>
        <field>OwnerId</field>
        <lookupValue>pgiintegration@pgi.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Set Owner to PGi Integration</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Website_from_Email</fullName>
        <field>Website</field>
        <formula>&quot;www.&quot; + RIGHT(Email, LEN(Email) - FIND(&quot;@&quot;,Email))</formula>
        <name>Set Website from Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_z_iMeet_Trial_to_be_True</fullName>
        <description>used in other WF Rules to ensure double notifications are not sent out</description>
        <field>z_iMeet_Trial__c</field>
        <literalValue>1</literalValue>
        <name>Set z-iMeet Trial to be True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TESLA_CompanyID_Update</fullName>
        <field>TESLA_IntlCompanyID__c</field>
        <formula>IM_PGI_ACCT_ID__c</formula>
        <name>TESLA CompanyID Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Custom_Lead_Description_Field</fullName>
        <description>Updates the custom Lead Description field from the standard Description field.</description>
        <field>Description__c</field>
        <formula>Description</formula>
        <name>Update Custom Lead Description Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Score</fullName>
        <field>hubspotscore__c</field>
        <formula>100</formula>
        <name>Update Lead Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Black Hole Lead</fullName>
        <actions>
            <name>Email_Brandon_Johnson_regarding_a_potential_Black_Hole_Lead</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>sends an email notification to Brandon Johnson whenever a DQ or inactive owner lead has its lead score increase.</description>
        <formula>AND(  OR(  ISPICKVAL(Status,&quot;Disqualified&quot;),  Owner:User.IsActive  = False, AND( BEGINS(OwnerId , &quot;00G&quot;), ! (OwnerId = &quot;00G30000001xMPl&quot;), ! (OwnerId = &quot;00G30000002zXt2&quot;), ! (OwnerId = &quot;00Ga0000003dGyp&quot;), ! (OwnerId = &quot;00Ga000000307g7&quot;), ! (OwnerId = &quot;00G30000002yXbZ&quot;) ) ),  OR(  PRIORVALUE(hubspotscore__c) &lt; hubspotscore__c,  ISBLANK(PRIORVALUE(hubspotscore__c)) &amp;&amp; ! ISBLANK(hubspotscore__c)  ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Convert Annual Revenue Range to number</fullName>
        <actions>
            <name>Set_Annual_Revenue_value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.AnnualRevenue</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.z_m_Annual_Revenue_Range__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.z_m_Annual_Revenue_Range__c</field>
            <operation>notEqual</operation>
            <value>Very Large (&gt;US$1000m),Small (US$6-$10m),Micro (US$0-$5m),Medium (US$11-$100m),Large (US$101-$999m)</value>
        </criteriaItems>
        <description>Fires off a formula that converts the field z_m-Annual Revenue Range to a number value and sets that into the Annual Revenue field when it doesnt have a value but the Range field does.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Convert Employee Range to number</fullName>
        <actions>
            <name>Set_No_of_Employees_value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.NumberOfEmployees</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Employee_Number_Range__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Employee_Number_Range__c</field>
            <operation>notEqual</operation>
            <value>Medium (50-250),Small (10-50),Large (250-3000),Micro (&lt;10),Very Large (3000+)</value>
        </criteriaItems>
        <description>Fires off a formula that converts the field z_m-Employee Number Range to a number value and sets that into the No. of Employees field when it doesnt have a value but the Range field does.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy RK-Email if no email</fullName>
        <actions>
            <name>Copy_RK_Email_if_no_email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RK_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Email</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Copy RK-Phone if no phone %23</fullName>
        <actions>
            <name>Copy_RK_Phone_if_no_phone</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RK_Phone__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Phone</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Lead Owner of iMeet Demo Request</fullName>
        <actions>
            <name>Send_email_informing_of_iMeet_Schedule_a_Demo_Request</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.IM_USER_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Test_Drive_Scheduled_Time__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Emails the owner of the Lead informing them of a Schedule a Demo request.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email to new Owner of Lead</fullName>
        <actions>
            <name>Send_new_lead_notification_to_Lead_Owner</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Lead_Routed_by_DB_back_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Lead_Routed_by_DB__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>when lead routed by DB = True this will email out a new lead assigned notification to the lead owner and set back to False</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>HBSPT_Notification To Lead Owner</fullName>
        <actions>
            <name>Rule</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>HubSpot Integration,Andrew Davidson</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>notEqual</operation>
            <value>*HubSpot Queue - IM/PGi,*HubSpot Queue - BC,*PGi.com email QUEUE,*Inquiries (Baking),Sales &amp; Marketing Database</value>
        </criteriaItems>
        <description>Used to send email notification to Lead Owners when a Lead is created from dataloader.  irrelevant now with lead routing process</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Integration User creates a lead with no Lead Source</fullName>
        <actions>
            <name>Email_when_lead_source_is_set_to_empty</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>contains</operation>
            <value>Hubspot Integration</value>
        </criteriaItems>
        <description>Integration User creates a lead with no Lead Source</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Move to PGi Integration User</fullName>
        <actions>
            <name>Set_Owner_to_PGi_Integration</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.To_be_Deleted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>So that agents will not call out on a lead that will be deleted in nightly batch process</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Move to Potential Junk Leads queue</fullName>
        <actions>
            <name>Reassign_to_Junk_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Andrew Davidson,Hubspot Integration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Description</field>
            <operation>contains</operation>
            <value>&lt;a href=,http:,https:</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Owner_Region__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>QC-IM New Notification</fullName>
        <actions>
            <name>Email_alert_on_new_iMeet_Trials_to_the_Owner</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_z_iMeet_Trial_to_be_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>PGI Integration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>notEqual</operation>
            <value>kemberly reed,PGi integration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.IM_USER_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.To_be_Deleted__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Need to lockdown criteria once we figure out the kemberly thing.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Channel Type to direct</fullName>
        <actions>
            <name>Set_Channel_Type_to_direct</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.ChannelType__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>If not selected puts it as Direct</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Company Name to be Account Name</fullName>
        <actions>
            <name>Set_Company_Name_to_be_Account_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT( ISBLANK(Account__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Company Name value</fullName>
        <actions>
            <name>Set_Company_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.co_name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Company</field>
            <operation>equals</operation>
            <value>[not provided]</value>
        </criteriaItems>
        <description>temporary until they can resolve webform issue on Hubspot side</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Email Opt Out to True</fullName>
        <actions>
            <name>Set_Email_Opt_Out_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Opt_Out_Date_to_TODAY</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR (3 AND 4)) AND 2 AND 5</booleanFilter>
        <criteriaItems>
            <field>Lead.Channel__c</field>
            <operation>equals</operation>
            <value>Canada</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.CreatedDate</field>
            <operation>greaterThan</operation>
            <value>6/25/2014 12:00 PM</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.FirstName</field>
            <operation>equals</operation>
            <value>Claudine</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.LastName</field>
            <operation>equals</operation>
            <value>Dumont</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Marketing_Channel__c</field>
            <operation>notContain</operation>
            <value>Canada</value>
        </criteriaItems>
        <description>Sets Email Opt Out to True whenever lead is created that its created date is greater than 6/30/2014 and channel = Canada.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Email Opt to Match Hspt one</fullName>
        <actions>
            <name>Set_Email_Opt_to_Match_Hspt_one</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Hubspot_Email_Opt_Out__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Hidden Checkbox to True</fullName>
        <actions>
            <name>Set_Hidden_Checkbox_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Sets Hidden Checkbox to true so that SetOwnerCopy trigger update Owner Copy fields in case of lead created from web to lead form</description>
        <formula>OR(Owner_Type__c &lt;&gt; null,Owner_Type__c &lt;&gt; &apos;&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
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
    <rules>
        <fullName>Set Last mod by %28non - admin%29</fullName>
        <actions>
            <name>Set_Last_mod_by_non_admin</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>PGi Admin Lite,System Administrator,System Administrator (No Expires)</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Lead RT to qualifyied</fullName>
        <actions>
            <name>Set_Lead_RT_to_qualified</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the record type on lead to Qualified whenever the lead status changes to be qualifying.  **Likely no reason to push this back to Standard as reps will have filled in all detail needed to see the Convert button.</description>
        <formula>AND( ISPICKVAL(Status, &quot;Qualifying&quot;), NOT( RecordType.Id = &quot;012e00000008fAr&quot;  /* Qualified */ ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Lead Score</fullName>
        <actions>
            <name>Update_Lead_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Eloqua_Lead_Score__c == &apos;A1&apos; || Eloqua_Lead_Score__c == &apos;A2&apos; || Eloqua_Lead_Score__c == &apos;A3&apos; || Eloqua_Lead_Score__c == &apos;B1&apos; || Eloqua_Lead_Score__c == &apos;B2&apos; || Eloqua_Lead_Score__c == &apos;B3&apos; || Eloqua_Lead_Score__c == &apos;C1&apos; || Eloqua_Lead_Score__c == &apos;C2&apos; || Eloqua_Lead_Score__c == &apos;D1&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Lead Status to Inquiry</fullName>
        <actions>
            <name>Set_Lead_Status_to_Inquiry</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>*HubSpot Queue - IM/PGi,*LW Marketing Loop Fuse,*LW Marketing Queue 1,*SMB Team Queue,*SWAT Team Queue</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Marketing Opt-In Timestamp Value</fullName>
        <actions>
            <name>Set_Marketing_Opt_In_Timestamp_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Marketing_Opt_In__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Likely need to update this if/when we give reps usage of this field.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Nurture TimeStamp</fullName>
        <actions>
            <name>Set_Nurture_TimeStamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Nurture</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Opt In Date to TODAY%28%29</fullName>
        <actions>
            <name>Set_Opt_In_Date_to_TODAY</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets Date Opt In to TODAY() whenever Email Opt Out has changed from True to False and channel = Canada</description>
        <formula>/* changed 8/24/2014 AEDD */ AND( OR( PRIORVALUE(HasOptedOutOfEmail) = True &amp;&amp;  HasOptedOutOfEmail = False &amp;&amp; TEXT(Channel__c) = &quot;Canada&quot;, ISNEW() &amp;&amp; CONTAINS(LOWER(TEXT( Marketing_Channel__c)), &quot;canada&quot;) &amp;&amp; CreatedById = &quot;005300000071JU5&quot; /* Hubspot Integration */ ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Opt Out Date to TODAY%28%29</fullName>
        <actions>
            <name>Set_Opt_Out_Date_to_TODAY</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets Email Opt Out to True whenever lead is created that its created date is greater than 6/30/2014 and channel = Canada.</description>
        <formula>AND( PRIORVALUE(HasOptedOutOfEmail) = False,  HasOptedOutOfEmail = True, TEXT(Channel__c) = &quot;Canada&quot; || CONTAINS(LOWER(TEXT( Marketing_Channel__c)), &quot;canada&quot;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Owner Region for Davidson Leads</fullName>
        <actions>
            <name>Set_Owner_Region_for_Davidson_Leads</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>Andrew Davidson</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Owner_Region__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>for S&amp;M Lead Routing purposes</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Website</fullName>
        <actions>
            <name>Set_Website_from_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Website</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Email</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Email</field>
            <operation>notContain</operation>
            <value>msn.com,yahoo,gmail,sbc,comcast,me.com,aol.com,mac.com,hotmail,mail.com,gmx,zoho,gawab,aim,lavabit,excite,lycos,imeet,videotron,shaw,telus</value>
        </criteriaItems>
        <description>Sets website if it doesnt already exist.  *Added videotron, shaw, telus per Claudine Dumont 10-3-2014.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Custom Lead Description Field</fullName>
        <actions>
            <name>Set_Description_1st_100</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Custom_Lead_Description_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates the custom Lead Description field from the standard Description field.</description>
        <formula>ISCHANGED(  LastModifiedDate )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update TESLA_IntlCompanyID</fullName>
        <actions>
            <name>Set_Owner_Name_Copy</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>TESLA_CompanyID_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Company</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This copies Company Id for account mapping</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>x-Notify of new lead if Hot%2FWarm</fullName>
        <actions>
            <name>Email_of_new_Lead_that_is_Hot_Warm</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Randy Schiff,Kelly Cooper,Robin Winningham</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Rating</field>
            <operation>equals</operation>
            <value>Warm,Hot</value>
        </criteriaItems>
        <description>when created by Randy and rating is Warm/Hot to notify the owner of the record**irrelevant now with lead routing process</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
