<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>At_Risk_Customer_Email</fullName>
        <description>At Risk Customer Email</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <field>Acct_Owner_Supervisor_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>carmen.legrange@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>shakeria.walker@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/At_Risk_Customer</template>
    </alerts>
    <fieldUpdates>
        <fullName>Account_Source_Custom_Update</fullName>
        <field>Account_Source__c</field>
        <literalValue>DnB_Data.com</literalValue>
        <name>Account Source Custom Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Status_Update</fullName>
        <field>Status__c</field>
        <literalValue>Customer</literalValue>
        <name>Account Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_AE_SE_Mgr</fullName>
        <field>OwnerId</field>
        <lookupValue>carmen.legrange@pgi.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Assign to AE/SE Mgr</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BillingCity_Update</fullName>
        <field>BillingCity</field>
        <formula>DandbCompany.City</formula>
        <name>BillingCity Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BillingCountry_Update</fullName>
        <field>BillingCountry</field>
        <formula>DandbCompany.Country</formula>
        <name>BillingCountry Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BillingPostalCode_Update</fullName>
        <field>BillingPostalCode</field>
        <formula>DandbCompany.PostalCode</formula>
        <name>BillingPostalCode Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BillingState_Update</fullName>
        <field>BillingState</field>
        <formula>DandbCompany.State</formula>
        <name>BillingState Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BillingStreet_Update</fullName>
        <field>BillingStreet</field>
        <formula>DandbCompany.Street</formula>
        <name>BillingStreet Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Checks_Exclude_from_Integration</fullName>
        <description>A field update makes Exclude_from_Integration__c TRUE when Status = Prospect OR Count of Companies = 0</description>
        <field>Exclude_from_Integration__c</field>
        <literalValue>1</literalValue>
        <name>Checks Exclude from Integration</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CompanyAnnualRevenue_Update</fullName>
        <field>Duns_Annual_Revenue__c</field>
        <formula>DandbCompany.SalesVolume</formula>
        <name>CompanyAnnualRevenue Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_to_zz_Partner</fullName>
        <description>Field Update: Partner__r.Name updates Account: zz-Copy of Partner</description>
        <field>zz_Copy_of_Partner__c</field>
        <formula>Partner__r.Name</formula>
        <name>Copy to zz-Partner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DUNSCompanyName_Update</fullName>
        <field>Duns_Company_Name__c</field>
        <formula>DandbCompany.Name</formula>
        <name>DUNSCompanyName Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DUNS_Custom_to_Standard</fullName>
        <field>DunsNumber</field>
        <formula>Duns_Number__c</formula>
        <name>DUNS Custom to Standard</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DnB_Last_Modified</fullName>
        <field>DnB_Last_Modified_Date__c</field>
        <formula>TODAY()</formula>
        <name>DnB Last Modified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DomesticUltimateDUNS_Update</fullName>
        <field>Domestic_Ultimate_Duns__c</field>
        <formula>DandbCompany.DomesticUltimateDunsNumber</formula>
        <name>DomesticUltimateDUNS Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DomesticUltimateName_Update</fullName>
        <field>Domestic_Ultimate_Name__c</field>
        <formula>DandbCompany.DomesticUltimateBusinessName</formula>
        <name>DomesticUltimateName Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Domestic_Ultimate_HQ</fullName>
        <field>Location_type__c</field>
        <literalValue>Domestic Ultimate HQ</literalValue>
        <name>Domestic Ultimate HQ</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DunsNumber_Update</fullName>
        <field>Duns_Number__c</field>
        <formula>DandbCompany.DunsNumber</formula>
        <name>DunsNumber Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DunsNumber_Update_Unique</fullName>
        <description>Copies standard DUNSNumber value to custom DUNS_Number__c.</description>
        <field>Duns_Number__c</field>
        <formula>DunsNumber</formula>
        <name>DunsNumber Update Unique</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EmployeesAtThisLocation_Update</fullName>
        <field>Employees_At_This_Location__c</field>
        <formula>DandbCompany.EmployeesHere</formula>
        <name>EmployeesAtThisLocation Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EmployeesTotal_Update</fullName>
        <field>Employee_Total_All_Locations__c</field>
        <formula>DandbCompany.EmployeesTotal</formula>
        <name>EmployeesTotal Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GlobalUltimateDUNS_Update</fullName>
        <field>Global_Ultimate_Duns__c</field>
        <formula>DandbCompany.GlobalUltimateDunsNumber</formula>
        <name>GlobalUltimateDUNS Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GlobalUltimateName_Update</fullName>
        <field>Global_Ultimate_Name__c</field>
        <formula>DandbCompany.GlobalUltimateBusinessName</formula>
        <name>GlobalUltimateName Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Headquarters</fullName>
        <field>Location_type__c</field>
        <literalValue>Headquarters</literalValue>
        <name>Headquarters</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Headquarters_HQ</fullName>
        <field>Account_Hierarchy_Type__c</field>
        <literalValue>HQ</literalValue>
        <name>Headquarters = HQ</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Legal_Name_Indicator_Update</fullName>
        <field>Legal_Name_Indicator__c</field>
        <literalValue>1</literalValue>
        <name>Legal Name Indicator Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Likely_Set_Likely_Annual_Revenue</fullName>
        <description>Sets the Likely Revenue from what is on the Ultimate Parent</description>
        <field>Likely_Annual_Revenue__c</field>
        <formula>IF(
!ISNULL(Likely_Ultimate_Parent__r.AnnualRevenue),  Likely_Ultimate_Parent__r.AnnualRevenue, -1
)</formula>
        <name>Likely-Set Likely Annual Revenue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Likely_Set_Likely_Industry</fullName>
        <description>Sets the Likely Industry from what is on the Ultimate Parent</description>
        <field>Likely_Industry__c</field>
        <formula>IF(
!ISNULL(TEXT(Likely_Ultimate_Parent__r.Industry)),  TEXT(Likely_Ultimate_Parent__r.Industry), &quot;&quot;
)</formula>
        <name>Likely-Set Likely Industry</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Likely_Set_Likely_No_of_Employees</fullName>
        <description>Sets the Likely No. of Employees from what is on the Ultimate Parent</description>
        <field>Likely_Number_of_Employees__c</field>
        <formula>IF(
!ISNULL(Likely_Ultimate_Parent__r.NumberOfEmployees),  Likely_Ultimate_Parent__r.NumberOfEmployees, -1
)</formula>
        <name>Likely-Set Likely No. of Employees</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Likely_Set_Likely_State_Province</fullName>
        <description>Sets the Likely State/Province from what is on the Ultimate Parent</description>
        <field>Likely_State_Province__c</field>
        <formula>IF(
!ISNULL(Likely_Ultimate_Parent__r.BillingState),  Likely_Ultimate_Parent__r.BillingState, &quot;&quot;
)</formula>
        <name>Likely-Set Likely State/Province</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Likely_Set_Likely_Zip_Code</fullName>
        <description>Sets the Likely Postal Code from what is on the Ultimate Parent</description>
        <field>Likely_Zip_Code__c</field>
        <formula>IF(
!ISNULL(Likely_Ultimate_Parent__r.BillingPostalCode),  Likely_Ultimate_Parent__r.BillingPostalCode, &quot;&quot;
)</formula>
        <name>Likely-Set Likely Zip Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Likely_Unset_Likely_Industry</fullName>
        <field>Likely_Industry__c</field>
        <name>Likely-Unset Likely Industry</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Likely_Unset_Likely_No_of_Employees</fullName>
        <field>Likely_Number_of_Employees__c</field>
        <name>Likely-Unset Likely No. of Employees</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Likely_Unset_Likely_Revenue</fullName>
        <field>Likely_Annual_Revenue__c</field>
        <name>Likely-Unset Likely Revenue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Likely_Unset_Likely_State_Province</fullName>
        <field>Likely_State_Province__c</field>
        <name>Likely-Unset Likely State/Province</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Likely_Unset_Likely_Zip_Code</fullName>
        <field>Likely_Zip_Code__c</field>
        <name>Likely-Unset Likely Zip Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Location_type_c_Global_Ultimate_HQ</fullName>
        <field>Location_type__c</field>
        <literalValue>Global Ultimate HQ</literalValue>
        <name>Location_type_c = &quot;Global Ultimate HQ&quot;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Change_Date_Update</fullName>
        <field>Ownership_Change_Date__c</field>
        <formula>Today()</formula>
        <name>Owner Change Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PGI_Hierarchy_Location_Type</fullName>
        <field>Account_Hierarchy_Type__c</field>
        <literalValue>Ultimate HQ</literalValue>
        <name>PGI Hierarchy/Location Type = Ultimate H</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PGI_Hierarchy_Location_Type_Domestic</fullName>
        <field>Account_Hierarchy_Type__c</field>
        <literalValue>HQ</literalValue>
        <name>PGI Hierarchy/Location Type = Domestic</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ParentDUNSNumber_Update</fullName>
        <field>Parent_Duns_Number__c</field>
        <formula>DandbCompany.ParentOrHqDunsNumber</formula>
        <name>ParentDUNSNumber Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ParentName_Update</fullName>
        <field>Duns_Parents_Name__c</field>
        <formula>DandbCompany.ParentOrHqBusinessName</formula>
        <name>ParentName Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SICDesc_Update</fullName>
        <field>SicDesc</field>
        <formula>DandbCompany.PrimarySicDesc</formula>
        <name>SICDesc Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SIC_Update</fullName>
        <field>Sic</field>
        <formula>DandbCompany.PrimarySic</formula>
        <name>SIC Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Exclude_from_Integration</fullName>
        <field>Exclude_from_Integration__c</field>
        <literalValue>1</literalValue>
        <name>Set Exclude from Integration to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Exclude_from_Integration_to_False</fullName>
        <field>Exclude_from_Integration__c</field>
        <literalValue>0</literalValue>
        <name>Set Exclude from Integration to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Inactive_Reason</fullName>
        <field>Inactive_Reason__c</field>
        <literalValue>No Recent Activity</literalValue>
        <name>Set Inactive Reason</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Inactive_Reason_to_NULL</fullName>
        <field>Inactive_Reason__c</field>
        <name>Set Inactive Reason to NULL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Last_Mod_by_Date_by_Non_admin</fullName>
        <field>Last_modified_Date_by_non_admin__c</field>
        <formula>NOW()</formula>
        <name>Set Last Mod by Date by Non-admin</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_NZL_to_True</fullName>
        <field>NZL__c</field>
        <literalValue>1</literalValue>
        <name>Set NZL to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Owner_for_Inactive_AAE_to_Mgr_for_Ce</fullName>
        <field>OwnerId</field>
        <lookupValue>brian.morse@pgi.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Set Owner for Inactive/AAE to Mgr for Ce</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Owner_for_Inactive_AAE_to_Mgr_for_SE</fullName>
        <field>OwnerId</field>
        <lookupValue>mark.turner@pgi.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Set Owner for Inactive/AAE to Mgr for SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Sub_Status_field_to_be_Assigned</fullName>
        <field>Status_Detail__c</field>
        <literalValue>Assigned</literalValue>
        <name>Set Sub-Status field to be Assigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Sub_status_to_Inactive</fullName>
        <field>Status_Detail__c</field>
        <literalValue>Inactive</literalValue>
        <name>Set Sub-status to Inactive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Supervisor_Email</fullName>
        <field>Acct_Owner_Supervisor_Email__c</field>
        <formula>Owner_Copy__r.Manager.Email</formula>
        <name>Set Supervisor Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Type_to_E_Commerce</fullName>
        <field>Type</field>
        <literalValue>Unknown</literalValue>
        <name>Set Type to Unknown</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_to_Inactive_Mgr</fullName>
        <field>Status_Detail__c</field>
        <literalValue>Inactive - Mgr</literalValue>
        <name>Set to Inactive - Mgr</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Single_Locaiton</fullName>
        <field>Location_type__c</field>
        <literalValue>Single Location</literalValue>
        <name>Single Locaiton</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Single_Location_to_Single_Locaiton</fullName>
        <field>Account_Hierarchy_Type__c</field>
        <literalValue>Single Location</literalValue>
        <name>Single Location to Single Locaiton</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SmallBusinessIndicator_Update</fullName>
        <field>Small_Business_Indicator__c</field>
        <literalValue>1</literalValue>
        <name>SmallBusinessIndicator Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Subsidiary_Indicator_update</fullName>
        <field>Subsidiary_Indicator__c</field>
        <literalValue>1</literalValue>
        <name>Subsidiary Indicator update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TradeName_Update</fullName>
        <field>Trade_Name__c</field>
        <formula>DandbCompany.TradeStyle1</formula>
        <name>TradeName Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_Status_to_Customer</fullName>
        <field>Status__c</field>
        <literalValue>Prospect</literalValue>
        <name>Update Account Status to Prospect</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_PGi_Hierarchy_Location_Type</fullName>
        <description>Update PGi Hierarchy/Location Type is set to &quot;Regional/Local Site&quot; when D&amp; B Company Location Type = Branch.</description>
        <field>Account_Hierarchy_Type__c</field>
        <literalValue>Regional/Local Site</literalValue>
        <name>Update PGi Hierarchy/Location Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>*Update* Set NZL Flag</fullName>
        <actions>
            <name>Set_NZL_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3 OR 4 OR 5</booleanFilter>
        <criteriaItems>
            <field>Account.BillingCountry</field>
            <operation>equals</operation>
            <value>NZL,New Zealand</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Territory_Code_Partner_Only__c</field>
            <operation>equals</operation>
            <value>AP001,APA000,APA116,APN230,APN250,APN251,APN252,APN256,APN257,APN260</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Territory_Code_Partner_Only__c</field>
            <operation>equals</operation>
            <value>APN262,D0964</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>contains</operation>
            <value>michael foot</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.NZL__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Sets the NZL checkbox to be true

