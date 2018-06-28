public class TestClone {
    public static void doCloneTest(){
        Account acc=new  Account(Name='ACC');
insert acc;

// Create the Opp.
Opportunity opp = new Opportunity(Name='CloneTest',AccountId=acc.id,Amount=222,StageName='xyz',CloseDate=System.today());
insert opp;

// Load the original back, this time also getting a referenced Account object.
Opportunity original = [select Name, Account.Name from Opportunity where id=:opp.id];

// Clone both ways.
Opportunity deep = original.Clone(true,true);
Opportunity shallow = original.Clone(true,false);

// All the Account Names will be the same.
system.debug('original.Account.Name: ' + original.Account.Name);
system.debug('deep.Account.Name: ' + deep.Account.Name);
system.debug('shallow.Account.Name: ' + shallow.Account.Name);

original.Account.Name = 'Peanuts';

// Only the Shallow one will change.
system.debug('original.Account.Name: ' + original.Account.Name);
system.debug('deep.Account.Name: ' + deep.Account.Name);
system.debug('shallow.Account.Name: ' + shallow.Account.Name);
    }

}