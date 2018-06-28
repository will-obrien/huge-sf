<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Biz_Dev</fullName>
        <description>Email Biz Dev List</description>
        <protected>false</protected>
        <recipients>
            <recipient>ltse@dimagi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Dimagi_Emails/email_biz_dev</template>
    </alerts>
    <alerts>
        <fullName>Email_Fogbugz_for_new_Opp</fullName>
        <ccEmails>fbnn@dimagi.com</ccEmails>
        <description>Email Fogbugz for new Opp</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Dimagi_Emails/email_biz_dev</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_No_Account</fullName>
        <description>Opportunity: No Account</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>dimagi-salesforce@dimagi.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Dimagi_Emails/Opportunity_No_Account</template>
    </alerts>
    <alerts>
        <fullName>Send_Proposal_Questions_to_Fogbugz</fullName>
        <ccEmails>support@dimagi.com, nnestle@dimagi.com</ccEmails>
        <description>Send Proposal Questions to Fogbugz</description>
        <protected>false</protected>
        <recipients>
            <recipient>ltse@dimagi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Dimagi_Emails/Opportunity_11_Questions</template>
    </alerts>
    <fieldUpdates>
        <fullName>Opportunity_Clear_Update_Field</fullName>
        <field>Funding_Type__c</field>
        <name>Opportunity: Clear Update Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_FB_Assigned_to_Opp_Owner</fullName>
        <description>Sets the Opportunity Owner based on who the FB Assigned To is</description>
        <field>OwnerId</field>
        <lookupValue>rhartford@dimagi.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Opportunity: Set RyanH as Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Probability_Fields_in_synch</fullName>
        <description>Sets the fogbugz probability field equal to the standard probability field.</description>
        <field>Fogbugz_Probability__c</field>
        <formula>Probability</formula>
        <name>Probability Fields in synch</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Christina_as_Owner</fullName>
        <description>Sets Christina as the opportunity owner</description>
        <field>OwnerId</field>
        <lookupValue>cjeffrey@dimagi.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Set Christina as Owner</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Close_Date</fullName>
        <description>Try to default the close date field on opportunity</description>
        <field>CloseDate</field>
        <formula>DATE(2013,12,31)</formula>
        <name>Set Close Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Kieran_as_Owner</fullName>
        <description>Sets Kieran as the owner of an opportunity</description>
        <field>OwnerId</field>
        <lookupValue>ksharpey@dimagi.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Set Kieran as Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Marco_Horta_as_Opportunity_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>mhorta@dimagi.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Set Marco Horta as Opportunity Owner</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Neal_as_Opp_Owner</fullName>
        <description>Sets Neal at the owner of an opportunity</description>
        <field>OwnerId</field>
        <lookupValue>nlesh@dimagi.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Set Neal as Opp Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Opportunity_Name</fullName>
        <field>Name</field>
        <formula>Account.Name &amp; &quot;: &quot;</formula>
        <name>Set Opportunity Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Opportunity_to_Closed</fullName>
        <description>Sets Opp to closed if the FB ticket is closed</description>
        <field>StageName</field>
        <literalValue>Closed</literalValue>
        <name>Set Opportunity to Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Proposal_Development_sent_to_yes</fullName>
        <description>Sets the field to TRUE when the Proposal Development questions are emailed to Fogbugz for the first time.</description>
        <field>Proposal_Questions_Sent__c</field>
        <literalValue>1</literalValue>
        <name>Set Proposal Development sent to yes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_Active</fullName>
        <description>Change the account status to &quot;Active&quot;</description>
        <field>Status__c</field>
        <literalValue>Active</literalValue>
        <name>Set Account Status Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stella_as_Owner</fullName>
        <description>Sets Stella as the opp owner</description>
        <field>OwnerId</field>
        <lookupValue>sluk@dimagi.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Set Stella as Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage_Name_Reset</fullName>
        <description>Resets the stage name back to the original value.</description>
        <field>StageName</field>
        <literalValue>Stage 1 - Connect</literalValue>
        <name>Stage Name Reset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Opportunity%3A Close Opportunity</fullName>
        <actions>
            <name>Set_Opportunity_to_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Fogbugz_Assigned_To__c</field>
            <operation>equals</operation>
            <value>CLOSED</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>notContain</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>When the FB ticket closes, the opp is set to closed.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A No Account</fullName>
        <actions>
            <name>Opportunity_No_Account</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Email the owner if an opportunity does not have an account associated with it.</description>
        <formula>ISBLANK(AccountId)  &amp;&amp;  ISCHANGED( OwnerId )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Proposal Development Questions</fullName>
        <actions>
            <name>Send_Proposal_Questions_to_Fogbugz</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Proposal_Development_sent_to_yes</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Opp_Stage__c</field>
            <operation>equals</operation>
            <value>Stage 4 - Proposal Development</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Proposal_Questions_Sent__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Send email to Fogbugz to copy the 11 questions into the FB case.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Christina as Owner</fullName>
        <actions>
            <name>Set_Christina_as_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Fogbugz_Owner_Mapping__c</field>
            <operation>equals</operation>
            <value>Christina Jeffrey</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.OwnerId</field>
            <operation>equals</operation>
            <value>Salesforce Fogbugz Integration</value>
        </criteriaItems>
        <description>Sets Christina as owner of an opportunity created by a DSA person in FB.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Devika as Owner</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Fogbugz_Owner_Mapping__c</field>
            <operation>equals</operation>
            <value>Devika Sarin</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.OwnerId</field>
            <operation>equals</operation>
            <value>Salesforce Fogbugz Integration</value>
        </criteriaItems>
        <description>Sets Devika as owner of an opportunity created by a DSI person in FB.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Kieran as Owner</fullName>
        <actions>
            <name>Set_Kieran_as_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Fogbugz_Owner_Mapping__c</field>
            <operation>equals</operation>
            <value>Kieran Sharpey-Schafer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.OwnerId</field>
            <operation>equals</operation>
            <value>Salesforce Fogbugz Integration</value>
        </criteriaItems>
        <description>Sets Kieran as owner of an opportunity created by a DSA person in FB.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Neal as Owner</fullName>
        <actions>
            <name>Set_Neal_as_Opp_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Fogbugz_Owner_Mapping__c</field>
            <operation>equals</operation>
            <value>Neal Lesh</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.OwnerId</field>
            <operation>equals</operation>
            <value>Salesforce Fogbugz Integration</value>
        </criteriaItems>
        <description>Sets Devika as owner of an opportunity created by a Inc person in FB.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Probability fields in synch</fullName>
        <actions>
            <name>Probability_Fields_in_synch</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Probability</field>
            <operation>notEqual</operation>
            <value>101</value>
        </criteriaItems>
        <description>keeps the standard probability field in synch with the fogbugz probability field.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set RyanH as Owner</fullName>
        <actions>
            <name>Opportunity_FB_Assigned_to_Opp_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.OwnerId</field>
            <operation>equals</operation>
            <value>Salesforce Fogbugz Integration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Fogbugz_Owner_Mapping__c</field>
            <operation>equals</operation>
            <value>Ryan Hartford</value>
        </criteriaItems>
        <description>Sets Ryan as owner of an opportunity created by a non-mapped person in FB.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Stella as Owner</fullName>
        <actions>
            <name>Set_Stella_as_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Fogbugz_Owner_Mapping__c</field>
            <operation>equals</operation>
            <value>Stella Luk</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.OwnerId</field>
            <operation>equals</operation>
            <value>Salesforce Fogbugz Integration</value>
        </criteriaItems>
        <description>Sets Stella as owner of an opportunity created by a DSI person in FB.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
