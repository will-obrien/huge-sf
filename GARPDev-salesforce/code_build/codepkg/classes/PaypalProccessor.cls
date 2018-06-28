public class PaypalProccessor{
public  string amount;
public  String result {set;get;}
public  string FirstName{get; set; }
public  string LastName{get; set; }
public  string Addy1{get; set; }
public  string Addy2{get; set; }
public  string Country{get; set; }
public  string CardType{get; set; }
public  string CardNo{get; set; }
public  string expMo{get; set; }
public  string expYe{get; set; }
public  string CVV{get; set; }
public  string city{get; set; }
public  string state{get; set; }
public  string zip{get; set; }
public  string payer{ get; set; }
public  string transid {get; set;}
public  string message {get; set; }
public  string err {get; set; }
public  string rawResponse {get; set; }

public PaypalProccessor(){
  city = '';
  state = '';
  zip = '';
  CVV = '';
  expYe = '';
  expMo = '';
  CardNo = '';
  CardType = 'Visa';
  FirstName = '';
  LastName = '';
  Country = 'US';
  Addy1 = '';
  Addy2 = '';
  payer = '';
  err = '';
  message = '';
}


public String doDirectPayment()
{ 
  
  Http h = new Http();
  HttpRequest req = new HttpRequest();
  String url = 'https://api-3t.sandbox.paypal.com/2.0/';
  string un = 'rob.cohen_api1.garp.com';
  string pw = '1396888252';
  string sig = 'AFcWxV21C7fd0v3bYYYRCpSSRl31A0UEIumLoG8JKpJcf-zAjLfgZKvj';
  
  
  String doDirectRequest;
  doDirectRequest =  '<soap:Envelope xmlns:soap=' + '\'' + 'http://schemas.xmlsoap.org/soap/envelope/'  + '\'' + ' xmlns:xsi=' + '\''+ 'http://www.w3.org/2001/XMLSchema-instance'  + '\'' + ' xmlns:xsd=' + '\''+ 'http://www.w3.org/2001/XMLSchema' + '\'' + '>';
  doDirectRequest += '<soap:Header><RequesterCredentials xmlns="urn:ebay:api:PayPalAPI"><Credentials xmlns="urn:ebay:apis:eBLBaseComponents">';
  doDirectRequest += '<Username>' + un + '</Username><ebl:Password xmlns:ebl="urn:ebay:apis:eBLBaseComponents">' + pw;
  doDirectRequest += '</ebl:Password><Signature>' + sig + '</Signature>';
  doDirectRequest += '</Credentials></RequesterCredentials></soap:Header><soap:Body><DoDirectPaymentReq xmlns="urn:ebay:api:PayPalAPI">';
  doDirectRequest += '<DoDirectPaymentRequest><Version xmlns="urn:ebay:apis:eBLBaseComponents">1.00</Version>';
  doDirectRequest += '<DoDirectPaymentRequestDetails xmlns="urn:ebay:apis:eBLBaseComponents">';
  doDirectRequest += '<PaymentAction>Sale</PaymentAction><PaymentDetails><OrderTotal currencyID="USD">' + amount + '</OrderTotal>';
  doDirectRequest += '<ShipToAddress><Name>' + FirstName + ' ' + LastName + '</Name><Street1>' + Addy1 + '</Street1><Street2>' +Addy2 + '</Street2>';
  doDirectRequest += '<CityName>' + city + '</CityName><StateOrProvince>' + state + '</StateOrProvince><PostalCode>' + zip + '</PostalCode>';
  doDirectRequest += '<Country>' + country + '</Country></ShipToAddress>';
  doDirectRequest += '</PaymentDetails><CreditCard><CreditCardType>' + CardType + '</CreditCardType><CreditCardNumber>' + CardNo + '</CreditCardNumber>';
  doDirectRequest += '<ExpMonth>' + expMo + '</ExpMonth><ExpYear>' + expYe + '</ExpYear><CardOwner><PayerStatus>verified</PayerStatus>';
  doDirectRequest += '<PayerName><FirstName>' + FirstName+ '</FirstName><LastName>' + LastName + '</LastName></PayerName><PayerCountry>' + country + '</PayerCountry>';
  doDirectRequest += '<Address><Street1>' + Addy1 + '</Street1><Street2>' + Addy2 + '</Street2><CityName>' + city + '</CityName>';
  doDirectRequest += '<StateOrProvince>' + state + '</StateOrProvince><Country>' + country + '</Country><PostalCode>' + zip + '</PostalCode></Address>';
  doDirectRequest += '</CardOwner><CVV2>' + CVV + '</CVV2></CreditCard></DoDirectPaymentRequestDetails>';
  doDirectRequest += '</DoDirectPaymentRequest></DoDirectPaymentReq></soap:Body></soap:Envelope>';
  
  req.setBody(doDirectRequest);
  
  req.setEndpoint(url);
  req.setMethod('POST');
  req.setHeader('Content-length', '1753' );
  req.setHeader('Content-Type', 'text/xml;charset=UTF-8'); 
  req.setHeader('SOAPAction','');
  req.setHeader('Host','api-aa.sandbox.paypal.com');
  HttpResponse res = h.send(req);
  String xml = res.getBody();
  rawResponse = xml;
  system.debug('::' + rawResponse);
  XmlStreamReader reader = res.getXmlStreamReader();
  result = readXMLResponse(reader,'Ack');
  reader = res.getXmlStreamReader();
  err = readXMLResponse(reader, 'LongMessage');
  
  if (result == 'Success')
  {
    reader = res.getXmlStreamReader();
    transid = readXMLResponse(reader, 'TransactionID'); 
      system.debug('::' + transid ); 
  }
  else
  {
    result = err;
  }
  return result;
}

public String readXMLResponse(XmlStreamReader reader, String sxmltag)
{
  string retValue; // Read through the XML
  while(reader.hasNext())
  {
    if (reader.getEventType() == XmlTag.START_ELEMENT)
    {
      if (reader.getLocalName() == sxmltag) {
        reader.next();
        if (reader.getEventType() == XmlTag.characters)
        {
          retValue = reader.getText();
        }
      }
    }
    reader.next();
  }
  return retValue;
}

public String pay(){
  
  err = '';
  if (FirstName == '')
    err = err + 'You must enter a First Name.\n';
  if (LastName == '')
    err = err + 'You must enter a Last Name.\n';
  if (Addy1 == '')
    err = err + 'You must enter an Address.\n';
  if (city == '')
    err = err + 'You must enter a City.\n';
  if (state == '')
    err = err + 'You must enter a State.\n';
  if (zip == '')
    err = err + 'You must enter a Zip.\n';
  if (CardNo == '')
    err = err + 'You must enter a Credit Card Number.\n';
  if (expMo.length() != 2)
    err = err + 'Expiration month must be in the format MM.\n';
  if (expYe.length() != 4) 
    err = err + 'Expiration year must be in the format YYYY.\n';
    
  if (amount == '0')
  {
    err += 'Amount 0 can not process.\n';
    message = err;
  }  
  message = err;
  if (err == '')
  {
    message = doDirectPayment();
  }
  
  if (message == 'Success')
  {
    
  }
  else
  {
    //pr = null;
  }
  return message;
}

}