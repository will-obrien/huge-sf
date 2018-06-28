<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>APAC_Email_notification_when_Implementation_Review_Request_True</fullName>
        <description>APAC_Email notification when Implementation Review/Request = True</description>
        <protected>false</protected>
        <recipients>
            <recipient>andrew.davidson@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>oliver.dalziel@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IST_Notifications/New_Implementation_Review_Request</template>
    </alerts>
    <alerts>
        <fullName>APAC_Send_Email_Notification_Stage_equals_Closed_Won</fullName>
        <description>APAC_Send Email Notification Stage equals Closed Won</description>
        <protected>false</protected>
        <recipients>
            <recipient>oliver.dalziel@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Implementation_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IST_Notifications/SF_contract_closed</template>
    </alerts>
    <alerts>
        <fullName>Approval_Request_Submitted</fullName>
        <ccEmails>testing.automation.sfdc.47aff793@mailosaur.in</ccEmails>
        <ccEmails>matt.santy@pgi.com</ccEmails>
        <description>Approval Request Submitted</description>
        <protected>false</protected>
        <recipients>
            <recipient>david.stoffle@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>william.claytor@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Approval_Request_Submitted_HTML</template>
    </alerts>
    <alerts>
        <fullName>CIF_Email_Notification</fullName>
        <description>CIF Email Notification</description>
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
        <template>unfiled$public/CIF_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>CIF_Email_Notification_Canada</fullName>
        <ccEmails>istcanada@pgi.com</ccEmails>
        <description>CIF Email Notification Canada</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>andrew.davidson@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CIF_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>CIF_Email_Notification_to_Heather_Clark_Karen_Schade</fullName>
        <ccEmails>istcif@pgi.com</ccEmails>
        <description>CIF Email Notification to Heather Clark/Karen Schade</description>
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
        <template>unfiled$public/CIF_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Closed_Won_for_Australia</fullName>
        <description>Closed Won for Australia</description>
        <protected>false</protected>
        <recipients>
            <recipient>sean.keevil@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EMEA_Hunter_Emails/iMeet_DVR1</template>
    </alerts>
    <alerts>
        <fullName>Competitor_Contract_Expiration_Date</fullName>
        <description>Competitor Contract Expiration Date</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Competitor_contract_expiry_date</template>
    </alerts>
    <alerts>
        <fullName>EMEA_Email_notification_when_Implementation_Review_Request_True</fullName>
        <description>EMEA_Email notification when Implementation Review/Request = True</description>
        <protected>false</protected>
        <recipients>
            <recipient>andrew.davidson@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>simone.curtin@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IST_Notifications/New_Implementation_Review_Request</template>
    </alerts>
    <alerts>
        <fullName>EMEA_Send_Email_Notification_Stage_equals_Closed_Won</fullName>
        <description>EMEA_Send Email Notification Stage equals Closed Won</description>
        <protected>false</protected>
        <recipients>
            <recipient>simone.curtin@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Implementation_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IST_Notifications/SF_contract_closed</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_for_MRR_10K</fullName>
        <description>Email Alert for MRR &gt;= $10K</description>
        <protected>false</protected>
        <recipients>
            <field>Supervisors_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>salesforcecrmsupport@pgi.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/MRR_75K</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_when_Final_CIF_uploaded_equals_True</fullName>
        <description>Email notification when Implementation Review/Request = True</description>
        <protected>false</protected>
        <recipients>
            <recipient>andrew.davidson@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>heather.clark@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>karen.schade@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforcecrmsupport@pgi.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>IST_Notifications/New_Implementation_Review_Request</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_when_Implementation_Review_Request_True_Canada</fullName>
        <description>Email notification when Implementation Review/Request = True Canada</description>
        <protected>false</protected>
        <recipients>
            <recipient>andrew.davidson@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>michele.torbet@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IST_Notifications/New_Implementation_Review_Request</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_when_Stage_Closed_Won_Final</fullName>
        <description>Email notification when Stage = Closed Won - Final</description>
        <protected>false</protected>
        <recipients>
            <field>Supervisors_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IST_Notifications/Implementation_complete</template>
    </alerts>
    <alerts>
        <fullName>Email_to_Manager_if_Lost_Reason_is_Unknown_Lost_Contact</fullName>
        <description>Email to Manager if Lost Reason is Unknown/Lost Contact</description>
        <protected>false</protected>
        <recipients>
            <field>Supervisors_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Unknown_Lost_Contact</template>
    </alerts>
    <alerts>
        <fullName>Email_warning_of_Close_Date_within_5_days</fullName>
        <description>Email warning of Close Date within 5 days</description>
        <protected>false</protected>
        <recipients>
            <field>Supervisors_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>salesforcecrmsupport@pgi.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Workflow_Emails/Opportunity_Close_Date_is_within_5_days_of_its_close_date</template>
    </alerts>
    <alerts>
        <fullName>Government_Checkbox_Send_Email</fullName>
        <description>Government Checkbox - Send Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>carmen.legrange@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jesse.oursler@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>simon.baker@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Government_Checkbox_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Government_Picklist_Send_Email</fullName>
        <description>Government Picklist- Send Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>carmen.legrange@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>simon.baker@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Government_Checkbox_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Past_Due_Close_Date10Days</fullName>
        <description>Opportunity Past Due Close Date10Days</description>
        <protected>false</protected>
        <recipients>
            <field>Supervisors_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Opportunity_Past_Due_Close_Dt_10Days</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Past_Due_Close_Date_5Days</fullName>
        <description>Opportunity Past Due Close Date 5Days</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Opportunity_Past_Due_Close_Dt_5Days</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_has_reached_a_stage_of_75_or_above</fullName>
        <description>Opportunity has reached a stage of 75% or above</description>
        <protected>false</protected>
        <recipients>
            <recipient>heather.clark@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>karen.schade@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforcecrmsupport@pgi.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>IST_Notifications/Opportunity_reached_a_stage_of_75_or_above</template>
    </alerts>
    <alerts>
        <fullName>Pricing_Approved</fullName>
        <ccEmails>rfp@pgi.com</ccEmails>
        <ccEmails>QE@pgi.com</ccEmails>
        <ccEmails>testing.automation.sfdc.47aff793@mailosaur.in</ccEmails>
        <description>Pricing Approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>Channel Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_Emails/Opportunity_Request_Approved</template>
    </alerts>
    <alerts>
        <fullName>Pricing_Rejected</fullName>
        <ccEmails>testing.automation.sfdc.47aff793@mailosaur.in</ccEmails>
        <description>Pricing Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_Emails/Opportunity_Request_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_Notification</fullName>
        <description>Send Email Notification Stage equals Closed Won</description>
        <protected>false</protected>
        <recipients>
            <recipient>heather.clark@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>karen.schade@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Implementation_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforcecrmsupport@pgi.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>IST_Notifications/SF_contract_closed</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_Notification_Stage_equals_Closed_Won_CANADA</fullName>
        <description>Send Email Notification Stage equals Closed Won CANADA</description>
        <protected>false</protected>
        <recipients>
            <recipient>andrew.davidson@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>michele.torbet@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Implementation_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IST_Notifications/SF_contract_closed</template>
    </alerts>
    <alerts>
        <fullName>ema</fullName>
        <description>Email Notification when Stage = Closed Won - Final1 (opp owner &amp; supervisor)</description>
        <protected>false</protected>
        <recipients>
            <field>Supervisors_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>andrew.davidson@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforcecrmsupport@pgi.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>IST_Notifications/Implementation_complete1</template>
    </alerts>
    <alerts>
        <fullName>notify_contracts_team_upon_opportunity_is_closed_won</fullName>
        <ccEmails>completedcustomeragr@pgi.com</ccEmails>
        <ccEmails>renewalagreements@pgi.com</ccEmails>
        <description>Notify contracts team upon opportunity is closed won</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Contract_Management/Contract_team_notification_on_closed_won_opportunity</template>
    </alerts>
    <fieldUpdates>
        <fullName>Change_RT_to_IST</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Implementation_Opps</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change RT to IST</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RW_Set_DR_Approval_Date</fullName>
        <description>Sets timestamp</description>
        <field>Deal_Reg_Approval_Date__c</field>
        <formula>NOW()</formula>
        <name>RW_Set DR Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RW_Set_DR_Expiration_Date</fullName>
        <field>Deal_Reg_Expiration_Date__c</field>
        <formula>DATEVALUE(Deal_Reg_Approval_Date__c) + 90</formula>
        <name>RW Set DR Expiration Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RW_Set_DR_Status_to_Expired</fullName>
        <field>Deal_Registration_Status__c</field>
        <literalValue>Expired</literalValue>
        <name>RW_Set DR Status to Expired</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Resets_Generate_CIF_Form</fullName>
        <description>Sets back to False</description>
        <field>Generate_CIF_Form_NA_Only__c</field>
        <literalValue>0</literalValue>
        <name>Resets Generate CIF Form</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Apex_Update_To_False</fullName>
        <field>Apex_Update__c</field>
        <literalValue>0</literalValue>
        <name>Set Apex Update To False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Closed_Pre_Implementation_TS</fullName>
        <field>Closed_Pre_Implementation_Timestamp__c</field>
        <formula>NOW()</formula>
        <name>Set Closed Won TS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Closed_Won_Final_TS</fullName>
        <field>Closed_Won_Final_Timestamp__c</field>
        <formula>NOW()</formula>
        <name>Set Closed Won - Implementation Compl TS</name>
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
    <fieldUpdates>
        <fullName>Set_Opp_Stage_to_imp_Completed</fullName>
        <field>Opp_Stage__c</field>
        <literalValue>Closed Won - Implementation Complete</literalValue>
        <name>Set Opp Stage to imp. Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Opportunity_Closed_Date_to_Today</fullName>
        <field>CloseDate</field>
        <formula>TODAY()</formula>
        <name>Set Opportunity Closed Date to Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Probability_from_Prob_Input</fullName>
        <field>Probability</field>
        <formula>VALUE(TEXT(Prob_Input__c))/100</formula>
        <name>Set Probability % from Prob Input %</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Probability_to_100</fullName>
        <field>Probability</field>
        <formula>1.00</formula>
        <name>Set Probability to 100%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_RT_for_Opp_Quote_LI_Created</fullName>
        <field>RecordTypeId</field>
        <lookupValue>NA_Only_Quote_LI_Active</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set RT for Opp Quote LI Created</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_RT_to_NA_Only</fullName>
        <field>RecordTypeId</field>
        <lookupValue>NA_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set RT to NA Only</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stage_to_Closed_Lost</fullName>
        <field>StageName</field>
        <literalValue>Closed Lost</literalValue>
        <name>Set Stage to Closed Lost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stage_to_Closed_Won</fullName>
        <field>StageName</field>
        <literalValue>Closed Won</literalValue>
        <name>Set Stage to Closed Won</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stage_to_Closed_Won_Implementation</fullName>
        <field>StageName</field>
        <literalValue>Closed Won - Implementation Complete</literalValue>
        <name>Set Stage to Closed Won - Implementation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stage_to_Develop_Proposal</fullName>
        <field>StageName</field>
        <literalValue>Develop Proposal</literalValue>
        <name>Set Stage to Develop Proposal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stage_to_Develop_Proposal_New</fullName>
        <field>Opp_Stage__c</field>
        <literalValue>Develop Proposal</literalValue>
        <name>Set Stage to Develop Proposal New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stage_to_Develop_Solution</fullName>
        <field>StageName</field>
        <literalValue>Develop Solution</literalValue>
        <name>Set Stage to Develop Solution</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stage_to_Develop_Solution_New</fullName>
        <field>Opp_Stage__c</field>
        <literalValue>Develop Solution</literalValue>
        <name>Set Stage to Develop Solution New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stage_to_Gain_Commitment</fullName>
        <field>StageName</field>
        <literalValue>Gain Commitment</literalValue>
        <name>Set Stage to Gain Commitment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stage_to_Gain_Commitment_New</fullName>
        <field>Opp_Stage__c</field>
        <literalValue>Gain Commitment</literalValue>
        <name>Set Stage to Gain Commitment New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stage_to_Identify_Target</fullName>
        <field>StageName</field>
        <literalValue>Identify Target</literalValue>
        <name>Set Stage to Identify Target</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stage_to_Implementation</fullName>
        <field>StageName</field>
        <literalValue>Closed Won - Implementation</literalValue>
        <name>Set Stage to Implementation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stage_to_Implementation_New</fullName>
        <field>Opp_Stage__c</field>
        <literalValue>Closed Won - Implementation</literalValue>
        <name>Set Stage to Implementation-New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stage_to_Info_Session_NeedsAnalysis</fullName>
        <field>Opp_Stage__c</field>
        <literalValue>Info Session/Needs Analysis</literalValue>
        <name>Set Stage to Info Session/NeedsAnalysis</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stage_to_Info_Session_Needs_Analysis</fullName>
        <field>StageName</field>
        <literalValue>Info Session/Needs Analysis</literalValue>
        <name>Set Stage to Info Session/Needs Analysis</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stage_to_Negotiate_Contract</fullName>
        <field>StageName</field>
        <literalValue>Negotiate Contract</literalValue>
        <name>Set Stage to Negotiate Contract</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stage_to_Negotiate_Contract_New</fullName>
        <field>Opp_Stage__c</field>
        <literalValue>Negotiate Contract</literalValue>
        <name>Set Stage to Negotiate Contract New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stage_to_Negotiation_Verbal</fullName>
        <field>StageName</field>
        <literalValue>Negotiation/Verbal</literalValue>
        <name>Set Stage to Negotiation/Verbal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stage_to_Negotiation_Verbal_New</fullName>
        <field>Opp_Stage__c</field>
        <literalValue>Negotiation/Verbal</literalValue>
        <name>Set Stage to Negotiation/Verbal New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stage_to_Obtain_Final_Approval</fullName>
        <field>StageName</field>
        <literalValue>Obtain Final Approvals</literalValue>
        <name>Set Stage to Obtain Final Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stage_to_Obtain_Final_Approval_New</fullName>
        <field>Opp_Stage__c</field>
        <literalValue>Obtain Final Approvals</literalValue>
        <name>Set Stage to Obtain Final Approval New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stage_to_Pilot_Trial_Evaluation</fullName>
        <field>StageName</field>
        <literalValue>Pilot/Trial/Evaluation</literalValue>
        <name>Set Stage to Pilot/Trial/Evaluation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stage_to_Pilot_Trial_Evaluation_New</fullName>
        <field>Opp_Stage__c</field>
        <literalValue>Pilot/Trial/Evaluation</literalValue>
        <name>Set Stage to Pilot/Trial/Evaluation New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stage_to_Proposal_Price_Quote</fullName>
        <field>StageName</field>
        <literalValue>Proposal/Price Quote</literalValue>
        <name>Set Stage to Proposal/Price Quote</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stage_to_Proposal_Price_Quote_New</fullName>
        <field>Opp_Stage__c</field>
        <literalValue>Proposal/Price Quote</literalValue>
        <name>Set Stage to Proposal/Price Quote New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stage_to_Qualification</fullName>
        <field>StageName</field>
        <literalValue>Qualification</literalValue>
        <name>Set Stage to Qualification</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stage_to_Qualification_New</fullName>
        <field>Opp_Stage__c</field>
        <literalValue>Qualification</literalValue>
        <name>Set Stage to Qualification New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_stage_to_Qualify_Opportunity</fullName>
        <field>StageName</field>
        <literalValue>Qualify Opportunity</literalValue>
        <name>Set stage to Qualify Opportunity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_stage_to_Qualify_Opportunity_New</fullName>
        <field>Opp_Stage__c</field>
        <literalValue>Qualify Opportunity</literalValue>
        <name>Set stage to Qualify Opportunity New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_to_Diamond_RT</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Diamond_Methodology</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set to Diamond RT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Notes_with_TS</fullName>
        <description>updates notes with Timestamp (TS) and Person who input the note</description>
        <field>Opp_Notes__c</field>
        <formula>&quot;***&quot; 
