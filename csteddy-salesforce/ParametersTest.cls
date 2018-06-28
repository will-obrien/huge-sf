@istest (SeeAllData=true)
public class ParametersTest {
public static testmethod void paramtest1() {


Card__c c = [SELECT Id, Name FROM Card__c LIMIT 1];
Parameters p = new Parameters();
p.add('Id',c.Id);
p.add('Name',c.Name);
system.debug(p.serialize());


Parameters params = new Parameters();
params.add('Name', 'Robert');
params.add('Age', 36);
system.debug(params.toString()); // [parameters={Age=36, Name=Robert}]
String serialized = params.serialize();
system.debug(serialized); // {"Age":36,"Name":"Robert"}
serialized = '{ "DisplayId": "GWX000104", "BuyingDetails" : { "TaxCode" : {"Code" : "GST","UID": "177b15f3-d01c-452c-a4ae-d218903a1f42"}, "FreightTaxCode" : {"Code" : "GST","UID": "177b15f3-d01c-452c-a4ae-d218903a1f42"}}, "Decimal": 1.1, "IsActive": true, "Integer" : 22 }';

// { "a": { "1": 1, "2": 2} could be read as ((Map<String,Object>) data.get('a')).get('2')
//Parameters deserialized = Parameters.deserialize(serialized);
Map<String,Object> deserialized = (Map<String,Object>)JSON.deserializeUntyped(serialized);
system.debug('Card Id ='+deserialized.get('DisplayId'));
Boolean Isactive = (Boolean)deserialized.get('IsActive');
Integer i = (Integer)deserialized.get('Integer');
Decimal d = (Decimal)deserialized.get('Decimal');
system.debug(Isactive + ' ' + i + ' ' + d);
system.debug('Buying Details = '+deserialized.get('BuyingDetails'));
Map<String,Object> buyingdetails = (Map<String,Object>)deserialized.get('BuyingDetails');
system.debug(buyingdetails);
Map<String,Object> taxcode = (Map<String,Object>)buyingdetails.get('TaxCode');
system.debug('TaxCode = '+taxcode); //{Code=GST, UID=177b15f3-d01c-452c-a4ae-d218903a1f42}
system.debug(((Map<String,Object>)deserialized.get('BuyingDetails')).get('TaxCode'));
system.debug(taxcode.get('Code')); //GST
 
String listofJSONobjects = '[ {"DisplayId": "GWX000105" },'+serialized+' ]';
List<Object> root = (List<Object>)JSON.deserializeUntyped(listofJSONobjects);
system.debug(root);
    for (Object item : root) {
        Map<String, Object> r = (Map<String, Object>)item;
        System.debug(r.get('DisplayId'));
        if(r.get('DisplayId') == 'GWX000104') {
        system.debug(((Map<String,Object>)r.get('BuyingDetails')).get('TaxCode'));
        }
    }


//Parameters t = new Parameters();
//t = (Parameters)buyingdetails;
//system.debug('TaxCode = '+t.get('TaxCode'));
//System.assertEquals(params.toString(), deserialized.toString());

}
}
