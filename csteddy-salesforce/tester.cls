public class tester {

public static void cards(String parentObjectName,String childObjectName, String cardtype) {
/*
tester.cards('Card__c','Address__c','Supplier');

*/
Schema.sObjectType parentType = Schema.getGlobalDescribe().get(parentObjectName);
Schema.sObjectType childType = Schema.getGlobalDescribe().get(childObjectName);
//Sobject sObj = parentType.newSObject();
//List<sObject> sObjects = Database.query('select Id from ' + parentObjectName + ' where Id = \'\'');
List<Sobject> listofparents = Database.query('select Id from ' + parentObjectName + ' where Id = \'\'');
List<Sobject> listofchildren = Database.query('select Id from ' + childObjectName + ' where Id = \'\'');
List<Address__c> listofaddresses = new List<Address__c>();
// Get custom field names for parent and child objects

Map<String,Schema.DisplayType> parentfields = objectinfo.showfields(parentObjectName);
Map<String,Schema.DisplayType> childfields = objectinfo.showfields(childObjectName);
String allsup = endpoint.callEndPoint('v2','GET','','/Contact/'+cardtype);
Integer alpha = allsup.IndexOf('[');
Integer omega = allsup.lastIndexOf(']');
allsup = allsup.substring(alpha,omega) + ']';
system.debug(allsup);
String rt = [select Id from RecordType where Name = :cardtype and SobjectType = 'Card__c' LIMIT 1].Id;
List<Object> root = (List<Object>)JSON.deserializeUntyped(allsup);
for (Object item : root) {
    Map<String, Object> s = (Map<String, Object>)item;
    
//     system.debug(((Map<String,Object>)r.get('BuyingDetails')).get('TaxCode'));
 
    
    SObject c = parentType.newSObject();

//  c.put('UID__c', s.get('UID')); //unique ID of MYOB record
//  c.put('IsIndividual__c',s.get('IsIndividual'));

    if ((Boolean)s.get('IsIndividual')) {
//        c.put('FirstName__c',(s.get('FirstName')));
//        c.put('LastName__c',(s.get('LastName')));
        c.put('Name',s.get('FirstName') + ' ' + s.get('LastName'));
        }
    else {
//     c.put('CompanyName__c',s.get('CompanyName'));   
       c.put('Name',s.get('CompanyName'));
       }
      
      for (String  f : parentfields.keySet()) {
        if (f.contains('Custom') != true) {
         List<String> h = f.split('_', 0);
         if ((f.countMatches('_') == 0) && (s.containsKey(f))) c.put(f+'__c',s.get(f));
         else if ((f.countMatches('_') == 1) && (s.containsKey(h[0]))) {
             system.debug(f+' '+h[0]+' '+h[1]);
             Map<String,Object> h1 = (Map<String,Object>)s.get(h[0]);
             c.put(f+'__c',h1.get(h[1])); }
             
             }
         
         }
      
/*

system.debug('Buying Details = '+deserialized.get('BuyingDetails'));
Map<String,Object> buyingdetails = (Map<String,Object>)deserialized.get('BuyingDetails');
Map<String,Object> taxcode = (Map<String,Object>)buyingdetails.get('TaxCode');
system.debug('TaxCode = '+taxcode); //{Code=GST, UID=177b15f3-d01c-452c-a4ae-d218903a1f42}
system.debug(((Map<String,Object>)deserialized.get('BuyingDetails')).get('TaxCode'));
system.debug(taxcode.get('Code')); //GST

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
*/       
       c.put('RecordTypeId',rt);
//    Is this record already in Salesforce?
//    Check using Card ID
//        [SELECT name FROM Card__c WHERE CardID__c = 
//       upsert c UID__c;
       listofparents.Add(c); // add the card to a list so that they can be all added with a single DML statement (bypasses 150 DML statement governor limit)
//
/* 
       if (s.Addresses != null) {
           
        Integer i = 0;
        system.debug(s.Addresses);
        system.debug(s.Addresses.size());
        for (i=0; i < s.Addresses.size(); i++) {
//      Address__c a = new Address__c();
        SObject a = childType.newSObject();
        a.put('Name',string.valueof(s.Addresses[i].Location));
        a.put('Card__c',null);
        a.put('Index__c',s.Addresses[i].Location);    //1
        a.put('Street__c',s.Addresses[i].Street);   //
        a.put('City__c',s.Addresses[i].City); //
        a.put('State__c',s.Addresses[i].State);    //
        a.put('PostCode__c', s.Addresses[i].PostCode); //
        a.put('Country__c',s.Addresses[i].Country);  //
        a.put('Phone1__c',s.Addresses[i].Phone1);   //
        a.put('Phone2__c',s.Addresses[i].Phone2);   //
        a.put('Phone3__c',s.Addresses[i].Phone3);   //
        a.put('Fax__c',s.Addresses[i].Fax);  //
        a.put('Email__c', s.Addresses[i].Email);    //
        a.put('Website__c', s.Addresses[i].Website);  //
        a.put('ContactName__c',s.Addresses[i].ContactName);  //
        a.put('Salutation__c',s.Addresses[i].Salutation);   //
        a.put('Id', null);
        a.put('UID__c', s.UID + s.Addresses[i].Location);
//        if (a.Street__c !='' || a.City__c !='' || a.State__c !='' || a.PostCode__c !='' || a.Country__c !='' || a.Phone1__c !='' || a.Phone2__c !='' || 
//            a.Phone3__c !='' || a.Fax__c !='' || a.Email__c !='' || a.Website__c !='' || a.ContactName__c !='' || a.Salutation__c !='')
            {
            listofchildren.add(a);
            system.debug(a);
            }
        

        }
        }
*/
    }
//      add all cards in a single DML statement
 
        upsert (List<Card__c>)listofparents UID__c;
//      create a Map of MYOB UID to SF Id
    
        Map<String,Id> uidmap = new Map<String,Id>();
        for (Card__c c : (List<Card__c>)listofparents) { uidmap.put(c.UID__c,c.Id); }
//      system.debug(uidmap);
        
//        system.debug(listofcards.get(0).Id);
//      stuff address objects with the Id of the owning Card object
        for (Address__c a : (List<Address__c>)listofchildren) {
          a.Card__c = uidmap.get(a.UID__c.left(a.UID__c.length()-1));
          system.debug(a);
          }
        
        upsert (List<Address__c>)listofchildren UID__c;
   
}
}
