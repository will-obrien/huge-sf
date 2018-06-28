// this utility class is invoked from CreateIntermediateCertController
// whenever the user clicks on the Create Intermediate Cert Button from root cert or owner cert
// they provide the PEM info on a screen
// this info is sent to the cert checker webservice and the response is mapped to several fields on the account record
public class X509CertificateCheckerUtility {


 public static Account x509CertChecker(String pemInfoStr)
 {
   
    Account tempAccountSo;
    
      
      // create new HTTP request 
      HttpRequest request = new HttpRequest();
      // set the endpoint
      request.setEndpoint('http://cert-checker.allizom.org/jx509'); // production site
      // request.setEndpoint('http://cert-checker.allizom.org/jx509-devel'); // test site

      request.setMethod('POST');
      
      // set the certificate info as the request body 
     // request.setBody(accountSo.X_509_Certificate_PEM__c);
      request.setBody(pemInfoStr);
      HttpResponse responseStr;
      // invoke the webservice and get the response
      if(!test.isRunningtest())
      {
       responseStr = (new Http()).send(request);
      }
      else
      {
      responseStr = new HttpResponse ();
      // responseStr.setBody('{"issuerCN":"DigiCert Trusted Root G4","issuerOU":"www.digicert.com","issuerO":"DigiCert Inc","issuerC":"US","subjectCN":"DigiCert Trusted Server CA G4","subjectOU":null,"subjectO":"DigiCert Inc","subjectC":"US","sha1Fingerprint":"876217035658b958f359fba589d630c4042d961b","sha256Fingerprint":"6e8d952fdbabad8de3d61e094393739b5a47371a52bdcb2a3c2f8c43622f640f","notBefore":"Thu, 01 Aug 2013 12:00:00 GMT","notAfter":"Tue, 01 Aug 2028 12:00:00 GMT","version":3,"serialNumber":"03637e538cfd86e1603527d6f2b80ff4","signatureAlgorithm":"sha384WithRSAEncryption","publicKeySize":4096,"publicKeyPublicExponent":65537,"basicConstraints":"cA: true, pathLenConstraint: 0","keyUsage":"digitalSignature, keyCertSign, cRLSign","extKeyUsage":"(not present)","ocsp":"http://ocsp.digicert.com","crl":"http://crl4.digicert.com/DigiCertTrustedRootG4.crl"}');
      responseStr.setBody('{"issuerCN":"Sample Issuer CN","issuerOU":"Sample Issuer OU","issuerO":"Sample Issuer O","issuerC":"Sample Issuer C","subjectCN":"Sample Subject CN","subjectOU":null,"subjectO":"Sample Subject O","subjectC":"Sample Subject C","sha1Fingerprint":"876217035658b958f359fba589d630c4042d961b","sha256Fingerprint":"6e8d952fdbabad8de3d61e094393739b5a47371a52bdcb2a3c2f8c43622f640f","notBefore":"Thu, 01 Aug 2013 12:00:00 GMT","notAfter":"Tue, 01 Aug 2028 12:00:00 GMT","version":3,"serialNumber":"03637e538cfd86e1603527d6f2b80ff4","signatureAlgorithm":"sha384WithRSAEncryption","publicKeySize":4096,"publicKeyPublicExponent":65537,"basicConstraints":"cA: true, pathLenConstraint: 0","keyUsage":"digitalSignature, keyCertSign, cRLSign","extKeyUsage":"(not present)","ocsp":"http:sample.company.com","crl":"http://sample.company.com/root.crl","technicallyConstrained":"no"}');
  
      }
      
      
       CertCheckerResponseJSON resp;
      if(responseStr.getStatusCode()==200 || test.isRunningTest())
      {
      // set the extraction results and turn off the warning message that is displayed when the process begins      
      tempAccountSo = New Account(Extraction_Results__c=responseStr.getBody(),Display_Warning_or_Message__c =false);
       // Parse JSON response to get all the totalPrice field values.
        //JSONParser parser = JSON.createParser(responseStr.getBody());
        resp = (CertCheckerResponseJSON) (JSON.deserialize(responseStr.getBody(),CertCheckerResponseJSON.class));
     
      }
      else
      {
       tempAccountSo = New Account(Extraction_Results__c='WebService Unavailable. Please try again later.',Display_Warning_or_Message__c =false,Display_Webservice_Not_Available__c=true);
      }  
      
      // if the response is not null
      // map the response to the fields on the account object
      if(resp!=null)
      {
      
      // prepare a map where key is the string value of month and 
      // value is the integer value of the month
      // we need this to parse the valid from and valid to dates
      Map <String,Integer> dateMap = New Map<String,Integer>{
        'Jan' => 1, 'Feb' => 2,'Mar' => 3, 'Apr' => 4, 'May' => 5, 'Jun' => 6,
        'Jul' => 7, 'Aug' => 8, 'Sep' => 9, 'Oct' => 10, 'Nov'  => 11, 'Dec'  => 12};



        // if(resp.errors!=null && resp.errors.size() > 0 || (resp.issuerCN==null && resp.issuerOU==null && resp.issuerO==null 
        //                                                   && resp.subjectCN==null && resp.subjectOU==null && resp.subjectO==null
        //                                                   )
        //  )
          
        if(resp.errors!=null && resp.errors.size() > 0)
        {

          tempAccountSo.Display_Webservice_Failed_Message__c = true;
        }
        
        tempAccountSo.Certificate_Issuer_Common_Name__c = resp.issuerCN ;
        tempAccountSo.Certificate_Issuer_Organizational_Unit__c = resp.issuerOU ;
        tempAccountSo.Certificate_Issuer_Organization__c = resp.issuerO;
        tempAccountSo.Certificate_Subject_Common_Name__c = resp.subjectCN ;
        
        tempAccountSo.name = resp.subjectCN == null ? '<Fill in Intermediate Cert Name>' : resp.subjectCN;
        tempAccountSo.Certificate_Subject_Organization_Unit__c = resp.subjectOU;
        tempAccountSo.Certificate_Subject_Organization__c = resp.subjectO;
        if(resp.sha1Fingerprint != null && resp.sha1Fingerprint.length() > 0)
        tempAccountSo.SHA_1_Fingerprint__c =  resp.sha1Fingerprint ;
        tempAccountSo.SHA_256_Fingerprint__c = resp.sha256Fingerprint ;
        String tempDateStr;
        String[] tempDateArr; 
        if(resp.notBefore!=null && resp.notBefore.length() > 0)
        {
          tempDateStr= resp.notBefore.subStringAfter(',');
          tempDateArr= tempDateStr.split(' ');
          tempAccountSo.Valid_From_GMT__c =   Date.newInstance(Integer.valueOf(tempDateArr[3].trim()),dateMap.get(tempDateArr[2].trim()),Integer.valueOf(tempDateArr[1].trim()));
        }

        if(resp.notAfter!=null && resp.notAfter.length()  > 0)
        {
         tempDateStr= resp.notAfter.subStringAfter(',');
         tempDateArr= tempDateStr.split(' ');
 
         tempAccountSo.Valid_To_GMT__c =   Date.newInstance(Integer.valueOf(tempDateArr[3].trim()),dateMap.get(tempDateArr[2].trim()),Integer.valueOf(tempDateArr[1].trim()));
        }

        if(resp.publicKey!=null && resp.publicKey.length()>0)
        {
          if(resp.publicKey.contains('RSA 1024'))
           {
           tempAccountSo.Signing_Key_Parameters__c = '1024';
           }
           else if(resp.publicKey.contains('RSA 2048'))
           {
           tempAccountSo.Signing_Key_Parameters__c = '2048';
           }
           else if(resp.publicKey.contains('RSA 4096'))
           {
           tempAccountSo.Signing_Key_Parameters__c = '4096';
           }
           else if(resp.publicKey.contains('EC secp256r1'))
           {
           tempAccountSo.Signing_Key_Parameters__c = 'ECC P-256';
           }
           else if(resp.publicKey.contains('EC secp384r1'))
           {
           tempAccountSo.Signing_Key_Parameters__c = 'ECC P-384';
           }
           else if(resp.publicKey.contains('EC secp521r1'))
           {
           tempAccountSo.Signing_Key_Parameters__c = 'ECC P-521';
           }

          
        }
       
        
        tempAccountSo.Certificate_Serial_Number__c = resp.serialNumber ;
        tempAccountSo.Signature_Algorithm__c = resp.signatureAlgorithm;
        tempAccountSo.Basic_Constraints__c = resp.basicConstraints ;
        tempAccountSo.Key_Usage__c = resp.keyUsage ;
        tempAccountSo.Extended_Key_Usage__c = resp.extkeyUsage ;
        tempAccountSo.OCSP_URL_s__c = resp.ocsp;
        tempAccountSo.CRL_URL_s__c = resp.crl;
        
        //axay: Checking for technical constrained flag - additional condition to check for null and converted to lower case and then compare with 'yes'
        tempAccountSo.Technically_Constrained__c = resp.technicallyConstrained != null && resp.technicallyConstrained.toLowerCase().equals('yes') ? true : false;
        
        // delete this line after testing - Poonam
        // tempAccountSo.Technically_Constrained__c = resp.technicallyConstrained != null && resp.technicallyConstrained.toLowerCase().equals('yes') ? false : true;
        
      }
     
     return tempAccountSo; 
    
   }
 
 
 
   // wrapper class to deserialize the JSON response from the cert checker webservice
   class CertCheckerResponseJSON {
   
 public String issuerCN {get;set;}
public   String issuerOU {get;set;}
public   String issuerO  {get;set;}
public   String issuerC  {get;set;}
public   String subjectCN {get;set;}
public   String subjectOU {get;set;}
public   String subjectO {get;set;}
public   String subjectC {get;set;}
public   String sha1Fingerprint {get;set;}
public   String sha256Fingerprint {get;set;}
public   String notBefore {get;set;}
public   String notAfter {get;set;}
public   String version {get;set;}
public   String serialNumber {get;set;}
public   String signatureAlgorithm {get;set;}
public   String publicKeySize {get;set;}
public   String publicKey {get;set;}
 public  String publicKeyPublicExponent {get;set;}
 public  String basicConstraints {get;set;}
 public  String keyUsage {get;set;}
 public  String extKeyUsage {get;set;}
 public  String ocsp {get;set;}            
 public  String crl {get;set;}  
 public  String technicallyConstrained {get;set;}          
 public  String[] errors {get;set;}            
  }

 
}