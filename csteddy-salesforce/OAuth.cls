public class OAuth {

//This method creates and returns a URL to get a temporary token
public static String getUnauthorizedReqToken(){
 


// The following statement will create new place marker usertoken object or mark the existing object as not authorized 
  usertoken.isauthorized = false; 
  String body='client_id='+myob.ConsumerKey+'&redirect_uri='+EncodingUtil.urlEncode(myob.CallBackURL,'UTF-8')+'&response_type=code';
  if (myob.SCOPE != null) {
    body=body+'&scope='+myob.SCOPE;
    }
  if (myob.StateParameterRequired){
    String state = getRandomNonce(); //Random String
    body=body+'&state='+state;
      userToken.nonce = state;

    }
//  save object
    usertoken.write();
  String retUrl=myob.AuthorizationURL+'?'+body;
  return retUrl;
}
//Generates Nonce Randomly
public static String getRandomNonce(){
   String allChars='ABCDEFGHIJKLMNOPQRSTUVWXYZ';
   String nonce='';
   for(integer cnt=0; cnt<=9;cnt++)   {
       Integer i = 1+Math.Round(700.0*Math.random()/26);
       if (i<=26)
       {
          i--;
          String newStr=allChars.substring(i,i+1);
          nonce=nonce+newStr;
      }else{
        cnt--;
      }
  }
  return nonce;
}


}
