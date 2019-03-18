public without sharing class QuoteHistoryHandler {

//public QuoteHistoryHandler(List<Quote> newQuotes, Map <Id,Quote> oldQuoteMap) {
//}

  public static Id adminId = '005a0000009lTTN'; //makes Matt Santy default owner 
  
  public static void trackChanges(List<Quote> newList, Map<Id,Quote> oldMap) { 
    List<Schema.FieldSetMember> trackedFields = SObjectType.Quote.FieldSets.QuoteHistoryTracking.getFields();
    if (trackedFields.isEmpty()) return;

    List<Quote_History__c> fieldChanges = new List<Quote_History__c>();

    for (Quote qNew : newList) {

      Quote qOld = oldMap.get(qNew.Id);

      for (Schema.FieldSetMember fsm : trackedFields) {
        String fieldName  = fsm.getFieldPath();
        String fieldLabel = fsm.getLabel();

        if (qNew.get(fieldName) != qOld.get(fieldName)) {
          String oldValue = String.valueOf(qOld.get(fieldName));
          String newValue = String.valueOf(qNew.get(fieldName));
          if (oldValue != null && oldValue.length()>255) oldValue = oldValue.substring(0,255);
          if (newValue != null && newValue.length()>255) newValue = newValue.substring(0,255); 

          Quote_History__c qft = new Quote_History__c();
          qft.name         = fieldLabel;
          qft.Field_Name__c   = fieldName;
          qft.Quote__c      = qNew.Id;
          qft.Edited_By__c = UserInfo.getUserId();
          qft.Old_Value__c  = oldValue;
          qft.New_Value__c  = newValue;
          qft.OwnerId      = adminId; 
          qft.Counter__c = fieldChanges.size();
          fieldChanges.add(qft);

        }        

      }

    }

    if (!fieldChanges.isEmpty()) {
      String jsonString = Json.serialize(fieldChanges);
      QuoteHistoryHandler.storeQuoteTracking(jsonString);
    }

  }

  public static void storeQuoteTracking(String jsonString){

    Type pType = List<Quote_History__c>.class;
    List<Quote_History__c> fieldHistory = (List<Quote_History__c>) JSON.deserialize(jsonString, pType);
    insert fieldHistory;

  }

}