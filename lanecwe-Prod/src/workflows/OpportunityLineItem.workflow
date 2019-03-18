<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>RW_Set_Bill_Freq_To_Annually</fullName>
        <field>Billing_Frequency__c</field>
        <literalValue>Annually</literalValue>
        <name>RW_Set_Bill_Freq_To_Annually</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RW_Set_Bill_Freq_To_Monthly</fullName>
        <description>Sets Bill Frequency as not able to on the Relayware side.</description>
        <field>Billing_Frequency__c</field>
        <literalValue>Monthly</literalValue>
        <name>RW_Set_Bill_Freq_To_Monthly</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RW_Set_Term_12_Months</fullName>
        <description>Set Term as not able to in Relayware</description>
        <field>Contract_Term__c</field>
        <formula>12</formula>
        <name>RW_Set_Term_12_Months</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RW_Set_Term_24_Months</fullName>
        <field>Contract_Term__c</field>
        <formula>24</formula>
        <name>RW_Set_Term_24_Months</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RW_Set_Term_36_Months</fullName>
        <field>Contract_Term__c</field>
        <formula>36</formula>
        <name>RW_Set_Term_36_Months</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RW_Set_Unit_Type_Licenses</fullName>
        <field>Unit_Type__c</field>
        <literalValue>Licenses</literalValue>
        <name>RW_Set_Unit_Type_Licenses</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ReSet_Quantity_Existing_Customer</fullName>
        <description>Sets back to a positive value if existing service is unselected.</description>
        <field>New_Quantity__c</field>
        <formula>- New_Quantity__c</formula>
        <name>ReSet Quantity (Existing Customer)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
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
        <fullName>Set_Historic_Line_Item_to_False</fullName>
        <field>Historic_Line_Item__c</field>
        <literalValue>0</literalValue>
        <name>Set Historic Line Item to False</name>
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
        <fullName>Set_New_Quantity_to_Negative</fullName>
        <field>New_Quantity__c</field>
        <formula>- New_Quantity__c</formula>
        <name>Set New Quantity to Negative</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Opp_Owner_Region_on_Opp_Prod</fullName>
        <field>Opp_Owner_Region__c</field>
        <formula>Opportunity.Owner_Region__c</formula>
        <name>Set Opp Owner Region on Opp Prod</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Opportunity_Products_to_Non_Editable</fullName>
        <field>isEditable__c</field>
        <literalValue>0</literalValue>
        <name>Set Opportunity Products to Non-Editable</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Product_Name</fullName>
        <description>Sets Product Name</description>
        <field>Product_Name1__c</field>
        <formula>Product2.Name</formula>
        <name>Set Product Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Unit_Price_Existing_Customer</fullName>
        <field>New_Sales_Price__c</field>
        <formula>- Unit_Price_Create_Only__c</formula>
        <name>Set Unit Price (Existing Customer)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Unit_Price_non_Existing_Customer</fullName>
        <field>New_Sales_Price__c</field>
        <formula>Unit_Price_Create_Only__c</formula>
        <name>Set Unit Price non-Existing Customer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Unit_Type_to_Licenses</fullName>
        <field>Unit_Type__c</field>
        <literalValue>Licenses</literalValue>
        <name>Set Unit Type to Licenses</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Unit_Type_to_Minutes</fullName>
        <field>Unit_Type__c</field>
        <literalValue>Minutes</literalValue>
        <name>Set Unit Type to Minutes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_isReportable_Value</fullName>
        <field>isReportable_Text__c</field>
        <formula>IF( 
NOT( 
ISBLANK(Package__r.Id) 
), &quot;Valid&quot;, 
IF( 
Existing_Service__c = True, &quot;Valid&quot;, 
IF( 
AND( 
ISBLANK(Package__r.Id), 
Opportunity.Count_of_Quote__c = 0 
), &quot;Valid&quot;, 
IF( 
AND( 
ISBLANK(Package__r.Id), 
Opportunity.Count_of_Quote__c &gt; 0 
), &quot;Invalid&quot;, &quot;Error in Formula&quot; 
))))</formula>
        <name>Set isReportable Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Temp_Set_Min_Commit_True</fullName>
        <field>Min_Commit__c</field>
        <literalValue>1</literalValue>
        <name>Temp_Set Min. Commit = True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_New_Sales_Price</fullName>
        <description>Sets the value of the standard &quot;Sales Price&quot; (i.e. unit price) field on the opportunity product (i.e. line item) to the value of the custom &quot;Contract Value&quot; field.  Since the standard Quantity field will always be 1, std Total Price will = Contract Value.</description>
        <field>UnitPrice</field>
        <formula>Value_Over_Term__c</formula>
        <name>Update New Sales Price</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Lockdown Opportunity Products after creation and updation</fullName>
        <actions>
            <name>Set_Opportunity_Products_to_Non_Editable</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>OpportunityLineItem.isEditable__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.isReportable_Text__c</field>
            <operation>equals</operation>
            <value>Valid</value>
        </criteriaItems>
        <description>Locks down the opportunity products if they have been created/updated by trigger.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RW_Set_Bill_Freq_To_Annually</fullName>
        <actions>
            <name>RW_Set_Bill_Freq_To_Annually</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.RW_Product_Name__c</field>
            <operation>contains</operation>
            <value>Prepaid</value>
        </criteriaItems>
        <description>Sets Bill Frequency as not able to on the Relayware side.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RW_Set_Bill_Freq_To_Monthly</fullName>
        <actions>
            <name>RW_Set_Bill_Freq_To_Monthly</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.RW_Product_Name__c</field>
            <operation>contains</operation>
            <value>Monthly</value>
        </criteriaItems>
        <description>Sets Bill Frequency as not able to on the Relayware side.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RW_Set_Term_12_Months</fullName>
        <actions>
            <name>RW_Set_Term_12_Months</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.RW_Product_Name__c</field>
            <operation>contains</operation>
            <value>1YR</value>
        </criteriaItems>
        <description>Sets term as not able to on the Relayware side.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RW_Set_Term_24_Months</fullName>
        <actions>
            <name>RW_Set_Term_24_Months</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.RW_Product_Name__c</field>
            <operation>contains</operation>
            <value>2YR</value>
        </criteriaItems>
        <description>Sets term as not able to on the Relayware side.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RW_Set_Term_36_Months</fullName>
        <actions>
            <name>RW_Set_Term_36_Months</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.RW_Product_Name__c</field>
            <operation>contains</operation>
            <value>3YR</value>
        </criteriaItems>
        <description>Sets term as not able to on the Relayware side.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RW_Set_Unit_Type_Licenses</fullName>
        <actions>
            <name>RW_Set_Unit_Type_Licenses</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.RW_Product_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Unit_Type__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Will need to update if we ever start selling non-license items here.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ReSet Quantity %28Existing Customer%29</fullName>
        <actions>
            <name>ReSet_Quantity_Existing_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the Quantity back to Positive for Existing Customers</description>
        <formula>AND(  Existing_Service__c = False,  PRIORVALUE(Existing_Service__c) = True,  New_Quantity__c &lt; 0 )</formula>
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
            <value>PGi Admin Lite,System Administrator,System Administrator (No Expires)</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Opp Owner Region on Opp Prod</fullName>
        <actions>
            <name>Set_Opp_Owner_Region_on_Opp_Prod</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.CreatedDate</field>
            <operation>greaterThan</operation>
            <value>9/27/2014</value>
        </criteriaItems>
        <description>for TCV/ACV calculation</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Product Name</fullName>
        <actions>
            <name>Set_Product_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Used to set product name for all Products so we can see it with Roll-up summary fields.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Quantity %28Existing Customer%29</fullName>
        <actions>
            <name>Set_New_Quantity_to_Negative</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Existing_Service__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.New_Quantity__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Unit Price %28Existing Customer%29</fullName>
        <actions>
            <name>Set_Unit_Price_Existing_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>OpportunityLineItem.Existing_Service__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Unit Price non-Existing Customer</fullName>
        <actions>
            <name>Set_Unit_Price_non_Existing_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>OpportunityLineItem.Existing_Service__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set isReportable Value</fullName>
        <actions>
            <name>Set_Admin_Flag_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_isReportable_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>OpportunityLineItem.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update standard Sales Price</fullName>
        <actions>
            <name>Update_New_Sales_Price</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Quantity</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update standard Sales Price</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>x-Set Unit Type based on Roll-up</fullName>
        <actions>
            <name>Set_Unit_Type_to_Minutes</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>OpportunityLineItem.Unit_Type__c</field>
            <operation>equals</operation>
            <value>,Minute,Event</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Historic_Line_Item__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Owner_Region__c</field>
            <operation>equals</operation>
            <value>NA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>notEqual</operation>
            <value>Closed Lost</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.QuoteLineItemId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>x-Set Unit Type to Licenses based on Roll-up</fullName>
        <actions>
            <name>Set_Unit_Type_to_Licenses</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>OpportunityLineItem.Unit_Type__c</field>
            <operation>equals</operation>
            <value>Month</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Historic_Line_Item__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Owner_Region__c</field>
            <operation>equals</operation>
            <value>NA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>notEqual</operation>
            <value>Closed Lost</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.QuoteLineItemId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>x-Temp_Set Min%2E Commit %3D True</fullName>
        <actions>
            <name>Temp_Set_Min_Commit_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(
BEGINS(Add_on_Feature__r.Name, &quot;Audio and Web Per Minute&quot;) ||
BEGINS(Add_on_Feature__r.Name, &quot;Web Per Minute&quot;),
Min_Commit__c = False
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>x-Uncheck Historical Line Item if set to closed lost</fullName>
        <actions>
            <name>Set_Historic_Line_Item_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Opp_Stage__c</field>
            <operation>equals</operation>
            <value>Closed Lost</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Historic_Line_Item__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Used to set Historic Line Item to be false when set to closed lost.

Not sure of the purpose here, turned it off as makes no sense and was impact Global Report Consistency Opp Product Remapping.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
