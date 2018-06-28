/**
 * Tests the update of the Country_Text__c field in Contract with the names of the Contract Countries
 *
 * @author  Virginia Fernández
 * @date    04/12/2013
 */
@isTest
private class ContractCountryTriggerTest {

    static testMethod void newContractCountryTest() {
        DContract__c contract = new DContract__c();
        contract.Name = 'Contract';
        insert contract;
        
        Country__c country1 = new Country__c();
        country1.Name = 'Country1';
        insert country1;
        
        Country__c country2 = new Country__c();
        country2.Name = 'Country2';
        insert country2;
        
        Test.startTest();
        
        Contract_Country__c contrCountry1 = new Contract_Country__c();
        contrCountry1.Country__c = country1.Id;
        contrCountry1.Contract__c = contract.Id;
        insert contrCountry1;
        
        contract = [select Id, Country_Text__c from DContract__c where id =: contract.Id];
        System.assertEquals(contract.Country_Text__c, 'Country1');
        
        Contract_Country__c contrCountry2 = new Contract_Country__c();
        contrCountry2.Country__c = country2.Id;
        contrCountry2.Contract__c = contract.Id;
        insert contrCountry2;
        
        contract = [select Id, Country_Text__c from DContract__c where id =: contract.Id];
        System.assert(contract.Country_Text__c != null &&
                      contract.Country_Text__c.indexOf('Country2') != -1 &&
                      contract.Country_Text__c.indexOf('Country1') != -1);
        
        Test.stopTest();
        
    }
    
    static testMethod void deleteContractCountryTest() {
        DContract__c contract = new DContract__c();
        contract.Name = 'Contract';
        insert contract;
        
        Country__c country1 = new Country__c();
        country1.Name = 'Country1';
        insert country1;
        
        Country__c country2 = new Country__c();
        country2.Name = 'Country2';
        insert country2;
        
        Contract_Country__c contrCountry1 = new Contract_Country__c();
        contrCountry1.Country__c = country1.Id;
        contrCountry1.Contract__c = contract.Id;
        insert contrCountry1;
        
        Contract_Country__c contrCountry2 = new Contract_Country__c();
        contrCountry2.Country__c = country2.Id;
        contrCountry2.Contract__c = contract.Id;
        insert contrCountry2;
        
        Test.startTest();
        
        contract = [select Id, Country_Text__c from DContract__c where id =: contract.Id];
        System.assert(contract.Country_Text__c != null &&
                      contract.Country_Text__c.indexOf('Country2') != -1 &&
                      contract.Country_Text__c.indexOf('Country1') != -1);
        
        delete contrCountry2;
        
        contract = [select Id, Country_Text__c from DContract__c where id =: contract.Id];
        System.assertEquals(contract.Country_Text__c, 'Country1');
        
        Test.stopTest();
        
    }
    
}