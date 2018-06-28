/*
 * This class Tests the Evals Delete Class
 */
@isTest(SEEALLDATA = true)
 Public Class TestEvalsDeletePart1{
     static testmethod void EvalsDelete(){
         
         integer i =0;
         //Agency
         Account acc = new Account(Name='Test', BillingState='ON', BillingCountry = 'Canada');
         insert acc;
         
         //Agent
         Contact con = New Contact(LastName='Subodh', Account=acc);
         insert con;
         
         //Travelers
         list <Account> listTravelers = new list <Account>();
         for(i =0; i <5; i++){
             Account t = new Account(LastName = 'Traveller'+i, Salutation='Mr.');
             listTravelers.add(t);
         }
         insert listTravelers;
         
         //Booking
         Booking__c booking = new Booking__c(Agent__c = con.Id);
         insert booking;
         
         //Services
         list <Service__c> listService = new list <Service__c>();
         for(i=0; i <5; i++){
             Service__c service = new Service__c(Booking__c = booking.Id);
             listService.add(service);
         }
         insert listService;
         
         //Tour Evals
         list <Tour_Evaluation__c> listTourEvals = new list <Tour_Evaluation__c>();
         List <Account> listAccounts = [Select Id from Account Limit 100];
         List <Service__c> listServices = [Select Id from Service__c Limit 100];
         for(i=0; i<5; i++){
             Tour_Evaluation__c tourEval = new Tour_Evaluation__c(Account__c = listAccounts[i].Id, Service__c = listService[i].Id);
             System.Debug(tourEval.SumEvaluationScores__c);
             listTourEvals.add(tourEval);
         }
         System.Debug(listTourEVals.size());
         insert listTourEvals;
         
         //Tour Eval Leaders
         List <Tour_Evaluation_Leader__c> listTourEvalLeader = new list <Tour_Evaluation_Leader__c>();
         for(i=0; i<5; i++){
             Tour_Evaluation_Leader__c tel = new Tour_Evaluation_Leader__c(Tour_Evaluation__c = listTourEvals[i].Id);
             System.Debug(tel.CEO_Overall_Average__c);
             listTourEvalLeader.add(tel);
         }
         insert listTourEvalLeader;
         
         Test.startTest();
             EvalsDelete ed = new EvalsDelete();
             ed.DeleteEvalLeaders();
         Test.stopTest();
         
         /* Assert */
         /*List <Tour_Evaluation_Leader__c> listTourEvalLeaderAssert = [Select Id from Tour_Evaluation_Leader__c where CEO_Overall_Average__c = NULL Limit 9000];
         System.AssertEquals(listTourEvalLeaderAssert.size(), 0);*/
     }     
 }