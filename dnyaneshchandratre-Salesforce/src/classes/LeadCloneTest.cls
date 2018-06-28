@isTest
public class LeadCloneTest 
{
    static testMethod void testLeadClone() 
    {
        Lead objLead = new Lead();
        objLead.LastName = 'Chandratre';
        objLead.Company = 'ESPL';
        objLead.Status = 'Open - Not Contacted';

        Test.startTest();
        insert objLead;
        Test.stopTest();

        List<Lead> lstLead = [SELECT ID FROM Lead WHERE LastName = 'Chandratre'];
        System.assertEquals(2, lstLead.size());
    }
}