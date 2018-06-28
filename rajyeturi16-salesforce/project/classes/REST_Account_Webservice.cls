/*
 Descrption: Takes Account and Contact String in JSOn format and create Account Objects in SF Org
 Author    :  Rajesh Tallapaneni
 {"rqst":
    {
      "acct":
             { "Name":"Account Creating from RestService"
             },
      "conList":
            [
             {"LastName":"Contact creating from RestService","Department":"Salesforce"},
             {"LastName":"Contact creating from RestService1","Department":"Salesforce"},
             {"LastName":"Contact creating from RestService2","Department":"Salesforce"},
             {"LastName":"Contact creating from RestService3","Department":"Salesforce"}
            ]   
      }  
 } 
*/
@RestResource(urlMapping='/rajesh/account/*')
global with sharing class REST_Account_Webservice{
  @HttpPost
  global static ResponseWrapper createAccounts(RequestWrapper rqst){
    RestRequest req=RestContext.request;
    RestResponse res=RestContext.response;
    ResponseWrapper rspWrapper=new ResponseWrapper();
       
    insert rqst.acct;
    rspWrapper.acc=rqst.acct;
    for(Contact con:rqst.conList){
      con.AccountId=rqst.acct.id;
    }
    insert rqst.conList;
    rspWrapper.lstCon=rqst.conList;
    rspWrapper.statusCode='OK';
    rspWrapper.msg='Accounts Inserted Succesfully';
    return rspWrapper;  
    
   } 
   
   @httpGet
   global static List<Account> getAccounts(){
    RestRequest req=RestContext.request;
    RestResponse res=RestContext.response;
    
     String strName=req.requestURI.subString(req.requestURI.lastIndexOf('/')+1);
     System.debug('strName is::'+strName);
     strName='%'+strName+'%';
    List<Account> lstAcc=[select id,name from Account where name like :strName];
    System.debug('lstAcc is@@'+lstAcc);
    //List<Account> lstAcc1=[select id,name from account limit 5];
    return lstAcc;
    //return lstAcc1;
     
   
   }

  global class ResponseWrapper{
     public String statusCode;
     public String msg;
     public account acc;
    public List<Contact> lstCon; 
  }
  
  global class RequestWrapper{
    public account acct;
    public List<Contact> conList; 
  }

}