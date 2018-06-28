public class endPoint{

private static boolean retry = false;

    public static String callEndPoint(String apiVersion,String method,String body,String suffix) {
 
// Do we have an authorised token for this service
// If not the OAuth initialisation has not been done
// Need to notify System Administrator

  
            
      
// Build HTTP request object and stuff headers
        HTTPRequest req = MYOBrequest.header(apiVersion,method,body,suffix);
        Http http = new Http();
        HTTPResponse res = new HTTPResponse();
// Don't do callout to the endpoint if we're running a test
        if (!Test.isRunningTest()) {
            res  = http.send(req);
        }
        else
            res.setStatusCode(401); //fake a refresh required if we're testing
// If we're all good then return the body of the response        
        if (res.getStatusCode() == 200) {
            return res.getBody();
        }
        else
        if (res.getStatusCode() == 201) {
        
//201 = Created (successful POST), URI returned in location key response header value
           return('{ "URI" : "'+responseHeader.get(res,'Location')+'" }');
           }
        else 
        if (res.getStatusCode() == 401) {
//401 = Unauthorized (expired token or maybe file username/password failure)  {"Message": "Access denied"}
        if (retry) {
            retry = false;
            system.debug('Token refresh failed');
            return res.getStatusCode()+' '+res.getStatus()+' '+res.getBody();
            }
        system.debug('Refresh token');
        token.refresh();
        retry = true;
        String response = endpoint.callEndPoint(apiVersion,method,body,suffix);
        usertoken.write();
        retry = false;
        return response;
         }       
//400 = Bad Request

//404 = Status=Not Found (on a PUT for a non-existent record) - i think more generally endpoint not found
//500 = Server Error
//409  Status=Conflict check msg (e.g. Invalid RowVersion: An Update operation requires a valid RowVersion from the current entity being modified.")
        {
        system.debug(res.getBody());
// Check if we have an authorisation failure
// If so, the OAuth token may have expired and we might need to refresh it
        }
        return res.getBody();
}
    @future(callout=true)
    public static void fireandforget(String data){
      system.debug('Inserted JSON data = '+data);
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
*/
//        string data1 = '{"CompanyName" : "TEST Company 24","IsActive" : true,"ABN" : null,"PurchaseLayoutId" : "Service","CreditLimit" : 0,"PrintedForm" : null,"VolumeDiscount" : 0,"TaxIdNumber" : null,"CustomFields" : null,"ShippingMethod" : null,"DisplayId" : "CARDTEST24","Memo" : null,"PurchaseComment" : null,"CustomLists" : null,"CostPerHour" : 0,"CurrentBalance" : 0,"UseSupplierTaxCode" : false,"IsIndividual" : false,"TermsId" : null,"IsReportable" : false,"FreightTaxCode" : {"Code" : "GST","UID": "177b15f3-d01c-452c-a4ae-d218903a1f42"},"ABNBranch" : null,"ExpenseAccountId" : null,"FirstName" : null,"TaxCode" : {"Code" : "GST","UID": "177b15f3-d01c-452c-a4ae-d218903a1f42"},"HourlyBillingRate" : 0,"Description" : "dfd","Tags" : "A" }';
        string data1 = '{ "DisplayId": "GWX000104", "BuyingDetails" : { "TaxCode" : {"Code" : "GST","UID": "177b15f3-d01c-452c-a4ae-d218903a1f42"}, "FreightTaxCode" : {"Code" : "GST","UID": "177b15f3-d01c-452c-a4ae-d218903a1f42"}}, "CompanyName": "GWX Team 104", "IsActive": true, "IsIndividual" : false }';
        String cardID = '';
//   If called with no data then use test JSON string
        if (data != null && data !='') data1 = data;
        String allsup = endpoint.callEndPoint('v2','POST',data1,'/Contact/Supplier');
        System.debug(allsup);
    }
}
