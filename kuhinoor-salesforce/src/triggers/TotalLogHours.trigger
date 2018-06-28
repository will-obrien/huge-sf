trigger TotalLogHours  on Employee__c (after update ) {
    set<id> ids = new set<id>();
    list<Employee__c > empHoueTotal = new list<Employee__c >();
    for(Employee__c  Emp : Trigger.new){
        ids.add(Emp.id);
    }
    AggregateResult[] HoursSum =     [SELECT  sum(lightingprefix__Hours__c) FROM lightingprefix__Working_Hours__c where lightingprefix__Name__c =: ids];
     for(Employee__c  Emp : Trigger.new){
          Emp.count__c = Decimal.valueOf(HoursSum.size()) ;
          system.debug('@@@@@@@@@@'+ Emp.count__c);
          empHoueTotal .add(emp);
    }
    Update empHoueTotal ;
}