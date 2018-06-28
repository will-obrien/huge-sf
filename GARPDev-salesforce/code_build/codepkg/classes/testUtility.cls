/**
This is utility class which provides methods to create instances of objects for test classes.

**/
@isTest
public class testUtility 
{
    // method to create exam record
    public Static Site__c createSite()
    {
        //Create a Site for test
        Site__c s = new Site__c(name='test site');
        return s;    
    }  
    
    // method to create venue record
    public Static Venue__c createVenue(Site__c site)
    {
        //Create a Site for test
        Venue__c v = new Venue__c(name = 'Test Venue',Site__c = site.id,Active__c = TRUE,hasSeatsAssigned__c = true );
        return v ;    
    } 
    
    // method to create room record
    public Static Room__c createRoom(Venue__c venue)
    {
        //Create a Site for test
        Room__c r = new Room__c(name = 'Test Room',Capacity__c = 5,Venue__c = venue.id );
        return r ;
    }          
    
    // method to create exam record
    public Static Exam__c createExam()
    {
        // Create an Exam for test
        Exam__c e = new Exam__c(
        name = 'test exam name',
        Exam_Date__c = date.today(),
        Last_Date_For_Early_Registration__c = date.today()-5,
        Last_Date_For_Late_Registration__c = date.today()-3,
        Last_Date_For_Standard_Registration__c = date.today()-4
       ) ;
        return e ;
        
        Exam__c e1 = new Exam__c(
        name = 'exam name',
        Exam_Date__c = date.today(),
        Last_Date_For_Early_Registration__c = date.today()-5,
        Last_Date_For_Late_Registration__c = date.today()-3,
        Last_Date_For_Standard_Registration__c = date.today()-4
      
       ) ;
        return e1 ;
    }
    
    // method to create exam site record
    public Static Exam_Sites__c createExamSite(Exam__c ex,Site__c s)
    {
        Exam_Sites__c es = new Exam_Sites__c(
        name = 'test exam site',
        Exam__c = ex.id, 
        Site__c = s.id) ;
        return es ;
        
        
        Exam_Sites__c es1 = new Exam_Sites__c(
        name = ' exam test site',
        Exam__c = ex.id, 
        Site__c = s.id) ;
        return es1 ;
    }         
}