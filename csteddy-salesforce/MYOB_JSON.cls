public class MYOB_JSON {

public static String supplier(Card__c s) {
/*


"Addresses" : [
{
"Location" : 1,
"Street" : "105 Bourke Street",
"City" : "Melbourne",
"State" : "VIC",
"PostCode" : "3000",
"Country" : "Australia",
"Phone1" : "03 8897 9444",
"Phone2" : "03 8897 2989",
"Phone3" : "03 8897 7300",
"Fax" : "03 8897 4212",
"Email" : "cashp@yahoo.com.au",
"Website" : "www.myob.com.au",
"ContactName" : "Tim",
"Salutation" : "Mr."
}
],

"Identifiers" : null,

*/
system.debug('SObject='+s);
//instantiate the generator
JSONGenerator gen = JSON.createGenerator(true);
gen.writeStartObject();
gen.writeBooleanField('IsIndividual',s.IsIndividual__c);
if (s.IsIndividual__c) {
  gen.writeStringField('FirstName',v.of(s.FirstName__c));
  gen.writeStringField('LastName',v.of(s.LastName__c));
  }
else 
  gen.writeStringField('CompanyName',v.of(s.CompanyName__c));
// UID only required on update
if (s.UID__c != null && s.UID__c != '') gen.writeStringField('UID',v.of(s.UID__c));
gen.writeStringField('DisplayID',v.of(s.DisplayID__c));
gen.writeNumberField('CurrentBalance',v.of(s.CurrentBalance__c));
gen.writeBooleanField('IsActive',s.IsActive__c);

gen.writeStringField('ABN',v.of(s.BuyingDetails_ABN__c));
gen.writeStringField('ABNBranch',v.of(s.BuyingDetails_ABNBranch__c));
gen.writeStringField('TaxIdNumber',v.of(s.BuyingDetails_TaxIdNumber__c));
gen.writeStringField('Notes',v.of(s.Notes__c));

gen.writeBooleanField('UseSupplierTaxCode',s.BuyingDetails_UseSupplierTaxCode__c);
gen.writeFieldName('CustomList1');
gen.writeStartObject();
gen.writeObjectField('Label','Custom List No. 1');
gen.writeObjectField('Value','Custom List Value');
gen.writeEndObject();
gen.writeFieldName('CustomList2');
gen.writeStartObject();
gen.writeObjectField('Label','Custom List No. 2');
gen.writeObjectField('Value','Custom List Value');
gen.writeEndObject();
gen.writeFieldName('CustomList3');
gen.writeStartObject();
gen.writeObjectField('Label','Custom List No. 3');
gen.writeObjectField('Value','Custom List Value');
gen.writeEndObject();
gen.writeFieldName('CustomField1');
gen.writeStartObject();
gen.writeObjectField('Label','Custom Field No. 1');
gen.writeObjectField('Value','Custom Field Value');
gen.writeEndObject();
gen.writeFieldName('CustomField2');
gen.writeStartObject();
gen.writeObjectField('Label','Custom Field No. 2');
gen.writeObjectField('Value','Custom Field Value');
gen.writeEndObject();
gen.writeFieldName('CustomField3');
gen.writeStartObject();
gen.writeObjectField('Label','Custom Field No. 3');
gen.writeObjectField('Value','Custom Field Value');
gen.writeEndObject();

// New API V2 fields
gen.writeFieldName('Terms');
gen.writeStartObject();
gen.writeObjectField('PaymentIsDue',v.of(s.BuyingDetails_Terms_PaymentIsDue__c));
gen.writeObjectField('Date',v.of(s.BuyingDetails_Terms_DiscountDate__c));
gen.writeObjectField('BalanceDueDate',v.of(s.BuyingDetails_Terms_BalanceDueDate__c));
gen.writeObjectField('DiscountForEarlyPayment',v.of(s.BuyingDetails_Terms_DiscountForEarlyPaym__c));
gen.writeObjectField('VolumeDiscount',v.of(s.BuyingDetails_Terms_VolumeDiscount__c));
gen.writeEndObject();
gen.writeFieldName('PaymentDetails');
gen.writeStartObject();
gen.writeObjectField('BSBNumber',v.of(s.PaymentDetails_BSBNumber__c));
gen.writeObjectField('BankAccountNumber',v.of(s.PaymentDetails_BankAccountNumber__c));
gen.writeObjectField('BankAccountName',v.of(s.PaymentDetails_BankAccountName__c));
gen.writeObjectField('StatementText',v.of(s.PaymentDetails_StatementText__c)); //   not the same as payment memo
gen.writeEndObject();
gen.writeFieldName('Refund');
gen.writeStartObject();
gen.writeObjectField('PaymentMethod',v.of(s.Refund_PaymentMethod__c));
gen.writeObjectField('NameOnCard',v.of(s.Refund_NameOnCard__c));
gen.writeObjectField('CardNumber',v.of(s.Refund_CardNumber__c));
gen.writeObjectField('Notes',v.of(s.Refund_Notes__c));
gen.writeEndObject();
gen.writeFieldName('BuyingDetails');
gen.writeStartObject();
gen.writeObjectField('PurchaseLayout',v.of(s.BuyingDetails_PurchaseLayout__c));
gen.writeObjectField('PurchaseLayout','Service');
gen.writeObjectField('PrintedForm',v.of(s.BuyingDetails_PrintedForm__c));
gen.writeObjectField('PurchaseOrderDelivery',v.of(s.BuyingDetails_PurchaseOrderDelivery__c));
gen.writeObjectField('PaymentMemo',v.of(s.BuyingDetails_PaymentMemo__c));
gen.writeObjectField('PurchaseComment',v.of(s.BuyingDetails_PurchaseComment__c));
gen.writeObjectField('SupplierBillingRate',v.of(s.BuyingDetails_SupplierBillingRate__c));
gen.writeObjectField('ShippingMethod',v.of(s.BuyingDetails_ShippingMethod__c));
gen.writeObjectField('IsReportable',s.BuyingDetails_IsReportable__c);
gen.writeObjectField('CostPerHour',v.of(s.BuyingDetails_CostPerHour__c));
gen.writeFieldName('TaxCode');
gen.writeStartObject();
gen.writeObjectField('UID','177b15f3-d01c-452c-a4ae-d218903a1f42');
gen.writeObjectField('Code',v.of(s.BuyingDetails_TaxCode_Code__c));
gen.writeEndObject();
gen.writeFieldName('FreightTaxCode');
gen.writeStartObject();
gen.writeObjectField('UID','177b15f3-d01c-452c-a4ae-d218903a1f42');
gen.writeObjectField('Code',v.of(s.BuyingDetails_FreightTaxCode_Code__c));
gen.writeEndObject();
gen.writeFieldName('ExpenseAccount');
gen.writeStartObject();
//gen.writeObjectField('UID" : "6703ee30-b063-4afe-8ed3-14834b25a30e",
//gen.writeObjectField('Name" : "Other Operating Expenses",
gen.writeObjectField('DisplayID',v.of(s.BuyingDetails_ExpenseAccount_DisplayID__c));
gen.writeEndObject();
gen.writeFieldName('Credit');
gen.writeStartObject();
gen.writeObjectField('Limit',v.of(s.BuyingDetails_Credit_Limit__c));
gen.writeObjectField('Available',v.of(s.CurrentBalance__c));
//gen.writeObjectField('PastDue',s.
gen.writeEndObject();
gen.writeEndObject();

gen.writeEndObject(); //Writes the ending marker of a JSON object '}'

String jsonString = gen.getAsString();

return jsonString;

}

}
