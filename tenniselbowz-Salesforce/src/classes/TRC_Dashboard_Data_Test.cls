@isTest
public class TRC_Dashboard_Data_Test {
	static testmethod void unitTest(){
        
        
        Test.startTest();
     
        
        
        Case cs = new case (Origin='Phone', Status = 'Working', Priority= 'Low', Reason = 'Equipment Performance Issue', Subject='TRC', RecordTypeID='012C0000000Hqlk');
        case css = cs.clone();
        Insert cs;
        insert css;
        cs.Status = 'Closed';
        cs.Resolution_Type__c = 'Answered Question';
        cs.Resolution_Description__c = 'Resolution Description';
        update cs;
        final String staticResourceName = 'CaseStaticRecords';
        final Case[] testCases = (Case[]) Test.loadData(Case.sObjectType, staticResourceName);
        List<Case> ccc = [SELECT Id From Case];
        
        /*TRC_Dashboard_Data TRCCase = new TRC_Dashboard_Data();
        TRCCase.getTRCResults();*/
        
        TRC_Dashboard_Data_Retrieval sch1 = new TRC_Dashboard_Data_Retrieval();
        String sch = '0 0 18 * * ?';
        system.schedule('TRC_Dashboard_Data', sch, sch1); 
        
        Test.stopTest(); 
        
        //update testCases;
        
        
      
    }
}