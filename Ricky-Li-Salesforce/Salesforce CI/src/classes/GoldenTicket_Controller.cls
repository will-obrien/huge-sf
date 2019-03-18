/*
 * Purpose: This class is the main controller for the Golden Ticket Visualforce Page.  
 *          This returns user info, captures data from the Visualforce Page and updates the Golden Ticket Model
 */

public class GoldenTicket_Controller {

    //Properties
    String Name;
    String usersId;
    Boolean AreYouComing;
    String ManagerId;
    String ManagerEmail;
    List <string> ApproverIds = new list <String>();
    Boolean BaseCamper = false;
    Public String Criteria {get; set;}
    Public String NightsStaying{get; set;}
    Public String GettingToNiagara{get; set;}
    public String DietRequests {get; set;}
    Public String SpecialRequests {get; set;}
    Public String RoomiePreference {get; set;}
    Public String Smoker{get; set;}
    Public String Passport_FullName{get;set;}
    Public String Passport_DOB{get;set;}
    Public String DepartureCity{get;set;}
    Public String ReturnCity{get;set;}
    Public String TravelThroughUS{get;set;}
    Public String UserName { get;set;}
    Public String StandardDates { get; set; }
    Public String Outsiders_DateChangeReason { get; set; }
    Public String Outsiders_EndDate { get; set; }
    Public String Outsiders_StartDate { get; set; }
    Public String Display_EndDate { get; set; }
    Public String Display_StartDate { get; set; }
    Public String FavouriteSongAllTime { get; set; }
    Public String FavouriteSongToday { get; set; }
    Public String ExploreNiagara { get; set; }
    Public Boolean Passport_VisaReceived { get; set; }
    Public String Passport_Nationality { get; set; }
    Public String UserId {get; set;}
    Public Boolean NotFilled { get; set; }
    Public Boolean AlreadyFilledOut { get; set; }
    
    Boolean isBaseCamp = false;
    Boolean isOutsider = false;
    Boolean isCommonQuestion = false;
    
    //Get Name of the User logged in
    public String getUser() {
        return UserInfo.getFirstName();
    }
  
   public String getUserName(){
       return UserName;
   } 
   
  /* 
    //Get the UserInput
    public String getCriteria() {
        return null;
    }
    
    //Get the Nights Staying in Niagara
    public String getNightsStaying() {
        return null;
    }
    
    //Get how the user will reach Niagara
    public String getGettingToNiagara() {
        return null;
    }
    
    //Special Requests
    public String getSpecialRequests() {
        return null;
    }

    //Smoker - Yes Or No
    public String getSmoker() {
        return null;
    }
    
    //Roomie Preference
    public String getRoomiePreference() {
        return null;
    }

    //Get the Name as on the passport   
    public String getPassport_FullName() {
        return null;
    }

    //Get the DOB as on the passport
    public String getPassport_DOB() {
        return null;
    }
    
    //Get the Departure city
    public String DepartureCity(){
        return null;
    }
    
    //Get the Return city
    public String ReturnCity(){
        return null ;
    }
    */
 /* Getters and Setters for Torontians */
     //get true or false to show
    public Boolean getHideshowToronto(){
        return this.isBaseCamp;
    }
    
    //set to true to show
    public void setHideshowToronto(boolean s){
        this.isBaseCamp = s;
    }

 /* Getters and Setters for Outsiders */
    public Boolean getHideshowOutsiders(){
        return this.isOutsider;
    }
    
    //set to true to show
    public void setHideshowOutsiders(boolean s){
        this.isOutsider = s;
    }

 /* Getters and Setters for Common Questions */
    public Boolean getShowCommonQuestions(){
        return this.isCommonQuestion;
    }
    
    public void setShowCommonQuestions(boolean s){
        this.isCommonQuestion = s;
        
    }
    
    //Returns Yes or No
    public List<SelectOption> getSelectItems() {
         List<SelectOption> options = new List<SelectOption>();  
         options.add(new SelectOption('Yes','Yes')); 
         options.add(new SelectOption('No','No')); 
         return options; 
    }
    
