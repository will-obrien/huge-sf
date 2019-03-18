/**************************************************************************************
 Author       :   Amarendar Junuthula
 Created Date :   December 08, 2015
 Description  :   The TestDataFactory class is a special type of class—it is a public class that is annotated with isTest and can be accessed only from a running test. 
Test utility classes contain methods that can be called by test methods to perform useful tasks, such as setting up test data. 
Test utility classes are excluded from the org’s code size limit.
***************************************************************************************/
@isTest
public class TestDataFactory {

    //Account creation
    public static List<Account> createAccounts( Integer numberOfAccounts) {
        List<Account> accounts = new List<Account>();
        for ( Integer i = 0 ; i < numberOfAccounts ; i++ ) {
            Account account = new Account( name = 'Test Account' + Math.random(),
                                          Type = 'Architect',Phone= '(415) 419-8873',BillingStreet = '5353 W.Test Rd', Industry = 'Airports & Transportation',
                                          BillingCity = 'Testdale', BillingCountrycode = 'US', BillingStatecode = 'CA', BillingPostalCode = '94803');
            accounts.add( account);
        }
        insert accounts;
        return accounts;
        
    }
    
    
    //Contact Creation
    public static List<Contact> createContacts(Integer numberOfContacts){
        List<Contact> contacts = new List<Contact>();
        for(Integer i=0; i<numberOfContacts; i++){
            Contact contact = new Contact( firstname = 'FirstName' + Math.random(), lastname = 'LastName',
                                          Email = 'noreplay@email.com',Phone= '(415) 419-8873',MailingStreet = '5353 W.Test Rd',
                                          MailingCity = 'Testdale', MailingCountry = 'United States', MailingState = 'California', MailingPostalCode = '94803');
            contacts.add(contact);
        }
        insert contacts;
        return contacts;
        
    }
    
    
    //Opportunity Creation
    public static List<opportunity> createOpportunities(Integer numberOfOpportunities){
        List<Opportunity> opportunities = new List<Opportunity>();
        for(Integer i=0; i<numberofOpportunities; i++){
            Opportunity opportunity = new Opportunity( Name = 'Test Opportunity'+ Math.random(), CloseDate = Date.today() + 7, Estimated_Shipping_Date__c = Date.today() + 10, 
                                                     StageName = 'Target/Lead Verification', Line_of_Business__c = 'Equipment Only', Vertical_Market__c = 'Airports & Transportation', 
                                                     Region_Territory__c = 'DALA', Opportunity_Country__c = 'USA-USA', Opp_State__c = 'Minnesota', Opp_City__c = 'Plymouth',
                                                     Amount = 10.00, Next_Step__c = 'Closed');
             opportunities.add(opportunity);
        }
        insert opportunities;
        return opportunities;
        
    }
    
    //Lead Creation
    public static List<Lead> createLeads(Integer numberOfLeads){
        List<Lead> leads = new List<Lead>();
        for(Integer i=0; i<numberOfLeads; i++){
            Lead lead = new Lead( FirstName = 'Firstname'+ Math.random(), LastName = 'LastName'+ Math.random(),  Company = 'Test Account' + Math.random(), 
                                 Email = 'noreplay@email.com',Phone= '(415) 419-8873', Industry = 'Airports & Transportation', street = 'Street 1',
                                 City = 'Plymouth', State = 'Minnesota', Country = 'United States', PostalCode = '55441');
             Leads.add(lead);
        }
        insert Leads;
        return Leads;
        
    }
    
    //Case Creation
    public static List<Case> createCases(Integer numberOfCases){
        List<Case> Cases = new List<Case>();
        for(Integer i=0; i<numberOfCases; i++){
            Case case1 = new case( Origin = 'web', Reason = 'Complex functionality', Status = 'New', Subject = 'Test Subject');
             Cases.add(case1);
        }
        insert Cases;
        return Cases;
    }
    
    //Change Request Creation
    public static List<Change_Request__c> createChangeRequests(Integer numberOfChangeRequests){
        List<Change_Request__c> ChangeRequests = new List<Change_Request__c>();
        for(Integer i=0; i<numberOfChangeRequests; i++){
            Change_Request__c ChangeRequest  = new Change_Request__c( Company_Division__c = 'Consulting Sales', Request_Type__c = 'New Functionality', Request_Category__c = 'Accounts', Request_Priority_Level__c = 'High', Desired_Completion_Date__c = Date.Today()+7, Change_Summary__c = 'Test', Detailed_Change_Description__c = 'Detailed Change Request');
            ChangeRequests.add(ChangeRequest);
        }
        insert ChangeRequests ;
        return ChangeRequests ;
    }
    
            
    
    //Quote/Proposal Creation
    public static List<Apttus_Proposal__Proposal__c> createApttusProposal(Integer numberOfProposals){
        List <Account> accounts = TestDataFactory.createAccounts(2);
        List<Contact> contacts = TestDataFactory.createContacts(2);
        Opportunity opportunities = TestDataFactory.createOpportunities(1)[0];
        List<Apttus_Proposal__Proposal__c> qApttusProposals= new List<Apttus_Proposal__Proposal__c>();
        
        Apttus_Config2__PriceList__c pb = new Apttus_Config2__PriceList__c(Name= 'Test Pricebook', Apttus_Config2__Active__c=TRUE);
        insert pb;
        Product2 p1 = new Product2(Name='Test Product1', Family = 'Test');
        insert p1;
        Product2 p2 = new Product2(Name='Test Product2', Family = 'Test');
        insert p2;
        Apttus_Config2__PriceListItem__c PLI1 = new Apttus_Config2__PriceListItem__c(Apttus_Config2__Active__c = TRUE, Apttus_Config2__ProductId__c = P1.Id, Apttus_Config2__PriceListId__c = pb.Id, Apttus_Config2__ListPrice__c =10);
        insert pLI1;
        Apttus_Config2__PriceListItem__c PLI2 = new Apttus_Config2__PriceListItem__c(Apttus_Config2__Active__c = TRUE, Apttus_Config2__ProductId__c = P2.Id, Apttus_Config2__PriceListId__c = pb.Id, Apttus_Config2__ListPrice__c =100);
        insert pLI2;
        for(Integer i=0; i<numberOfProposals; i++){
            
          Apttus_Proposal__Proposal__c qApttusProposal = new Apttus_Proposal__Proposal__c( Apttus_Proposal__Account__c = accounts[0].id, Apttus_Proposal__Primary_Contact__c=contacts[0].id,  Apttus_QPConfig__PriceListId__c = pb.Id, Quote_Document_Date__c = date.Today(), Expiration_Date__c = date.Today(), Brand__c = 'Daikin', Quote_Document_Title__c = 'QUOTE', Document_Presentation_Language__c = 'English', Quote_Presentation_Currency__c ='USD');
      qApttusProposals.add(qApttusProposal);
            
      }
        insert qApttusProposals;
        //Apttus_Proposal__Proposal_Line_Item__c lineItemClone = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Proposal__c=qApttusProposals[0].id, Apttus_QPConfig__PriceListId__c =pb.Id, Apttus_QPConfig__PriceListItemId__c = pLI1.id);
        //insert lineItemClone;
        return qApttusProposals;
        
    }
    
}