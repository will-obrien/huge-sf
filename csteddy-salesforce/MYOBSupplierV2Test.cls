@istest
public class MYOBSupplierV2Test {

static testMethod void testParse() {
        String json=        '{'+
        '      "UID": "9ef4e1e3-0b67-4bab-a459-9e411b86976d",'+
        '      "CompanyName": "Cash Purchases",'+
        '      "IsIndividual": false,'+
        '      "DisplayID": "SUPP000001",'+
        '      "IsActive": true,'+
        '      "Addresses": ['+
        '        {'+
        '          "Location": 1,'+
        '          "Street": "",'+
        '          "City": "",'+
        '          "State": "",'+
        '          "PostCode": "",'+
        '          "Country": "",'+
        '          "Phone1": "",'+
        '          "Phone2": "",'+
        '          "Phone3": "",'+
        '          "Fax": "",'+
        '          "Email": "",'+
        '          "Website": "",'+
        '          "ContactName": "",'+
        '          "Salutation": ""'+
        '        }'+
        '      ],'+
        '      "Notes": "Test update",'+
        '      "Identifiers": ['+
        '        {'+
        '          "Label": "",'+
        '          "Value": "A"'+
        '        },'+
        '        {'+
        '          "Label": "",'+
        '          "Value": "M"'+
        '        },'+
        '        {'+
        '          "Label": "",'+
        '          "Value": "C"'+
        '        }'+
        '      ],'+
        '      "CustomList1": {'+
        '        "Label": "Custom List #1",'+
        '        "Value": "Test Custom List"'+
        '      },'+
        '      "CustomList2": {'+
        '        "Label": "Custom List #2",'+
        '        "Value": "List Number 2"'+
        '      },'+
        '      "CustomList3": null,'+
        '      "CustomField1": {'+
        '        "Label": "Custom Field #1",'+
        '        "Value": "Test Custom Field 1"'+
        '      },'+
        '      "CustomField2": {'+
        '        "Label": "Custom Field #2",'+
        '        "Value": "Test Custom Field 2"'+
        '      },'+
        '      "CustomField3": {'+
        '        "Label": "Custom Field #3",'+
        '        "Value": "Test Custom Field 3"'+
        '      },'+
        '      "CurrentBalance": 0.000000,'+
        '      "BuyingDetails": {'+
        '        "PurchaseLayout": "NoDefault",'+
        '        "PrintedForm": "",'+
        '        "PurchaseOrderDelivery": "Print",'+
        '        "ExpenseAccount": {'+
        '          "UID": "f1e8b80a-d886-43d0-949a-a60327bc30d1",'+
        '          "Name": "Other Operating Expenses",'+
        '          "DisplayID": "6-2150",'+
        '          "URI": "https://api.myob.com/accountright/073def5d-d1cf-ffff-9828-e440aadbbfe0/GeneralLedger/Account/f1e8b80a-d886-43d0-949a-a60327bc30d1"'+
        '        },'+
        '        "PaymentMemo": "",'+
        '        "PurchaseComment": null,'+
        '        "SupplierBillingRate": 0.000000,'+
        '        "ShippingMethod": null,'+
        '        "IsReportable": false,'+
        '        "CostPerHour": 0.000000,'+
        '        "Credit": {'+
        '          "CLimit": 0.000000,'+
        '          "Available": 0.000000,'+
        '          "PastDue": 0.0'+
        '        },'+
        '        "ABN": "",'+
        '        "ABNBranch": "",'+
        '        "TaxIdNumber": "",'+
        '        "TaxCode": {'+
        '          "UID": "177b15f3-d01c-452c-a4ae-d218903a1f42",'+
        '          "Code": "GST",'+
        '          "URI": "https://api.myob.com/accountright/073def5d-d1cf-ffff-9828-e440aadbbfe0/GeneralLedger/TaxCode/177b15f3-d01c-452c-a4ae-d218903a1f42"'+
        '        },'+
        '        "FreightTaxCode": {'+
        '          "UID": "177b15f3-d01c-452c-a4ae-d218903a1f42",'+
        '          "Code": "GST",'+
        '          "URI": "https://api.myob.com/accountright/073def5d-d1cf-ffff-9828-e440aadbbfe0/GeneralLedger/TaxCode/177b15f3-d01c-452c-a4ae-d218903a1f42"'+
        '        },'+
        '        "UseSupplierTaxCode": true,'+
        '        "Terms": {'+
        '          "PaymentIsDue": "DayOfMonthAfterEOM",'+
        '          "DiscountDate": 1,'+
        '          "BalanceDueDate": 30,'+
        '          "DiscountForEarlyPayment": 0.0,'+
        '          "VolumeDiscount": 0.0'+
        '        }'+
        '      },'+
        '      "PaymentDetails": {'+
        '        "BSBNumber": "",'+
        '        "BankAccountNumber": "",'+
        '        "BankAccountName": "",'+
        '        "StatementText": "",'+
        '        "Refund": null'+
        '      },'+
        '      "PhotoURI": null,'+
        '      "URI": "https://api.myob.com/accountright/073def5d-d1cf-ffff-9828-e440aadbbfe0/Contact/Supplier/9ef4e1e3-0b67-4bab-a459-9e411b86976d",'+
        '      "RowVersion": "8551491267446439936"'+
        '    }';
        
        MYOBSupplierV2 obj = MYOBSupplierV2.parse(json);
//       MYOBSupplierV2 obj = (MYOBSupplierV2) System.JSON.deserialize(json, MYOBSupplierV2.class);
        
// All object fields must be referenced to get code coverage for the class

        MYOBSupplierV2 o = new MYOBSupplierV2();
        o.CustomList1 = new MYOBSupplierV2.cls_CustomList1();
        o.CustomList1.label = 'List Name 1';
        o.CustomList1.value = 'List Value 1';
        o.CustomList2 = new MYOBSupplierV2.cls_CustomList2();
        o.CustomList2.label = 'List Name 2';
        o.CustomList2.value = 'List Value 2';
        o.CustomList3 = new MYOBSupplierV2.cls_CustomList3();
        o.CustomList3.label = 'List Name 3';
        o.CustomList3.value = 'List Value 3';
        o.CustomField1 = new MYOBSupplierV2.cls_CustomField1();
        o.CustomField1.label = 'Field Name 1';
        o.CustomField1.value = 'Field Value 1';
        o.CustomField2 = new MYOBSupplierV2.cls_CustomField2();
        o.CustomField2.label = 'Field Name 2';
        o.CustomField2.value = 'Field Value 2';
        o.CustomField3 = new MYOBSupplierV2.cls_CustomField3();
        o.CustomField3.label = 'Field Name 3';
        o.CustomField3.value = 'Field Value 3';
        o.BuyingDetails = new MYOBSupplierV2.cls_BuyingDetails();
        o.BuyingDetails.ExpenseAccount = new MYOBSupplierV2.cls_ExpenseAccount();
        o.BuyingDetails.Credit = new MYOBSupplierV2.cls_Credit();
        o.BuyingDetails.TaxCode = new MYOBSupplierV2.cls_TaxCode();
        o.BuyingDetails.FreightTaxCode = new MYOBSupplierV2.cls_FreightTaxCode();
        o.BuyingDetails.Terms = new MYOBSupplierV2.cls_Terms();
        o.PaymentDetails = new MYOBSupplierV2.cls_PaymentDetails();
        o.Refund = new MYOBSupplierV2.cls_Refund();
        o.UID = '9ef4e1e3-0b67-4bab-a459-9e411b86976d';
        o.CompanyName = 'Cash Purchases';
//      o.Identifiers[0] = new MYOBSupplierV2.cls_Identifiers();
//      o.Addresses[0] = new MYOBSupplierV2.cls_Addresses();
//      o.Addresses[0].Location = 1;
        o.PaymentDetails.BSBNumber='013-645';

        System.assert(obj.RowVersion == '8551491267446439936');
        System.debug(obj.RowVersion);
        System.debug(obj);
        System.assert(obj != null);
        
        
        Card__c c = new Card__c(CompanyName__c='Fred', IsActive__c=true, IsIndividual__c = false, Name='Fred');
        
    }
    }