&amp; BR() &amp; &quot;Notes by :&quot; &amp; &quot; &quot; &amp;  $User.FirstName &amp; &quot; &quot; &amp;  $User.LastName  &amp; &quot; &quot; &amp; LEFT(TEXT(NOW()-0.1666667),16) &amp; &quot; EST&quot; &amp; BR() &amp;  BR()  &amp;  Opp_Notes__c</formula>
        <name>Update Notes with TS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Notes_with_TS_EMEA</fullName>
        <field>Opp_Notes__c</field>
        <formula>&quot;***&quot; 
&amp; BR() &amp; &quot;Notes by :&quot; &amp; &quot; &quot; &amp; $User.FirstName &amp; &quot; &quot; &amp; $User.LastName &amp; &quot; &quot; &amp; LEFT(TEXT(NOW()),16) &amp; &quot; GMT&quot; &amp; BR() &amp; BR() &amp; Opp_Notes__c</formula>
        <name>Update Notes with TS - EMEA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opportuntiy_Description_Field</fullName>
        <description>Updates the standard Opportunity Description field from the custom Description field.</description>
        <field>Description</field>
        <formula>Description__c</formula>
        <name>Update Opportuntiy Description Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>APAC_IST_Implementation Review%2FRequest equals True</fullName>
        <actions>
            <name>APAC_Email_notification_when_Implementation_Review_Request_True</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(  Implementation_Review_Request__c = True, Exclude_from_IST__c = 0,  Owner_Region__c = &quot;APAC&quot;  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>APAC_IST_Opportunity Stage equals Closed Won</fullName>
        <actions>
            <name>APAC_Send_Email_Notification_Stage_equals_Closed_Won</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Change_RT_to_IST</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Closed_Pre_Implementation_TS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>An Opportunity has finalized its contract and is ready to start Implementation!</description>
        <formula>AND(    RecordTypeId = &apos;012a0000001FfkF&apos;,    ISPICKVAL(Opp_Stage__c, &quot;Closed Won&quot;),   $User.Override_Validation_Rules__c = False,  Implementation_Owner__r.LastName &lt;&gt; &quot;Responsible&quot;,   Exclude_from_IST__c = 0,  Owner_Region__c = &quot;APAC&quot;   )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Competitor contract expiry date</fullName>
        <active>true</active>
        <formula>AND(NOT($Setup.BypassRules__c.Disable_Workflow_Rules__c), Competitor_Contract_Expiration_Date__c &lt;&gt; NULL )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Competitor_Contract_Expiration_Date</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Competitor_Contract_Expiration_Date__c</offsetFromField>
            <timeLength>-120</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>EMEA_IST_Implementation Review%2FRequest equals True</fullName>
        <actions>
            <name>EMEA_Email_notification_when_Implementation_Review_Request_True</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(  Implementation_Review_Request__c = True, Exclude_from_IST__c = 0,  Owner_Region__c = &quot;EMEA&quot;  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EMEA_IST_Opportunity Stage equals Closed Won</fullName>
        <actions>
            <name>EMEA_Send_Email_Notification_Stage_equals_Closed_Won</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Change_RT_to_IST</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Closed_Pre_Implementation_TS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>An Opportunity has finalized its contract and is ready to start Implementation!</description>
        <formula>AND(    RecordTypeId = &apos;012a0000001FfkF&apos;,    ISPICKVAL(Opp_Stage__c, &quot;Closed Won&quot;),   $User.Override_Validation_Rules__c = False,  Implementation_Owner__r.LastName &lt;&gt; &quot;Responsible&quot;,   Exclude_from_IST__c = 0,  Owner_Region__c = &quot;EMEA&quot;   )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Emil To Contract Team upon opportunity is closed-Won</fullName>
        <actions>
            <name>notify_contracts_team_upon_opportunity_is_closed_won</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Opp_Stage__c</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Z_Source__c</field>
            <operation>equals</operation>
            <value>Salesgateway</value>
        </criteriaItems>
        <description>notify contract team after SG opportunity is closed won</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GCS_Change to Diamond Methodology</fullName>
        <actions>
            <name>Set_to_Diamond_RT</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Diamond_Methodology__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>contains</operation>
            <value>PGi Sales User - GCS Diamond,admin</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Government Picklist - Send Email</fullName>
        <actions>
            <name>Government_Picklist_Send_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends email to Simon &amp; Jesse when Government Opportunity field is not null</description>
        <formula>AND(NOT(  ISPICKVAL( GovernmentOpportunity__c ,&apos;&apos;) ) ,  Owner_Region__c == &apos;NA&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IST_Change Stage to Implmentation</fullName>
        <actions>
            <name>Change_RT_to_IST</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Stage_to_Implementation</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Stage_to_Implementation_New</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Opp_Stage__c</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Count_of_Implementation_Services__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Override_Validation_Rules__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IST_Implementation Review%2FRequest Canada</fullName>
        <actions>
            <name>Email_notification_when_Implementation_Review_Request_True_Canada</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends email to istcanada@pgi.com the first time that the Implementation Review Request field is true and channel = Canada and region is NA</description>
        <formula>AND(   Implementation_Review_Request__c = True,  Exclude_from_IST__c = 0,   Owner_Region__c = &quot;NA&quot;,  ISPICKVAL(Channel__c, &quot;Canada&quot;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IST_Implementation Review%2FRequest equals True</fullName>
        <actions>
            <name>Email_notification_when_Final_CIF_uploaded_equals_True</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(   Implementation_Review_Request__c = True,  Exclude_from_IST__c = 0,   Owner_Region__c = &quot;NA&quot;,  ! ISPICKVAL(Channel__c, &quot;Canada&quot;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IST_Opportunity Stage equals Closed Won</fullName>
        <actions>
            <name>Send_Email_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Change_RT_to_IST</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Closed_Pre_Implementation_TS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>An Opportunity has finalized its contract and is ready to start Implementation!</description>
        <formula>AND(    OR( RecordTypeId = &apos;012a0000001Fjqv&apos;,    RecordTypeId = &apos;012a0000001Fjqw&apos;  ),  ISPICKVAL(Opp_Stage__c, &quot;Closed Won&quot;),   $User.Override_Validation_Rules__c = False,  Implementation_Owner__r.LastName &lt;&gt; &quot;Responsible&quot;,   Exclude_from_IST__c = 0,  Owner_Region__c = &quot;NA&quot;, ! ISPICKVAL(Channel__c, &quot;Canada&quot;)    )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IST_Opportunity Stage equals Closed Won CANADA</fullName>
        <actions>
            <name>Send_Email_Notification_Stage_equals_Closed_Won_CANADA</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Change_RT_to_IST</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Closed_Pre_Implementation_TS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>An Opportunity has finalized its contract and is ready to start Implementation!  for channel = Canada only</description>
        <formula>AND(    OR( RecordTypeId = &apos;012a0000001Fjqv&apos;,    RecordTypeId = &apos;012a0000001Fjqw&apos;  ),  ISPICKVAL(Opp_Stage__c, &quot;Closed Won&quot;),   $User.Override_Validation_Rules__c = False,  Implementation_Owner__r.LastName &lt;&gt; &quot;Responsible&quot;,   Exclude_from_IST__c = 0,  Owner_Region__c = &quot;NA&quot;, ISPICKVAL(Channel__c, &quot;Canada&quot;)    )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IST_Stage equals Closed Won - Implementation Complete</fullName>
        <actions>
            <name>ema</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Closed_Won_Final_TS</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Opp_Stage_to_imp_Completed</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Stage_to_Closed_Won_Implementation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Count_of_Completed_Implementations__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Override_Validation_Rules__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>MRR %3E %2410K</fullName>
        <actions>
            <name>Email_Alert_for_MRR_10K</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.MRR_Total__c</field>
            <operation>greaterOrEqual</operation>
            <value>&quot;USD 10,000&quot;,&quot;CAD 10,984&quot;</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Channel__c</field>
            <operation>equals</operation>
            <value>Partners</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Supervisors_Email__c</field>
            <operation>notEqual</operation>
            <value>scott.tapp@pgi.com,david.gosling@pgi.com</value>
        </criteriaItems>
        <description>Notifies the VPs within the partner team anytime one of their reps has entered an opportunity with greater than $10K MRR.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity CIF Form</fullName>
        <actions>
            <name>CIF_Email_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Resets_Generate_CIF_Form</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(OR(      AND(      ISPICKVAL(Opp_Stage__c, &apos;Closed Won&apos;),      OR(    Owner_Region__c  = &quot;NA&quot;  &amp;&amp;   /* ISPICKVAL(Channel__c, &quot;Partners&quot;),  Andy update per MM 9/3/2014*/  ISPICKVAL(Channel__c, &quot;Soundpath&quot;),     ISPICKVAL(Channel__c, &quot;E-Commerce&quot;) /*, ISPICKVAL(Channel__c ,&quot;ECS Acquisition&quot;),   ISPICKVAL(Channel__c ,&quot;GCS Acquisition&quot;),   ISPICKVAL(Channel__c ,&quot;GCS Base&quot;),     ISPICKVAL(Channel__c, &quot;ECS Base&quot;), ISPICKVAL(Channel__c, &quot;Budget Conferencing&quot;), ISPICKVAL(Channel__c ,&quot;Canada&quot;) Andy commented out per KS 10/31/2014 */ ),    ISCHANGED(Opp_Stage__c)=TRUE,     $User.Override_Validation_Rules__c = False,  /*   OR( ISPICKVAL(Channel__c, &quot;Partners&quot;),  ISPICKVAL(Channel__c, &quot;Soundpath&quot;), ISPICKVAL(Channel__c, &quot;Budget Conferencing&quot;), ISPICKVAL(Channel__c, &quot;E-Commerce&quot;)),   !ISPICKVAL(Account.Channel__c,  &apos;Partner - Reseller&apos;),   !ISPICKVAL(Account.Channel__c, &apos;Partner - Agent&apos;),   !ISPICKVAL(Account.Channel__c, &apos;Partner - Alliance&apos;),   */     ISPICKVAL(Type, &quot;New Logo&quot;) || ISPICKVAL(Type, &quot;Winback&quot;) /* Andy added 10/31/2014 */,    Count_of_Completed_Q_C_Records__c = 0  ),    AND(  IsWon = True,     /*  for testing  $User.Override_Validation_Rules__c = False,  */ Generate_CIF_Form_NA_Only__c = True,    Count_of_Completed_Q_C_Records__c = 0   )   ),NOT($Setup.BypassRules__c.Disable_Validation_Rules__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity CIF to Canada IST</fullName>
        <actions>
            <name>CIF_Email_Notification_Canada</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends New Logo/Winback Opps on closed won to the canadaist@pgi.com alias.  *took out exclusion of government opps*</description>
        <formula>AND(     ISPICKVAL(Opp_Stage__c, &apos;Closed Won&apos;),      Owner_Region__c  = &quot;NA&quot;,  ISPICKVAL(Channel__c, &quot;Canada&quot;),     ISCHANGED(Opp_Stage__c)=TRUE,     $User.Override_Validation_Rules__c = False,         ISPICKVAL(Type, &quot;New Logo&quot;) || ISPICKVAL(Type, &quot;Winback&quot;), Count_of_Completed_Q_C_Records__c = 0 )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity CIF to Heather%2FKaren</fullName>
        <actions>
            <name>CIF_Email_Notification_to_Heather_Clark_Karen_Schade</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Resets_Generate_CIF_Form</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>sends non-Partners, AAE, and Soundpath to Heather/Karen</description>
        <formula>/*    OR(   AND(   ISPICKVAL(Opp_Stage__c, &apos;Closed Won&apos;),    Owner_Region__c  = &quot;NA&quot;,    ISCHANGED(Opp_Stage__c)=TRUE,    !ISPICKVAL(Channel__c, &quot;Partners&quot;),  !ISPICKVAL(Channel__c, &quot;Soundpath&quot;), !ISPICKVAL(Channel__c, &quot;ECS Base&quot;),  !ISPICKVAL(Channel__c, &quot;Budget Conferencing&quot;),  !ISPICKVAL(Channel__c, &quot;E-Commerce&quot;),              ISPICKVAL(Type, &quot;New Logo&quot;)  ),  AND(   ISPICKVAL(Opp_Stage__c, &apos;Closed Won&apos;),    Generate_CIF_Form_NA_Only__c = True,   Owner_Region__c  = &quot;NA&quot;  )  )   */       AND(     ISPICKVAL(Opp_Stage__c, &apos;Closed Won&apos;),      Owner_Region__c  = &quot;NA&quot;,      ISCHANGED(Opp_Stage__c)=TRUE,     $User.Override_Validation_Rules__c = False, OR(    /* Andy changed to be equal to and an OR statement for values they want for channel per KS 10/31/2014 */ ISPICKVAL(Channel__c, &quot;Partners&quot;),    ISPICKVAL(Channel__c, &quot;GCS Acquisition&quot;), ISPICKVAL(Channel__c, &quot;GCS Base&quot;), ISPICKVAL(Channel__c, &quot;GCS Diamond&quot;), ISPICKVAL(Channel__c, &quot;GCS SE&quot;), ISPICKVAL(Channel__c, &quot;ECS Acquisition&quot;), ISPICKVAL(Channel__c, &quot;ECS Base&quot;), ISPICKVAL(Channel__c, &quot;ECS SE&quot;), ISPICKVAL(Channel__c, &quot;SMB Base&quot;),    ISPICKVAL(Channel__c, &quot;Budget Conferencing&quot;) ),   /*  ISPICKVAL(Channel__c, &quot;Soundpath&quot;), ISPICKVAL(Channel__c, &quot;E-Commerce&quot;),   Andy removed per KS 10/31/2014 */ !ISPICKVAL(GovernmentOpportunity__c, &quot;Federal&quot;),       !ISPICKVAL(GovernmentOpportunity__c, &quot;State&quot;),         !ISPICKVAL(GovernmentOpportunity__c, &quot;Municipal&quot;),               ISPICKVAL(Type, &quot;New Logo&quot;) || ISPICKVAL(Type, &quot;Winback&quot;) /* Andy added 10/31/2014 */,   Count_of_Completed_Q_C_Records__c = 0,NOT($Setup.BypassRules__c.Disable_Validation_Rules__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Past Due Close Date10Days</fullName>
        <actions>
            <name>Opportunity_Past_Due_Close_Date10Days</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>If Opportunity stage is NOT set to close and its close date passed the current date +10 then we need to send mail to Opportunity owner and his manager.</description>
        <formula>IF( AND( NOT( IsClosed = True ),  $User.Override_Validation_Rules__c = False, TODAY() &gt; CloseDate +10),True,False)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Past Due Close Date5Days</fullName>
        <actions>
            <name>Opportunity_Past_Due_Close_Date_5Days</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>If a Opportunity status is not closed and its close date passed 5 day from current date then this workflow rule will fire and send email to Opportunity Owner</description>
        <formula>IF(  AND(  NOT(  IsClosed = True  ),  $User.Override_Validation_Rules__c = False, TODAY() &gt; CloseDate +5),True,False)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Override Probability %25 with Prob %25 Input</fullName>
        <actions>
            <name>Set_Probability_from_Prob_Input</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( NOT(   ISPICKVAL(Prob_Input__c,&quot;&quot;)   ),   IsClosed = False )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RW_Set DR Approval%2FExp%2E Date</fullName>
        <actions>
            <name>RW_Set_DR_Approval_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>RW_Set_DR_Expiration_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Deal_Reg_Approval_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Deal_Registration_Status__c</field>
            <operation>equals</operation>
            <value>Accepted</value>
        </criteriaItems>
        <description>Sets both the Deal Reg Approval Date to the date and time that the rule fires AND sets the Deal Reg Expiration Date to be TODAY + 90</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RW_Set DR Status to Expired</fullName>
        <active>true</active>
        <description>Sets the Deal Registration Status field to Expired at the end of the day on the Current Expiration Date.</description>
        <formula>Deal_Reg_Expiration_Date__c &gt;=  TODAY() &amp;&amp; NOT( ISPICKVAL(Deal_Registration_Status__c, &quot;Expired&quot;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>RW_Set_DR_Status_to_Expired</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Opportunity.Deal_Reg_Expiration_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Reset Apex Update Field</fullName>
        <actions>
            <name>Set_Apex_Update_To_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Apex_Update__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set Apex_Update__c field to false if true</description>
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
            <value>PGi - Implementation Services,PGi Admin Lite,System Administrator,System Administrator (No Expires)</value>
        </criteriaItems>
        <description>Sets the Last Modified Date by Non-Admin Functions.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Opp Notes TS-EMEA</fullName>
        <actions>
            <name>Update_Notes_with_TS_EMEA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Evaluate the rule when a record is created, and every time it’s edited</description>
        <formula>AND(  OR( ISCHANGED(Opp_Notes__c),  ISBLANK(PRIORVALUE(Opp_Notes__c)) &amp;&amp; !ISBLANK(Opp_Notes__c) ), LEFT(Opp_Notes__c, 2) &lt;&gt; &quot;**&quot;,  Owner_Region__c = &quot;EMEA&quot;  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Opp Notes TS-NA</fullName>
        <actions>
            <name>Update_Notes_with_TS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Evaluate the rule when a record is created, and every time it’s edited</description>
        <formula>AND(  ISCHANGED(Opp_Notes__c),  LEFT(Opp_Notes__c, 2) &lt;&gt; &quot;**&quot;,  Owner_Region__c = &quot;NA&quot; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Opportunity Closed Date to Today</fullName>
        <actions>
            <name>Set_Opportunity_Closed_Date_to_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set&apos;s the Opportunity closed date equal to the current date the first time an opportunity is set to closed.</description>
        <formula>AND( IsClosed = TRUE, $User.Override_Validation_Rules__c = False )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set RT to NA Only</fullName>
        <actions>
            <name>Set_RT_to_NA_Only</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>used for when cloning a record to ensure gets to the proper RT</description>
        <formula>AND( Owner_Region__c = &quot;NA&quot;, ! ISPICKVAL(Channel__c, &quot;GCS Diamond&quot;), ISNEW() )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Stage 10%25 Diamond</fullName>
        <actions>
            <name>Set_stage_to_Qualify_Opportunity</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Prob_Input__c</field>
            <operation>equals</operation>
            <value>10</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Diamond Methodology</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Sets stage based on value of prob % field when is diamond RT</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Stage 10%25 Standard</fullName>
        <actions>
            <name>Set_Stage_to_Qualification</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Prob_Input__c</field>
            <operation>equals</operation>
            <value>10</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Implementation Opps,NA Only,NA Only (Quote LI Active),Standard User</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Sets stage based on value of prob % field when not diamond RT</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Stage 20%25 Diamond</fullName>
        <actions>
            <name>Set_Stage_to_Develop_Solution</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Prob_Input__c</field>
            <operation>equals</operation>
            <value>20</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Diamond Methodology</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Sets stage based on value of prob % field when is diamond RT</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Stage 20-40%25 Standard</fullName>
        <actions>
            <name>Set_Stage_to_Info_Session_Needs_Analysis</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Prob_Input__c</field>
            <operation>equals</operation>
            <value>30,20,40</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Implementation Opps,NA Only,NA Only (Quote LI Active),Standard User</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Sets stage based on value of prob % field when not diamond RT</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Stage 30-40%25 Diamond</fullName>
        <actions>
            <name>Set_Stage_to_Develop_Proposal</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Prob_Input__c</field>
            <operation>equals</operation>
            <value>30,40</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Diamond Methodology</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Sets stage based on value of prob % field when is diamond RT</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Stage 50-60%25 Diamond</fullName>
        <actions>
            <name>Set_Stage_to_Gain_Commitment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Prob_Input__c</field>
            <operation>equals</operation>
            <value>60,50</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Diamond Methodology</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Sets stage based on value of prob % field when is diamond RT</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Stage 50-60%25 Standard</fullName>
        <actions>
            <name>Set_Stage_to_Proposal_Price_Quote</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Prob_Input__c</field>
            <operation>equals</operation>
            <value>60,50</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Implementation Opps,NA Only,NA Only (Quote LI Active),Standard User</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Sets stage based on value of prob % field when not diamond RT</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Stage 70-80%25 Diamond</fullName>
        <actions>
            <name>Set_Stage_to_Negotiate_Contract</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Prob_Input__c</field>
            <operation>equals</operation>
            <value>70,80</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Diamond Methodology</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Sets stage based on value of prob % field when is diamond RT</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Stage 70-80%25 Standard</fullName>
        <actions>
            <name>Set_Stage_to_Pilot_Trial_Evaluation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Prob_Input__c</field>
            <operation>equals</operation>
            <value>70,80</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Implementation Opps,NA Only,NA Only (Quote LI Active),Standard User</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Sets stage based on value of prob % field when not diamond RT</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Stage 90%25 Diamond</fullName>
        <actions>
            <name>Set_Stage_to_Obtain_Final_Approval</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Prob_Input__c</field>
            <operation>equals</operation>
            <value>90</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Diamond Methodology</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Sets stage based on value of prob % field when is diamond RT</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Stage 90%25 Standard</fullName>
        <actions>
            <name>Set_Stage_to_Negotiation_Verbal</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Prob_Input__c</field>
            <operation>equals</operation>
            <value>90</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Implementation Opps,NA Only,NA Only (Quote LI Active),Standard User</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Sets stage based on value of prob % field when not diamond RT</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Stage to Closed Lost</fullName>
        <actions>
            <name>Set_Stage_to_Closed_Lost</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Opp_Stage__c</field>
            <operation>equals</operation>
            <value>Closed Lost</value>
        </criteriaItems>
        <description>Sets stage based on value of Opp Stage field when not diamond RT</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Stage to Closed Won</fullName>
        <actions>
            <name>Set_Probability_to_100</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Stage_to_Closed_Won</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Opp_Stage__c</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <description>Sets stage based on value of Opp Stage field and probability % to 100</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Stage to Develop Proposal</fullName>
        <actions>
            <name>Set_Stage_to_Develop_Proposal</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Opp_Stage__c</field>
            <operation>equals</operation>
            <value>Develop Proposal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Diamond Methodology</value>
        </criteriaItems>
        <description>Sets stage based on opp stage field when is diamond RT</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Stage to Develop Solution</fullName>
        <actions>
            <name>Set_Stage_to_Develop_Solution</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Opp_Stage__c</field>
            <operation>equals</operation>
            <value>Develop Solution</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Diamond Methodology</value>
        </criteriaItems>
        <description>Sets stage based on opp stage field when is diamond RT</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Stage to Gain Commitment</fullName>
        <actions>
            <name>Set_Stage_to_Gain_Commitment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Opp_Stage__c</field>
            <operation>equals</operation>
            <value>Gain Commitment</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Diamond Methodology</value>
        </criteriaItems>
        <description>Sets stage based on opp stage field when is diamond RT</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Stage to Identify Target</fullName>
        <actions>
            <name>Set_Stage_to_Identify_Target</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Opp_Stage__c</field>
            <operation>equals</operation>
            <value>Identify Target</value>
        </criteriaItems>
        <description>Sets stage based on value of Opp Stage field for all RT&apos;s</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Stage to Info Session%2FNeeds Analysis</fullName>
        <actions>
            <name>Set_Stage_to_Info_Session_Needs_Analysis</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Opp_Stage__c</field>
            <operation>equals</operation>
            <value>Info Session/Needs Analysis</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Implementation Opps,NA Only,NA Only (Quote LI Active),Standard User</value>
        </criteriaItems>
        <description>Sets stage based on value of Opp Stage field when not diamond RT</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Stage to Negotiate Contract</fullName>
        <actions>
            <name>Set_Stage_to_Negotiate_Contract</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Opp_Stage__c</field>
            <operation>equals</operation>
            <value>Negotiate Contract</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Diamond Methodology</value>
        </criteriaItems>
        <description>Sets stage based on opp stage field when is diamond RT</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Stage to Negotiation%2FVerbal</fullName>
        <actions>
            <name>Set_Stage_to_Negotiation_Verbal</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Opp_Stage__c</field>
            <operation>equals</operation>
            <value>Negotiation/Verbal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Implementation Opps,NA Only,NA Only (Quote LI Active),Standard User</value>
        </criteriaItems>
        <description>Sets stage based on value of Opp Stage field when not diamond RT</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Stage to Obtain Final Approvals</fullName>
        <actions>
            <name>Set_Stage_to_Obtain_Final_Approval</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Opp_Stage__c</field>
            <operation>equals</operation>
            <value>Obtain Final Approvals</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Diamond Methodology</value>
        </criteriaItems>
        <description>Sets stage based on opp stage field when is diamond RT</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Stage to Pilot%2FTrial%2FEvaluation</fullName>
        <actions>
            <name>Set_Stage_to_Pilot_Trial_Evaluation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Opp_Stage__c</field>
            <operation>equals</operation>
            <value>Pilot/Trial/Evaluation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Implementation Opps,NA Only,NA Only (Quote LI Active),Standard User</value>
        </criteriaItems>
        <description>Sets stage based on value of opp stage when not diamond RT</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Stage to Proposal%2FPrice Quote</fullName>
        <actions>
            <name>Set_Stage_to_Proposal_Price_Quote</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Opp_Stage__c</field>
            <operation>equals</operation>
            <value>Proposal/Price Quote</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Implementation Opps,NA Only,NA Only (Quote LI Active),Standard User</value>
        </criteriaItems>
        <description>Sets stage based on value of prob % field when not diamond RT</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Stage to Qualification</fullName>
        <actions>
            <name>Set_Stage_to_Qualification</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Opp_Stage__c</field>
            <operation>equals</operation>
            <value>Qualification</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Implementation Opps,NA Only,NA Only (Quote LI Active),Standard User</value>
        </criteriaItems>
        <description>Sets stage based on value of Opp Stage field when not diamond RT</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set stage to Qualify Opportunity</fullName>
        <actions>
            <name>Set_stage_to_Qualify_Opportunity</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Opp_Stage__c</field>
            <operation>equals</operation>
            <value>Qualify Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Diamond Methodology</value>
        </criteriaItems>
        <description>Sets stage based on opp stage field when is diamond RT</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Unknown_Lost</fullName>
        <actions>
            <name>Email_to_Manager_if_Lost_Reason_is_Unknown_Lost_Contact</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>OR(  ISPICKVAL(Lost_Reason__c, &quot;Unknown/Lost Contact&quot;),  ISPICKVAL(Secondary_Lost_Reason__c, &quot;Unknown/Lost Contact&quot;),  ISPICKVAL(Tertiary_Lost_Reason__c, &quot;Unknown/Lost Contact&quot;)  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Opportuntiy Description Field</fullName>
        <actions>
            <name>Update_Opportuntiy_Description_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Description__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Description</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Updates the standard Opportunity Description field from the custom Description field.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Warn Opp is within 5 days of its Close Date-1</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CloseDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Owner_Region__c</field>
            <operation>equals</operation>
            <value>EMEA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.CloseDate</field>
            <operation>greaterThan</operation>
            <value>10/1/2012</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Override_Validation_Rules__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>First WF that warns if Opp is within 5 days of the Close Date

TODAY() + 5  CloseDate &gt;=  DATE(2012,10,1)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_warning_of_Close_Date_within_5_days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.CloseDate</offsetFromField>
            <timeLength>-5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>x-Government Checkbox - Send Email</fullName>
        <actions>
            <name>Government_Checkbox_Send_Email</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>2 AND (1 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Government_Opportunity__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Owner_Region__c</field>
            <operation>equals</operation>
            <value>NA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Government_Opportunity_Inside_Sales__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Sends email to Simon &amp; Jesse when Government Checkbox is selected.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>x-IST_%28fix%29Stage equals Closed Won - Implementation Complete1</fullName>
        <actions>
            <name>Email_notification_when_Stage_Closed_Won_Final</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Opp_Stage__c</field>
            <operation>equals</operation>
            <value>Closed Won - Implementation Complete</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>x-IST_Opportunity has reached a stage of 75%25 or above</fullName>
        <actions>
            <name>Opportunity_has_reached_a_stage_of_75_or_above</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Rule to send email notification when Opportunity has reached a stage of 75%</description>
        <formula>AND( Probability &gt;= 0.75, Probability &lt;= 0.90 ,   CloseDate &lt; TODAY() +90 ,  CloseDate  &gt;=  TODAY(), $User.Override_Validation_Rules__c = False, Exclude_from_IST__c = 0  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>x-IST_Set Closed Won - Implementation Complete</fullName>
        <actions>
            <name>Set_Closed_Won_Final_TS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Closed_Won_Final_Timestamp__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opp_Stage__c</field>
            <operation>equals</operation>
            <value>Closed Won - Implementation Complete</value>
        </criteriaItems>
        <description>Set Closed Won - Final Timestamp</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>x-IST_Set Closed Won TS</fullName>
        <actions>
            <name>Set_Closed_Pre_Implementation_TS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Set Closed Won - Pre-Implementation</description>
        <formula>AND(  RecordTypeId = &apos;012a0000001FfkF&apos;,  ISPICKVAL(Opp_Stage__c, &quot;Closed Won&quot;),  ISBLANK(Closed_Won_Final_Timestamp__c), Owner_Region__c = &quot;NA&quot;,  ! ISPICKVAL(Channel__c, &quot;Soundpath&quot;),  ! ISPICKVAL(Channel__c, &quot;E-Commerce&quot;),  Government_Opportunity__c = False,  Government_Opportunity_Inside_Sales__c = False  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>x-IST_Set Stage to Closed Won - Implementation Completed</fullName>
        <actions>
            <name>Set_Stage_to_Closed_Won_Implementation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Count_of_Completed_Implementations__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>x-Set RT for Opp Quote LI Created</fullName>
        <actions>
            <name>Set_RT_for_Opp_Quote_LI_Created</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Count_of_Quote__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Count_of_Completed_Q_C_Records__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
