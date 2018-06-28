<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Copy_Expiration_Date_Field</fullName>
        <field>Expiration_Date_Copy__c</field>
        <formula>Expiration_Date__c</formula>
        <name>Copy Expiration Date Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Add_on_Name</fullName>
        <description>to the Product__c.Name value</description>
        <field>Add_on_Name__c</field>
        <formula>Product__r.Name</formula>
        <name>Set Add-on Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Contract_Name_value</fullName>
        <field>contract_not_supported_SFDC_text__c</field>
        <formula>contract_not_supported_SFDC__c</formula>
        <name>Set contract not supported text</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Unit_Type_from_Unit_Type_from_Add_on</fullName>
        <description>Sets Unit type so that available in formulas for Annual/Contract Value</description>
        <field>Unit_Type_for_TCV__c</field>
        <formula>Unit_Type_from_Add_on__c</formula>
        <name>Set Unit Type from Unit Type from Add-on</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Copy Expiration Date Field</fullName>
        <actions>
            <name>Copy_Expiration_Date_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>QuoteLineItem.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Add-on Name</fullName>
        <actions>
            <name>Set_Add_on_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>QuoteLineItem.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Set to the Product__c.Name value so can reference it in Contract Value Formula field</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Unit Type from Unit Type from Add-on</fullName>
        <actions>
            <name>Set_Unit_Type_from_Unit_Type_from_Add_on</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>QuoteLineItem.Unit_Type_from_Add_on__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set contract_not_supported_SFDC %28text%29</fullName>
        <actions>
            <name>Set_Contract_Name_value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>QuoteLineItem.contract_not_supported_SFDC__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
