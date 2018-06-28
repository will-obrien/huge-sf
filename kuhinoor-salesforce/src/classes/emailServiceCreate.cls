global class emailServiceCreate implements Messaging.InboundEmailHandler {
      global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
          Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
          
                Contact con = new Contact();
                List<lightingprefix__Subscription__c> sublist = new  List<lightingprefix__Subscription__c>();
                 List<lightingprefix__Subscription__c> sublistupdate = new  List<lightingprefix__Subscription__c>();
                 
                 
                con.FirstName = email.fromname.substring(0,email.fromname.indexOf(' '));
                con.LastName = email.fromname.substring(email.fromname.indexOf(' '));
                con.email= email.fromAddress;
                con.body__c = email.plainTextBody;
                System.debug('***********code**************'+email.plainTextBody);
                List<Contact> conlist = [select firstname,lastname,email,Subscription_status__c from contact where email=:con.email];                
                
                
                
                if(conlist!=null && conlist.size()>0){
                    system.debug('--------------inside the if loop-----------------');
                    for(Contact c : conlist ){ 
                        system.debug('--------------inside the for loop-----------------');
                    if('yes'==email.plainTextBody.trim()){
                        system.debug('--------------inside the for loop yes condition loop-----------------');
                         List<Subscription__c> sc = [select id,lightingprefix__status__c,lightingprefix__Subscriber__r.id from lightingprefix__Subscription__c where lightingprefix__Subscriber__r.id=:c.id];
                          system.debug('#############################################SC'+sc);   
                         for(Subscription__c s : sc){
                            s.lightingprefix__status__c='Responded';
                            sublistupdate.add(s);
                         } 
                        }
                       
                            
                        }
                    } 
                    
                
                
                
                
                
         //---------------
                if(conlist!=null && conlist.size()>0){
                    system.debug('--------------inside the if loop-----------------');
                    for(Contact c : conlist ){ 
                        system.debug('--------------inside the for loop-----------------');
                    if('yes'==email.plainTextBody.trim()){
                        system.debug('--------------inside the for loop yes condition loop-----------------');
                         List<Subscription__c> sc = [select id,lightingprefix__status__c,lightingprefix__Subscriber__r.id from lightingprefix__Subscription__c where lightingprefix__Subscriber__r.id=:c.id];
                          system.debug('#############################################SC'+sc);   
                         for(Subscription__c s : sc){
                            s.lightingprefix__status__c='Responded';
                            sublistupdate.add(s);
                             
                         }
                    } 
                        
                        if('Accepted'==c.Subscription_status__c){
                            sublist.add(new lightingprefix__Subscription__c(Subscriber__c=c.id,StartDate__c=date.today(),EndDate__c=date.today().addyears(1),status__c='Active')); 
                            
                        }
                        else{
                            
                             sublist.add(new lightingprefix__Subscription__c(lightingprefix__Subscriber__c=c.id));
                        }
                        
                    }
                }
                else{
                     insert con;
                     sublist.add(new lightingprefix__Subscription__c(lightingprefix__Subscriber__c=con.id));
                   
                }
        //------------------------------------ 
        
                
                
                if(sublist.size()>0){
                   insert sublist;
                }
                if(sublistupdate.size()>0){
                    update sublistupdate;
                }
                
                
          return result;
      }
  }