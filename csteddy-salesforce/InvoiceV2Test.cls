@istest
public class InvoiceV2Test {
static testMethod void testParse() {
        String json=        '{'+
        '      "UID": "3777ee08-7ede-4db3-81e7-8fd12e4c0975",'+
        '      "Number": "00007040",'+
        '      "Date": "2012-10-11T00:00:00",'+
        '      "CustomerPurchaseOrderNumber": "09696",'+
        '      "Customer": {'+
        '        "UID": "e73afa56-7643-492b-a5c4-8e8f8bb3f99a",'+
        '        "Name": "The Owner - 1001 Clarke Street OConnor",'+
        '        "URI": "https://api.myob.com/accountright/84f38c5b-82a0-ffff-9ad8-6c38b177a0ed/Contact/Customer/e73afa56-7643-492b-a5c4-8e8f8bb3f99a"'+
        '      },'+
        '      "PromisedDate": null,'+
        '      "BalanceDueAmount": 0.000000,'+
        '      "Status": "Closed",'+
        '      "Lines": ['+
        '        {'+
        '          "RowID": 25996,'+
        '          "Type": "Transaction",'+
        '          "Description": "Garden works as per auth. ",'+
        '          "Total": 1780.900000,'+
        '          "Account": {'+
        '            "UID": "3e86a4c1-8207-4313-a389-f18dda6095b5",'+
        '            "Name": "Contract Income",'+
        '            "DisplayID": "4-2300",'+
        '            "URI": "https://api.myob.com/accountright/84f38c5b-82a0-ffff-9ad8-6c38b177a0ed/GeneralLedger/Account/3e86a4c1-8207-4313-a389-f18dda6095b5"'+
        '          },'+
        '          "Job": null,'+
        '          "TaxCode": {'+
        '            "UID": "bb3c40b0-d27b-4075-9759-6c5aa1c9abce",'+
        '            "Code": "GST",'+
        '            "URI": "https://api.myob.com/accountright/84f38c5b-82a0-ffff-9ad8-6c38b177a0ed/GeneralLedger/TaxCode/bb3c40b0-d27b-4075-9759-6c5aa1c9abce"'+
        '          },'+
        '          "RowVersion": "-977839671046307840"'+
        '        },'+
        '        {'+
        '          "RowID": 25997,'+
        '          "Type": "Transaction",'+
        '          "Description": "Supply and application of mulch",'+
        '          "Total": 1758.900000,'+
        '          "Account": {'+
        '            "UID": "40ca4f8d-0773-463e-912d-dc72c1e3b18e",'+
        '            "Name": "Mulch",'+
        '            "DisplayID": "4-2350",'+
        '            "URI": "https://api.myob.com/accountright/84f38c5b-82a0-ffff-9ad8-6c38b177a0ed/GeneralLedger/Account/40ca4f8d-0773-463e-912d-dc72c1e3b18e"'+
        '          },'+
        '          "Job": null,'+
        '          "TaxCode": {'+
        '            "UID": "bb3c40b0-d27b-4075-9759-6c5aa1c9abce",'+
        '            "Code": "GST",'+
        '            "URI": "https://api.myob.com/accountright/84f38c5b-82a0-ffff-9ad8-6c38b177a0ed/GeneralLedger/TaxCode/bb3c40b0-d27b-4075-9759-6c5aa1c9abce"'+
        '          },'+
        '          "RowVersion": "-905782077008379904"'+
        '        },'+
        '        {'+
        '          "RowID": 25998,'+
        '          "Type": "Transaction",'+
        '          "Description": "Removal of green waste",'+
        '          "Total": 450.000000,'+
        '          "Account": {'+
        '            "UID": "3a2bec9c-6f6b-4d2b-aaee-5b3b0681ea33",'+
        '            "Name": "Waste removal",'+
        '            "DisplayID": "4-2370",'+
        '            "URI": "https://api.myob.com/accountright/84f38c5b-82a0-ffff-9ad8-6c38b177a0ed/GeneralLedger/Account/3a2bec9c-6f6b-4d2b-aaee-5b3b0681ea33"'+
        '          },'+
        '          "Job": null,'+
        '          "TaxCode": {'+
        '            "UID": "bb3c40b0-d27b-4075-9759-6c5aa1c9abce",'+
        '            "Code": "GST",'+
        '            "URI": "https://api.myob.com/accountright/84f38c5b-82a0-ffff-9ad8-6c38b177a0ed/GeneralLedger/TaxCode/bb3c40b0-d27b-4075-9759-6c5aa1c9abce"'+
        '          },'+
        '          "RowVersion": "-833724482970451968"'+
        '        },'+
        '        {'+
        '          "RowID": 26000,'+
        '          "Type": "Transaction",'+
        '          "Description": "Supply and application of chemical",'+
        '          "Total": 68.180000,'+
        '          "Account": {'+
        '            "UID": "6728df32-64b2-4d3e-826a-3a66e340136e",'+
        '            "Name": "Chemical",'+
        '            "DisplayID": "4-2330",'+
        '            "URI": "https://api.myob.com/accountright/84f38c5b-82a0-ffff-9ad8-6c38b177a0ed/GeneralLedger/Account/6728df32-64b2-4d3e-826a-3a66e340136e"'+
        '          },'+
        '          "Job": null,'+
        '          "TaxCode": {'+
        '            "UID": "bb3c40b0-d27b-4075-9759-6c5aa1c9abce",'+
        '            "Code": "GST",'+
        '            "URI": "https://api.myob.com/accountright/84f38c5b-82a0-ffff-9ad8-6c38b177a0ed/GeneralLedger/TaxCode/bb3c40b0-d27b-4075-9759-6c5aa1c9abce"'+
        '          },'+
        '          "RowVersion": "-761666888932524032"'+
        '        }'+
        '      ],'+
        '      "ShipToAddress": "The Owner - 1001 Clarke Street OConnor\r\nC/- Jones and Jones\r\nLevel 72 Central Park\r\n152-158 St Georges Terrace\r\nPerth  WA  6000",'+
        '      "Terms": {'+
        '        "PaymentIsDue": "InAGivenNumberOfDays",'+
        '        "DiscountDate": 0,'+
        '        "BalanceDueDate": 30,'+
        '        "DiscountForEarlyPayment": 0.0,'+
        '        "MonthlyChargeForLatePayment": 0.0'+
        '      },'+
        '      "IsTaxInclusive": true,'+
        '      "Subtotal": 4057.980000,'+
        '      "Freight": 0.000000,'+
        '      "FreightTaxCode": {'+
        '        "UID": "bb3c40b0-d27b-4075-9759-6c5aa1c9abce",'+
        '        "Code": "GST",'+
        '        "URI": "https://api.myob.com/accountright/84f38c5b-82a0-ffff-9ad8-6c38b177a0ed/GeneralLedger/TaxCode/bb3c40b0-d27b-4075-9759-6c5aa1c9abce"'+
        '      },'+
        '      "TotalTax": 368.910000,'+
        '      "TotalAmount": 4057.980000,'+
        '      "Salesperson": null,'+
        '      "Comment": "",'+
        '      "ShippingMethod": null,'+
        '      "JournalMemo": "Sale; The Owner - 1001 Clarke Street OConnor",'+
        '      "ReferralSource": null,'+
        '      "InvoiceDeliveryStatus": "Nothing",'+
        '      "URI": "https://api.myob.com/accountright/84f38c5b-82a0-4213-9ad8-6c38b177a0ed/Sale/Invoice/Service/3777ee08-7ede-4db3-81e7-8fd12e4c0975",'+
        '      "RowVersion": "6624516875420172288"'+
        '    }';
 //       InvoiceV2 obj = parse(json);
 //       System.assert(obj != null);
    }
 }
