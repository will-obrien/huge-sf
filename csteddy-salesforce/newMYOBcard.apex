trigger newMYOBcard on Card__c (before insert) {
/*
The purpose of this trigger is to callout to the MYOB API to create a new card record that mirrors
the SF Custom Object Cards. There are 4 different card types in MYOB of which 3 are currently supported by
our bespoke customisation - [Personal, Supplier and Customer]. The fields applicable to the different record types
include some fields that are common to all record types;some fields that are common to some record types and some
fields that are unique to a record type. The different field groupings have been identified by SF fieldsets.
The Personal fieldset contains fields common to ALL record types;
The Base (Card) fieldset contains fields common to Customer and Supplier record types;
The Supplier fieldset contains fields unique to the Supplier record type;
The Customer fieldset contains fields unique to the Customer record type;

The API requires a JSON object contain field:value pairs for all the Card object fields
for the matching record type. I have made the API field name match the API requirements so only the '__c' suffix
needs to be removed. This could be done by using a System.JSON serialize method and then trimming off the 
'__c' suffix or using the System.JSONGenerator class methods. Either way there will be no need to individually map
SF fields to MYOB API fields.

*/
/*
public class CardDetails {

    public Card__c card { get; set; }
    
    public CardDetails(String recordTypeId) {
        this.card = getCard(recordTypeId);
    }

    public List<Schema.FieldSetMember> getFields(String recordTypeId) {
    // method returns a list of fields based on the Card object record type
        Map<Id,RecordType> r = new Map<Id,RecordType>([SELECT Id,Name from RecordType where SObjectType='Card__c']);
//      System.debug(r.get(recordTypeId).Name);
        List<Schema.FieldSetMember> lf = new List<Schema.FieldSetMember>();
//      All record types have Personal fields
        lf.addall(SObjectType.Card__c.FieldSets.Personal.getFields());
        if (r.get(recordTypeId).Name=='Personal') return lf;
//      Supplier and Customer record types have common fields (Card/Base fieldset)
        lf.addall(SObjectType.Card__c.FieldSets.Card.getFields());
        if (r.get(recordTypeId).Name=='Customer') lf.addall(SObjectType.Card__c.FieldSets.Customer.getFields());
        else if (r.get(recordTypeId).Name=='Supplier') lf.addall(SObjectType.Card__c.FieldSets.Supplier.getFields());
        return lf;
        
    }

    private Card__c getCard(String recordTypeId) {
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getFields(recordTypeId)) {
            query += f.getFieldPath() + ', ';
        }
 
        query += 'Id, Name FROM Card__c LIMIT 1';
        return Database.query(query);
    }
}

for (Card__c ct: Trigger.new) {
*/  
/*  
  Map<String,String> mapAllFieldsWithRecordType = newMyobUtil.getAllFieldsWithRecordType(ct.RecordTypeId);
  system.debug(mapAllFieldsWithRecordType + ' List All Fields');   
  system.debug(mapAllFieldsWithRecordType.size() + ' Number of Fields');
  Card__c resultCard = new Card__c(id = ct.Id, Name = ct.Name );
  CardDetails c= new CardDetails(ct.RecordTypeId);

  if (mapAllFieldsWithRecordType.size() > 0) {
       JSONGenerator generator = JSON.createGenerator(true);
       generator.writeStartObject();
       //generator.writeStringField('Id__c',String.valueOf(ct.Id));
       //generator.writeStringField('Name',ct.Name);
      for (String key : mapAllFieldsWithRecordType.keyset() ) {
              if (key != 'Id__c' && key != 'CoLastName__c'){
              
                if ((mapAllFieldsWithRecordType.get(key) == 'CURRENCY') || (mapAllFieldsWithRecordType.get(key) == 'Number') ){
                    if (ct.get(key) != null){
                        generator.writeNumberField(key.replace('__c',''),Double.valueOf(ct.get(key)));
                    }
                    else{
                        generator.writeNumberField(key.replace('__c',''),0);
                    }
                }
                else{
                     if (ct.get(key) != null){
                        generator.writeStringField(key.replace('__c',''),String.valueOf(ct.get(key)));
                     }
                     else{
                        generator.writeStringField(key.replace('__c',''),'');
                     }  
                }
              }
              else{
                 if (key == 'Id__c'){
                    generator.writeStringField(key,String.valueOf(ct.get(key)));
                 }
                 else{
                    generator.writeStringField(key.replace('__c',''),String.valueOf(ct.get(key)));
                 }
                
              }   
          }
        generator.writeEndObject(); 
      String jsonString = generator.getAsString();
      system.debug(jsonString + ' Json String using Json Generator');
*/

//     String jsonString = MYOB_JSON.supplier(ct);
     // async call to myob
//     System.debug(jsonString);    
//      endpoint.FireAndForget(jsonString); 
//      }

        
//  }  // end of function

  
  
 }  // end of class
