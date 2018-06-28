public class TabbedEvals {

    Public String textData;
    Public String textCEOName;
    Public String dateEvalSent;
    Public String dateEvalCompleted;
    Public String dateServiceFinished;
    Public String accountName;
    Public String serviceName;
    Public String region;
    Public String bookingNumber;
    Public String SearchCriteria {get; set;}
    Public List <Tour_Evaluation__c> listTE {get;set;}
    Public list <Tour_Evaluation_Historical_Summary__c> listTEHS {get;set;}
    Public list <Tour_Evaluation_Leader__c> listTEL {get;set;}
    
    //Pagination
    public Integer pageSize{get;set;}
    public Integer noOfPages{get;set;}
    public Integer pageNumber{get;set;}
    private Integer totalNoOfRecs;
    
    public TabbedEvals(){
        pageSize = 10;      
    }
    
    public String getTextData() {
        return null;
    }
    
    Public void setTextData(String s){
        textData = s;
    }

    public List<SelectOption> getSearchItems() {
         List<SelectOption> options = new List<SelectOption>();  
         options.add(new SelectOption('DateEvalSent','Date Evaluation Sent')); 
         options.add(new SelectOption('DateEvalCompleted','Date Evaluation Completed')); 
         options.add(new SelectOption('ServiceFinishDate', 'Service Finish Date'));
         options.add(new SelectOption('CEOName','Tour Leader (CEO) Name')); 
         options.add(new SelectOption('TravellerName', 'Traveller Name'));
         options.add(new SelectOption('ServiceName', 'Service Name'));
         options.add(new SelectOption('TripCode','Trip Code'));
         options.add(new SelectOption('Region', 'Region'));
         options.add(new SelectOption('BookingNumber', 'Booking Number'));
         return options; 
    }
    
    public void Clear() {
       listTE = null;
       listTEHS = null;
       listTEL = null;
    }
    
    Public void SearchText(){
          
       //Check the radio button
          if(SearchCriteria == null){
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Choose a radio Button!'));
           }
       //check the text box
           else if(textData.Trim() == ''){
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter some text to search!'));
           }
      //Search for trip code
           else if(textData != null && SearchCriteria != null){
               //Trip Code
               if(SearchCriteria == 'TripCode'){
               		if(textData.Trim().length() < 10){
               			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter a valid trip code!'));
           			}else{
                   String TripCode = textData;
                   List <Service__c> listService = [Select Id from Service__c where Trip_Code__c =: TripCode];
                   
                      /*  Pagination Stuff 
                       pageNumber = 0;
                       totalNoOfRecs = [Select Count() from Tour_Evaluation__c where Service__c in : listService];
                       System.Debug(totalNoOfRecs);
                       System.Debug(pageSize);
                       noOfPages = totalNoOfRecs/pageSize;
                       System.Debug(noOfPages);
                   
                   /*                   */
                    
                   listTE = new list <Tour_Evaluation__c>();
                   
                   /* Pagination Stuff 
                   if(Math.mod(totalNoOfRecs, pageSize) > 0)
                       noOfPages++;
                   try{
                       String baseQueryTETripCode = 'Select Id, Name, Account__c, Service__c, Date_Completed__c, Date_Read__c, NPS_Rating__c, User_Read__c from Tour_Evaluation__c where Service__c in: listService';
                       listTE = Database.query(baseQueryTETripCode + ' limit ' +pageSize);
                   }
                   catch(Exception e){
                       ApexPages.addMessages(e);
                   }
                   
                   /*                  */
                   
                   listTE = [Select Id, Name, Account__c, Service__c, Date_Completed__c, Date_Read__c, NPS_Rating__c, User_Read__c from Tour_Evaluation__c where Service__c in: listService];
                   
                   if(listTE.size() == 0){
                       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Info,'There is no Records'));
                       listTE = null;
                       listTEHS = null;
                       listTEL = null;
                   }
                   else{
                       listTEHS = new list <Tour_Evaluation_Historical_Summary__c>();
                       listTEHS = [Select Id, Account_Name__c, Agency_Name__c, Evaluation_Email_Address__c, Status__c, Error__c, Trip_Code__c, Date_Sent__c, Tour_Evaluation__c, Resent_By__c from Tour_Evaluation_Historical_Summary__c where Tour_Evaluation__c in : listTE]; 
        
                       listTEL = new list <Tour_Evaluation_Leader__c>();
                       listTEL = [Select Id, Tour_Evaluation__c, Account__c, CEO_Name__c, CEO_Communication__c, CEO_Enthusiasm__c, CEO_ID__c, CEO_Insight__c, CEO_Local_Knowledge__c, CEO_Management__c, CEO_Professionalism__c, Trip_Code__c from Tour_Evaluation_Leader__c where Tour_Evaluation__c in : listTE];  
                   }
               }
               }
               
               //CEO Name
               if(SearchCriteria == 'CEOName'){
               	if(textData.Trim().length() < 2){
               			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter at least two characters!'));
           			}else{
                   textCEOName = textData;
                   listTEL = new list <Tour_Evaluation_Leader__c>();
                   //LIKE Operator
                   String query = 'Select Id, Tour_Evaluation__c, Account__c, CEO_Name__c, CEO_Communication__c, CEO_Enthusiasm__c, CEO_ID__c, CEO_Insight__c, CEO_Local_Knowledge__c, CEO_Management__c, CEO_Professionalism__c, Trip_Code__c from Tour_Evaluation_Leader__c where CEO_Name__c LIKE \'%'+textCEOName+'%\' limit 5000';
                   listTEL = database.query(query);
                    
                   List <String> listStrTEL = new list <String>();
                   for(integer i =0; i < listTEL.size(); i++){
                     System.Debug(listTEL[i].Tour_Evaluation__c);
                     listStrTEL.add(listTEL[i].Tour_Evaluation__c);
                   }
         
                   listTE = new list <Tour_Evaluation__c>();
                   listTE = [Select Id, Name, Account__c, Service__c, Date_Completed__c, Date_Read__c, NPS_Rating__c, User_Read__c from Tour_Evaluation__c where Id in: listStrTEL];
                    
                   if(listStrTEL.size() == 0 && listTE.size() == 0){
                       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Info,'There is no Records'));
                       listTE = null;
                       listTEHS = null;
                       listTEL = null;
                   }
                   else{
                       listTEHS = new list <Tour_Evaluation_Historical_Summary__c>();
                       listTEHS = [Select Id, Account_Name__c, Agency_Name__c, Evaluation_Email_Address__c, Status__c, Error__c, Trip_Code__c, Date_Sent__c, Tour_Evaluation__c, Resent_By__c  from Tour_Evaluation_Historical_Summary__c where Tour_Evaluation__c in : listTE];
                   }
               }
               }  
               
               //Date Eval Sent
               if(SearchCriteria == 'dateEvalSent'){
               	if(isValidDate(textData)){
                   dateEvalSent = textData;
                   listTEHS = new list <Tour_Evaluation_Historical_Summary__c>();
                   
                   String query = 'Select Id, Account_Name__c, Agency_Name__c, Evaluation_Email_Address__c, Status__c, Error__c, Trip_Code__c, Date_Sent__c, Tour_Evaluation__c, Resent_By__c  from Tour_Evaluation_Historical_Summary__c where Date_Sent__c = \''+dateEvalSent+'\'';
                   listTEHS = Database.query(query); 
         
                   List <String> listStrTEHS = new list <String>();
                   for(integer i =0; i < listTEHS.size(); i++){
                        System.Debug(listTEHS[i].Tour_Evaluation__c);
                        listStrTEHS.add(listTEHS[i].Tour_Evaluation__c);
                   }
                   
                   listTE = new list <Tour_Evaluation__c>();
                   listTE = [Select Id, Name, Account__c, Service__c, Date_Completed__c, Date_Read__c, NPS_Rating__c, User_Read__c from Tour_Evaluation__c where Id in: listStrTEHS];
                   
                   //validation
                   if(listTE.size() == 0 && listStrTEHS.size() == 0){
                       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Info,'There is no Records'));
                       listTE = null;
                       listTEHS = null;
                       listTEL = null;
                   }
                   else{
                        listTEL = new list <Tour_Evaluation_Leader__c>();
                        listTEL = [Select Id, Tour_Evaluation__c, Account__c, CEO_Name__c, CEO_Communication__c, CEO_Enthusiasm__c, CEO_ID__c, CEO_Insight__c, CEO_Local_Knowledge__c, CEO_Management__c, CEO_Professionalism__c, Trip_Code__c from Tour_Evaluation_Leader__c where Tour_Evaluation__c in: listTE];  
                   }
               	}else{
               		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter a valid Date Format: yyyy-mm-dd'));
               	}             
                }
               
               //Date Evaluation Completed
               if(SearchCriteria == 'DateEvalCompleted'){
               	if(isValidDate(textData)){
                   dateEvalCompleted = textData;
                   
                   String query = 'Select Id, Name, Account__c, Service__c, Date_Completed__c, Date_Read__c, NPS_Rating__c, User_Read__c from Tour_Evaluation__c where date_completed__c ='+dateEvalCompleted;
                   listTE = new list <Tour_Evaluation__c>();
                   listTE = Database.query(query);
                   
                   if(listTE.size() == 0){
                       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Info,'There is no Records'));
                       listTE = null;
                       listTEHS = null;
                       listTEL = null;
                   }
                   else{
                       listTEHS = new list <Tour_Evaluation_Historical_Summary__c>();
                       listTEHS = [Select Id, Account_Name__c, Agency_Name__c, Evaluation_Email_Address__c, Status__c, Error__c, Trip_Code__c, Date_Sent__c, Tour_Evaluation__c, Resent_By__c from Tour_Evaluation_Historical_Summary__c where Tour_Evaluation__c in : listTE];
                       
                       System.Debug(listTE);
                       
                       listTEL = new list <Tour_Evaluation_Leader__c>();
                       listTEL = [Select Id, Tour_Evaluation__c, Account__c, CEO_Name__c, CEO_Communication__c, CEO_Enthusiasm__c, CEO_ID__c, CEO_Insight__c, CEO_Local_Knowledge__c, CEO_Management__c, CEO_Professionalism__c, Trip_Code__c from Tour_Evaluation_Leader__c where Tour_Evaluation__c in: listTE];
                   }
               	}else{
               		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter a valid Date Format: yyyy-mm-dd'));
               	}
               }
               
               //Service Finish Date
               if(SearchCriteria == 'ServiceFinishDate'){
               	if(isValidDate(textData)){
                   dateServiceFinished = textData;
                   
                   //fetch services
                   List <Service__c> listService = [Select Id from Service__c where Service_Finish_Date__c =: date.valueOf(dateServiceFinished)];
                   System.Debug(listService);
                   //fetch TE's
                   listTE = new list <Tour_Evaluation__c>();
                   listTE = [Select Id, Name, Account__c, Service__c, Date_Completed__c, Date_Read__c, NPS_Rating__c, User_Read__c from Tour_Evaluation__c where Service__c in : listService];
                   System.Debug(listTE);
                    
                   if(listTE.size() == 0){
                       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Info,'There is no Records'));
                       listTE = null;
                       listTEHS = null;
                       listTEL = null;
                   }
                   else{
                       listTEHS = new list <Tour_Evaluation_Historical_Summary__c>();
                       listTEHS = [Select Id, Account_Name__c, Agency_Name__c, Evaluation_Email_Address__c, Status__c, Error__c, Trip_Code__c, Date_Sent__c, Tour_Evaluation__c, Resent_By__c from Tour_Evaluation_Historical_Summary__c where Tour_Evaluation__c in : listTE];
                   
                       listTEL = new list <Tour_Evaluation_Leader__c>();
                       listTEL = [Select Id, Tour_Evaluation__c, Account__c, CEO_Name__c, CEO_Communication__c, CEO_Enthusiasm__c, CEO_ID__c, CEO_Insight__c, CEO_Local_Knowledge__c, CEO_Management__c, CEO_Professionalism__c, Trip_Code__c from Tour_Evaluation_Leader__c where Tour_Evaluation__c in: listTE];
                   }
               	}else{
               		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter a valid Date Format: yyyy-mm-dd'));
               	} 
                    
               }
               
               //Traveller Name
               if(SearchCriteria == 'TravellerName'){
               	if(textData.Trim().length() < 2){
               			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter at least two characters!'));
           			}else{
                   accountName = textData;
                   
                   List <Account> listAccount = new List <Account>();
                   String query = 'Select Id from Account where name LIKE \'%'+accountName+'%\' limit 50000';
                   listAccount = database.query(query);
                   
                   System.Debug(listAccount);
                   
                   listTE = new list <Tour_Evaluation__c>();
                   listTE = [Select Id, Name, Account__c, Service__c, Date_Completed__c, Date_Read__c, NPS_Rating__c, User_Read__c from Tour_Evaluation__c where Account__c in : listAccount];
                   System.Debug(listTE);
                    
                   if(listTE.size() == 0){
                       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Info,'There is no Records'));
                       listTE = null;
                       listTEHS = null;
                       listTEL = null;
                   }
                   else{
                       listTEHS = new list <Tour_Evaluation_Historical_Summary__c>();
                       listTEHS = [Select Id, Account_Name__c, Agency_Name__c, Evaluation_Email_Address__c, Status__c, Error__c, Trip_Code__c, Date_Sent__c, Tour_Evaluation__c, Resent_By__c from Tour_Evaluation_Historical_Summary__c where Tour_Evaluation__c in : listTE];
                   
                       listTEL = new list <Tour_Evaluation_Leader__c>();
                       listTEL = [Select Id, Tour_Evaluation__c, Account__c, CEO_Name__c, CEO_Communication__c, CEO_Enthusiasm__c, CEO_ID__c, CEO_Insight__c, CEO_Local_Knowledge__c, CEO_Management__c, CEO_Professionalism__c, Trip_Code__c from Tour_Evaluation_Leader__c where Tour_Evaluation__c in: listTE];
                   }
               	} 
               }    
               
               //Service Name
               if(SearchCriteria == 'ServiceName'){
               	if(textData.Trim().length() < 2){
               			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter at least two characters!'));
           			}else{
                   serviceName = textData;
                   
                   List <Service__c> listService = new list <Service__c>();
                   String query = 'Select Id from Service__c where name LIKE \'%'+serviceName+'%\' limit 50000';
                   listService = Database.query(query);
                   
                   listTE = new list <Tour_Evaluation__c>();
                   listTE = [Select Id, Name, Account__c, Service__c, Date_Completed__c, Date_Read__c, NPS_Rating__c, User_Read__c from Tour_Evaluation__c where Service__c in : listService];
                   System.Debug(listTE);
                    
                   if(listTE.size() == 0){
                       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Info,'There is no Records'));
                       listTE = null;
                       listTEHS = null;
                       listTEL = null;
                   }
                   else{
                       listTEHS = new list <Tour_Evaluation_Historical_Summary__c>();
                       listTEHS = [Select Id, Account_Name__c, Agency_Name__c, Evaluation_Email_Address__c, Status__c, Error__c, Trip_Code__c, Date_Sent__c, Tour_Evaluation__c, Resent_By__c from Tour_Evaluation_Historical_Summary__c where Tour_Evaluation__c in : listTE];
                   
                       listTEL = new list <Tour_Evaluation_Leader__c>();
                       listTEL = [Select Id, Tour_Evaluation__c, Account__c, CEO_Name__c, CEO_Communication__c, CEO_Enthusiasm__c, CEO_ID__c, CEO_Insight__c, CEO_Local_Knowledge__c, CEO_Management__c, CEO_Professionalism__c, Trip_Code__c from Tour_Evaluation_Leader__c where Tour_Evaluation__c in: listTE];
                   }
               	}
               }      
                   
               //Region
               if(SearchCriteria == 'Region'){
               	if(textData.Trim().length() < 2){
               			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter at least two characters!'));
           			}else{
                   region = textData;
                   
                   listTE = [Select Id, Name, Account__c, Service__c, Date_Completed__c, Date_Read__c, NPS_Rating__c, User_Read__c from Tour_Evaluation__c where Region__c =: region];
                   System.Debug(listTE);
                    
                   if(listTE.size() == 0){
                       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Info,'There is no Records'));
                       listTE = null;
                       listTEHS = null;
                       listTEL = null;
                   }
                   else{
                       listTEHS = new list <Tour_Evaluation_Historical_Summary__c>();
                       listTEHS = [Select Id, Account_Name__c, Agency_Name__c, Evaluation_Email_Address__c, Status__c, Error__c, Trip_Code__c, Date_Sent__c, Tour_Evaluation__c, Resent_By__c from Tour_Evaluation_Historical_Summary__c where Tour_Evaluation__c in : listTE];
                   
                       listTEL = new list <Tour_Evaluation_Leader__c>();
                       listTEL = [Select Id, Tour_Evaluation__c, Account__c, CEO_Name__c, CEO_Communication__c, CEO_Enthusiasm__c, CEO_ID__c, CEO_Insight__c, CEO_Local_Knowledge__c, CEO_Management__c, CEO_Professionalism__c, Trip_Code__c from Tour_Evaluation_Leader__c where Tour_Evaluation__c in: listTE];
                   }
               	}    
               }
                   
               //Booking Number      
               if(SearchCriteria == 'BookingNumber'){
                   if(textData.Trim().length() < 2){
               			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter at least two characters!'));
           			}else{
                   bookingNumber = textData;
                   
                   //get the booking
                   List <Booking__c> listBooking = [Select Id from Booking__c where Name =: BookingNumber];
                   System.Debug(listBooking);
                   
                   //get the Services
                   List <Service__c> listService = [Select Id, (Select Id from Tour_Evaluations__r) from Service__c where Booking__c in: listBooking];
                   System.Debug(listService);
                   
                   List <String> listStrTourEvalId = new List <String>();
                   
                   for(Service__c service : listService){
                       for(Tour_Evaluation__c te : service.Tour_Evaluations__r){
                           listStrTourEvalId.add(te.Id);
                       }
                   }
                  
                   listTE = [Select Id, Name, Account__c, Service__c, Date_Completed__c, Date_Read__c, NPS_Rating__c, User_Read__c from Tour_Evaluation__c where Id in: listStrTourEvalId];
                   System.Debug(listTE);
                    
                   if(listTE.size() == 0){
                       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Info,'There is no Records'));
                       listTE = null;
                       listTEHS = null;
                       listTEL = null;
                   }
                   else{
                       listTEHS = new list <Tour_Evaluation_Historical_Summary__c>();
                       listTEHS = [Select Id, Account_Name__c, Agency_Name__c, Evaluation_Email_Address__c, Status__c, Error__c, Trip_Code__c, Date_Sent__c, Tour_Evaluation__c, Resent_By__c from Tour_Evaluation_Historical_Summary__c where Tour_Evaluation__c in : listTE];
                   
                       listTEL = new list <Tour_Evaluation_Leader__c>();
                       listTEL = [Select Id, Tour_Evaluation__c, Account__c, CEO_Name__c, CEO_Communication__c, CEO_Enthusiasm__c, CEO_ID__c, CEO_Insight__c, CEO_Local_Knowledge__c, CEO_Management__c, CEO_Professionalism__c, Trip_Code__c from Tour_Evaluation_Leader__c where Tour_Evaluation__c in: listTE];
                   }
                   }
               }
        }
 }
 
 private boolean isValidDate(String dateText){
 	if(Pattern.matches('[0-9]{4}[-]{1}[0-9]{2}[-]{1}[0-9]{2}',dateText)){
 		try{
 			Date validDate = date.valueOf(dateText);
 			return true;
 		}catch(Exception e){
 			return false;
 		}
 	}
 	return false;	 
 }
 
    /* Public PageReference previous(){
         pageNumber ++;
        
         queryResult();
         return null;
     }
     
     Public PageReference next(){
         pageNumber --;
         
         if(pageNumber < 0)
             return null;
         else
             queryResult();
             
         return null;
     }
     
     Public void 
   */  
     
}