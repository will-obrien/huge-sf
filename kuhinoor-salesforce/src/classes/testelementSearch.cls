/*
* Description : 
*/
@isTest
Public Class testelementSearch{
    Static testMethod Void demo(){
    
        elementSearch ele = new elementSearch();
        ele.dateType='Drawing';
        DateTime dt = system.now();
        Date dat = dt.date();
        ele.finddate=dat.format();
        
        lightingprefix__Job__c job = new lightingprefix__Job__c();
        insert job;
        
        lightingprefix__Element__c e = new lightingprefix__Element__c();
        e.lightingprefix__DrawingDate__c=system.today();
        e.lightingprefix__Production_date__c=system.today();
        e.lightingprefix__Installation_date__c=system.today();
        e.lightingprefix__job__c=job.id;
        insert e;
        
        lightingprefix__Job__c jb = new lightingprefix__Job__c();        
        insert jb;
        
        ele.go();        
          
        lightingprefix__Element__c e1 = new lightingprefix__Element__c();
        e1.lightingprefix__DrawingDate__c=system.today();
        e1.lightingprefix__Production_date__c=system.today();
        e1.lightingprefix__Installation_date__c=system.today();
        e1.lightingprefix__job__c=job.id;
        insert e1;
        
        lightingprefix__Job__c jb2 = new lightingprefix__Job__c();        
        insert jb2;
        
        ele.fillpopup();
        ele.savechanges();
    }
}