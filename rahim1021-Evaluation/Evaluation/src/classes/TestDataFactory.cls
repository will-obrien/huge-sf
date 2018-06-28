/* This class is the Test DAta FActory class for ConvertedLeads VisualForce Page.
 *
 * Functionality: this class will Create lead,account,contact records 
 *
 * Revision History: 
 *
 * Version     Author               Date         Description 
 * 1.0         Abdulrahim Mulla     21/03/2016   Basic Functionality Acheived 
 *
 */
public class TestDataFactory {
    // Create test record for Leads 
    public static List<Lead> createTestRecordLeads(Integer numLeads){
        List<Lead> listLeads=new List<Lead>();
        for(Integer indexI=0;indexI<numLeads;indexI++){
            Lead objLead=new Lead(FirstName='firstName'+indexI,
                                  LastName='lastName'+indexI,
                                  MobilePhone='134654'+indexI,
                                  Company='Company'+indexI,
                                  Email='email'+indexI+'@mail.com',
                                  Status='Open - Not Contacted',
                                  LeadSource='Web'
                                 );
            listLeads.add(objLead);
        }
        return listLeads;
    }
    public static List<Account> createTestRecordAccounts(Integer numAccounts){
        // Create test record for Accounts 
        List<Account> listAccounts=new List<Account>();
        for(Integer indexI=0;indexI<numAccounts;indexI++){
            Account objAccount=new Account(Name='Company'+indexI);
            listAccounts.add(objAccount);
        }
        
        return listAccounts;
    }
    public static List<Contact> createTestRecordContacts(Integer numContacts){
        // Create test record for Contacts 
        List<Account> listAccounts=createTestRecordAccounts(3);
        List<Contact> listContacts=new List<Contact>();
        for(Integer indexI=0;indexI<numContacts;indexI++){
            Contact objContact=new Contact(FirstName='firstName'+indexI,
                                           LastName='lastName'+indexI,
                                           AccountId=listAccounts.get(indexI).id
                                          );
            listContacts.add(objContact);
        }
        return listContacts;
    }

}