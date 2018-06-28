//Makes the webservice call and validates the Address
public class AddressService {
    
    public class AddressServiceResult {
      public Boolean isValid {get;set;}
      public String statusCode {get;set;}
      public List<rC_Bios__Address__c> addressOutput {get;set;}
      public String errorMessage {get;set;}
      
      public AddressServiceResult(){
        this.isValid = true;
        this.addressOutput = new List<rC_Bios__Address__c>();
      }
    }
    
    
 //Parse the result and add to the list.
  public static List<rC_Bios__Address__c> populateAddresses(string resultBody){
    List<rC_Bios__Address__c> verifiedAddressList = new List<rC_Bios__Address__c>();
    while(resultBody.contains('<country>')){
      rC_Bios__Address__c verifiedAddress = new rC_Bios__Address__c();

      verifiedAddress.rC_Bios__Street_Line_1__c = resultBody.substring(resultBody.indexof('<streetadr>')+11,resultBody.indexof('</streetadr>'));
      resultBody = resultBody.substring(resultBody.indexof('</streetadr>')+12);


      verifiedAddress.rC_Bios__Street_Line_2__c = resultBody.substring(resultBody.indexof('<suppadr>')+9,resultBody.indexof('</suppadr>'));
      resultBody = resultBody.substring(resultBody.indexof('</suppadr>')+10);

      verifiedAddress.rC_Bios__City__c = resultBody.substring(resultBody.indexof('<city>')+6,resultBody.indexof('</city>'));
      resultBody = resultBody.substring(resultBody.indexof('</city>')+7);

      verifiedAddress.rC_Bios__State__c = resultBody.substring(resultBody.indexof('<state>')+7,resultBody.indexof('</state>'));
      resultBody = resultBody.substring(resultBody.indexof('</state>')+8);

      verifiedAddress.rC_Bios__ZIP__c = resultBody.substring(resultBody.indexof('<zipcode>')+9,resultBody.indexof('</zipcode>'));
      resultBody = resultBody.substring(resultBody.indexof('</zipcode>')+10);

      verifiedAddress.rC_Bios__Country__c = resultBody.substring(resultBody.indexof('<country>')+9,resultBody.indexof('</country>'));
      resultBody = resultBody.substring(resultBody.indexof('</country>')+10);

      //verifiedAddress.listIndex = verifiedAddressesList.size();
      verifiedAddressList.add(verifiedAddress);
    }
    return verifiedAddressList;
  }
    
    public static AddressServiceResult Validate(rC_Bios__Address__c addressInput) {
      HttpRequest req = new HttpRequest();
    HttpResponse res = new HttpResponse();
    
    Http http = new Http();
    String payload = getPayload(addressInput);
    
    req.setEndpoint('https://www.neodata.com/ITPS2.cgi?' + payload);
    req.setMethod('GET');
    
    // Changed by virendra to increase the timeout in case to avoid for  invalid address response expection
    req.setTimeout(2000); // timeout in milliseconds
    
    req.setCompressed(true); 
    
    AddressServiceResult result = new AddressServiceResult();
    
    try {
          res = http.send(req);
                    system.debug('res :::: ' + res.getBody());

          if (res.getBody().indexOf('Your transaction could not be processed') > 0 ) {
            result.isValid = false;
            result.addressOutput.add(addressInput);
            
              }
              else{
                result.addressOutput = populateAddresses(res.getBody());
              }
            result.statusCode = res.getStatus();
      } catch(System.CalloutException e) {result.isValid = false; result.statusCode = res.getStatus();
      }
    System.debug('@@@@ result : ' + result);
    return result;  
    }
    
    
    public static AddressServiceResult validateForTest(rC_Bios__Address__c addressInput,Boolean isValid,Boolean isServiceDown) {
        
        AddressServiceResult result = new AddressServiceResult();
        TestDataUtility testData = new TestDataUtility();
        
        if(isServiceDown){
            result.isValid = false;
            result.statusCode = '503';
            return result;
        }
        
        if(isValid){
            result.isValid = true;
            result.statusCode = '200';
            result.addressOutput.add(testData.createNewInvalidAddress(false));
        }else{
            result.isValid = false;
            result.statusCode = '200';
            result.addressOutput.add(testData.createNewInvalidAddress(false)); 
        }
        return result;  
    }
        
        public static String getPayLoad(rC_Bios__Address__c addressInput){
          String encoded = 'OrderType=' + EncodingUtil.urlEncode('Address Hygiene', 'UTF-8');
               encoded += '&ItemCode=itps';
               encoded += '&DoAddressHygiene=on';
               encoded += '&iResponse=SCMS.hygiene';
               encoded += '&FullName=Resident';
               encoded += '&StreetAdr=' + EncodingUtil.urlEncode(addressInput.rC_Bios__Street_Line_1__c, 'UTF-8');
        
        if(addressInput.rC_Bios__Street_Line_2__c != null && addressInput.rC_Bios__Street_Line_2__c != ''){
         encoded += '&SuppAdr=' + EncodingUtil.urlEncode(addressInput.rC_Bios__Street_Line_2__c, 'UTF-8');
        }
        String city = String.isEmpty(addressInput.rC_Bios__City__c) ? 'x': addressInput.rC_Bios__City__c;
        encoded += '&City=' + EncodingUtil.urlEncode(city, 'UTF-8');
        encoded += '&State=' + EncodingUtil.urlEncode(addressInput.rC_Bios__State__c, 'UTF-8');
         
        String postalCode = String.isEmpty(addressInput.rC_Bios__ZIP__c) ? '':addressInput.rC_Bios__ZIP__c;
        
        while(postalCode.length() < 5){
           postalCode += '9';
        }
        encoded += '&PostalCode=' + EncodingUtil.urlEncode(postalCode, 'UTF-8');
        encoded += '&Country=' + EncodingUtil.urlEncode(addressInput.rC_Bios__Country__c, 'UTF-8');
    
        return encoded;
    }
    
}