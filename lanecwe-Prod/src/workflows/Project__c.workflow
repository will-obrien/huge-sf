<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Project_Notes</fullName>
        <field>Project_Notes__c</field>
        <formula>&quot;  ***&quot; 
&amp; BR() &amp; &quot;Notes by :&quot; &amp; &quot; &quot; &amp;  $User.FirstName &amp; &quot; &quot; &amp;  $User.LastName  &amp; &quot; &quot; &amp; LEFT(TEXT(NOW()-0.1666667),16) &amp; &quot; EST&quot; &amp; BR() &amp;  BR()  &amp;  Project_Notes__c</formula>
        <name>Update Project Notes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set Project Notes TS</fullName>
        <actions>
            <name>Update_Project_Notes</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( ISCHANGED(Project_Notes__c), LEFT(Project_Notes__c, 2) &lt;&gt; &quot;**&quot; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
