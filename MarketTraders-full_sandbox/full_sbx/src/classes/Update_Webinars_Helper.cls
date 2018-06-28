global class Update_Webinars_Helper{
    @Future(Callout=true)
    public static void updateWebinar(Id credentialid){
        if(credentialid!=null)
        {
            Webinar_Credentials__c credential = new Webinar_Credentials__c();
            credential = [SELECT Token__c,Org_ID__c,Provider__c,Credentials_ID__c,Mnemonic__c FROM Webinar_Credentials__c where id = :credentialid LIMIT 1];
            Logger logger = new Logger();
            if(credential !=null)
            {
                     list<Webinar__c> webinars = new list<Webinar__c>();
                         if(credential.Provider__c == 'Citrix'){
                            list<CitrixWebinar> citrixWebinars;
                            citrixWebinars = Update_Webinars_Helper.parseUpcomingCitrixWebinars(credential.Org_ID__c,credential.Token__c);
                            webinars.addAll(Update_Webinars_Helper.getWebinarsToUpsert(credential.Credentials_ID__c,credential.Mnemonic__c,citrixWebinars));
                            }
                         if(!webinars.isEmpty()){
                            list<Database.UpsertResult> results = Database.upsert(webinars,Webinar__c.Webinar_ID__c,false);
                                for(Database.UpsertResult result : results){
                                    if(!result.isCreated() || !result.isSuccess()){
                                        for(Database.Error error : result.getErrors()){
                                            logger.log(error.getMessage());   
                                        }
                                    }
                                }
                         }                           
                
            }
            logger.emailDebugResults(new list<String>{'sfdev@markettraders.com'});
        }    
    }
             public static list<Webinar__c> getWebinarsToUpsert(String credentialsId,String mnemonic,list<CitrixWebinar> citrixWebinars){
                Webinar_Credentials__c credentials = [SELECT id,Name,Mnemonic__c FROM Webinar_Credentials__c WHERE Credentials_ID__c = :credentialsId];
                Map<String, WebinarType_Credential__c> webinarToCredential = WebinarType_Credential__c.getAll();
                list<Webinar__c> webinars = new list<Webinar__c>();
                    for(CitrixWebinar citrixwebinar : citrixWebinars){
                        Webinar__c webinar = new Webinar__c();
                            if(citrixwebinar.subject.length() > 80){     
                                webinar.Name = citrixwebinar.subject.substring(0,80);
                                }else{
                                        webinar.Name = citrixwebinar.subject;
                                     }    
                                webinar.Webinar_Credentials__c = credentials.id;
                                webinar.Description__c = citrixwebinar.description;
                                webinar.Webinar_ID__c = citrixwebinar.webinarKey;
                                webinar.Platform__c = 'Citrix';
                                /*if(credentials.Name == 'Options'){
                                    webinar.Webinar_Type__c = 'Ultimate Options Course';
                                }else if(credentials.Name == 'Client'){
                                    webinar.Webinar_Type__c = 'Continued Education';
                                } aac 3 20 2015 changed to custom setting */
                            if(webinarToCredential.containskey(credentials.Mnemonic__c)){
                                webinar.Webinar_Type__c = webinarToCredential.get(credentials.Mnemonic__c).Webinar_Type__c;
                                }            
                            if(citrixwebinar.times != null && citrixwebinar.times[0].startTime != null){
                                DateTime dateTimeFromCitrix = DateTime.valueOfGmt(citrixwebinar.times[0].startTime.replace('T',' '));
                                webinar.Event_Date_Time__c = dateTimeFromCitrix;
                                webinars.add(webinar);
                            }   
                    }
                    return webinars;
    }    
                public static list<CitrixWebinar> parseUpcomingCitrixWebinars(String orgId,String authToken){
                    HttpRequest req = new HttpRequest();
                    req.setEndpoint('https://api.citrixonline.com/G2W/rest/organizers/'+ orgId +'/upcomingWebinars');
                    req.setMethod('GET');
                    req.setHeader('Accept','application/json');
                    req.setHeader('Content-Type','application/json');
                    req.setHeader('Authorization','OAuth oauth_token=' + authToken);
                    Http http = new Http();
                    HTTPResponse res = http.send(req);
                    CitrixWebinarJSONHandler webinarHandler = (CitrixWebinarJSONHandler)JSON.deserialize('{"webinars":' + res.getBody() + '}',CitrixWebinarJSONHandler.class);
                    return webinarHandler.webinars;
    }
 }