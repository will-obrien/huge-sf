@isTest
public class UnusedInternalPropertiesDeploymentTest {

    static testMethod void shouldDeleteInternalPropertiesRecords() {
        Test.startTest();
        Id intProp1 = createInternalProperties('IntP_1');
        Id intProp2 = createInternalProperties('IntP_2');
        Id intProp3 = createInternalProperties('IntP_3');
        Id intProp4 = createInternalProperties('IntP_4');
        Id intProp5 = createInternalProperties('IntP_5');

        createDomainObject(1, intProp1);
        createDomainObject(2, intProp2);
        createDomainObject(3, intProp3);

        List<Internal_Properties__c> intPropsInDB = [SELECT Id FROM Internal_Properties__c];
        System.assertEquals(5, intPropsInDB.size());
        Database.executeBatch(new UnusedInternalPropertiesDeleteBatch());
        Test.stopTest();

        List<Internal_Properties__c> intProps = [SELECT Id FROM Internal_Properties__c];
        System.assertEquals(3, intProps.size());
    }

    static private Id createInternalProperties(String name) {
        Internal_Properties__c intProp = new Internal_Properties__c(area__c = name);
        insert intProp;
        return intProp.Id;
    }

    static private void createDomainObject(Integer i, Id intProp) {
        hqInt_Model_DomainClass d = new hqInt_Model_DomainClass();
        d.x_id = 'domain_' + i;
        d.Name = 'domain_name_' + i;
        d.tags = new List<String> { ' ' };
        Domain__c domainFromDb = d.createDbObject(null, 'CommCareHQ');
        domainFromDb.Internal_Properties__c = intProp;
        insert domainFromDb;
    }
}