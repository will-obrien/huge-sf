@isTest(SeeAllData=true)
public class PROEmailTest {
  static testMethod void testContractFilterHelper(){
        //Create Test Data.
        List<DContract__C> contractList=new List<DContract__C>();
        DContract__C contract=new DContract__C();
        contract.Name='C Test 1';
        insert contract;
        
        contractList.add(contract);
        PROEmailContractFilterHelper filterHelper=new PROEmailContractFilterHelper();
        filterHelper.filter(contractList,ProEmailContractFilterType.FirstNag);
        filterHelper.filter(contractList,ProEmailContractFilterType.SecondNag);
        filterHelper.filter(contractList,ProEmailContractFilterType.ThirdNag);
        filterHelper.filter(contractList,ProEmailContractFilterType.FourthNag);
        
    }
    static testMethod void testPROEmailTemplateHelper(){
        List<DContract__C> contractList=new List<DContract__C>();
        DContract__C contract=new DContract__C();
        contract.Name='C Test 1';
        //contract.Last_Report_Out_Date__c=Date.Today();
        insert contract;
        
        Project_Report_Out__c reportOut=new Project_Report_Out__c();
        reportOut.Contract__c = contract.id;
        reportOut.Report_Out_Date__c = Date.newInstance(2014, 12, 25);
        insert reportOut;
        
        contractList.add(contract);
        
        List<DContract__C> contractList1=[select id,Name,Last_Report_Out_Date__c,Last_Report_Out_Status__c,Is_Snooze__c,Is_First_Nag_Sent__c,
                                           Snooze_Days__c,Snooze_Date__c,First_Nag_Sent_Date__c
                                         ,OwnerId,Owner.Name,Owner.Email 
                                         ,Backstop__c,Backstop__r.FirstName,Backstop__r.LastName,Backstop__r.Email 
                                         ,Project_Manager__c,Project_Manager__r.FirstName, Project_Manager__r.LastName,Project_Manager__r.Email
                                         ,Prime_Contracting_Business_Unit__c 
                                         from DContract__c where Last_Report_Out_Date__c!=null];
        
        PROEmailTemplateHelper templateHelper=new PROEmailTemplateHelper();
        string content=templateHelper.GetProjectInchargeEmailTemplate('Test',contractList1[0].OwnerId,contractList,ProEmailContractFilterType.FirstNag);
        string content1=templateHelper.GetProjectInchargeEmailTemplate('Test',contractList1[0].OwnerId,contractList,ProEmailContractFilterType.SecondNag);
       string con2=templateHelper.GetBackstopEmailTemplate('Test1',contractList1);
        string con4=templateHelper.GetThirdNagEmailTemplate(contractList1);
        
        string con5=templateHelper.GetFourthNagEmailTemplate(contractList1);
        
    }
    static testMethod void PROEmailJobTest(){
        Test.startTest();
            Id batchInstanceId = Database.executeBatch(new PROEmailRemindarBatch()); 
        Test.stopTest();
    }
    static testMethod void PROSnoozeTest(){
       DContract__C contract=new DContract__C();
            contract.Name='C Test 1';
            //contract.Last_Report_Out_Date__c=Date.Today();
            insert contract;
        
          SnoozePROController sh=new SnoozePROController();
          ApexPages.currentPage().getParameters().put('id', contract.id);
          ApexPages.currentPage().getParameters().put('NoOfDays', '5');
          ApexPages.currentPage().getParameters().put('OwnerId', UserInfo.getUserId());
          sh.SnoozePRO();
    }
}