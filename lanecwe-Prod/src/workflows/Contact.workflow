<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Copy_Account_Name</fullName>
        <field>Account_Name_copy__c</field>
        <formula>Account.Name</formula>
        <name>Copy Account Name</name>
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
        <fullName>Set_Last_Mod_Date_by_Non_Admin</fullName>
        <field>Last_modified_Date_by_non_admin__c</field>
        <formula>NOW()</formula>
        <name>Set Last Mod Date by Non-Admin</name>
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
    <rules>
        <fullName>Account Name copy</fullName>
        <actions>
            <name>Copy_Account_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.AccountName</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
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
            <field>Contact.Channel__c</field>
            <operation>equals</operation>
            <value>Canada</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.CreatedDate</field>
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
            <field>Contact.Marketing_Channel__c</field>
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
            <field>Contact.Hubspot_Email_Opt_Out__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
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
        <fullName>Set Opt In Date to TODAY%28%29</fullName>
        <actions>
            <name>Set_Opt_In_Date_to_TODAY</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets Date Opt In to TODAY() whenever Email Opt Out has changed from True to False and channel = Canada.</description>
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
        <description>Sets Email Opt Out to True whenever contact is created that its created date is greater than 6/30/2014 and channel = Canada.</description>
        <formula>AND( PRIORVALUE(HasOptedOutOfEmail) = False,  HasOptedOutOfEmail = True, TEXT(Channel__c) = &quot;Canada&quot; || CONTAINS(LOWER(TEXT( Marketing_Channel__c)), &quot;canada&quot;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
