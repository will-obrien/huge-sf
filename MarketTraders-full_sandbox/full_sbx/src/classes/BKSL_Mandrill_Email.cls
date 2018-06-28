public with sharing class BKSL_Mandrill_Email {

class email{
  public String email{get; set;}
  public String name{get; set;}
  public String type{get; set;}
}

class var{
  public String name{get; set;}
  public String content{get; set;}
  
  public var(String name, String content){
    this.name = name;
    this.content = content;
  }
}
    
public class properties{
    public String toAddress{get; set;}
    public String toName{get; set;}
    public String replyTo{get; set;}
    public String appointmentTime{get; set;}
    public String appointmentId{get; set;}
    public String serviceid{get; set;}
}

Map<String,String> header = new Map<String, String>();
Map<String,Object> postMap = new Map<String, Object>();
Map<String,Object> mergeVar = new Map<String, Object>();
list<var> lstVar = new list<var>();
public properties prop = new properties();

public void sendEmail(){
  postMap.put('key', '8Ceqb5y9BDgIix7KX18e4A');
  postMap.put('template_name', 'mti-appointment-confirmation' );
  postMap.put( 'template_content', new List<String>() );
  Map<String,Object> message = new Map<String, Object>();
  
  list<email> lstmail = new list<email>();
  email mail = new email();
  mail.email = prop.toAddress;
  mail.name = prop.toName;
  mail.type = 'to';
  lstmail.add(mail);
  message.put('to', lstmail);
  
  header.put('Reply-To', prop.replyTo);
  message.put('headers', header);
  message.put('merge', true);
  
  lstVar.add(new var('fname', prop.toName));
  lstVar.add(new var('appointmenttime', prop.appointmentTime));
  lstVar.add(new var('appointmentid', prop.appointmentId));
  lstVar.add(new var('serviceid', prop.serviceid));
  
  mergeVar.put('vars', lstVar);
  message.put('global_merge_vars', lstVar);
  message.put('subaccount', 'MTI');
  
  postMap.put( 'message', message );
  system.debug('postMap:' + postMap);
  
  Http h = new Http();
  HttpRequest req = new HttpRequest();
  
  req.setEndpoint('https://mandrillapp.com/api/1.0/messages/send-template.json' );
  req.setMethod('POST');
  string postJson = JSON.serialize( postMap );
  req.setBody( postJson );
  
  // Send the request, and return a response
  if(!Test.isRunningTest())
    HttpResponse res = h.send(req);
}
}