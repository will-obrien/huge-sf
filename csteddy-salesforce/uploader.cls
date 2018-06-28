public class uploader {

public static void cards(String cardtype) {
/*
Upload all MYOB Suppliers to Card and Address objects
    
*/

String objectName = 'Card__c';

// get a sObjectType object
Schema.sObjectType sObjectType = 
Schema.getGlobalDescribe().get(objectName);

sObject sObj;
List<sObject> listofcards;

// create a new generic sObject
//sObj = sObjectType.newSObject();

// or get an existing generic sObject
sObj = sObjectType.newSObject('a0AZ0000004IFte');

// we can fake it
listofcards = Database.query(
    'select Id from ' + objectName + ' where Id = \'\'');
//List<Card__c> listofcards = new List<Card__c>();

List<Address__c> listofaddresses = new List<Address__c>();
String allsup = endpoint.callEndPoint('v2','GET','','/Contact/'+cardtype);
Integer alpha = allsup.IndexOf('[');
Integer omega = allsup.lastIndexOf(']');
allsup = allsup.substring(alpha,omega) + ']';
system.debug(allsup);
String rt = [select Id from RecordType where Name = :cardtype and SobjectType = 'Card__c' LIMIT 1].Id;
  List<MYOBSupplierV2> r = 
          (List<MYOBSupplierV2>)JSON.deserialize(allsup, List<MYOBSupplierV2>.class);

    for (MYOBSupplierV2 s:r) {
    Card__c c = new Card__c();
    c.UID__c = s.UID;  //unique ID of MYOB record
    c.IsIndividual__c = s.IsIndividual;
    if (s.isIndividual) {
        c.FirstName__c = v.of(s.FirstName);
        c.LastName__c = v.of(s.LastName);
        c.Name = c.FirstName__c + ' ' + c.LastName__c;
        }
    else {
       c.CompanyName__c = v.of(s.CompanyName);   
       c.Name = c.CompanyName__c;
       }
    c.DisplayID__c = v.of(s.DisplayID);    //Labelled as Card ID in MYOB
    c.IsActive__c = s.IsActive;
    c.Notes__c = v.of(s.Notes);    // v.of method protects us from null reference errors
    c.CurrentBalance__c = v.of(s.CurrentBalance);  
    c.PhotoURI__c = v.of(s.PhotoURI);
    c.RowVersion__c = v.of(s.RowVersion);   //If this has changed then the record has been updated
    if (s.CustomField1 != null) {
        c.CustomField1_Label__c = v.of(s.CustomField1.Label);
        c.CustomField1_Value__c = v.of(s.CustomField1.Value);
        }
    if (s.CustomField2 != null) {
        c.CustomField2_Label__c = v.of(s.CustomField2.Label);
        c.CustomField2_Value__c = v.of(s.CustomField2.Value);
        }
    if (s.CustomField3 != null) {
        c.CustomField3_Label__c = v.of(s.CustomField3.Label);  
        c.CustomField3_Value__c = v.of(s.CustomField3.Value);
        }
    if (s.CustomList1 != null) {
        c.CustomList1_Label__c = v.of(s.CustomList1.Label);
        c.CustomList1_Value__c = v.of(s.CustomList1.Value);
        }
    if (s.CustomList2 != null) {
        c.CustomList2_Label__c = v.of(s.CustomList2.Label);   
        c.CustomList2_Value__c = v.of(s.CustomList2.Value);
        }
    if (s.CustomList3 != null) {
        c.CustomList3_Label__c = v.of(s.CustomList3.Label);
        c.CustomList3_Value__c = v.of(s.CustomList3.Value);
        }
    
    if (s.Identifiers != null) {
        c.Identifiers__c = '';
        for (Integer i=0; i<s.Identifiers.size(); i++) {
        system.debug(s.Identifiers[i]);
        c.Identifiers__c=c.Identifiers__c + s.Identifiers[i].Value+';';
        }
        }

    if (s.PaymentDetails != null) {
        c.PaymentDetails_BSBNumber__c = s.PaymentDetails.BSBNumber;    //
        c.PaymentDetails_BankAccountNumber__c = s.PaymentDetails.BankAccountNumber;    //
        c.PaymentDetails_BankAccountName__c = s.PaymentDetails.BankAccountName;  //
        c.PaymentDetails_StatementText__c = s.PaymentDetails.StatementText;    //
        }
        
    if (s.Refund != null) {
        c.Refund_PaymentMethod__c = v.of(s.Refund.PaymentMethod);
        c.Refund_CardNumber__c = s.Refund.CardNumber;
        c.Refund_NameOnCard__c = s.Refund.NameOnCard; // String (50)
        c.Refund_Notes__c = s.Refund.Notes; // String (255)
        }
     if (s.BuyingDetails != null) {
         c.BuyingDetails_PaymentMemo__c = s.BuyingDetails.PaymentMemo;  //
         c.BuyingDetails_PurchaseComment__c = s.BuyingDetails.PurchaseComment;
         c.BuyingDetails_SupplierBillingRate__c = s.BuyingDetails.SupplierBillingRate; //0
         c.BuyingDetails_ShippingMethod__c = s.BuyingDetails.ShippingMethod;
         c.BuyingDetails_IsReportable__c = s.BuyingDetails.IsReportable;
         c.BuyingDetails_CostPerHour__c = s.BuyingDetails.CostPerHour; //0
         c.BuyingDetails_ABN__c = s.BuyingDetails.ABN.replaceAll('(\\s+)', '');  //
         c.BuyingDetails_ABNBranch__c = s.BuyingDetails.ABNBranch;    //
         c.BuyingDetails_TaxIdNumber__c = s.BuyingDetails.TaxIdNumber;  //
         c.BuyingDetails_UseSupplierTaxCode__c = s.BuyingDetails.UseSupplierTaxCode;
         c.BuyingDetails_PurchaseLayout__c = s.BuyingDetails.PurchaseLayout;   //NoDefault
         c.BuyingDetails_PrintedForm__c = s.BuyingDetails.PrintedForm;  //
         c.BuyingDetails_PurchaseOrderDelivery__c = s.BuyingDetails.PurchaseOrderDelivery;    //Print 
         if (s.BuyingDetails.TaxCode != null) {
            c.BuyingDetails_TaxCode_UID__c = s.BuyingDetails.TaxCode.UID;  //177b15f3-d01c-452c-a4ae-d218903a1f42
            c.BuyingDetails_TaxCode_Code__c = s.BuyingDetails.TaxCode.Code; //GST
            }
         if (s.BuyingDetails.FreightTaxCode != null) {
            c.BuyingDetails_FreightTaxCode_UID__c = s.BuyingDetails.FreightTaxCode.UID;  //177b15f3-d01c-452c-a4ae-d218903a1f42
            c.BuyingDetails_FreightTaxCode_Code__c =  s.BuyingDetails.FreightTaxCode.Code; //GST 
            }
         if (s.BuyingDetails.ExpenseAccount != null) {
           c.BuyingDetails_ExpenseAccount_Name__c = v.of(s.BuyingDetails.ExpenseAccount.Name);
           c.BuyingDetails_ExpenseAccount_DisplayID__c = s.BuyingDetails.ExpenseAccount.DisplayID;
           c.BuyingDetails_ExpenseAccount_UID__c = s.BuyingDetails.ExpenseAccount.UID;
           }
         if (s.BuyingDetails.Terms != null) {    
           c.BuyingDetails_Terms_PaymentIsDue__c = s.BuyingDetails.Terms.PaymentIsDue; //DayOfMonthAfterEOM
           c.BuyingDetails_Terms_DiscountDate__c = s.BuyingDetails.Terms.DiscountDate;    //1
           c.BuyingDetails_Terms_BalanceDueDate__c = s.BuyingDetails.Terms.BalanceDueDate;  //30
           c.BuyingDetails_Terms_DiscountForEarlyPaym__c = s.BuyingDetails.Terms.DiscountForEarlyPayment; //0
           c.BuyingDetails_Terms_VolumeDiscount__c = s.BuyingDetails.Terms.VolumeDiscount;  //0
           }
         if (s.BuyingDetails.Credit != null) {
           c.BuyingDetails_Credit_Limit__c = s.BuyingDetails.Credit.CLimit;   //0
           c.BuyingDetails_Credit_Available__c = s.BuyingDetails.Credit.Available;   //0
           c.BuyingDetails_Credit_PastDue__c = s.BuyingDetails.Credit.PastDue; //0
           }
           }
       
       c.RecordTypeId = rt;
//    Is this record already in Salesforce?
//    Check using Card ID
//        [SELECT name FROM Card__c WHERE CardID__c = 
//       upsert c UID__c;
       listofcards.Add(c); // add the card to a list so that they can be all added with a single DML statement (bypasses 150 DML statement governor limit)
//
// 
       if (s.Addresses != null) {
           
        Integer i = 0;
        system.debug(s.Addresses);
        system.debug(s.Addresses.size());
        for (i=0; i < s.Addresses.size(); i++) {
        Address__c a = new Address__c();
        a.Name = string.valueof(s.Addresses[i].Location);
        a.Card__c = null;
        a.Index__c = s.Addresses[i].Location;    //1
        a.Street__c = s.Addresses[i].Street;   //
        a.City__c = s.Addresses[i].City; //
        a.State__c = s.Addresses[i].State;    //
        a.PostCode__c = s.Addresses[i].PostCode; //
        a.Country__c = s.Addresses[i].Country;  //
        a.Phone1__c = s.Addresses[i].Phone1;   //
        a.Phone2__c = s.Addresses[i].Phone2;   //
        a.Phone3__c = s.Addresses[i].Phone3;   //
        a.Fax__c = s.Addresses[i].Fax;  //
        a.Email__c = s.Addresses[i].Email;    //
        a.Website__c = s.Addresses[i].Website;  //
        a.ContactName__c = s.Addresses[i].ContactName;  //
        a.Salutation__c = s.Addresses[i].Salutation;   //
        a.Id = null;
        a.UID__c = s.UID + s.Addresses[i].Location;
        if (a.Street__c !='' || a.City__c !='' || a.State__c !='' || a.PostCode__c !='' || a.Country__c !='' || a.Phone1__c !='' || a.Phone2__c !='' || 
            a.Phone3__c !='' || a.Fax__c !='' || a.Email__c !='' || a.Website__c !='' || a.ContactName__c !='' || a.Salutation__c !='')
            {
            listofaddresses.add(a);
            system.debug(a);
            }
        

        }
        }
    }
//      add all cards in a single DML statement
        List <Card__c> x = (List <Card__c>)listofcards;
        upsert x UID__c;
//      create a Map of MYOB UID to SF Id
    
        Map<String,Id> uidmap = new Map<String,Id>();
        for (Card__c c : x) { uidmap.put(c.UID__c,c.Id); }
//      system.debug(uidmap);
        
//        system.debug(listofcards.get(0).Id);
//      stuff address objects with the Id of the owning Card object
        for (Address__c a : listofaddresses) {
          a.Card__c = uidmap.get(a.UID__c.left(a.UID__c.length()-1));
          system.debug(a);
          }
        
        upsert listofaddresses UID__c;
   
}
}
