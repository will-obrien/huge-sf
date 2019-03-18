<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>test</fullName>
        <active>false</active>
        <criteriaItems>
            <field>DandBCompany.LocationStatus</field>
            <operation>equals</operation>
            <value>Branch. Secondary location to a headquarters location</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
