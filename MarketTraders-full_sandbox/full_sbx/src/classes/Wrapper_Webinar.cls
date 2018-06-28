public class Wrapper_Webinar{
    
    public Webinar__c webinar {get;set;}
    public integer attended {get;set;}
    public integer notAttended {get;set;}

    public Wrapper_Webinar(Webinar__c webinar){
    	this.webinar = webinar;
        this.attended = 0;
        this.notAttended = 0;
    }
    public integer getRegistered(){
        return this.attended + this.notAttended;
    }
        
}