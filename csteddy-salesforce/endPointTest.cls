@istest (seeAllData=true) //seeAllData is required for Custom Settings which cannot be created via Apex
public class endPointTest{

    static testMethod void callEndPointTest() {
    string data1 = '{ "DisplayId": "GWX000104", "BuyingDetails" : { "TaxCode" : {"Code" : "GST","UID": "177b15f3-d01c-452c-a4ae-d218903a1f42"}, "FreightTaxCode" : {"Code" : "GST","UID": "177b15f3-d01c-452c-a4ae-d218903a1f42"}}, "CompanyName": "GWX Team 104", "IsActive": true, "IsIndividual" : false }';
    endpoint.callEndPoint('v2', 'POST', data1,'/Contact/Supplier');

    endpoint.fireandforget(data1);
    endpoint.fireandforget('');
    
/*
"CompanyName" : "Cash Purchases",
"IsIndividual" : false,
"DisplayID" : "SUP00001",
"IsActive" : true,
"CurrentBalance" : 1000,
"Notes" : "Description for Cash Purchase",
"ABN" : "45 676 343 223",
"ABNBranch" : "014",
"TaxIdNumber" : null,
"UseSupplierTaxCode" : true,

//        string data1 = '{"CompanyName" : "TEST Company 24","IsActive" : true,"ABN" : null,"PurchaseLayoutId" : "Service","CreditLimit" : 0,"PrintedForm" : null,"VolumeDiscount" : 0,"TaxIdNumber" : null,"CustomFields" : null,"ShippingMethod" : null,"DisplayId" : "CARDTEST24","Memo" : null,"PurchaseComment" : null,"CustomLists" : null,"CostPerHour" : 0,"CurrentBalance" : 0,"UseSupplierTaxCode" : false,"IsIndividual" : false,"TermsId" : null,"IsReportable" : false,"FreightTaxCode" : {"Code" : "GST","UID": "177b15f3-d01c-452c-a4ae-d218903a1f42"},"ABNBranch" : null,"ExpenseAccountId" : null,"FirstName" : null,"TaxCode" : {"Code" : "GST","UID": "177b15f3-d01c-452c-a4ae-d218903a1f42"},"HourlyBillingRate" : 0,"Description" : "dfd","Tags" : "A" }';
        string data1 = '{ "DisplayId": "GWX000104", "BuyingDetails" : { "TaxCode" : {"Code" : "GST","UID": "177b15f3-d01c-452c-a4ae-d218903a1f42"}, "FreightTaxCode" : {"Code" : "GST","UID": "177b15f3-d01c-452c-a4ae-d218903a1f42"}}, "CompanyName": "GWX Team 104", "IsActive": true, "IsIndividual" : false }';
        String cardID = '';
//   If called with no data then use test JSON string
        if (data != null && data !='') data1 = data;
        String allsup = endpoint.callEndPoint('v2','POST',data1,'/Contact/Supplier');
        System.debug(allsup);
*/
    }
}