    //Coming or Not
    public List<SelectOption> getSelectItemsComing() {
         List<SelectOption> options = new List<SelectOption>();  
         options.add(new SelectOption('Yes','HELL YEAH!')); 
         options.add(new SelectOption('No','No, I am bummed that I can\'t make it.')); 
         return options; 
    }
    
    //Explore Niagara
    public List<SelectOption> getSelectItemsNiagara() {
         List<SelectOption> options = new List<SelectOption>();  
         options.add(new SelectOption('Yes','Yes, I want to see the sights, but I\'m not a tourist!')); 
         options.add(new SelectOption('No','No, I\'ll be too lazy or I\'ve seen it already, so I\'ll head straight back to Toronto.')); 
         return options; 
    }
    
    
    //Returns the list Of Days
    public List<SelectOption> getNightsInNiagara(){
        List<selectOption> options = new List<selectOption>();
        options.add(new SelectOption('None', 'None'));
        options.add(new SelectOption('Thursday Only','Thursday Only'));
        options.add(new SelectOption('Friday Only', 'Friday Only'));
        options.add(new SelectOption('Full Weekend', 'Full Weekend'));
        
        return options;
    }
    
    public List<SelectOption> getTransportation() {
        List<selectOption> options = new List<selectOption>();
        options.add(new SelectOption('Bus', 'Bus'));
        options.add(new SelectOption('Driver','Driver'));
        options.add(new SelectOption('Other', 'Other'));
        
        return options;
    }
    
    
    public List<SelectOption> getDiet() {
        List<selectOption> options = new List<selectOption>();
        options.add(new SelectOption('None','None'));
        options.add(new SelectOption('Veg', 'Vegetarian'));
        options.add(new SelectOption('Other', 'Other (Please specify)'));
        
        return options;
    }

    
    //Page Redirection
    public PageReference MainRenderer() {
         if(Criteria == 'No'){   
            setHideshowToronto(false);
            setHideshowOutsiders(false);
            setShowCommonQuestions(false);
            
            return null;
            
         }
         else{
             //Check the city of the User
             String userCity = [Select city from User where id=:usersId][0].city;
             if(userCity == 'Toronto'){
                setHideshowToronto(true);
                BaseCamper = true;
             }
             if(userCity != 'Toronto'){
                setHideShowOutsiders(true);
             }
             setShowCommonQuestions(true);
             return null;
         }          
    }
   
    /*
     * Constructor
     */ 
    public GoldenTicket_Controller(){
        CheckIfFilled();
        usersId = UserInfo.getUserId();
        Golden_Ticket__c gtc = [Select Standard_Stay__c, Arrival_Date__c, Departure_Date__c ,Date_Change_Reason__c from Golden_Ticket__c where user__c=:usersId];
        Passport_DOB = 'dd/MM/YYYY' ;
        //Dates
        Display_StartDate = String.valueOf(gtc.Arrival_Date__c.format());
        Outsiders_StartDate = String.valueOf(gtc.Arrival_Date__c.format());
        Display_EndDate = String.valueOf(gtc.Departure_Date__c.format());        
        Outsiders_EndDate = String.valueOf(gtc.Departure_Date__c.format());

        Outsiders_DateChangeReason = 'Your reason for the Date Change...';
        System.Debug('This is the first thing that loads up');  
        
        System.Debug('StandardDates:'+StandardDates);
    }
    
    public void checkIfFilled(){
        List <Golden_Ticket__c> listGoldenTicket = [Select id, Passport_Full_Name__c, IsComing__c, Nights_staying_in_Niagara__c, Status__c from Golden_Ticket__c where User__c =: userinfo.getUserId()];
        String city = [Select city from User where id=: userInfo.getUserId()][0].city;
        ManagerId = [Select ManagerId from User where id=: userInfo.getUserId()][0].ManagerId;
        ManagerEmail = [Select Email from User where Id =:ManagerId][0].Email;
       
        if(listGoldenTicket.size() == 1){
            
           
            
           if(city != 'Toronto'){
                System.Debug('Whatsup');
                if(listGoldenTicket[0].Passport_Full_Name__c == null){
                    NotFilled = true;
                    AlreadyFilledOut = false;          
                }
                else{
                   AlreadyFilledOut = true;
                   NotFilled = false;
                }
            }
            else{
                if(listGoldenTicket[0].Nights_staying_in_Niagara__c == null){
                    NotFilled = true;
                    AlreadyFilledOut = false;
                }
                else{
                    AlreadyFilledOut = true;
                    NotFilled = false;
                }
            }
           
            // damn you subodh - you didn't code the not coming case.
            if (listGoldenTicket[0].Status__c == 'Not Attending') {
                AlreadyFilledOut = true;
                NotFilled = false;
            }

        }
    }
    
