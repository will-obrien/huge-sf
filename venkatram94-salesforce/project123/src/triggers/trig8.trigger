trigger trig8 on Opportunity (after insert, after update) {
    if(trigger.isafter){
    for(Opportunity o :trigger.new){
        Date d=o.closedate;
        d=d+30;
        
    }
    }
}