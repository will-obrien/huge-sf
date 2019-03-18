<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_AsOfmonth_to_this_year</fullName>
        <field>AsOFTHISYEAR__c</field>
        <literalValue>THIS YEAR</literalValue>
        <name>Set AsOfmonth to this year</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Product_Family_to_GlobalMeet</fullName>
        <field>ProductType__c</field>
        <literalValue>Web: GlobalMeet</literalValue>
        <name>Set Product Family to GlobalMeet</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Product_Family_to_iMeet</fullName>
        <field>ProductType__c</field>
        <literalValue>Web: iMeet</literalValue>
        <name>Set Product Family to iMeet</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Usage_Type_to_Monthly_License</fullName>
        <field>UsageType__c</field>
        <literalValue>Monthly Licenses</literalValue>
        <name>Set Usage Type to Monthly License</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Usage_Type_to_Revenue</fullName>
        <field>UsageType__c</field>
        <literalValue>Revenue</literalValue>
        <name>Set Usage Type to Revenue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Usage_Type_to_Weekly_License</fullName>
        <field>UsageType__c</field>
        <literalValue>Weekly LIcenses</literalValue>
        <name>Set Usage Type to Weekly License</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set AsOfmonth to this year</fullName>
        <actions>
            <name>Set_AsOfmonth_to_this_year</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>YEAR(AsofMonthDate__c) = YEAR(TODAY())</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Product Family to GlobalMeet</fullName>
        <actions>
            <name>Set_Product_Family_to_GlobalMeet</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ClientUsageInfo__c.ClientUsageId__c</field>
            <operation>contains</operation>
            <value>globalmeet</value>
        </criteriaItems>
        <description>For use with License Usage files; not active yet as no process for extracting GM licenses</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Product Family to iMeet</fullName>
        <actions>
            <name>Set_Product_Family_to_iMeet</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ClientUsageInfo__c.ClientUsageId__c</field>
            <operation>contains</operation>
            <value>imeet</value>
        </criteriaItems>
        <description>For use with License Usage files</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Usage Type to Monthly License</fullName>
        <actions>
            <name>Set_Usage_Type_to_Monthly_License</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>OR(
      ! ISBLANK(Cancelled_Billable__c),
      ! ISBLANK(Active_Billable__c ),
      ! ISBLANK(Active_Trial__c ),
      ! ISBLANK(Expired_Trial__c ),
      ! ISBLANK(N_A_Licenses__c ),
      ! ISBLANK(Total_Licenses_Non_N_A__c )
)
)</description>
        <formula>AND(            ISPICKVAL(UsageType__c, &quot;&quot;),            CONTAINS(ClientUsageId__c, &quot;m-&quot;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Usage Type to Revenue</fullName>
        <actions>
            <name>Set_Usage_Type_to_Revenue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ClientUsageInfo__c.Revenue__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>ClientUsageInfo__c.UsageType__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Usage Type to Weekly License</fullName>
        <actions>
            <name>Set_Usage_Type_to_Weekly_License</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>OR(
      ! ISBLANK(Cancelled_Billable__c),
      ! ISBLANK(Active_Billable__c ),
      ! ISBLANK(Active_Trial__c ),
      ! ISBLANK(Expired_Trial__c ),
      ! ISBLANK(N_A_Licenses__c ),
      ! ISBLANK(Total_Licenses_Non_N_A__c )
)
)</description>
        <formula>AND(            ISPICKVAL(UsageType__c, &quot;&quot;),            CONTAINS(ClientUsageId__c, &quot;w-&quot;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
