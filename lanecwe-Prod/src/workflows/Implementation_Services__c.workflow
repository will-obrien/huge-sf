<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>APAC_Emailing_Opportunity_Owner_when_IST_Status_is_Reviewed_Automated</fullName>
        <description>APAC:Emailing Opportunity Owner when Implementation Stage is No IS Assigned</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>andrew.davidson@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>matt.santy@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>oliver.dalziel@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IST_Notifications/APAC_IST_Status_Reviewed_Automated</template>
    </alerts>
    <alerts>
        <fullName>EMEA_Emailing_Opportunity_Owner_when_IST_Status_is_Reviewed_Automated</fullName>
        <description>EMEA:Emailing Opportunity Owner when Implementation Stage is No IS Assigned</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>andrew.davidson@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>simone.curtin@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IST_Notifications/EMEA_IST_Status_Reviewed_Automated</template>
    </alerts>
    <alerts>
        <fullName>Email_Notification_of_cancelled_Implementations</fullName>
        <description>Email Notification of cancelled Implementations</description>
        <protected>false</protected>
        <recipients>
            <field>Implementation_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforcecrmsupport@pgi.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>IST_Notifications/Implementation_Closed</template>
    </alerts>
    <alerts>
        <fullName>Email_Notification_when_Company_created_equals_True</fullName>
        <description>Email Notification when Company created equals True</description>
        <protected>false</protected>
        <recipients>
            <recipient>andrew.davidson@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IST_Notifications/Add_rates</template>
    </alerts>
    <alerts>
        <fullName>Email_Notification_when_License_list_uploaded_True</fullName>
        <description>Email Notification when License list uploaded = True  gold2@pgi.com</description>
        <protected>false</protected>
        <recipients>
            <recipient>andrew.davidson@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IST_Notifications/Add_licenses</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_when_Final_CIF_uploaded_equals_True</fullName>
        <description>Email notification when Rates entered  = True Company  (owner, IST Owner, opp supervisor email)</description>
        <protected>false</protected>
        <recipients>
            <field>Opp_Supervisors_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Implementation_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IST_Notifications/Company_created_rates_entered_Company_name</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_when_Rates_entered_equals_True</fullName>
        <description>Email notification when Rates entered equals True  (opp owner, IST owner, opp supe email)</description>
        <protected>false</protected>
        <recipients>
            <recipient>andrew.davidson@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IST_Notifications/Company_created_rates_entered</template>
    </alerts>
    <alerts>
        <fullName>Emailing_Opportunity_Owner_when_IST_Status_is_Reviewed_Automated</fullName>
        <description>Emailing Opportunity Owner when Implementation Stage is No IS Assigned</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IST_Notifications/IST_Status_Reviewed_Automated</template>
    </alerts>
    <alerts>
        <fullName>Notify_of_IST_owner_change</fullName>
        <description>Notify of IST owner change</description>
        <protected>false</protected>
        <recipients>
            <recipient>andrew.davidson@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>subhadip.manna@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Implementation_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IST_Notifications/Notify_of_IST_Owner_Change</template>
    </alerts>
    <alerts>
        <fullName>Notify_of_IST_owner_change_Gina_Marshall</fullName>
        <description>Notify of IST owner change - Gina Marshall</description>
        <protected>false</protected>
        <recipients>
            <recipient>gina.marshall@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IST_Notifications/Notify_of_IST_Owner_Change</template>
    </alerts>
    <alerts>
        <fullName>Send_email_for_CIF_Closed</fullName>
        <ccEmails>istcif@pgi.com</ccEmails>
        <description>Send email for CIF Closed istcif@pgi.com</description>
        <protected>false</protected>
        <recipients>
            <recipient>andrew.davidson@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IST_Notifications/Create_company</template>
    </alerts>
    <fieldUpdates>
        <fullName>IST_Completed_status</fullName>
        <description>Implementation Stage to Cancelled.</description>
        <field>IST_Completed_Status__c</field>
        <literalValue>Cancelled</literalValue>
        <name>IST Completed status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pre_Implementation_Survey_True</fullName>
        <description>Updates the Pre-Implementation Survey field to True if the Related Opportunity has a true Pre-Implementation Survey.</description>
        <field>Pre_Implementation_Survey__c</field>
        <literalValue>1</literalValue>
        <name>Pre-Implementation Survey = True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Company_Created</fullName>
        <field>TS_Company_Created__c</field>
        <formula>Now()</formula>
        <name>Set Company Created</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Final_CIF_Uploaded</fullName>
        <field>TS_Final_CIF_Uploaded__c</field>
        <formula>Now()</formula>
        <name>Set Final CIF Uploaded</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_IST_Notes</fullName>
        <description>sets user who created note adn timestamp</description>
        <field>IST_Notes__c</field>
        <formula>&quot;***&quot; 
