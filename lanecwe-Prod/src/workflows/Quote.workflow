<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CIF_Email_notification</fullName>
        <ccEmails>istcif@pgi.com</ccEmails>
        <description>CIF Email notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>andrew.davidson@pgi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CIF_Email_Template_for_Deals</template>
    </alerts>
    <alerts>
        <fullName>Contract_Team_Created_Q_C_Email_Alert_to_Opportunity_Owner</fullName>
        <description>Contract Team Created Q/C - Email Alert to Opportunity Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Contract_Team_Created_Q_C</template>
    </alerts>
    <alerts>
        <fullName>Email_Notify_of_DS_Internal_Signed</fullName>
        <description>Email Notify of DS Internal Signed</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Docusign_Templates/DS_Signed_by_Internal_Signer</template>
    </alerts>
    <alerts>
        <fullName>Email_notify_of_Approved</fullName>
        <description>Email notify of Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_Emails/Request_Approved</template>
    </alerts>
    <alerts>
        <fullName>Email_notify_of_Rejected</fullName>
        <description>Email notify of Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_Emails/Request_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>ChangePageLayout_QuoteLayout</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Editable_Record_type_for_Users_of_Level_1_and_Level_2</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ChangePageLayout-QuoteLayout</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_RT_to_signed_contract</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Ready_for_Closed_Won</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change RT to signed contract</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DisableQouteContractButton</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ApprovalRecordType</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>DisableQouteContractButton</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PopulateOpportunityDescriptionToQuote</fullName>
        <field>Description</field>
        <formula>Opportunity.Description</formula>
        <name>PopulateOpportunityDescriptionToQuote</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QuoteCloneLayout</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Record_Type_for_Cloned_Records</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>QuoteCloneLayout</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QuoteInterestPenaltyPercent_field_update</fullName>
        <field>InterestPenaltyPercent__c</field>
        <literalValue>1.5</literalValue>
        <name>Quote:InterestPenaltyPercent fieldupdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quote_Contract_Document_Generated</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ConractDocumentGeneration</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Quote:Contract Document Generated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quote_DefaultPagelayout</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Editable_Record_Type</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Quote:DefaultPagelayout</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quote_Read_only_on_Submit_Approval</fullName>
        <description>Change Page layout to ready only</description>
        <field>RecordTypeId</field>
        <lookupValue>Readonly_Record_Type</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Quote:Read only on Submit Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quote_Read_only_without_Total_margin_for</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Readonly_Record_Type</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set RT to Read only Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Refresh_the_Date_CEA_Date_to_Become</fullName>
        <description>Sets this value again in case it has been modified or gotten out of sync.</description>
        <field>Auto_Renewal_Contract_End_Anniversary_Da__c</field>
        <formula>DATE( 
/*YEAR*/ 
YEAR( Contract_End_Anniversary_Date_2__c) + FLOOR((MONTH(Contract_End_Anniversary_Date_2__c) + SC_Auto_renewal_Interval_in_months__c - 1)/12), 
/*MONTH*/ 
CASE(MOD(MONTH(Contract_End_Anniversary_Date_2__c)+SC_Auto_renewal_Interval_in_months__c, 12), 
/*value = if the month of the C_E_A_D_2 is 12, the above calculation evaluates to 0, therefore, the result1 should be 12. 12 is the only month that evaluates to something other than its #, so it requires a CASE*/ 
0,12, 
/*else_result is the same MOD(MONTH( equation as above, because it works for months 1-11*/ 
MOD(MONTH(Contract_End_Anniversary_Date_2__c )+SC_Auto_renewal_Interval_in_months__c, 12 )),/*for example,(9+24)/12=2.75-2=.75*12=9*/ 
/*DAY*/ 
/*So the MIN returns the lowest value for the CASE and the IF below. If the lowest value is just DAY(C_E_A_D_2), then great. But if it&apos;s the last day of one of the 30 day months, or 2/28 or 2/29 on a leap year, then the below CASE and IF functions determine if that is the case and then provide the appropriate day*/ 
MIN(DAY(Contract_End_Anniversary_Date_2__c), 
CASE(MOD(MONTH(Contract_End_Anniversary_Date_2__c)+SC_Auto_renewal_Interval_in_months__c,12),/*for example,(7+12)/12=1.58-1=.58*12=7*/ 
9,30, 
4,30, 
6,30, 
11,30, 
2, /* result for 2 = return max days for February dependent on if end date is leap year */ 
IF(MOD(YEAR(Contract_End_Anniversary_Date_2__c) + FLOOR((MONTH(Contract_End_Anniversary_Date_2__c ) + SC_Auto_renewal_Interval_in_months__c)/12) , 400 ) = 0 || (MOD(YEAR(Contract_End_Anniversary_Date_2__c) + FLOOR((MONTH (Contract_End_Anniversary_Date_2__c) + SC_Auto_renewal_Interval_in_months__c)/12) , 4 ) = 0 &amp;&amp; MOD(YEAR(Contract_End_Anniversary_Date_2__c) + FLOOR((MONTH(Contract_End_Anniversary_Date_2__c) + SC_Auto_renewal_Interval_in_months__c)/12) , 100 ) &lt;&gt; 0 
) 
, 29,28) 
,31 ) ) 
)</formula>
        <name>Refresh the Date CEA Date to Become</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Renew_CEA_Date</fullName>
        <description>Pushes the Contract End Anniversary Date forward the total number of months in the auto-renewal interval field</description>
        <field>Contract_End_Anniversary_Date_2__c</field>
        <formula>DATE( 
/*YEAR*/ 
YEAR( Contract_End_Anniversary_Date_2__c) + FLOOR((MONTH(Contract_End_Anniversary_Date_2__c) + SC_Auto_renewal_Interval_in_months__c - 1)/12), 
/*MONTH*/ 
CASE(MOD(MONTH(Contract_End_Anniversary_Date_2__c)+SC_Auto_renewal_Interval_in_months__c, 12), 
/*value = if the month of the C_E_A_D_2 is 12, the above calculation evaluates to 0, therefore, the result1 should be 12. 12 is the only month that evaluates to something other than its #, so it requires a CASE*/ 
0,12, 
/*else_result is the same MOD(MONTH( equation as above, because it works for months 1-11*/ 
MOD(MONTH(Contract_End_Anniversary_Date_2__c )+SC_Auto_renewal_Interval_in_months__c, 12 )),/*for example,(9+24)/12=2.75-2=.75*12=9*/ 
/*DAY*/ 
/*So the MIN returns the lowest value for the CASE and the IF below. If the lowest value is just DAY(C_E_A_D_2), then great. But if it&apos;s the last day of one of the 30 day months, or 2/28 or 2/29 on a leap year, then the below CASE and IF functions determine if that is the case and then provide the appropriate day*/ 
MIN(DAY(Contract_End_Anniversary_Date_2__c), 
CASE(MOD(MONTH(Contract_End_Anniversary_Date_2__c)+SC_Auto_renewal_Interval_in_months__c,12),/*for example,(7+12)/12=1.58-1=.58*12=7*/ 
9,30, 
4,30, 
6,30, 
11,30, 
2, /* result for 2 = return max days for February dependent on if end date is leap year */ 
IF(MOD(YEAR(Contract_End_Anniversary_Date_2__c) + FLOOR((MONTH(Contract_End_Anniversary_Date_2__c ) + SC_Auto_renewal_Interval_in_months__c)/12) , 400 ) = 0 || (MOD(YEAR(Contract_End_Anniversary_Date_2__c) + FLOOR((MONTH (Contract_End_Anniversary_Date_2__c) + SC_Auto_renewal_Interval_in_months__c)/12) , 4 ) = 0 &amp;&amp; MOD(YEAR(Contract_End_Anniversary_Date_2__c) + FLOOR((MONTH(Contract_End_Anniversary_Date_2__c) + SC_Auto_renewal_Interval_in_months__c)/12) , 100 ) &lt;&gt; 0 
) 
, 29,28) 
,31 ) ) 
)</formula>
        <name>Renew CEA Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Auto_Renewal_Counter</fullName>
        <field>Auto_Renewal_Counter__c</field>
        <name>Reset Auto Renewal Counter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Auto_Renewal_Counter_Date</fullName>
        <description>Sets back to NULL</description>
        <field>Auto_Renewal_Contract_End_Anniversary_Da__c</field>
        <name>Reset Auto Renewal Counter Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Generate_CIF_Form</fullName>
        <field>Generate_CIF_Form__c</field>
        <literalValue>0</literalValue>
        <name>Reset Generate CIF Form</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Admin_Contact_City</fullName>
        <field>Admin_Contact_City__c</field>
        <formula>Billing_Contact_City__c</formula>
        <name>Set Admin Contact City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Admin_Contact_Email</fullName>
        <field>Admin_Contact_Email__c</field>
        <formula>Billing_Contact_Email__c</formula>
        <name>Set Admin Contact Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Admin_Contact_Name</fullName>
        <field>Admin_Contact_Name__c</field>
        <formula>Billing_Contact_Name__c</formula>
        <name>Set Admin Contact Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Admin_Contact_Phone</fullName>
        <field>Admin_Contact_Phone__c</field>
        <formula>Billing_Contact_Phone__c</formula>
        <name>Set Admin Contact Phone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Admin_Contact_Postal_Code</fullName>
        <field>Admin_Contact_Postal_Code__c</field>
        <formula>Billing_Contact_Postal_Code__c</formula>
        <name>Set Admin Contact Postal Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Admin_Contact_State_Province</fullName>
        <field>Admin_Contact_State_Province__c</field>
        <formula>Billing_Contact_State_Province__c</formula>
        <name>Set Admin Contact State/Province</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Admin_Contact_Street</fullName>
        <field>Admin_Contact_Street__c</field>
        <formula>Billing_Contact_Street__c</formula>
        <name>Set Admin Contact Street</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Admin_Flag_to_False</fullName>
        <field>Admin_Flag__c</field>
        <literalValue>0</literalValue>
        <name>Set Admin Flag to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Auto_Renewal_Counter_to_1</fullName>
        <field>Auto_Renewal_Counter__c</field>
        <formula>1</formula>
        <name>Set Auto Renewal Counter to 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Auto_Renewal_Date</fullName>
        <field>Auto_Renewal_Contract_End_Anniversary_Da__c</field>
        <formula>TODAY()</formula>
        <name>Set Auto Renewal Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_CEA_Date_Active</fullName>
        <description>sets this once the CEA Date Original field has a value on Active Contracts</description>
        <field>CEA_Date_Active__c</field>
        <formula>CEA_Date_Original__c</formula>
        <name>Set CEA Date Active when no value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Company_City_Provisioning</fullName>
        <field>ShippingCity</field>
        <formula>BillingCity</formula>
        <name>Set Company City (Provisioning)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Company_Name_Provisioning</fullName>
        <field>ShippingName</field>
        <formula>BillingName</formula>
        <name>Set Company Name (Provisioning)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Contract_Doc_Status_for_eSign</fullName>
        <description>Sets to Active</description>
        <field>File_Store_Contract_Status__c</field>
        <literalValue>Active</literalValue>
        <name>Set Contract Doc Status for eSign</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Contract_End_Date_2</fullName>
        <description>Sets Contract End/Anniversary Date 2 to be the value from Contract End/Anniversary Date field</description>
        <field>Contract_End_Anniversary_Date_2__c</field>
        <formula>Contract_End_Anniversary_Date__c</formula>
        <name>Set Contract End Date 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Contract_Name_value</fullName>
        <description>QuoteNumber + Company__r.Name + ContractType__c + Service_Commencement_Date__c.  If there&apos;s no Tesla Company Name, then uses the ShippingName.</description>
        <field>Name</field>
        <formula>IF(ISBLANK(ShippingName), 
/*Company__r.Name is the TESLA Company Name*/
QuoteNumber + &quot;-&quot; +  Company__r.Name + &quot;-&quot; +  TEXT(ContractType__c) + &quot;-&quot; +  TEXT( Service_Commencement_Date__c ),
QuoteNumber + &quot;-&quot; +  ShippingName + &quot;-&quot; +  TEXT(ContractType__c) + &quot;-&quot; +  TEXT( Service_Commencement_Date__c ))</formula>
        <name>Set Contract Name value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Contract_Source</fullName>
        <field>Contract_Source__c</field>
        <literalValue>Docusign</literalValue>
        <name>Set Contract Source</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Contract_Status_Reason_Cancel_Notice</fullName>
        <field>Cancellation_Notice__c</field>
        <formula>TEXT(Contract_Status_Reason__c)</formula>
        <name>Set Contract Status Reason Cancel Notice</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Country_Provisioning</fullName>
        <field>ShippingCountry</field>
        <formula>BillingCountry</formula>
        <name>Set Country (Provisioning)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Fax_Provisioning</fullName>
        <field>Fax_Provisioning__c</field>
        <formula>Fax</formula>
        <name>Set Fax (Provisioning)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Non_Standard_Exceptions</fullName>
        <field>Non_Standard_Exceptions__c</field>
        <literalValue>Non Standard - Product not Supported by Contract Gen</literalValue>
        <name>Set Non Standard - Exceptions 2 prod not</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Phone_Provisioning</fullName>
        <field>Phone_Provisioning__c</field>
        <formula>Phone</formula>
        <name>Set Phone (Provisioning)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Postal_Zip_Code_Provisioning</fullName>
        <field>ShippingPostalCode</field>
        <formula>BillingPostalCode</formula>
        <name>Set Postal/Zip Code (Provisioning)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Purge_Date</fullName>
        <field>SC_Contract_Purge_Date_Seven_years__c</field>
        <formula>IF(MONTH(CEA_Date_Active__c)=2 &amp;&amp; DAY(CEA_Date_Active__c)=29, 
DATE(YEAR(CEA_Date_Active__c)+7, 2, 28), 
DATE(YEAR(CEA_Date_Active__c)+7, MONTH(CEA_Date_Active__c), DAY(CEA_Date_Active__c))-1)</formula>
        <name>Set Purge Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_RT_to_Fill_Out_CIF_Fields</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Ready_for_Closed_Won</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set RT to Ready for Closed Won/Lost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_RT_to_Non_Standard_Exceptions</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Non_Standard_Exceptions</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set RT to Non Standard Exceptions</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_RT_to_Pricing_Approved</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Pricing_Approved</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set RT to Pricing Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_RT_to_Ready_for_Contract</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Ready_for_Contract</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set RT to Ready for Contract</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Rep_Territory_Code</fullName>
        <field>Sales_Rep_Id__c</field>
        <formula>Opportunity.Owner_Copy__r.Terr__c</formula>
        <name>Set Rep Territory Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_State_Province_Provisioning</fullName>
        <field>ShippingState</field>
        <formula>BillingState</formula>
        <name>Set State/Province  (Provisioning)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_to_Closed</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Set Status to Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_to_Fully_Executed_Contract</fullName>
        <field>Status</field>
        <literalValue>Ready for Closed Won</literalValue>
        <name>Set Status to Ready for Closed Won</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_to_Ready_for_Contract</fullName>
        <field>Status</field>
        <literalValue>Ready for Contract</literalValue>
        <name>Set Status to Ready for Contract</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Street_Provisioning</fullName>
        <field>ShippingStreet</field>
        <formula>BillingStreet</formula>
        <name>Set Street (Provisioning)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SignedContractRecordType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>SignedContractRecordType</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SignedContractRecordType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SignedContractRecordType1</fullName>
        <field>RecordTypeId</field>
        <lookupValue>SignedContractRecordType</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SignedContractRecordType1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Contract_Document_Status</fullName>
        <description>Updates the contract document status to expired when the q/c reaches the contract end/expiration date 2 and auto-renewal is false.</description>
        <field>File_Store_Contract_Status__c</field>
        <literalValue>Expired</literalValue>
        <name>Update Contract Document Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_the_Quote_layout_for_hiding_Total</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Editable_Record_Type</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set RT to be Editable</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_the_Quote_layout_for_hiding_test</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Editable_Record_type_for_Users_of_Level_1_and_Level_2</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update the Quote layout for hiding test</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Updates_Contract_End_one_hour</fullName>
        <field>Contract_End_Anniversary_Date_2__c</field>
        <formula>Auto_Renewal_Contract_End_Anniversary_Da__c</formula>
        <name>Sets CEA Date to be the Auto Renew DAte</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>auto_renewal_contract_end</fullName>
        <description>Sets the date that the contract is going to end.</description>
        <field>Auto_Renewal_Contract_End_Anniversary_Da__c</field>
        <formula>DATE( 
/*YEAR*/ 
YEAR( Contract_End_Anniversary_Date_2__c) + FLOOR((MONTH(Contract_End_Anniversary_Date_2__c) + SC_Auto_renewal_Interval_in_months__c - 1)/12), 
/*MONTH*/ 
CASE(MOD(MONTH(Contract_End_Anniversary_Date_2__c)+SC_Auto_renewal_Interval_in_months__c, 12), 
/*value = if the month of the C_E_A_D_2 is 12, the above calculation evaluates to 0, therefore, the result1 should be 12. 12 is the only month that evaluates to something other than its #, so it requires a CASE*/ 
0,12, 
/*else_result is the same MOD(MONTH( equation as above, because it works for months 1-11*/ 
MOD(MONTH(Contract_End_Anniversary_Date_2__c )+SC_Auto_renewal_Interval_in_months__c, 12 )),/*for example,(9+24)/12=2.75-2=.75*12=9*/ 
/*DAY*/ 
/*So the MIN returns the lowest value for the CASE and the IF below. If the lowest value is just DAY(C_E_A_D_2), then great. But if it&apos;s the last day of one of the 30 day months, or 2/28 or 2/29 on a leap year, then the below CASE and IF functions determine if that is the case and then provide the appropriate day*/ 
MIN(DAY(Contract_End_Anniversary_Date_2__c), 
CASE(MOD(MONTH(Contract_End_Anniversary_Date_2__c)+SC_Auto_renewal_Interval_in_months__c,12),/*for example,(7+12)/12=1.58-1=.58*12=7*/ 
9,30, 
4,30, 
6,30, 
11,30, 
2, /* result for 2 = return max days for February dependent on if end date is leap year */ 
IF(MOD(YEAR(Contract_End_Anniversary_Date_2__c) + FLOOR((MONTH(Contract_End_Anniversary_Date_2__c ) + SC_Auto_renewal_Interval_in_months__c)/12) , 400 ) = 0 || (MOD(YEAR(Contract_End_Anniversary_Date_2__c) + FLOOR((MONTH (Contract_End_Anniversary_Date_2__c) + SC_Auto_renewal_Interval_in_months__c)/12) , 4 ) = 0 &amp;&amp; MOD(YEAR(Contract_End_Anniversary_Date_2__c) + FLOOR((MONTH(Contract_End_Anniversary_Date_2__c) + SC_Auto_renewal_Interval_in_months__c)/12) , 100 ) &lt;&gt; 0 
) 
, 29,28) 
,31 ) ) 
)</formula>
        <name>auto renewal contract end</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_customer_sign</fullName>
        <field>Customer_Signature_Type__c</field>
        <literalValue>eSignature</literalValue>
        <name>update customer sign</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Cloned-ContractAmendmentRecordTypeChange</fullName>
        <actions>
            <name>QuoteCloneLayout</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Quote.IsCloned__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NA_K_Q%2FC Created by PGi Contract Manager</fullName>
        <actions>
            <name>Contract_Team_Created_Q_C_Email_Alert_to_Opportunity_Owner</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Triggers an email alert to the Opportunity Owner notifying them that a Q/C has been created by Contract Team.</description>
        <formula>AND(ISPICKVAL(Status, &quot;Ready for Closed Won&quot;), CreatedBy.Profile.Name = &quot;PGi Contract Manager&quot; )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NA_K_Team_Contract Field Updates for eSign</fullName>
        <actions>
            <name>Set_Contract_Doc_Status_for_eSign</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Contract_Source</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Quote.Envelope_Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.File_Store_Contract_Status__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Contract_Source__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Sets Contract Document status to be active once the eSignature Status is Completed; sets the Contract Source to be Docusign as well.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NA_K_Team_Purge Date %2B 7 Years</fullName>
        <actions>
            <name>Set_Purge_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Runs when the Contract End/Anniversary Date 2 is NOT NULL, the Contract Purge Date is NULL, and Status = Ready For Closed Won.  The field &quot;Contract Purge Date (Seven years)&quot; is populated with the date 7 years from Contract_End_Anniversary_Date_2__c.</description>
        <formula>OR( AND( !ISBLANK(CEA_Date_Active__c), ISBLANK(SC_Contract_Purge_Date_Seven_years__c), ISPICKVAL(File_Store_Contract_Status__c, &quot;Active&quot;) ), AND( ISCHANGED(CEA_Date_Active__c), ISPICKVAL(File_Store_Contract_Status__c, &quot;Active&quot;) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NA_K_Team_Set CEA Active when original set</fullName>
        <actions>
            <name>Set_CEA_Date_Active</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This WF rule is meant to set theauto renewal contract end date based on the value in the Date CEA Date to become on Auto-Renew</description>
        <formula>AND( 
ISPICKVAL(File_Store_Contract_Status__c, &quot;Active&quot;), 
!ISBLANK(CEA_Date_Original__c),
ISBLANK(CEA_Date_Active__c)
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NA_K_Team_Set CEA Date to auto renew Date</fullName>
        <actions>
            <name>Reset_Auto_Renewal_Counter_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This WF rule is meant to set theauto renewal contract end date based on the value in the Date CEA Date to become on Auto-Renew</description>
        <formula>AND( SC_Auto_Renewal__c = true, !ISBLANK(Contract_End_Anniversary_Date_2__c), !ISBLANK(SC_Auto_renewal_Interval_in_months__c), ISPICKVAL(File_Store_Contract_Status__c, &quot;Active&quot;), ISBLANK(Auto_Renewal_Counter__c) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Set_Auto_Renewal_Counter_to_1</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Quote.Auto_Renewal_Contract_End_Anniversary_Da__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Renew_CEA_Date</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Set_Auto_Renewal_Date</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Quote.Contract_End_Anniversary_Date_2__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>NA_K_Team_Set CEA Date to auto renew Date-1</fullName>
        <actions>
            <name>Reset_Auto_Renewal_Counter_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This WF rule is meant to set theauto renewal contract end date based on the value in the Date CEA Date to become on Auto-Renew</description>
        <formula>AND( SC_Auto_Renewal__c = true, !ISBLANK(Contract_End_Anniversary_Date_2__c), !ISBLANK(SC_Auto_renewal_Interval_in_months__c), ISPICKVAL(File_Store_Contract_Status__c, &quot;Active&quot;), Auto_Renewal_Counter__c = 1 )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Renew_CEA_Date</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Set_Auto_Renewal_Date</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Quote.Contract_End_Anniversary_Date_2__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Reset_Auto_Renewal_Counter</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Quote.Auto_Renewal_Contract_End_Anniversary_Da__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>NA_K_Team_Set Contract End%2FAnniversary Date 2</fullName>
        <actions>
            <name>Set_Contract_End_Date_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quote.Contract_End_Anniversary_Date_2__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Contract_End_Anniversary_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Status</field>
            <operation>notEqual</operation>
            <value>Ready for Closed Won</value>
        </criteriaItems>
        <description>Updates this field from the roll-up so that it can be editable</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NA_K_Team_Set Contract Name value</fullName>
        <actions>
            <name>Set_Contract_Name_value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quote.QuoteNumber</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Rule which updates the Name and the Sales Ops Contract Name.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NA_K_Team_Set to Expired</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Quote.SC_Auto_Renewal__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.File_Store_Contract_Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <description>When the auto renewal is false, this triggers a field update to change the Contract Document Status to Expired.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Contract_Document_Status</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Quote.Contract_End_Anniversary_Date_2__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>PgiNonStandardApprovalRule</fullName>
        <actions>
            <name>DisableQouteContractButton</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Quote.Non_Std_Terms_Conditions__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.isapprovedtrue__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Description on Quote From Opportunity</fullName>
        <actions>
            <name>PopulateOpportunityDescriptionToQuote</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quote.Description</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Quote%3AField update on Interest Penalty Percent</fullName>
        <actions>
            <name>QuoteInterestPenaltyPercent_field_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quote.InterestPenaltyPercent__c</field>
            <operation>equals</operation>
            <value>0.3</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Non Standard - Exceptions</fullName>
        <actions>
            <name>Set_Non_Standard_Exceptions</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quote.Count_of_contract_not_supported_SFDC__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set RT to Non Standard</fullName>
        <actions>
            <name>Set_RT_to_Non_Standard_Exceptions</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Non_Standard_Exceptions__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Status</field>
            <operation>equals</operation>
            <value>Pricing Approved - Internally Signed</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Rep Territory Code</fullName>
        <actions>
            <name>Set_Rep_Territory_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quote.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WIP_Set Approver Escalation Email</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Quote.Approver_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Sets to Delegated Approver if exists or else the Manager if not populated</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>x-1-11aSet Status %26 RT to Ready for Closed Won</fullName>
        <actions>
            <name>Set_RT_to_Fill_Out_CIF_Fields</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Status_to_Fully_Executed_Contract</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Non_Standard_Exceptions__c</field>
            <operation>equals</operation>
            <value>Pricing &amp; Payment Terms,T &amp; Cs,Unsupported Q/C Products,T &amp; Cs and Pricing Terms</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Status</field>
            <operation>notEqual</operation>
            <value>Submitted Contract- Customer Approval,Contract Signed by Customer,Draft,Closed,Submitted - Price Approval,Submitted Contract-Internal Approval,Ready for Closed Won,Quote- In Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>APAC Contract Manager</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>x-1-2_Set RT to Editable Record Type</fullName>
        <actions>
            <name>Update_the_Quote_layout_for_hiding_Total</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Quote.Status</field>
            <operation>contains</operation>
            <value>Quote- In Progress,Draft</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Editable Record Type</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>APAC Contract Manager</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>x-10_Set RT to Ready for Closed Won</fullName>
        <actions>
            <name>Set_RT_to_Fill_Out_CIF_Fields</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Quote.Status</field>
            <operation>equals</operation>
            <value>Ready for Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Ready for Closed Won/Lost</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>x-10_Set Status to Ready for Closed Won</fullName>
        <actions>
            <name>Set_RT_to_Fill_Out_CIF_Fields</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Status_to_Fully_Executed_Contract</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(  ISPICKVAL(Status, &quot;Contract Signed by Customer&quot;),  OR(  NOT(  ISPICKVAL(Opportunity.Type, &quot;New Logo&quot;)  ),  AND(  ! ISBLANK(Billing_Contact_Name__c),  ! ISBLANK(Billing_Contact_Email__c),  ! ISBLANK(Billing_Contact_Phone__c),  ! ISBLANK(Billing_Contact_Street__c),  ! ISBLANK(Billing_Contact_City__c),  ! ISBLANK(Billing_Contact_State_Province__c),  ! ISBLANK(Billing_Contact_Postal_Code__c),  ! ISBLANK(Admin_Contact_Name__c),  ! ISBLANK(Admin_Contact_Email__c),  ! ISBLANK(Admin_Contact_Phone__c),  ! ISBLANK(Admin_Contact_Street__c),  ! ISBLANK(Admin_Contact_City__c),  ! ISBLANK(Admin_Contact_State_Province__c),  ! ISBLANK(Admin_Contact_Postal_Code__c),  ! ISBLANK(ShippingName),  ! ISBLANK(Phone_Provisioning__c),  ! ISBLANK(ShippingStreet),  ! ISBLANK(ShippingCity),  ! ISBLANK(ShippingState),  ! ISBLANK(ShippingPostalCode )  )  )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>x-11_Set Status to Closed</fullName>
        <actions>
            <name>Change_RT_to_signed_contract</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Status_to_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>whenever the Stage is set to Closed Lost</description>
        <formula>ISPICKVAL(Opportunity.Opp_Stage__c, &quot;Closed Lost&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>x-3_Set RT to Read only Record Type</fullName>
        <actions>
            <name>Quote_Read_only_without_Total_margin_for</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Quote.Status</field>
            <operation>contains</operation>
            <value>Submitted - Price Approval</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>x-4_Set RT to Pricing Approved - Internally Signed</fullName>
        <actions>
            <name>Set_RT_to_Pricing_Approved</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(  ISPICKVAL(Status, &quot;Pricing Approved - Internally Signed&quot;),  /*RecordType.DeveloperName &lt;&gt; &quot;Pricing Approved&quot;,*/  /*RecordType.DeveloperName &lt;&gt; &quot;Ready for Contract&quot;, */  RecordTypeId &lt;&gt; &quot;012a0000001FjqB&quot;, /* Ready for Contract */  OR(  ISBLANK(BillingName),  ISBLANK(BillingStreet),  ISBLANK(BillingCity),  ISBLANK(BillingState),  ISBLANK(BillingPostalCode),  ISBLANK(BillingCountry)  )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>x-5_Set RT and Status to Ready for Contract</fullName>
        <actions>
            <name>Set_RT_to_Ready_for_Contract</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Status_to_Ready_for_Contract</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>AND( 
! ISBLANK(Signer_Contact_Name__c),</description>
        <formula>AND(  ! ISBLANK(ContactId),  ! ISBLANK(BillingName),  ! ISBLANK(BillingStreet),  ! ISBLANK(BillingCity),  ! ISBLANK(BillingState),  ! ISBLANK(BillingPostalCode),  ! ISBLANK(BillingCountry),  ! ISBLANK(Sales_Rep_Id__c), OR( ISPICKVAL(Status, &quot;Pricing Approved - Internally Signed&quot;),  ISPICKVAL(Status, &quot;Ready for Contract&quot;) ),  ! ISPICKVAL(Opportunity.Non_Standard_Exceptions__c, &quot;T &amp; Cs and Pricing Terms&quot;),  ! ISPICKVAL(Opportunity.Non_Standard_Exceptions__c, &quot;Unsupported Q/C Products&quot;),  ! ISPICKVAL(Opportunity.Non_Standard_Exceptions__c, &quot;Pricing &amp; Payment Terms&quot;),  ! ISPICKVAL(Opportunity.Non_Standard_Exceptions__c, &quot;T &amp; Cs&quot;),  ! ISPICKVAL(Opportunity.Type, &quot;Co-Terminus License&quot;),  ! ISPICKVAL(Opportunity.Type, &quot;Rate Change (Amendment)&quot;),  ! ISPICKVAL(Opportunity.Type, &quot;New Amendment (Existing Cust.)&quot;),  ! CONTAINS(Opportunity.Channel_New__c, &quot;Diamond&quot;),  ! CONTAINS(Opportunity.Channel_New__c, &quot;Budget&quot;),  Count_of_contract_not_supported_SFDC__c = 0 )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>x-5a_Set RT and Status Ready for Closed Won</fullName>
        <actions>
            <name>Set_RT_to_Fill_Out_CIF_Fields</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Status_to_Fully_Executed_Contract</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(   ISPICKVAL(Status, &quot;Pricing Approved - Internally Signed&quot;) ||  ISPICKVAL(Status, &quot;Contract Document Generated&quot;) ||  ISPICKVAL(Status, &quot;Ready for Contract&quot;),   OR(  ISPICKVAL(Opportunity.Non_Standard_Exceptions__c, &quot;T &amp; Cs and Pricing Terms&quot;), ISPICKVAL(Opportunity.Non_Standard_Exceptions__c, &quot;Unsupported Q/C Products&quot;), ISPICKVAL(Opportunity.Non_Standard_Exceptions__c, &quot;Pricing &amp; Payment Terms&quot;), ISPICKVAL(Opportunity.Non_Standard_Exceptions__c, &quot;T &amp; Cs&quot;),  ISPICKVAL(Opportunity.Type, &quot;Co-Terminus License&quot;),  ISPICKVAL(Opportunity.Type, &quot;Rate Change (Amendment)&quot;),  ISPICKVAL(Opportunity.Type, &quot;New Amendment (Existing Cust.)&quot;), CONTAINS(Opportunity.Channel_New__c, &quot;Diamond&quot;),  CONTAINS(Opportunity.Channel_New__c, &quot;Soundpath&quot;),   CONTAINS(Opportunity.Channel_New__c, &quot;Budget&quot;),  Count_of_contract_not_supported_SFDC__c &gt; 0  )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>x-6_Set RT to Contract Generated</fullName>
        <actions>
            <name>Quote_Contract_Document_Generated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Quote.Status</field>
            <operation>equals</operation>
            <value>Contract Document Generated</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>x-7-9_Set RT to Contract Signed by Customer</fullName>
        <actions>
            <name>SignedContractRecordType1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Quote.Status</field>
            <operation>equals</operation>
            <value>Submitted Contract-Internal Approval,Submitted Contract- Customer Approval,Contract Signed by Customer</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>x-ChangePageLayout-QuoteLayout</fullName>
        <actions>
            <name>ChangePageLayout_QuoteLayout</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Quote.Non_Std_Terms_Conditions__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>x-Click on Q%2FC Generate CIF checkbox</fullName>
        <actions>
            <name>CIF_Email_notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Reset_Generate_CIF_Form</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(  Opportunity.IsWon = True,  $User.Override_Validation_Rules__c = False,  Generate_CIF_Form__c = True,  Opportunity.Count_of_Completed_Q_C_Records__c &gt; 0  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>x-Email Notify to Quote Owner when Approved</fullName>
        <actions>
            <name>Email_notify_of_Approved</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Quote.OverallApprovalStatus__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>x-Email Notify to Quote Owner when DS Envelope is Internal Signed</fullName>
        <actions>
            <name>Email_Notify_of_DS_Internal_Signed</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Quote.Internal_Signer_Completed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>x-Email Notify to Quote Owner when Rejected</fullName>
        <actions>
            <name>Email_notify_of_Rejected</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Quote.OverallApprovalStatus__c</field>
            <operation>contains</operation>
            <value>reject</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>x-Quote%3ADefaultPagelayout</fullName>
        <actions>
            <name>Quote_DefaultPagelayout</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 OR 3) AND 2</booleanFilter>
        <criteriaItems>
            <field>User.Level_Of_Authority__c</field>
            <operation>contains</operation>
            <value>Level 3,Level 5,Level 4,Level 6</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Status</field>
            <operation>contains</operation>
            <value>Draft,Rejected,Quote- In Progress,Quote- Pricing Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Level_Of_Authority__c</field>
            <operation>notContain</operation>
            <value>Level 1,Level 2</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>x-Quote%3ARead only on Submit Approval</fullName>
        <actions>
            <name>Quote_Read_only_on_Submit_Approval</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Quote.Status</field>
            <operation>contains</operation>
            <value>Pending Price Approval,Contract Signed by Customer,Awaiting Co-Signature from VP,Contract- Waiting for Customer Approval,Submitted - Price Approval,Submitted Contract-Internal Approval,Submitted quote-Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Level_Of_Authority__c</field>
            <operation>contains</operation>
            <value>Level 3,Level 5,Level 4,Level 6</value>
        </criteriaItems>
        <description>Quote: Ready only page Layout on submit for approval</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>x-Send out CIF Form Ph2</fullName>
        <actions>
            <name>CIF_Email_notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Reset_Generate_CIF_Form</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>OR(  AND(   Opportunity.IsClosed = True,    OR(   Opportunity.Owner_Region__c = &quot;NA&quot;  &amp;&amp;  ISPICKVAL(Opportunity.Channel__c, &quot;Partners&quot;),   ISPICKVAL(Opportunity.Channel__c, &quot;Soundpath&quot;),   ISPICKVAL(Opportunity.Channel__c, &quot;Ent - AAE&quot;),   ISPICKVAL(Opportunity.Channel__c, &quot;SaaS Acquisition&quot;), ISPICKVAL(Opportunity.Channel__c, &quot;GCS Acquisition&quot;),   ISPICKVAL(Opportunity.Channel__c, &quot;GCS Base&quot;),     ISPICKVAL(Opportunity.Channel__c, &quot;SaaS Base&quot;),  ISPICKVAL(Opportunity.Channel__c, &quot;SMB - Base&quot;),  ISPICKVAL(Opportunity.Channel__c, &quot;Budget Conferencing&quot;),   ISPICKVAL(Opportunity.Channel__c, &quot;E-Commerce&quot;),  ISPICKVAL(Opportunity.Channel__c ,&quot;Canada&quot;)   ),   $User.Override_Validation_Rules__c = False,   ISPICKVAL(Opportunity.Type, &quot;New Logo&quot;),   Opportunity.Count_of_Completed_Q_C_Records__c &gt; 0,   ! ISPICKVAL(Opportunity.Non_Standard_Exceptions__c, &quot;Pricing &amp; Payment Terms&quot;),  ! ISPICKVAL(Opportunity.Non_Standard_Exceptions__c, &quot;T &amp; Cs&quot;),  ! ISPICKVAL(Opportunity.Non_Standard_Exceptions__c, &quot;Unsupported Q/C Products&quot;),  ! ISPICKVAL(Opportunity.Non_Standard_Exceptions__c, &quot;T &amp; Cs and Pricing Terms&quot;)  ),  Generate_CIF_Form__c = True )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>x-Set Admin Contact fields same as Billing Contact</fullName>
        <actions>
            <name>Set_Admin_Contact_City</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Admin_Contact_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Admin_Contact_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Admin_Contact_Phone</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Admin_Contact_Postal_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Admin_Contact_State_Province</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Admin_Contact_Street</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Quote.Is_Same_as_the_Billing_Contact__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Copys the Billing Contact fields to the CIF Admin Contact fields</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>x-Set Provisioning same as Legal %28Name%2FAddress%29</fullName>
        <actions>
            <name>Set_Company_City_Provisioning</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Company_Name_Provisioning</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Country_Provisioning</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Fax_Provisioning</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Phone_Provisioning</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Postal_Zip_Code_Provisioning</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_State_Province_Provisioning</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Street_Provisioning</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Quote.Provisioning_Details_same_as_Legal__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Copys the Company Name (Legal) and Company Address (Legal) over to the Provisioning fields of the same name</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>x-Set RT to Fill Out CIF Fields</fullName>
        <actions>
            <name>Set_RT_to_Fill_Out_CIF_Fields</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Quote.Status</field>
            <operation>equals</operation>
            <value>Contract Signed by Customer</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>x_NA_K_Team_Update Cancellation</fullName>
        <actions>
            <name>Set_Contract_Status_Reason_Cancel_Notice</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Quote.Contract_Status_Reason__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
