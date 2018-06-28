public with sharing class SoqlTasks {

    /* Set 1 */
    public void fetchContacts() {
        List<Contact> contactList = [SELECT c.Phone,
                                            c.Name,
                                            c.MobilePhone,
                                            c.Id,
                                            c.FirstName
                                     FROM Contact c];
        System.debug('-- contactList : ' + contactList);
    }

    public void fetchUsers() {
        List<User> userList= [SELECT u.Id,
                                     u.IsActive,
                                     u.Email,
                                     u.Alias
                              FROM User u
                              WHERE u.IsActive = TRUE];

        Map<ID,User> userMap = new Map<ID,User>();
        for(User user : userList) {
            userMap.put(user.ID, user);
        }
        System.debug(userMap);
    }

    public void fetchAccounts()
    {

        List<Account> accountList=[Select a.Name,
                                          a.Id,
                                          a.BillingState,
                                          a.BillingCountry,
                                          a.AccountNumber
                                   From Account a];

        map<String,ID> nameMap = new map<String,ID>();
        map<ID,Account> idMap = new map<ID,Account>();
        for(Account a: accountList)
        {
            nameMap.put(a.Name,a.ID);
            idMap.put(a.ID,a);
        }
        System.debug(nameMap);
        System.debug(idMap);
    }

    public void fetchAccountsByEnrollment()
    {
        List<Account> fetch2010  = [Select a.Name, 
                                           a.Id, 
                                           a.BillingCity, 
                                           a.AccountNumber 
                                    From Account a 
                                    where Enrollment_year__c INCLUDES ('2010')];

        List<Account> fetch1314 = [Select a.Name, 
                                          a.Id, 
                                          a.BillingCity, 
                                          a.AccountNumber 
                                   From Account a 
                                   where Enrollment_year__c INCLUDES ('2013','2014')];
        system.debug(fetch2010);
        system.debug('');
        system.debug(fetch1314);
    }
    
    public void fetchAccountsByBillingState()
    {
        List<Account> fetchRecords = [Select a.Rating,
                                             a.Name,
                                             a.Id,
                                             a.BillingState,
                                             a.AccountNumber
                                      From Account a 
                                      where a.BillingState not in ('Maharashtra','Kerala')
                                      order by a.BillingState desc
                                      nulls last 
                                      limit 10000];
        for(Account a: fetchRecords)
            system.debug(a);
    }

    public void fetchOpportunity()
    {
        list<Opportunity> oppList= [Select o.Id, 
                                           o.CreatedDate, 
                                           o.Amount 
                                    From Opportunity o 
                                    where o.Amount >10000 
                                    order by o.CreatedDate 
                                    limit 100 
                                    offset 50 
                                    ALL ROWS];
        for(Opportunity a: oppList)
            system.debug(a);
    }

    /*Set 2*/
    public void amountStats()
    {
        List<AggregateResult> ar = [Select SUM(o.Amount) s,
                                           CloseDate 
                                    From Opportunity o 
                                    where IsClosed=FALSE AND 
                                          CloseDate = THIS_FISCAL_YEAR 
                                    group by CloseDate];
        map<Integer,Double> mapYear = new map <Integer,Double>();
        for(AggregateResult a : ar)
        {
            Date d=Date.valueOf(a.get('CloseDate'));
            Integer year=d.year();
            Double amount = Double.valueOf(a.get('s'));
            mapYear.put(year,amount);
        }
        system.debug(mapYear);
    }

    public void leadSources()
    {
        List<AggregateResult> ar = [Select count_distinct(Name) cd,
                                           LeadSource 
                                    from lead 
                                    group by LeadSource 
                                    having count_distinct(ID) > 10];
        for(AggregateResult a : ar)
        {
            System.debug('The count of distinct leads for ' + a.get('LeadSource') + ' is ' + a.get('cd'));
        }
    }

/*
Scratch 

        List<AggregateResult> aggregateResults = [
            SELECT COUNT(Name) leadName
                 , Status
                 , LeadSource
              FROM Lead
          GROUP BY LeadSource
                 , Status
        ];
*/

    public void leadStatus_Abbas() {
        Map<String, Map<String, Integer>> leadStatusMap = new Map<String, Map<String, Integer>>();
        for(AggregateResult result : [
            SELECT COUNT(Name) leadCount
                 , Status
                 , LeadSource
              FROM Lead
          GROUP BY LeadSource
                 , Status
        ]) {

            // Create new
            if(!leadStatusMap.containsKey(String.valueOf(result.get('status')))) {
                leadStatusMap.put(
                    String.valueOf(result.get('Status')),
                    new Map<String, Integer> {
                        String.valueOf(result.get('LeadSource')) => Integer.valueOf(result.get('leadCount'))
                    }
                );

            // Add existing
            } else {
                leadStatusMap.get(String.valueOf(result.get('Status'))).put(
                    String.valueOf(result.get('LeadSource')), Integer.valueOf(result.get('leadCount'))
                );
            }
        }
        system.debug('--- leadStatusMap : ' + leadStatusMap);
    }


    public void leadStatus()
    {
        List<AggregateResult> ar = [Select count(Name) lname,
                                           Status,
                                           LeadSource 
                                    from Lead 
                                    group by LeadSource,
                                             Status];

        map<String,Integer> mapSource  = new map<String,Integer>();
        map<String,map<String,Integer>> mapStatus = new map<String,map<String,Integer>>();

        Integer i=0;

        for(i=0;i<ar.size();i++) {
            //System.debug(i);
            //System.debug(ar[i]);
            mapSource.put(String.valueOf(ar[i].get('LeadSource')),Integer.valueOf(ar[i].get('lname')));
            mapStatus.put(String.valueOf(ar[i].get('Status')),mapSource);
            
        }
        System.debug(mapStatus);
        System.debug(mapSource);
        /*Set<String> keys = mapSource.keyset();
        //System.debug(keys);
        for(String key: keys)
            System.debug(key + ' : ' +mapSource.get(key));*/
    }
    /*Set 3*/
    /*Set 3: Child to Parent*/
    public void fetchMedia()
    {
        list<Contact> conList=[Select c.Name, 
                                      c.Account.Industry, 
                                      c.Account.Name, 
                                      c.Active__c, 
                                      c.Account.Id, 
                                      c.AccountId 
                               From Contact c 
                               where c.Account.Industry = 'media' AND 
                                     c.Active__c = 'Yes'];
        for(Contact c : conList)
        {
            system.debug('Contact : ' + c.Name);
            system.debug('Account : ' + c.Account.Name);
        }
    }
    public void fetchJohnFromC()
    {
        list<C__c> cList=[Select c.Name__c, 
                                 c.B__r.Name, 
                                 c.A__r.Name 
                          From C__c c 
                          where c.Name__c Like 'john%'];
        for(C__c c : cList)
        {
            system.debug('Child : ' + c.Name__c);
            system.debug('Parents : ' + c.A__r.Name + ',' + c.B__r.Name);
        }
    }
    /*Set 3: Parent to Child*/ 
    public void fetchJohn()
    {
        list<Account> accList=[Select Name, 
                                      Id, 
                                      Active__c, 
                                      AccountNumber, 
                                      (Select Id,
                                              Name 
                                       From Contacts) 
                                From Account 
                                where Id IN (Select AccountId 
                                             From Contact 
                                             where Name Like 'John%')];
        for(Account a : accList)
        { 
            System.debug(a.Name);
            System.debug(a.Active__c+','+a.AccountNumber);
            for(Contact c : a.Contacts)
                System.debug(c.Name);
        }
    }
    public void wonOpportunities()
    {
        list<Account> accList= [Select a.Name,
                                       a.Id, a.AccountNumber, 
                                       (Select Id, 
                                               StageName 
                                        From Opportunities) 
                                 From Account a 
                                 where Id IN (Select AccountID 
                                              from Opportunity 
                                              where StageName='Closed Won')];
        for(Account a : accList)
        {
            System.debug(a.Id+' : '+a.Name);
            System.debug('Account Number : ' + a.AccountNumber + '\RList of Opportunities:');
            for(Opportunity o : a.Opportunities)
                System.debug('>>>'+o.Id + ' : ' + o.StageName);
        }
    }
    public void fetchJohnFromA()
    {
        list<A__c> aList= [Select a.Id, 
                                  (Select A__c,
                                          Name__c 
                                   From Cs__r
                                   where Name__c Like 'john%') 
                           From A__c a 
                           where a.Id IN (Select A__c 
                                          From C__c c 
                                          where c.Name__c Like 'john%')];
        system.debug(alist.size());
        for(A__c a : aList)
        {
            System.debug(a.Id+' : \n'); 
            for(C__c c : a.Cs__r)
                System.debug('>>>'+c.Id + ' : ' + c.Name__c ); 
        } 
    }
    
    /*Set 4*/
    public void testSearch()
    {
        List<List<SObject>> searchTest = [FIND 'Test*' 
                                          IN NAME FIELDS 
                                          RETURNING Contact,
                                                    Account,
                                                    Lead,
                                                    User];
        List<Contact> conList = ((List<Contact>)searchTest[0]);
        List<Account> accList = ((List<Account>)searchTest[1]);
        List<Lead> leadList = ((List<Lead>)searchTest[2]);
        List<User> userList = ((List<User>)searchTest[3]);
        System.debug(conList+'\n'+accList+'\n'+leadList+'\n'+userList);
    }
    /*Set 5*/
    public void logErrors()
    {
        List<Lead> leadList = new List<Lead>(); 
        for(Integer i=0;i<100;i++)
        {
            Lead temp = new Lead();
            if(math.mod(i,2)==0)
                temp = new Lead(LastName='Test'+i, Company='ABCD Pvt. Ltd.', Status='Working - Contacted', Role__c= 'Role'+i);
            else
                temp = new Lead(LastName='Test'+i, Company='ABCD Pvt. Ltd.', Status='Working - Contacted', Role__c= 'Role');
            leadList.add(temp);
        }
        try
        {
            insert leadList;
        }
        catch(DMLException e)
        { 
           Log__c errorLog =new Log__c( Error_Description__c = e.getMessage());
           insert errorLog;
           System.debug('The following exception has occurred: ' + e.getMessage()); 
        }
    }
    public void deleteInactive()
    {
        list<Account> accList=[select Id,
                                      CreatedDate 
                               from Account 
                               where Active__c = 'No' AND 
                                     createdDate >: Date.today().addDays(-90) 
                               order by createdDate DESC];
        for(Account a : accList)
            system.debug(a.createdDate);
        delete accList;
    }
    public void upsertAsset()
    {
        list<Asset> assets = new list<Asset>();
        
        for(Integer i=120;i<130;i++)
        {
            Asset temp = new Asset(Name = 'Asset'+i, Price=i*10, Line_Item_ID__c='LI'+i,AccountId='');
            system.debug(temp);
            assets.add(temp);
        }
        upsert assets Line_Item_ID__c;
    }
}