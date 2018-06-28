public class BrochureRequestTriggerController{
        /* Flag Account */
    /*
    static integer runTimesAccount = 0;

    public static integer getRunTimesAccount(){
        return runTimesAccount;
    }

    public static void setRunTimesAccount(){
        runTimesAccount++;
    }
    */
        /* Account */
    public static void BrochureRequest_Account(List<Account> listAccount){   
     
      //List <String> allAccountIds = new list <String>();
      
        Map <String, String> MapCountryISO = new Map <String, String> ();
        String ISOCode;
        List <CountryToISO__c> listCountryToISO = [Select CountryName__c, ISO__c from CountrytoISO__c];
           
           for(CountrytoISO__c cti : listCountryToISO){
              mapCountryISO.put(cti.CountryName__c, cti.ISO__c);
           }

        //List <Account> listAccount = [Select Id, BillingCountry, ShippingCountry, ISOCountry__pc, ISOCountry__c, IsPersonAccount from Account where Id in: AccountIds];
        //List <Account> listAccountUpdate = new List <Account>();
        for(Account acc : listAccount){
               /* Billing Country */
           if(acc.BillingCountry != null){
              if(acc.BillingCountry.Length() > 2){
                 ISOCode = MapCountryISO.get(acc.BillingCountry);
                     if(ISOCode != null){
                         if(acc.IsPersonAccount == true)
                             acc.ISOCountry__pc = ISOCode;
                         else
                             acc.ISOCountry__c = ISOCode;
                     }
                     else{
                         if(acc.IsPersonAccount == true)
                             acc.ISOCountry__pc = '';
                         else
                             acc.ISOCountry__c = '';   
                     
                         //allAccountIds.add(acc.Id);
                     }
              }
              else{
                  if(acc.IsPersonAccount == true){
                      if(MapCountryISO.get(acc.BillingCountry) != null){
                          acc.ISOCountry__pc = MapCountryISO.get(acc.BillingCountry);
                      }
                      else
                          acc.ISOCountry__pc = acc.BillingCountry;
                  }
                  else
                      if(MapCountryISO.get(acc.BillingCountry) != null){
                          acc.ISOCountry__c = MapCountryISO.get(acc.BillingCountry);
                      }
                      else
                          acc.ISOCountry__c = acc.BillingCountry;
              }
           }
           else{
                /* Shipping Country */
                if(acc.ShippingCountry != null){
                    if(acc.ShippingCountry.Length() > 2){
                        ISOCode = MapCountryISO.get(acc.ShippingCountry);
                            if(ISOCode != null){
                                if(acc.IsPersonAccount == true)
                                    acc.ISOCountry__pc = ISOCode;
                                else
                                    acc.ISOCountry__c = ISOCode;
                            }
                            else{
                                if(acc.IsPersonAccount == true)
                                    acc.ISOCountry__pc = '';
                                else
                                    acc.ISOCountry__c = '';
                                 
                                //allAccountIds.add(acc.Id);
                            }
                    }
                    else{
                        if(acc.IsPersonAccount == true)
                            if(MapCountryISO.get(acc.ShippingCountry) != null){
                                acc.ISOCountry__pc = MapCountryISO.get(acc.ShippingCountry);
                            }
                            else
                                acc.ISOCountry__pc = acc.ShippingCountry;
                        else
                            if(MapCountryISO.get(acc.ShippingCountry) != null){
                                acc.ISOCountry__c = MapCountryISO.get(acc.ShippingCountry);
                            }
                            else
                                acc.ISOCountry__c = acc.ShippingCountry;
                    }
                }                
            } 
           //DML update unecessary because it is fired at before insert / update
           //listAccountUpdate.add(acc); 
        }
            /*Create a Task*/
    /*    Task task = new Task();
        task.Subject = 'Brochure Request';
        task.description = 'Please have a look at the Location country field for these Ids:'+AllAccountIds+'. We did not find a matching ISO in the CountrytoISO__c object.';
        task.OwnerId = '00530000007kWpTAAU';
            if(AllAccountIds.size() >0)
                insert task;
    */
     
           
            /* Send Email *//*
        Messaging.singleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'salesforce@gadventures.com'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('No ISO Code found!');
        mail.setPlainTextBody('Please have a look at the Location country field for these Ids:'+AllAccountIds+'. We did not find a matching ISO in the CountrytoISO__c object.');
        if(AllAccountIds.size() >0)
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
     */
        //System.Debug(listAccountUpdate);
        //update listAccountUpdate;           
    }
    
            /* Flag Contact */
            /*
    static integer runTimesContact = 0;

    public static integer getRunTimesContact(){
        return runTimesContact;
    }

    public static void setRunTimesContact(){
        runTimesContact++;
    }
    */
        /* Contact */
    public static void BrochureRequest_Contact(List<Contact> listContact){
        String ISOCode;
        String AgencyMailing;
        String AgencyShipping;
        List <String> AllContactIds = new list <String>();
        
        //List <Contact> listContact = [Select Id, MailingCountry, OtherCountry, ISOCountry__c, AccountId from Contact where Id in: ContactIds and isPersonAccount = false];
        //List <Contact> listContactUpdate = new list <Contact>();    
            List <String> listAgencyId = new list <String>();
            for(integer i=0; i < listContact.size(); i++){
                listAgencyId.add(listContact[i].AccountId);
            }
            
        List <Account> listAccount = [Select Id, ShippingCountry, BillingCountry from Account where isPersonAccount = false and Id in: listAgencyId];
              Map <String, String> mapCountryISO = new Map <String, String>();
              Map <String, String> mapAgentAgencyId = new Map <String, String>();
              Map <String, String> mapIdAgencyMailingCountry = new Map <String, String>();
              Map <String, String> mapIdAgencyShippingCountry = new map <String, String>();
              
              List <CountryToISO__c> listCountryToISO = [Select CountryName__c, ISO__c from CountrytoISO__c];
                 for(CountrytoISO__c cti : listCountryToISO){
                    mapCountryISO.put(cti.CountryName__c, cti.ISO__c);
                 }    
              
                for(Contact con : listContact){
                      mapAgentAgencyId.put(con.Id, con.AccountId);
                }
                  
                for(Account acc : listAccount){
                      mapIdAgencyMailingCountry.put(acc.Id, acc.BillingCountry);
                      mapIdAgencyShippingCountry.put(acc.Id, acc.ShippingCountry);
                }

                for(Contact con : listContact){ 
                      /* Mailing COuntry */ 
                    if(con.MailingCountry != null){
                      if(con.MailingCountry.Length() > 2){
                         ISOCode = MapCountryISO.get(con.MailingCountry);
                           if(ISOCode != null){
                               con.ISOCountry__c = ISOCode;
                           }
                           else{
                               con.ISOCountry__c = '';
                               AllContactIds.add(con.Id);
                           }
                       }
                       else{
                           if(MapCountryISO.get(con.MailingCountry) != null){
                               con.ISOCountry__c = MapCountryISO.get(con.MailingCountry);
                           }
                           else
                               con.ISOCountry__c = con.MailingCountry;
                       }
                    }
                        /* Other Country */
                    if(con.OtherCountry != null){
                     if(con.OtherCountry.Length() > 2){
                        ISOCode = MapCountryISO.get(con.OtherCountry);
                        if(ISOCode != null){
                               con.ISOCountry__c = ISOCode;
                           }
                           else{
                               con.ISOCountry__c = '';
                               AllContactIds.add(con.Id);
                           }
                        }
                        else{
                            if(MapCountryISO.get(con.OtherCountry) != null){
                                con.ISOCountry__c = MapCountryISO.get(con.OtherCountry);
                            }
                            else
                                con.ISOCountry__c = con.OtherCountry;  
                        }
                    }
                        /*Agency Billing Country*/
                    if(con.MailingCountry == null && con.OtherCountry == null){
                        String AgencyId = mapAgentAgencyId.get(con.Id);
                        String AgencyMailingCountry = mapIdAgencyMailingCountry.get(AgencyId);
                            if(AgencyMailingCountry != null){
                             if(AgencyMailingCountry.length() > 2){ 
                               ISOCode = MapCountryISO.get(AgencyMailingCountry);
                               if(ISOCode != null){
                                   con.ISOCountry__c = ISOCode;
                               }
                               else{
                                   con.ISOCountry__c = '';
                                   AllContactIds.add(con.Id);
                               }
                            }
                            else{
                                if(MapCountryISO.get(AgencyMailingCountry) != null){
                                    con.ISOCountry__c = MapCountryISO.get(AgencyMailingCountry);
                                }
                                else
                                    con.ISOCountry__c = AgencyMailingCountry;
                            }
                         }
                         /*Agency Shipping Country*/   
                     else{
                          String AgencyLocationCountry = MapIdAgencyShippingCountry.get(AgencyId);
                              if(AgencyLocationCountry != null){
                               if(AgencyLocationCountry.Length() > 2){ 
                                 ISOCode = MapCountryISO.get(AgencyLocationCountry);
                                 if(ISOCode != null){
                                     con.ISOCountry__c = ISOCode;
                                 }
                                 else{
                                      con.ISOCountry__c = '';
                                      AllContactIds.add(con.Id);
                                 }   
                              }
                              else{
                                  if(MapCountryISO.get(AgencyLocationCountry) != null){
                                      con.ISOCountry__c = MapCountryISO.get(AgencyLocationCountry);
                                  }
                                  else    
                                      con.ISOCountry__c = AgencyLocationCountry;
                              }
                      }
                   } 
                }
               
               //listContactUpdate.add(con);
            }
            
                        /*Create a Task*/
       /*         Task task = new Task();
                task.Subject = 'Brochure Request';
                task.description = 'Please have a look at the Location country field for these Ids:'+AllContactIds+'. We did not find a matching ISO in the CountrytoISO__c object.';
                task.OwnerId = '00530000007kWpTAAU';
                    if(AllContactIds.size() >0)
                        insert task;
        */
            
          /*
             Messaging.singleEmailMessage mail = new Messaging.SingleEmailMessage();
             String[] toAddresses = new String[] {'salesforce@gadventures.com'};
             mail.setToAddresses(toAddresses);
             mail.setSubject('No ISO Code found!');
             mail.setPlainTextBody('Please have a look at the country field for these Ids: '+AllContactIds+' in the subject line. We did not find a matching ISO in the CountrytoISO__c object.');
             if(AllContactIds.size() > 0)
                 Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });   
           */
            
         //update listContact
         //update listContactUpdate;
    }
}