&amp; BR() &amp; &quot;Notes by :&quot; &amp; &quot; &quot; &amp; $User.FirstName &amp; &quot; &quot; &amp; $User.LastName &amp; &quot; &quot; &amp; LEFT(TEXT(NOW()),16) &amp; &quot; GMT&quot; &amp; BR() &amp; BR() &amp;  IST_Notes__c</formula>
        <name>Set IST Notes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_IST_Recent_Notes</fullName>
        <field>IST_Recent_Notes__c</field>
        <formula>LEFT(IST_Notes__c, 200)</formula>
        <name>Set IST Recent Notes</name>
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
        <fullName>Set_License_List_Uploaded</fullName>
        <field>TS_License_List_Uploaded__c</field>
        <formula>NOW()</formula>
        <name>Set License List Uploaded</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_On_Hold_Set_TS</fullName>
        <description>Sets On Hold Set field with the Date/Time</description>
        <field>TS_On_Hold_Set__c</field>
        <formula>NOW()</formula>
        <name>Set On Hold Set TS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Opp_Supervisors_Email</fullName>
        <field>Opp_Supervisors_Email__c</field>
        <formula>Related_Opportunity__r.Supervisors_Email__c</formula>
        <name>Set Opp Supervisors Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Owner_to_Simone</fullName>
        <field>Implementation_Owner__c</field>
        <lookupValue>simone.curtin@pgi.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Set Owner to Simone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Pre_contract_TS</fullName>
        <field>Pre_Contract_Timestamp__c</field>
        <formula>NOW()</formula>
        <name>Set Pre-contract TS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Rates_Entered</fullName>
        <field>TS_Rates_Entered__c</field>
        <formula>NOW()</formula>
        <name>Set Rates Entered</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_TS_Adoption_Status_Set</fullName>
        <field>TS9_Adoption_Status_Set__c</field>
        <formula>NOW()</formula>
        <name>Set TS-Adoption Status Set</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_TS_Adoption_Status_Unselect</fullName>
        <field>TS9_Adoption_Status_Unselected__c</field>
        <formula>NOW()</formula>
        <name>Set TS-Adoption Status Unselect</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_TS_Bill_Review_Set_to_completed</fullName>
        <field>TS8_Bill_Review_Status_Unselected__c</field>
        <formula>NOW()</formula>
        <name>Set TS-Bill Review Set to completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_TS_Bill_Review_Status_Set</fullName>
        <field>TS8_Bill_Review_Status_Set__c</field>
        <formula>NOW()</formula>
        <name>Set TS-Bill Review Status Set</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_TS_Build_Status_Set</fullName>
        <field>TS1_Build_Status_Set__c</field>
        <formula>NOW()</formula>
        <name>Set TS-Build Status Set</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_TS_Build_Status_Unselect</fullName>
        <field>TS1_Build_Status_UnSelected__c</field>
        <formula>NOW()</formula>
        <name>Set TS-Build Status Unselect</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_TS_Company_Created</fullName>
        <field>TS_Company_Created__c</field>
        <formula>NOW()</formula>
        <name>Set TS-Company Created</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_TS_Discover_Status_Set</fullName>
        <field>TS_Discover_Status_Set__c</field>
        <formula>NOW()</formula>
        <name>Set TS-Discover Status Set</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_TS_Discover_Status_Unselect</fullName>
        <field>TS_Discover_Status_Unselected__c</field>
        <formula>NOW()</formula>
        <name>Set TS-Discover Status Unselect</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_TS_Hand_off_SetToCompleted</fullName>
        <field>TS_Hand_off_Status_Unselected__c</field>
        <formula>NOW()</formula>
        <name>Set TS-Hand-off Set to completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_TS_Hand_off_Status_Set</fullName>
        <field>TS_Hand_off_Status_Set__c</field>
        <formula>NOW()</formula>
        <name>Set TS-Hand-off Status Set</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_TS_Initial_Comm_Status_Set</fullName>
        <field>TS2_Initial_Communication_Status_Set__c</field>
        <formula>NOW()</formula>
        <name>Set TS-Initial Comm Status Set</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_TS_Initial_Comm_Status_Unselect</fullName>
        <field>TS2_Initial_Communication_Status_Unset__c</field>
        <formula>NOW()</formula>
        <name>Set TS-Initial Comm Status Unselect</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_TS_On_Hold_Status_Unselect</fullName>
        <field>TS_On_Hold_Unselected__c</field>
        <formula>NOW()</formula>
        <name>Set TS-On Hold Status Unselect</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_TS_Plan_Status_Set</fullName>
        <field>TS_Plan_Status_Set__c</field>
        <formula>NOW()</formula>
        <name>Set TS-Plan Status Set</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_TS_Plan_Status_Unselect</fullName>
        <field>TS_Plan_Status_Unselected__c</field>
        <formula>NOW()</formula>
        <name>Set TS-Plan Status Unselect</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_TS_Train_Status_Set</fullName>
        <field>TS3_Train_Status_Set__c</field>
        <formula>NOW()</formula>
        <name>Set TS-Train Status Set</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_TS_Train_Status_Unselect</fullName>
        <field>TS3_Train_Status_Unselected__c</field>
        <formula>NOW()</formula>
        <name>Set TS-Train Status Unselect</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_TimeStamp_for_Notes</fullName>
        <description>LEFT(TEXT(NOW()),16)  &amp; BR()  &amp; IST_Notes__c</description>
        <field>IST_Notes__c</field>
        <formula>&quot;***&quot; 
