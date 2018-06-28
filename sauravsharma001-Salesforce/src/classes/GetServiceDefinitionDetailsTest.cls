@isTest(SeeAllData=true)
public class GetServiceDefinitionDetailsTest {

    static  testmethod void getDatatypeDescriptionTest(){
        
        GetServiceDefinitionDetails d = new GetServiceDefinitionDetails();
        d.getDatatypeDescription('DataCategoryGroupReference');
        d.getDatatypeDescription('Currency');
        d.getDatatypeDescription('Boolean');
        d.getDatatypeDescription('Date');
        d.getDatatypeDescription('Date/Time');
        d.getDatatypeDescription('Email');
        d.getDatatypeDescription('Geolocation');
        d.getDatatypeDescription('Integer');
        d.getDatatypeDescription('MultiPicklist');
        d.getDatatypeDescription('Picklist');
        d.getDatatypeDescription('Percent');
        d.getDatatypeDescription('Phone');
        d.getDatatypeDescription('String');
        d.getDatatypeDescription('TextArea');
        d.getDatatypeDescription('EncryptedString');
        d.getDatatypeDescription('URL');
    }    
    
    static  testmethod void fieldListTest(){
        
        GetServiceDefinitionDetails d = new GetServiceDefinitionDetails();
        d.fieldList('SR-ST19');
        d.fieldList('SR-ST49');
    }
    
    static  testmethod void fieldListCodeTest(){
        
        GetServiceDefinitionDetails d = new GetServiceDefinitionDetails();
        d.fieldListCode('SR-ST19');
        d.fieldListCode('SR-ST49');
    }
    
    static  testmethod void decryptFieldListCodeTest(){
        
        GetServiceDefinitionDetails d = new GetServiceDefinitionDetails();
        d.decryptFieldListCode('SR-ST19','SR-ST19-F25');
        d.decryptFieldListCode('SR-ST19','SR-ST19-F01');
        d.decryptFieldListCode('SR-ST19','SR-ST19-F29');
    }
    
    static  testmethod void fieldListNotReqdTest(){
        
        GetServiceDefinitionDetails d = new GetServiceDefinitionDetails();
        d.fieldListNotReqd('SR-PD01','Test');
        d.fieldListNotReqd('SR-PD01','SR-PD01-F04');
    }    
}