trigger CreateCalender on WorkOrder__c ( after insert,after update) {
    List<Calendar__c> calendar = new List<Calendar__C>();
    List<Calendar__c> Calendarlist = new list<Calendar__c>();
     List<Calendar__c> CalendarlistInsert = new list<Calendar__c>();
    List<Calendar__c> Calendarlistnew = new list<Calendar__c>();
    List<Calendar__c> Calendarlistnew1 = new list<Calendar__c>();
    
    //---------------- code for is insert-----------
        if(Trigger.isInsert){
            for(WorkOrder__c wrkodr : Trigger.new){    
                Integer  nodays = wrkodr.startDate__c.daysBetween(wrkodr.EndDate__c);
                System.debug('######'+nodays);
                for(Integer i=0;i<=nodays;i++){  
                System.debug('######'+i);     
                System.debug('######'+wrkodr.startDate__c.adddays(i));       
                CalendarlistInsert.add(new Calendar__c(date__c=wrkodr.startDate__c.adddays(i),WorkOrder__c=wrkodr.id));       
                }             
            }      
        }
     //---------------- code for is update-----------
    if(trigger.isupdate){
        for(WorkOrder__c wrkodr :trigger.new){        
        
        //---------if start date is same and end date different-------------
        
            if(Trigger.oldmap.get(wrkodr.id).startdate__c == wrkodr.startdate__c ){
                Integer  nodays = Trigger.oldmap.get(wrkodr.id).endDate__c.daysBetween(wrkodr.EndDate__c); 
              // Integer  nodays = wrkodr.startdate__c.daysBetween(wrkodr.EndDate__c); 
                //System.debug('##@@@@@@@@@@@@@@@@@@@update'+nodays );            
                for(Integer i=1;i<=nodays;i++){
                Calendarlist.add(new Calendar__c(date__c=Trigger.oldmap.get(wrkodr.id).endDate__c.adddays(i),WorkOrder__c=wrkodr.id));       
                } 
              }
      //---------if start date is differentand enddate same---------
            if(Trigger.oldmap.get(wrkodr.id).startdate__c != wrkodr.startdate__c ){
            
               // Integer  nodays1 = wrkodr.startdate__C.daysBetween(Trigger.oldmap.get(wrkodr.id).startdate__C); 
                Integer  nodays1 = wrkodr.startdate__C.daysBetween(Trigger.oldmap.get(wrkodr.id).startdate__C); 
               // System.debug('##@@@@@@@@@@@@@@@@@@@update'+nodays1);            
                for(Integer i=1;i<=nodays1;i++){
                    Calendarlist.add(new Calendar__c(date__c=Trigger.oldmap.get(wrkodr.id).startDate__c.adddays(-i),WorkOrder__c=wrkodr.id));       
                } 
              }
           
           // -------------------------if both the date will be change---------------------------
            
            if(Trigger.oldmap.get(wrkodr.id).startDate__c !=wrkodr.startDate__c && Trigger.oldmap.get(wrkodr.id).enddate__c != wrkodr.enddate__c){
               Calendarlist.clear();
               Calendarlistnew.clear();
               
               
             List<Calendar__c> candel =[select lightingprefix__Date__c,lightingprefix__WorkOrder__r.id from lightingprefix__Calendar__c where lightingprefix__WorkOrder__r.id=:wrkodr.id];
                delete candel;
                
                Integer newdays = wrkodr.startDate__c.daysBetween(wrkodr.enddate__c);
                System.debug('********************************************'+newdays);
                for(Integer i=0;i<=newdays;i++){
                    Calendarlistnew.add(new Calendar__c(date__c=wrkodr.startDate__c.adddays(i),WorkOrder__c=wrkodr.id)); 
                
                }
                
                
            
     } 
             
             
             
         // ------------------delete code when end date will be  change --------------------------
         
            if(wrkodr.enddate__c<Trigger.oldmap.get(wrkodr.id).Enddate__C){
               // Calendarlistnew.clear();
                 Integer restdate = wrkodr.enddate__c.daysBetween(Trigger.oldmap.get(wrkodr.id).enddate__c);
                 System.debug('********************restdate'+restdate);   
                 List<Calendar__c> can =[select id,lightingprefix__workorder__r.id from lightingprefix__Calendar__c where lightingprefix__workorder__r.id=:wrkodr.id Order BY id DESC limit : restdate];
                 //System.debug('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%candate'+can);
                 delete can;             
              }
            
           // ------------------delete code when end Start date will be change --------------------------
           
           if(wrkodr.startdate__c>Trigger.oldmap.get(wrkodr.id).startdate__c){ 
              
             Integer restdate1 = Trigger.oldmap.get(wrkodr.id).startdate__c.daysBetween(wrkodr.startdate__c);
             System.debug('********************restdate'+restdate1);   
             List<Calendar__c> can1 =[select id,lightingprefix__workorder__r.id from lightingprefix__Calendar__c where lightingprefix__workorder__r.id=:wrkodr.id  limit : restdate1];
            /// System.debug('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%candate'+can1);
             delete can1;
          }
//-------------------------------------------------------------------------------------------------------------------------
        
         
         
         
//   -------------------------------------------------------------------------------------------------------------------------
          
        }
     }
    if(Calendarlist.size()>0){
        
        insert Calendarlist;
    }
    if(Calendarlistnew.size()>0){
        system.debug('----------------------------------->>>>'+Calendarlistnew.size());
        insert Calendarlistnew;
    }
    if(CalendarlistInsert.size()>0){
        
       insert  CalendarlistInsert;
    }
    if(Calendarlistnew1.size()>0){
        
       insert Calendarlistnew1;
    }
    
    
    
}