&amp; BR() &amp; &quot;Notes by:&quot; &amp;  $User.FirstName &amp; &quot; &quot; &amp;  $User.LastName  &amp; &quot; &quot; &amp;LEFT(TEXT(NOW()-0.166667),16) &amp; &quot; EST&quot; &amp; BR() &amp;  BR()  &amp; IST_Notes__c</formula>
        <name>Set TimeStamp for Notes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>APAC%3AImplementation Stage No IS Assigned</fullName>
        <actions>
            <name>APAC_Emailing_Opportunity_Owner_when_IST_Status_is_Reviewed_Automated</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Implementation_Services__c.IST_Status__c</field>
            <operation>equals</operation>
            <value>No IS Assigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Region__c</field>
            <operation>equals</operation>
            <value>APAC</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Channel__c</field>
            <operation>notEqual</operation>
            <value>Canada</value>
        </criteriaItems>
        <description>Whenever Implementation Stage is set to No IS Assigned, email is sent to Opportunity owner.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Company created equals True</fullName>
        <actions>
            <name>Email_Notification_when_Company_created_equals_True</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Implementation_Services__c.Company_Created__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EMEA%3AImplementation Stage No IS Assigned</fullName>
        <actions>
            <name>EMEA_Emailing_Opportunity_Owner_when_IST_Status_is_Reviewed_Automated</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Implementation_Services__c.IST_Status__c</field>
            <operation>equals</operation>
            <value>No IS Assigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Region__c</field>
            <operation>equals</operation>
            <value>EMEA</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Channel__c</field>
            <operation>notEqual</operation>
            <value>Canada</value>
        </criteriaItems>
        <description>Whenever Implementation Stage is set to No IS Assigned, email is sent to Opportunity owner.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EMEA-Timestamp Notes</fullName>
        <actions>
            <name>Set_IST_Notes</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Takes Notes and adds a Timestamp to the beginning of the thread</description>
        <formula>AND(  ISCHANGED(IST_Notes__c), Owner_Region__c = &quot;EMEA&quot;,  Channel__c &lt;&gt; &quot;Canada&quot;, LEFT(IST_Notes__c, 2) &lt;&gt; &quot;**&quot;  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Final CIF uploaded equals True</fullName>
        <actions>
            <name>Send_email_for_CIF_Closed</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Implementation_Services__c.Final_CIF_Uploaded__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IST_set stage to Cancelled - Implementation cancelled</fullName>
        <actions>
            <name>Email_Notification_of_cancelled_Implementations</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>IST_Completed_status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Implementation_Services__c.CheckboxForWFRule__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Implementation_Services__c.Implementation_Owner__c</field>
            <operation>notContain</operation>
            <value>Responsible</value>
        </criteriaItems>
        <description>set IST stage to cancelled as whenever opportunity stage is Closed Lost.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Implementation Stage No IS Assigned</fullName>
        <actions>
            <name>Emailing_Opportunity_Owner_when_IST_Status_is_Reviewed_Automated</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Implementation_Services__c.IST_Status__c</field>
            <operation>equals</operation>
            <value>No IS Assigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Region__c</field>
            <operation>equals</operation>
            <value>NA</value>
        </criteriaItems>
        <description>Whenever Implementation Stage is set to No IS Assigned, email is sent to Opportunity owner.  previously called reviewed automated</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>License list uploaded equals True</fullName>
        <actions>
            <name>Email_Notification_when_License_list_uploaded_True</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Implementation_Services__c.License_List_Uploaded__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify of Owner Change</fullName>
        <actions>
            <name>Notify_of_IST_owner_change</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ISCHANGED(Implementation_Owner__c), ! ISNEW() )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify of Owner Change - Gina Marshall</fullName>
        <actions>
            <name>Notify_of_IST_owner_change_Gina_Marshall</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(Implementation_Owner__c), Implementation_Owner__c &lt;&gt; &quot;00530000007dKU2&quot;, Implementation_Owner__c &lt;&gt; &quot;005300000065o6P&quot;, Implementation_Owner__c &lt;&gt; &quot;0053000000620A0&quot;, Implementation_Owner__c &lt;&gt; &quot;005a000000AoISB&quot;, !ISNEW(), Owner_Region__c = &quot;NA&quot;, Channel__c != &quot;Canada&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Pre-Implementation Survey</fullName>
        <actions>
            <name>Pre_Implementation_Survey_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( !ISBLANK(CreatedDate), Related_Opportunity__r.Technical_Survey__c = true )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Rates entered  equals True-Company Name</fullName>
        <actions>
            <name>Email_notification_when_Final_CIF_uploaded_equals_True</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Implementation_Services__c.Rates_Entered__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Implementation_Services__c.Owner_Region__c</field>
            <operation>equals</operation>
            <value>NA</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Rates entered equals True</fullName>
        <actions>
            <name>Email_notification_when_Rates_entered_equals_True</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Implementation_Services__c.Rates_Entered__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Company Created</fullName>
        <actions>
            <name>Set_Company_Created</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Implementation_Services__c.Company_Created__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Implementation_Services__c.TS_Company_Created__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Final CIF Uploaded</fullName>
        <actions>
            <name>Set_Final_CIF_Uploaded</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Implementation_Services__c.Final_CIF_Uploaded__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Implementation_Services__c.TS_Final_CIF_Uploaded__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set IST Owner to Simone for EMEA</fullName>
        <actions>
            <name>Set_Owner_to_Simone</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Implementation_Services__c.Implementation_Owner__c</field>
            <operation>equals</operation>
            <value>Sales Rep Responsible</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Owner_Region__c</field>
            <operation>equals</operation>
            <value>EMEA</value>
        </criteriaItems>
        <description>when set to Angelina and opp owner region is EMEA, set to Simone so shows up properly on reports...might change to Kate if simone plans on actually owning anything</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set IST Recent Notes</fullName>
        <actions>
            <name>Set_IST_Recent_Notes</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Implementation_Services__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
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
        <description>Sets the Last Modified Date by Non-Admin Functions</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set License List Uploaded</fullName>
        <actions>
            <name>Set_License_List_Uploaded</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Implementation_Services__c.License_List_Uploaded__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Opp Supervisors Email</fullName>
        <actions>
            <name>Set_Opp_Supervisors_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Used for WF email notifications</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Pre Contract TS</fullName>
        <actions>
            <name>Set_Pre_contract_TS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>INCLUDES( IST_Status__c, &quot;Pre-Contract&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Rates Entered</fullName>
        <actions>
            <name>Set_Rates_Entered</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Implementation_Services__c.Rates_Entered__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Implementation_Services__c.TS_Rates_Entered__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set TS-Adoption Status Set</fullName>
        <actions>
            <name>Set_TS_Adoption_Status_Set</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( INCLUDES(IST_Status__c, &quot;Adoption&quot;), ISBLANK(TS9_Adoption_Status_Set__c) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set TS-Adoption Status Unselect</fullName>
        <actions>
            <name>Set_TS_Adoption_Status_Unselect</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( INCLUDES(PRIORVALUE(IST_Status__c), &quot;Adoption&quot;), NOT( INCLUDES(IST_Status__c, &quot;Adoption&quot;)), ISBLANK(TS9_Adoption_Status_Unselected__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set TS-Bill Review Set to completed</fullName>
        <actions>
            <name>Set_TS_Bill_Review_Set_to_completed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Merge with email workflow once we turn them on.</description>
        <formula>AND( PRIORVALUE(Bill_Review_Completed__c) = False, Bill_Review_Completed__c = True )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set TS-Bill Review Status Set</fullName>
        <actions>
            <name>Set_TS_Bill_Review_Status_Set</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( INCLUDES(IST_Status__c, &quot;Bill Review&quot;), ISBLANK(TS8_Bill_Review_Status_Set__c) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set TS-Build Status Set</fullName>
        <actions>
            <name>Set_TS_Build_Status_Set</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>INCLUDES(IST_Status__c, &quot;Build&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set TS-Build Status Unselect</fullName>
        <actions>
            <name>Set_TS_Build_Status_Unselect</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( INCLUDES(PRIORVALUE(IST_Status__c), &quot;Build&quot;), NOT( INCLUDES(IST_Status__c, &quot;Build&quot;)), ISBLANK(TS1_Build_Status_UnSelected__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set TS-Company Created to completed</fullName>
        <actions>
            <name>Set_TS_Company_Created</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Merge with email workflow once we turn them on.</description>
        <formula>AND( PRIORVALUE( Company_Created__c) = False, Company_Created__c = True )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set TS-Discovery Status Set</fullName>
        <actions>
            <name>Set_TS_Discover_Status_Set</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  INCLUDES(IST_Status__c, &quot;Discovery&quot;),  ISBLANK(TS_Discover_Status_Set__c)  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set TS-Discovery Status Unselect</fullName>
        <actions>
            <name>Set_TS_Discover_Status_Unselect</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( INCLUDES(PRIORVALUE(IST_Status__c), &quot;Discovery&quot;), NOT( INCLUDES(IST_Status__c, &quot;Discovery&quot;)), ISBLANK(TS_Discover_Status_Unselected__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set TS-Hand-off Set to completed</fullName>
        <actions>
            <name>Set_TS_Hand_off_SetToCompleted</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( PRIORVALUE(Hand_off_Completed__c) = False, Hand_off_Completed__c = True )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set TS-Hand-off Status Set</fullName>
        <actions>
            <name>Set_TS_Hand_off_Status_Set</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( INCLUDES(IST_Status__c, &quot;Hand-off&quot;), ISBLANK(TS_Hand_off_Status_Set__c) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set TS-Initial Comm Status Set</fullName>
        <actions>
            <name>Set_TS_Initial_Comm_Status_Set</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( INCLUDES(IST_Status__c, &quot;Initial Communication&quot;), ISBLANK(TS2_Initial_Communication_Status_Set__c) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set TS-Initial Comm Status Unselect</fullName>
        <actions>
            <name>Set_TS_Initial_Comm_Status_Unselect</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( INCLUDES(PRIORVALUE(IST_Status__c), &quot;Initial Communication&quot;), NOT( INCLUDES(IST_Status__c, &quot;Initial Communication&quot;)), ISBLANK(TS2_Initial_Communication_Status_Unset__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set TS-On Hold Status Set</fullName>
        <actions>
            <name>Set_On_Hold_Set_TS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  INCLUDES(IST_Status__c, &quot;On Hold&quot;),  ISBLANK( TS_On_Hold_Set__c )  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set TS-On Hold Status Unselect</fullName>
        <actions>
            <name>Set_TS_On_Hold_Status_Unselect</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( INCLUDES(PRIORVALUE(IST_Status__c), &quot;On Hold&quot;), NOT( INCLUDES(IST_Status__c, &quot;On Hold&quot;)), ISBLANK( TS_On_Hold_Unselected__c ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set TS-Plan Status Set</fullName>
        <actions>
            <name>Set_TS_Plan_Status_Set</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  INCLUDES(IST_Status__c, &quot;Plan&quot;),  ISBLANK(TS_Plan_Status_Set__c)  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set TS-Plan Status Unselect</fullName>
        <actions>
            <name>Set_TS_Plan_Status_Unselect</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( INCLUDES(PRIORVALUE(IST_Status__c), &quot;Plan&quot;), NOT( INCLUDES(IST_Status__c, &quot;Plan&quot;)), ISBLANK(TS_Plan_Status_Unselected__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set TS-Train Status Set</fullName>
        <actions>
            <name>Set_TS_Train_Status_Set</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( INCLUDES(IST_Status__c, &quot;Train&quot;), ISBLANK(TS3_Train_Status_Set__c) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set TS-Train Status Unselect</fullName>
        <actions>
            <name>Set_TS_Train_Status_Unselect</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( INCLUDES(PRIORVALUE(IST_Status__c), &quot;Train&quot;), NOT( INCLUDES(IST_Status__c, &quot;Train&quot;)), ISBLANK(TS3_Train_Status_Unselected__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Timestamp Notes</fullName>
        <actions>
            <name>Set_TimeStamp_for_Notes</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Takes Notes and adds a Timestamp to the beginning of the thread</description>
        <formula>AND(  ISCHANGED(IST_Notes__c),  Owner_Region__c = &quot;NA&quot; ||  Channel__c = &quot;Canada&quot;, LEFT(IST_Notes__c, 2) &lt;&gt; &quot;**&quot;  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
