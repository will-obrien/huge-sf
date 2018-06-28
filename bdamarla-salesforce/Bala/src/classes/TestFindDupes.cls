@isTest
public class TestFindDupes {
    static testMethod void TestDupes(){
        Contact mycontact = new Contact();
				mycontact.FirstName ='Bala';
				mycontact.LastName ='dam';
        		mycontact.Email ='Bala@abc.com';
        insert mycontact;
        
		Lead myLead	= new Lead();
        		myLead.FirstName ='Bala';
				myLead.LastName ='dam';
        		myLead.Email ='Bala@abc.com';        		
        
        try {
        insert myLead;    
        }
        catch(exception e) {
            system.debug('An expected valid error');
        }
        
        List<Lead> dupcheck = [Select id from Lead where Email = 'Bala@abc.com'];
       	system.assertEquals(0, dupcheck.size());
        
        Lead cLead = new Lead();
        	cLead.FirstName='Sankar';
            cLead.LastName='Dam';
        	cLead.Email='Sankar@abc.com';
        insert cLead;
        
        List<Lead> Lcheck = [Select id from Lead where Email = 'Sankar@abc.com'];
       	system.assertEquals(1, Lcheck.size());
 
    }
    
}