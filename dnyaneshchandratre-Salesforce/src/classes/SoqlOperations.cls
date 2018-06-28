public class SoqlOperations {
    Integer i;
    public void operateAccount() {
        List<Account> accList= [select ID from Account where Type__c='Person'];
        for(i=0;i<accList.size();i++)
            System.debug(accList[i]);
        System.debug('*********************************');
        for(Account a : accList)
            System.debug(a);
    }
    public void operateOpportunity()
    {
        List<Opportunity> oppList= [Select Id, 
                                    /*Name, 
                                    Description,*/
                                    AccountID
                                    from Opportunity 
                                    where 
                                    AccountID!=NULL and 
                                    StageName like 'Closed%'];
        List<ID> IdList= new List<ID>();
        Set<ID> IdSet= new Set<ID>();
        Map<ID,ID> oppMap= new Map<ID,ID>();
        for(i=0;i<oppList.size();i++)
        {
            IdList.add(oppList[i].ID);
            IdSet.add(oppList[i].AccountID);
            oppMap.put(oppList[i].ID,oppList[i].AccountID);
        }
        System.debug(IdList+'\n'+IdSet+'\n'+oppMap);
    }
    public void updateAccount()
    {
        List<Account> accUpdateName = [Select Name from Account where Name like 'A%'];
        System.debug(accUpdateName.size());
        for(Account a: accUpdateName)
        {
            a.Name='Updated via update DML operation';
        }
        update accUpdateName;
    }
    public void sortCampaign()
    {
        List<Campaign> camList=[Select ID,name,BudgetedCost from Campaign limit 10];
        List<Campaign> camAscList=camList;
        List<Campaign> camDescList=camList;
        Campaign temp;
        /***Ascending order by Budgeted Cost***/
        for(i=0;i<camAscList.size();i++)
            for(Integer j=i+1;j<camAscList.size();j++)
                if(camAscList[i].BudgetedCost > camAscList[j].BudgetedCost)
                {
                    temp=camAscList[i];
                    camAscList[i]=camAscList[j];
                    camAscList[j]=temp;
                }
        System.debug(camAscList);
        /***Descending order by Budgeted Cost***/
        for(i=0;i<camDescList.size();i++)
            for(Integer j=i+1;j<camDescList.size();j++)
                if(camDescList[i].BudgetedCost < camDescList[j].BudgetedCost)
                {
                    temp=camDescList[i];
                    camDescList[i]=camDescList[j];
                    camDescList[j]=temp;
                }
        System.debug(camDescList);
    }
    public void modifiedContacts()
    {
        List<Contact> conList=[select ID, name from Contact where LastModifiedDate =: System.Date.Today()];
        System.debug('\n\R'+conList);
    }
    public void mapAccToOpp()
    {
        List<Account> accList = [Select a.Name, a.Id, (Select Id, Name From Opportunities) From Account a];
        Map<Id, List<Opportunity>> mapAcc= new Map<Id, List<Opportunity>>();
        for(Account a : accList)
        {
            mapAcc.put(a.Id, a.Opportunities);
        }
        for(ID i : mapAcc.keySet())
            System.debug(mapAcc.get(i));
    }
}