**Need to add back in Assign to PGi Data migration Field update once clean-up is done.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Assign Partner Name</fullName>
        <actions>
            <name>Copy_to_zz_Partner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Partner__r.Name = &quot;Orange&quot; || Partner__r.Name = &quot;Tata&quot;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>At Risk Customer</fullName>
        <actions>
            <name>At_Risk_Customer_Email</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Status_Detail__c</field>
            <operation>equals</operation>
            <value>At Risk</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>equals</operation>
            <value>Customer</value>
        </criteriaItems>
        <description>At Risk Customer</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Custom DUNS Number Update</fullName>
        <actions>
            <name>DunsNumber_Update_Unique</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.DunsNumber</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Copies standard DUNSNumber value to custom DUNS_Number__c.  DUNS_Number__c is set to unique.  This is part of the validation to prevent the entry of accounts with already existing DUNS #.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>D%26B</fullName>
        <actions>
            <name>BillingCity_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>BillingCountry_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>BillingPostalCode_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>BillingState_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>BillingStreet_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>DomesticUltimateDUNS_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>DomesticUltimateName_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>DunsNumber_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>EmployeesAtThisLocation_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>EmployeesTotal_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 AND 2) OR (3 AND 4)</booleanFilter>
        <criteriaItems>
            <field>Account.CleanStatus</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>DandBCompany.LocationStatus</field>
            <operation>notEqual</operation>
            <value>Branch. Secondary location to a headquarters location</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.AccountSource</field>
            <operation>equals</operation>
            <value>Data.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>DandBCompany.LocationStatus</field>
            <operation>notEqual</operation>
            <value>Branch. Secondary location to a headquarters location</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>D%26B 2</fullName>
        <actions>
            <name>Account_Source_Custom_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CompanyAnnualRevenue_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>DUNSCompanyName_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>GlobalUltimateDUNS_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Legal_Name_Indicator_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ParentDUNSNumber_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ParentName_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SICDesc_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SIC_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>TradeName_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 AND 2) OR (3 AND 4)</booleanFilter>
        <criteriaItems>
            <field>Account.CleanStatus</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>DandBCompany.LocationStatus</field>
            <operation>notEqual</operation>
            <value>Branch. Secondary location to a headquarters location</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.AccountSource</field>
            <operation>equals</operation>
            <value>Data.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>DandBCompany.LocationStatus</field>
            <operation>notEqual</operation>
            <value>Branch. Secondary location to a headquarters location</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>D%26B 3</fullName>
        <actions>
            <name>GlobalUltimateName_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 AND 2) OR (3 AND 4)</booleanFilter>
        <criteriaItems>
            <field>Account.CleanStatus</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>DandBCompany.LocationStatus</field>
            <operation>notEqual</operation>
            <value>Branch. Secondary location to a headquarters location</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.AccountSource</field>
            <operation>equals</operation>
            <value>Data.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>DandBCompany.LocationStatus</field>
            <operation>notEqual</operation>
            <value>Branch. Secondary location to a headquarters location</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DNB Last Modified</fullName>
        <actions>
            <name>DnB_Last_Modified</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>OR( ISCHANGED(AccountSource), ISCHANGED(CleanStatus) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DUNS Custom to Standard</fullName>
        <actions>
            <name>DUNS_Custom_to_Standard</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Duns_Number__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Data%2Ecom Cleaning Branch</fullName>
        <actions>
            <name>Update_PGi_Hierarchy_Location_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.CleanStatus</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>DandBCompany.LocationStatus</field>
            <operation>equals</operation>
            <value>Branch. Secondary location to a headquarters location</value>
        </criteriaItems>
        <description>When Clean is allowed on a branch location, the PGi Hierarchy/Location Type is set to &quot;Regional/Local Site&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Domestic Ultimate HQ to HQ</fullName>
        <actions>
            <name>Headquarters_HQ</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PGI_Hierarchy_Location_Type_Domestic</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Account.Location_type__c</field>
            <operation>equals</operation>
            <value>Domestic Ultimate HQ</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Location_type__c</field>
            <operation>equals</operation>
            <value>Headquarters</value>
        </criteriaItems>
        <description>​If Location_type__c is Domestic Ultimate HQ, Account_Hierarchy_Type__c = HQ OR if If Location_type__c​ is Headquarters,Account_Hierarchy_Type__c = HQ​​</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Global Ultimate HQ to Ultimate HQ</fullName>
        <actions>
            <name>PGI_Hierarchy_Location_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Location_type__c</field>
            <operation>equals</operation>
            <value>Global Ultimate HQ</value>
        </criteriaItems>
        <description>​If Location_type__c is Global Ultimate HQ, Account_Hierarchy_Type__c Ultimate HQ</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Likely Fields UNset on Ultimate Parent</fullName>
        <actions>
            <name>Likely_Unset_Likely_Industry</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Likely_Unset_Likely_No_of_Employees</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Likely_Unset_Likely_Revenue</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Likely_Unset_Likely_State_Province</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Likely_Unset_Likely_Zip_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND( ISBLANK(Likely_Ultimate_Parent__c), NOT( ISBLANK( PRIORVALUE(Likely_Ultimate_Parent__c))) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Likely Fields set on Ultimate Parent</fullName>
        <actions>
            <name>Likely_Set_Likely_Annual_Revenue</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Likely_Set_Likely_Industry</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Likely_Set_Likely_No_of_Employees</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Likely_Set_Likely_State_Province</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Likely_Set_Likely_Zip_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>! ISBLANK(Likely_Ultimate_Parent__c)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Location Type 1</fullName>
        <actions>
            <name>Location_type_c_Global_Ultimate_HQ</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When DnB Object field LocationStatus is populated with 
* &quot;Headquarters/Parent&quot; and the Duns_Number_c=Global_Ultimate_Duns_c, then Location_type_c = &quot;Global Ultimate HQ&quot;</description>
        <formula>AND( ISPICKVAL(DandbCompany.LocationStatus, &quot;Headquarters/Parent. Branches and/or subsidiaries report to the business&quot;), Duns_Number__c = Global_Ultimate_Duns__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Location Type 2</fullName>
        <actions>
            <name>Domestic_Ultimate_HQ</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When DnB Object field LocationStatus is populated with &quot;Headquarters/Parent&quot; and the Duns_Number_c = Domestic_Ultimate_Duns_c, then Location_type_c = &quot;Domestic Ultimate HQ&quot;</description>
        <formula>AND( ISPICKVAL(DandbCompany.LocationStatus, &quot;Headquarters/Parent. Branches and/or subsidiaries report to the business&quot;), Duns_Number__c = Domestic_Ultimate_Duns__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Location Type 3</fullName>
        <actions>
            <name>Headquarters</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When DnB Object field LocationStatus is populated with &quot;Headquarters/Parent&quot; and the Duns_Number_c = Domestic_Ultimate_Duns_c, then Location_type_c = &quot;Domestic Ultimate HQ&quot;</description>
        <formula>AND( ISPICKVAL(DandbCompany.LocationStatus, &quot;Headquarters/Parent. Branches and/or subsidiaries report to the business&quot;), Duns_Number__c &lt;&gt; Domestic_Ultimate_Duns__c, Duns_Number__c &lt;&gt; Global_Ultimate_Duns__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Location Type 4</fullName>
        <actions>
            <name>Single_Locaiton</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When DnB Object field LocationStatus is populated with &quot;Single Location&quot;, then Location_type_c = Single Location.</description>
        <formula>ISPICKVAL(DandbCompany.LocationStatus, &quot;Single Location&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Exclude from Integration to False</fullName>
        <actions>
            <name>Set_Exclude_from_Integration_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets to False so that Account Ownership is set via the integration process</description>
        <formula>AND( NOT( AND( OR( Partner__r.Name = &quot;Tata&quot;, Partner__r.Name = &quot;Orange&quot;, ISPICKVAL( Account_Hierarchy_Type__c, &quot;Ultimate HQ&quot;)  ), ISPICKVAL( Type, &quot;Diamond&quot;) )),  Billed_Rev_Prev_13_Months__c &gt; 0,  
Name &lt;&gt; &quot;American Teleconferencing Services,Ltd. d/b/a PGi&quot;,
Name &lt;&gt; &quot;PGi Employees, Internal Use Only&quot;,  Exclude_from_Integration__c = TRUE, ! CONTAINS(Name, &quot;Unmatch&quot;),  ! CONTAINS(Name, &quot;Unidentified&quot;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Exclude from Integration to True</fullName>
        <actions>
            <name>Set_Exclude_from_Integration</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3) AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Account.Count_of_all_Companies__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Billed_Rev_Prev_13_Months__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Billed_Rev_Prev_13_Months__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Exclude_from_Integration__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>equals</operation>
            <value>Prospect</value>
        </criteriaItems>
        <description>Sets to True so that Account Ownership isnt set via the integration process</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Last Mod Date by Non_admin</fullName>
        <actions>
            <name>Set_Last_Mod_by_Date_by_Non_admin</name>
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
        <fullName>Set Owner for Inactive%2FAAE to Mgr for Central</fullName>
        <actions>
            <name>Set_Owner_for_Inactive_AAE_to_Mgr_for_Ce</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND( ISPICKVAL(Type, &quot;AAE&quot;), ISPICKVAL(Status__c, &quot;Prospect&quot;), ISPICKVAL(Status_Detail__c, &quot;Inactive&quot;), ISPICKVAL(Inactive_Reason__c, &quot;No Recent Activity&quot;), OR( State_Province_of_Ult_Parent__c = &quot;IA&quot;, State_Province_of_Ult_Parent__c = &quot;IL&quot;, State_Province_of_Ult_Parent__c = &quot;IN&quot;, State_Province_of_Ult_Parent__c = &quot;KS&quot;, State_Province_of_Ult_Parent__c = &quot;KY&quot;, State_Province_of_Ult_Parent__c = &quot;MI&quot;, State_Province_of_Ult_Parent__c = &quot;MN&quot;, State_Province_of_Ult_Parent__c = &quot;MO&quot;, State_Province_of_Ult_Parent__c = &quot;ND&quot;, State_Province_of_Ult_Parent__c = &quot;NE&quot;, State_Province_of_Ult_Parent__c = &quot;OH&quot;, State_Province_of_Ult_Parent__c = &quot;SD&quot;, State_Province_of_Ult_Parent__c = &quot;WI&quot; ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Owner for Inactive%2FAAE to Mgr for SE</fullName>
        <actions>
            <name>Set_Owner_for_Inactive_AAE_to_Mgr_for_SE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND( ISPICKVAL(Type, &quot;AAE&quot;), ISPICKVAL(Status__c, &quot;Prospect&quot;), ISPICKVAL(Status_Detail__c, &quot;Inactive&quot;), ISPICKVAL(Inactive_Reason__c, &quot;No Recent Activity&quot;), OR( State_Province_of_Ult_Parent__c = &quot;AL&quot;, State_Province_of_Ult_Parent__c = &quot;FL&quot;, State_Province_of_Ult_Parent__c = &quot;GA&quot;, State_Province_of_Ult_Parent__c = &quot;NC&quot;, State_Province_of_Ult_Parent__c = &quot;SC&quot;, State_Province_of_Ult_Parent__c = &quot;TN&quot; ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Owner for Inactive%2FAE to Mgr for SE</fullName>
        <actions>
            <name>Assign_to_AE_SE_Mgr</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND( ISPICKVAL(Type, &quot;AE&quot;), ISPICKVAL(Status__c, &quot;Prospect&quot;), ISPICKVAL(Status_Detail__c, &quot;Inactive&quot;), ISPICKVAL(Inactive_Reason__c, &quot;No Recent Activity&quot;), OR( State_Province_of_Ult_Parent__c = &quot;AL&quot;, State_Province_of_Ult_Parent__c = &quot;FL&quot;, State_Province_of_Ult_Parent__c = &quot;GA&quot;, State_Province_of_Ult_Parent__c = &quot;NC&quot;, State_Province_of_Ult_Parent__c = &quot;SC&quot;, State_Province_of_Ult_Parent__c = &quot;TN&quot; ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Sub-Status field to be Assigned</fullName>
        <actions>
            <name>Set_Inactive_Reason_to_NULL</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Sub_Status_field_to_be_Assigned</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  OR( Count_of_Recent_Tasks__c  &gt; 0,  Count_of_Recent_Events__c &gt; 0,             Count_of_Recent_Attachments__c  &gt; 0, 	   Count_of_Recent_Contacts__c  &gt; 0,            Count_of_Recent_Leads__c  &gt; 0, 	   Count_of_Recent_Notes__c  &gt; 0, 	   Count_of_Recent_Opportunities__c  &gt; 0, 	   Ownership_Change_Date__c  &gt;=  TODAY()-90, ISPICKVAL(Status__c, &quot;Customer&quot;) ),   OR( ISPICKVAL(Inactive_Reason__c, &quot;No Recent Activity&quot;), ISPICKVAL(Inactive_Reason__c, &quot;&quot;)  ), Owner_Copy__r.isManager1__c = False, !CONTAINS(Owner_Copy__r.LastName, &quot;x-&quot;), !CONTAINS(Owner_Copy__r.LastName, &quot;(RAL)&quot;), !CONTAINS(Owner_Copy__r.LastName, &quot;Migration&quot;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Sub-Status field to be Inactive</fullName>
        <actions>
            <name>Set_Inactive_Reason</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Sub_status_to_Inactive</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>a.	Fire whenever all of the Count of Recent fields are set to a value of zero &amp; the Ownership Change Date is &gt; TODAY () – 90 &amp; the Type Field is either AE or AAE
b.	Set Sub-Status to a value of Inactive</description>
        <formula>AND( OR( AND(  Count_of_Recent_Tasks__c  = 0,  Count_of_Recent_Events__c =0,             Count_of_Recent_Attachments__c  = 0, 	   Count_of_Recent_Contacts__c  = 0,            Count_of_Recent_Leads__c  = 0, 	   Count_of_Recent_Notes__c  = 0, 	   Count_of_Recent_Opportunities__c  = 0, 	   OR( Ownership_Change_Date__c  &lt;  TODAY()-90, 	   ISBLANK(Ownership_Change_Date__c) ), OR(   ISPICKVAL(Type, &quot;AAE&quot;),              ISPICKVAL(Type, &quot;AE&quot;), ISPICKVAL(Type, &quot;E-Commerce&quot;) )), OR( CONTAINS(Owner_Copy__r.LastName, &quot;x-&quot;), CONTAINS(Owner_Copy__r.LastName, &quot;Migration&quot;), CONTAINS(Owner_Copy__r.LastName, &quot;(RAL)&quot;) )), ISPICKVAL(Status__c, &quot;Prospect&quot;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Supervisors email</fullName>
        <actions>
            <name>Set_Supervisor_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Type to Unknown</fullName>
        <actions>
            <name>Set_Type_to_E_Commerce</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Owner_Region__c</field>
            <operation>equals</operation>
            <value>NA</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set value of Ownership Change to Today</fullName>
        <actions>
            <name>Owner_Change_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(ISNEW(),ISCHANGED(OwnerId))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Single Location to Single Locaiton</fullName>
        <actions>
            <name>Single_Location_to_Single_Locaiton</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Location_type__c</field>
            <operation>equals</operation>
            <value>Single Location</value>
        </criteriaItems>
        <description>If Location_type__c​ is Single Location, Account_Hierarchy_Type__c  = Single Location</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SmallBusinessIndicator Update</fullName>
        <actions>
            <name>SmallBusinessIndicator_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>DandBCompany.SmallBusiness</field>
            <operation>equals</operation>
            <value>Small business site</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Subsidiary Indicator update</fullName>
        <actions>
            <name>Subsidiary_Indicator_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>DandBCompany.Subsidiary</field>
            <operation>equals</operation>
            <value>Subsidiary of another organization</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Account Status to Customer</fullName>
        <actions>
            <name>Account_Status_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3 OR 4 OR 5</booleanFilter>
        <criteriaItems>
            <field>Account.Total_Partner_Enterprises__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Billed_Rev_Prev_13_Months__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Territory_Code_Partner_Only__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Count_of_Companies__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>equals</operation>
            <value>ACT</value>
        </criteriaItems>
        <description>To update account status to customer,  If  [Territory Code (Partner Only)] is NOT NULL or [Total Partner Enterprises] IS &gt;0 OR Billed Revenue last 13 months is &gt; 0 OR Companies (Recent Count of) &gt; 0</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Account Status to Prospect</fullName>
        <actions>
            <name>Update_Account_Status_to_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3 AND 4 AND (5 OR 7) AND 6</booleanFilter>
        <criteriaItems>
            <field>Account.Billed_Rev_Prev_13_Months__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Billed_Rev_Prev_13_Months__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Total_Partner_Enterprises__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Territory_Code_Partner_Only__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Count_of_Companies__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>notEqual</operation>
            <value>ACT</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Count_of_Companies__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
