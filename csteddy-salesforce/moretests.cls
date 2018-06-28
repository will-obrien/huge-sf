@istest
public class moretests {
public static testmethod void testErrorParsing() {
/*
    The body of the response from the MYOB API endpoint contains a JSON string.
    If there is a error in the request (say a Status Code of 400) then the JSON string returned will be of the form
    below. The "Name" token describes the API field in error. eg. BuyingDetails.PurchaseLayout 
    is null (which is seemingly not permitted). The  attribute validation errors can be for multiple fields.
    (I haven't seen the API message or errorcode fields returned with any values yet).  
    We  need to map field.name -> field_name__c (SF API field name) 
    The SF API field name is limited to 40 characters (not including the  __c suffix).
    The length of some MYOB attribute names exceeds 40 characters so the SF field name will need to be truncated.
    Hopefully all MYOB attribute names will be unique to 40 characters.

    The controller should use the adderror method for any fields that are identified by the API.
    This is so that the VF page MYOBCard highlights the fields in error for the user.

{
  "Errors": [
    {
      "Name": "instance.BuyingDetails.PurchaseLayout",
      "Message": "",
      "AdditionalDetails": null,
      "ErrorCode": 0
    },
    {
      "Name": "instance.BuyingDetails.PurchaseOrderDelivery",
      "Message": "",
      "AdditionalDetails": null,
      "ErrorCode": 0
    }
  ],
  "Information": "Warning, error messages have not been finalised in this release and may change"
}
*/


string errstr = '{ "Errors": [ { "Name": "instance.BuyingDetails.PurchaseLayout", "Message": "", "AdditionalDetails": null, "ErrorCode": 0 }, { "Name": "instance.BuyingDetails.PurchaseOrderDelivery", "Message": "", "AdditionalDetails": null, "ErrorCode": 0 } ], "Information": "Warning, error messages have not been finalised in this release and may change"}';

}
}
