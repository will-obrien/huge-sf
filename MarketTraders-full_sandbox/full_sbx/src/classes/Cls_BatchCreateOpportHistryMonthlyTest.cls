@IsTest  //(SeeAllData=true)
public class Cls_BatchCreateOpportHistryMonthlyTest{
    
    public static testmethod void Cls_BatchCreateOpportHistryMonthly1(){
        
        Test.startTest(); 
            Account acc = new Account();
            acc.name = 'test account';
            insert acc;
             
            Opportunity opp = new Opportunity();
            opp.Name = 'test Opportunity';
            opp.AccountId = acc.id;
            opp.Product__c = 'UTP OnDemand';
            opp.CloseDate = date.today();
            opp.StageName = 'Closed Lost';
            insert opp;
                                

            List<opportunity> st = new List<opportunity>();
            Database.BatchableContext bc;        
            Cls_BatchCreateOpportHistryMonthly obj = new Cls_BatchCreateOpportHistryMonthly();
            database.executebatch(obj);
            obj.execute(bc,st);
            obj.finish(bc);
        Test.stopTest();   

    }
    
    
    public static testmethod void Cls_BatchCreateOpportHistryMonthlySchd1(){
        Test.startTest();
            Datetime dt = Datetime.now().addMinutes(1);
            String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
            String jobId = System.schedule('Sample_Heading', CRON_EXP, new Cls_BatchCreateOpportHistryMonthlySchd() );   
        Test.stopTest();
    }

  
}