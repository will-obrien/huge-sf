<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>FUSetAccountStatusInText</fullName>
        <field>Status_In_Text__c</field>
        <formula>CASE(Status__c , 
&quot;Not Yet Included&quot;, &quot;Not Yet Included&quot;,
&quot;Change Requested&quot;, &quot;Change Requested&quot;,
&quot;Included&quot;,         &quot;Included&quot;,
&quot;Provided by CA&quot;,   &quot;Provided by CA&quot;,
&quot;Verified&quot;,         &quot;Verified&quot;,
&quot;Removed&quot;,          &quot;Removed&quot;,
&quot;Obsolete&quot;,         &quot;Obsolete&quot;,
&quot;&quot;)</formula>
        <name>FUSetAccountStatusInText</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FUSetAccountTypeAsIntermediateCert</fullName>
        <field>Type</field>
        <literalValue>Intermediate Certificate</literalValue>
        <name>FUSetAccountTypeAsIntermediateCert</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FUSetAccountTypeAsOwner</fullName>
        <field>Type</field>
        <literalValue>Owner</literalValue>
        <name>FUSetAccountTypeAsOwner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FUSetAccountTypeAsRoot</fullName>
        <field>Type</field>
        <literalValue>Root</literalValue>
        <name>FUSetAccountTypeAsRoot</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FUSetCAOwner</fullName>
        <description>Update the CA Owner - top level in hierarchy.</description>
        <field>CA_Owner__c</field>
        <formula>if(RecordType.Name = &apos;CA Owner&apos;, Name,
  if(RecordType.Name = &apos;Root Certificate&apos;, Parent.Name,
    if(RecordType.Name = &apos;Intermediate Certificate&apos;, 
         Parent.Parent.CA_Owner__c,
      &apos;Error in finding CA Owner Name&apos;
    )
  )
)</formula>
        <name>FUSetCAOwner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FUSetCAOwnerID</fullName>
        <description>Update the CA Owner ID - top level in hierarchy.</description>
        <field>CA_Owner_ID__c</field>
        <formula>if(RecordType.Name = &apos;CA Owner&apos;, Id, 
if(RecordType.Name = &apos;Root Certificate&apos;, Parent.Id, 
if(RecordType.Name = &apos;Intermediate Certificate&apos;, 
Parent.Parent.CA_Owner_ID__c, 
&apos;Error in finding CA Owner ID&apos; 
) 
) 
)</formula>
        <name>FUSetCAOwnerID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FUSetCP255</fullName>
        <description>Set Certificate Policy (CP) a long field to Text Area field. This field will be used by in formula fields</description>
        <field>Certificate_Policy_CP_255_char_c__c</field>
        <formula>Certificate_Policy_CP__c</formula>
        <name>FUSetCP255</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FUSetCPS255</fullName>
        <description>Certification Practice Statement (CPS)
Set Certification Practice Statement (CPS) a long field to Text Area field. This field will be used by in formula fields</description>
        <field>Certification_Practice_Stat_CPS_255_char__c</field>
        <formula>Certification_Practice_Statement_CPS__c</formula>
        <name>FUSetCPS255</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FUSetGeographicFocus255</fullName>
        <field>Geographic_Focus_255_char__c</field>
        <formula>Geographic_Focus__c</formula>
        <name>FUSetGeographicFocus255</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>WFSetAccountGeographicFocus</fullName>
        <actions>
            <name>FUSetGeographicFocus255</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set GeographicFocus a long field to Text Area field. This field will be used by Root records in formula fields</description>
        <formula>ISNEW() || ISCHANGED( Geographic_Focus__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WFSetAccountStatusInText</fullName>
        <actions>
            <name>FUSetAccountStatusInText</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow to convert Status picklist value to text.</description>
        <formula>ISNEW() || ISCHANGED( Status__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WFSetAccountTypeAsIntermediateCertific</fullName>
        <actions>
            <name>FUSetAccountTypeAsIntermediateCert</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Intermediate Certificate</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WFSetAccountTypeAsOwner</fullName>
        <actions>
            <name>FUSetAccountTypeAsOwner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>CA Owner</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WFSetAccountTypeAsRoot</fullName>
        <actions>
            <name>FUSetAccountTypeAsRoot</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Root Certificate</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WFSetCAOwnerAndCAOwnerID</fullName>
        <actions>
            <name>FUSetCAOwner</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FUSetCAOwnerID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>CA Owner,Root Certificate,Intermediate Certificate</value>
        </criteriaItems>
        <description>This workflow sets CA Owner and CA Owner ID fields with the top hierarchy account name.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WFSetCP255</fullName>
        <actions>
            <name>FUSetCP255</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set Certificate Policy (CP) a long field to Text Area field. This field will be used by in formula fields</description>
        <formula>ISNEW() || ISCHANGED(Certificate_Policy_CP__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WFSetCPS255</fullName>
        <actions>
            <name>FUSetCPS255</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set Certification Practice Statement (CPS) a long field to Text Area field. This field will be used by in formula fields</description>
        <formula>ISNEW() || ISCHANGED(Certification_Practice_Statement_CPS__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