    /*
     * Objective: Update the Golden Ticket Model
     */
    public PageReference updateModel() {
          Boolean isError = false;  
          PageReference ref;
          List <String> listErrors = new list <String>();
          /* 
           * Update the Golden ticket Model 
          */
          List <Golden_Ticket__c> listGoldenTicket = [SELECT Arrival_Date__c, CreatedById, CreatedDate, CurrencyIsoCode, 
                                                             Date_Change_Reason__c, Passport_DOB__c, IsDeleted, Departure_City__c,
                                                             Departure_Date__c, Dietary_Requests__c, Explore_Niagara__c, 
                                                             Fav_Rock_Song_All_Time__c, Fav_Rock_Song_Today__c, Flight_Booking__c,
                                                             Passport_Full_Name__c, Getting_to_Niagara__c, Name, LastActivityDate,
                                                             LastModifiedById, LastModifiedDate, Name__c, Passport_Nationality__c,
                                                             Nights_staying_in_Niagara__c, Other_Requests__c, OwnerId, Id,
                                                             Request_Different_Dates__c, Return_City__c, Sex__c, Smoker__c,
                                                             Standard_Stay__c, Status__c, SystemModstamp, Travel_Through_US__c,
                                                             Visa_Received__c, isBaseCamper__c, 
                                                             isComing__c, Roomie__c
                                                             FROM Golden_Ticket__c where User__c =: usersId];
           
        if(listGoldenTicket.size() == 1){
          if(Criteria == null){
               isError = true;     
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Are you coming or not?'));   
          }          
           else{   
              
              //Check if the response is yes
              if(Criteria == 'Yes'){
                  //Set isComing to true
                  listGoldenTicket[0].isComing__c = true;
                        
                  if(BaseCamper == true){
                      /* Base Camper Deets */
                      if(NightsStaying == null){
                         isError = true;     
                         listErrors.add('Nights staying in Niagara'); 
                      }
                      
                      if(GettingToNiagara == null) {
                         isError = true; 
                         listErrors.add('Getting To Niagara');    
                      }
                   
                      if(NightsStaying !=null && GettingToNiagara !=null){   
                          listGoldenTicket[0].Getting_to_Niagara__c = GettingToNiagara;
                          listGoldenTicket[0].Nights_Staying_in_Niagara__c = NightsStaying;
                      }
                  }
                  else{
                      /* Outsider Deets */
                      
                      if(StandardDates == null){
                          isError = true;
                          listErrors.add('Standard Date Preference');
                      }
                      
                      //If the user does not want standard dates
                       if(StandardDates == 'false'){
                           if(Outsiders_StartDate == ''){
                               isError = true;
                               listErrors.add('Start Date');
                           }
                           //Start Date validations
                           if(Outsiders_StartDate.contains('-')){
                               isError = true;
                               listErrors.add('Start Date: Use "/" instead of "-"');
                           }
                           if(Date.parse(Outsiders_StartDate).year() != 2013){
                               isError = true;
                               listErrors.add('Start Date: Change the year to 2013!');
                           }
                           
                           if(Outsiders_EndDate == ''){
                               isError = true;
                               listErrors.add('End Date');
                           }
                           
                           if(Outsiders_EndDate.contains('-')){
                               isError = true;
                               listErrors.add('End Date: Use "/" instead of "-"');
                           }
                           if(Date.parse(Outsiders_EndDate).year() != 2013){
                               isError = true;
                               listErrors.add('End Date: Change the year to 2013!');
                           }
                           
                           if(Outsiders_DateChangeReason == 'Your reason for the Date Change...' || Outsiders_DateChangeReason == ''){
                               isError = true;
                               listErrors.add('Date Change Reason');
                               
                           }
                           if(Outsiders_StartDate != null && Outsiders_StartDate.contains('/') && Date.parse(Outsiders_StartDate).year() == 2013 
                               && Outsiders_EndDate != null && Outsiders_EndDate.contains('/') && Date.parse(Outsiders_EndDate).year() == 2013
                               && Outsiders_DateChangeReason != 'Your reason for the Date Change...' && Outsiders_DateChangeReason != ''){
                               //set the Dates and Reason
                                   listGoldenTicket[0].Standard_Stay__c = false;
                                   listGoldenTicket[0].Request_Different_Dates__c = true;
                                   listGoldenTicket[0].Arrival_Date__c = date.parse(Outsiders_StartDate);
                                   listGoldenTicket[0].Departure_Date__c = date.parse(Outsiders_EndDate); 
                                   listGoldenTicket[0].Date_Change_Reason__c = Outsiders_DateChangeReason;
                           }
                       }
                       else{
                           listGoldenTicket[0].Standard_Stay__c = true;
                           listGoldenTicket[0].Request_Different_Dates__c = false;
                           listGoldenTicket[0].Date_Change_Reason__c = '';
                       }
                      
                      //Flight Booking Details
                     System.Debug('Passport_FullName'+Passport_FullName);
                     if(Passport_FullName == ''){
                         isError = true;
                         listErrors.add('Full Name as per your passport');    
                     }
                     //Check the format of the Date
                     String DateEntered = Passport_DOB;
                         if(DateEntered.contains('-')){
                             isError=true;
                             listErrors.add('Use "/" in the Date of Birth');
                         }
                         
                     //Year Validation
                     Integer difference;
                         if(DateEntered.contains('/') && DateEntered != 'dd/MM/YYYY'){
                             //Entered Date's year
                             Integer year = Date.parse(passport_DOB).year();
                          
                             //Today's year
                             Integer todaysYear = date.Today().year();
                         
                             //Check the difference
                             difference = todaysYear - year;
                                 
                                 if(difference < 16){
                                     isError = true;
                                     listErrors.add('Date Of Birth: You cannot be younger than 16');
                                 }
                         
                                 if(difference > 71){
                                     isError = true;
                                     listErrors.add('Date Of Birth: You can not be older than 70');
                                 }
                       }
                     
                     System.Debug('Passport_DOB'+Passport_DOB);
                     if(Passport_DOB == '' || Passport_DOB == 'dd/MM/YYYY'){
                         isError = true;
                         listErrors.add('Date of Birth');
                     }
                     System.Debug('Passport_Nationality'+Passport_Nationality);
                     if(Passport_Nationality == ''){
                         isError = true;
                         listErrors.add('Nationality');
                     }
                     System.Debug('DepartureCity'+ DepartureCity);
                     if(DepartureCity == ''){
                         isError = true;
                         listErrors.add('Departure City');
                     }
                     System.Debug('ReturnCity'+ReturnCity);
                     if(ReturnCity == ''){
                         isError = true;
                         listErrors.add('Return City');
                     }
                     System.Debug('TravelThroughUS'+TravelThroughUS);
                     if(TravelThroughUS == null){
                         isError = true;
                         listErrors.add('Eligibility to travel through the US');
                     }

                     if(TravelThroughUS != null && ReturnCity != '' && DepartureCity != '' && Passport_Nationality != '' && Passport_DOB != '' && Passport_DOB != 'dd/MM/YYYY' && Passport_FullName != ''){
                        
                        if(DateEntered.contains('/') && difference > 16 && difference < 71){
                             listGoldenTicket[0].Passport_Full_Name__c = Passport_FullName;
                             System.Debug('Parsed Date' + Date.parse(Passport_DOB));
                             listGoldenTicket[0].Passport_DOB__c = Date.parse(Passport_DOB);
                             listGoldenTicket[0].Passport_Nationality__c = Passport_Nationality;  
                             listGoldenTicket[0].Departure_City__c = DepartureCity;
                             listGoldenTicket[0].Return_City__c = ReturnCity;
                         
                             if(TravelThroughUS == 'Yes')
                                 listGoldenTicket[0].Travel_Through_US__c = true;
                           
                             else
                                 listGoldenTicket[0].Travel_Through_US__c = false;
                       }
                     }
                  }
                  
                          /* Common Questions */
                      
                      if( DietRequests == null){
                          isError = true;
                          listErrors.add('Dietary Requests');    
                      }
                      
                      if(RoomiePreference == null){
                          isError = true;
                          listErrors.add('Global Roomie Preference');
                      }
                      
                      if(Smoker == null){
                          isError = true;
                          listErrors.add('Smoker');
                      } 
                       
                      if(RoomiePreference != null && DietRequests != null){
                          listGoldenTicket[0].Dietary_Requests__c = DietRequests;
                          listGoldenTicket[0].Other_Requests__c = SpecialRequests;
                          
                          if(Smoker == 'true')
                             listGoldenTicket[0].Smoker__c = true;
                             
                          else
                              listGoldenTicket[0].Smoker__c = false;
                          
                          if(RoomiePreference == 'false')
                              listGoldenTicket[0].Roomie__c = '';
                          
                      }
                      
                      //Other Questions
                      
                      if(ExploreNiagara == null){
                          isError = true;
                          listErrors.add('Explore Niagara'); 
                      }
                      
                      if(ExploreNiagara != null){
                          if(ExploreNiagara == 'Yes')
                              listGoldenTicket[0].Explore_Niagara__c = true;
                          
                          else
                              listGoldenTicket[0].Explore_Niagara__c = false;
                              
                          listGoldenTicket[0].Fav_Rock_Song_All_Time__c = FavouriteSongAllTime;
                          listGoldenTicket[0].Fav_Rock_Song_Today__c = FavouriteSongToday;
                      }
               } 
           }
               //Check if there are any errors
               if(isError == true){
                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'The following required fields are missing your input:'));
                   for(integer i =0; i < listErrors.size(); i++){
                     ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,listErrors[i]));  
                   }
               }   
               
               //Check if there are any errors and if not, update the model
               if(isError == false){
                  System.Debug('Updating');
                  listGoldenTicket[0].OwnerId = usersId;             
                  /*
                    No workflow condition check:
                    a.)the person is coming
                    b.)the person is not from basecamp
                    c.)No different Dates required    
                  */
                  if(listGoldenTicket[0].isBaseCamper__c == 'No' && Criteria == 'Yes' && standardDates == 'true'){
                      //No workflow required so just update the list
                      listGoldenTicket[0].Status__c = 'Approved by Manager';
                      update listGoldenTicket;
                  }
                   
                 else{
                  /* Status Confirmed
                     Condition check: a.)the person is coming 
                                      b.)the person is from basecamp
                   */
                   
                   if (listGoldenTicket[0].isBaseCamper__c == 'Yes' && Criteria == 'Yes'){
                      listGoldenTicket[0].Status__c = 'Confirmed';
                      update listGoldenTicket;
                   }
                  
                  else if (listGoldenTicket[0].IsComing__c == False) {
                      System.Debug('Is coming is false is being called!');
                      listGoldenTicket[0].Status__c = 'Not Attending';
                      update listGoldenTicket;
                        
                  }
                   
                  //Submit for approval  
                  else {
                     //update the list
                     update listGoldenTicket;

                     //call the approval process
                     System.Debug('Approval is getting called');
                     Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                     //req1.setComments('Submitting the request for approval');
                     req1.setObjectId(listGoldenticket[0].Id);
                     
                     // Submit the approval request for the 
                     Approval.ProcessResult result = Approval.process(req1);
                     System.assert(result.isSuccess());  
                     
                 }
              }
              
                  //redirect to the same Page              
                  ref = Page.Golden_Ticket;
                  ref.setRedirect(true);        
               }
               else
                  System.Debug('Did not update');
          }   
        else
              System.Debug('There is no records for this user!');
      
      
      return ref;             
    }
}