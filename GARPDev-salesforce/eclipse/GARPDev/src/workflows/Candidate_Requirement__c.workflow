<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Set Start Date</fullName>
        <active>false</active>
        <description>When FRM candidate passes FRM 1 set the Program start date to the date that the candidate sat for the exam.</description>
        <formula>AND( 
  TRUE , 
  ISPICKVAL(Status__c, &apos;Completed&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
